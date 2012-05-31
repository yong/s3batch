Gem::Specification.new do |s|
  s.name = %q{s3batch}
  s.version = "0.1.1"

  s.authors = ["Xue Yong Zhi"]
  s.date = %q{2012-05-30}
  s.email = ["yong@intridea.com"]
  s.files = Dir['lib/**/*.rb']
  s.summary = %q{upload/delete s3 objects in batch}
  s.homepage = "http://github.com/yong/s3batch"
  s.add_dependency(%q<happening>)
  s.add_dependency(%q<nokogiri>)
end

