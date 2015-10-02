require "spec_helper"

describe Config do

  context "without a config file" do
    before(:each) { mock_config(nil) }

    it "aborts" do
      expect { Config.new("site") }.to raise_error SystemExit, %r{Could not open config file ~/.vpn}
    end
  end

  context "with a config file" do
    before(:each) { mock_config }

    it "uses first site if none specified" do
      config = Config.new(nil)
      expect(config.site).to eq "site0"
      expect(config.opts).to eq( {"opt0" => "val0"} )
    end

    it "uses specified site" do
      config = Config.new("site1")
      expect(config.site).to eq("site1")
      expect(config.opts).to eq( {"opt1" => "val1"} )
    end

    it "aborts if unlisted site specified" do
      expect { Config.new("nonesuch") }.to raise_error SystemExit, %r{nonesuch not listed in ~/.vpn}
    end
  end

  def mock_config(data = {"site0" => { "opt0" => "val0"}, "site1" => { "opt1" => "val1" }})
    allow(IO).to receive(:read).with(ENV['HOME']+"/.vpn") {
      case data
      when nil then raise Errno::ENOENT
      else data.to_yaml
      end
    }
  end

end
