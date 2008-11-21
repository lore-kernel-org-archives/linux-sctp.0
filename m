From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 21 Nov 2008 15:50:12 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <20081121154951.GA31453@dhcp35.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri 21-11-08 10:42:23, Vlad Yasevich wrote:
> Michal Hocko wrote:
> > On Fri 21-11-08 09:28:37, Vlad Yasevich wrote:
> >> Michal
> >>
> >> This really smells like the corruption of the sctp_packet structure.
> >> The number chunks printout out is 0, but the list appears to have multiple
> >> entries on it.
> > 
> > I am just wondering that it takes such a long time to trigger on my
> > system. What can be different (code path?) that corrupts this structure?
> > Any idea how to trigger it faster? I have tried to increase the number
> > of servers and clients, but that doesn't seem like it made that crash
> > faster... 
> > 
> 
> Michal
> 
> Could you make your reproducer available?  I'd like to see if it uses any
> protocol extensions.

Will go in private email without mailing list. (You can make it public
if you want though)

> 
> Also, can you provide the output of "sysctl -a | grep sctp".  Also to check
> if any extensions are enabled.  Just trying to narrow down the what to look for.

net.sctp.rto_initial = 3000
net.sctp.rto_min = 1000
net.sctp.rto_max = 60000
net.sctp.valid_cookie_life = 60000
net.sctp.max_burst = 4
net.sctp.association_max_retrans = 10
net.sctp.sndbuf_policy = 0
net.sctp.rcvbuf_policy = 0
net.sctp.path_max_retrans = 5
net.sctp.max_init_retransmits = 8
net.sctp.hb_interval = 30000
net.sctp.cookie_preserve_enable = 1
net.sctp.rto_alpha_exp_divisor = 3
net.sctp.rto_beta_exp_divisor = 2
net.sctp.addip_enable = 0
net.sctp.prsctp_enable = 1
net.sctp.sack_timeout = 200
net.sctp.sctp_mem = 77568       103424  155136
net.sctp.sctp_rmem = 4096       253500  3309568
net.sctp.sctp_wmem = 4096       16384   3309568
net.sctp.auth_enable = 0
net.sctp.addip_noauth_enable = 0

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
