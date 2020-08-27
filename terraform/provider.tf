variable "do_token"{}
variable "pub_key"{}
variable "domain_name"{}
variable "kas_password"{}
variable "kas_username"{}
variable "pvt_key"{}
variable "ssh_fingerprint"{}
variable "githubRepo"{}
variable "githubAccessToken"{}

provider "digitalocean" {
  token = var.do_token
}