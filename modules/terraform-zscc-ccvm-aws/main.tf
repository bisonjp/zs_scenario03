################################################################################
# Module VM creation validation
################################################################################
resource "null_resource" "error_checker" {
  count = local.valid_cc_create ? 0 : 1 # 0 means no error is thrown, else throw error
  provisioner "local-exec" {
    command = <<EOF
      echo "Cloud Connector parameters were invalid. No appliances were created. Please check the documentation and cc_instance_size / ccvm_instance_type values that were chosen" >> ${path.root}/errorlog.txt
EOF
  }
}

################################################################################
# Create Cloud Connector VM
################################################################################
resource "aws_instance" "cc_vm" {
  count                       = local.valid_cc_create ? var.cc_count : 0
  ami                         = var.ami_id
  instance_type               = var.ccvm_instance_type
  iam_instance_profile        = element(var.iam_instance_profile, count.index)
#  vpc_security_group_ids      = var.security_group
#  subnet_id                   = var.mgmt_subnet_id
  key_name                    = var.instance_key
#  associate_public_ip_address = false
  user_data                   = base64encode(var.user_data)

  tags = {
    Name = "${var.tag}-cc${count.index}"
    Tag = var.tag
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = var.imdsv2_enabled ? "required" : "optional"
  }
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.cc_vm_nic_index_0[count.index].id
  }
}


################################################################################
# Create Cloud Connector Service Interface for Small CC. 
# This interface becomes LB0 interface for Medium/Large size CCs
################################################################################
resource "aws_network_interface" "cc_vm_nic_index_0" {
  count             = local.valid_cc_create ? var.cc_count : 0
  description       = "cc next hop forwarding interface"
  subnet_id         = var.service_subnet_id
  source_dest_check = false
}

################################################################################
# Create Cloud Connector Mgmt Interface.
################################################################################
resource "aws_network_interface" "cc_vm_nic_index_1" {
  count             = local.valid_cc_create ? var.cc_count : 0
  description       = "cc mgmt interface"
  subnet_id         = var.mgmt_subnet_id
  source_dest_check = false
  private_ips_count = 1
  attachment {
    instance     = aws_instance.cc_vm[count.index].id
    device_index = 1
  }

}


################################################################################
# Create Cloud Connector Service Interface #1 for Medium/Large CC. 
# This resource will not be created for "small" CC instances.
################################################################################
resource "aws_network_interface" "cc_vm_nic_index_2" {
  count             = local.valid_cc_create && var.cc_instance_size != "small" ? var.cc_count : 0
  description       = "CC Service 1 interface"
  subnet_id         = var.service_subnet_id
#  security_groups   = var.service_security_group_id
  source_dest_check = false
  attachment {
    instance     = aws_instance.cc_vm[count.index].id
    device_index = 2
  }

}


################################################################################
# Create Cloud Connector Service Interface #2 for Medium/Large CC. 
# This resource will not be created for "small" CC instances.
################################################################################
resource "aws_network_interface" "cc_vm_nic_index_3" {
  count             = local.valid_cc_create && var.cc_instance_size != "small" ? var.cc_count : 0
  description       = "CC Service 2 interface"
  subnet_id         = var.service_subnet_id
#  security_groups   = var.service_security_group_id
  source_dest_check = false
  attachment {
    instance     = aws_instance.cc_vm[count.index].id
    device_index = 3
  }

}


################################################################################
# Create Cloud Connector Service Interface #3 for Large CC. This resource will 
# not be created for "small" or "medium" CC instances
################################################################################
resource "aws_network_interface" "cc_vm_nic_index_4" {
  count             = local.valid_cc_create && var.cc_instance_size == "large" ? var.cc_count : 0
  description       = "CC Service 3 interface"
  subnet_id         = var.service_subnet_id
#  security_groups   = var.service_security_group_id
  source_dest_check = false
  attachment {
    instance     = aws_instance.cc_vm[count.index].id
    device_index = 4
  }

}
