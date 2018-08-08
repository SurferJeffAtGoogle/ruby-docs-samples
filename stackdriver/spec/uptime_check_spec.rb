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

# bundle exec rspec

require_relative "../uptime_check"
require "rspec"

describe "Stackdriver uptime check" do
  before :all do
    @project_id = ENV["GOOGLE_CLOUD_PROJECT"]
    if @project_id.nil? then
      raise "Set the environment variable GOOGLE_CLOUD_PROJECT."
    end
    @configs = [create_uptime_check_config(project_id:@project_id.to_s)]
  end

  after :all do
    @configs.each { |config| delete_uptime_check_config(config.name)}
  end

  it "list_ips" do
    expect { list_ips() }.to output(/Singapore/).to_stdout
  end
end
