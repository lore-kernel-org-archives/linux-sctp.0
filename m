From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 29 Jan 2016 17:41:18 +0000
Subject: Re: Query on SCTP:INIT re-transmission interval behavior
Message-Id: <20160129174117.GD6604@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <SG2PR0401MB15190940DB1D58DC1EBFB140FED90@SG2PR0401MB1519.apcprd04.prod.outlook.com>
In-Reply-To: <SG2PR0401MB15190940DB1D58DC1EBFB140FED90@SG2PR0401MB1519.apcprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jan 29, 2016 at 04:22:22PM +0000, Ravi Puttachannaiah wrote:
> Thanks Marcelo.. We have tried with LKSCTP version 1.0.7 (Kernel Linux 3.10.10 #1 SMP Fri Dec 12 15:38:16 EST 2014 armv7l GNU/Linux) and there we could see that SCTP:INIT retransmission is starting with "3" but with LKSCTP version 1.0.16 we see that it is starting with "6".  Any idea why this change in behavior with different LKSCTP version.

That's weird. In that case, can you share a minimal test app (src) that
causes this difference in behavior?

  Marcelo

> Regards,
> 
> Ravi
> 
> -----Original Message-----
> From: Marcelo Ricardo Leitner [mailto:marcelo.leitner@gmail.com]
> Sent: Friday, January 29, 2016 7:15 PM
> To: Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com>
> Cc: linux-sctp@vger.kernel.org
> Subject: Re: Query on SCTP:INIT re-transmission interval behavior
> 
> Hi,
> 
> On Fri, Jan 29, 2016 at 07:22:13AM +0000, Ravi Puttachannaiah wrote:
> > Hi Marcelo,
> >
> > Thanks for the response. Following is the kernel version we are using and there are only one transport.
> >
> > Linux 3.10.10-svn1674 #73 SMP Fri Jan 22 12:42:34 IST 2016 armv7l
> > GNU/Linuxs
> >
> > I have also uploaded the SCTP logs at the following URL. Basically we want to understand why the SCTP:INIT retransmission is starting from "6" (instead of "3") and is it an expected behavior. Could you please help.
> >
> > https://www.dropbox.com/sh/75cu9n5jytchgkv/AACYXhPSJL_VhlPsj9h5hON-a?d
> > l=0
> 
> That's weird, but I don't know whay may be causing it. I'm not aware of a related bug.
> 
> It works just fine here:
>   1   0.000000 192.168.122.1 -> 192.168.123.100 SCTP 84 INIT
>   2   3.007833 192.168.122.1 -> 192.168.123.100 SCTP 84 INIT
> 
> You may want to enable some debugs, like the pr_debug() statements in
> sctp_sf_t1_init_timer_expire() and sctp_cmd_t1_timer_update() and perhaps a new at sm_sideeffect.c, after line "case SCTP_CMD_TIMER_RESTART:"
> 
> It should give you a view of when the timer is started, when it's modified and when it expires.
> 
> HTH
>   Marcelo
> 
> >
> > Regards,
> >
> > Ravi
> >
> >
> > -----Original Message-----
> > From: linux-sctp-owner@vger.kernel.org
> > [mailto:linux-sctp-owner@vger.kernel.org] On Behalf Of Marcelo Ricardo
> > Leitner
> > Sent: Wednesday, January 27, 2016 9:32 PM
> > To: Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com>
> > Cc: linux-sctp@vger.kernel.org
> > Subject: Re: Query on SCTP:INIT re-transmission interval behavior
> >
> > Hi,
> >
> > On Wed, Jan 27, 2016 at 03:36:11PM +0000, Ravi Puttachannaiah wrote:
> > > Hi,
> > >
> > > We are using LKSCTP version 1.0.16 and have configured the SCTP configuration parameters as follows:
> >
> > Okay but in the end who will do the actual handling of the retransmission is the kernel. Which kernel are you using?
> >
> > > SctpInitMaxAttempts : 10
> > > SctpInitRTO : 3000
> > > SctpMinRTO : 1000
> > > SctpMaxRTO : 60000
> > >
> > > We observed that SCTP:INIT re-transmission is occurring at interval  6,12,24.., 6,12,24.., 6,12,24....... As per our understanding re-transmission should occur at interval  3,6,12,24..., 3,6,12,24...3,6,12,24... since SctpInitRTO000.
> > >
> > > Could you please let us know if it is an expected behavior or not. Also why re-transmission interval is not started with 3,6,12,24...
> >
> > That's my understanding too, 3, 6, 12..
> >
> > How many transports do you have?
> >
> >   Marcelo
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> > "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> >
> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
