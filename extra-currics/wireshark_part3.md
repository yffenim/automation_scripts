The Security team received reports of an infected Windows host on the network. They know the following:


- Machines in the network live in the range 172.16.4.0/24.

## Filters used:
`ip.addr >= 172.16.4.1 and ip.addr <= 172.16.4.254`
`ip.addr == 172.16.4.0/24`

**why did the range calculated from subnet as a filter give different results?**

- The domain mind-hammer.net is associated with the infected computer.
- The DC for this network lives at 172.16.4.4 and is named Mind-Hammer-DC

__Steps taken__
- noticed black TCP errors
- followed conversation
- https://wiki.wireshark.org/DCE/RPC
- DCE/RPC is a specification for a remote procedure call mechanism that defines both APIs and an over-the-network protocol.
- what is DSCrackNames? enables client applications to map between the multiple names used to identify various directory service objects. For example, user objects can be identified by SAM account names (domain\username), user principal name (username@domain.com), or distinguished name.
- but its encrypted payload
-
- Now looking at TCP:
- [This frame is a (suspected) retransmission]

- no idea what to do so i return to question: what do I know? 
- An infected machine exists. It's windows. I need to find it's name.
- tried to use find, no luck
- no idea what to look for, getting rid of TCP filter
- open warning thing, find security issue, expand it
- apply it as filter

- back to `ip.addr == 172.16.4.0/24`
- filter by http: `tcp.dstport == 80 and ip.addr == 172.16.4.0/24` check red button thingie, nothing weird
-
- filter by https: `tcp.dstport == 443 and ip.addr == 172.16.4.0/24`
-Found something shady from here: [Full request URI: `http://31.7.62.214/fakeurl.htm]` in an POST
- what is the conneciton between a domain controller and a windows machine
- message justin, ask google
- justin says AD, hail mary search for AD
- obviously this doesn't make sense bc I dno't have access to AD, just network packets
- Question is now: how does a DC connect to a machine on its network
- google: 
- https://serverfault.com/questions/325765/what-protocols-are-used-when-a-machine-joins-to-a-windows-domain
-
-
## Filters used:
`ip.addr == 172.16.4.0/24 && kerberos`
`KRB5` is the kerberos authentication protocol

- again, what is my goal? find host name. 
- so search packet details by name:
- by host: nothing
- by CNAME: alias for a domain - i find something in the kerberos payload:
- `CNameString: ROTTERDAM-PC$`
-
- google: what does CNAME mean on a kerberos ticket?
- google: kerberos register with principle name host name or cname
- basically confirms that this IS possible to authenticate by CNAME so ticket is letgi 

__ANSWERS__
- Find the following information about the infected Windows machine:
- Host name: ROTTERDAM-PC$
- IP Address: 
- MAC address
- What is the username of the Windows user whose computer is infected?
- What are the IP addresses used in the actual infection traffic?
