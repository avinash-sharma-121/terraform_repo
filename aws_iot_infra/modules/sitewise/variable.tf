
variable "asset_model_name" {
  type = string
}

variable "environment" {
  type = string
  default = "dev"
}

variable "device_names" {
  type = list(string)
}