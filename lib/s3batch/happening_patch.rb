#Monkey patch
module Happening
  class AWS
    protected
    alias old_canonical_request_description canonical_request_description

    def canonical_request_description(method, path, headers = {}, expires = nil)
      description = old_canonical_request_description(method, path, headers, expires)
      description << '?delete'  if path[/[&?]delete($|&|=)/]
      description << '?website'  if path[/[&?]website($|&|=)/]
      description
    end
  end

  module S3
    class Request
      protected
      def validate
      end
    end

    class Item
      protected
      def validate
      end
    end
  end
end
