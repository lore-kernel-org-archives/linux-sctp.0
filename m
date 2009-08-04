From: "Doug Graham" <dgraham@nortel.com>
Date: Tue, 04 Aug 2009 03:57:29 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <4A77B1A9.5060206@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


>>  
> Why can it never happen?  If I send a bunch of large messages with
> small last fragments, your modification will allow all messages
> to be sent, because it disables Nagle for large messages, right?
> If so, many small last fragments can be outstanding at any one
> time (one from each message).  Technically, this violates Nagle,
> which aims to prevent more than one small fragment from ever being
> outstanding, but I'm not sure that it really violates the spirit
> of what Nagle is trying to accomplish.
>
> Nagle is really meant to prevent the case of an application like
> telnet from sending a whole lot of small packets containing only 1
> or a few characters.  If the receive window is, say, 10000 bytes,
> Nagle would allow 10000 packets to be outstanding, all clogging
> up the network.

I meant to say that *without* Nagle, you'd be able to have 10000 packets
outstanding.  This is what Nagle is trying to prevent.

> But if the PMTU is, say, 1000 bytes and the user
> tries to send a bunch of 1001 byte messages, your method (if I
> understand it correctly) will allow 9 unacknowledged messages to
> be outstanding.  Those 9 messages will be split into 9 full-sized
> packets and 9 packets carrying only 1 byte of data.  18 outstanding
> packets isn't all that bad.  If the user were instead sending 1000
> byte messages, Nagle would have nothing to say about it, and you'd
> be able to have 10 packets outstanding.  The increase from 10 to
> 19 outstanding packets isn't likely to cause network collapse.
>
> --Doug
>
>
