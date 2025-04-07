resource "aws_s3_bucket" "bucket-adopet" {
  bucket = "bucket-adopet"

  tags = {
    Name = "S3 Bucket"
  }
}

resource "aws_s3_object" "object-dump-sql" {
  bucket = aws_s3_bucket.bucket-adopet.bucket
  key    = "adopet-dump"
  source = "../sql/adopet-dump.sql"

  tags = {
    Name = "S3 Object Dump SQL"
  }
}

resource "aws_s3_object" "object_app_tar" {
  bucket = aws_s3_bucket.bucket-adopet.bucket
  key    = "adopet-app"
  source = "../app-tar/app.tar"

  depends_on = [null_resource.app_tar]

  tags = {
    Name = "S3 Object App Tar"
  }
}