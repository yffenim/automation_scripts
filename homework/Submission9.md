# Networking Fundamentals: Homework 9

### Follow-Up Questions
- mission 1: why are they still able to send mail if the mail servers are down?


Your task is a crucial one: Restore the Resistance's core DNS infrastructure and verify that traffic is routing as expected.

### Your Objectives: 

- Review each network issue in the missions below.

- Document each DNS record type found.

- Take note of the DNS records that can explain the reasons for the existing network issue.

- Provide recommended fixes to save the Galaxy!

### Mission 1:

__Network Issue:__

The Resistence has taken down their primary DNS and email servers in order to a build and deply a new DNS and mail server but they are not currently receiving emails because they have not configured MX Records for the new email servers to the correct primary and secondary mail servers.

__DNS record type found:__ 

We want to check the  MX records (mail exchanger records) which specify which mail servers can accept email that's sent to our domain with: `starwars.com`: `nslookup -type=mx starwars.com`

__DNS records that can explain the reasons for existing network issue:__

According to our `nslookup` results, the new mail servers are not listed. The primary mail server for starwars.com should be `asltx.l.google.com` and the secondary email should be `asltx.2.google.com`.

`Server:		192.168.2.1
Address:	192.168.2.1#53

Non-authoritative answer:
starwars.com	mail exchanger = 5 alt2.aspmx.l.google.com.
starwars.com	mail exchanger = 1 aspmx.l.google.com.
starwars.com	mail exchanger = 10 aspmx2.googlemail.com.
starwars.com	mail exchanger = 10 aspmx3.googlemail.com.
starwars.com	mail exchanger = 5 alt1.aspx.l.google.com.`

Instead, the primary server (indicated by the numeric value of 1 before the server address) is: `aspmx.l.google.com.`
The secondary server is either: `aspmx.l.google.com.` or `alt1.aspx.l.google.com.` as both addresses have the next priority value of 5.

It's likely that these are the old servers and someone has forgotten to change the MX record configuration to the new servers at: `asltx.l.google.com` and `asltx.2.google.com`.

__Recommended fixes to save the Galaxy!__

The corrected MX record should be:

`starwars.com mail exchanger = 1 asltx.l.google.com
starwars.com mail exhanger = 2 asltx.2.google.com`


### Mission 2: 

__Network Issue:__ 

Official emails are going into spam or being blocked because the SPF record has not been updated to reflect the new IP address of their mail server. Since the SPF record is used to indicate which mail servers are allowed to send emails on behalf of a domain, emails from the IP address of the new mail server (missing from the current SPF record) is likely to be filtered out as spam.

__DNS record type found:__

Looking up the SPF (Sender Policy Framework) record using `nslookup -type=txt theforce.net | grep spf` to find the following SPF record:

`theforce.net	text = "v=spf1 a mx mx:smtp.secureserver.net include:aspmx.googlemail.com ip4:104.156.250.80 ip4:45.63.15.159 ip4:45.63.4.215"`

Alternatively, we can also use the `dig` DNS lookup utility: `dig theforce.net txt | grep spf` which confirms the same SPF record:

`theforce.net.		3498	IN	TXT	"v=spf1 a mx mx:smtp.secureserver.net include:aspmx.googlemail.com ip4:104.156.250.80 ip4:45.63.15.159 ip4:45.63.4.215"`

__DNS records that can explain the reasons for existing network issues:__

The servers currently configured to be allowed to send emails for the domain are from the following IPv4 hosts: `104.156.250.80`, `45.63.15.159`, and `45.63.4.215`. The new one (`45.23.176.21`) has not beed added. It is likely that similar to Mission 1, someone has forgotten to update the `DNS` text record to reflect the required record pointing to the new mail server.

__Recommended fixes to save the Galaxy!__

We have not been given data regarding whether the other mail server IP addresses are up -- if we assume that we do not need to removed, we only need to add the missing IP so that the corrected record should be:

`theforce.net.		3498	IN	TXT	"v=spf1 a mx mx:smtp.secureserver.net include:aspmx.googlemail.com ip4:104.156.250.80 ip4:45.63.15.159 ip4:45.63.4.215 ip4:45.23.176.21` 

### Mission 3:

__Network Issue:__



__DNS record type found:__ 

We need to check the `CNAME` record of the `resistance.theforce.net` domain in order to see why it is not redirecting to `theforce.net`. A `CNAME` record is used to point one domain to another so if we want the `resistance.theforce.net` subdomain to point to `theforce.net`, we need to have the `CNAME` configured to do so.

__DNS records that can explain the reasons for existing network issues:__

Looking up the `CNAME` (Canonical Name) of `www.theforce.net` with `nslookup` in interactive mode in order to examine a correct `CNAME` configuration where `www.theforce.net` will be redirected to `theforce.net`:

`nslookup` to enter into interactive mode

`> set query=CNAME` to set the query type to `CNAME`
`> www.theforce.net` to set the domain to query 

This gives the following (relevant) output:

`www.theforce.net	canonical name = theforce.net.` This means that `www.theforce.net` domain  will redirect to the canonical name at `theforce.net`.

