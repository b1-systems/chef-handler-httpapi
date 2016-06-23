# copyright: B1 Systems GmbH <info@b1-systems.de>, 2016
# license:   GPLv3+, http://www.gnu.org/licenses/gpl-3.0.html
# author:    Eike Waldt <waldt@b1-systems.de>

require 'rubygems'
require 'chef'
require 'chef/handler'

require "net/http"
require "uri"
require "openssl"

class Httpapi < Chef::Handler
def initialize(api_url, api_user, api_pass, api_ssl_verify, api_ssl_version, api_data_message, api_data_success, api_data_failed)
    @api_url = api_url
    @api_ssl_verify = api_ssl_verify
    @api_ssl_version = api_ssl_version
    @api_user = api_user
    @api_pass = api_pass
    @api_data_message = api_data_message
    @api_data_success = api_data_success
    @api_data_failed = api_data_failed
  end

  def formatted_run_list
    node.run_list.map { |r| r.type == :role ? r.name : r.to_s }.join(", ")
  end

  def report
      uri = URI(@api_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.set_debug_output $stderr
      http.use_ssl = true
      if @api_ssl_verify == "none"
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.ssl_version = @api_ssl_version

      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth(@api_user, @api_pass)

      if run_status.success?
        api_data_info = { @api_data_message => "Chef successfull on #{node.name}\n\nrun_list:\n#{formatted_run_list}\n\ntotal_resources:\n#{run_status.all_resources.length}\n\nupdated_resources:\n#{run_status.updated_resources.length}\n\nelapsed_time:\n#{run_status.elapsed_time}" }
        api_data = @api_data_success.merge(api_data_info)
      else
        api_data_info = { @api_data_message => "Chef failed on #{node.name}\n\nrun_list:\n#{formatted_run_list}\n\nexception:\n#{run_status.exception}\n\nbacktrace:\n#{Array(backtrace).join('\n')}" }
        api_data = @api_data_failed.merge(api_data_info)
      end

      request.body = URI.encode_www_form(api_data)
      response = http.request request
      puts response
    end
end
