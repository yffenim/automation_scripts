# Networking Fundamentals: Homework 9

Your task is a crucial one: Restore the Resistance's core DNS infrastructure and verify that traffic is routing as expected.

### Your Objectives: 

- Review each network issue in the missions below.

- Document each DNS record type found.

- Take note of the DNS records that can explain the reasons for the existing network issue.

- Provide recommended fixes to save the Galaxy!

### Mission 1:

- Determine and document the mail servers for starwars.com using NSLOOKUP:

`nslookup -type=mx starwars.com
Server:		192.168.2.1
Address:	192.168.2.1#53

Non-authoritative answer:
starwars.com	mail exchanger = 5 alt2.aspmx.l.google.com.
starwars.com	mail exchanger = 1 aspmx.l.google.com.
starwars.com	mail exchanger = 10 aspmx2.googlemail.com.
starwars.com	mail exchanger = 10 aspmx3.googlemail.com.
starwars.com	mail exchanger = 5 alt1.aspx.l.google.com.

Authoritative answers can be found from:

`


- Explain why the Resistance isn't receiving any emails.

- Document what a corrected DNS record should be.

### Mission 2: 

Your mission:

  - Determine and document the `SPF` for `theforce.net` using NSLOOKUP.

  - Explain why the Force's emails are going to spam.

  - Document what a corrected DNS record should be.

### Mission 3:


