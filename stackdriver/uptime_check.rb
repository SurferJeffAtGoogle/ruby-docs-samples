# bundle exec ruby uptime_check.rb
require "google/cloud/monitoring/v3"

uptime_check_service_client = Google::Cloud::Monitoring::V3::UptimeCheck.new

# Iterate over all results.
uptime_check_service_client.list_uptime_check_ips.each do |element|
  # Process element.
end

# Or iterate over results one page at a time.
uptime_check_service_client.list_uptime_check_ips.each_page do |page|
  # Process each page at a time.
  page.each do |element|
    p element
    # Process element.
  end
end