resource "netbox_dcim_region" "example" {
  name = "example"
  slug = "example"
  description = "example description"
}

resource "netbox_tenancy_tenant" "example" {
  name = "example"
  slug = "example"
}


resource "netbox_ipam_vlan" "untagged-vlan" {
  name = "untagged vlan"
	vid = 500
	tenant_id = netbox_tenancy_tenant.example.id
}

module "example" {
    source = "../"
    path = "site.yaml"
    region = netbox_dcim_region.example.id
    tenant = netbox_tenancy_tenant.example.id
    
}