Alternatively, we can also use single line command `nslookup -type=CNAME www.theforce.net` or 
`dig www.theforce.net | grep CNAME` if we like to confirm things in multiple ways before moving forward:

`www.theforce.net.	2321	IN	CNAME	theforce.net.` is the output from `dig` indicating the correct configuration.

Looking up why our `resistance.theforce.net` is not redirecting to `theforce.net`:

Using `nslookup -type=CNAME resistance.theforce.net` we get:`** server can't find resistance.theforce.net: NXDOMAIN` which is an error message indicating the  DNS query failed because the domain name queried (`resistance.theforce.net`) does not exist or that the query could not "know" that it exists. This makes sense because we are supposed to be redirecting `resistance.theforce.net` to the `CNAME` domain `theforce.net` but the `DNS CNAME` record is missing so it is not redirecting.

However, other reasons that we could be receiving the `NXDOMAIN` error could mean (if we assume we have not made a user error in our query, i.e. mistyping the address):
- the domain is currently offline or is having server issues
- a security control blocking the domain 
- domain could be compromised or that malware exists

To follow-up, we can first check if the domain is offline using `https://isitup.org/resistance.theforce.net` which indicates that the domain is down. To fix this, we need to correct the `CNAME` record configuration to have this line:

__Recommended fixes to save the Galaxy!__

Correct the DNS record to be: `resistance.theforce.net	canonical name = theforce.net.`

### Mission 4 ???

__Network Issue:__

The `DNS` records for `princessleia.site` have not been configured to reference the back up servers.

__DNS record type found:__

Checking the `DNS` name server records: `nslookup -type=NS princessleia.site`

`Non-authoritative answer:
princessleia.site	nameserver = ns26.domaincontrol.com.
princessleia.site	nameserver = ns25.domaincontrol.com.`

__DNS records that can explain the reasons for existing network issues:__

The current name servers are `ns26.domaincontrol.com` and `ns25.domaincontrol.com` and the backup server (`ns2.galaxybackup.com`) provided by the Resistance is missing.

__Recommended fixes to save the Galaxy!__

We need to add a reference to the backup `DNS` server: 

`princessleia.site nameserver = ns2.galaxybackup.com.`

### Mission 5: 

__Network Issue:__ 

We are experiencing slow network traffic from the planet of `Batuu` to `Jedha` due to an attack on Planet N and need to find a better path. 

__Recommended fixes to save the Galaxy!__

Using the `OSPF` (Open Shortest Path First):
D C E F J I L Q T V 
1 2 1 1 1 6 4 2 2 2

This path has 23 hops, does not include `Planet N`, and is the shortest distance:
Planet Batuu → D → C → E → F → J → I → L → Q → T → V → Planet Jedha

### Mission 6: 

Results from running `aircrack-ng Darkside.pcap -w ~/Documents/SecLists/Passwords/WiFi-WPA/probable-v2-wpa-top4800.txt` with the password list downloaded from: https://github.com/danielmiessler/SecLists/blob/master/Passwords/WiFi-WPA/probable-v2-wpa-top4800.txt


      `[00:00:00] 3432/4800 keys tested (10349.88 k/s)

      Time left: 0 seconds                                      71.67%

                          KEY FOUND! [ dictionary ]


      Master Key     : B3 52 50 D0 9F 8E AB BD 0D 9E 3D D3 A3 62 12 82
                       9E FA 89 FC 19 1D A4 4A 3E 7A 40 9C D4 DF 68 DC

      Transient Key  : DF 26 D4 B0 47 58 E5 AB 33 66 35 14 87 70 7E 46
                       9E 93 3F 48 3A AE BE F5 0A 58 81 82 B1 59 56 A4
                       05 C4 04 F4 F0 E2 27 45 49 3D 51 9C A0 E0 AA 83
                       5F 63 D5 35 A5 56 52 24 35 70 31 08 BE 99 F6 15

      EAPOL HMAC     : 3E B9 D6 B8 63 69 A7 8B 83 EA 2A 3A 71 ED CF 59`


The password is: `dictionary`. We use this password to decrypt the WPA traffic via Wireshark. 

Host:
Sender MAC address: IntelCor_55:98:ef (00:13:ce:55:98:ef)
Sender IP address: 172.16.0.101 (172.16.0.101)

Additional IPs/MAC addresses of interest:
172.16.0.9 is at 00:14:bf:0f:03:30
68.9.16.30 is at 00:0f:66:e3:e4:01 which is the same mac as:
68.9.16.25 is at 00:0f:66:e3:e4:01 which is the same mac as:
10.1.1.50 is at 00:0f:66:e3:e4:01

Looking for:
Sender MAC address: Cisco-Li_e3:e4:01 (00:0f:66:e3:e4:01)
Sender IP address: 172.16.0.1 (172.16.0.1)

### Mission 7:

Viewing the DNS record from Mission #4, specifically looking for a hidden message in the `TXT` record:

`nslookup -type=txt princessleia.site` to find this message:

`princessleia.site	text = "Run the following in a command line: telnet towel.blinkenlights.nl or as a backup access in a browser: www.asciimation.co.nz"`

**Screenshot provided in the same folder as this assignment!**

Note: This was the coolest last homework question ever! And thank you for reading.
  
