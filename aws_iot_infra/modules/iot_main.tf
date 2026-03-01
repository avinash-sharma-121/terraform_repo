
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

resource "aws_iot_thing_group_membership" "things_things_group_membership" {
    for_each = local.devices
    thing_name = each.key
    thing_group_name = aws_iot_thing_group.thing_group.name
}

resource "aws_iot_policy" "pubsub" {
  name   = var.iot_policy_name
  policy = var.iot_policy_json
}

resource "aws_iot_certificate" "cert" {
  active = true
  csr    = file(var.csr_file_path)

  lifecycle {
    create_before_destroy = true
  }
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


resource "awscc_iot_topic_rule" "rule" {
  rule_name          = var.iot_topic_rule_name
  topic_rule_payload = var.iot_topic_rule_payload
}

