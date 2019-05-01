resource "random_pet" "environment" {
}

variable "environment" {
  type        = "string"
  description = "Name of environment. Used to tag resources."
  default     = "${random_pet.environment.id}"
}

variable "subnet" {
  type        = "string"
  description = "Subnet of environment. Used to partition out the address space. Use a /16 space."
  default     = "15.0.0.0/16"
}
