# Container IP Addresses for Ansible
output "librechat_ip" {
  description = "IP address of the LibreChat container"
  value       = proxmox_lxc.librechat.network[0].ip
}

output "mcp_server_ip" {
  description = "IP address of the MCP server container"
  value       = proxmox_lxc.mcp_server.network[0].ip
}

# Infrastructure Summary
output "infrastructure_summary" {
  description = "Summary of deployed infrastructure"
  value = {
    total_containers = 2
    total_cpu        = var.container_cpu_limit * 2
    total_memory_mb  = var.container_memory_limit * 2
    total_storage_gb = var.container_storage_limit * 2
    containers = {
      librechat     = proxmox_lxc.librechat.hostname
      mcp_server    = proxmox_lxc.mcp_server.hostname
    }
  }
}
