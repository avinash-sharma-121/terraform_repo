

module "lhm_rack" {
  source = "./modules"
  iot_thing_group   = "LHM-Rack-testing"
  environment = "Dev"
  device_names = [
    "LHM-Rack-1-test",
    "LHM-Rack-2-test"
  ]
  csr_file_path = "${path.root}/csr.pem"
  # Variables for IoT policy
  iot_policy_name = "LHM-Rack-Policy"
  iot_policy_json = file("${path.root}/iot_policy.json")
    # Variables for IoT topic rule
  iot_topic_rule_name = "LHM-Rack-TopicRule"
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