---
layout: cheatsheet
title: "IPv4 and Subnetting"
description: "Notes from a long time ago!"
date: 2025-01-25
categories: [networking]
tags: [networking, ipv4, multicast, broadcast, routing, binary]
---


# IPv4 and Subnetting Cheat Sheet

## IPv4 Basics

### What is an IP Address?
An IPv4 address is a unique numerical identifier assigned to each device on a network. Every device needs a unique IP address so data can be routed to the correct destination.

**Format**: Four octets (8-bit numbers) separated by dots
- Example: `192.168.1.100`
- Range: Each octet can be 0-255 (2^8 = 256 possible values)
- Total possible addresses: ~4.3 billion (2^32)

### Binary Representation
Each octet represents 8 bits, with each bit position having a specific value:

```
Position:  8  7  6  5  4  3  2  1
Value:   128 64 32 16  8  4  2  1
Binary:    1  0  1  1  0  0  1  0  = 178 decimal
```

**Quick Conversion Tips:**
- 255 = 11111111 (all switches on)
- 0 = 00000000 (all switches off)
- 128 = 10000000 (only first switch on)

## Address Classes (Historical)

Different address classes were designed for networks of different sizes:

| Class | Range   | Default Mask        | Network Bits | Host Bits | Max Networks | Max Hosts  |
| ----- | ------- | ------------------- | ------------ | --------- | ------------ | ---------- |
| A     | 1-126   | /8 (255.0.0.0)      | 8            | 24        | 126          | 16,777,214 |
| B     | 128-191 | /16 (255.255.0.0)   | 16           | 16        | 16,384       | 65,534     |
| C     | 192-223 | /24 (255.255.255.0) | 24           | 8         | 2,097,152    | 254        |

Class A provides few networks with many host addresses each, while Class C provides many networks with few host addresses each.

## Subnet Masks

### Purpose
A subnet mask defines which portion of an IP address represents the network and which portion represents the host.

### Common Subnet Masks
```
/8  = 255.0.0.0     = 11111111.00000000.00000000.00000000
/16 = 255.255.0.0   = 11111111.11111111.00000000.00000000
/24 = 255.255.255.0 = 11111111.11111111.11111111.00000000
/25 = 255.255.255.128 = 11111111.11111111.11111111.10000000
/26 = 255.255.255.192 = 11111111.11111111.11111111.11000000
/27 = 255.255.255.224 = 11111111.11111111.11111111.11100000
/28 = 255.255.255.240 = 11111111.11111111.11111111.11110000
/29 = 255.255.255.248 = 11111111.11111111.11111111.11111000
/30 = 255.255.255.252 = 11111111.11111111.11111111.11111100
/31 = 255.255.255.254 = 11111111.11111111.11111111.11111110
/32 = 255.255.255.255 = 11111111.11111111.11111111.11111111
```

### CIDR Notation
**CIDR** (Classless Inter-Domain Routing) uses `/X` to indicate how many bits are used for the network portion.

Example: `192.168.1.0/24` means the first 24 bits identify the network, leaving 8 bits for hosts.

## Subnetting Calculations

### Key Formulas
- **Number of subnets**: 2^(borrowed bits)
- **Hosts per subnet**: 2^(host bits) - 2
- **Subnet increment**: 256 - subnet mask value

### Example: Subnetting 192.168.1.0/24 into /26
**Goal**: Create 4 subnets from a /24 network

1. **Borrowed bits**: Need 2 bits to create 4 subnets (2^2 = 4)
2. **New mask**: /24 + 2 = /26 (255.255.255.192)
3. **Hosts per subnet**: 2^6 - 2 = 62 hosts
4. **Increment**: 256 - 192 = 64

**Resulting subnets**:
```
Subnet 1: 192.168.1.0/26   (192.168.1.0 - 192.168.1.63)
Subnet 2: 192.168.1.64/26  (192.168.1.64 - 192.168.1.127)
Subnet 3: 192.168.1.128/26 (192.168.1.128 - 192.168.1.191)
Subnet 4: 192.168.1.192/26 (192.168.1.192 - 192.168.1.255)
```

### Variable Length Subnet Masking (VLSM)
VLSM allows different subnet sizes within the same network to efficiently allocate address space based on actual requirements.

**Process**:
1. List requirements in descending order
2. Assign largest subnet first
3. Use remaining space efficiently

**Example**: From 192.168.1.0/24, create:
- Department A: 100 hosts (/25 = 126 hosts)
- Department B: 50 hosts (/26 = 62 hosts)
- Department C: 20 hosts (/27 = 30 hosts)

## Special Address Types

### Network Address
- **Definition**: First address in a subnet (all host bits = 0)
- **Purpose**: Identifies the network itself
- **Example**: In 192.168.1.0/24, the network address is 192.168.1.0

