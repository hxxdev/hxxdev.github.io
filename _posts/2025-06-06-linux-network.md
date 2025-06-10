---
title: Basics of Linux Network
date: 2025-06-06
categories: [dev, os]
tags: [linux, network]
---

# 📝 About Linux Network

## 🌐 What is a Network?

A computer network allows devices (nodes) to communicate over protocols like TCP/IP.  
Every device (host) has one or more network interfaces
Each network interface has:
- An IP address (e.g., 192.168.0.5)
- A MAC address (e.g., 00:1A:2B:3C:4D:5E)


```nginx

       INTERNET
           |
    [Public IP: 203.0.113.10]
        [ISP Router]
           |
       ┌──────────────┐
       │  Your Router │ ← 192.168.1.1 (gateway)
       └──────┬───────┘
              ↓
     ┌────────┴────────┐
     │                 │
[PC: 192.168.1.100]   [Phone: 192.168.1.101]
```

All your devices in LAN shall send traffic through **192.168.1.1** which is the router's LAN IP.

Your router acts as a **gateway** which is the device that connects local network to another network(e.g. Internet).

run `traceroute google.com`. This shows you each router hop from your PC to Google.
You will see something like:

```pgsql
 1  192.168.1.1         ← Your home router (gateway)
 2  10.0.0.1            ← ISP internal router
 3  203.0.113.45        ← ISP core router
 4  142.250.46.1        ← Google server hop
 5  142.250.46.174      ← Final Google IP
```

Router keeps a **NAT table** to remember who asked for it's outgoing packets.  
Let’s say your PC sends this request:  

```nginx
[192.168.1.100:12345] → [142.250.46.174:443] (google.com)
```

Your router replaces the source IP with its public IP and sends it to `google.com`.
```nginx
[203.0.113.10:54321] → [142.250.46.174:443]
```

However, the router remembers this mapping:

```nginx
NAT Table:
203.0.113.10:54321 ↔ 192.168.1.100:12345
```

So when the reply comes from Google:

```nginx
[142.250.46.174:443] → [203.0.113.10:54321]
```

The router looks at the NAT Table and forwards the data to your PC.

## Dynamic Host Configuration Protocol(DHCP)

🏠 In a Home Network
When you turn on your computer:
It sends a DHCP request: “Hey, I’m new here. Can I get an IP?”
Your router replies: “Sure! Here’s 192.168.0.123 for you. Use this DNS, this gateway, etc.”
Your computer accepts it and joins the network.
This avoids you having to manually set IP addresses.

DHCP provides:
IP address (e.g., 192.168.0.123)
Subnet mask (e.g., 255.255.255.0)
Default gateway (e.g., your router: 192.168.0.1)
DNS servers (e.g., 1.1.1.1 or 8.8.8.8)
Lease time (how long your IP is valid)

> **_NOTE_**: DHCP reservation is when your router always assigns the same IP address to a specific device based on its MAC address.



## 📦 Network in Linux

### Network Interfaces

Network interfaces can be shown by `ip link show`.

| Interface	| Meaning                                       |
| :-:       | :-                                            |
| eth0	    | Wired Ethernet                                |
| wlan0	    | Wireless                                      |
| lo	    | Loopback (127.0.0.1)                          |
| docker0	| Virtual bridge for Docker                     |
| enp0s3,   | ens33	Renamed Ethernet (predictable naming)   |

Each interface can be up(active)/down(deactive) by:

```bash
sudo ip link set eth0 up
sudo ip link set eth0 down
```

Each interface can have:
- IPv4 address (e.g., 192.168.1.10)
- IPv6 address (e.g., fe80::1)

IP address can be checked by `ip addr show` or simply `ip a`.

### 🧭 Routing Table

Routing table decides where packets go based on the destination IP.
Whenever your computer sends data (like a webpage request), the routing table decides which interface to send it on — like a traffic director.

To view it, simply run `ip route`.

You will see something like:

```nginx
default via 192.168.1.1 dev eth0
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.10
```
`default via 192.168.1.1 dev eth0` means "To go anywhere outside my local subnet (192.168.1.x), send packets to 192.168.1.1(usually your router) through network interface `eth0`."

