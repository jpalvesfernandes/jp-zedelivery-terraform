variable "region" {
  description = "AWS Region for the VPC"
  default     = "us-east-1"
}

variable "cluster-name" {
  type        = string
  description = "The name of AWS ECS cluster"
  default     = "ze"
}

variable "app-name" {
  type        = string
  description = "The name of the Application"
  default     = "breja"
}

variable "container-name" {
  description = "Container app name"
  default     = "breja"
}

variable "desired-tasks" {
  description = "Number of containers desired to run app task"
  default     = 2
}

variable "min-tasks" {
  description = "Minimum"
  default     = 2
}

variable "max-tasks" {
  description = "Maximum"
  default     = 4
}

variable "cpu-scale-up" {
  description = "CPU % to Scale Up the number of containers"
  default     = 80
}

variable "cpu-scale-down" {
  description = "CPU % to Scale Down the number of containers"
  default     = 30
}

variable "desired-task-cpu" {
  description = "Desired CPU to run your tasks"
  default     = "256"
}

variable "desired-task-memory" {
  description = "Desired memory to run your tasks"
  default     = "512"
}

variable "deployment-configuration" {
  description = "AWS Codedeploy deployment configuration"
  default     = "CodeDeployDefault.ECSCanary10Percent5Minutes"
}


###### GITHUB OPTIONS  ######
variable "git_repository_owner" {
  description = "Github Repository Owner"
}

variable "git_repository_name" {
  description = "Project name on Github"
}

variable "git_repository_branch" {
  description = "Github Project Branch"
}

variable "github_token" {
  description = "Github Token"
}