### Broadcast Address
- **Definition**: Last address in a subnet (all host bits = 1)
- **Purpose**: Sends data to all devices in the subnet
- **Example**: In 192.168.1.0/24, broadcast is 192.168.1.255

### Unicast
- **Definition**: Communication between one sender and one receiver

### Multicast (Detailed)
- **Definition**: One sender to multiple specific receivers
- **Range**: 224.0.0.0 to 239.255.255.255 (Class D)

**Multicast Address Categories**:
```
224.0.0.0/24    - Local Network Control Block
  224.0.0.1     - All Systems (all hosts on subnet)
  224.0.0.2     - All Routers 
  224.0.0.22    - IGMP (Internet Group Management Protocol)
  
224.0.1.0/24    - Internetwork Control Block  
  224.0.1.1     - NTP (Network Time Protocol)
  224.0.1.60    - DHCP Server/Relay

239.0.0.0/8     - Administratively Scoped (organization-specific)
  239.255.255.250 - Universal Plug and Play (UPnP)
```

**Multicast vs Broadcast**:
- **Broadcast**: All devices in subnet receive the message
- **Multicast**: Only interested devices receive the message

### Anycast
- **Definition**: Data sent to nearest receiver in a group

## Private vs Public Addresses

### Private (RFC 1918) - Non-routable on Internet
```
Class A: 10.0.0.0/8        (10.0.0.0 - 10.255.255.255)
Class B: 172.16.0.0/12     (172.16.0.0 - 172.31.255.255)
Class C: 192.168.0.0/16    (192.168.0.0 - 192.168.255.255)
```

### Public Addresses
- Routable on the internet
- Must be unique globally

### Special Purpose Addresses (Expanded)
```
Loopback:     127.0.0.0/8     (testing local machine - "talking to yourself")
Link-Local:   169.254.0.0/16  (automatic when no DHCP - "emergency backup address")
Multicast:    224.0.0.0/4     (group communication)
Reserved:     240.0.0.0/4     (experimental use)
Broadcast:    255.255.255.255 (limited broadcast - entire local network)
This Network: 0.0.0.0/8       (this network, used in routing)
```

**APIPA (Automatic Private IP Addressing)**:
- Range: 169.254.0.0/16
- Indicates DHCP failure - useful troubleshooting clue
- Computers self-assign these addresses when unable to obtain an IP via DHCP

## Subnetting Quick Reference

### Powers of 2 Table
```
2^1 = 2      2^9 = 512
2^2 = 4      2^10 = 1024
2^3 = 8      2^11 = 2048
2^4 = 16     2^12 = 4096
2^5 = 32     2^13 = 8192
2^6 = 64     2^14 = 16384
2^7 = 128    2^15 = 32768
2^8 = 256    2^16 = 65536
```

### Common Subnet Sizes
| CIDR | Subnet Mask     | Hosts | Use Case             |
| ---- | --------------- | ----- | -------------------- |
| /30  | 255.255.255.252 | 2     | Point-to-point links |
| /29  | 255.255.255.248 | 6     | Small office         |
| /28  | 255.255.255.240 | 14    | Small department     |
| /27  | 255.255.255.224 | 30    | Medium department    |
| /26  | 255.255.255.192 | 62    | Large department     |
| /25  | 255.255.255.128 | 126   | Small company        |
| /24  | 255.255.255.0   | 254   | Standard LAN         |

## Advanced Concepts

### Supernetting (Route Aggregation)
**Definition**: Combining multiple smaller networks into one larger route for more efficient routing table management.

**Example**: Combine these networks into one route:
```
192.168.4.0/24
192.168.5.0/24  
192.168.6.0/24
192.168.7.0/24
Result: 192.168.4.0/22 (covers all four /24 networks)
```

### IPv4 Address Exhaustion & Solutions
- **Problem**: Only ~4.3 billion IPv4 addresses available
- **Solutions**:
  - NAT (Network Address Translation) - allows multiple devices to share one public IP
  - CIDR - more efficient allocation than class-based
  - IPv6 - the long-term solution

## Practical Subnetting Scenarios

### Scenario 1: Office Building with Departments
**Given**: 172.16.0.0/22 for a company with:
- Sales: 200 users
- Engineering: 150 users  
- Marketing: 75 users
- Management: 25 users
- Point-to-point links: 3 connections

**Solution approach**:
1. Start with largest requirement
2. Sales: /24 (254 hosts) → 172.16.0.0/24
3. Engineering: /24 → 172.16.1.0/24
4. Marketing: /25 (126 hosts) → 172.16.2.0/25
5. Management: /27 (30 hosts) → 172.16.2.128/27
6. P2P links: /30 each → 172.16.2.160/30, 172.16.2.164/30, 172.16.2.168/30

