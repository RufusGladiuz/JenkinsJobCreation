variable "do_token"{
  type = "string"
  default = "Digital Ocean API Keey"
}
variable "pub_key"{
  type = "string"
  default = "Directory to public ssh key"
}

variable "pvt_key"{
  type = "string"
  default = "Directory to private ssh key"
}

variable "ssh_fingerprint"{
  type = "string"
  default = "DigitalOcean SSH-Fingerprint"
}

variable "domain_name"{
  type = "string"
  default = "Domain name"
}

variable "kas_username"{
  type = "string"
  default = "Password for Kas login"
}

variable "kas_password"{
  type = "string"
  default = "Password for Kas login"
}

variable "githubRepo"{
  type = "string"
  default = "TODO Application github"
}

variable "githubAccessToken"{
  type = "string"
  default = "Github API-Token"
}

provider "digitalocean" {
  token = var.do_token
}