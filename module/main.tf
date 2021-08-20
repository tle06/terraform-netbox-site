
/* -------------------------------------------------------------------------- */
/*                               Read YAML file                               */
/* -------------------------------------------------------------------------- */
data "local_file" "input" {
    filename = var.path
}


/* -------------------------------------------------------------------------- */
/*                             set local variables                            */
/* -------------------------------------------------------------------------- */
locals {
  default = {
    site = {
      facility = null
      description = null
      contact_name = null
      contact_email = null
      contact_phone = null
      status = "active"
      asn_id = null
      longitude = null
      latitude = null
      comments = null
    }
    rack = {
      status = "active" 
      role_id = null
      serial = null
      asset_tag = null
      type = null
      width = null
      u_height = 19
      desc_units = false
      outer_width = null
      outer_depth = null
      outer_unit = "mm"
      comments = null
    }
    device = {
      comments = null
      status = "active"
      asset_tag = null
      cluster_id = null
      serial = null
      face = "front"
      platform_id = null
      position_id = null
    }

    interface = {
      connection_status = null
      enabled = true
      management_only = null
      label = null
      mac_address = null
      mode = null
      description = null
      untagged_vlan_id = null
      mtu = null
      type = "1000base-t"
      tagged_vlan = null
    }

    vlan = {
      status = "active"
      role_id = null
      description = null
    }

    prefix = {
      status = "active"
      description = null
      vrf_id = null
      vlan_id = null
      role_id = null
      is_pool = null
    }

    tag = {
      color = "2196f3"
    }
  }

  raw_settings = yamldecode(data.local_file.input.content)
  site = {
      name = local.raw_settings["site"].name
      region = var.region
      tenant = var.tenant
      time_zone = local.raw_settings["site"].time_zone
      physical_address = local.raw_settings["site"].physical_address
      shipping_address = try(local.raw_settings["site"].shipping_address,local.raw_settings["site"].physical_address)
      site_id = local.raw_settings["site"].site_id
      contact_name = try(local.raw_settings["site"].contact_name, local.default.site.contact_name)
      contact_email = try(local.raw_settings["site"].contact_email,local.default.site.contact_email)
      contact_phone = try(local.raw_settings["site"].contact_phone, local.default.site.contact_phone)
      longitude = try(local.raw_settings["site"].longitude,local.default.site.longitude)
      latitude = try(local.raw_settings["site"].latitude,local.default.site.latitude)
      comments = try(local.raw_settings["site"].comments,local.default.site.comments)
      facility = try(local.raw_settings["site"].facility,local.default.site.facility)
      tags = var.tags
    
  }
  
  racks = local.raw_settings["site"].racks
  prefixes = local.raw_settings["site"].prefixes
  vlans = local.raw_settings["site"].vlans


  devices_association = flatten([for rack in local.racks:[
    for device in rack.devices:{
    device_type_id = device.device_type_id
    device_role_id = device.device_role_id
    rack_name = rack.name
    name = device.name
    comments = try(device.comments,local.default.device.comments)
    status = try(device.status,local.default.device.status)
    asset_tag = try(device.asset_tag,local.default.device.asset_tag)
    cluster_id = try(device.cluster_id,local.default.device.cluster_id)
    serial = try(device.serial,local.default.device.serial)
    face = try(device.face,local.default.device.face)
    platform_id = try(device.platform_id,local.default.device.platform_id)
    position_id = try(device.position_id,local.default.device.position_id)
    interfaces = device.interfaces

    }]])


  interfaces_association = flatten([for device in local.devices_association:[
    for interface in device.interfaces:{
      tagged_vlan = try(interface.tagged_vlan,local.default.interface.tagged_vlan)
      device_name = device.name
      type = try(interface.type,local.default.interface.type)
      name = interface.name
      connection_status = try(interface.connection_status,local.default.interface.connection_status)
      enabled = try(interface.enabled,local.default.interface.enabled)
      management_only = try(interface.management_only,local.default.interface.management_only)
      label = try(interface.label,local.default.interface.label)
      mac_address = try(interface.mac_address,local.default.interface.mac_address)
      mode = try(interface.mode,local.default.interface.mode)
      description = try(interface.description,local.default.interface.description)
      untagged_vlan_id = try(interface.untagged_vlan_id,local.default.interface.untagged_vlan_id)
      mtu = try(interface.mtu,local.default.interface.mtu)

    }
  ]])

}


