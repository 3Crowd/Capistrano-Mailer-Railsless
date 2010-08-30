require 'rubygems' unless defined?(Rubygems)
require 'capistrano' unless defined?(Capistrano)

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano/mailer requires Capistrano 2"
end

require 'action_mailer' unless defined?(ActionMailer)

require 'cap_mailer' unless defined?(CapMailer)


module Capistrano
  class Configuration
    module CapistranoMailer
      def send_notification_email(cap, config = {}, *args)
        if CapMailer.respond_to? :notification_email
          CapMailer.notification_email.deliver(cap, config, args)
        else
          CapMailer.deliver_notification_email(cap, config, args)
        end
      end
    end

    include CapistranoMailer
  end
end

Capistrano.plugin :mailer, Capistrano::Configuration::CapistranoMailer
