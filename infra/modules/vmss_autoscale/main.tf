resource "azurerm_monitor_autoscale_setting" "this" {
  name               = "autoscale-vmss"
  resource_group_name= var.rg_name
  location           = var.location
  target_resource_id = var.vmss_id

  # Default CPU-based profile
  profile {
    name = "cpu-rules"
    capacity { 
        maximum = 10
        minimum = 1
        default = 2
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.vmss_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    # scale in: CPU < 30% for 10m
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.vmss_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
    }

  # Weekdays 18:00 
  profile {
    name = "weekday-1800-to-3"
    capacity { 
        minimum = 1
        default = 2
        maximum = 5
    }

  rule {
      metric_trigger {
        metric_name        = "VmAvailabilityMetric"
        metric_resource_id = var.vmss_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 1
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "VmAvailabilityMetric"
        metric_resource_id = var.vmss_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 1
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    recurrence {
      timezone = "Central European Standard Time"
      days     = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
      hours    = [18]
      minutes  = [0]
    }
  }

  notification {
    email {
      custom_emails = ["lisovska.anastasiis.o@gmail.com"]
    }
  }
}
