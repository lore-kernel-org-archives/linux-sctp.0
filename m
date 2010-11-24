From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 24 Nov 2010 09:03:51 +0000
Subject: Re: Source address selection with secondary interface address
Message-Id: <4CECD4F7.7080005@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <79C4240C13B4C84B910850B96B1B431201C276DA@DEMUEXC035.nsn-intra.net>
In-Reply-To: <79C4240C13B4C84B910850B96B1B431201C276DA@DEMUEXC035.nsn-intra.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Kiss, Zoltan (NSN - HU/Budapest) wrote, at 11/23/2010 11:24 PM:
> Hi,
> 
> I still don't know am I writing to the good mailing list, because I didn't received any feedback, so please someone reply to me if I'm writing to a wrong address.
> I've started to investigate my problem in the kernel code, and I found the following:
> 
> - before SCTP layer send the packet to IP, it fills the src IP address in the skbuff (see net/sctp/output.c:333 in 2.6.21.7 kernel code)

Yes.

> - it queries the routing table in sctp_transport_route (see transport.c) to find a route to the destination (which is the secondary address of the remote end)

The destination is .36.

> - the routing entry will return an address of that interface. Here comes the problem, because it returns only one address basically, the primary address of that interface (except if src IP is explicitly specified to that route)
> - it won't match any of the associations local address, of course, because they are secondary addresses on those interfaces

The route entry you setted is:
10.0.0.36/28 via 10.0.0.153 dev vlan2

So the source ip address of the route entry is 10.0.0.153 which is not match any local address of association.
The local address of association is .146(as primary), and .154.

> - the next thing is not clear yet to me: the sctp_v4_get_dst (see protocol.c) tries to find a destination in the routing table according to its local addresses. Based on this it should choose a different interface than the actually used. Or could it be that struct dst_entry doesn't change the actual outgoing interface?

The next things is that:
The association used every local address as source address of flowi struct to search route.
If succeed, then use this source address to send HEARTBEAT ACK chunk.
So the source address of HEARTBEAT ACK chunk is .146, not .154.

so, when you set explicitly in the route enty which source address has to be used (10.0.0.154), it works also.
I think you set route entry without source address, it works still ok.
like: ip route add 10.0.0.36 dev eth0


> As I checked, 2.6.31.1 works in a similiar manner. Before I'm going forward, could anyone help me in confirming or disclaiming about the above?
> 
> Thanks for the help,
> 
> Zoltán, Kiss
> 
> -----Original Message-----
> From: Kiss, Zoltan (NSN - HU/Budapest) 
> Sent: Wednesday, November 17, 2010 5:22 PM
> To: 'linux-sctp@vger.kernel.org'
> Subject: Source address selection with secondary interface address
> 
> Hi,
> 
> I have an issue with source IP selection in case of multihoming. In my configuration the host has two addresses on different VLAN interfaces and subnets:
> 
> 1: vlan1@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
>     inet 10.0.0.148/29 scope global vlan1
>     inet 10.0.0.146/29 scope global secondary vlan1
>        valid_lft forever preferred_lft forever
> 2: vlan2@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
>     inet 10.0.0.156/29 scope global vlan2
>     inet 10.0.0.154/29 scope global secondary vlan2
>        valid_lft forever preferred_lft forever
> 
> The association uses the secondary addresses for both interface as local address:
> 
> ffff810136d2c000 ffff8101370a3b40 2   1   4  40533    7        0        0     100  5866 1111  2222  *10.0.0.146 10.0.0.154 <-> *10.0.0.20 10.0.0.36
> 
> And there is a routing entry, which tells to use vlan 2 if 10.0.0.36 is the destination:
> 
> 10.0.0.32/28 via 10.0.0.153 dev vlan2

what is 10.0.0.153?

> 
> But capturing on that interface shows the HB ACKs going back with a wrong address:
> 
> 18:43:31.917051 IP 10.0.0.36.2222 > 10.0.0.154.1111: sctp (1) [HB REQ]
> 18:43:31.917057 IP 10.0.0.146.1111 > 10.0.0.36.2222: sctp (1) [HB ACK]
> 
> More exactly, with the primary address of that association. When I changed the second address of the association to 10.0.0.156 instead of .154, it works well, .156 is used. Also, when I set explicitly in the route enty which source address has to be used (10.0.0.154), it works also.
> The thing I don't understand why does it work with the interface's secondary address only when I specify the source address explicitly? I thought they are equal from this point of view, and when SCTP stack specifies the source address, IP won't overwrite it when it is existing on that interface.
> 
> Is this a bug or a feature? Unfortunatelly I have to use a pretty old kernel, 2.6.21.7, and I tried to search the changelogs to find if this is a fixed problem, but without luck. So I decided to ask you before I make efforts to try this out on a newer kernel.
> 
> Thanks for your help beforehand!
> 
> Kiss Zoltán
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 

Best Regards
-----
Shan Wei
