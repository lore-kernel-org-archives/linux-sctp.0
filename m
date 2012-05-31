From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 31 May 2012 17:23:27 +0000
Subject: Re: crc32c_intel vs libcrc32c
Message-Id: <4FC7A90F.2000904@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <OF37C8B3DB.4464FF3A-ON85257A0F.005A2106-85257A0F.005A77CC@pt.com>
In-Reply-To: <OF37C8B3DB.4464FF3A-ON85257A0F.005A2106-85257A0F.005A77CC@pt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 05/31/2012 12:28 PM, Peter Butler wrote:
> I have a system with SSE4.2 and thus hardware support for CRC32C
> calculations.  I can manually load the crc32c_intel module, however when I
> do an lsmod I see:
>
> [root@peterFC16 ~]# lsmod | grep -E 'crc|sctp'
> crc32c_intel           12770  0
> libcrc32c              12603  1 sctp
> sctp                  203671  2
>
> Does this mean that SCTP is not actually using the crc32c_intel module? If
> so, how do I remedy that?
>
>

What happens if you don't manually load crc32c_intel?  Does it still 
show up in lsmod output?

I think you are already using it.  libcrc32c doesn't do anything itself 
any more.  It's a wrapper that's calling the crypto api to compute the 
checksum.  Here it depends which crypto module it loads.  It could load 
crc32c_intel or it could load crc32c_generic.  If you see intel loaded, 
that's what you are using.  If you see _generic loaded, then that's 
what's available.

-vlad

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

