resource "aws_iam_policy" "WebAppS3" {
  name = "WebAppS3"
  path        = "/"
  description = "Allow"

  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
            # "s3:*"
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:Abort*",
        ]
        Resource = [
            "arn:aws:s3:::${var.s3_bucket_name}",
            "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      },
    ]
  })
}
