---
layout: post
title: "Building AI-Ready Data Center Networks: My Journey with EVPN-VxLAN on NVIDIA Air"
date: 2024-11-15
categories: [networking, ai-ml]
tags: [evpn, vxlan, nvidia, data-center, gpu-networking, bgp, ai-infrastructure, network-overlay]
excerpt: "As AI workloads push the boundaries of data center networking, I explore how EVPN-VxLAN can meet these demanding requirements through hands-on experience with NVIDIA Air."
---

I have been immersing myself into all things AI for the last several years. My focus has been mainly around security, but in order to be knowledgeable enough (expert level), I needed to learn about AI from multiple angles. I have been working on numerous projects, from creating my own learning chatbot that I am teaching to be like me to building AI Agents, MCP Servers, and custom applications. One of the areas I have been doing quite a bit of research on is the actual processing and passing of data. Understanding how GPUs play a role as well as networking. That's where I am today.

As AI workloads continue to push the boundaries of data center networking, I've been exploring how modern overlay technologies like EVPN-VxLAN can meet these demanding requirements. Today, I'll share my hands-on experience building a multi-tenant data center fabric using NVIDIA Air, and how these concepts apply to real-world AI infrastructure.

## Why EVPN-VxLAN Matters for AI Infrastructure

Modern AI training requires massive east-west bandwidth between GPU nodes. Traditional three-tier networks simply can't deliver the non-blocking, low-latency connectivity needed for collective operations like AllReduce. Here's why EVPN-VxLAN has become the de facto standard:

- **Scalability**: Support thousands of nodes without spanning-tree limitations
- **Multi-tenancy**: Secure isolation between different AI projects/teams
- **Flexibility**: Easy workload mobility and dynamic provisioning
- **Performance**: Optimal paths with ECMP load balancing

## The Challenge I Set Out to Solve

I wanted to simulate a real-world scenario: building a network fabric that could support both AI training workloads and traditional enterprise applications. The requirements included:

1. Non-blocking leaf-spine architecture
2. Support for at least 4 different tenants (VNIs)
3. Sub-millisecond latency between any two hosts
4. Resilience to single points of failure
5. Easy scale-out as GPU clusters grow

## My Lab Architecture

```
                    [Spine1]                       [Spine2]
                   AS 65001                       AS 65002
                   /    |    \                  /    |    \
                  /     |     \               /     |     \
            [Leaf1]  [Leaf2]  [Leaf3]     [Leaf4]
            AS 65011  AS 65012  AS 65013  AS 65014
               |        |        |            |
            [GPU1]   [GPU2]   [GPU3]        [GPU4]
```

*Note: This is a simplified representation of the topology I built in NVIDIA Air*

### Key Design Decisions:

1. **eBGP Underlay**: Chose eBGP over iBGP for simpler configuration and better scalability
2. **Unique AS per Node**: Prevents path hunting and improves convergence
3. **/31 Point-to-Point Links**: Efficient IP usage for fabric links
4. **Loopback VTEPs**: Ensures VTEP availability regardless of link failures

## Step-by-Step Implementation

### 1. Building the Underlay

The foundation of any EVPN-VxLAN network is the IP underlay. For my testing, I set up my BGP sessions as follows:

```bash
# Spine1 BGP Configuration
net add bgp autonomous-system 65001
net add bgp router-id 10.0.0.1
net add bgp neighbor 10.1.1.1 remote-as 65011
net add bgp network 10.0.0.1/32
```

**Key Learning**: Using aggressive BGP timers (3/9) significantly improved convergence time during failure scenarios.

### 2. Implementing the Overlay

With the underlay stable, I moved on to EVPN configuration:

```bash
# Leaf EVPN Configuration
net add bgp l2vpn evpn neighbor 10.0.0.1 activate
net add bgp l2vpn evpn advertise-all-vni
net add vxlan vni10 vxlan id 10
net add vxlan vni10 vxlan local-tunnelip 10.0.0.11
```

**Interesting Discovery**: Using the `advertise-all-vni` command dramatically simplified configuration compared to manual RT configuration.

### 3. Testing and Validation

My tests to validate the design:

