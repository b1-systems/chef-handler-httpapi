Httpapi chef handler
===========

This is a simple Chef report handler that reports status of a Chef run
to any API via net/http.

* http://wiki.opscode.com/display/chef/Exception+and+Report+Handlers

Kudos to the following chef_handlers for their inspirations:
* https://github.com/portertech/chef-irc-snitch
* https://github.com/jblaine/syslog_handler
* https://github.com/kisoku/chef-handler-mail


Requirements
============

Tested Platform: Linux

Uses the libraries `net_http`, `uri` and `openssl`.


Installation
============

    gem install chef-handler-httpapi


Usage
============

You can send data to an API via the http post method.

Therefore you have to define which data elements should be sent.

"api_data_message" is the name for the KEY including the message text.

"api_data_success/failed" are the HASHes you want to send as the post data (in addition to the "message" HASH).


Append the following to your Chef client configs, usually at `/etc/chef/client.rb`

    require "chef-handler-httpapi"

	api_url = "https://myfanceapi/logging/object"
	api_user = myfanceuser
	api_pass = myfancepass

	# ssl tweaks
	(api_ssl_version = :SSLv3)
	(api_ssl_verify = "none")

	# name for data_message KEY
	api_data_message = "message"

	# keys and values for successful run
	api_data_success = {
		"state" => "INFO",
		"class" => "chef-client"
	}

	# keys and values for failed run
	api_data_failed = {
		"state" => "FAILED",
		"class" => "chef-client"
	}

	Httpapi_handler = Httpapi.new(api_url, api_user, api_pass, api_ssl_verify, api_ssl_version, api_data_message, api_data_success, api_data_failed)
	report_handlers << Httpapi_handler            # run at the end of a successful run
	exception_handlers << Httpapi_handler         # run at the end of a failed run


Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


License and Author
============

copyright: B1 Systems GmbH <info@b1-systems.de>, 2016

license:   GPLv3+, http://www.gnu.org/licenses/gpl-3.0.html

author:    Eike Waldt <waldt@b1-systems.de>
