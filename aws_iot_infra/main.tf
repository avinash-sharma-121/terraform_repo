provider "aws" {
  region = "us-east-1"
}

resource "aws_iot_thing_group" "motors_via_tf"{
    name = "motors_via_tf"

    properties {
    attribute_payload {
      attributes = {
        One = "11111"
        Two = "TwoTwo"
      }
    }
    description = "This is my thing group"
    }

    tags = {
      terraform = "true"
    }
}

# Create a thing group with a parent group
resource "aws_iot_thing" "child_motors_via_tf" {
    count = 4
    name = "motor${count.index+1}_via_tf"
   
}


resource "aws_iot_thing_group_membership" "child_motors_via_tf_membership" {
    count = 4
    thing_name = aws_iot_thing.child_motors_via_tf[count.index].name
    thing_group_name = aws_iot_thing_group.motors_via_tf.name
}

/*
resource "aws_iot_policy" "pubsub" {
  name = "PubSubToAnyTopic"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iot:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
*/

data "aws_iam_policy_document" "pubsub" {
  statement {
    effect    = "Allow"
    actions   = ["iot:*"]
    resources = ["*"]
  }
}

resource "aws_iot_policy" "pubsub" {
  name   = "PubSubToAnyTopic"
  policy = data.aws_iam_policy_document.pubsub.json
}


resource "aws_iot_certificate" "cert" {
  active = true
}


resource "aws_iot_policy_attachment" "att" {
  policy = aws_iot_policy.pubsub.name
  target = aws_iot_certificate.cert.arn
}

resource "aws_iot_thing_principal_attachment" "att" {
  count = 4
  principal = aws_iot_certificate.cert.arn
  thing     = aws_iot_thing.child_motors_via_tf[count.index].name
}