#### Bandwidth Testing:
```bash
# Using iperf3 to simulate AI all-reduce patterns
iperf3 -c 192.168.10.2 -P 8 -t 60
# Result: 9.4 Gbps throughput (near line-rate for 10G links)
```

#### Latency Measurement:
```bash
# Using netperf for accurate latency testing
netperf -H 192.168.10.2 -t TCP_RR
# Result: 0.248ms average RTT
```

#### Failure Testing:
- Simulated spine failure: Traffic reconverged in <1 second
- Simulated leaf failure: Only affected hosts lost connectivity
- Link flapping: EVPN dampening prevented route churn

## Notable Challenges I Encountered (And How I Solved Them)

### Challenge 1: Silent Host Issues

**Problem**: ARP suppression was causing issues with silent hosts (common in GPU nodes that only respond to requests).

**Solution**: Implemented periodic ARP refresh and adjusted ARP timeout values:
```bash
net add vxlan vni10 vxlan arp-nd-suppress off
# Or use dynamic ARP inspection instead
```

### Challenge 2: MTU Mismatches

**Problem**: Rusty mistake from not working with VxLAN in a while—I had forgotten about VxLAN's 50-byte overhead, causing packet fragmentation.

**Solution**: Increased underlay MTU to 9216 (jumbo frames):
```bash
net add interface swp1-4 mtu 9216
```

## Key Takeaways and Lessons Learned

1. **Start Simple**: Get a working underlay before adding overlay complexity
2. **Automate Everything**: Automation is key—it saves time and prevents errors
3. **Monitor Proactively**: Set up monitoring early, before you need it
4. **Document as You Go**: Just a best practice from 25+ years of experience

## How This Applies to Real AI Infrastructure

This lab directly translates to production AI environments:

- **NVIDIA DGX BasePOD** uses similar EVPN-VxLAN designs
- **Scale**: The same principles apply whether you have 4 nodes or 4,000
- **RoCE Compatibility**: EVPN-VxLAN works perfectly with RoCE for RDMA
- **Multi-tenancy**: Critical for shared GPU infrastructure

## Performance Optimization Tips for AI Workloads

Based on my testing, here are optimizations that specifically help AI traffic:

```bash
# Enable PFC for lossless Ethernet (required for RoCE)
net add interface swp1-4 pfc priority 3

# Configure ECN for congestion management
net add qos ecn mode enabled

# Optimize ECMP hashing for GPU traffic patterns
net add bgp bestpath as-path multipath-relax
```

## What's Next?

Time permitting, here's what I plan to explore next with this setup:

1. Integrating with Kubernetes CNI plugins
2. Adding SR-IOV for direct GPU networking
3. Implementing network slicing for guaranteed bandwidth
4. Exploring P4-programmable switching for custom protocols

## Resources and References

- [NVIDIA Air Platform](https://air.nvidia.com) - Free lab environment - if you're interested in NVIDIA networking, check this out!
- [Cumulus Linux Documentation](https://docs.nvidia.com/networking-ethernet-software/)
- [RFC 7432](https://tools.ietf.org/html/rfc7432) - BGP MPLS-Based Ethernet VPN
- My GitHub repo with all configurations: [evpn-vxlan-ai-fabric](https://github.com/scthornton/evpn-vxlan-ai-fabric)

## Conclusion

While it's been a number of years, I had experience with VxLAN and EVPN in my past career. Building this EVPN-VxLAN lab reinforced my understanding of modern data center networking and its critical role in AI infrastructure. My goal was to become more familiar with the NVIDIA way of doing things. The hands-on experience with NVIDIA Air, along with the reference architecture materials, gave me practical insights into the challenges of scaling these networks for massive GPU clusters.

---

**About the Author**: Scott Thornton is a technology veteran with 25+ years of experience across networking, security, cloud infrastructure, and AI. Currently focused on designing enterprise-grade agentic AI systems and implementing zero trust architectures, Scott brings deep expertise in building resilient infrastructures that support modern AI workloads. His recent work involves optimizing large-scale networks for AI/ML applications while maintaining robust security frameworks.

**Connect with me**: [LinkedIn](https://www.linkedin.com/in/scthornton/) | [GitHub](https://github.com/scthornton)