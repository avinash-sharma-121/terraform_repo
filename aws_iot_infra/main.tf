# This Terraform configuration sets up an AWS IoT Core infrastructure for a project named "LHM_Rack". It includes the creation of an IoT thing group, IoT devices, an IoT policy, and an IoT topic rule that sends data to AWS SiteWise.

module "lhm_rack" {
  source = "./modules/iot_core"
  iot_thing_group   = "LHM_Rack_testing"
  environment = "Dev"
  device_names = [
    "LHM-Rack-1-test",
    "LHM-Rack-2-test"
  ]
  csr_file_path = "${path.root}/cert/csr.pem"
  
  # Variables for IoT policy
  iot_policy_name = "LHM-Rack-Policy-update"
  iot_policy_json = file("${path.root}/iot_policy.json")
  
  # Variables for IoT topic rule
  iot_topic_rule_name = "lhm_rack_topic_rule"
  iot_topic_rule_payload = local.topic_rule_payload
}


locals {
  topic_rule_payload = {
    sql                 = "SELECT * FROM 'robots/LHM-Rack/+'"
    aws_iot_sql_version = "2015-10-08"
    rule_disabled       = false

    actions = [
      {
        iot_site_wise = {
          role_arn = "arn:aws:iam::385163247062:role/CdkStack-sitewiseiotruleingestfromiotserviceroleBFC-oYbi9gSqjadp"

          put_asset_property_value_entries = [
            {
              property_alias = "robots/LHM-Rack/$${topic(3)}"

              property_values = [
                {
                  value = {
                    double_value = "$${temperature_c}"
                  }

                  timestamp = {
                    time_in_seconds = "$${timestamp}"
                  }
                }
              ]
            }
          ]
        }
      }
    ]
  }
}

output "certificate_pem" {
  value     = module.lhm_rack.certificate_pem
  sensitive = true
}