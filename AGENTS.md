# Agent Constitution

## I. Safe Refactoring

Adhere to the purest form of refactoring, ensuring that all changes are behavior-preserving.

- Modifications made to the code should not alter its external behavior or functionality.
- Improve the internal structure of the code without affecting how it interacts with users or other systems.
- Objectively assess the need for a `moved` block in Terraform / OpenTofu.
- When assessing Terraform / OpenTofu `moved` blocks, always compare the current branch against the target base using
  `git diff <base>...HEAD` before making conclusions. Do not infer address changes from the current file alone.
- For each changed resource or module block, verify whether `count`, `for_each`, resource names, module names, or module
  nesting changed between the base and `HEAD`.
- Only add `moved` blocks for managed resource or module address changes. Do not add them for data sources.
- If `count` changes from `1` to a conditional expression, verify whether the address remains indexed before adding a
  `moved` block.

## II. Code Quality

Maintain high standards of code quality by following best practices, including:

- Writing clean, readable, and maintainable code.
- Adhering to established coding conventions and style guides.
- Implementing comprehensive testing to ensure code reliability and robustness.
- Regularly reviewing and refactoring code to improve its structure and performance.

## III. Commit Hygiene

Ensure that all commits are well-structured and meaningful:

- Each commit should represent a single logical change or improvement.
- Commit messages should be conventional, clear, concise, and descriptive of the changes made.
- Avoid committing large, unrelated changes in a single commit to maintain a clear project history.
- Do not disable commit signing if it fails, prompt the user to fix the issue instead to maintain security
  and integrity of the commit history.
- Do not disable commit hooks if they fail, prompt the user to fix the issue instead to maintain code quality and consistency.

## IV. Text Formatting

Maintain consistent text formatting across all documentation and code comments:

- Use clear and concise language to enhance readability.
- Adhere to the `.editorconfig` settings for consistent formatting across different editors and IDEs.
- Use tools to automatically format code and documentation according to the project's style guidelines, i.e. Prettier, Black, or `tf fmt`.

## V. Continuous Improvement

Commit to continuous improvement by regularly reviewing and updating this constitution as needed:

- Periodically assess the effectiveness of the guidelines and make adjustments based on feedback and evolving best practices.
- Prompt the user when a change is made that violates the constitution, providing clear guidance on how to correct the issue.
- As new best practices and tools emerge through use, update this constitution to reflect the evolving nature of engineering.

## VI. Tool Use

If a tool returns no output, then use `get_terminal_output` to check for any error messages or logs that may provide insight into the issue. This will help identify and resolve any problems with the tool's execution.

- If terminal output is missing or unclear during a diff-based review, immediately use `get_terminal_output` or rerun the
  command in a retrievable form before proceeding.
