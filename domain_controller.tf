module "vm_dc" {
  count = var.deploy_dc ? 1 : 0

  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "~> 0.18.1"

  name                = local.resource_names["vm_domain_controller"]
  resource_group_name = azurerm_resource_group.domain_controller.name
  location            = azurerm_resource_group.domain_controller.location

  tags = var.tags

  os_type                            = "Windows"
  generate_admin_password_or_ssh_key = false
  zone                               = null
  // Must use a SKU with a local temp disk because the data disk is expected to be "Disk2" (// TODO: confirm)
  sku_size     = var.vm_dc_sku
  license_type = "Windows_Server"


  // TODO: Use Key Vault
  admin_password = random_password.vm_dc_admin[0].result
  admin_username = "srvadmin"

  encryption_at_host_enabled = false

  extensions = {
    create_ad_forest = { // TODO: Consider using Machine Configuration instead?
      name                       = "create_ad_forest"
      publisher                  = "Microsoft.PowerShell"
      type                       = "DSC"
      type_handler_version       = "2.83"
      auto_upgrade_minor_version = false // Not supported anyway

      protected_settings = jsonencode({
        configurationArguments = {
          AdminCreds = {
            UserName = "srvadmin"
            Password = random_password.vm_dc_admin[0].result
          }
        }
      })
      settings = jsonencode(
        {
          wmfVersion = "latest"
          configuration = {
            url      = "https://github.com/vbalbarin/azure-quickstart-templates/raw/refs/heads/fix/interface-incorrectly-identified/application-workloads/active-directory/active-directory-new-domain/DSC/CreateADPDC.zip"
            script   = "CreateADPDC.ps1"
            function = "CreateADPDC"
          }
          configurationArguments = {
            DomainName     = var.domain_name
            VirtualNetwork = local.conf_network_resources.vnet_address_space
          }
        }
      )
    }
  }

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    // TODO: Consider using smalldisk image
    sku     = "2022-datacenter-g2"
    version = "latest"
  }

  managed_identities = {
    system_assigned = false
  }

  // The ADDS provisioning requires a second disk
  data_disk_managed_disks = {
    datadisk0 = {
      caching              = "None"
      lun                  = 0
      name                 = "${local.resource_names["vm_domain_controller"]}_datadisk0"
      storage_account_type = "StandardSSD_LRS"
      disk_size_gb         = 10
    }
  }

  // TODO: Check storage profile: use standard SSD LRS

  network_interfaces = {
    network_interface_1 = {
      name                           = "${local.resource_names["vm_domain_controller"]}-nic-01"
      accelerated_networking_enabled = false
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource_id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.virtualnetwork.subnets[local.subnet_names.domain_controller].resource.body.properties.addressPrefixes[0], 4)
        }
      }
    }
  }

  enable_telemetry = var.telemetry_enabled

  // Explicit dependencies required to ensure that the VM can retrieve the DSC script for AD forest creation
  # depends_on = [module.nat_gateway, module.firewall, module.fwpolicy_rulecollectiongroup]
  depends_on = [module.nat_gateway]
}

// Update VNet's DNS server IP to DC IP
// Note: setting DNS IPs here precludes setting them in the VNet module
resource "azurerm_virtual_network_dns_servers" "vnet_dns" {
  count = var.deploy_dc ? 1 : 0

  virtual_network_id = module.virtualnetwork.resource_id
  dns_servers        = [module.vm_dc[0].network_interfaces.network_interface_1.private_ip_address]

  depends_on = [module.vm_dc]
}