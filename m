From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
Date: Mon, 10 Sep 2012 06:33:34 +0000
Subject: Re: [Lksctp-developers] route/dst_entry caching issue
Message-Id: <504D89BE.1060901@nsn.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------010704080508050203020304"
List-Id: <linux-sctp.vger.kernel.org>
References: <5047370C.8080604@nsn.com>
In-Reply-To: <5047370C.8080604@nsn.com>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------010704080508050203020304
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

re-sending after 4 days, I believe something went wrong.

Regards,

Matija

On 06.09.2012 13:23, Matija Glavinic Pecotic wrote:
> Hello,
>
> On 05.09.2012 16:55, ext Vlad Yasevich wrote:
>> On 09/05/2012 07:27 AM, Matija Glavinic Pecotic wrote:
>>> Hello lksctp developers,
>>>
>>> a while back we noticed below described issue.
>>>
>>> In order to quick-fix this, we implemented following workaround:
>>>
>>> 1) added interface to sctp for invalidating all dst entries on all
>>> associations (0002-sctp-export-dst-entries-invalidation-if.patch) - this
>>> is on top of below mentioned patch
>>> (0001-sctp-check-cached-dst-before-using-it.patch)
>>>
>>> 2) in a separate module route and ipsec events are monitored and upon
>>> addition and deletion of routes, along with xfrm events interface is
>>> called. This is done by netlink socket opened within the kernel. If
>>> interested, I can share that one as well.
>>>
>>> Could you please give some comments on both workaround and mentioned
>>> issue?
>>
>> These workarounds should not be needed.  The code should function
>> correctly.  We just need to get to the root cause...
>>
>>
>>>
>>> Thanks and regards,
>>>
>>> Matija
>>>
>>> On 12.06.2012 19:10, ext Matija Glavinic Pecotic wrote:
>>>> Hello,
>>>>
>>>> We're facing an issue regarding route change and startup of ipsec
>>>> tunnel. Here is setup and test scenarios:
>>>>
>>>> 1) Setup
>>>> Simple sctp client and server. Client is bound to the loopback address
>>>> 10.0.0.1 and it is connected to the server via eth3 (192.168.2.1) which
>>>> is in LAN with eth2 (192.168.2.2) and eth3 (192.168.2.3) on the server
>>>> and server is bound to the 20.0.0.1 which is loopback.
>>>>
>>>> Client:
>>>>
>>>> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
>>>>        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>>>>        inet 10.0.0.1/8 scope global lo
>>>>        inet6 ::1/128 scope host
>>>>           valid_lft forever preferred_lft forever
>>>>
>>>> 13: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
>>>> state UP
>>>>        link/ether 00:40:43:30:81:80 brd ff:ff:ff:ff:ff:ff
>>>>        inet 192.168.2.1/24 brd 192.168.2.255 scope global eth3
>>>>        inet6 fe80::240:43ff:fe30:8180/64 scope link
>>>>           valid_lft forever preferred_lft forever
>>>>
>>>> 192.168.2.0/24 dev eth3  proto kernel  scope link  src 192.168.2.1
>>>> 192.168.253.0/24 dev rio0  proto kernel  scope link  src 192.168.253.16
>>>> 192.168.254.0/23 dev eth0  proto kernel  scope link  src 192.168.255.1
>>>> 20.0.0.0/8 via 192.168.2.1 dev eth3  scope link
>>
>> Should the above route be via 192.168.2.2 (typo), or is this correct?
>
> No, I want to say that traffic on the lo is to go over eth3 interface. I
> dont want to tie it directly to 192.168.2.2.
>
>>>>
>>>> Server:
>>>>
>>>> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
>>>>        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>>>>        inet 20.0.0.1/8 scope global lo
>>>>        inet6 ::1/128 scope host
>>>>           valid_lft forever preferred_lft forever
>>>>
>>>> 12: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
>>>> state UP
>>>>        link/ether 00:40:43:b1:f8:ae brd ff:ff:ff:ff:ff:ff
>>>>        inet 192.168.2.2/24 brd 192.168.2.255 scope global eth2
>>>>        inet6 fe80::240:43ff:feb1:f8ae/64 scope link
>>>>           valid_lft forever preferred_lft forever
>>>>
>>>> 13: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
>>>> state UP
>>>>        link/ether 00:40:43:b1:f8:af brd ff:ff:ff:ff:ff:ff
>>>>        inet 192.168.2.3/24 brd 192.168.2.255 scope global eth3
>>>>        inet6 fe80::240:43ff:feb1:f8af/64 scope link
>>>>           valid_lft forever preferred_lft forever
>>>>
>>>> 192.168.2.0/24 dev eth2  proto kernel  scope link  src 192.168.2.2
>>>> 192.168.2.0/24 dev eth3  proto kernel  scope link  src 192.168.2.3
>>>> 192.168.253.0/24 dev rio0  proto kernel  scope link  src 192.168.253.16
>>>> 192.168.255.0/24 dev eth0  proto kernel  scope link  src 192.168.255.2
>>>> 10.0.0.0/8 via 192.168.2.1 dev eth2
>>>> 10.0.0.0/8 via 192.168.2.1 dev eth3  metric 10
>>>>
>>>> Server listens on 20.0.0.1 and when client is connected it sends
>>>> message
>>>> indefinitely
>>>>
>>>> Kernel is 2.6.32.58 and sctp is applied with patch from this thread:
>>>> http://sourceforge.net/mailarchive/message.php?msg_id=25786006
>>>> (0001-sctp-check-cached-dst-before-using-it.patch)
>>>>
>>>> 2) Test scenario 1
>>>>
>>>> Start sctp_server
>>>> Start sctp_client -> clients receives messages from the server
>>>> Observe traffic flow -> as expected it goes over eth2 on the server
>>>> Delete route 10.0.0.0/8 via 192.168.2.1 dev eth2
>>>> Traffic still goes over eth2, on server restart it goes over eth3
>>
>> Very interesting... Upon route deletion the cache should be invalidated
>> and sctp should look-up a new route.
>>
>> Can you turn on debug output in net/sctp/protocol.c and see what the
>> route printed is after the delete call?
>>
>> You can turn it on by adding #define CONFIG_SCTP_DBG_MSG to the top of
>> protocol.c
>
> attached two logs, in one, cable was plugged out, we can see that stack
> copes with it, especially since we have new dst (I added print of address)
>
>>     if (dst)
>>         SCTP_DEBUG_PRINTK("rt_dst:%pI4, rt_src:%pI4, rt@0x%p\n",
>>                   &rt->rt_dst, &rt->rt_src, rt);
>
>
> other log is as scenario mentioned, additional info inside regarding
> routes. You can look for:
>
> 2004-01-01T00:01:48.329137+00:00 (none) [notice]      root:  Deleting route
>
> Scenario went as described previously, traffic continued over eth2
>
> Thanks and regards,
>
> Matija
>
>>
>> -vlad
>>
>>>>
>>>> For reference, I've run also TCP server/client which does the same
>>>> thing, after deletion of mentioned route traffic continued over eth3.
>>>> Other kinds of traffic are also rerouted on route deletion (icmp)
>>>>
>>>> 3) Test scenario 2
>>>>
>>>> Setup same as before, eth3 on server isn't used.
>>>>
>>>> Start sctp_server
>>>> Start sctp_client -> traffic ok
>>>> Start ipsec tunnel:
>>>>        left=192.168.2.2
>>>>        leftsubnet=20.0.0.0/24
>>>>        right=192.168.2.1
>>>>        rightsubnet=10.0.0.0/24
>>>> After start of ipsec tunnel, traffic went over same dst unencrypted for
>>>> a short period of time.
>>>> For reference, again same scenario with TCP server/client -> traffic
>>>> started to be encrypted immediately
>>>>
>>>> ------
>>>>
>>>> In my opinion there is problem with cached dst_entry. I've tried
>>>> following:
>>>>
>>>> [sctp.h]
>>>> /* The cookie is always 0 since this is how it's used in the
>>>>     * pmtu code.
>>>>     */
>>>> static inline struct dst_entry *sctp_transport_dst_check(struct
>>>> sctp_transport *t)
>>>> {
>>>>      if (t->dst) {
>>>>          dst_release(t->dst);
>>>>          t->dst = NULL;
>>>>      }
>>>>
>>>>      return t->dst;
>>>> }
>>>>
>>>> With this I just wanted to force sctp to route every time it wants to
>>>> send packet, and after this change above mentioned scenarios passed.
>>>> Here is my short analysis, ignore it if I got something wrong: I see
>>>> potential problem with SCTP's dst_entry: struct dst_entry *dst which is
>>>> member of sctp_transport. For example, ipv4&6 implement operations on
>>>> dst_entry (ipv4_dst_ops ) which are to be done when event occurs, such
>>>> as unreachability, route deleteion, etc. SCTP doesn't, and it also
>>>> doesn't use dst_entries from ipv*. In this way, only events which
>>>> impact
>>>> SCTPs dst_entries are default ones, NETDEV_DOWN and NETDEV_UNREGISTER
>>>> and these are only which will be noted with dst_check().
>>>>
>>>> Could you comment please? I'll be glad to make tests/verifications or
>>>> provide any sort of help on this.
>>>>
>>>> Thanks & regards,
>>>>
>>>> Matija
>>>>
>>>> ------------------------------------------------------------------------------
>>>>
>>>>
>>>> Live Security Virtual Conference
>>>> Exclusive live event will cover all the ways today's security and
>>>> threat landscape has changed and how IT managers can respond.
>>>> Discussions
>>>> will include endpoint security, mobile security and the latest in
>>>> malware
>>>> threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
>>>> _______________________________________________
>>>> Lksctp-developers mailing list
>>>> Lksctp-developers@lists.sourceforge.net
>>>> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>>>>
>>>
>>>
>>>
>>> ------------------------------------------------------------------------------
>>>
>>> Live Security Virtual Conference
>>> Exclusive live event will cover all the ways today's security and
>>> threat landscape has changed and how IT managers can respond.
>>> Discussions
>>> will include endpoint security, mobile security and the latest in
>>> malware
>>> threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
>>>
>>>
>>>
>>> _______________________________________________
>>> Lksctp-developers mailing list
>>> Lksctp-developers@lists.sourceforge.net
>>> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>>>
>>
>>
>> ------------------------------------------------------------------------------
>>
>> Live Security Virtual Conference
>> Exclusive live event will cover all the ways today's security and
>> threat landscape has changed and how IT managers can respond. Discussions
>> will include endpoint security, mobile security and the latest in malware
>> threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
>> _______________________________________________
>> Lksctp-developers mailing list
>> Lksctp-developers@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>>
>


