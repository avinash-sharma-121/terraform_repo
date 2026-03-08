# This Terraform configuration sets up an AWS IoT Core infrastructure for a project named "LHM_Rack". It includes the creation of an IoT thing group, IoT devices, an IoT policy, and an IoT topic rule that sends data to AWS SiteWise.

module "lhm_rack_iot_core" {
  source = "./modules/iot_core"
  iot_thing_group   = var.iot_thing_group
  environment = var.environment
  device_names = var.device_names
  csr_file_path = local.csr_file_path
  
  # Variables for IoT policy
  iot_policy_name = var.iot_policy_name
  iot_policy_json = local.iot_policy_json
  
  # Variables for IoT topic rule
  iot_topic_rule_name = var.iot_topic_rule_name
  iot_topic_rule_payload = local.topic_rule_payload
}

module "lhm_rack_sitewise" {
  source = "./modules/sitewise"
  asset_model_name = var.asset_model_name
  environment = var.environment
  device_names = var.device_names
}


output "certificate_pem" {
  value     = module.lhm_rack_iot_core.certificate_pem
  sensitive = true
}