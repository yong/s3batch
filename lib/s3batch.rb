require 'happening'
require 'nokogiri'
require 'mime/types'

require File.expand_path(File.dirname(__FILE__) + '/s3batch/happening_patch')
require File.expand_path(File.dirname(__FILE__) + '/s3batch/multi_delete')
require File.expand_path(File.dirname(__FILE__) + '/s3batch/batch_upload')
require File.expand_path(File.dirname(__FILE__) + '/s3batch/website_enabler')

#ruby s3batch.rb S3ID S3KEY BUCKET DIR
if $0 == __FILE__
  s3id = ARGV[0]
  s3key = ARGV[1]
  bucket = ARGV[2]
  dir = ARGV[3]
  pattern = ARGV[4] || "**/*"

  S3Batch::WebsiteEnabler.run s3id, s3key, bucket
  #S3Batch::Upload.run s3id, s3key, bucket, dir, pattern
  #S3Batch::Delete.run s3id, s3key, bucket, [dir]
end

