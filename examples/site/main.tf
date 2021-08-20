resource "netbox_dcim_region" "example" {
  name        = "example"
  slug        = "example"
  description = "example description"
}

resource "netbox_tenancy_tenant" "example" {
  name = "example"
  slug = "example"
}

module "example" {
  source = "../../"
  path   = "site.yaml"
  region = netbox_dcim_region.example.id
  tenant = netbox_tenancy_tenant.example.id

}