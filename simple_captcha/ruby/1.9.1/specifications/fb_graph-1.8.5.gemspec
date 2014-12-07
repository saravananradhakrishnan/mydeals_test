# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fb_graph}
  s.version = "1.8.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{nov matake}]
  s.date = %q{2011-06-14}
  s.description = %q{A full-stack Facebook Graph API wrapper in Ruby.}
  s.email = %q{nov@matake.jp}
  s.extra_rdoc_files = [%q{LICENSE}, %q{README.rdoc}]
  s.files = [%q{LICENSE}, %q{README.rdoc}]
  s.homepage = %q{http://github.com/nov/fb_graph}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.3}
  s.summary = %q{A full-stack Facebook Graph API wrapper in Ruby.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httpclient>, [">= 2.2.0.2"])
      s.add_runtime_dependency(%q<rack-oauth2>, [">= 0.8.0"])
      s.add_development_dependency(%q<rake>, [">= 0.8"])
      s.add_development_dependency(%q<rcov>, [">= 0.9"])
      s.add_development_dependency(%q<rspec>, [">= 2"])
      s.add_development_dependency(%q<webmock>, [">= 1.6.2"])
    else
      s.add_dependency(%q<httpclient>, [">= 2.2.0.2"])
      s.add_dependency(%q<rack-oauth2>, [">= 0.8.0"])
      s.add_dependency(%q<rake>, [">= 0.8"])
      s.add_dependency(%q<rcov>, [">= 0.9"])
      s.add_dependency(%q<rspec>, [">= 2"])
      s.add_dependency(%q<webmock>, [">= 1.6.2"])
    end
  else
    s.add_dependency(%q<httpclient>, [">= 2.2.0.2"])
    s.add_dependency(%q<rack-oauth2>, [">= 0.8.0"])
    s.add_dependency(%q<rake>, [">= 0.8"])
    s.add_dependency(%q<rcov>, [">= 0.9"])
    s.add_dependency(%q<rspec>, [">= 2"])
    s.add_dependency(%q<webmock>, [">= 1.6.2"])
  end
end
