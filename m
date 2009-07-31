From: "Doug Graham" <dgraham@nortel.com>
Date: Fri, 31 Jul 2009 13:11:00 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <20090731131100.GE2758@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jul 31, 2009 at 09:30:48AM +0200, Michael T?xen wrote:
> On Jul 31, 2009, at 3:17 AM, Doug Graham wrote:
> >13 2.002632    10.0.0.15   10.0.0.11   DATA (1452 bytes data)
> >14 2.203092    10.0.0.11   10.0.0.15   SACK
> >15 2.203153    10.0.0.15   10.0.0.11   DATA (2 bytes data)
> >16 2.203427    10.0.0.11   10.0.0.15   SACK
> >17 2.203808    10.0.0.11   10.0.0.15   DATA (1452 bytes data)
> >18 2.403524    10.0.0.15   10.0.0.11   SACK
> >19 2.403686    10.0.0.11   10.0.0.15   DATA (2 bytes data)
> >20 2.603285    10.0.0.15   10.0.0.11   SACK
> >
> >What bothers me about this is that Nagle seems to be introducing a  
> >delay here.
>
> This is the common bad interaction between Nagle and delayed SACKs.
>
> >The first DATA packets in both directions are MTU-sized packets
> >yet both the Linux client and the BSD server wait 200ms until they get
> >the SACK to the first fragment before sending the second fragment.
> >The server can't send its reply until it gets both fragments, and the
> >client can't reassemble the reply until it gets both fragments, so  
> >from
> >the application's point of view, the reply doesn't arrive until 400ms
> >after the request is sent.  This could probably be fixed by disabling
> >Nagle with SCTP_NODELAY, but that shouldn't be required.  Nagle is  
> >only supposed to prevent multiple outstanding *small* packets.

> Yes, but Nagle operates at the level of chunks...
> This problem is one of the reasons why we have
> draft-tuexen-tsvwg-sctp-sack-immediately-02
> The kernel can set the I-Bit on the first chunk...
> Currently the only way around this is to disable Nagle at all...

I don't understand how Nagle operating at the level of chunks makes a
difference here.  The first DATA chunk contained 1452 bytes of data,
which results in an MTU-sized frame.  How is this any different than TCP
sending 1460 bytes data in one segment followed immediately by sending
another 2 bytes in a second segment?  ie: user tries to send 1462 bytes,
which TCP has to segment.  It first sends an MTU-sized packet followed
immediately by another packet containing whatever is left over the data,
all without Nagle getting in the way.

--Doug
