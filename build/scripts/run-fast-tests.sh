#!/usr/bin/env bash
#
# Runs the fast test tier (static + contract) for every Terraform module that
# ships tests. A module "ships tests" when it contains a `test/` directory or a
# `tests/` directory with `*.tftest.hcl` files.
#
# Static tier:   terraform fmt -check, terraform init -backend=false, validate
# Contract tier: terraform test (mocked-provider plan assertions)
#
# The script requires no cloud credentials and creates no billable resources.
# It exits non-zero if any module fails, so it can be used as a CI gate. Go
# Terratest suites belong to the live tier and are run separately (opt-in), so
# they are intentionally not executed here.

set -uo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

export TF_IN_AUTOMATION=1

failed_modules=()

# Discover module roots that ship tests (parents of a `test` or `tests` dir).
mapfile -t module_dirs < <(
  find . -path '*/modules/*' -type d \( -name test -o -name tests \) -printf '%h\n' \
    | sort -u
)

if [[ ${#module_dirs[@]} -eq 0 ]]; then
  echo "No modules with tests discovered."
  exit 0
fi

run_step() {
  # run_step <module> <description> <command...>
  local module="$1" description="$2"
  shift 2
  echo "  -> ${description}"
  if ! "$@"; then
    echo "  !! ${description} FAILED for ${module}"
    return 1
  fi
}

for module_dir in "${module_dirs[@]}"; do
  module_dir="${module_dir#./}"

  # Skip directories without top-level Terraform configuration.
  if ! compgen -G "${module_dir}/*.tf" > /dev/null; then
    continue
  fi

  echo "=============================================================="
  echo "Fast tier: ${module_dir}"
  echo "=============================================================="

  module_failed=0

  # --- Static tier ---
  run_step "$module_dir" "terraform fmt -check" \
    terraform fmt -check -recursive "$module_dir" || module_failed=1

  run_step "$module_dir" "terraform init -backend=false" \
    terraform -chdir="$module_dir" init -backend=false -input=false -no-color || module_failed=1

  if [[ $module_failed -eq 0 ]]; then
    run_step "$module_dir" "terraform validate" \
      terraform -chdir="$module_dir" validate -no-color || module_failed=1

    # --- Contract tier: terraform test ---
    if compgen -G "${module_dir}/tests/*.tftest.hcl" > /dev/null \
      || compgen -G "${module_dir}/*.tftest.hcl" > /dev/null; then
      run_step "$module_dir" "terraform test" \
        terraform -chdir="$module_dir" test -no-color || module_failed=1
    fi
  fi

  if [[ $module_failed -ne 0 ]]; then
    failed_modules+=("$module_dir")
  fi
done

echo "=============================================================="
if [[ ${#failed_modules[@]} -ne 0 ]]; then
  echo "Fast tier FAILED for: ${failed_modules[*]}"
  exit 1
fi

echo "Fast tier passed for all ${#module_dirs[@]} discovered module(s)."
