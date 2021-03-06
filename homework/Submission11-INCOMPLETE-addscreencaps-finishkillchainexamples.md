## Unit 11 Submission File: Network Security Homework 

### Follow-up Questions

### Part 1: Review Questions 

#### Security Control Types

The concept of defense in depth can be broken down into three different security control types. Identify the security control type of each set  of defense tactics.

1. Walls, bollards, fences, guard dogs, cameras, and lighting are what type of security control?

Physical Controls

2. Security awareness programs, BYOD policies, and ethical hiring practices are what type of security control?

Administrative Controls

3. Encryption, biometric fingerprint readers, firewalls, endpoint security, and intrusion detection systems are what type of security control?

Operational Security -- (Data protections, Access Control, Intrusion Detection and Attack indicators)


#### Intrusion Detection and Attack indicators

1. What's the difference between an IDS and an IPS?

IDS (Intrusion Detection System) is a detection and monitoring tool that doe snot take action on its own so a human (or another system) has to read and interpret the results. IPS (Intrusion Prevention System) is a control system that accepts or rejects a packet based on the rulelist -- this means that unlike IDS, the IPS can take action against potential attacks. 

Another difference is that IPS sits on the network in the same area as a firewall might (between the outside and internal network) so traffic has to flow through the IPS. (Ideally, one could put it in the demilitarized zone so that the firewall can act first.) An IDS only monitors the traffic, it is not in the line of traffic.

The last difference is that while both are known for generaeting false positives, in the event of an IDS, the false positive will only create alerts whereas for the IPS, this coudl cause the loss of important data or functions (again because it sits on the network).

2. What's the difference between an Indicator of Attack and an Indicator of Compromise?

An Indicator of Attack (IOA) focuses on detecting the **intent** of what an attacker is trying to accomplish regardless of the malware or exploit being used and is typically an alert before a network or application is exploited. On the other hand, an Indicator of Compromise (IOC) is regarded as the **evidence** that indicates a network security breach. It is usually gathered after a suspicious incident, on a scheduled basis or after an unusual discovery.

#### The Cyber Kill Chain

Name each of the seven stages for the Cyber Kill chain and provide a brief example of each.

1. Stage 1: Reconnaisance - Attackers pick a target and perform analysis, collect information (such as email addresses, conference information, technology stack, etc) and evaluate their target's weaknesses.

Example: Trying to discover what firewalls or intrusion prevention systems are in place for a targeted network. Using tools such as `nmap`, `stan`, or Strobe to search for vulnerabilities.

2. Stage 2: Weaponization - Attackers determine how best to get inside the network by exploiting the discovered vulnerabilities. 

Example: Using a malware tailored to exploit the specific techhology that they discovered in the Reconnaisance stagethat the target network uses. Using a Zero-day vulnerability they have discovered.

3. Stage 3: Delivery - The chosen attack method is delivered to the target encironment.

Example: An infected USB drive is dropped off at the target office, a malicious attachment is sent via a phishing email, etc.

4. Stage 4: Exploitation - The attackers leverage the vulnerabilities and execute the malicious code on the target network. 

Example: Triggering a Buffer overflow/underflow on a vulnerable database. 

5. Stage 5: Installation - The malware weapon is installed, giving the attaker's an access point to the target environment, ideally one that they can return to effortlessly.

Example: A DLL Hijacking attack that exploits the way some Windows applicatons search and load Dynamic Link Libraries (DLL) by copying the name of a legitimate DLL and placing the malicious DLL in a position that the application will search first so that the malicious DLL will load instead. The malicious DLL could be written to launch the malware and then the legitimate DLL can be loaded to avoid suspicion, creating a persistent point of entry for the attacker.

6. Stage 6: Command and Control (C2) - The attackers have uninterrupted remote access to the target environment and can manipulate it to their choosing.

Example: Any escalation to root is a C2. For example

7. Stage 7: Actions on Objective - The original goal(s) of the attack can be executed.  

#### Snort Rule Analysis

Use the Snort rule to answer the following questions:

Snort Rule #1

