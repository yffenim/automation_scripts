## Phase 1: On `Ping`

The IPs for the Hollywood offices and whether they are reachable:

15.199.95.91	Hollywood Database Servers ---> ICMP Network Unreachable
15.199.94.98		Hollywood Web Servers ---> ICMP Network Unreachable
11.199.158.91		Hollywood Web Servers ---> alive!
167.172.144.11		Hollywood Application Servers ---> Unreacheable
11.199.141.91		Hollywood Application Servers ---> Unreacheable

__Steps Taken__

Running `fping 15.199.95.91  15.199.94.98 11.199.158.91 167.172.144.11 11.199.141.91` gives the following output:

`167.172.144.11 is alive
15.199.95.91 is unreachable
15.199.94.98 is unreachable
11.199.158.91 is unreachable
11.199.141.91 is unreachable`

There are four IP addresses unavailable to `ping` meaning that the packet would not be delivered. This may be any number of reasons: the domain may be down, it may be the wrong IP address, the router may not know the way to reach the destination, etc. In this case, we know that the servers are unreachable intentionally. 

__Potential Vulnerabilities & Mitigation Recommendation__

Since RockStar Corp does not want any of their servers indicating that they are responsive, this means that `167.172.144.11` is potentially a vulnerability because it is responding our `ping`. 

If the server is intentionally up, we recommend configuring the network and device firewalls to block `ping` traffic from unauthorized IP addresses and untrusted IP networks. Even though this is extra work than disabling `ping` or filtering `ICMP`, since `ICMP` is used for `traceroute` and time exceeded timeouts, completely filtering out `ICMP` can cause network issues and limit your ability to monitor your network. 


__OSI Layer__

The `fping` and `ping` utility use the ICMP (internet Control Message Protocol) which is encapsulated in the IP header and operates on Layer 3: The Network Layer of the OSI model. Since `ping` is only performing a simple host lookup, it is not using Transport layer services nor addressing traffic reliability issues. 

### Phase 2: On `Syn`

__Steps Taken__
`nmap -sS  <IP Address>` is the syntax for using `nmap` to run a `SYN` scan.

Running a `SYN` scan on the RockStar Corp servers to the IP found from Phase 1:
`sudo nmap -sS 167.172.144.11` returns the following open ports:

`Nmap scan report for 167.172.144.11`
`Host is up (0.042s latency).`
`Not shown: 995 closed tcp ports (reset)`
`PORT    STATE    SERVICE`
`22/tcp  open     ssh`
`25/tcp  filtered smtp`
`135/tcp filtered msrpc`
`139/tcp filtered netbios-ssn`
`445/tcp filtered microsoft-ds`

Running a second `SYN` scan with a slower time lapse between attempts (`sudo nmap -sS 167.172.144.11`) )returns the same results.

__Potential Vulnerabilities and Mitigation Recommendations__

According to the `SYN` scan conducted by the `Nmap` utility, we have 995 closed ports, 4 filtered ports, and 1 open port: For the 995 closed ports, this is not a vulnerability as the server has rejected our connection attempt with a `RST` packet meaning that the port is properly configured to be closed.

For the 4 filtered ports, this means that the port is likely blocked by a physical firewall device in the network path, host-based firewall software, or from router configurations. According to the NMAP Reference Guide (Chapter 15), the "packet filtering prevents its probes from reaching the port" meaning that we cannot access the port from our scanning location but it does not necesarily mean that the port is closed on the sytem itself. This means that these ports have adequate security protection.

Lastly, we have our open port `22` which is typically used for remote management via `SSH`. Even though this generally considered secure if it is configured with key authentication (as opposed to password authentication), we consider this to be a potential vulnerability. A password authentication is susceptible to brute-force attacks and/or social engineering, especially if it is a weak or obvious password. We therefore strongly recommend (at least) implementing `SSH Key Authenticatioe` infrastucture.

Since every direct access to a server is a potential entry point for attackers, it is important to take this vulnerability seriously. Depending on the company's security needs, we further recommend enabling Multifactor Authentication for and storing the private key on a cryptographic device like a smart card or a USB token (instead of on the local harddrive) so that it is not accessible to other (possibly malicious) users of the computer that was used to generate the keys.

__OSI Layer__

`Nmap` is a port scanner that checks a network for hosts and services and interprets the response back depending on information was sent. To map a network, `Nmap` sends packets to the target host and then analyzes the responses. (In our case, we sent standard `SYN` packets.) This means that `Nmap` is on Layer 4: Transport Layer of the OSI model.


### Phase 3: On `DNS`

__Steps taken__

Login via `SSH` using given credentials: `ssh jimi@167.172.144.11 -p 22` + entering password `hendrix` when prompted.

`less /etc/hosts` to troubleshoot why rollingstone.com isn't loading. 

A line has been found that says: `98.137.246.8 rollingstone.com` meaning that the domain rollingstone.com is being redirected to the ip `98.137.246.8` 

`nslookup 98.137.246.8` to perform a PTR record look up on the IP that `rollingstone.com` is being redirected to gives the following output:

`Non-authoritative answer:`
`8.246.137.98.in-addr.arpa	name = unknown.yahoo.com.`

`Authoritative answers can be found from:`
`246.137.98.in-addr.arpa	nameserver = ns2.yahoo.com.`
`246.137.98.in-addr.arpa	nameserver = ns3.yahoo.com.`
`246.137.98.in-addr.arpa	nameserver = ns4.yahoo.com.`
`246.137.98.in-addr.arpa	nameserver = ns5.yahoo.com.`
`246.137.98.in-addr.arpa	nameserver = ns1.yahoo.com.`

