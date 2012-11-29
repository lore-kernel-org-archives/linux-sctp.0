From: Dilip Daya <dilip.daya@hp.com>
Date: Thu, 29 Nov 2012 21:33:51 +0000
Subject: Re: SCTP sysctl /proc/sys/net/sctp/rto_min/initial/max variables
Message-Id: <1354224831.6915.142.camel@pro6455b.example.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1354221337.6915.107.camel@pro6455b.example.com>
In-Reply-To: <1354221337.6915.107.camel@pro6455b.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad,

On Thu, 2012-11-29 at 15:49 -0500, Vlad Yasevich wrote:
> On 11/29/2012 03:35 PM, Dilip Daya wrote:
> > Hi,
> >
> > Testing kernel 3.2.32 x86_64 environment show the sctp sysctl variables:
> >
> >   - net.sctp.rto_initial,
> >   - net.sctp.rto_min,
> >   - net.sctp.rto_max
> >
> > are not overriding the hard-coded recommended values of:
> > - http://lxr.linux.no/linux+v3.2.34/include/net/sctp/constants.h#L276
> >
> > I've confirmed the following values are correct to what I need modified:
> >   - /proc/sys/net/sctp/rto_initial
> >   - /proc/sys/net/sctp/rto_min
> >   - /proc/sys/net/sctp/rto_max
> >
> > If I change the hard-coded values and rebuild sctp they take effect. Is
> > this an issue on my end or is this a sctp sysctl issue?
> >
> > Thanks,
> > -DilipD.
> >
> 
> Dilip
> 
> I am not sure what you mean...   Are you saying that issuing
> 	sysctl -w net.sctp.rto_initial0
> doesn't change the value of rto_initial shown in /proc/sys/net/sctp?

No, it does change the value in /proc/sys/net/sctp but not picked up by
sctp associations. Only default recommended values are picked up, i.e.

# sysctl -a 2>/dev/null | grep ".rto_"
net.ipv4.tcp_frto_response = 0
net.sctp.rto_initial = 25
net.sctp.rto_min = 20
net.sctp.rto_max = 30
net.sctp.rto_alpha_exp_divisor = 3
net.sctp.rto_beta_exp_divisor = 2

# cat /proc/sys/net/sctp/rto_max
30

# cat /proc/sys/net/sctp/rto_min 
20

# cat /proc/sys/net/sctp/rto_initial 
25

Selective sctp debug:
[  206.783286] sctp_init_sock: net_params->rto_min: 1000,
net_params->rto_initial: 3000, net_params->rto_max: 60000
[  206.783291] sctp_init_sock: sp->rtoinfo.srto_min: 1000,
sp->rtoinfo.srto_initial: 3000, sp->rtoinfo.srto_max: 60000
[  206.783403] sctp_association_init: sp->rtoinfo.srto_min: 1000,
sp->rtoinfo.srto_initial: 3000, sp->rtoinfo.srto_max: 60000
[  206.783407] sctp_association_init: asoc->rto_min: 250,
asoc->rto_initial: 750, asoc->rto_max: 15000
[  206.783426] sctp_transport_init: net_params->rto_initial: 3000,
peer->rto: 750
[  206.783993] sctp_transport_init: net_params->rto_initial: 3000,
peer->rto: 750
[  206.784008] sctp_transport_init: net_params->rto_initial: 3000,
peer->rto: 750
[  206.784019] sctp_transport_init: net_params->rto_initial: 3000,
peer->rto: 750
[  206.784028] sctp_transport_init: net_params->rto_initial: 3000,
peer->rto: 750
[  206.784038] sctp_transport_init: net_params->rto_initial: 3000,
peer->rto: 750
[  206.784047] sctp_transport_init: net_params->rto_initial: 3000,
peer->rto: 750
[  206.784731] sctp_transport_update_rto: transport: ffff88011e1b0400,
rtt: 0, srtt: 0 rttvar: 1, rto: 250, rto-msecs: 1000, rto_min: 250,
rto_max: 15000
...

# cat /proc/net/sctp/remaddr 
ADDR ASSOC_ID HB_ACT RTO MAX_PATH_RTX REM_ADDR_RTX  START
192.168.2.62  1 1 250 5 0 0

# cat /proc/net/sctp/assocs_info | grep "R:"
R:192.168.2.62  1 1500 0 5 11832 0 21040 250 0 1 0

i.e.

Default hard-coded recommended values are:
rto_min     = 1000  msec = 1000/4  =   250 jiffies
rto_initial = 3000  msec = 3000/4  =   750 jiffies
rto_max     = 60000 msec = 60000/4 = 15000 jiffies


=> Seems sctp sysctl rto_ variables do not effect.

-DilipD.

> 
> -vlad
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 

