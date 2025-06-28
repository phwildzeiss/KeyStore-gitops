variable "git_username" {
  type        = string
  description = "Github Username secret"
  sensitive   = true
}

variable "git_token" {
  type        = string
  description = "Github token secret"
  sensitive   = true
}