### Scenario 2: ISP Allocation
**Goal**: Efficiently allocate 203.0.113.0/24 to customers
```
Customer A (120 hosts): 203.0.113.0/25   (128 addresses)
Customer B (50 hosts):  203.0.113.128/26 (64 addresses)  
Customer C (25 hosts):  203.0.113.192/27 (32 addresses)
Customer D (10 hosts):  203.0.113.224/28 (16 addresses)
Remaining space:        203.0.113.240/28 (for future use)
```

## Troubleshooting Tips

### Determining if Two IPs are on Same Subnet
1. Convert both IPs and subnet mask to binary
2. Perform AND operation with subnet mask
3. If results match, they're on the same subnet

**Example**: Are 192.168.1.50 and 192.168.1.200 on same /25 network?
```
192.168.1.50  & 255.255.255.128 = 192.168.1.0
192.168.1.200 & 255.255.255.128 = 192.168.1.128
Different results = Different subnets
```

### Step-by-Step Subnet Design Process
1. **Gather requirements** (number of hosts per subnet)
2. **Sort by size** (largest first)
3. **Calculate subnet size** needed for each requirement
4. **Assign subnets** starting with largest
5. **Verify no overlaps** and document

### Common Mistakes
1. **Forgetting to subtract 2** from host count (network + broadcast addresses)
2. **Mixing up network and broadcast addresses**
3. **Not accounting for subnet zero** (192.168.1.0/25 is valid)
4. **Overlapping subnets** in VLSM scenarios
5. **Not planning for growth** - always leave room for expansion
6. **Confusing /30 with /32** - /32 is host route, /30 is smallest subnet

### Binary Conversion Shortcuts
**Fast methods for common values:**
- **128**: 10000000 (first bit only)
- **192**: 11000000 (first two bits)  
- **224**: 11100000 (first three bits)
- **240**: 11110000 (first four bits)
- **248**: 11111000 (first five bits)
- **252**: 11111100 (first six bits)
- **254**: 11111110 (first seven bits)

**Memory aid**: "128, 64, 32, 16, 8, 4, 2, 1" - each position is half the previous

### Subnet Size Quick Reference
| Prefix | Usable Hosts       | Use Case          |
| ------ | ------------------ | ----------------- |
| /32    | 0 (host route)     | Single device     |
| /31    | 0 (point-to-point) | Router links      |
| /30    | 2                  | WAN links         |
| /29    | 6                  | Very small office |
| /28    | 14                 | Small team        |
| /27    | 30                 | Department        |
| /26    | 62                 | Large department  |
| /25    | 126                | Small company     |
| /24    | 254                | Standard LAN      |

## Visual Learning Aids

### Subnet Mask Visualization
A subnet mask acts as a filter to separate network and host portions:
```
IP Address:    192.168.001.100
Subnet Mask:   255.255.255.000  
Network:       192.168.001.000  (network portion)
```

### Binary Conversion Visual Guide
```
128  64  32  16   8   4   2   1
 ┌───┬───┬───┬───┬───┬───┬───┬───┐
 │ 1 │ 1 │ 0 │ 0 │ 0 │ 0 │ 0 │ 0 │ = 192
 └───┴───┴───┴───┴───┴───┴───┴───┘
   ↑   ↑                           
 128 + 64 = 192
```

### Subnetting Memory Device
**"Subnetting Rule of 256"**: 
- Subnet increment = 256 - subnet mask octet value
- Example: /26 mask = 255.255.255.192
- Increment = 256 - 192 = 64
- Subnets: 0, 64, 128, 192

### VLSM Planning Template
```
1. List all requirements (hosts needed)
2. Sort largest to smallest  
3. Calculate required subnet size for each
4. Assign addresses sequentially
5. Document and verify no overlaps

Example planning table:
Requirement | Hosts | Subnet Size | Network Assigned
Sales       | 100   | /25 (126)   | 10.1.0.0/25
Engineering | 60    | /26 (62)    | 10.1.0.128/26  
Marketing   | 25    | /27 (30)    | 10.1.0.192/27
```

### Home Network Example
- **ISP assigns**: 203.0.113.0/29 (6 usable IPs)
- **Router gets**: 203.0.113.1 (gateway)
- **Internal network**: 192.168.1.0/24
- **NAT translates**: Private IPs ↔ Public IP

### Enterprise Example
- **Headquarters**: 10.0.0.0/16
- **Branch offices**: 10.1.0.0/24, 10.2.0.0/24, etc.
- **VLANs**: Different subnets for different departments
- **DMZ**: Separate subnet for public-facing servers