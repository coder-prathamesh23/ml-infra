output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}
output "sagemaker_execution_role_arn" {
  value = aws_iam_role.sagemaker_exec_role.arn
}