module "secret_manager" {
  source = "../"

  secrets = [{
    name          = "mysecret"
    description   = "secret description"
    secret_string = "this is the plain text secret"
  }]
}
