# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{attr_required}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{nov matake}]
  s.date = %q{2010-12-05}
  s.description = %q{attr_required and attr_optional}
  s.email = %q{nov@matake.jp}
  s.extra_rdoc_files = [%q{LICENSE}, %q{README.rdoc}]
  s.files = [%q{LICENSE}, %q{README.rdoc}]
  s.homepage = %q{http://github.com/nov/attr_required}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.3}
  s.summary = %q{attr_required and attr_optional}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0.8"])
      s.add_development_dependency(%q<rcov>, [">= 0.9"])
      s.add_development_dependency(%q<rspec>, [">= 2"])
    else
      s.add_dependency(%q<rake>, [">= 0.8"])
      s.add_dependency(%q<rcov>, [">= 0.9"])
      s.add_dependency(%q<rspec>, [">= 2"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0.8"])
    s.add_dependency(%q<rcov>, [">= 0.9"])
    s.add_dependency(%q<rspec>, [">= 2"])
  end
end
