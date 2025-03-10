### IAM Role for EC2
resource "aws_iam_role" "iam_ec2_role" {
  name = "iam_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "IAM Role"
  }
}
###


### S3 Read Policy
resource "aws_iam_policy" "s3_read_policy" {
  name        = "S3ReadPolicy"
  description = "Policy to read the dump SQL bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:GetObject", "s3:ListBucket"]
      Resource = [
        aws_s3_bucket.bucket.arn,
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }]
  })

  tags = {
    Name = "IAM S3 Read Policy"
  }
}

resource "aws_iam_policy_attachment" "iam_s3_read_policy_attachment" {
  name       = "iam_s3_read_policy_attachment"
  roles      = [aws_iam_role.iam_ec2_role.name]
  policy_arn = aws_iam_policy.s3_read_policy.arn
}
###


### Secret Manager Policy
resource "aws_iam_policy" "secretmanager_policy" {
  name        = "SecretManagerPolicy"
  description = "Policy to allow EC2 to access Secret Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["secretsmanager:GetSecretValue"]
      Resource = [
        aws_secretsmanager_secret.secretmanager_postgres.arn
      ]
    }]
  })

  tags = {
    Name = "IAM Secret Manager Policy"
  }
}

resource "aws_iam_policy_attachment" "iam_secretmanager_policy_attachment" {
  name       = "iam_secretmanager_policy_attachment"
  roles      = [aws_iam_role.iam_ec2_role.name]
  policy_arn = aws_iam_policy.secretmanager_policy.arn
}
###


### EC2 Profile
resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "iam_instance_profile"
  role = aws_iam_role.iam_ec2_role.name

  tags = {
    Name = "IAM Instance Profile"
  }
}
###
