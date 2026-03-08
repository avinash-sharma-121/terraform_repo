locals {
  csr_file_path = "${path.root}/cert/csr.pem"
  iot_policy_json = file("${path.root}/iot_policy.json")
}