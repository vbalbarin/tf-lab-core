module "analysis_win_vm" {
  count = var.deploy_dm ? 1 : 0

  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "~> 0.18.1"

  name                = local.resource_names["vm_domain_member"]
  resource_group_name = azurerm_resource_group.domain_member.name
  location            = azurerm_resource_group.domain_member.location

  tags = var.tags

  admin_password = random_password.vm_dm_admin[0].result
  admin_username = "srvadmin"

  os_type                            = "Windows"
  sku_size                           = "Standard_D2as_v5"
  zone                               = null
  generate_admin_password_or_ssh_key = false
  encryption_at_host_enabled         = false

  license_type = "Windows_Client"

  extensions = {
    // LATER: Enhance parallelization of deployment by moving the domain join to a separate resource
    // That way the VM deployment can start concurrently with the DC VM deployment and only the
    // domain join has to be held up for the forest creation.
    // TODO: Make conditional on DC deployment
    domain_join = {
      name                    = "domain_join"
      publisher               = "Microsoft.Compute"
      type                    = "JsonADDomainExtension"
      type_handler_version    = "1.3"
      autoUpgradeMinorVersion = true

      settings = jsonencode({
        Name    = var.domain_name
        User    = "${var.domain_netbios_name}\\srvadmin"
        Restart = "true"
        Options = "3"
      })

      protected_settings = jsonencode({
        Password = random_password.vm_dc_admin[0].result
      })
    }
  }

  source_image_reference = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-23h2-ent"
    version   = "latest"
  }

  managed_identities = {
    system_assigned = false
  }

  // LATER: Check storage profile: use standard SSD LRS

  network_interfaces = {
    network_interface_1 = {
      // TODO: Use naming module
      name = "${local.resource_names["vm_domain_member"]}-nic-01"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = module.virtualnetwork.subnets[local.subnet_names.domain_member].resource_id
          private_ip_address_allocation = "Dynamic"
        }
      }
      // HACK: Explicitly setting the DNS server IP when domain-joining
      dns_servers = var.deploy_dc ? [module.vm_dc[0].network_interfaces.network_interface_1.private_ip_address] : []
    }
  }

  enable_telemetry = var.telemetry_enabled

  depends_on = [azurerm_virtual_network_dns_servers.vnet_dns]
}