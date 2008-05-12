From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 12 May 2008 14:37:36 +0000
Subject: Re: [PATCH next-2.6 3/3] [SCTP]: add sctp/remaddr table to
Message-Id: <20080512143736.GA26305@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1210360481-16599-1-git-send-email-vladislav.yasevich@hp.com> <1210360566-16661-3-git-send-email-vladislav.yasevich@hp.com> <20080509.151518.202869638.davem@davemloft.net>
In-Reply-To: <20080509.151518.202869638.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: vladislav.yasevich@hp.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net

On Fri, May 09, 2008 at 03:15:18PM -0700, David Miller wrote:
> From: Vlad Yasevich <vladislav.yasevich@hp.com>
> Date: Fri,  9 May 2008 15:16:06 -0400
> 
> > Add support for RFC3873 remote address table OID.
> > 
> >       +--(5) sctpAssocRemAddrTable
> >       |   |
> >       |   |--(-) sctpAssocId (shared index)
> >       |   |
> >       |   +--(1) sctpAssocRemAddrType (index)
> >       .   |
> >       .   +--(2) sctpAssocRemAddr (index)
> >       .   |
> >           +--(3) sctpAssocRemAddrActive
> >           |
> >           +--(4) sctpAssocRemAddrHBActive
> >           |
> >           +--(5) sctpAssocRemAddrRTO
> >           |
> >           +--(6) sctpAssocRemAddrMaxPathRtx
> >           |
> >           +--(7) sctpAssocRemAddrRtx
> >           |
> >           +--(8) sctpAssocRemAddrStartTime
> > 
> > This patch places all the requsite data in /proc/net/sctp/remaddr.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> 
> Applied.

Dave, where is this applied?  I don't see it in either your net or net-next
trees?

Thanks & Regards
Neil

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
