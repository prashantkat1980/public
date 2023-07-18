variable "ecr_name"{
    type = string
    description = "repository name"    
}

variable "vpc_name"{
    type = string
    description = "vpc name"
    default = "vpc-main"
}

variable "environment"{
    type = string
    description = "Env name"

}


