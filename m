From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 03 Dec 2014 16:31:03 +0000
Subject: Re: Problem with a host having an UNREACHABLE address ?
Message-Id: <547F3AC7.3080906@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B005721E0A@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B005721E0A@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/03/2014 11:11 AM, Boiteux Frederic wrote:
>    Hi,
> 
> I've another problem to submit to your knowledge !
> 
> I test my SCTP messaging small application between two hosts far away
> one from another, with possible packet loss on the net. Each of them is
> advertising two different [IPv4] addresses, but in fact, on one host,
> one IP isn't actually connected and can't be used for messages.
> 
> When I start SCTP messages exchanges, the hosts are using the first
> address, which is working, and messages are correctly transmitted. On
> the peer of the failing-IP host, I get notifications that this IP
> address is UNREACHABLE, it's correct. In fact, I get one notification
> each 100ms, but this can probably be setup.

No, this was an issue that was recently addressed.  See
https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id1079ac0b9be7a578dcd09f7865c2c0d6ac894a

> The problem is that after some time of message exchanges, about 20
> seconds, the hosts get a LOST notification for the association and no
> message can't be sent anymore until a new association is built.

Which host gets the LOST notification?
> 
> Should I do something when I get a UNREACHABLE peer change notification
> ?

You don't have to do anything here.

> is the LOST related to these UNREACHABLE notifications, or should I
> look for other cause ?

It might be, or it might be related to some transport selection code
that has seen some good fixes.

It would be good if you could try this on a recent kernel to see if
you still see the issue.

-vlad

> I didn't saw this behavior during my tests (on
> virtual hosts)...
> 
>                 Thanks for you help,
>                                Fred.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

