class CapRailslessMailer < ActionMailer::Base

  @@default_base_config ||= {
    :sender_address           => %("Capistrano Deployment" <capistrano.mailer@example.com>),
    :recipient_addresses      => [],
    # Customize the subject line
    :subject_prepend          => "[DEPLOYMENT] ",
    :subject_append           => nil,
    # Include which sections of the deployment email?
    :sections                 => %w(deployment release_data source_control latest_release previous_release other_deployment_info extra_information),
    :site_name                => "",
    :format                   => :html,
    :view_path                => "#{File.dirname(__FILE__)}/../views"
  }

  cattr_accessor :default_base_config
  attr_accessor  :config, :options
  attr_accessor  :date, :time, :inferred_command, :task_name, :repo_end

  def self.configure(&block)
    yield @@default_base_config

    self.view_paths = [default_base_config[:view_path]]

    default :format => default_base_config[:format].to_s
    default :from => default_base_config[:sender_address]
  end

  def self.reloadable?() false end

  def notification_email(cap, config = {}, *args)
    @options = { :release_data => {}, :extra_information => {}, :data => {} }.merge(args.extract_options!)
    @config  = default_base_config.merge(config.reverse_merge({
          :task_name          => cap.task_name,
          :application        => cap.application,
          :repository         => cap.repository,
          :scm                => cap.scm,
          :deploy_via         => cap.deploy_via,
          :deploy_to          => cap.deploy_to,
          :revision           => cap.revision,
          :real_revision      => cap.real_revision,
          :release_name       => cap.release_name,
          :version_dir        => cap.version_dir,
          :shared_dir         => cap.shared_dir,
          :current_dir        => cap.current_dir,
          :releases_path      => cap.releases_path,
          :shared_path        => cap.shared_path,
          :current_path       => cap.current_path,
          :release_path       => cap.release_path,
          :releases           => cap.releases,
          :current_release    => cap.current_release,
          :previous_release   => cap.previous_release,
          :current_revision   => cap.current_revision,
          :latest_revision    => cap.latest_revision,
          :previous_revision  => cap.previous_revision,
          :run_method         => cap.run_method,
          :latest_release     => cap.latest_release,
          :user		      => cap.user,
          :stage	      => (cap.respond_to?(:stage) ? cap.stage : "" )
    }))

    @date             = Date.today.to_s
    @time             = Time.now.strftime("%I:%M %p").to_s
    @inferred_command = "cap #{@config[:task_name]}"
    @task_name        = @config[:task_name] || "unknown"
    @site_name        = @config[:site_name]
    @sections         = @config[:sections]
    @section_data     = section_data_hash
    @site_url         = @config[:site_url]
    @application      = @config[:application]
    @repo_end         = repo_end

    mail(:to => @config[:recipient_addresses], :subject => subject_line)
  end

  private

    def repo_end
      repo  = @config[:repository]
      x     = repo.include?('/') ? repo.rindex('/') - 1 : repo.length
      front = repo.slice(0..x)
      back  = repo.sub(front, '')
      unless back == 'trunk'
        x = front.include?('/') ? front.rindex('/') - 1 : front.length
        front = front.slice(0..x)
      end

      repo.sub(front, '')
    end

    def subject_line
      #The subject prepend and append are useful for people to setup filters in mail clients.
      user = config[:user] ? " by #{config[:user]}" : ""
      middle = config[:subject] ? config[:subject] : "[#{repo_end}]#{!config[:stage].nil? ? '[' + config[:stage].to_s.upcase + ']' : ''} #{inferred_command}#{user}"
      "#{config[:subject_prepend]}#{middle}#{config[:subject_append]}"
    end

    def section_data_hash
      {
        :deployment             => section_hash_deployment,
        :source_control         => section_hash_source_control,
        :latest_release         => section_hash_latest_release,
        :previous_release       => section_hash_previous_release,
        :other_deployment_info  => section_hash_other_deployment_info,
        :release_data           => options[:release_data],
        :extra_information      => options[:extra_information]
      }
    end

    def section_hash_deployment
      {
        :date             => date,
        :time             => time,
        :task_name        => task_name,
        :inferred_command => inferred_command,
        :host             => config[:host],
        :release_name     => config[:release_name]
      }
    end

    def section_hash_source_control
      {
        :revision         => config[:revision],
        :released         => repo_end,
        :repository       => config[:repository],
        :branch           => config[:branch],
        :scm              => config[:scm],
        :deploy_via       => config[:deploy_via],
        :deploy_to        => config[:deploy_to]
      }
    end

    def section_hash_latest_release
      {
        :latest_release   => config[:latest_release],
        :latest_revision  => config[:latest_revision],
        :release_path     => config[:release_path],
        :real_revision    => config[:real_revision],
        :current_path     => config[:current_path]
      }
    end

    def section_hash_previous_release
      {
        :current_release    => config[:current_release],
        :current_revision   => config[:current_revision],
        :previous_release   => config[:previous_release],
        :previous_revision  => config[:previous_revision],
        :releases           => config[:releases]
      }
    end

    def section_hash_other_deployment_info
      {
        :version_dir    => config[:version_dir],
        :shared_dir     => config[:shared_dir],
        :current_dir    => config[:current_dir],
        :releases_path  => config[:releases_path],
        :shared_path    => config[:shared_path],
        :run_method     => config[:run_method],
        :ip_address     => config[:ip_address]
      }
    end
end