`192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.10` ensure any packet to 192.168.1.x are sent directly by `eth0` without gateway.

> **_NOTE_**: `/24` is a CIDR notation. It masks the last 8 bits of IP(`255.255.255.0`). Therefore, `192.168.1.0/24` means any IP ranging from `192.168.1.0` to `192.168.1.255`.

Example:
Let’s say your PC is 192.168.1.100, and you want to ping:
192.168.1.101 ✅ — matches 192.168.1.0/24, send directly via eth0
8.8.8.8 ❌ — doesn’t match 192.168.1.0/24, use default route (via 192.168.1.1)

> **_NOTE:_**  `8.8.8.8` is commonly known as the primary IP address of Google's Public DNS service.  
`8.8.4.4` is commonly known as the secondary IP address of Google's Public DNS service.

### Netfilters

| Hook Name   | When It's Triggered                        | Purpose                                                    |
| :-:         | :-                                         |                                                            |
| PREROUTING  | As soon as a packet enters the system      | Used for DNAT, early drops                                 |
| INPUT       | For packets destined to your machine       | Firewall for local services                                |
| FORWARD     | For packets passing through your machine   | Routers, bridges, VMs, Docker                              |
| OUTPUT      | For packets created by your machine        | Controls outbound traffic                                  |
| POSTROUTING | Just before the packet leaves an interface | Used for SNAT, masquerading                                |
### Overall Summary

{ %plantuml% }
title Linux Packet Flow with Netfilter and Interfaces

' Define external network
cloud "Internet" as Internet

' Interfaces
rectangle "eth0\ninterface" as eth0
rectangle "wlan0\ninterface" as wlan0

' Netfilter PREROUTING
rectangle "Netfilter\nPREROUTING chain\n(NAT/drop)" as prerouting

' Routing decision
rectangle "Routing Table" as routing

' Local processing path
rectangle "Netfilter\nINPUT chain\n(allow/deny)" as input
rectangle "Your application" as app

' Forwarding path
rectangle "Forward to\nanother device" as forward
rectangle "POSTROUTING(SNAT/drop)" as postrouting

' Flow from Internet through eth0
Internet --> eth0
Internet --> wlan0
eth0 --> prerouting
prerouting --> routing

' Routing branches
routing --> input : if destination is local
routing --> forward : if forwarded
forward --> postrouting
postrouting --> eth0

' Local path
input --> app
{ %endplantuml% }

### 📶 Domain Name System(DNS)

DNS converts domain names to IP addresses and vice versa.

You can check your DNS configuration by:

```bash
cat /etc/resolve.conf
```

You will see something like:

```nginx
nameserver 8.8.8.8
```

### 🔗 Network Ports and Services

| Protocol	| Port	| Service   |
| :-:       | :-:   | :-:       |
| TCP	    | 22	| SSH       |
| TCP	    | 80	| HTTP      |
| TCP	    | 443	| HTTPS     |

















---

## 🔥 What is a Firewall?

A firewall is a security system that controls incoming and outgoing network traffic based on predefined rules.
- blocks unwanted traffic(e.g., hackers)
- allows legitimate communication(e.g. browser or SSH connection)

## 🧱 What is firewalld?
`firewalld` is a daemon for firewall management. It provides:
- A high-level interface to manage firewall rules.
- Dynamic rule changes without restarting the firewall.
- Support for zones, rich rules, and runtime vs permanent configurations.

It's basically a frontend that uses `iptables`, `ip6tables`, or `nftables` which are the backends.

`firewalld` uses **zones** to apply different rules to different network interfaces.

### 🌐 What are Zones?

**Zones** are a way to define different levels of trust for network interfaces(e.g. `eth0`).
Each zone has its own set of firewall rules.

| Zone     | Description                                    |
| :-:      | :-                                             |
| public   | For untrusted networks (e.g., Wi-Fi)           |
| home     | For trusted networks (e.g., home LAN)          |
| internal | More trusted than public, less than trusted    |
| trusted  | All traffic is accepted                        |
| drop     | All traffic is dropped (no response)           |

### Using firewalld

