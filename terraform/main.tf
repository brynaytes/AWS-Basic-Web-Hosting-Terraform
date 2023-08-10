locals {
  s3_bucket_name = "${var.site_name}-site-assets"
}

resource "aws_s3_bucket" "site_bucket" {
    bucket =  "${var.site_name}-site-assets"
    tags = {
        Name = "Terraform hosting test"
    }
}

resource "aws_cloudfront_distribution" "distribution"  {
    origin {
        domain_name = aws_s3_bucket.site_bucket.bucket_regional_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
        origin_id = aws_s3_bucket.site_bucket.id
    }
    default_cache_behavior {
        allowed_methods = ["POST", "HEAD", "PATCH", "DELETE", "PUT", "GET", "OPTIONS"]
        cached_methods = [ "HEAD", "GET", "OPTIONS"]
        viewer_protocol_policy = "allow-all"
        target_origin_id = aws_s3_bucket.site_bucket.id
        forwarded_values {
          query_string = false
              cookies {
            forward = "none"
          }
        }

    }
    restrictions {
        geo_restriction {

            restriction_type = "none"
            locations = []
        }
    }
    viewer_certificate {
        cloudfront_default_certificate = true
    }
    enabled = true
    is_ipv6_enabled = true
    default_root_object = "index.html" 
    tags = {
        Name = "Terraform hosting test"
    }
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name = "OAC for ${var.site_name}"
  description = ""
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.site_bucket.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${local.s3_bucket_name}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudfront_distribution.distribution.arn}"
                }
            }
        }
    ]
}
  EOF
}

