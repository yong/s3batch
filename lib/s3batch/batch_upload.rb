module S3Batch

  class TaskManager
    def initialize
      @count = 0
      @adding_ended = false
    end

    def add
      @count += 1
    end

    def remove
      @count -= 1
      EM.stop if @count == 0 && @adding_ended
    end

    def end_adding
      @adding_ended = true
      EM.stop if @count == 0
    end
  end

  class Upload
    def initialize(bucket, dir, pattern, options = {})
      @bucket = bucket
      @dir = dir.end_with?('/') ? dir : dir + "/"
      @pattern = pattern
      @options = options
    end

    def upload request_options = {}
      item = Happening::S3::Item.new(@bucket, '', @options)
      item.get { |response|
        keys = parse_keys(response.response)
        check_md5_and_upload keys
      }
    end

    def self.run s3id, s3key, bucket, dir, pattern
      EM.run {
        items = Upload.new bucket, dir, pattern, :aws_access_key_id => s3id, :aws_secret_access_key => s3key, :protocol => 'http', :permissions => 'public-read'
        items.upload 
      }
    end
    
    private
    
      def parse_keys xml
        h = {}
        doc = Nokogiri::XML(xml)
        doc.css("Contents").each { |entry|
          key = entry.at("Key").content
          md5 = entry.at("ETag").content.gsub(/\A"/m, "").gsub(/"\Z/m, "")
          h[key] = md5
        }
        return h
      end

      def check_md5_and_upload keys
        manager = TaskManager.new
        on_error = Proc.new {|response| puts "An error occured: #{response.response_header.status}"; manager.remove; }
        on_success = Proc.new {|response| manager.remove; }

        Dir.glob(@dir + @pattern) {|filename|
          next unless File.file? filename

          key = filename[@dir.length..-1]
          content = File.read(filename)
          md5 = Digest::MD5.hexdigest(content)

          if keys[key] != md5
            puts "uploading #{key} to #{@bucket}"
            item = Happening::S3::Item.new(@bucket, key, @options)
            headers = {}
            type = MIME::Types.type_for(key).first
            headers['Content-Type'] = type if type
            item.put(content, :on_error => on_error, :on_success => on_success, :headers => headers)
            manager.add
          else
            puts "ignore #{key}, no change"
          end
        }

        manager.end_adding
      end
  end
end
