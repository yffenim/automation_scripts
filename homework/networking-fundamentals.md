### **Phase 1**: _"I'd like to Teach the World to `Ping`"_

You have been provided a list of network assets belonging to RockStar Corp. Use `fping` to ping the network assets for only the Hollywood office.

  - Determine the IPs for the Hollywood office and run `fping` against the IP ranges in order to determine which IP is accepting connections.

  - RockStar Corp doesn't want any of their servers, even if they are up, indicating that they are accepting connections.
     - Use `fping <IP Address>` and ignore any results that say "Request timed out".
     - If any of the IP addresses send back a Reply, enter Ctrl+C to stop sending requests.

  - Create a summary file in a word document that lists out the `fping` command used, as well as a summary of the results.

  - Your summary should determine which IPs are accepting connections and which are not.

  - Also indicate at which OSI layer your findings are found.

## Phase 1: On `Ping`

The IPs for the Hollywood offices and their status.
# is status the right word to use here?

15.199.95.91	Hollywood Database Servers ---> ICMP Network Unreachable
15.199.94.98		Hollywood Web Servers ---> ICMP Network Unreachable
11.199.158.91		Hollywood Web Servers ---> alive!
167.172.144.11		Hollywood Application Servers ---> Unreacheable
11.199.141.91		Hollywood Application Servers ---> Unreacheable

# Steps Taken

Ran `fping` on 15.199.95.91 and received the following output:
`ICMP Network Unreachable from 8.243.188.17 for ICMP Echo sent to 15.199.95.91`

This means that the packet could not be delivered to the receiver for a variety of possible reasons including: the receiver may be down, it may be the wrong IP address, the router may not know the way to reach the destination network, etc. 

**QUESTIONS**
- Why would the router not know the way to reach the destination network?
- What is the difference between network unreachable and host unreachable?
- why isn't wireshark capturing this?
- how do I display the ICMP error code via CLI?
-
- trouble-shooting unreachable IP: 
- THE GOAL: is to narrow down your problem domain methodically
- server admin/team - ilo connection (console connection) to narrow down network vs server problem, if connected, validates that server is good. if not, check server itself
- check hardware: beyond server, check switch
- enterprise swtiches 
- if you know the nic, you can find the ARP translation to trace the MAC address from
- once you have the MAC, you check its switch: from the switch perspective, are you seeing the server? if up, you have validated that physical layer is good
- trouble-shooting from layer one up - narrow it down
- if layer two is good, you should be able to find the mac address
- layer 3: is this an IP problem or all the servers on this subnet? 
- if you can ping the other IPs, recheck the hardware because every other IP is working
- its a problem with localhost not network -- its a problem with the specific machine pinging from
- reverse the ping direction to check 
- follow up:
- VLAN
- opnet/tcp dump - track the packet



Ran `fping` from Ubuntu and `ping` from MacOS on 15.199.94.98 and received the following output: 

From Ubuntu and `fping`, the same result as with the previous IP was given:
`ICMP Network Unreachable from 8.243.188.17 for ICMP Echo sent to 15.199.95.98`

From MacOS and `ping`, the result is: 

`PING 15.199.94.91 (15.199.94.91): 56 data bytes
36 bytes from 8.243.188.17: Destination Net Unreachable
Vr HL TOS  Len   ID Flg  off TTL Pro  cks      Src      Dst
 4  5  00 5400 1b6d   0 0000  3c  01 dfa0 10.1.11.121  15.199.94.91`

**FIGURE OUT EACH OF THESE HEADERS FOR RETURN?**

Running `fping 11.199.158.91 167.172.144.11 11.199.141.91` to ping the three remtaining networks at once. Result:

`167.172.144.11 is alive
11.199.158.91 is unreachable
11.199.141.91 is unreachable`

Running `ping` on the unreachable IPs due to understand the issue:

`PING 11.199.158.91 (11.199.158.91): 56 data bytes
Request timeout for icmp_seq 0
Request timeout for icmp_seq 1
Request timeout for icmp_seq 2
Request timeout for icmp_seq 3`

Unlike the previous unreachable IPs, this is due to a request timeout which means that our host did not receive the `ping` message from the destination device within the designated time period. This could be due to network connectivity or configuration issues on their end, or (in rare cases) enough congestion on the network that timely deivery of the ping could not be completed. 

**What is the difference here between the two errors and how can I see the error code???**

### In summary: 

The only IP accepting connections is: `167.172.144.11 is alive`. 

The `fping` and `ping` utility use the ICMP (internet Control Message Protocol) which is encapsulated in the IP header and operates on Layer 3: The Network Layer of the OSI model. Since `ping` is only performing a simple host lookup, it is not using Transport layer services nor addressing traffic reliability issues. 

### Phase 2: On `Syn`

- For the purpose of this exercise, document which ports are open on the RockStar Corp server, and which OSI layer SYN scans run on.

`Syn` Scan: also know as "half-open scanning" **(why?)** where the hostile client attempts to set up a TCP/IP connection with a server at every possible port by sending a `SYN` packet. Since the `SYN` (synchronization) packet is the first step of the three-way handshake, the ports on the server that are open will accept the connection. 

`nmap -sS  <IP Address>` is the syntax for using `nmap` to run a `SYN` scan.

Running a `SYN` scan on the RockStar Corp servers with `sudo nmap -sS <IP address>` returns the following open ports:

**Do they really just want me to list out all the ports on this server...?"**

### Phase 3: On `DNS`

Login to the IP that respnded to `pings` from Phase 1: `ssh jimi@167.172.144.11 -p 22`

`less /etc/hosts` to troubleshoot why rollingstone.com isn't loading. A line has been found that says: `98.137.246.8 rollingstone.com` meaning that the domain rollingstone.com is being redirected to the ip `98.137.246.8` 


Of Interest: 

4000/tcp  open     remoteanything
1166/tcp  open     qsm-remote
1174/tcp  open     fnet-remote-ui
256/tcp   open     fw1-secureremote
1053/tcp  open     remote-as
1174/tcp  open     fnet-remote-ui
:
749/tcp   open     kerberos-adm
541/tcp   open     uucp-rlogin
513/tcp   open     login
22/tcp    open     ssh

`ls -alht /etc` to find hacker's secret packetcapture info:

 https://drive.google.com/file/d/1ic-CFFGrbruloYrWaw3PvT71elTkh3eF/view?usp=sharing


### wireshark question
- 
