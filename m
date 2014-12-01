From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Mon, 01 Dec 2014 18:50:53 +0000
Subject: Re: sctp with multi-homing : PEER_ADDR_CHANGE event for each address ?
Message-Id: <698C7701-ACE9-40E4-B396-EBDA9231C6FC@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B00555F41F@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B00555F41F@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01 Dec 2014, at 18:27, Boiteux Frederic <fboiteux@prosodie.com> wrote:

>   Hello Michael,
> 
>> You get only a PEER_ADDR_CHANGE notification, if the status of a peer address changes.
>> For example from unconfirmed to confirmed. If you call connect(addr), the addr is already confirmed. So you don't get a PEER_ADDR_CHANGE notification.
> 
> I don't use connect(addr), but the message -oriented ' sctp_sendmsg()' function with one target address... And then 
OK, that is fine. All addresses provide by the upper layer are confirmed.. It does not actually
matter if it is via sendmsg(), sctp_sendmsg(), connect(), sctp_connectx().
> I get a COMM_UP when the corresponding association is going up.   On the receiving host, I get the COMM_UP notification with the message...
On the other end, the destination address of the INIT-ACK is confirmed automatically. See
http://tools.ietf.org/html/rfc4960#section-5.4

Best regards
Michael
> 
> 	Fred.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

