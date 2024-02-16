output "bucket_name" {
  value = module.workspaces_bucket.bucket_id
}

output "statefile_table_name" {
  value = aws_dynamodb_table.statefile_locks.id
}

output "role_arns" {
  value = { for this_application, these_attributes in module.workspace : this_application => these_attributes.role_arn }
}

output "workspaces" {
  description = "Here for API compatibility with the TFC module"
  value       = module.workspace
}
