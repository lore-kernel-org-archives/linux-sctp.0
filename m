From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 24 Nov 2008 15:25:48 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <20081124152548.GB5131@dhcp35.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon 24-11-08 10:00:28, Vlad Yasevich wrote:
> Michal Hocko wrote:
> > On Fri 21-11-08 09:28:37, Vlad Yasevich wrote:
> >> Michal
> > 
> > Hi Vlad,
> > 
> >> This really smells like the corruption of the sctp_packet structure.
> >> The number chunks printout out is 0, but the list appears to have multiple
> >> entries on it.
> >>
> >> Can you turn on CONFIG_DEBUG_LIST and may be even turn on memory
> >> debugging as well.
> > 
> > I have turned on some debug config options as you have suggested and
> > here is the trace (unfortunately there was no other output on my serial
> > console):
> > 
[...]
> > 
> > 
> > If you are interested in vmcore, system map and config file, you can find 
> > them at:
> > ftp.novell.com/outgoing/System.map-2.6.28-rc5-sctp.debug.gz
> > ftp.novell.com/outgoing/vmcore.2.6.28-rc5-sctp.debug.gz
> > ftp.novell.com/outgoing/config-2.6.28-rc5-sctp.debug
> > 
> > Best regrads
> 
> 
> Michal
> 
> In you test runs, what's the data size of the messages you use?

Both server and client take command-line parameter (2nd) and we have
tested with the value 1024. You can change it (from 0 up to the lenght
of s_SndData SCTPCrash.cpp:522)

> 
> Thanks
> -vlad

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
