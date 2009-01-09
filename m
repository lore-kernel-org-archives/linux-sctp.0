From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 09 Jan 2009 17:21:35 +0000
Subject: Re: bad reference counting for module (was Re: BUG in sctp crashes
Message-Id: <20090109172135.GB8504@dhcp35.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090108145515.GF29698@dhcp35.suse.cz>
In-Reply-To: <20090108145515.GF29698@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad,

On Thu 08-01-09 11:56:28, Vlad Yasevich wrote:
> Michal Hocko wrote:
[...]
> > However we are currently seeing another issue. It is not a crash (only
> > process is killed with BUG message in the log - see attached) but it is
> > the problem with module reference counting (
> > BUG_ON(module_refcount(module)=0) in __module_get is called). 
> > 
> > I am not sure whether this is a real problem, because we were able to
> > trigger this only on _one_ testing configuration while other one is OK.
> > 
> > I have checked all places where sctp decreases module reference count
> > (sock_put) and it seems that all places are correctly balanced with
> > sock_hold resp. __module_get:
> > - sctp_association_init vs. sctp_association_destroy
> > - sctp_association_migrate - put for old and hold for new
> > - sctp_endpoint_int vs. sctp_endpoint_destroy
> > - sctp_close - one artificial hold because of sk_common_release (which calls
> >                put)
> >              - one put balanced with sys_accept which calls __module_get
> > 
> > And all sock_put corresponds to the current upstream.
> > 
> > Do you have any idea or remember any problem in this area which could
> > trigger this? 
> > 
> > It smells either as some misconfiguration of the testing system or
> > another race condition or just I am overlooking something.
> > 
> > 
> 
> Try this commit: 027f6e1ad32de32f9fe1c61d0f744e329e8acfd9
> SCTP: Fix a potential race between timers and receive path.

Thanks for this tip, but the same result on the same testing machine. 

> 
> Also, what does lsmod tell you about the reference count on sctp module?

It shown something like 48 when I asked tester about that. Do you want
some finer grained values (with 1s interval). I understand that this
value can change rapidly so it is very imprecise.
I would like to give a try another test HW configuration on Monday
(whether we are able to reproduce at all).

> 
> -vlad

Thanks for your help

Best regards
-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
