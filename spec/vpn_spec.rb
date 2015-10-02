require "spec_helper"
require "ostruct"

describe Vpn do

  let(:vpn) { Vpn.new }
  let(:pid) { 12345 }

  before(:each) do 
    allow(vpn).to receive(:system)
  end

  describe "up" do

    context "when vpn is down" do
      before(:each) { mock_vpn_status(:down) }

      it "fails if no server in config" do
        expect{
          vpn.up make_config(server: nil)
        }.to raise_error SystemExit, /must specify a server/
      end

      it "prompts for password and calls sudo openconnect" do
        $stdin = StringIO.new "it's spaced out"
        config = make_config(opts: {foo: "bar", baz: true})
        vpn.up config
        expect(vpn).to have_received(:system).with "stty -echo"
        expect(vpn).to have_received(:system).with "stty echo"
        expect(vpn).to have_received(:system).with /sudo .* openconnect .*--foo=bar --baz .*#{config.opts['server']} <<< it\\'s\\ spaced\\ out/
      end
    end

    context "when vpn is already up" do
      before(:each) { mock_vpn_status(:up) }

      it "aborts" do
        expect{
          vpn.up make_config
        }.to raise_error SystemExit, /vpn is already up/
      end
    end

    private

    def make_config(server: "vpn.example.com", opts: {})
      OpenStruct.new(
        site: "site",
        opts: opts.merge("server" => server),
        filename: "/dummy/filename"
      )
    end
  end

  describe "down" do
    context "when vpn is up" do
      before(:each) { mock_vpn_status(:up) }

      it "sends HUP signal to openconnect process" do
        vpn.down
        expect(vpn).to have_received(:system).with /sudo .* kill -s HUP #{pid}/
      end
    end

    context "when vpn is already down" do
      before(:each) { mock_vpn_status(:down) }
      it "aborts" do
        expect {
          vpn.down
        }.to raise_error SystemExit, /vpn is already down/
      end
    end


  end

  describe "reset" do
    let(:prior_status) { :up }

    context "when vpn is up" do
      before(:each) { mock_vpn_status(:up) }
      it "sends USR2 signal to openconnect process" do
        vpn.reset
        expect(vpn).to have_received(:system).with /sudo .* kill -s USR2 #{pid}/
      end
    end

    context "when vpn is down" do
      before(:each) { mock_vpn_status(:down) }
      it "aborts" do
        expect {
          vpn.reset
        }.to raise_error SystemExit, /vpn is not up/
      end
    end

  end

  describe "connected?" do
    
    context "when vpn is up" do
      context "(no permission for process)" do
        before(:each) { mock_vpn_status(:up_noperm) }
        it { expect(vpn.connected?).to be_truthy }
      end
      context "(permission for process)" do
        before(:each) { mock_vpn_status(:up_permok) }
        it { expect(vpn.connected?).to be_truthy }
      end
    end

    context "when vpn is down" do
      context "(no pidfile)" do
        before(:each) { mock_vpn_status(:down_nopidfile) }
        it { expect(vpn.connected?).to be_falsey }
      end
      context "(no process)" do
        before(:each) { mock_vpn_status(:down_noprocess) }
        it { expect(vpn.connected?).to be_falsey }
      end
    end

  end


  def mock_vpn_status(status)
    allow(File).to receive(:read).with("/tmp/openconnect.pid") {
      case status
      when :down_nopidfile then raise Errno::ENOENT
      else pid
      end
    }
    allow(Process).to receive(:kill).with(0, pid) {
      case status
      when :up, :up_noperm then raise Errno::EPERM
      when :up_permok then true
      when :down, :down_noprocess then raise Errno::ESRCH
      end
    }
  end

end
