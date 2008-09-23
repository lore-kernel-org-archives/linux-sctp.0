From: Willy Tarreau <w@1wt.eu>
Date: Tue, 23 Sep 2008 05:19:20 +0000
Subject: Re: SCTP checksum patch for 2.6.26.5
Message-Id: <20080923051920.GD24654@1wt.eu>
List-Id: <linux-sctp.vger.kernel.org>
References: <48D7C0A2.9090406@protei.ru> <20080922.131245.193705447.davem@davemloft.net>
In-Reply-To: <20080922.131245.193705447.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: nickolay@protei.ru, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Mon, Sep 22, 2008 at 01:12:45PM -0700, David Miller wrote:
> From: Nickolay Vinogradov <nickolay@protei.ru>
> Date: Mon, 22 Sep 2008 19:58:26 +0400
> 
> CC:'ing correct mailing lists...
> 
> > SCTP checksum calculation fix for BigEndian.
> > ntohl() doesn't do anything on BigEndian.
> > 
> > diff --git a/Makefile b/Makefile
> > diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
> > index ba75c67..2f0ed64 100644
> > --- a/include/net/sctp/checksum.h
> > +++ b/include/net/sctp/checksum.h
> > @@ -74,5 +74,19 @@ static inline __u32 sctp_update_cksum(__u8 *buffer, __u16 length, __u32 crc32)
> > 
> >   static inline __u32 sctp_end_cksum(__u32 crc32)
> >   {
> > -       return ntohl(~crc32);
> > +       __u32 result;
> > +       __u8 byte0, byte1, byte2, byte3;
> > +
> > +       result = ~crc32;
> > +
> > +       byte0 = result & 0xff;
> > +       byte1 = (result>>8) & 0xff;
> > +       byte2 = (result>>16) & 0xff;
> > +       byte3 = (result>>24) & 0xff;
> > +
> > +       crc32 = ((byte0 << 24) |
> > +                (byte1 << 16) |
> > +                (byte2 << 8)  |
> > +                byte3);
> > +       return crc32;
> >   }

Nickolay,

you should use swab32(~crc32) instead. It will make use of arch-specific
optimisations when available (eg: bswap on x86).

Willy

