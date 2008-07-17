From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 17 Jul 2008 13:52:23 +0000
Subject: Re: [PATCH] add /proc/net/sctp/remaddr table to complete RFC remote address table OID
Message-Id: <20080717135223.GD17892@hmsendeavour.rdu.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080430144606.GB572@hmsendeavour.rdu.redhat.com>
In-Reply-To: <20080430144606.GB572@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Apr 30, 2008 at 10:46:06AM -0400, Neil Horman wrote:
> Hey all-
> 
> Add support for RFC3873 remote address table OID.  Currently the OID's required
> by RFC 3873 cannot be implemented as part of the association table, where they
> would otherwise naturally belong.  This patch places all the requsite data in a
> separate proc file, /proc/net/sctp/remaddr
>     
> Regards
> Neil 
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
Vlad, Sorry to bother you, but whatever happened to this patch?  I posted the
correction you asked for, but I don't see this in your tree anywhere.  Is there
something else you're waiting on?

Thanks!
Neil



-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
