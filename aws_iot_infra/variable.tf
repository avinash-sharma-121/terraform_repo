######-------------------------------------Common variables-------------------------------------#######


variable "device_names" {
  type = list(string)
  default = [
    "LHM-Rack-1-test",  
    "LHM-Rack-2-test"
  ]
}


######-------------------------------------IoT variables-------------------------------------#######

variable "iot_thing_group" {
  type = string
  default = "LHM-Rack-Thing-Group"
}

variable "environment" {
  type = string
  default = "DEV"
}

/*
variable "csr_file_path" {
  type        = string
  description = "Path to CSR file from root module"
  default = "${path.root}/cert/csr.pem"
}*/


# Variables for IoT policy

variable "iot_policy_name" {
  type        = string
  description = "IoT policy name passed from root module"
  default = "LHM-Rack-Policy"
}
/*
variable "iot_policy_json" {
  type        = string
  description = "IoT policy JSON document passed from root module"
  default = file("${path.root}/iot_policy.json")
}
*/

# Variables for IoT topic rule
variable "iot_topic_rule_name" {
  type        = string
  description = "Topic rule name passed from root module"
  default = "LHM_Rack_Topic_Rule"
}

/*
variable "iot_topic_rule_payload" {
  type        = any
  description = "Topic rule payload passed from root module"
}
*/


#######-------------------------------------Sitewise variables-------------------------------------#######


variable "asset_model_name" {
  type = string
  default = "LHM-Rack-Model"
}
