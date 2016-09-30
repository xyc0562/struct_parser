$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "struct_parser/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "struct_parser"
  s.version     = StructParser::VERSION
  s.authors     = ["Yecheng Xu"]
  s.email       = ["xyc0562@gmail.com"]
  s.homepage    = "https://github.com/xyc0562/struct_parser"
  s.summary     = "Parse & operate on structured data"
  s.description = "This Gem Provides a systematic approach to parsing structured data (especially CSV files) through usage " +
      "of callback functions."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "roo", "~> 2.1.1"

  s.add_development_dependency "sqlite3"
end
