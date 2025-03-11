variable "key_name" {

}

variable "path_key" {

}

variable "public_key" {
  sensitive = true
}

variable "postgres_username" {

}

variable "postgres_credentials" {
  sensitive = true
  type      = map(string)
}