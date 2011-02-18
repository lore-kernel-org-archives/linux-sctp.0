From: Jiri Bohac <jbohac@suse.cz>
Date: Fri, 18 Feb 2011 12:01:42 +0000
Subject: Re: [PATCH][RFC] sctp: fix reporting of unknown parameters
Message-Id: <20110218120142.GA24525@midget.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110217231208.GA28281@midget.suse.cz>
 <4D5E575A.9000905@cn.fujitsu.com>
In-Reply-To: <4D5E575A.9000905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: Jiri Bohac <jbohac@suse.cz>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

On Fri, Feb 18, 2011 at 07:26:18PM +0800, Shan Wei wrote:
> Jiri Bohac wrote, at 02/18/2011 07:12 AM:
> > commit 5fa782c2f5ef6c2e4f04d3e228412c9b4a4c8809 re-worked the 
> > handling of unknown parameters. sctp_init_cause_fixed() can now
> > return -ENOSPC if there is not enough tailroom in the error
> > chunk skb. When this happens, the error header is not appended to
> > the error chunk. In that case, the payload of the unknown parameter
> > should not be appended either.
> > 
> > Signed-off-by: Jiri Bohac <jbohac@suse.cz>
> 
> For this case, there is no more tailroom in skb

not always true:

both sctp_init_cause_fixed() and sctp_addto_chunk_fixed() get
passesd WORD_ROUND(ntohs(param.p->length) as the paylen/len
parameter.

sctp_init_cause_fixed() does:
	len = sizeof(sctp_errhdr_t) + paylen;
        if (skb_tailroom(chunk->skb) < len)
	                return -ENOSPC;

if paylen is only slightly smaller than the tailroom (by less
than sizeof(sctp_errhdr_t) bytes), -ENOSPEC will be returned and
the header will not be appended to the error chunk.

But later sctp_addto_chunk_fixed() does this check:
	if (skb_tailroom(chunk->skb) >= len)
which will pass and the unknown parameter value will be appended
to the error chunk without the error header.

> we send incomplete INIT-ACK chunk. With your patch, this chunk also 
> can't info the sender of INIT Chunk which parameter is not unrecognized.
> So maybe this handle is not perfect. 

The logic of not reporting unknown parameters for which we don't
have space in the pre-allocated buffer remains unchanged.

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

