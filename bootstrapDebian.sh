#!/bin/sh

# Update package lists
sudo apt update

# Install OpenSSH and Ansible
sudo apt install -y openssh-server ansible

# Configure SSH daemon
sudo sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Restart SSH daemon
sudo systemctl restart ssh

# Download the keys file from GitHub
curl -s https://github.com/bondjames12.keys -o /tmp/bondjames12.keys

# Append " colinweber" to the first line of the downloaded file
sed -i '1s/$/ colinweber/' /tmp/bondjames12.keys

# Extract the first line from the modified file
key_line=$(head -n 1 /tmp/bondjames12.keys)

# Create the .ssh directory for the colinweber user if it doesn't exist
sudo mkdir -p /home/colinweber/.ssh

# Append the key line to the authorized_keys file
echo "$key_line" | sudo tee -a /home/colinweber/.ssh/authorized_keys > /dev/null

# Set proper permissions for the .ssh directory and authorized_keys file
sudo chown -R colinweber:colinweber /home/colinweber/.ssh
sudo chmod 700 /home/colinweber/.ssh
sudo chmod 600 /home/colinweber/.ssh/authorized_keys

# Clean up the temporary file
rm /tmp/bondjames12.keys

echo "Script execution completed."
