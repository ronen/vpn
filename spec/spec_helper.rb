require "simplecov"
require "pathname"
SimpleCov.start

load Pathname(__FILE__).dirname.parent + "bin/vpn"

RSpec.configure do |config|
  config.around(:each) do |example|
    begin
      $stdin = StringIO.new
      $stdout = StringIO.new
      $stderr = StringIO.new
      example.run
    ensure
      $stdin = STDIN
      $stdout = STDOUT
      $stderr = STDERR
    end
  end
end