/* -------------------------------------------------------------------------- */
/*                                  Site tag                                  */
/* -------------------------------------------------------------------------- */

resource "netbox_extras_tag" "site_tag" {
  name  = local.site.site_id
  slug  = trimspace(lower(replace(local.site.site_id," ","-")))
  color = local.default.tag.color
}


/* -------------------------------------------------------------------------- */
/*                                  Add site                                  */
/* -------------------------------------------------------------------------- */

resource "netbox_dcim_site" "site" {
  name = local.site.name
  slug = trimspace(lower(replace(local.site.name," ","-")))
  region_id = local.site.region
  status = try(local.default.site.status, local.default.site.status)
  tenant_id = local.site.tenant
  facility = try(local.site.facility, local.default.site.facility)
  asn_id = try(local.default.site.asn_id, local.default.site.asn_id)
  time_zone = try(local.site.time_zone, local.default.site.time_zone)
  description = try(local.default.site.description, local.default.site.description)
  physical_address = try(local.site.physical_address, local.default.site.physical_address)
  shipping_address = try(local.site.shipping_address, local.default.site.shipping_address)
  latitude = try(local.site.latitude, local.default.site.latitude)
  longitude = try(local.site.longitude, local.default.site.longitude)
  contact_name = try(local.site.contact_name, local.default.site.contact_name)
  contact_phone = try(local.site.contact_phone, local.default.site.contact_phone)
  contact_email = try(local.site.contact_email, local.default.site.contact_email)
  comments = try(local.site.comments, local.default.site.comments)

  dynamic "tags" {
    for_each = local.site.tags
    content {
      name = tags.value.name
      slug = tags.value.slug
    }
  }

  tags {
    name = netbox_extras_tag.site_tag.name
    slug = netbox_extras_tag.site_tag.slug
  }
    
}

/* -------------------------------------------------------------------------- */
/*                                    Racks                                   */
/* -------------------------------------------------------------------------- */

resource "netbox_dcim_rack" "racks" {
  for_each ={ for rack in local.racks : rack.name => rack }
  name = each.key
  site_id = netbox_dcim_site.site.id
  facility = local.site.facility
  tenant_id = local.site.tenant
  status = try(each.value.status,local.default.rack.status)
  role_id = try(each.value.role_id,local.default.rack.role_id)
  serial = try(each.value.serial,local.default.rack.serial)
  asset_tag = try(each.value.asset_tag,local.default.rack.asset_tag)
  type = try(each.value.type,local.default.rack.type)
  width = try(each.value.width,local.default.rack.width)
  u_height = try(each.value.u_height,local.default.rack.u_height)
  desc_units = try(each.value.desc_units,local.default.rack.desc_units)
  outer_width = try(each.value.outer_width,local.default.rack.outer_width)
  outer_depth = try(each.value.outer_depth,local.default.rack.outer_depth)
  outer_unit = try(each.value.outer_unit,local.default.rack.outer_unit)
  comments = try(each.value.comments,local.default.rack.comments)

  dynamic "tags" {
    for_each = local.site.tags
    content {
      name = tags.value.name
      slug = tags.value.slug
    }
  }
  
  tags {
    name = netbox_extras_tag.site_tag.name
    slug = netbox_extras_tag.site_tag.slug
  }

}

/* -------------------------------------------------------------------------- */
/*                                   Devices                                  */
/* -------------------------------------------------------------------------- */

