variable "iot_thing_group" {
  type = string
}

variable "environment" {
  type = string
  default = "dev"
}

variable "device_names" {
  type = list(string)
}

variable "csr_file_path" {
  type        = string
  description = "Path to CSR file from root module"
}

# Variables for IoT policy

variable "iot_policy_name" {
  type        = string
  description = "IoT policy name passed from root module"
}

variable "iot_policy_json" {
  type        = string
  description = "IoT policy JSON document passed from root module"
}

# Variables for IoT topic rule
variable "iot_topic_rule_name" {
  type        = string
  description = "Topic rule name passed from root module"
}

variable "iot_topic_rule_payload" {
  type        = any
  description = "Topic rule payload passed from root module"
}