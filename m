From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 02 Aug 2013 13:00:58 +0000
Subject: Re: Association issue.
Message-Id: <20130802130058.GB18116@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAwSLG+fNrUKrfd1dBshHvsSUOpsEASBtwXb2iZF+uQ+uM8kxw@mail.gmail.com>
In-Reply-To: <CAAwSLG+fNrUKrfd1dBshHvsSUOpsEASBtwXb2iZF+uQ+uM8kxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Aug 02, 2013 at 02:24:07PM +0530, Vipul Singhania wrote:
> On Thu, Aug 1, 2013 at 5:18 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Thu, Aug 01, 2013 at 03:52:50PM +0530, Vipul Singhania wrote:
> >> On Wed, Jul 31, 2013 at 6:41 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >> > On Wed, Jul 31, 2013 at 10:33:50AM +0530, Vipul Singhania wrote:
> >> >> Thanks for reply.
> >> >>
> >> >> There is no firewall in that network. This is just separate network.
> >> >> and I can say they are directly connected to each other using L1
> >> >> switch and no other connection to outside world.
> >> >>
> >> >> It was jut testing that I have giving public IP to one of interface in one host.
> >> >>
> >> >> - The association look like with public IP.
> >> >>
> >> >> sh-3.2# cat /proc/net/sctp/assocs
> >> >>  ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
> >> >> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
> >> >> ffff8800089b0000 ffff8800335944c0 2   1   3  37916    3      516
> >> >>  0       0 10635 48520  7168  127.3.253.1 127.3.21.1 127.4.253.1
> >> >> 127.2.253.1 127.1.221.1 164.48.1.1 127.3.254.1 <-> *127.4.252.1
> >> >>  7500   300   300   10    0    0        0
> >> >> ffff8800089b2000 ffff880033594000 2   1   3  50717    4      516
> >> >>  0       0 10634 60890  7169  127.3.253.1 127.3.21.1 127.4.253.1
> >> >> 127.2.253.1 127.1.221.1 164.48.1.1 127.3.254.1 <-> *127.4.252.1
> >> >>  7500   300   300   10    0    0        0
> >> >>
> >> >> -----------------------------------------------------------------------------
> >> >> - But if I give private IP (10.1.1.1) this look like.
> >> >>
> >> >> sh-3.2# cat /proc/net/sctp/assocs
> >> >>  ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
> >> >> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
> >> >> ffff88003c721800 ffff8800335944c0 2   1   3  22045    2        0
> >> >>  0       0  5674 47434  7169  127.3.253.1 127.3.21.1 127.4.253.1
> >> >> 127.2.253.1 127.1.221.1 <-> *127.4.252.1         7500   300   300   10
> >> >>    0    0        0
> >> >> ffff88003c720800 ffff880033594000 2   1   3  36124    1        0
> >> >>  0       0  5673 58513  7168  127.3.253.1 127.3.21.1 127.4.253.1
> >> >> 127.2.253.1 127.1.221.1 <-> *127.4.252.1         7500   300   300   10
> >> >>    0    0        0
> >> >>
> >> > I don't see any difference between the two environments here.  How exactly are
> >> > you 'giving' a private ip here?  Are you attempting an ADDIP operation?
> >> >
> >>
> >> [Vipul] -- The difference which I can is the public IP 164.48.1.1 is
> >> there in association list. (Why & how this case in this list this I am
> >> not able to understand). however If I assign the IP 10.1.1.1/24 to my
> >> eth0 it doesn't come in this association.
> >> The IP address assignment is using ifconfig.
> >>
> > Ok, so all your doing is specifying it on the interface, you're not explicitly
> > binding to it in whatever program you have.
> >
> 
> [vipul] - Yes, At client side I am not doing explicitly bind.
> 
> >> >>
> >> >> - I may be wrong but is it possible that when we do bind with on IP
> >> >> (and if multi homing is enabled) it'll build with all available
> >> >> interfaces?
> >> >>
> >> > The opposite in fact.  If you bind to a local address the association on that
> >> > socket will be creating using only the bound address, if you do not bind on a
> >> > local address (the autobind case), and multihoming is enabled, then all
> >> > available addresses will be used.
> >> >
> >> [Vipul] -- If this is the case one host is working as server and I am
> >> doing bind on that for IP 127.4.252.1 and the other host is always
> >> acting as client and in this I just do connect().
> >> So Client will bind with all IP addresses, in this case I am not clear
> >> why & how private IP is not coming for the accociation and why public
> >> IP is coming in this association?
> > Can you post the code that you are using to set up this connection?
> >
> ******
> #define SERVER_IP "127.4.252.1"
> #define CLIENT_IP "127.4.253.1"
> 
> socklen_t optlen = sizeof (optval);
> struct sctp_event_subscribe   events ;
> ..
> ..
>  start_socket:
> 
>  tSoc = -1 ;
>  lSoc = -1 ; /* intialize the socket description */
>     if (  (lSoc = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP)) < 0 ) {
>          //error handling.
>          return ;
>     }
> ...
> ...
> 
>  /* Specify the peer end point for connection */
>      servaddr.sin_family = AF_INET;
>      servaddr.sin_port = htons(7169);
>      inet_aton(SERVER_IP, &servaddr.sin_addr);
> 
>      optval = 0;
>      if (setsockopt(lSoc, SOL_SOCKET, SO_KEEPALIVE, &optval, optlen) < 0) {
>          //error handling.
>      }
> 
>      /* set to re-use to avoid "Address in use" on retry */
>      optval = 1;
>      if(setsockopt(lSoc, SOL_SOCKET, SO_REUSEADDR, &optval, optlen) < 0) {
>          //error handling.
>      }
> 
> 
> ....
> ....
> 
>     /* bind the server address in keep listening */
>      if (0 != bind(lSoc, (struct sockaddr *)&servaddr, sizeof(sockaddr))) {
>     // error handling.
>              close(lSoc);
>              sleep(2);
>              goto start_socket;
>      }
> 
>     if (listen(lSoc,5) = -1) {
>         close(lSoc);
>         sleep(2);
>         goto start_socket ; /* close the current connection and wait for new */
>     }
> ...
> ...
> 
>      /* SCTP Events noticiation to listen */
>      bzero(&events,sizeof(events));
>      events.sctp_data_io_event = 1;
>      events.sctp_association_event = 1;
>      events.sctp_address_event = 1;
>      events.sctp_send_failure_event = 1;
>      events.sctp_peer_error_event = 1;
>      events.sctp_shutdown_event = 1;
>      if(setsockopt(lSoc,IPPROTO_SCTP,SCTP_EVENTS,&events,sizeof(events)) < 0) {
>          // Error handling.
>      }
> ...
> ...
> 
>     while (1) {
>     start:
>     if (server) { //server case
>         if((tSoc = accept (lSoc, NULL, 0))  = -1 ) {
>         //Error handle
>         sleep(2) ;
>                 goto start ;
>             }
>     } else {  // client case
>         if ((connect(lSoc, (struct sockaddr *)&servaddr,
> sizeof(sockaddr))) != 0) {
>             //Error Handling
>                }
>         }
> 
>    }
> 
> ...
> ...
> after that when I do
> 
>    if((len = recvmsg(tSoc, msg, MSG_NOSIGNAL)) > 0) {
>     // Some operation.
>    } /* if (len > 0) */
> 
>    if (len  < 0) {
>     if (getsockopt(tSoc, IPPROTO_SCTP,SCTP_STATUS, &status, &socklen) = -1) {
>         HERE I GET CONNECTION RESET BY PEER
>     }
>    }
> ************************************
> 
> I have following default setting related to sctp.
> 
> h-3.2# sysctl -a |grep sctp
> net.sctp.rto_initial = 3000
> net.sctp.rto_min = 1000
> net.sctp.rto_max = 60000
> net.sctp.valid_cookie_life = 600000
> net.sctp.max_burst = 4
> net.sctp.association_max_retrans = 10
> net.sctp.sndbuf_policy = 0
> net.sctp.rcvbuf_policy = 0
> net.sctp.path_max_retrans = 5
> net.sctp.max_init_retransmits = 8
> net.sctp.hb_interval = 30000
> net.sctp.cookie_preserve_enable = 1
> net.sctp.rto_alpha_exp_divisor = 3
> net.sctp.rto_beta_exp_divisor = 2
> net.sctp.addip_enable = 0
> net.sctp.prsctp_enable = 1
> net.sctp.sack_timeout = 200
> net.sctp.sctp_mem = 36171    48230    72342
> net.sctp.sctp_rmem = 4096    397500    1543360
> net.sctp.sctp_wmem = 4096    16384    1543360
> net.sctp.auth_enable = 0
> net.sctp.addip_noauth_enable = 0
> net.sctp.addr_scope_policy = 1
> net.sctp.rwnd_update_shift = 4
> net.sctp.max_autoclose = 8589934
> sh-3.2#
> 
> ********
> Attaching two pcap files.
> 
> 1. Client_localIP.pcap ---> In this file local IP (10.1.1.1) is not in
> association.
> 2, Client_publicIP.pcap. ---> in this 164.48.1.1 is part of association.
> 
> 
> 
> >> I have also tries with "echo "2" >
> >> /proc/sys/net/sctp/addr_scope_policy" which even doesn't allow the
> >> association with private IP. for both (private & public IP) the server
> >> receiver end receives the connection reset by peer.
> >>
> > Can you provide a tcpdump of this as well?
> > Neil
> >
> >
> >> > Neil
> >> >
> >>
> >>
> >> --
> >> -=vipsy
> >> http://through-dlens.blogspot.in
> >>
> 
So, I'm somewhat confused here.  I've looked at both the tcpdumps you provided
and both traces show that ABORT chunks are generated, the exact same ABORT
chunks.

So I'm left wondering why you think one environment works and the other
doesn't (unless neither environment works and I just misunderstood you
previously).

FWIW, the ABORT chunks have no causal data, which suggests they are either the
result of the reception of an out of the blue packet, a t5 timer expiration or
an init verification failure (I would guess the latter).  What does
/proc/net/sctp/snmp show after you get the aborts?

Neil

> 
> 
> -- 
> -=vipsy
> http://through-dlens.blogspot.in


