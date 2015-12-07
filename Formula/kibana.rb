class Kibana < Formula
  homepage "https://www.elastic.co/products/kibana"
  version "4.3.0"
  url "https://download.elastic.co/kibana/kibana/kibana-4.3.0-darwin-x64.tar.gz"
  sha1 "ba16b784eeab7fbd96367eb3f8e441812f83f7b6"

  depends_on "elasticsearch"

  head "http://download.elastic.co/kibana/kibana-snapshot/kibana-5.0.0-snapshot-darwin-x64.tar.gz"

  def install
    rm_f Dir["bin/*.bat"]

    prefix.install Dir["*"]

    # Bind to localhost
    inreplace "#{prefix}/config/kibana.yml", "host: \"0.0.0.0\"", "host: \"127.0.0.1\""

    # Move configs to local etc and symlink to current version
    (etc/"kibana").install Dir[prefix/"config/*"]
    (prefix/"config").rmtree
    ln_s etc/"kibana", prefix/"config"
  end

  def caveats; <<-EOS.undent
    Using:  http://127.0.0.1:5601/
    Logs:   #{var}/log/kibana.log
    Config: #{etc}/kibana
  EOS
  end

  plist_options :manual => 'kibana'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{prefix}/bin/kibana</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kibana.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/kibana.log</string>
      </dict>
    </plist>
  EOS
  end
end
