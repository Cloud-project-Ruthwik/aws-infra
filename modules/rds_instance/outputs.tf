output "database_security_group_id" {
  value = aws_security_group.database.id
}

# output "database_security_group_arn" {
#   value = aws_security_group.database.arn
# }

# output "csye6225_rds_endpoint" {
#   value = aws_db_instance.csye6225.endpoint
# }

# output "csye6225_rds_arn" {
#   value = aws_db_instance.csye6225.arn
# }

output "database_endpoint" {
  value = aws_db_instance.database.endpoint
}

output "database_username" {
  value = aws_db_instance.database.username
}

output "database_password" {
  value = aws_db_instance.database.password
}
