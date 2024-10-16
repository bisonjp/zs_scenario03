################################################################################
# AWSの変数定義
################################################################################
variable "aws_region" {
  type        = string
  description = "AWSのリージョン"
  default     = "ap-northeast-1"
}

variable "aws_vpc_name" {
  description = "VPCの名前"
  type        = string
}

variable "aws_vpc_cidr" {
  description = "VPCで使用するアドレス帯"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_pub_subnet_cidr" {
  description = "AWSのパブリックサブネットで使用するアドレス帯"
  type        = string
  default     = "10.0.0.0/24"
}

variable "aws_pri1_subnet_cidr" {
  description = "AWSのプライベートサブネット１で使用するアドレス帯"
  type        = string
  default     = "10.0.1.0/24"
}

variable "aws_pri2_subnet_cidr" {
  description = "AWSのプライベートサブネット2で使用するアドレス帯"
  type        = string
  default     = "10.0.2.0/24"
}

variable "aws_az1_name" {
  description = "Availability zone"
  type        = string
  default     = "ap-northeast-1a"
}

variable "aws_instance_key" {
  description = "インスタンス接続用のシークレットキー名"
  type        = string
}

variable "aws_win_ami" {
  description = "Windowsのami"
  type        = string
  default     = "ami-0f36f4f3d34a4df19"
}

variable "aws_win_instance_type" {
  description = "Windowsのinstance type"
  type        = string
  default     = "t3.medium"
}

variable "aws_ac_ami" {
  description = "App Connectorのami"
  type        = string
  default     = "ami-05b60713705a935c2"
}

variable "aws_ac_instance_type" {
  description = "App Connectorのinstance type"
  type        = string
  default     = "t3.medium"
}

variable "aws_cc_ami" {
  description = "Cloud Connectorのami"
  type        = string
  default     = "ami-09db530e8a9188750"
}

variable "aws_cc_instance_type" {
  description = "Cloud Connectorのinstance type"
  type        = string
  default     = "t3.medium"
}

variable "aws_ac_provision_key" {
  description = "AWS App Connector用のProvisioning Key"
  type        = string
}
################################################################################
# Azureの変数定義
################################################################################
variable "azure_region" {
  type        = string
  description = "Azureのリージョン"
  default     = "japaneast"
}

variable "azure_rg_name" {
  description = "Azure Resource Groupの名前"
  type        = string
}

variable "azure_subscription_id" {
  type        = string
  description = "AzureのサブスクリプションID"
  sensitive   = true
}

variable "azure_tenant_id" {
  type        = string
  description = "AzureのテナントID"
  sensitive   = true
}

variable "azure_client_id" {
  type        = string
  description = "AzureのクライアントID"
  sensitive   = true
}

variable "azure_client_secret" {
  type        = string
  description = "Azureのクライアントシークレット"
  sensitive   = true
}

variable "azure_vnet_cidr" {
  description = "Azure vNETで使用するアドレス帯"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azure_pub_subnet_cidr" {
  description = "パブリックサブネットで使用するアドレス帯"
  type        = string
  default     = "10.0.0.0/24"
}

variable "azure_pri1_subnet_cidr" {
  description = "プライベートサブネット１で使用するアドレス帯"
  type        = string
  default     = "10.0.1.0/24"
}

variable "azure_pri2_subnet_cidr" {
  description = "プライベートサブネット2で使用するアドレス帯"
  type        = string
  default     = "10.0.2.0/24"
}

variable "azure_tls_key_algorithm" {
  type        = string
  description = "algorithm for tls_private_key resource"
  default     = "RSA"
}

variable "azure_client_image_publisher" {
  description = "AzureにデプロイするWindowsクライアントのイメージ発行元"
  type        = string
  default     = "microsoftwindowsdesktop"
}

variable "azure_client_image_offer" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Offer"
  default     = "windows-10"
}

variable "azure_client_image_sku" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image SKU"
  default     = "win10-22h2-pro"
}

variable "azure_client_image_version" {
  type        = string
  description = "Azure Marketplace CIS CentOS Image Version"
  default     = "latest"
}

variable "azure_ac_provision_key" {
  description = "AzureにデプロイするApp Connectorのプロビジョニングキー"
  type        = string
}

variable "azure_acvm_instance_type" {
  description = "AzureにデプロイするApp Connectorのインスタンスタイプ"
  type        = string
  default     = "Standard_D4s_v3"
  validation {
    condition = (
      var.azure_acvm_instance_type == "Standard_D4s_v3" ||
      var.azure_acvm_instance_type == "Standard_F4s_v2"
    )
    error_message = "Input acvm_instance_type must be set to an approved vm size."
  }
}

variable "azure_ac_username" {
  type        = string
  description = "Default App Connector admin/root username"
  default     = "zsroot"
}

variable "azure_acvm_image_publisher" {
  description = "AzureにデプロイするApp Connectorのイメージ発行元"
  type        = string
  default     = "zscaler"
}

variable "azure_acvm_image_offer" {
  type        = string
  description = "Azure Marketplace Zscaler App Connector Image Offer"
  default     = "zscaler-private-access"
}

variable "azure_acvm_image_sku" {
  type        = string
  description = "Azure Marketplace Zscaler App Connector Image SKU"
  default     = "zpa-con-azure"
}

variable "azure_acvm_image_version" {
  type        = string
  description = "Azure Marketplace App Connector Image Version"
  default     = "latest"
}
################################################################################
# ZPAの変数定義
################################################################################
variable "zpa_client_id" {
  type        = string
  description = "Zscaler Private Access Client ID"
  sensitive   = true
}

variable "zpa_client_secret" {
  type        = string
  description = "Zscaler Private Access Secret ID"
  sensitive   = true
}

variable "zpa_customer_id" {
  type        = string
  description = "Zscaler Private Access Tenant ID"
}

variable "azure_ac_group" {
  type        = string
  description = "Azure用App Connector Groupの名前"
}

variable "aws_ac_group" {
  type        = string
  description = "AWS用のApp Connector Groupの名前"
}

variable "name_prefix" {
  type        = string
  description = "The name prefix for all your resources"
  default     = "zscc"
  validation {
    condition     = length(var.name_prefix) <= 12
    error_message = "Variable name_prefix must be 12 or less characters."
  }
}

variable "cc_callhome_enabled" {
  type        = bool
  description = "determine whether or not to create the cc-callhome-policy IAM Policy and attach it to the CC IAM Role"
  default     = true
}

variable "cc_vm_prov_url" {
  type        = string
  description = "Zscaler Cloud Connector Provisioning URL"
}

variable "aws_secret_name" {
  type        = string
  description = "AWS Secrets Manager Secret Name for Cloud Connector provisioning"
}

variable "http_probe_port" {
  type        = number
  description = "Port number for Cloud Connector cloud init to enable listener port for HTTP probe from GWLB Target Group"
  default     = 50000
  validation {
    condition = (
      tonumber(var.http_probe_port) == 80 ||
      (tonumber(var.http_probe_port) >= 1024 && tonumber(var.http_probe_port) <= 65535)
    )
    error_message = "Input http_probe_port must be set to a single value of 80 or any number between 1024-65535."
  }
}
