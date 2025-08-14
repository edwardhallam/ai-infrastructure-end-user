# Configure Proxmox Provider
provider "proxmox" {
  pm_api_url          = "https://${var.proxmox_host}:8006/api2/json"
  pm_api_token_id     = var.proxmox_user
  pm_api_token_secret = var.proxmox_password
  pm_tls_insecure    = true
}

# Create LXC container for LibreChat
resource "proxmox_lxc" "librechat" {
  target_node = var.proxmox_node
  hostname    = var.librechat_container_name
  ostemplate  = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  
  cores   = var.container_cpu_limit
  memory  = var.container_memory_limit
  swap    = var.container_memory_limit / 2
  
  rootfs {
    storage = var.storage_pool
    size    = "${var.container_storage_limit}G"
  }
  
  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = cidrhost(var.network_subnet, 10)
    gw     = var.network_gateway
  }
  
  nameserver = join(" ", var.dns_servers)
  start = true
  tags = ["ai-infrastructure", "librechat"]
}

# Create LXC container for MCP Server
resource "proxmox_lxc" "mcp_server" {
  target_node = var.proxmox_node
  hostname    = var.mcp_server_container_name
  ostemplate  = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  
  cores   = var.container_cpu_limit
  memory  = var.container_memory_limit
  swap    = var.container_memory_limit / 2
  
  rootfs {
    storage = var.storage_pool
    size    = "${var.container_storage_limit}G"
  }
  
  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = cidrhost(var.network_subnet, 11)
    gw     = var.network_gateway
  }
  
  nameserver = join(" ", var.dns_servers)
  start = true
  tags = ["ai-infrastructure", "mcp-server"]
}
