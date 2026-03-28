# send-ip
Small script and set of instructions for periodically sending a dynamic IP address to a static server.

## Client Setup
### 1. Set server destination in `~/.ssh/config`:
```
Host SEND-IP-DESTINATION
        HostName HOSTNAME
        Port 22
        User USERNAME
```

### 2. Copy/link repo to `/`:
```
cd send-ip
sudo rsync -a --chown=$(id -un):$(id -gn) . /send-ip
```
-or-
```
cd send-ip
sudo ln -s . /send-ip
sudo chown -R $(id -un):$(id -gn) /send-ip
```

### 3. Configure `crontab`:
```
sudo crontab -e -u $USER
```
Use either:
```
0 * * * * /send-ip/doit.sh >> /send-ip/crontab.log 2>&1
@reboot sleep 300 && /send-ip/doit.sh >> /send-ip/crontab.log 2>&1
```
where:
- `0 * * * *` = every hour
- `*/5 * * * *` = every 5 minutes
- `* * * * *` = every 1 minute
- `@reboot sleep 300 && ...` = wait 5 minutes after reboot

You can also change parameters (e.g., `IFNAME`) in `crontab` as such:
```
0 * * * * IFNAME="wlx4086cb22d9fb" /send-ip/doit.sh >> /send-ip/crontab.log 2>&1
```

## Server Setup
### 1. Copy/link repo to `/`:
```
cd send-ip
sudo rsync -a --chown=$(id -un):$(id -gn) . /send-ip
```
-or-
```
cd send-ip
sudo ln -s . /send-ip
sudo chown -R $(id -un):$(id -gn) /send-ip
```

### 2. Configure `~/.ssh/authorized_keys`:
This restricts key to only use `rsync`, only have write access, and only to a specific directory.
```
command="rrsync -wo /send-id/logs" ssh-ed25519 AAAA...
```
where:
- `rrsync` is restricted rsync (see `man rrsync`)
