resource "shoreline_notebook" "mongodb_cursors_timeouts_incident" {
  name       = "mongodb_cursors_timeouts_incident"
  data       = file("${path.module}/data/mongodb_cursors_timeouts_incident.json")
  depends_on = [shoreline_action.invoke_update_mongodb_cursor_timeout]
}

resource "shoreline_file" "update_mongodb_cursor_timeout" {
  name             = "update_mongodb_cursor_timeout"
  input_file       = "${path.module}/data/update_mongodb_cursor_timeout.sh"
  md5              = filemd5("${path.module}/data/update_mongodb_cursor_timeout.sh")
  description      = "Increase the cursor timeout limit if necessary to prevent timeouts from occurring in the future."
  destination_path = "/agent/scripts/update_mongodb_cursor_timeout.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_mongodb_cursor_timeout" {
  name        = "invoke_update_mongodb_cursor_timeout"
  description = "Increase the cursor timeout limit if necessary to prevent timeouts from occurring in the future."
  command     = "`chmod +x /agent/scripts/update_mongodb_cursor_timeout.sh && /agent/scripts/update_mongodb_cursor_timeout.sh`"
  params      = ["NEW_TIMEOUT_LIMIT"]
  file_deps   = ["update_mongodb_cursor_timeout"]
  enabled     = true
  depends_on  = [shoreline_file.update_mongodb_cursor_timeout]
}

