# terraform-netbox-site

## Usage

```hcl
resource "netbox_dcim_region" "example" {
  name = "example"
  slug = "example"
  description = "example description"
}

resource "netbox_tenancy_tenant" "example" {
  name = "example"
  slug = "example"
}

module "example" {
    source = "tle06/netbox/site"
    path = "site.yaml"
    region = netbox_dcim_region.example.id
    tenant = netbox_tenancy_tenant.example.id
    
}
```

## Value

```yaml
site:
  name: "Example site 01"
  region: "Barcelona"
  tenant: "Store"
  time_zone: "Europe/Madrid"
  site_id: "S111"
  physical_address: "example of physical address"
  status: "active" #Optional
  facility: "example facility" #Optional
  asn_id: 65000 #Optional
  description: "example description" #Optional
  shipping_address: "example shipping address" #Optional
  latitude: "10.800000" #Optional
  longitude : "11.800000" #Optional
  contact_name: "John doe" #Optional
  contact_phone: "+33734989876" #Optional
  contact_email: "john.doe@example.com" #Optional
  comments: "example comments" #Optional
  racks:
    - name: "BCN-RCK111"
      status: "active" #Optional
      role_id: 1 #Optional
      serial: "example serial" #Optional
      asset_tag: "example asset tag" #Optional
      type: "wall-frame" #Optional
      width: 10 #Optional
      u_height: 19 #Optional
      desc_units: false #Optional
      outer_width: 10 #Optional
      outer_depth: 10 #Optional
      outer_unit: "mm" #Optional
      comments: "example comments" #Optional
      devices:
        - name: "BCN-ACP001"
          device_type_id: 7
          device_role_id: 4
          comments: "exampel comments" #Optional
          status: "active" #Optional
          asset_tag: "example tag" #Optional
          cluster_id: 1 #Optional
          serial: "example serial" #Optional
          face: "front" #Optional
          platform_id: 1 #Optional
          interfaces:
            - name: "Interface 1"
              tagged_vlan: [300]
              type: "1000base-t" #Optional
              connection_status: true #Optional
              enabled: true #Optional
              management_only: false #Optional
              label: "example label" #Optional
              mac_address: "00:00:00:00:00:00" #Optional
              mode: "access" #Optional
              description: "example description" #Optional
              untagged_vlan_id: 71 #Optional
              mtu: 1500 #Optional
            - name: "Interface 2"
              tagged_vlan: [400]
  prefixes:
    - prefix: "192.168.1.0/24"
      vrf: 1 #Optional
      description: "example description" #Optional
      status: "active"  #Optional
      is_pool: true  #Optional
    - prefix: "192.168.2.0/24"
  vlans:
    - vid: "300"
      name: "example vlan 300"
      status: "reserved" #Optional
      role_id: 1 #Optional
      description: "example description" #Optional
    - vid: "400"
      name: "example vlan 400"
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_netbox"></a> [netbox](#requirement\_netbox) | 0.1.0-alpha.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_netbox"></a> [netbox](#provider\_netbox) | 0.1.0-alpha.7 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [netbox_dcim_device.devices](https://registry.terraform.io/providers/tle06/netbox/0.1.0-alpha.7/docs/resources/dcim_device) | resource |
| [netbox_dcim_interface.interfaces](https://registry.terraform.io/providers/tle06/netbox/0.1.0-alpha.7/docs/resources/dcim_interface) | resource |
| [netbox_dcim_rack.racks](https://registry.terraform.io/providers/tle06/netbox/0.1.0-alpha.7/docs/resources/dcim_rack) | resource |
| [netbox_dcim_site.site](https://registry.terraform.io/providers/tle06/netbox/0.1.0-alpha.7/docs/resources/dcim_site) | resource |
| [netbox_extras_tag.site_tag](https://registry.terraform.io/providers/tle06/netbox/0.1.0-alpha.7/docs/resources/extras_tag) | resource |
| [netbox_ipam_prefix.prefixes](https://registry.terraform.io/providers/tle06/netbox/0.1.0-alpha.7/docs/resources/ipam_prefix) | resource |
| [netbox_ipam_vlan.vlans](https://registry.terraform.io/providers/tle06/netbox/0.1.0-alpha.7/docs/resources/ipam_vlan) | resource |
| [local_file.input](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_path"></a> [path](#input\_path) | The path of the yaml file describing the site. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The ID of region where the site will be located. | `number` | n/a | yes |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | The ID of tenant that will be added to the site. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_devices"></a> [devices](#output\_devices) | the devices generated |
| <a name="output_input"></a> [input](#output\_input) | The yaml file converted to varible |
| <a name="output_interfaces"></a> [interfaces](#output\_interfaces) | The interfaces attached to the devices |
| <a name="output_prefixes"></a> [prefixes](#output\_prefixes) | The prefix added to the site. |
| <a name="output_racks"></a> [racks](#output\_racks) | The racks generated and attached to the site |
| <a name="output_site"></a> [site](#output\_site) | The full site generated |
| <a name="output_site_tag"></a> [site\_tag](#output\_site\_tag) | The site tag generated from the site\_id value |
| <a name="output_vlans"></a> [vlans](#output\_vlans) | The VLANs generated |


## License

MIT Licensed. See [LICENSE](LICENSE) for full details.