resource "aws_iot_thing_group" "thing_group"{
    name = "${var.iot_thing_group}"
    properties {
    attribute_payload {
      attributes = {
        env = "${var.environment}"  
      }
    }
    description = "This is my thing group"
    }

    tags = {
      terraform = "true"
    }
}

locals {
  devices = toset(var.device_names)
}

resource "aws_iot_thing" "things" {
  for_each = local.devices
  name     = each.key
}

/*
# Create a thing group with a parent group
resource "aws_iot_thing" "child_LHM-Rack_tf" {
    count = 5
    name = "LHM-Rack-${count.index+1}"
   
}
*/

resource "aws_iot_thing_group_membership" "things_things_group_membership" {
    for_each = local.devices
    thing_name = each.key
    thing_group_name = aws_iot_thing_group.thing_group.name
}

/*
resource "aws_iot_policy" "pubsub" {
  name = "PubSubToAnyTopic"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iot:Publish",
        "iot:Receive",
        "iot:PublishRetain"
      ],
      "Resource": [
        "arn:aws:iot:us-west-2:385163247062:topic/sdk/test/java",
        "arn:aws:iot:us-west-2:385163247062:topic/sdk/test/python",
        "arn:aws:iot:us-west-2:385163247062:topic/sdk/test/python/*",
        "arn:aws:iot:us-west-2:385163247062:topic/sdk/test/js",
        "arn:aws:iot:us-west-2:385163247062:topic/robots/LHM-Rack",
        "arn:aws:iot:us-west-2:385163247062:topic/robots/LHM-Rack/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "iot:Subscribe",
      "Resource": [
        "arn:aws:iot:us-west-2:385163247062:topicfilter/sdk/test/java",
        "arn:aws:iot:us-west-2:385163247062:topicfilter/sdk/test/python",
        "arn:aws:iot:us-west-2:385163247062:topicfilter/sdk/test/python/*",
        "arn:aws:iot:us-west-2:385163247062:topicfilter/sdk/test/js",
        "arn:aws:iot:us-west-2:385163247062:topicfilter/robots/LHM-Rack",
        "arn:aws:iot:us-west-2:385163247062:topicfilter/robots/LHM-Rack/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "iot:Connect",
      "Resource": [
        "arn:aws:iot:us-west-2:385163247062:client/sdk-java",
        "arn:aws:iot:us-west-2:385163247062:client/basicPubSub",
        "arn:aws:iot:us-west-2:385163247062:client/*",
        "arn:aws:iot:us-west-2:385163247062:client/sdk-nodejs-*"
      ]
    }
  ]
})
}
*/

resource "aws_iot_policy" "pubsub" {
  name   = "PubSubToAnyTopic"
  policy = var.iot_policy_json
}

resource "aws_iot_certificate" "cert" {
  active = true
  csr    = file(var.csr_file_path)

  lifecycle {
    create_before_destroy = true
  }
}

output "certificate_pem" {
  value = aws_iot_certificate.cert.certificate_pem
  sensitive = true
}

resource "aws_iot_policy_attachment" "att" {
  policy = aws_iot_policy.pubsub.name
  target = aws_iot_certificate.cert.arn
}

resource "aws_iot_thing_principal_attachment" "att" { 
  for_each = local.devices
  principal = aws_iot_certificate.cert.arn
  thing     = each.key
}


resource "awscc_iot_topic_rule" "test_via_tf" {
  rule_name = "test_via_tf"

  topic_rule_payload = {
    sql              = "SELECT * FROM 'robots/LHM-Rack/+'"
    aws_iot_sql_version = "2015-10-08"
    rule_disabled    = false

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
