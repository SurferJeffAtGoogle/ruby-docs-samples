# bundle exec ruby uptime_check.rb
require "google/cloud/monitoring/v3"

def list_ips
  uptime_check_service_client = Google::Cloud::Monitoring::V3::UptimeCheck.new

  # Iterate over all results.
  uptime_check_service_client.list_uptime_check_ips.each do |element|
    puts "#{element.location} #{element.ip_address}"
  end
end

if __FILE__ == $PROGRAM_NAME
  command    = ARGV.shift

  case command
  when "list_ips"
    list_ips()
  when "inspect_file"
    inspect_file(
      project_id: project_id,
      filename: ARGV.shift.to_s,
      max_findings: ARGV.shift.to_i
    )
  else
    puts <<-usage
Usage: ruby uptime_check.rb <command> [arguments]

Commands:
  list_ips <content> <max_findings> Lists the ip address of uptime check servers.
  inspect_file <filename> <max_findings> Inspect a local file.

Environment variables:
  GOOGLE_APPLICATION_CREDENTIALS set to the path to your JSON credentials
    usage
  end
end