--------------010704080508050203020304
Content-Type: application/x-zip-compressed;
 name="logs.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="logs.zip"

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
bO5ubz9tPo65vVVCb8ab0eb01mHz8uXm+b93d8/f3f78/P7++Gz8dyNe/p5/s7n/+e341DA+
NPxvMyYtHzf73TH6v3/3f1BLAwQKAAAAAACxZiZBAAAAAAAAAAAAAAAABQAAAGxvZ3MvUEsB
AhQACgAAAAAAvWgmQQAAAAAAAAAAAAAAABQAAAAAAAAAAAAQAAAAAAAAAGxvZ3MvY2FibGVf
cGx1Z19vdXQvUEsBAhQAFAACAAgAgmYmQZdiW9lNFAAAf90AAC4AAAAAAAAAAQAgAAAAMgAA
AGxvZ3MvY2FibGVfcGx1Z19vdXQvbWVzc2FnZXNfY2FibGVfcGx1Z2dlZF9vdXRQSwECFAAK
AAAAAAC4aCZBAAAAAAAAAAAAAAAADwAAAAAAAAAAABAAAADLFAAAbG9ncy9yb3V0ZV9kZWwv
UEsBAhQAFAACAAgAhWgmQdmVozJqJAAAkNMBACYAAAAAAAAAAQAgAAAA+BQAAGxvZ3Mvcm91
dGVfZGVsL21lc3NhZ2VzX3JvdXRlX2RlbGV0aW9uUEsBAhQACgAAAAAAsWYmQQAAAAAAAAAA
AAAAAAUAAAAAAAAAAAAQAAAApjkAAGxvZ3MvUEsFBgAAAAAFAAUAYgEAAMk5AAAAAA==
--------------010704080508050203020304--
