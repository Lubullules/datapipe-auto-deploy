variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "project_name" {
  default     = "test"
  type        = string
  description = "Nom du projet"
}

variable "account_id" {
  type    = string
  default = "257394462879"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "reddit_username" {
  type        = string
  description = "Nom d'utilisateur Reddit"
  default     = "BusinessAd4873"
}

variable "reddit_password" {
  type        = string
  description = "Mot de passe Reddit"
  default     = "magodassearthur123"
  sensitive = true
}

variable "user_agent" {
  type        = string
  description = "User agent pour Reddit"
  default     = "CryptoPostsTest (by /u/BusinessAd4873)"
}

variable "client_id" {
  type        = string
  description = "Client ID pour Reddit"
  default     = "ECL9oz9sGlFbawRB95ZcrA"
}

variable "client_secret" {
  type        = string
  description = "Client secret pour Reddit"
  default     = "DPGGI-B9u-MAbJX_HDG_rtxTfHaLLQ"
  sensitive   = true
}