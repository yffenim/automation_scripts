## Week 5 Homework Submission File: Archiving and Logging Data

Please edit this file by adding the solution commands on the line below the prompt.

Save and submit the completed file for your homework submission.

---

### Step 1: Create, Extract, Compress, and Manage tar Backup Archives

1. Command to **extract** the `TarDocs.tar` archive to the current directory: `tar -xvf TarDocs.tar`

`tar` command has optional dashes so the you can also use `tar xvf`. The `x` flag tells `tar` to extract, the `v` is for verbose, and `f` is for file. 

2. Command to **create** the `Javaless_Doc.tar` archive from the `TarDocs/` directory, while excluding the `TarDocs/Documents/Java` directory: `tar cvf Javaless_Doc.tar --exclude='TarDocs/Documents/Java' TarDocs`

`c` flag tells `tar` to create a file (as opposed to extracting it). The file name to be created follows the flags. `--exclude` is written in longform as a flag, likely as to not confuse the user with `extract` (both start with e's; probably also why `x` was chosen as shortform for `--extract`). 

3. Command to ensure `Java/` is not in the new `Javaless_Docs.tar` archive:

Use `vim Javaless_Doc.tar` then `/Java` to search the file.
Or use: `tar -tf Javaless_Doc.tar | grep Java*`


**Bonus** 
- Command to create an incremental archive called `logs_backup_tar.gz` with only changed files to `snapshot.file` for the `/var/log` directory:

`sudo tar --listed-incremental="snapshot.file" -cvzf logs_backup_tar.gz /var/log`


#### Critical Analysis Question

- Why wouldn't you use the options `-x` and `-c` at the same time with `tar`?

You cannot as the `tar` command to perform antithetical actions: `x` is extract and `c` is create so it doesn't make sense. It would be the same as asking yourself to go left and right simultaneously.

---

### Step 2: Create, Manage, and Automate Cron Jobs

1. Cron job for backing up the `/var/log/auth.log` file

`crontab -e`
`* 6 * * 3 tar cfz /auth_backup.tgz /var/log/auth.log`


---

### Step 3: Write Basic Bash Scripts

1. Brace expansion command to create the four subdirectories: `mkdir -p ~/backups/{freemem,diskuse,openlist,freedisk}`

2. Paste your `system.sh` script edits below:

    ```bash
    #!/bin/bash
    # Free memory outpu to a free_mem.txt file
    free -h > ~/backups/freemem/free_mem.txt
    
    # Disk usage output to a disk_usage.txt file
    df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}' > ~/backups/diskuse/disk_usage.txt
    # List open files as an open_list.txt file
    lsof > ~/backups/openlist/open_list.txt

    # Free disk space to a free_disk.txt file
    df -h > ~/backups/freedisk/free_disk.txt
    ```

3. Command to make the `system.sh` script executable: `chmod +x system.sh`

**Optional**
- Commands to test the script and confirm its execution: `bash system.sh` then `cat diskuse/disk_usage.txt freedisk/free_disk.txt freemem/free_mem.txt openlist/open_list.txt` to confirm

**Bonus**
- Command to copy `system` to system-wide cron directory: `sudo cp ~/sysadmin/system.sh /etc/cron.weekly/`

---

### Step 4. Manage Log File Sizes
 
1. Run `sudo nano /etc/logrotate.conf` to edit the `logrotate` configuration file. 

    Configure a log rotation scheme that backs up authentication messages to the `/var/log/auth.log`.

    - Add your config file edits below:

    ```bash
    /var/log/auth.log {

    # rotate log files weekly
        weekly
    # keep 7 weeks worth of backlogs
        rotate 7
    # do not rotate empty logs
        notifempty
    # create new empty log files after rotating old ones
        create
    # compress log files
        compress
    # delay compression if a program cannot be told to immediately close its logfiole
        delaycompress
    # skip error if log file is missing
        missingok
        endscript
        }

    ```
--


### Bonus: Check for Policy and File Violations

1. Command to verify `auditd` is active: `systemctl status auditd`

2. Command to set number of retained logs and maximum log file size: `sudo vim /etc/audit/auditd.conf`

    - Add the edits made to the configuration file below:

	max_log_file = 35 	num_logs = 7


3. Command using `auditd` to set rules for `/etc/shadow`, `/etc/passwd` and `/var/log/auth.log`:


    - Add the edits made to the `rules` file below:

`-w /etc/shadow -p wra -k hashpass_audit `
`-w /etc/passwd -p wra -k userpass_audit `
`-w /var/log/auth.log -p wra -k authlog_audit`

4. Command to restart `auditd`: `sudo systemctl restart auditd`

5. Command to list all `auditd` rules: `sudo auditctl -l`

6. Command to produce an audit report: `sudo aureport -au`

7. Create a user with `sudo useradd attacker` and produce an audit report that lists account modifications: `sudo aureport -m`

8. Command to use `auditd` to watch `/var/log/cron`: `sudo auditctl -w /var/log/con`

9. Command to verify `auditd` rules: `sudo auditctl -l`

---

### Bonus (Research Activity): Perform Various Log Filtering Techniques

1. Command to return `journalctl` messages with priorities from emergency to error:

`sudo journalctl -b -p emerge..err`

2. Command to check the disk usage of the system journal unit since the most recent boot:

`sudo journalctl -b -u systemd-journald | less`


3. Comand to remove all archived journal files except the most recent two: `sudo journalctl —vacuum-files=2`


4. Command to filter all log messages with priority levels between zero and two, and save output to `/home/sysadmin/Priority_High.txt`:
`sudo su`
`journalctl -p 0..2 > /home/sysadmin/Priority_High.txt`

5. Command to automate the last command in a daily cronjob. Add the edits made to the crontab file below:

`sudo crontab -e`
`@daily journalctl -p 0..2 > /home/student/Priority_High.txt`


---
© 2020 Trilogy Education Services, a 2U, Inc. brand. All Rights Reserved.-

