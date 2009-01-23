From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 23 Jan 2009 14:52:44 +0000
Subject: Re: [PATCH 1/4] sctp: Fix crc32c calculations on big-endian arhes.
Message-Id: <4979D9BC.5000609@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1232663768-4028-2-git-send-email-vladislav.yasevich@hp.com> <20090123051956.GA25803@gondor.apana.org.au> <20090123052849.GA25937@gondor.apana.org.au> <20090123092449.GA27399@gondor.apana.org.au>
In-Reply-To: <20090123092449.GA27399@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net

Herbert Xu wrote:
> On Fri, Jan 23, 2009 at 04:28:49PM +1100, Herbert Xu wrote:
>>>> static inline __be32 sctp_end_cksum(__be32 crc32)
>>>> {
>>>> -       return ~crc32;
>>>> +       return (__force __be32)~cpu_to_le32((__force u32)crc32);
>>>> }
>>> Ouch, surely there is a better way to do this?
>> In fact this looks wrong.  Has this code actually been tested
>> on big-endian?

Yes, the code was tested by me and the person who reported it
as listed in the commit log. :)

> 
> Reading this again it does seem to do the right thing as it's
> using the raw crc32c interface as opposed to crypto crc32c.
> 
> However, I suggest that we change it as follows:
> 
> 1) Make sh->csum __le32 since we're using crc32c_le.
> 2) Change all intermediate values in sctp/checksum.h to u32.
> 3) Make sctp_end_cksum return __le32 and have it do
> 
> 	return cpu_to_le32(~crc);
> 

I'll give it some thought.  It would clean up all the __force
casts, but it will be a little misleading to define a packet
checksum as little endian. :)

-vlad

> Cheers,
