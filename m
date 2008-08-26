From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Aug 2008 01:19:48 +0000
Subject: Re: [Security] [PATCH] sctp: add verification checks to SCTP_AUTH_KEY
Message-Id: <alpine.LFD.1.10.0808251816110.3363@nehalem.linux-foundation.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080825164440.GA504@kernel.sg> <12196959323990-git-send-email-vladislav.yasevich@hp.com> <48B35561.2010001@redhat.com>
In-Reply-To: <48B35561.2010001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eugene Teo <eteo@redhat.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, security@kernel.org, davem@davemloft.net



On Tue, 26 Aug 2008, Eugene Teo wrote:
>
> > @@ -80,6 +80,10 @@ static struct sctp_auth_bytes *sctp_auth_create_key(__u32 key_len, gfp_t gfp)
> 
> This should be __u16 key_len.

Hmm? If it fits in a u16, then there is no worry about overflow.

> >  	struct sctp_auth_bytes *key;
> >  
> > +	/* Verify that we are not going to overflow INT_MAX */
> > +	if ((INT_MAX - key_len) < sizeof(struct sctp_auth_bytes))
> > +		return NULL;
> 
> Shouldn't this be UINT_MAX? But then if you are going to change
> sctp_auth_create_key() to accept __u16 key_len, then it should be
> USHORT_MAX.

If it's ushort, then it shouldn't need any test at all from an overflow 
standpoint. The addition simply can't overflow, since it's always done in 
"size_t" due to the sizeof.

But if it can overflow, I actually think it makes more sense to test for 
something smaller than the "exact" overflow. A key can't reasonably be all 
that long _anyway_, so it's probably better to test for something _much_ 
smaller.

		Linus
