From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 07 Mar 2013 15:29:27 +0000
Subject: Re: NULL primary_path
Message-Id: <20130307152927.GB2464@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
In-Reply-To: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Mar 07, 2013 at 03:52:35PM +0100, Cristian Constantin wrote:
> On Wed, Mar 06, 2013 at 08:53:02PM -0500, Vlad Yasevich wrote:
> > On 03/06/2013 05:57 PM, Karl Heiss wrote:
> > >I am getting kernel panics due to a NULL dereference in
> > >sctp_getsockopt_sctp_status() when calling getsockopt() with
> > >SCTP_STATUS immediately after establishing a connection.  This occurs
> > >when transport = asoc->peer.primary_path; is NULL and transport is
> > >later dereferenced.  Is there any way that an association would be
> > >present but have no primary_path?
> > 
> > No, that shouldn't happen.  The very first transport that is added
> > to the association is assigned to the primary_path.  Primary_path can
> > never be null since the association must have at least 1 transport and
> > that 1 transport will always be primary.
> 
> cristian: hi!
> 
> but, vlad, at least in 2.6.30.2 (which I have on my hdd with
> the "tags" already computed), sctp_getsockopt_primary_addr() is a little
> bit more conservative and does:
>     
>     ...
>     asoc = sctp_id2assoc(sk, prim.ssp_assoc_id);
>     if (!asoc)
>         return -EINVAL;
> 
>     if (!asoc->peer.primary_path)
>         return -ENOTCONN;
>     ...
> 
> any idea if is there any big difference btw. the two getsockopt()s? behind
> them, everything is assumed to be asynch., right? (in the sense that 
> the assoc. can come and go at any time)
> 
All paths that touch primary_path hold the associated socket lock for the socket
that owns the transport path, so there shouldn't be any changing of the primary
path while accessing it here, at least not in the upstream kernel.

Regards
Neil

> thanks!
> bye now!
> cristian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
