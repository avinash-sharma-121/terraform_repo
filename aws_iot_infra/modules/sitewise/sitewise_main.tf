
# Example of an IoT SiteWise Asset Model for a Wind Turbine
resource "awscc_iotsitewise_asset_model" "LHM-Rack_tf" {
  asset_model_name        = "LHM-Rack_tf"
  asset_model_description = "Asset model for LHM-Rack"

  asset_model_properties = [
    # Measurement Properties    
    {
      name       = "Temperature"
      data_type  = "DOUBLE"
      unit       = "°C"
      logical_id = "temperature_property"
      type = {
        type_name = "Measurement"
      }
    }
    
    /*
    {
      name       = "Wind Speed"
      data_type  = "DOUBLE"
      unit       = "m/s"
      logical_id = "wind_speed_property"
      type = {
        type_name = "Measurement"
      }
    },
    {
      name       = "Power Output"
      data_type  = "DOUBLE"
      unit       = "kW"
      logical_id = "power_output_property"
      type = {
        type_name = "Measurement"
      }
    },
    # Attribute Properties
    {
      name       = "Location"
      data_type  = "STRING"
      logical_id = "location_property"
      type = {
        type_name = "Attribute"
        attribute = {
          default_value = "Unknown"
        }
      }
    }
    */
  ]

  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]
}

# Then create the asset using the model
resource "awscc_iotsitewise_asset" "child-LHM-Rack_tf" {
  count = 5
  asset_name        = "LHM-Rack-${count.index+1}"
  asset_model_id    = awscc_iotsitewise_asset_model.LHM-Rack_tf.asset_model_id
  asset_description = "LHM-Rack IoT SiteWise asset"

  asset_properties = [{
    name               = "Temperature"
    alias = "robots/LHM-Rack/LHM-Rack-${count.index+1}"
    logical_id         = "temperature_property"
    notification_state = "DISABLED"
  }]


  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]
}