```bash
alert tcp $EXTERNAL_NET any -> $HOME_NET 5800:5820 (msg:"ET SCAN Potential VNC Scan 5800-5820"; flags:S,12; threshold: type both, track by_src, count 5, seconds 60; reference:url,doc.emergingthreats.net/2002910; classtype:attempted-recon; sid:2002910; rev:5; metadata:created_at 2010_07_30, updated_at 2010_07_30;)
```

1. Break down the Sort Rule header and explain what is happening.

   Answer: Sets an Alert when any external network tries to communicate over the home network port range of 5800 to 5820. One can also set a pass list of IP addresses that Snort should never block (even when malicious traffic is detected).

2. What stage of the Cyber Kill Chain does this alert violate?

   Answer: Reconnaissance. This alert has detected an attempted scan for VNC vulnerabilities. 

3. What kind of attack is indicated?

   Answer: This is not neccesarily an indication of attack because reconnance is not in itself a full attack. Rather it suggests that an attack could happen because someone has conducted a port scan of ports 5800-5820 looking for potential vulnerable VNC (Virtual Network Computing).


Snort Rule #2

```bash
alert tcp $EXTERNAL_NET $HTTP_PORTS -> $HOME_NET any (msg:"ET POLICY PE EXE or DLL Windows file download HTTP"; flow:established,to_client; flowbits:isnotset,ET.http.binary; flowbits:isnotset,ET.INFO.WindowsUpdate; file_data; content:"MZ"; within:2; byte_jump:4,58,relative,little; content:"PE|00 00|"; distance:-64; within:4; flowbits:set,ET.http.binary; metadata: former_category POLICY; reference:url,doc.emergingthreats.net/bin/view/Main/2018959; classtype:policy-violation; sid:2018959; rev:4; metadata:created_at 2014_08_19, updated_at 2017_02_01;)
```

1. Break down the Sort Rule header and explain what is happening.

   Answer: The header indicates that traffic has been detected coming from an external network through specific `http` ports to the internal network via any ports. There is likely an attempt to delivery a malicious payload.

2. What layer of the Defense in Depth model does this alert violate?

   Answer: Delivery. This is an attempt to send a potentially weaponized payload.

3. What kind of attack is indicated?

   Answer: The `ET POLICY PE EXE or DLL Windows file download HTTP` 
