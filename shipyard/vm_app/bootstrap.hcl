template "bootstrap_agent" {
  source = <<-EOF
  #!/bin/sh -e

  # Create the ACL policy and Token for the Payments service
  cat <<-EOT > /tmp/payments-agent-policy.hcl
  node_prefix "" {
     policy = "write"
  }
  service_prefix "" {
     policy = "read"
  }
  service_prefix "payments" {
     policy = "write"
  }
  EOT

  consul acl policy create \
    -name "payments-agent-token" \
    -description "Payments Agent Token Policy" \
    -rules @/tmp/payments-agent-policy.hcl

  consul acl token create -description "Payments Agent Token" \
    -policy-name "payments-agent-token" \
    -format json | jq -r '.SecretID' > /files/payments-agent.token
  
  export PAYMENTS_AGENT_TOKEN="$(cat /files/payments-agent.token)"

  cat <<-EOT >> /files/payments-token-config.hcl
  acl {
    tokens {
      default = "$${PAYMENTS_AGENT_TOKEN}"
    }
  }
  EOT
  
  # Create the ACL policy and Token for the Web service
  cat <<-EOT > /tmp/web-agent-policy.hcl
  node_prefix "" {
     policy = "write"
  }
  service_prefix "" {
     policy = "read"
  }
  service_prefix "web" {
     policy = "write"
  }
  EOT
  
  consul acl policy create \
    -name "web-agent-token" \
    -description "Web Agent Token Policy" \
    -rules @/tmp/web-agent-policy.hcl

  consul acl token create -description "Web Agent Token" \
    -policy-name "web-agent-token" \
    -format json | jq -r '.SecretID' > /files/web-agent.token

  export WEB_AGENT_TOKEN="$(cat /files/web-agent.token)"
  
  cat <<-EOT >> /files/web-token-config.hcl
  acl {
    tokens {
      default = "$${WEB_AGENT_TOKEN}"
    }
  }
  EOT
  
  # Create the ACL policy and Token for the Currency service
  cat <<-EOT > /tmp/currency-agent-policy.hcl
  node_prefix "" {
     policy = "write"
  }
  service_prefix "" {
     policy = "read"
  }
  service_prefix "currency" {
     policy = "write"
  }
  EOT

  consul acl policy create \
    -name "currency-agent-token" \
    -description "Currency Agent Token Policy" \
    -rules @/tmp/currency-agent-policy.hcl

  consul acl token create -description "Currency Agent Token" \
    -policy-name "currency-agent-token" \
    -format json | jq -r '.SecretID' > /files/currency-agent.token
  
  export CURRENCY_AGENT_TOKEN="$(cat /files/currency-agent.token)"

  cat <<-EOT >> /files/currency-token-config.hcl
  acl {
    tokens {
      default = "$${CURRENCY_AGENT_TOKEN}"
    }
  }
  EOT
  
  # Create the ACL policy and Token for the Nginx service
  cat <<-EOT > /tmp/nginx-agent-policy.hcl
  node_prefix "" {
     policy = "write"
  }
  service_prefix "" {
     policy = "read"
  }
  service_prefix "nginx" {
     policy = "write"
  }
  key_prefix "nginx/" {
     policy = "read"
  }
  EOT
  
  consul acl policy create \
    -name "nginx-agent-token" \
    -description "Nginx Agent Token Policy" \
    -rules @/tmp/nginx-agent-policy.hcl

  consul acl token create -description "Nginx Agent Token" \
    -policy-name "nginx-agent-token" \
    -format json | jq -r '.SecretID' > /files/nginx-agent.token

  export NGINX_AGENT_TOKEN="$(cat /files/nginx-agent.token)"
  
  cat <<-EOT >> /files/nginx-token-config.hcl
  acl {
    tokens {
      default = "$${NGINX_AGENT_TOKEN}"
    }
  }
  EOT
  EOF

  destination = "${data("agent_config")}/agent_bootstrap.sh"
}

exec_remote "agent_consul_bootstrap" {
  target = "container.1-consul-server"

  cmd = "sh"
  args = [
    "/files/agent_bootstrap.sh"
  ]
}
