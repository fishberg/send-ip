# send-ip
Small script for facilitating sending dynamic IP address to a static server periodically.

## Client Setup
1. Set destination in `~/.ssh/config`:
```
Host SEND-IP-DESTINATION
        HostName HOSTNAME
        Port 22
        User USERNAME
```

2. Copy repo to `/`:
```
cd send-ip
sudo rsync -a --chown=$(id -un):$(id -gn) . /send-ip
```

3. Configure `crontab`:
```
sudo crontab -e -u $USER
```
Either:
```
0 * * * * /send-ip/doit.sh >> /send-ip/crontab.log 2>&1
@reboot sleep 300 && /send-ip/doit.sh >> /send-ip/crontab.log 2>&1
```
where:
- `0 * * * *` = every hour
- `*/5 * * * *` = every 5 minutes
- `@reboot sleep 300 && ...` = wait 5 minutes after reboot

You can change parameters (e.g., `IFNAME`) in `crontab` as such:
```
0 * * * * IFNAME="wlx4086cb22d9fb" /send-ip/doit.sh >> /send-ip/crontab.log 2>&1
```

## Server Setup
1. Copy repo to `/`
```
cd send-ip
sudo rsync -a --chown=$(id -un):$(id -gn) . /send-ip
```

2. Configure to `~/.ssh/authorized_keys` to allow only `rsync` write-only to specific dir (
```
command="rrsync -wo /send-id/logs" ssh-ed25519 AAAA...
```
where:
- `rrsync` is restricted rsync (see `man rrsync`)
