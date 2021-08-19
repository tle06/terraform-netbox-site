
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
      tag_color = "000000"
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
  devices = local.raw_settings["site"].devices
  prefixes = local.raw_settings["site"].prefixes
  

}

/* -------------------------------------------------------------------------- */
/*                                  Add site                                  */
/* -------------------------------------------------------------------------- */
resource "netbox_dcim_site" "site" {
  name = local.site.name
  slug = trimspace(lower(replace(local.site.name," ","-")))
  region_id = local.site.region
  status = local.default.site.status
  tenant_id = local.site.tenant
  facility = local.site.facility
  asn_id = local.default.site.asn_id
  time_zone = local.site.time_zone
  description = local.default.site.description
  physical_address = local.site.physical_address
  shipping_address = local.site.shipping_address
  latitude = local.site.latitude
  longitude = local.site.longitude
  contact_name = local.site.contact_name
  contact_phone = local.site.contact_phone
  contact_email = local.site.contact_email
  comments = local.site.comments

  dynamic "tags" {
    for_each = local.site.tags
    content {
      name = tags.value.name
      slug = tags.value.slug
    }
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
    

}

/* -------------------------------------------------------------------------- */
/*                                   Devices                                  */
/* -------------------------------------------------------------------------- */
resource "netbox_dcim_device" "devices" {
  for_each ={ for device in local.devices : device.name => device }
  device_type_id = 7
  device_role_id = 4
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
  position_id = try(each.value.position_id,local.default.device.position_id)
  
  
  dynamic "tags" {
    for_each = local.site.tags
    content {
      name = tags.value.name
      slug = tags.value.slug
    }
  }

}