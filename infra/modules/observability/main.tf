# NOTIFICATION CHANNELS

# Email
resource "google_monitoring_notification_channel" "email" {
  project      = var.project_id
  display_name = "Email Alerts"
  type         = "email"

  labels = {
    email_address = var.alert_email
  }
}

# Slack 
resource "google_monitoring_notification_channel" "slack" {
  project      = var.project_id
  display_name = "Slack Alerts"
  type         = "webhook_tokenauth"

  labels = {
    #channel_name = "#test-paresh"
    url = var.slack_webhook_url
  }
  /*
  sensitive_labels {
    password = "https://hooks.slack.com/services/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"
  }
  */
}


# LOG-BASED METRIC (5xx ERRORS)
resource "google_logging_metric" "app_5xx_errors" {
  project = var.project_id
  name    = var.metric_name

  filter = <<EOF
resource.type="k8s_container"
resource.labels.container_name="${var.service_name}"
httpRequest.status>=500
EOF

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

# ALERT POLICIES

# CPU Alert
resource "google_monitoring_alert_policy" "cpu_high" {
  project      = var.project_id
  display_name = "GKE High CPU Usage"
  combiner     = "OR"

  conditions {
    display_name = "CPU > 80%"
    condition_threshold {
      filter          = "resource.type=\"k8s_container\" AND metric.type=\"kubernetes.io/container/cpu/core_usage_time\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.cpu_threshold
      duration        = "300s"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.slack.id
  ]
}

# Memory Alert
resource "google_monitoring_alert_policy" "memory_high" {
  project      = var.project_id
  display_name = "GKE High Memory Usage"
  combiner     = "OR"

  conditions {
    display_name = "Memory > 500MB"
    condition_threshold {
      filter          = "resource.type=\"k8s_container\" AND metric.type=\"kubernetes.io/container/memory/used_bytes\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.memory_threshold
      duration        = "300s"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.slack.id]
}


# Pod Restart Alert
resource "google_monitoring_alert_policy" "pod_restart" {
  project      = var.project_id
  display_name = "Pod Restart Alert"
  combiner     = "OR"

  conditions {
    display_name = "Restart > 3"
    condition_threshold {
      filter          = "resource.type=\"k8s_container\" AND metric.type=\"kubernetes.io/container/restart_count\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.pod_restart_threshold
      duration        = "300s"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_DELTA"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.slack.id]
}

# 5xx Error Alert (WARNING)
resource "google_monitoring_alert_policy" "error_rate" {
  project      = var.project_id
  display_name = "High Error Rate (WARNING)"
  combiner     = "OR"

  conditions {
    display_name = "5xx Errors > 2"
    condition_threshold {
      filter          = "resource.type=\"k8s_container\" AND metric.type=\"logging.googleapis.com/user/${var.metric_name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.error_rate_threshold
      duration        = "300s"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.slack.id
  ]
}

# SLO Burn Alert (CRITICAL)
resource "google_monitoring_alert_policy" "slo_burn" {
  project      = var.project_id
  display_name = "High Error Budget Burn (CRITICAL)"
  combiner     = "OR"

  conditions {
    display_name = "Error rate too high"
    condition_threshold {
      filter          = "resource.type=\"k8s_container\" AND metric.type=\"logging.googleapis.com/user/${var.metric_name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.slo_burn_threshold
      duration        = "300s"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}

# SLO (ORDER SERVICE)
resource "google_monitoring_custom_service" "order_service" {
  project      = var.project_id
  service_id   = var.service_name
  display_name = var.service_display_name
}

resource "google_monitoring_slo" "order_availability" {
  project             = var.project_id
  service             = google_monitoring_custom_service.order_service.service_id
  display_name        = "${var.service_display_name} Availability"
  goal                = var.slo_goal
  rolling_period_days = 30

  request_based_sli {
    good_total_ratio {
      good_service_filter  = "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/request_count\" AND metric.label.response_code_class=\"2xx\""
      total_service_filter = "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/request_count\""
    }
  }
}

# DASHBOARD
resource "google_monitoring_dashboard" "gke_dashboard" {
  project = var.project_id
  dashboard_json = jsonencode({
    displayName = "GKE Monitoring Dashboard"
    gridLayout = {
      columns = 2
      widgets = [
        {
          title = "CPU Usage"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type=\"k8s_container\" AND metric.type=\"kubernetes.io/container/cpu/core_usage_time\""
                }
              }
            }]
          }
        },
        {
          title = "Memory Usage"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type=\"k8s_container\" AND metric.type=\"kubernetes.io/container/memory/used_bytes\""
                }
              }
            }]
          }
        },
        {
          title = "Pod Restarts"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type=\"k8s_container\" AND metric.type=\"kubernetes.io/container/restart_count\""
                }
              }
            }]
          }
        },
        {
          title = "5xx Errors"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type=\"k8s_container\" AND metric.type=\"logging.googleapis.com/user/${var.metric_name}\""
                }
              }
            }]
          }
        }
      ]
    }
  })
}