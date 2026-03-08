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