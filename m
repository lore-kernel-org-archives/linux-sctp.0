From: Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com>
Date: Thu, 04 Feb 2016 05:30:59 +0000
Subject: RE: Query on SCTP:INIT re-transmission interval behavior
Message-Id: <SG2PR0401MB1519E2DDCD5687ABAF5232EDFED10@SG2PR0401MB1519.apcprd04.prod.outlook.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <SG2PR0401MB15190940DB1D58DC1EBFB140FED90@SG2PR0401MB1519.apcprd04.prod.outlook.com>
In-Reply-To: <SG2PR0401MB15190940DB1D58DC1EBFB140FED90@SG2PR0401MB1519.apcprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Marcelo,

Only during sctp_connectx () the code is different for LKSCTP version 1.0.16 and 1.0.7  as follows and rest of the code is common and same for both the version.



static S32 l3_sctp_connectx(
        S32       connSock,
        mme_comm_info_t *p_mme_comm_info)
{
    U32 counter = RRC_NULL;
    U8 no_of_ip_addr = RRC_NULL;
    struct sockaddr_in6 servaddr6[MAX_IP_ADDR];
    struct sockaddr_in servaddr[MAX_IP_ADDR];
    if(p_mme_comm_info->bitmask & MME_COMM_INFO_IPV6_NUM_ADDR_PRESENT)
    {
        no_of_ip_addr = p_mme_comm_info->num_ipv6_addr;
    }
    else
    {
        no_of_ip_addr = p_mme_comm_info->num_ip_addr;
    }


#ifdef LKSCTP_1_0_16
    sctp_assoc_t sctp_assoc;
    memset_wrapper(&sctp_assoc, 0, sizeof(sctp_assoc_t));
#endif

    /* Specify the peer endpoint(s) to which we'll connect */

    for(counter = 0; counter < no_of_ip_addr; counter++)
    {
        if(p_mme_comm_info->bitmask & MME_COMM_INFO_IPV6_ADDR_PRESENT)
        {
            bzero_wrapper( (void *)&servaddr6[counter], sizeof(servaddr6[0]) );
            servaddr6[counter].sin6_family     = 10;
            servaddr6[counter].sin6_port        = htons_wrapper(p_mme_comm_info->port);
            RRC_TRACE(RRC_INFO,"MME Server IP ADDRESS = %s and Port = %u",
                    (const S8*)(p_mme_comm_info->ipv6_addr[counter].ipv6_addr),
                    p_mme_comm_info->port);
            if (inet_pton_wrapper(10,(const char *)p_mme_comm_info->ipv6_addr[counter].ipv6_addr,
                        (void*)&servaddr6[counter].sin6_addr) != 1)
            {
                RRC_TRACE(RRC_WARNING,"l3_sctp_connectx: Couldnot convert the "
                        "INET6 address");
                return -1;
            }
        }
 else
        {
            bzero_wrapper( (void *)&servaddr[counter], sizeof(servaddr[0]) );
            servaddr[counter].sin_family      = (SA_FAMILY_T)AF_INET;
            servaddr[counter].sin_port        = htons_wrapper(p_mme_comm_info->port);
            servaddr[counter].sin_addr.s_addr                 inet_addr_wrapper((const char*)(p_mme_comm_info->ip_addr[counter].ip_addr));
            RRC_TRACE(RRC_INFO,"MME Server IP ADDRESS = %s and Port = %u",
                    (const S8*)(p_mme_comm_info->ip_addr[counter].ip_addr),
                    p_mme_comm_info->port);
        }
    }

    /* Connect to the server */
    if(p_mme_comm_info->bitmask & MME_COMM_INFO_IPV6_ADDR_PRESENT)
    {

#ifdef LKSCTP_1_0_16

        RRC_TRACE(RRC_INFO,"USING LKSCTP Version 1.0.16\n");

        return  sctp_connectx(
                connSock,
                (struct sockaddr *)&servaddr6,
                no_of_ip_addr, &sctp_assoc);
#else
        RRC_TRACE(RRC_INFO,"USING LKSCTP Version 1.0.7\n");
        return  sctp_connectx(
                connSock,
                (struct sockaddr *)&servaddr6,
                no_of_ip_addr );
#endif
    }
    else
    {
#ifdef LKSCTP_1_0_16
    RRC_TRACE(RRC_INFO,"USING LKSCTP Version 1.0.16\n");
    return  sctp_connectx(
                         connSock,
                         (struct sockaddr *)&servaddr,
                         no_of_ip_addr, &sctp_assoc);
#else
    RRC_TRACE(RRC_INFO,"USING LKSCTP Version 1.0.7\n");
        /* Connect to the server */
        return  sctp_connectx(
                connSock,
                (struct sockaddr *)&servaddr,
                no_of_ip_addr );
#endif

    }
}


Regards,

Ravi


-----Original Message-----
From: Marcelo Ricardo Leitner [mailto:marcelo.leitner@gmail.com]
Sent: Friday, January 29, 2016 11:11 PM
To: Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com>
Cc: linux-sctp@vger.kernel.org
Subject: Re: Query on SCTP:INIT re-transmission interval behavior

On Fri, Jan 29, 2016 at 04:22:22PM +0000, Ravi Puttachannaiah wrote:
> Thanks Marcelo.. We have tried with LKSCTP version 1.0.7 (Kernel Linux 3.10.10 #1 SMP Fri Dec 12 15:38:16 EST 2014 armv7l GNU/Linux) and there we could see that SCTP:INIT retransmission is starting with "3" but with LKSCTP version 1.0.16 we see that it is starting with "6".  Any idea why this change in behavior with different LKSCTP version.

That's weird. In that case, can you share a minimal test app (src) that causes this difference in behavior?

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
> > https://www.dropbox.com/sh/75cu9n5jytchgkv/AACYXhPSJL_VhlPsj9h5hON-a
> > ?d
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
> > [mailto:linux-sctp-owner@vger.kernel.org] On Behalf Of Marcelo
> > Ricardo Leitner
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
> To unsubscribe from this list: send the line "unsubscribe linux-sctp"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
>
"DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
