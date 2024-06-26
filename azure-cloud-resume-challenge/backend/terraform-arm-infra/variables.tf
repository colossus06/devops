variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus2"
}


variable "rg" {
  description = "Azure resource group"
  type        = string
  default     = "rgcrctopcug"
}



variable "rgtest" {
  description = "Azure resource group"
  type        = string
  default     = "rgtestcrctopcug"
}


variable "st" {
  description = "Azure storageaccount"
  type        = string
  default     = "stcrctopcug"
}



variable "sttest" {
  description = "Azure storageaccount"
  type        = string
  default     = "sttestcrctopcug"
}

variable "asp" {
  description = "Azure storageaccount"
  type        = string
  default     = "aspcrctopcug"
}

variable "func" {
  description = "Azure storageaccount"
  type        = string
  default     = "funcrctopcug"
}


variable "cosmos" {
  description = "Azure storageaccount"
  type        = string
  default     = "cosmoscrctopcug"
}


variable "appi" {
  description = "Azure storageaccount"
  type        = string
  default     = "appicrctopcug"
}

variable "logic" {
  description = "Azure testlgappp"
  type        = string
  default     = "testlgappp"
}
variable "ag" {
  description = "Azure testlgappp"
  type        = string
  default     = "failedreq"
}
variable "alert" {
  description = "Azure testlgappp"
  type        = string
  default     = "failed_requests_al"
}
variable "stc" {
  description = "Azure testlgappp"
  type        = string
  default     = "stcinfra"
}

variable "cdnp" {
  description = "Azure testlgappp"
  type        = string
  default     = "cdnpcrctopcug"
}


variable "ep" {
  description = "Azure testlgappp"
  type        = string
  default     = "epcrctopcug"
}

variable "funcslot" {
  description = "Azure slot"
  type        = string
  default     = "funccrcstaging"
}


