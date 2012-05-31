module S3Batch
  class DeleteCollection < Happening::S3::Item
    MULTIPLE_DELETE_LIMIT = 1000

    def initialize(bucket, keys, options = {})
      super bucket, "NO_USE", options
      @keys = keys
    end
    
    def path(with_bucket=true)
      with_bucket ? "/#{bucket}/?delete" : "/?delete"
    end

    def delete request_options = {}, &blk
      i = 0
      while i < @keys.size
        keys = @keys.slice(i, MULTIPLE_DELETE_LIMIT)
        data = "<Delete><Quiet>true</Quiet><Object><Key>" + keys.join("</Key></Object><Object><Key>") + "</Key></Object></Delete>"
        md5 = Base64.encode64(Digest::MD5.digest(data)).strip

        headers = aws.sign("POST", path, {"Content-MD5" => md5})
        request_options[:on_success] = blk if blk          
        request_options.update(:headers => headers, :data => data)
        Happening::S3::Request.new(:post, url, {:ssl => options[:ssl]}.update(request_options)).execute
        i += MULTIPLE_DELETE_LIMIT
      end
    end

    def run s3id, s3key, bucket, keys 
      EM.run {
        on_error = Proc.new {|response| puts "An error occured: #{response.response}"; EM.stop }
        on_success = Proc.new {|response| puts "Deleted!"; EM.stop }
        items = DeleteCollection.new bucket, keys, :aws_access_key_id => s3id, :aws_secret_access_key => s3key, :protocol => 'http'
        items.delete(:on_error => on_error, :on_success => on_success) 
      }
    end
  end
end
