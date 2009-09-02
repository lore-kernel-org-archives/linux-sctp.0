From: "Doug Graham" <dgraham@nortel.com>
Date: Wed, 02 Sep 2009 00:25:16 +0000
Subject: Re: [PATCH 0/2] Re: Do piggybacked ACKs work
Message-Id: <4A9DBB6C.8030602@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad,

I'm probably just being stupid, but I can't figure out which version of 
output.c your patch
is supposed to be applied against.  Is it supposed to be applied on top 
of any of the other
patches that Wei or I provided, or does it replace them all?

The main reason I ask is that as far as I can tell, your patch doesn't 
change the original
mysterious condition for bundling a SACK, which was "if (asoc->a_rwnd > 
asoc->rwnd)".

--Doug

Vlad Yasevich wrote:
> Try to wrap up the discussion and all the patches that
> happened in this tread, I'd like to send out what I've come
> up with.  It's really a merge of all the points
> we've discussed (minus the Nagel/small fragment discussion).
>
> What we try to do in the first patch is bundle the SACK
> if we are going to send the DATA, regardless of if the SACK
> will fit in the same packet or not.
>
> The second patch in the series, will size the DATA chunks
> to account for possbile SACKs.  This will encourage bundling.
>
> The last piece of the puzzle is what to do with the small message
> fragements.  Wei's approach doesn't work in the face of small
> messages that the user decides to fragment as well (think, 400
> byte message with a frag_size of 50).  I think we need to
> take message size into account in this situation.
>
> Anyway, please feel free to comment on this approach.
>
> -vlad
>
>   
