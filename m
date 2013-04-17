From: "David Laight" <David.Laight@ACULAB.COM>
Date: Wed, 17 Apr 2013 16:28:47 +0000
Subject: RE: [PATCH net-next 9/9] net: sctp: sctp_ulpq: do not use char as a struct member
Message-Id: <AE90C24D6B3A694183C094C60CF0A2F6026B71E5@saturn3.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366146438-8815-1-git-send-email-dborkman@redhat.com> <1366146438-8815-10-git-send-email-dborkman@redhat.com> <20130417154552.GJ5149@hmsreliant.think-freely.org>
In-Reply-To: <20130417154552.GJ5149@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>, Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

> >  /* A structure to carry information to the ULP (e.g. Sockets API) */
> >  struct sctp_ulpq {
> > -	char pd_mode;
> >  	struct sctp_association *asoc;
> >  	struct sk_buff_head reasm;
> >  	struct sk_buff_head lobby;
> > +	__u8 pd_mode:1;
> >  };
> >
> 
> Can you move the char (or __u8 if you prefer) to right after the reasm meber?  I
> think theres a hole there that you can fill in

If there is a hole after 'reasm' there will also be one after 'lobby'.
In any case it can't be worse than the 7 byte pad after pd_mode
in the existing file.

In the other structure there is a uint32 preceding the three
flag bytes - so unless some other stuff is moved making them
bitfields won't change any sizes at all.

FWIW we do use SCTP (for M3UA).
The code has to be an order of magnitude slower than TCP!
Never mind the difficulty in generating long ethernet frames
(since the data flow means you have to disable nagle).

	David.


