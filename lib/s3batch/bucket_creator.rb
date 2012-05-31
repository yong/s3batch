module S3Batch
  class BucketCreator < Happening::S3::Item
    def path(with_bucket=true)
      with_bucket ? "/#{bucket}/" : "/"
    end

    def create region, request_options = {}, &blk
      data =<<EOF
<CreateBucketConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
  <LocationConstraint>#{region}</LocationConstraint> 
</CreateBucketConfiguration>
EOF
      data = '' unless region

      md5 = Base64.encode64(Digest::MD5.digest(data)).strip
      headers = aws.sign("PUT", path, {"Content-MD5" => md5})
      request_options[:on_success] = blk if blk          
      request_options.update(:headers => headers, :data => data)
      Happening::S3::Request.new(:put, url, {:ssl => options[:ssl]}.update(request_options)).execute
    end

    def self.run s3id, s3key, bucket, region = nil
      EM.run {
        on_error = Proc.new {|response| puts "An error occured: #{response.response}"; EM.stop; }
        on_success = Proc.new {|response| puts "Created #{response.response}"; EM.stop; }
        item = S3Batch::BucketCreator.new(bucket, "NO_USE", :aws_access_key_id => s3id, :aws_secret_access_key => s3key, :protocol => 'http')
        item.create(region, :on_error => on_error, :on_success => on_success)
      }
    end
  end
end
