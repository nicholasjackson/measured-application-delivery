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
  
  # Create the ACL policy and Token for the API service
  cat <<-EOT > /tmp/api-agent-policy.hcl
  node_prefix "" {
     policy = "write"
  }
  service_prefix "" {
     policy = "read"
  }
  service_prefix "api" {
     policy = "write"
  }
  EOT
  
  consul acl policy create \
    -name "api-agent-token" \
    -description "API Agent Token Policy" \
    -rules @/tmp/api-agent-policy.hcl

  consul acl token create -description "API Agent Token" \
    -policy-name "api-agent-token" \
    -format json | jq -r '.SecretID' > /files/api-agent.token

  export API_AGENT_TOKEN="$(cat /files/api-agent.token)"
  
  cat <<-EOT >> /files/api-token-config.hcl
  acl {
    tokens {
      default = "$${API_AGENT_TOKEN}"
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