| Zone                                                             | Description                                                         |
| :-:                                                              | :-                                                                  |
| `firewall-cmd --get-active-zones`                                | This command shows which interfaces are assigned to which zones.    |
| `firewall-cmd --zone=public --list-services`                     | List allowed services in a zone `public`.                           |
| `firewall-cmd --zone=public --list-ports`                        | List allowed ports in a zone `public`.                              |
| `firewall-cmd --zone=public --change-interface=eth0 --permanent` | assign interface `eth0` to zone `public`.                           |
| `firewall-cmd --zone=public --remove-interface=eth1 --permanent` | remove interface `eth1` from zone `public`.                         |
| `firewall-cmd --zone=public --add-port=2222/tcp --permanent`     | open port `2222` in the public zone for incoming traffic.           |
| `firewall-cmd --zone=public --remove-port=2222/tcp --permanent`  | close port `2222` in the public zone for incoming traffic.          |
| `firewall-cmd --reload`                                          | apply configurations and reload.                                    |

> **_NOTE_**: You can check your port status at [yougetsignal.com](https://www.yougetsignal.com/tools/open-ports/).

## 🔧 What are iptables and nftables?

`iptables` is a low-level command-line utility for configuring the Linux kernel's firewall.
Controls traffic by defining chains of rules.
Each rule specifies what to do with certain packets (accept, drop, forward, etc.).
Supports NAT, packet mangling, logging, etc.

`nftables` is the successor to `iptables`, introduced by the Linux kernel to unify and modernize firewall configuration.
`nftables` is preferred over `iptables` for these benefits:
- Unified framework for IPv4, IPv6, ARP, and more.
- Easier syntax and better performance.
- Centralized ruleset (instead of split across multiple tables).

Nowadays, `firewalld` uses `nftables` by default instead of `iptables`.

{ %plantuml% }
title firewalld Backend Architecture

' Define components
component "firewalld\n(frontend manager)" as firewalld

package "Backends" {
    component "iptables/ip6tables\n(older backend)" as iptables
    component "nftables\n(modern backend)" as nftables
}

' Define relationships
firewalld --> iptables : uses
firewalld --> nftables : uses
{ %endplantuml% }

> **_NOTE:_**  `iptables` is deprecated. Use `nftables` if possible.
`firewalld` can be configured to use `nftables` by editing `/etc/firewalld/firewalld.conf`.
Look for `FirewallBackend`. `nftables` can be used by `FirewalldBackend=nftables`.
After making changes, reload by `sudo systemctl restart firewalld` or `firewall-cmd --reload`.

### Using nftables


There are 3 concepts(Table, Chain, Rule) to know to make use of `nftables`.

#### Table

A table is a top-level container containing chains.
It groups chains and defines a family.

| family    | iptables utility       |
| :-:       | :-                     |
| ip        | for IPv4 only          |
| ip6       | for IPv6 only          |
| inet      | for both IPv4 and IPv6 |
| arp       | for arp                |
| bridge    | ebtables               |

Table with `inet` family can be defined by:

```nft
table inet my_table
```

#### Chain

A chain holds rules and may be linked to a hook in the packet processing path.

- Base chains are attached to a hook (e.g., input, forward, output, prerouting, postrouting).  
Base chains have:
    - type: filter, nat, route, tproxy
    - hook: where it attaches in the kernel
    - priority: determines order vs other chains
    - policy: accept or drop by default
- Regular chain: used for jumping, like a subroutine

Base chain with `input` hook can be defined by:

```nft
chain input {
    type filter hook input priority 0;
    policy drop;
}
```


#### Rule

A rule is basically a condition + action.



### Summary of Commands

| Task                                | Command                                                                  |
| :-:                                 | :-:                                                                      |
| See real-world hops                 | `traceroute google.com`                                                  |
| See all interfaces                  | `ip link`                                                                |
| See IP addresses                    | `ip a`                                                                   |
| See routing table                   | `ip route`                                                               |
| Ping your gateway                   | `ping 192.168.1.1`                                                       |
| List listening services             | `ss -tuln`                                                               |
| Create nftables rule to allow HTTP  | `nft add rule inet myfw input tcp dport 80 accept`                       |
| Block pings (ICMP)                  | `nft add rule inet myfw input icmp type echo-request drop`               |
