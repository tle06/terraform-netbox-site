resource "netbox_dcim_region" "example" {
  name = "terraform root region"
  slug = "terraform-root-region"
  description = "description for terraform"
}

resource "netbox_extras_tag" "tag-one" {
  name  = "tag one"
  slug  = "tag-one"
  color = "ff0000"
}

resource "netbox_extras_tag" "tag-two" {
  name  = "tag two"
  slug  = "tag-two"
  color = "ff0000"
}


resource "netbox_tenancy_tenant" "example" {
  name = "test terraform"
  slug = "test-terraform"
}

module "test" {
    source = "../module"
    path = "site.yaml"
    region = netbox_dcim_region.example.id
    tenant = netbox_tenancy_tenant.example.id
    tags = [{
        name = netbox_extras_tag.tag-one.name
        slug = netbox_extras_tag.tag-one.slug},
        {
        name = netbox_extras_tag.tag-two.name
        slug = netbox_extras_tag.tag-two.slug},

        ]
    
}