resource "netbox_dcim_device" "devices" {
  for_each ={ for device in local.devices_association : device.name => device }
  device_type_id = each.value.device_type_id
  device_role_id = each.value.device_role_id
  site_id = netbox_dcim_site.site.id
  tenant_id = local.site.tenant
  rack_id = netbox_dcim_rack.racks[each.value.rack_name].id
  name = each.key
  comments = try(each.value.comments,local.default.device.comments)
  status = try(each.value.status,local.default.device.status)
  asset_tag = try(each.value.asset_tag,local.default.device.asset_tag)
  cluster_id = try(each.value.cluster_id,local.default.device.cluster_id)
  serial = try(each.value.serial,local.default.device.serial)
  face = try(each.value.face,local.default.device.face)
  platform_id = try(each.value.platform_id,local.default.device.platform_id)
  
  
  dynamic "tags" {
    for_each = local.site.tags
    content {
      name = tags.value.name
      slug = tags.value.slug
    }
  }
  
  tags {
    name = netbox_extras_tag.site_tag.name
    slug = netbox_extras_tag.site_tag.slug
  }
}

/* -------------------------------------------------------------------------- */
/*                                    Vlan                                    */
/* -------------------------------------------------------------------------- */

resource "netbox_ipam_vlan" "vlans" {

  for_each ={ for vlan in local.vlans : vlan.vid => vlan }
  name = each.value.name
	vid = each.key
	site_id = netbox_dcim_site.site.id
	tenant_id = local.site.tenant
	status = try(each.value.status, local.default.vlan.status)
	role_id = try(each.value.role_id, local.default.vlan.role_id)
  description = try(each.value.description, local.default.vlan.description)
  
  dynamic "tags" {
    for_each = local.site.tags
    content {
      name = tags.value.name
      slug = tags.value.slug
    }
  }

  tags {
    name = netbox_extras_tag.site_tag.name
    slug = netbox_extras_tag.site_tag.slug
  }
}

/* -------------------------------------------------------------------------- */
/*                                 Interfaces                                 */
/* -------------------------------------------------------------------------- */
resource "netbox_dcim_interface" "interfaces" {
  for_each = { for interface in local.interfaces_association : interface.name => interface }
  tagged_vlan = flatten([for vid in each.value.tagged_vlan:[
    netbox_ipam_vlan.vlans[vid].id
  ]])
  device_id = netbox_dcim_device.devices[each.value.device_name].id
  type = each.value.type
  name = each.value.name
  connection_status = each.value.connection_status
  enabled = each.value.enabled
  management_only =  each.value.management_only
  label = each.value.label
  mac_address = each.value.mac_address
  mode = each.value.mode
  description = each.value.description
  untagged_vlan_id = each.value.untagged_vlan_id
  mtu = each.value.mtu

  dynamic "tags" {
    for_each = local.site.tags
    content {
      name = tags.value.name
      slug = tags.value.slug
    }
  }

  tags {
    name = netbox_extras_tag.site_tag.name
    slug = netbox_extras_tag.site_tag.slug
  }
}


/* -------------------------------------------------------------------------- */
/*                                  Prefixes                                  */
/* -------------------------------------------------------------------------- */

resource "netbox_ipam_prefix" "prefixes" {

  for_each ={ for prefix in local.prefixes : prefix.prefix => prefix }
  prefix = each.key
  site_id = netbox_dcim_site.site.id
  status = try(each.value.status,local.default.prefix.status)
  description = try(each.value.description,local.default.prefix.description)
  vrf_id = try(each.value.vrf_id,local.default.prefix.vrf_id)
  tenant_id = local.site.tenant
  vlan_id = try(each.value.vlan_id,local.default.prefix.vlan_id)
  role_id = try(each.value.role_id,local.default.prefix.role_id)
  is_pool = try(each.value.is_pool,local.default.prefix.is_pool)

  dynamic "tags" {
    for_each = local.site.tags
    content {
      name = tags.value.name
      slug = tags.value.slug
    }
  }

  tags {
    name = netbox_extras_tag.site_tag.name
    slug = netbox_extras_tag.site_tag.slug
  }
}