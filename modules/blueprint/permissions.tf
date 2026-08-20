resource "port_blueprint_permissions" "this" {
  count                 = var.permissions.readOwnedByTeam ? 0 : 1
  blueprint_identifier  = port_blueprint.this.identifier
  entities              = local.permissions_blueprint_native
}

resource "terraform_data" "port_patch_read_permissions" {
  count = var.permissions.readOwnedByTeam ? 1 : 0

  input = {
    blueprint_id = port_blueprint.this.identifier
    payload      = local.port_permissions_payload_api
    base_url     = var.port_api_base_url
    token        = var.port_api_token
    payload_hash = sha256(local.port_permissions_payload_api)
  }

  depends_on = [
    port_blueprint.this
  ]

  provisioner "local-exec" {
    when        = create
    interpreter = ["/bin/bash", "-c"]
    environment = {
      BASE_URL    = self.input.base_url
      BLUEPRINT   = self.input.blueprint_id
      PAYLOAD     = self.input.payload
      PORT_TOKEN  = self.input.token
    }

    command = <<-BASH
      set -euo pipefail

      if [ -z "$${PORT_TOKEN:-}" ]; then
        echo "ERROR: port_api_token no está definido. Es requerido cuando permissions.readOwnedByTeam = true." >&2
        exit 1
      fi

      tmpfile="$(mktemp)"
      respfile="$(mktemp)"
      trap 'rm -f "$tmpfile" "$respfile"' EXIT

      printf "%s" "$PAYLOAD" > "$tmpfile"

      url="$BASE_URL/v1/blueprints/$BLUEPRINT/permissions"

      http_code="$(curl -sS -L -X PATCH \
        "$url" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -H "Authorization: Bearer $PORT_TOKEN" \
        --data-binary "@$tmpfile" \
        -o "$respfile" \
        -w "%%{http_code}")"

      echo "Port PATCH permissions HTTP $http_code for blueprint=$BLUEPRINT"
      cat "$respfile" || true
      echo ""

      if [ "$http_code" -lt 200 ] || [ "$http_code" -ge 300 ]; then
        echo "ERROR: PATCH failed (HTTP $http_code)" >&2
        exit 1
      fi

      echo "✅ Port permissions patched for blueprint=$BLUEPRINT"
    BASH
  }
}
