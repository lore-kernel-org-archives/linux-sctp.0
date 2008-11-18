From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 18 Nov 2008 16:12:38 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <20081118161238.GA6055@tiehla.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue 18-11-08 10:46:44, Vlad Yasevich wrote:
> Michal Hocko wrote:
> > On Tue 18-11-08 09:04:58, Vlad Yasevich wrote:
> >> Michal Hocko wrote:
> >>> On Thu 06-11-08 08:48:45, Vlad Yasevich wrote:
> >>>> Michal Hocko wrote:
> >>>>> Hi,
> > [...]
> >>> Do you have any ETA?
> >>> Is there some way how to help here?
> >>>
> >> which version in particular is most critical?
> >>
> >> Just remember then 2.6.16 is very old and there have been a lot of fixes that
> >> address critical issues.
> >>
> >> For 2.6.28, can you apply the attached patch and post dmesg output.  Also, if
> >> it's possible to capture a kdump, that would make things much easier.
> > 
> > Does it make sense to enable CONFIG_SCTP_DBG_MSG and CONFIG_SCTP_DBG_OBJCNT?
> > We don't set them in our enterprise kernels and I as this seems to be
> > race condition I would like to prevent some timing issues. But if it is
> > worth trying I can try to turn them on.
> > 
> 
> DBG_MSG will slow everything down too much and will alter any races significantly.

OK

> 
> I don't think this is as much a race as potentially corruption.  From the
> skb_over_panic() you reported, the allocated skb looks very strange.

We had also panics from other places, but I do agree that this may well
be due to corruption as well. Race condition came to mind because we had
different traces and times to reproduce in different environments (e.g.
I wasn't able to reproduce with switched connection between boxes but
other guy was able!).

> 
> The skb size is 1280 bytes and the reserved header area is on 116 bytes.
> That doesn't appear to correspond to what should be in the packet.
> So, either sctp_packet or skb somehow got corrupted.  The debug code I
> added will show the values from the sctp_packet if such corruption occurs.
> We'll still BUG out since I want to see the values from the skb as well.
> Getting a kdump will allow to examine other areas as well, but I wanted
> to start small.

Yeah. Machine is in the test loop with kdupm crash kernel enabled.

> 
> -vlad
> 

Thanks for your help!
-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
