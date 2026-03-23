resource "google_compute_security_policy" "waf_policy" {
  name    = var.policy_name
  project = var.project_id

  # SQL Injection protection
  rule {
    priority = 100
    action   = "deny(403)"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sqli-v33-stable')"
      }
    }
    description = "Block SQL injection"
  }

  # XSS protection
  rule {
    priority = 200
    action   = "deny(403)"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('xss-v33-stable')"
      }
    }
    description = "Block XSS attacks"
  }

  # Local file inclusion protection
  rule {
    priority = 300
    action   = "deny(403)"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('lfi-v33-stable')"
      }
    }
    description = "Block path traversal"
  }

  # Remote code execution protection
  rule {
    priority = 400
    action   = "deny(403)"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('rce-v33-stable')"
      }
    }
    description = "Block remote code execution"
  }

  # Rate limiting - block if more than 100 requests per minute
  rule {
    priority = 500
    action   = "throttle"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    rate_limit_options {
      conform_action = "allow"
      exceed_action  = "deny(429)"
      rate_limit_threshold {
        count        = 100
        interval_sec = 60
      }
    }
    description = "Rate limiting"
  }

  # Default allow rule 
  rule {
    priority = 2147483647
    action   = "allow"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow rule"
  }
}

#Health chech
resource "google_compute_health_check" "order_service_hc" {
  name    = var.health_check_name
  project = var.project_id

  http_health_check {
    port         = var.health_check_port
    request_path = "/health"
  }

  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3
}


resource "google_compute_backend_service" "order_service_backend" {
  name                  = var.backend_service_name
  project               = var.project_id
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 30

  security_policy = google_compute_security_policy.waf_policy.id
  health_checks   = [google_compute_health_check.order_service_hc.id]

  outlier_detection {
    consecutive_errors = 3
    base_ejection_time { seconds = 30 }
    interval { seconds = 10 }
    max_ejection_percent                  = 50
    consecutive_gateway_failure           = 3
    enforcing_consecutive_errors          = 100
    enforcing_consecutive_gateway_failure = 100
    enforcing_success_rate                = 100
    success_rate_minimum_hosts            = 3
    success_rate_request_volume           = 100
    success_rate_stdev_factor             = 1900
  }

  log_config {
    enable      = true
    sample_rate = 1.0
  }
}