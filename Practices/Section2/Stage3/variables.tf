variable "access_key" { }
variable "secret_key" { }
variable "POSTGRES_USER" { }
variable "POSTGRES_DB" { }
variable "POSTGRES_PASSWORD" { }
variable "ips" {
    default = {
        "0" = "10.0.1.100"
        "1" = "10.0.1.101"
    }
}
variable "access_ip"{
    default = "176.119.233.130/32"
    
}