The domain that begins with `unknown` is the non-authoritative answer (meaning that this answer is from a cache file constructed from previous `DNS` lookups): `unknown.yahoo.com`

__Potential Vulnerabilities and Mitigation Recommendations__

The credentials for Jimi Hendrix is way too easy to guess -- one might not even require a password cracking script to guess "Hendrix" in response to "Jimi." We recommend following the security strategies outlined in the previous section (re: Key Authentication) to secure this vulnerability. 

It is also  possible that a malicious actor has changed the A record the server so that the `rollingstone.com` IP address has been saved as `98.137.246.8` instead of the real IP. The vulnerability here is: Why was someone able to access `/etc/hosts`? The permissions for `/etc/hosts` indicate that only `root` is able to write to the file: 

`-rw-r--r-- 1 root root 648 Mar 18  2020 /etc/hosts`

This means that there is someone with authorized  `root` access who has altered the  `/etc/hosts` file or there is someone who can gain unauthorized `root` access.

Our recommendation is to:
- check the server and harden against the most common privilege escalation techniques (check `SUID` binaries that allow for privilege escalation, check permissions of users with `SUDO` privilege (`/etc/sudoers`), and check the Cron Jobs, specifically `/etc/crontab` which is used to schedule system-wide jobs that are executed with root privileges.
- perform a system-wide audit with Lynis and follow the recommendations for hardedning
- check whether there is an employee with authorized `root` access who has recently been fired or demoted

__OSI Layer__

When a client requests that a domain name be converted into an IP address (or vice versa), the task is completed by the `DNS` protocol which operates at the Application Layer (Layer 7).

### Phrase 4: On `ARP`

__Steps Taken__

`ls -alht /etc` to find hacker's secret packetcapture info by sorting the contents of the `/etc` by time (on top of the other details) because I hypotheized that the "malicious" changes would have been the last thing to be implemented by the people preparing this lesson... (If this hadn't worked, I would have `grepped` for the packet with: `ls -alh /etc | grep packet*`)

`less /etc/packetcaptureinfo.txt` to display contents which gives us a link to a Packet Capture file that can be examined in Wireshark:

 https://drive.google.com/file/d/1ic-CFFGrbruloYrWaw3PvT71elTkh3eF/view?usp=sharing

__Suspicious (ARP):__

Wireshark notifies us that there are two MAC addresses found for an IP address after filtering for `ARP`:

[Duplicate IP address detected for 192.168.47.200 (00:0c:29:1d:b3:b1) - also in use by 00:0c:29:0f:71:a3 (frame 4)]

This is a sign that either there is a human configuration error -- it's possible that someone has manually set up an VM with the duplicate MAC address, etc -- or that there is a malicious `ARP` spoof message attempting to direct all future traffic intended for the good MAC address to the malicious one. However, given the current amount of information, we are not able confirm with certainty which is good host and which is the malicious just from examining the two separate `ARP` responses in Wireshark.

__Potential Vulnerabilities and Mitigation: `ARP`__

We recommend immediately blocking both IPs and inspecting what devices are at the endpoints in order to confirm the correct MAC address (or at least until the ARP cache is updated if manual confirmation is not readible doable).

Depending on the impact and likelihood of future `ARP` attacks, we recommend:
- adding the malicious host's source MAC address to the blackhole address list and discarding all packets from said host by configuring the ACL (Access Control List) on the firewall or router
- installing a detection tool 
- configuring packet filtering and inspect
- configuring a rate threshold to monitor the ARP flow. If threshold is exceeded, then it is considered an attack.
- creating a static ARP entry (a permanent entry) in the server for any two hosts that regularly communicate so that it cannot be spoofed
- implementing backend segmentation by subnetting and network configuration so that a smaller portion of the network is behind an additional proxy and double NAT. 

__Suspicious (HTTP):__

There is a `303 See Other` error code which is a way to redirect web applications to a new URI, especially if an `HTTP POST` request has been performed which in this case, it has been performed:

A form has been submitted to `/formservice/en/3f64542cb2e3439c9bd01649ce5595ad/6150f4b54616438dbb01eb877296d534/c3a179f3630a440a96196bead53b76fa/I660593e583e747f1a91a77ad0d3195e3/ HTTP/1.1\r\n`

So we can now look into the form data found in the payload and find in form item 3 the following message from a self-identified hacker:

"Hi Got The Blues Corp!  This is a hacker that works at Rock Star Corp.  Rock Star has left port 22, SSH open if you want to hack in.  For 1 Milliion Dollars I will provide you the user and password!"

__Potential Vulnerabilities and Mititgation Strategies: `HTTP`__

Here is evidence of a hacker and/or an internal leak. Unfortunately, the plaintext `POST` data is not something we can protect against if the website is not ours. (This third-party Blues Music website where this secret message was passed could be a back-channel where hackers communicate!) The `SSH` vulnerability in the leak has already been previously identified and discussed. If we did have control over the website, we could use `HTTPS` instead of `HTTP` so that the data is encrypted in transit and it won't be broadcast to the world for sale. Otherwise, `HTTP` data is sent in plaintext so anyone can easily access or read the not-so-secret message.

__OSI LAYER:__

`ARP` is a broadcast frame that is send on a Layer 2 segment. While it does provide services to Layer 3 (Network), the main function of `ARP` is to take an IP address and resolve this to a MAC address so this is Layer 2: Data Link.

`HTTP` is a Layer 7: Application layer protocol that is sent over `TCP` (though in some scenarios, it can also use `UDP`). It is mainly used to transfer, access, and represent data.

Lastly, thank you for reading my homework. 
