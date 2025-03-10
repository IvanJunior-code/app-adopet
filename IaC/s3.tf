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
