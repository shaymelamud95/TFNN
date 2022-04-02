variable "TFPrefix" {
  description = "The prefix which should be used for all resources connected to the web app from terraform."
  default     = "TF-"
}

variable "DBPrefix" {
  description = "The prefix which should be used for all resources connected to the database."
  default     = "DB-"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "eastus"
}

variable "vm_zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "size" {
  type    = string
  default = "Standard_b1ls"
}

variable "vmcount" {
  description = "The number of vms to creat"
  default     = 3
}
