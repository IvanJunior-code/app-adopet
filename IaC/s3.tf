resource "aws_s3_bucket" "bucket" {
  bucket = "bucket-adopet-dump-sql"

  tags = {
    Name = "S3 Bucket"
  }
}

resource "aws_s3_object" "object-dump-sql" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "adopet-dump"
  source = "../sql/adopet-dump.sql"

  tags = {
    Name = "S3 Object"
  }
}

resource "aws_iam_role" "iam_role_for_s3" {
  name = "iam_role_for_s3"

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

resource "aws_iam_policy" "s3_read_policy" {
  name        = "S3ReadPolicy"
  description = "Leitura no bucket do dump SQL"

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
    Name = "IAM Policy"
  }
}

resource "aws_iam_policy_attachment" "iam_policy_attachment" {
  name       = "iam_policy_attachment"
  roles      = [aws_iam_role.iam_role_for_s3.name]
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "iam_instance_profile"
  role = aws_iam_role.iam_role_for_s3.name

  tags = {
    Name = "IAM Instance Profile"
  }
}
