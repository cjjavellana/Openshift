#!/usr/bin/ruby

require 'net/http'
require 'thread'
require 'logger'
require 'json'

queue = Queue.new
logger = Logger.new(STDOUT)
poison = Object.new
consumers_count = 7

logger.info "Setting Up Consumers.."
consumers = consumers_count.times.map do
  Thread.new do
    until (item = queue.pop) == poison
      uri = URI('http://10.92.141.178:8787/api/v1/execProcess')

      args = JSON.parse(item)

      output_filename = "#{args[1].gsub(' ', '_')}_#{args[3].gsub(' ', '_')}.log"

      req = Net::HTTP::Post.new(uri.path, initheader = {"Content-type" => "application/json"})
      req.body = { serviceToInvoke: "xxx.svc", jvmParams: [ "-Dconfig.location=http://someconfig.com", "-Xms3g", "-Xmx3g" ], args: args }.to_json
      res = Net::HTTP.start(uri.hostname, uri.port, :read_timeout => 7200) do |http|
        http.request(req)
      end

      output = File.open(output_filename, 'w')
      output << res.body
      output.close()

    end
  end
end

logger.info "Reading conf..."
File.open("./conf.conf", "r") do |f|
  f.each_line do |line|
    queue << line unless line.strip.empty?
  end
end

consumers_count.times { queue << poison }
consumers.each(&:join)
