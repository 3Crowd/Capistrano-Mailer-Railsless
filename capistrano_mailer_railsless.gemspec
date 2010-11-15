Gem::Specification.new do |s|
  s.name = "capistrano_mailer_railsless"
  s.version = "3.2.7"

  s.authors = ["3Crowd Technologies, Inc.", "Justin Lynn", "Peter Boling", "Dave Nolan"]

  s.date = %q{2010-04-29}

  s.description = %q{Capistrano Deployment Email Notification without Rails.  Keep the whole team informed of each release! Graciously derived from capistrano_mailer.}

  s.email = ["eng@3crowd.com"]

  s.extra_rdoc_files = [
    "README.rdoc"
  ]

  s.files = Dir.glob("{lib,views}/**/*") + %w(README.rdoc Rakefile VERSION.yml about.yml capistrano_mailer_railsless.gemspec init.rb)

  s.homepage = %q{http://github.com/3crowd/capistrano_mailer_railsless}

  s.rdoc_options = ["--charset=UTF-8"]

  s.require_paths = ["lib"]

  s.summary = %q{Capistrano Deployment Email Notification, not requiring Rails}

  s.test_files = [
    "test/build_gem_test.rb"
  ]

  s.add_dependency('actionmailer', '>=3.0.0')
  s.required_rubygems_version	= ">= 1.3.6"

end

