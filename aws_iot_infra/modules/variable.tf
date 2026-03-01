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

variable "iot_policy_json" {
  type        = string
  description = "IoT policy JSON document passed from root module"
}