# Copyright 2018 Google, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# bundle exec ruby uptime_check.rb

require 'pp'

# [START monitoring_uptime_check_list_ips]
def list_ips
  require "google/cloud/monitoring/v3"
  client = Google::Cloud::Monitoring::V3::UptimeCheck.new

  # Iterate over all results.
  client.list_uptime_check_ips.each do |element|
    puts "#{element.location} #{element.ip_address}"
  end
end
# [END monitoring_uptime_check_list_ips]

# [START monitoring_uptime_check_create]
def create_uptime_check_config project_id: nil, host_name: nil, display_name: nil
  require "google/cloud/monitoring/v3"

  client = Google::Cloud::Monitoring::V3::UptimeCheck.new
  project_name = Google::Cloud::Monitoring::V3::UptimeCheckServiceClient.project_path(project_id)
  config = {
    display_name: display_name.nil? ? 'New uptime check' : display_name,
    monitored_resource: { 
      type: 'uptime_url',
      labels: {'host' => host_name.nil? ? 'example.com': host_name }
    },
    http_check: { path:  '/', port: 80 },
    timeout: { seconds: 10 },
    period: { seconds: 300 }
  }
  client = Google::Cloud::Monitoring::V3::UptimeCheck.new
  new_config = client.create_uptime_check_config(project_name, config)
  puts new_config.name
  return new_config
end
# [END monitoring_uptime_check_create]

# [START monitoring_uptime_check_delete]
def delete_uptime_check_config(config_name)
  require "google/cloud/monitoring/v3"

  client = Google::Cloud::Monitoring::V3::UptimeCheck.new
  client.delete_uptime_check_config(config_name)
  puts "Deleted #{config_name}"
end
# [END monitoring_uptime_check_delete]


# [START monitoring_uptime_check_list_configs]
def list_uptime_check_configs(project_id)
  require "google/cloud/monitoring/v3"

  client = Google::Cloud::Monitoring::V3::UptimeCheck.new
  project_name = Google::Cloud::Monitoring::V3::UptimeCheckServiceClient.project_path(project_id)
  configs = client.list_uptime_check_configs(project_name)

  configs.each { |config| puts config.name }
end
# [END monitoring_uptime_check_list_configs]

# [START monitoring_uptime_check_get]
def get_uptime_check_config(config_name)
  require "google/cloud/monitoring/v3"

  client = Google::Cloud::Monitoring::V3::UptimeCheck.new
  config = client.get_uptime_check_config(config_name)
  pp config.to_hash
  return config
end
# [END monitoring_uptime_check_get]

# [START monitoring_uptime_check_update]
def update_uptime_check_config config_name: nil, new_display_name: nil, new_http_check_path: nil
  require "google/cloud/monitoring/v3"

  client = Google::Cloud::Monitoring::V3::UptimeCheck.new
  puts "config_name: #{config_name}"
  puts "new_display_name: #{new_display_name}"
  puts "new_http_check_path: #{new_http_check_path}"
  config = { name: config_name }
  field_mask = { paths: []}
  if not new_display_name.nil? then
    field_mask[:paths].push('display_name')
    config[:display_name] = new_display_name
  end
  if false and not new_http_check_path.nil? then
    field_mask.paths.push('http_check.path')
    config[:http_check] = {path: new_http_check_path }
  end
  pp config
  pp field_mask.to_hash
  client.update_uptime_check_config(config, field_mask)
end
# [END monitoring_uptime_check_update]

if __FILE__ == $PROGRAM_NAME
  command    = ARGV.shift

  case command
  when "list_ips"
    list_ips()
  when "create_uptime_check"
    create_uptime_check_config(
      project_id: ARGV.shift.to_s,
      host_name: ARGV.shift.to_s,
      display_name: ARGV.shift.to_s
    )
  when "delete_uptime_check"
    delete_uptime_check_config(ARGV.shift.to_s)
  when "list_uptime_check"
    list_uptime_check_configs(ARGV.shift.to_s)
  when "get_uptime_check"
    get_uptime_check_config(ARGV.shift.to_s)
  when "update_uptime_check"
    update_uptime_check_config(
      config_name: ARGV.shift.to_s,
      new_display_name: ARGV.shift.to_s,
      new_http_check_path: ARGV.shift.to_s
    )
  else
    puts <<-usage
Usage: ruby uptime_check.rb <command> [arguments]

Commands:
  list_ips  Lists the ip address of uptime check servers.
  create_uptime_check  <project_id> <host_name> <display_name> Create a new uptime check
  delete_uptime_check  <name>  Deletes an uptime check.
  get_uptime_check  <name>  Gets the full details for an uptime check.
  list_uptime_check  <project_id>  Lists the uptime checks.
  update_uptime_check  <name> <new_display_name> <new_http_path>

Environment variables:
  GOOGLE_APPLICATION_CREDENTIALS set to the path to your JSON credentials
    usage
  end
end