detected by the alert has been previously detected as a part of Conti Ransomware (https://thedfirreport.com/2021/05/12/conti-ransomware/) and research indicates that a `PE EXE` is a Process Injection attack of a Portable Executable Injection, meaning that the attack attempts to injec itself into a process: https://attack.mitre.org/techniques/T1055/002/

Snort Rule #3

- Your turn! Write a Snort rule that alerts when traffic is detected inbound on port 4444 to the local network on any port. Be sure to include the `msg` in the Rule Option.

    Answer: alert tcp $EXTERNAL_NET any -> $HOME_NET 4444 (msg: "Possible malicious worm attack PORT 4444")

    https://www.speedguide.net/port.php?port=4444

    https://resources.infosecinstitute.com/topic/snort-rules-workshop-part-one/

### Part 2: "Drop Zone" Lab

#### Log into the Azure `firewalld` machine

Log in using the following credentials:

- Username: `sysadmin`
- Password: `cybersecurity`

#### Uninstall `ufw`

Before getting started, you should verify that you do not have any instances of `ufw` running. This will avoid conflicts with your `firewalld` service. This also ensures that `firewalld` will be your default firewall.

https://firewalld.org/documentation/man-pages/firewall-cmd.html

- Run the command that removes any running instance of `ufw`.

    ```bash
    $ sudo apt remove ufw
    ```

#### Enable and start `firewalld`

By default, these service should be running. If not, then run the following commands:

- Run the commands that enable and start `firewalld` upon boots and reboots.

    ```bash
    $ sudo systemctl enable firewalld.service
    $ sudo /etc/init.d/firewalld start    
    ```

  Note: This will ensure that `firewalld` remains active after each reboot.

#### Confirm that the service is running.

- Run the command that checks whether or not the `firewalld` service is up and running.

    ```bash
    $ sudo systemctl status firewalld.service
    # OR
    $ firewall-cmd --state
    ```


#### List all firewall rules currently configured.

Next, lists all currently configured firewall rules. This will give you a good idea of what's currently configured and save you time in the long run by not doing double work.

- Run the command that lists all currently configured firewall rules:

    ```bash
    $ sudo firewall-cmd --list-all
    ```

- Take note of what Zones and settings are configured. You many need to remove unneeded services and settings.

#### List all supported service types that can be enabled.

- Run the command that lists all currently supported services to see if the service you need is available

    ```bash
    $ sudo firewall-cmd --get-services
    ```

- We can see that the `Home` and `Drop` Zones are created by default.


#### Zone Views

- Run the command that lists all currently configured zones.

    ```bash
    $ sudo firewall-cmd --list-all-zones
    ```

- We can see that the `Public` and `Drop` Zones are created by default. Therefore, we will need to create Zones for `Web`, `Sales`, and `Mail`.

#### Create Zones for `Web`, `Sales` and `Mail`.

- Run the commands that creates Web, Sales and Mail zones.

    ```bash
    $ sudo firewall-cmd --permanent --new-zone=web
    $ sudo firewall-cmd --permanent --new-zone=sales
    $ sudo firewall-cmd --permanent --new-zone=mail
    $ sudo firewall-cmd --reload
    ```

#### Set the zones to their designated interfaces:

- Run the commands that sets your `eth` interfaces to your zones.

    ```bash
    $ sudo firewall-cmd --zone=public --change-interface=eth0
    $ sudo firewall-cmd --zone=public --change-interface=eth1
    $ sudo firewall-cmd --zone=public --change-interface=eth2
    $ sudo firewall-cmd --zone=public --change-interface=eth3
    ```

#### Add services to the active zones:

- Run the commands that add services to the **public** zone, the **web** zone, the **sales** zone, and the **mail** zone.

- Public:

    ```bash
    $ sudo firewall-cmd --permanent --zone=public --add-service=http  
    $ sudo firewall-cmd --permanent --zone=public --add-service=https  
    $ sudo firewall-cmd --permanent --zone=public --add-service=pop3  
    $ sudo firewall-cmd --permanent --zone=public --add-service=smtp   
    ```

- Web:

    ```bash
    $ sudo firewall-cmd --permanent --zone=web --add-service=http
    ```

- Sales

    ```bash
    $ sudo firewall-cmd --permanent --zone=sales --add-service=https
    ```

- Mail

    ```bash
   $ sudo firewall-cmd --permanent --zone=mail --add-service=smtp  
   $ sudo firewall-cmd --permanent --zone=mail --add-service=pop3  
    ```

- What is the status of `http`, `https`, `smtp` and `pop3`?
***************************
    _add screen cap!!!!!_
***************************

#### Add your adversaries to the Drop Zone.

- Run the command that will add all current and any future blacklisted IPs to the Drop Zone.

     ```bash
     $ sudo firewall-cmd --permanent --zone=drop --add-source=10.208.56.23  
     $ sudo firewall-cmd --permanent --zone=drop --add-source=135.95.103.76  
     $ sudo firewall-cmd --permanent --zone=drop --add-source=76.34.169.118  
     ```

#### Make rules permanent then reload them:

It's good practice to ensure that your `firewalld` installation remains nailed up and retains its services across reboots. This ensure that the network remains secured after unplanned outages such as power failures.

- Run the command that reloads the `firewalld` configurations and writes it to memory

    ```bash
    `$ sudo firewall-cmd --reload
    ```

#### View active Zones

Now, we'll want to provide truncated listings of all currently **active** zones. This a good time to verify your zone settings.

- Run the command that displays all zone services.

    ```bash
    `$ sudo firewall-cmd --get-active-zone
    ```


#### Block an IP address

- Use a rich-rule that blocks the IP address `138.138.0.3`.

    ```bash
    $ sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="138.138.0.3" reject'
    ```

#### Block Ping/ICMP Requests

Harden your network against `ping` scans by blocking `icmp ehco` replies.

- Run the command that blocks `pings` and `icmp` requests in your `public` zone.

    ```bash
    $ sudo firewall-cmd --zone=public --add-icmp-block=echo-reply --add-icmp-block=echo-request
    ```

#### Rule Check

Now that you've set up your brand new `firewalld` installation, it's time to verify that all of the settings have taken effect.

- Run the command that lists all  of the rule settings. Do one command at a time for each zone.

    ```bash
    $ sudo firewall-cmd --zone=public --list-all  
    $ sudo firewall-cmd --zone=sales --list-all
    $ sudo firewall-cmd --zone=mail --list-all
    $ sudo firewall-cmd --zone=web --list-all
    $ sudo firewall-cmd --permanent --zone=drop --list-all
    ```

- Are all of our rules in place? If not, then go back and make the necessary modifications before checking again.
***************************
    _add screen cap!!!!!_
***************************


Congratulations! You have successfully configured and deployed a fully comprehensive `firewalld` installation.

---

### Part 3: IDS, IPS, DiD and Firewalls

Now, we will work on another lab. Before you start, complete the following review questions.

#### IDS vs. IPS Systems

1. Name and define two ways an IDS connects to a network.

_Network Intrusion Detection System (NIDS)_ is used to monitor and analyze network traffic in order to detect network-based threats. NIDS can be hardware or software-based systems and can attach to various network mediums. Analysis is performed passively inspecting the traffic traversing the devices on which the NIDS sit and sending a warning alert is there is abnormal behaviour that deviates from baseline patterns.

https://www.sciencedirect.com/topics/computer-science/network-based-intrusion-detection-system

_Host Intrusion Detection System (HIDS)_ is used to monitor the computer infrastructure in a single host system in order to report on the system's configuration and applicaton for activity. While this does not provide comprehensive security for an organization, the specificity of its vantage point allows greater detail: it can provide snapshots in order to detect if anything changes, determine which processes and/or users are involved in malicious activities, access and analyze operating system logs and operating system audit trails.

https://www.sciencedirect.com/topics/computer-science/host-based-intrusion-detection-system
https://www.cimcor.com/blog/how-host-based-intrusion-detection-hids-works

2. Describe how an IPS connects to a network.

   Answer: An IPS connects to a mirror port that is  inline on the network between the firewall and switch. 

3. What type of IDS compares patterns of traffic to predefined signatures and is unable to detect Zero-Day attacks?

   Answer: A signature-based IDS. This is because it compares traffic from predefined lists and so cannot filter anything outside of those lists which would not cover an unknown Zero-day.

4. Which type of IDS is beneficial for detecting all suspicious traffic that deviates from the well-known baseline and is excellent at detecting when an attacker probes or sweeps a network?

   Answer: Anomaly-based network intrusion.

#### Defense in Depth

1. For each of the following scenarios, provide the layer of Defense in Depth that applies:

    1.  A criminal hacker tailgates an employee through an exterior door into a secured facility, explaining that they forgot their badge at home.

        Answer: Administrative Policy

    2. A zero-day goes undetected by antivirus software.

        Answer: Technical Software

    3. A criminal successfully gains access to HR???s database.

        Answer: Technical Network

    4. A criminal hacker exploits a vulnerability within an operating system.

        Answer: Technical Software

    5. A hacktivist organization successfully performs a DDoS attack, taking down a government website.

        Answer: Technical Network

    6. Data is classified at the wrong classification level.

        Answer: Administrative Procedures 

    7. A state sponsored hacker group successfully firewalked an organization to produce a list of active services on an email server.

        Answer: Administrative Network

2. Name one method of protecting data-at-rest from being readable on hard drive.

    Answer: Drive Encryption

3. Name one method to protect data-in-transit.

    Answer: PKI (Public Key Infrastructure)

4. What technology could provide law enforcement with the ability to track and recover a stolen laptop.

   Answer: Network Cards 

5. How could you prevent an attacker from booting a stolen laptop using an external hard drive?

    Answer: Disk Encryption. A strong BIOS/UEFI password policy.


#### Firewall Architectures and Methodologies

1. Which type of firewall verifies the three-way TCP handshake? TCP handshake checks are designed to ensure that session packets are from legitimate sources.

  Answer: Stateful Inspection Firewalls, Circuit-Level Gateways, Next-Generation Firewalls

2. Which type of firewall considers the connection as a whole? Meaning, instead of looking at only individual packets, these firewalls look at whole streams of packets at one time.

  Answer: Stateful Inspection Firewalls

3. Which type of firewall intercepts all traffic prior to being forwarded to its final destination. In a sense, these firewalls act on behalf of the recipient by ensuring the traffic is safe prior to forwarding it?

  Answer: Application/Proxy Firewalls


4. Which type of firewall examines data within a packet as it progresses through a network interface by examining source and destination IP address, port number, and packet type- all without opening the packet to inspect its contents?

  Answer: Packet-Filtering Firewalls


5. Which type of firewall filters based solely on source and destination MAC address?

  Answer: MAC firewalls/Mac layer filtering


### Bonus Lab: "Green Eggs & SPAM"
In this activity, you will target spam, uncover its whereabouts, and attempt to discover the intent of the attacker.
 
- You will assume the role of a Jr. Security administrator working for the Department of Technology for the State of California.
 
- As a junior administrator, your primary role is to perform the initial triage of alert data: the initial investigation and analysis followed by an escalation of high priority alerts to senior incident handlers for further review.
 
- You will work as part of a Computer and Incident Response Team (CIRT), responsible for compiling **Threat Intelligence** as part of your incident report.

#### Threat Intelligence Card

**Note**: Log into the Security Onion VM and use the following **Indicator of Attack** to complete this portion of the homework. 

Locate the following Indicator of Attack in Sguil based off of the following:

- **Source IP/Port**: `188.124.9.56:80`
- **Destination Address/Port**: `192.168.3.35:1035`
- **Event Message**: `ET TROJAN JS/Nemucod.M.gen downloading EXE payload`

Answer the following:

1. What was the indicator of an attack?
   - Hint: What do the details of the reveal? 

    Answer: Nemucod is a Trojan that downloads potentially malicious files to an infected computer which are typically used to steal data. Succinctly, this is a Trojan malware attack.

2. What was the adversarial motivation (purpose of attack)?

    Answer: ??

3. Describe observations and indicators that may be related to the perpetrators of the intrusion. Categorize your insights according to the appropriate stage of the cyber kill chain, as structured in the following table.

| TTP | Example | Findings |
| --- | --- | --- | 
| **Reconnaissance** |  How did they attacker locate the victim? | 
| **Weaponization** |  What was it that was downloaded?|
| **Delivery** |    How was it downloaded?|
| **Exploitation** |  What does the exploit do?|
| **Installation** | How is the exploit installed?|
| **Command & Control (C2)** | How does the attacker gain control of the remote machine?|
| **Actions on Objectives** | What does the software that the attacker sent do to complete it's tasks?|


    Answer: 

    __Reconnaissance:__ | It's possible the attacker found the port vulnerability through port mapping. Example: Nmap.
    __Weaponization:__ | Malicious software is downloaded onto the target system or network. Examples: Worms, viruses, logic bombs, etc.
    __Delivery:__ | Direct hacking into an open port. Example: itself?
    __Exploitation:__ | Malware downloaded is an Installer -- it will install potentiall yunwanted program or download more malware to the computer. Example: 
    __Installation:__ | RAT (Remote Access Trojans) are most likely how this malware was installed.
    __C2:__ | 
    __Actions on Objectives:__ | We can hypothesize that the attacker's goals are to 
extract ransom or extract data. Example: 


4. What are your recommended mitigation strategies?


    Answer: 


5. List your third-party references.

    Answer: 


---

?? 2020 Trilogy Education Services, a 2U, Inc. brand. All Rights Reserved.
