require 'rubygems' unless defined?(Rubygems)
require 'capistrano' unless defined?(Capistrano)

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano/railsless_mailer requires Capistrano 2"
end

require 'action_mailer' unless defined?(ActionMailer)

require 'cap_railsless_mailer' unless defined?(CapRailslessMailer)


module Capistrano
  class Configuration
    module RailslessCapistranoMailer
      def send_notification_email(cap, config = {}, *args)
        if CapRailslessMailer.respond_to? :notification_email
          CapRailslessMailer.notification_email(cap, config, args).deliver
        else
          CapRailslessMailer.deliver_notification_email(cap, config, args)
        end
      end
    end

    include CapistranoRailslessMailer
  end
end

Capistrano.plugin :railsless_mailer, Capistrano::Configuration::RailslessCapistranoMailer
