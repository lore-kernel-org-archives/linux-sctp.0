From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 17 Jul 2008 17:46:12 +0000
Subject: Re: [PATCH] add /proc/net/sctp/remaddr table to complete RFC remote address table OID
Message-Id: <20080717174612.GE17892@hmsendeavour.rdu.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080430144606.GB572@hmsendeavour.rdu.redhat.com>
In-Reply-To: <20080430144606.GB572@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jul 17, 2008 at 10:24:19AM -0400, Vlad Yasevich wrote:
> Neil Horman wrote:
> > On Wed, Apr 30, 2008 at 10:46:06AM -0400, Neil Horman wrote:
> >> Hey all-
> >>
> >> Add support for RFC3873 remote address table OID.  Currently the OID's required
> >> by RFC 3873 cannot be implemented as part of the association table, where they
> >> would otherwise naturally belong.  This patch places all the requsite data in a
> >> separate proc file, /proc/net/sctp/remaddr
> >>     
> >> Regards
> >> Neil 
> >>
> >> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> >>
> >>
> > Vlad, Sorry to bother you, but whatever happened to this patch?  I posted the
> > correction you asked for, but I don't see this in your tree anywhere.  Is there
> > something else you're waiting on?
> > 
> > Thanks!
> > Neil
> > 
> 
> Nope.  It went into net-next.
> 
> http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commit;h c2c1fd6c842caf70dcb1d94b9d58861949fd3d
> 
> -vlad
> 
Cool, thanks!
Neil

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
