

module "lhm_rack" {
  source = "./modules"
  iot_thing_group   = "LHM-Rack-testing"
  environment = "Dev"
  device_names = [
    "LHM-Rack-1-test",
    "LHM-Rack-2-test"
  ]
  csr_file_path = "${path.root}/csr.pem"
  iot_policy_json = file("${path.root}/iot_policy.json")
}