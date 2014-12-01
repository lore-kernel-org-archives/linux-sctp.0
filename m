From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Mon, 01 Dec 2014 17:12:27 +0000
Subject: Re: sctp with multi-homing : PEER_ADDR_CHANGE event for each address ?
Message-Id: <D0A6D86B-A2A7-42B7-919F-0C9C1C360FE6@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B00555F41F@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B00555F41F@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01 Dec 2014, at 16:49, Boiteux Frederic <fboiteux@prosodie.com> wrote:

>    Hello,
> 
>  I'm trying to do SCTP messages between two hosts which have each a network interface on two different subnets :
>     --- net 192.168.1.0/24-- 
>    /                                             \
> Host1                                 Host2
>    \                                            /
>      --- net 10.0.0.0/24 ----
> 
> And I try to use multi-homing and follow availability of each network access.
> 
> When Host 1 and Host2 send messages using one network (for example 192.168.1.0/24), on both hosts I receive notification of kind PEER_ADDR_CHANGE (with spc_state value SCTP_ADDR_CONFIRMED) only for the other host's address *on the other network* (in this case : 10.0.0.0/24), but not for the network address on which the SCTP message has been sent or received : is it the correct behaviour ? Is the SCTP_COMM_UP state event replace the SCTP_ADDR_CONFIRMED for the address actually used for message sending/receiving ?
You get only a PEER_ADDR_CHANGE notification, if the status of a peer address changes.
For example from unconfirmed to confirmed. If you call connect(addr), the addr is already
confirmed. So you don't get a PEER_ADDR_CHANGE notification.

Best regards
Michael
> 
>  Thanks for sharing your knowledge,
>    Fred.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

