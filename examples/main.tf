resource "netbox_dcim_region" "example" {
  name = "terraform root region"
  slug = "terraform-root-region"
  description = "description for terraform"
}

resource "netbox_tenancy_tenant" "example" {
  name = "test terraform"
  slug = "test-terraform"
}


resource "netbox_ipam_vlan" "untagged-vlan" {
  name = "untagged vlan"
	vid = 500
	tenant_id = netbox_tenancy_tenant.example.id
}

module "test" {
    source = "../"
    path = "site.yaml"
    region = netbox_dcim_region.example.id
    tenant = netbox_tenancy_tenant.example.id
    
}