terraform {
  required_version = ">= 0.14"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Simple example resource that creates a local file
resource "local_file" "deployment_info" {
  content  = <<EOF
Deployment Information
=====================
Deployed at: ${timestamp()}
Environment: production
Application: CI/CD Practice App
EOF
  filename = "${path.module}/deployment-info.txt"
}

# Example null resource for demonstration
resource "null_resource" "example" {
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = "echo 'Terraform deployment completed at ${timestamp()}'"
  }
}

output "deployment_file" {
  value = local_file.deployment_info.filename
}

output "deployment_time" {
  value = timestamp()
}