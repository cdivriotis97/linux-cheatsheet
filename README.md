# Useful commands


### Space 
Check disk space:
```
df -g
```

Check lvm space:
```
df -h
```

Check repository space 
```
du . --max-depth=1 -h
```

Dossiers / fichiers volumineux
```
du -a | sort -nr | head -n 5
du -hs /* | sort -rh | head -5
du -Sh | sort -rh | head -5
```

### Zabbix
```
firewall-cmd --permanent --add-port=10050/tcp--add-source=<IP>:<PORT>
firewall-cmd --reload
```

```
zabbix_agentd -V
```

```
su -s /bin/bash zabbix
```

Nettoyer les logs de journalctl
```
journalctl --disk-usage
journalctl --vacuum-time=2d
journalctl --vacuum-size=1G
journalctl --verify
```

### Certificate
Convert CRT to PEM
```
openssl x509 -in <filename>.crt -out <filename>.der -outform DER
openssl x509 -in <filename>.der -inform DER -out <filename>.pem -outform PEM
```

Convert CER to CRT
```
openssl x509 -inform PEM -in <filename>.cer -out <filename>.crt
```

Read information from PEM
```
openssl x509 -text -in <filename>.pem
```

### NMAP
Scan a host & get all algos used by SSH
```
nmap --script ssh2-enum-algos -sV -p <PORT> <IP>
```

### Mail
Test sendmail
```
echo "Subject: sendmail test" | sendmail -v <MAIL>
```

### TCPDUMP
Capture network traffic
```
tcpdump -i any host <IP> -vvvvv -w /tmp/capture.pcap
```

### YUM / DNF
Lock package
```
yum -y install yum-plugin-versionlock
yum versionlock <PACKAGE>
```

### Files manipulation
Find a work in the current repo
```
grep -nr '*word*' .
```

List directories with find
```
find . -ls
```

Find user with blank password
```
getent shadow | grep '^[^:]*:.\?:' | cut -d: -f1
```

Find empty files
```
find ~ -type f -empty
```

List just directories
```
find ~/Public -type d
```

Find by content
```
find ~/Documents/ -name "*txt" -exec grep -Hi content {} \;
```

Find a single file by approximate name
```
find / -iname "*foo*txt" 2>/dev/null
```

### SCP 
Get a file with scp
```
scp -P <PORT> <USERNAME>@<HOSTNAME>:<PATH_DEST> <PATH_SRC>
```

### History
```
history -d <LINE>
```

```
history -w
```

```
cat /dev/null > ~/.bash_history && history -c && exit
```

### TAR command

Untar
```
tar -xvzf <file>.tat.gz
```


### Ansible

Create role
```
ansible-galaxy role init 
```

Send a command from ansible
```
ansible groupe -a "cmd" -u mon_user_ansible --become
```


### Monitoring commands
Get status from specific process
```
htop -p pid,pid,pid
```

Get IO from device files
```
iostat -xN --human 5
```


### Firewall
Check live blocking traffic
```
dmesg -e -w
```
