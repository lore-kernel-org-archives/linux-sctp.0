From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 23 Jan 2009 05:19:56 +0000
Subject: Re: [PATCH 1/4] sctp: Fix crc32c calculations on big-endian arhes.
Message-Id: <20090123051956.GA25803@gondor.apana.org.au>
List-Id: <linux-sctp.vger.kernel.org>
References: <1232663768-4028-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1232663768-4028-2-git-send-email-vladislav.yasevich@hp.com>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net

Vlad Yasevich <vladislav.yasevich@hp.com> wrote:
>
> diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
> index b799fb2..2fec3c3 100644
> --- a/include/net/sctp/checksum.h
> +++ b/include/net/sctp/checksum.h
> @@ -79,5 +79,5 @@ static inline __be32 sctp_update_cksum(__u8 *buffer, __u16 length, __be32 crc32)
> 
> static inline __be32 sctp_end_cksum(__be32 crc32)
> {
> -       return ~crc32;
> +       return (__force __be32)~cpu_to_le32((__force u32)crc32);
> }

Ouch, surely there is a better way to do this?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
