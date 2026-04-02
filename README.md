# send-ip
Small script and set of instructions for periodically sending a dynamic IP address to a static server.

## Client Setup (i.e., client pushes IP to server)
### 1. Set server destination in `~/.ssh/config`:
```
Host SEND-IP-DESTINATION
        HostName HOSTNAME
        Port 22
        User USERNAME
```

### 2. Clone repo on client
We are assuming you're cloning this repo to `~/send-ip`:
```
git clone https://github.com/fishberg/send-ip.git
```

### 3. Configure `crontab`:
```
sudo crontab -e -u $USER
```
Use either:
```
0 * * * * IFNAME="wlx4086cb22d9fb" LOGDIR="$HOME/send-ip/logs" $HOME/send-ip/doit.sh >> $HOME/send-ip/crontab.log 2>&1
@reboot sleep 300 && IFNAME="wlx4086cb22d9fb" LOGDIR="$HOME/send-ip/logs" $HOME/send-ip/doit.sh >> $HOME/send-ip/crontab.log 2>&1
```
where:
- `0 * * * *` = every hour
- `*/5 * * * *` = every 5 minutes
- `* * * * *` = every 1 minute
- `@reboot sleep 300 && ...` = wait 5 minutes after reboot
- `IFNAME` is the interface name
- `LOGDIR` is the path to the `send-ip/logs` folder

## Server Setup (i.e., server receives IP from client)
### 1. Clone repo
Again, we are assuming you're cloning this repo to `~/send-ip`:
```
git clone https://github.com/fishberg/send-ip.git
```

### 2. Configure `~/.ssh/authorized_keys`:
This restricts key to only use `rsync`, only have write access, and only to a specific directory.
```
command="rrsync -wo $HOME/send-id/logs" ssh-ed25519 AAAA...
```
where:
- `rrsync` is restricted rsync (see `man rrsync`)

## Test Pipeline

### 1. On the client
```
touch TESTFILE
rsync -azP TESTFILE SEND-IP-DESTINATION:.
```
- Make sure you've manually used `rsync` or `ssh` to connect to `SEND-IP-DESTINATION` at least once to confirm the host key (the "authenticity of host" prompt). If you haven't, that interactive `yes/no/[fingerprint]` prompt will cause the automated `rsync` command to fail.

### 2. On the server
```
ls ~/send-ip/logs/TESTFILE
```

### 3. Remove TESTFILE from both computers
```
rm TESTFILE
```
