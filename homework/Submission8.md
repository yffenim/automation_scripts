**FOLLOW-UP QUESTIONS**
- authoritative vs non-authoritative DNS & usage/security implications?
-


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

This means that `167.172.144.11` is a vulnerability because it is responding our ping. We recommend checking the server's firewall configrations to block ICMP responses. Currently we have not detected a malicious actor present. 

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

__Potential Vulnerabilities and Mitigation Recommendations__

According to the `SYN` scan conducted by the `Nmap` utility, we have 995 closed ports, 4 filtered ports, and 1 open port: For the 995 closed ports, this is not a vulnerability as the server has rejected our connection attempt with a `RST` packet meaning that the port is properly configured to be closed.

For the 4 filtered ports, this means that the port is likely blocked by a physical firewall device in the network path, host-based firewall software, or from router configurations. According to the NMAP Reference Guide (Chapter 15), the "packet filtering prevents its probes from reaching the port" meaning that we cannot access the port from our scanning location but it does not necesarily mean that the port is closed on the sytem itself. This means that these ports have adequate security protection.

Lastly, we have our open port `22` which is typically used for remote management via `SSH`. Even though this generally considered secure if it is configured with key authentication (as opposed to password authentication), we consider this to be a potential vulnerability. A password authentication is susceptible to brute-force attacks and/or social engineering, especially if it is a weak or obvious password. We therefore strongly recommend (at least) implementing `SSH Key Authenticatioe` infrastucture. 


Since every direct access to a server is a potential entry point for attackers, it is important to take this vulnerability seriously. We further recommend that instead of storing the private key a hard drive, it can be stored on a cryptographic device like a smart card or a USB token so that it is not accessible to other (possibly malicious) users of the computer that was used to generate the keys.

__OSI Layer__

`Nmap` is a port scanner that checks a network for hosts and services and interprets the response back depending on information was sent. To map a network, `Nmap` sends packets to the target host and then analyzes the responses. (In our case, we went standard `SYN` packets.) This means that `Nmap` is on Layer 4: Transport Layer of the OSI model.


### Phase 3: On `DNS`

__Steps taken__

Login to the IP that respnded to `pings` from Phase 1 via `SSH` and the given credentials: `ssh jimi@167.172.144.11 -p 22` + entering password `hendrix` when prompted.

`less /etc/hosts` to troubleshoot why rollingstone.com isn't loading. 

A line has been found that says: `98.137.246.8 rollingstone.com` meaning that the domain rollingstone.com is being redirected to the ip `98.137.246.8` 

`nslookup 98.137.246.8` to perform a PTR record look up on the IPr that `rollingstone.com` is being redirected to gives the following output:

`Server:		192.168.2.1`
`Address:	192.168.2.1#53`

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

The credentials for Jimi Hendrix is way too easy to guess, literally. One would not even require a password cracking script to guess "Hendrix" in response to "Jimi." We recommend following the strategies outlined in the previous section to secure this vulnerability. 

__OSI Layer__

When a client requests that a domain name be converted into an IP address (or vice versa), the task is completed by the `DNS` protocol which operates at the Application Layer (Layer 7).

__Potential Vulnerabilities and Mitigation Strategies__

- permissions for the /etc/hosts
In this case, a hacker has changed the A record for  configure the server into saving the `rollingstone.com` IP address as `98.137.246.8` instead of the real IP.

`DNS` vulnerabilities are usually critical: if an attacker is able to conduct a DNS cache poisoning or spoofing attack (as has happened here), they can redirect you to a malicious site (that looks exactly the same as the site you intended to visit) without you seeing that anything is wrong because the browser actually thinks this is the correct website. 


### Phrase 4: On `ARP`
`ls -alht /etc` to find hacker's secret packetcapture info:

 https://drive.google.com/file/d/1ic-CFFGrbruloYrWaw3PvT71elTkh3eF/view?usp=sharing


### wireshark question
- 
