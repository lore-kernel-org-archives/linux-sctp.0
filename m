From: Vipul Singhania <vipsinghania@gmail.com>
Date: Mon, 05 Aug 2013 06:53:08 +0000
Subject: Re: Association issue.
Message-Id: <CAAwSLGLZwn+OOjBqjQoKz1pW8mS3J-XuE6-q6Kv-RoTH3DPT3A@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="047d7b2e3e68eb125d04e32d974e"
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAwSLG+fNrUKrfd1dBshHvsSUOpsEASBtwXb2iZF+uQ+uM8kxw@mail.gmail.com>
In-Reply-To: <CAAwSLG+fNrUKrfd1dBshHvsSUOpsEASBtwXb2iZF+uQ+uM8kxw@mail.gmail.com>
To: linux-sctp@vger.kernel.org

--047d7b2e3e68eb125d04e32d974e
Content-Type: text/plain; charset=ISO-8859-1

I have attached one log file with assocs & snmp log out put in all
cases. (with pvt IP & with Public IP) for HOST A & HOST B.

On Sat, Aug 3, 2013 at 1:35 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Fri, Aug 02, 2013 at 10:50:44PM +0530, Vipul Singhania wrote:
>> On Fri, Aug 2, 2013 at 6:30 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> > On Fri, Aug 02, 2013 at 02:24:07PM +0530, Vipul Singhania wrote:
>> >> On Thu, Aug 1, 2013 at 5:18 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> >> > On Thu, Aug 01, 2013 at 03:52:50PM +0530, Vipul Singhania wrote:
>> >> >> On Wed, Jul 31, 2013 at 6:41 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> >> >> > On Wed, Jul 31, 2013 at 10:33:50AM +0530, Vipul Singhania wrote:
>> >> >> >> Thanks for reply.
>> >> >> >>
>> >> >> >> There is no firewall in that network. This is just separate network.
>> >> >> >> and I can say they are directly connected to each other using L1
>> >> >> >> switch and no other connection to outside world.
>> >> >> >>
>> >> >> >> It was jut testing that I have giving public IP to one of interface in one host.
>> >> >> >>
>> >> >> >> - The association look like with public IP.
>> >> >> >>
>> >> >> >> sh-3.2# cat /proc/net/sctp/assocs
>> >> >> >>  ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
>> >> >> >> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
>> >> >> >> ffff8800089b0000 ffff8800335944c0 2   1   3  37916    3      516
>> >> >> >>  0       0 10635 48520  7168  127.3.253.1 127.3.21.1 127.4.253.1
>> >> >> >> 127.2.253.1 127.1.221.1 164.48.1.1 127.3.254.1 <-> *127.4.252.1
>> >> >> >>  7500   300   300   10    0    0        0
>> >> >> >> ffff8800089b2000 ffff880033594000 2   1   3  50717    4      516
>> >> >> >>  0       0 10634 60890  7169  127.3.253.1 127.3.21.1 127.4.253.1
>> >> >> >> 127.2.253.1 127.1.221.1 164.48.1.1 127.3.254.1 <-> *127.4.252.1
>> >> >> >>  7500   300   300   10    0    0        0
>> >> >> >>
>> >> >> >> -----------------------------------------------------------------------------
>> >> >> >> - But if I give private IP (10.1.1.1) this look like.
>> >> >> >>
>> >> >> >> sh-3.2# cat /proc/net/sctp/assocs
>> >> >> >>  ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
>> >> >> >> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
>> >> >> >> ffff88003c721800 ffff8800335944c0 2   1   3  22045    2        0
>> >> >> >>  0       0  5674 47434  7169  127.3.253.1 127.3.21.1 127.4.253.1
>> >> >> >> 127.2.253.1 127.1.221.1 <-> *127.4.252.1         7500   300   300   10
>> >> >> >>    0    0        0
>> >> >> >> ffff88003c720800 ffff880033594000 2   1   3  36124    1        0
>> >> >> >>  0       0  5673 58513  7168  127.3.253.1 127.3.21.1 127.4.253.1
>> >> >> >> 127.2.253.1 127.1.221.1 <-> *127.4.252.1         7500   300   300   10
>> >> >> >>    0    0        0
>> >> >> >>
>> >> >> > I don't see any difference between the two environments here.  How exactly are
>> >> >> > you 'giving' a private ip here?  Are you attempting an ADDIP operation?
>> >> >> >
>> >> >>
>> >> >> [Vipul] -- The difference which I can is the public IP 164.48.1.1 is
>> >> >> there in association list. (Why & how this case in this list this I am
>> >> >> not able to understand). however If I assign the IP 10.1.1.1/24 to my
>> >> >> eth0 it doesn't come in this association.
>> >> >> The IP address assignment is using ifconfig.
>> >> >>
>> >> > Ok, so all your doing is specifying it on the interface, you're not explicitly
>> >> > binding to it in whatever program you have.
>> >> >
>> >>
>> >> [vipul] - Yes, At client side I am not doing explicitly bind.
>> >>
>> >> >> >>
>> >> >> >> - I may be wrong but is it possible that when we do bind with on IP
>> >> >> >> (and if multi homing is enabled) it'll build with all available
>> >> >> >> interfaces?
>> >> >> >>
>> >> >> > The opposite in fact.  If you bind to a local address the association on that
>> >> >> > socket will be creating using only the bound address, if you do not bind on a
>> >> >> > local address (the autobind case), and multihoming is enabled, then all
>> >> >> > available addresses will be used.
>> >> >> >
>> >> >> [Vipul] -- If this is the case one host is working as server and I am
>> >> >> doing bind on that for IP 127.4.252.1 and the other host is always
>> >> >> acting as client and in this I just do connect().
>> >> >> So Client will bind with all IP addresses, in this case I am not clear
>> >> >> why & how private IP is not coming for the accociation and why public
>> >> >> IP is coming in this association?
>> >> > Can you post the code that you are using to set up this connection?
>> >> >
>> >> ******
>> >> #define SERVER_IP "127.4.252.1"
>> >> #define CLIENT_IP "127.4.253.1"
>> >>
>> >> socklen_t optlen = sizeof (optval);
>> >> struct sctp_event_subscribe   events ;
>> >> ..
>> >> ..
>> >>  start_socket:
>> >>
>> >>  tSoc = -1 ;
>> >>  lSoc = -1 ; /* intialize the socket description */
>> >>     if (  (lSoc = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP)) < 0 ) {
>> >>          //error handling.
>> >>          return ;
>> >>     }
>> >> ...
>> >> ...
>> >>
>> >>  /* Specify the peer end point for connection */
>> >>      servaddr.sin_family = AF_INET;
>> >>      servaddr.sin_port = htons(7169);
>> >>      inet_aton(SERVER_IP, &servaddr.sin_addr);
>> >>
>> >>      optval = 0;
>> >>      if (setsockopt(lSoc, SOL_SOCKET, SO_KEEPALIVE, &optval, optlen) < 0) {
>> >>          //error handling.
>> >>      }
>> >>
>> >>      /* set to re-use to avoid "Address in use" on retry */
>> >>      optval = 1;
>> >>      if(setsockopt(lSoc, SOL_SOCKET, SO_REUSEADDR, &optval, optlen) < 0) {
>> >>          //error handling.
>> >>      }
>> >>
>> >>
>> >> ....
>> >> ....
>> >>
>> >>     /* bind the server address in keep listening */
>> >>      if (0 != bind(lSoc, (struct sockaddr *)&servaddr, sizeof(sockaddr))) {
>> >>     // error handling.
>> >>              close(lSoc);
>> >>              sleep(2);
>> >>              goto start_socket;
>> >>      }
>> >>
>> >>     if (listen(lSoc,5) == -1) {
>> >>         close(lSoc);
>> >>         sleep(2);
>> >>         goto start_socket ; /* close the current connection and wait for new */
>> >>     }
>> >> ...
>> >> ...
>> >>
>> >>      /* SCTP Events noticiation to listen */
>> >>      bzero(&events,sizeof(events));
>> >>      events.sctp_data_io_event = 1;
>> >>      events.sctp_association_event = 1;
>> >>      events.sctp_address_event = 1;
>> >>      events.sctp_send_failure_event = 1;
>> >>      events.sctp_peer_error_event = 1;
>> >>      events.sctp_shutdown_event = 1;
>> >>      if(setsockopt(lSoc,IPPROTO_SCTP,SCTP_EVENTS,&events,sizeof(events)) < 0) {
>> >>          // Error handling.
>> >>      }
>> >> ...
>> >> ...
>> >>
>> >>     while (1) {
>> >>     start:
>> >>     if (server) { //server case
>> >>         if((tSoc = accept (lSoc, NULL, 0))  == -1 ) {
>> >>         //Error handle
>> >>         sleep(2) ;
>> >>                 goto start ;
>> >>             }
>> >>     } else {  // client case
>> >>         if ((connect(lSoc, (struct sockaddr *)&servaddr,
>> >> sizeof(sockaddr))) != 0) {
>> >>             //Error Handling
>> >>                }
>> >>         }
>> >>
>> >>    }
>> >>
>> >> ...
>> >> ...
>> >> after that when I do
>> >>
>> >>    if((len = recvmsg(tSoc, msg, MSG_NOSIGNAL)) > 0) {
>> >>     // Some operation.
>> >>    } /* if (len > 0) */
>> >>
>> >>    if (len  < 0) {
>> >>     if (getsockopt(tSoc, IPPROTO_SCTP,SCTP_STATUS, &status, &socklen) == -1) {
>> >>         HERE I GET CONNECTION RESET BY PEER
>> >>     }
>> >>    }
>> >> ************************************
>> >>
>> >> I have following default setting related to sctp.
>> >>
>> >> h-3.2# sysctl -a |grep sctp
>> >> net.sctp.rto_initial = 3000
>> >> net.sctp.rto_min = 1000
>> >> net.sctp.rto_max = 60000
>> >> net.sctp.valid_cookie_life = 600000
>> >> net.sctp.max_burst = 4
>> >> net.sctp.association_max_retrans = 10
>> >> net.sctp.sndbuf_policy = 0
>> >> net.sctp.rcvbuf_policy = 0
>> >> net.sctp.path_max_retrans = 5
>> >> net.sctp.max_init_retransmits = 8
>> >> net.sctp.hb_interval = 30000
>> >> net.sctp.cookie_preserve_enable = 1
>> >> net.sctp.rto_alpha_exp_divisor = 3
>> >> net.sctp.rto_beta_exp_divisor = 2
>> >> net.sctp.addip_enable = 0
>> >> net.sctp.prsctp_enable = 1
>> >> net.sctp.sack_timeout = 200
>> >> net.sctp.sctp_mem = 36171    48230    72342
>> >> net.sctp.sctp_rmem = 4096    397500    1543360
>> >> net.sctp.sctp_wmem = 4096    16384    1543360
>> >> net.sctp.auth_enable = 0
>> >> net.sctp.addip_noauth_enable = 0
>> >> net.sctp.addr_scope_policy = 1
>> >> net.sctp.rwnd_update_shift = 4
>> >> net.sctp.max_autoclose = 8589934
>> >> sh-3.2#
>> >>
>> >> ********
>> >> Attaching two pcap files.
>> >>
>> >> 1. Client_localIP.pcap ---> In this file local IP (10.1.1.1) is not in
>> >> association.
>> >> 2, Client_publicIP.pcap. ---> in this 164.48.1.1 is part of association.
>> >>
>> >>
>> >>
>> >> >> I have also tries with "echo "2" >
>> >> >> /proc/sys/net/sctp/addr_scope_policy" which even doesn't allow the
>> >> >> association with private IP. for both (private & public IP) the server
>> >> >> receiver end receives the connection reset by peer.
>> >> >>
>> >> > Can you provide a tcpdump of this as well?
>> >> > Neil
>> >> >
>> >> >
>> >> >> > Neil
>> >> >> >
>> >> >>
>> >> >>
>> >> >> --
>> >> >> -=vipsy
>> >> >> http://through-dlens.blogspot.in
>> >> >>
>> >>
>> > So, I'm somewhat confused here.  I've looked at both the tcpdumps you provided
>> > and both traces show that ABORT chunks are generated, the exact same ABORT
>> > chunks.
>> >
>>
>> [Vipul] -- Ohh I got your point. If you are looking at starting ABORT,
>> that time server was not running but once IT started there is not
>> ABORT in between, (Please forgave me I didn't explain this in my
>> previous mail). And if you look into capture with publicIP there are
>> continue ABORT in some interval. I don;t know why this ABORT after
>> some data transmission.
>>
> Ah, ok, I still don't see a significant difference though.  You have have
> identical INIT chunks in the client_localIP trace, some of which produce aborts,
> some of which result in successful connections. I'm not sure what the difference
> is, and neither of them contain your 168.* address in the init chunk (look at
> frames 109-112 and 113-116 for comprative examples).  I would suggest looking at
> the snmp stats on the peer, or just enable dynamic debugging in the sctp module
> to get some clue as to whats going on here.
>
>
>>
>> > So I'm left wondering why you think one environment works and the other
>> > doesn't (unless neither environment works and I just misunderstood you
>> > previously).
>> >
>> > FWIW, the ABORT chunks have no causal data, which suggests they are either the
>> > result of the reception of an out of the blue packet, a t5 timer expiration or
>> > an init verification failure (I would guess the latter).  What does
>> > /proc/net/sctp/snmp show after you get the aborts?
>> >
>> > Neil
>> >
>> >>
>>
>> I used the Bind before connect to bind only one IP and this fixes the
>> issue. Now I cannot see multiple IP in association and no ABORT
>> PACKET.
>>
>> I'll be able to update with snmp output after a while as I need revert
>> the code again to get this.
>>
>> (If you think this is worth to discusses why ABORT is coming I'll
>> really like to continue this).
>>
>> PS: Really thanks a lot to all team for helping me and guiding me.
>>
> Don't thank me yet, I'm going on vacation here for a week or so.
>>
>> >>
>> >> --
>> >> -=vipsy
>> >> http://through-dlens.blogspot.in
>> >
>> >
>>
>>
>>
>> --
>> -=vipsy
>> http://through-dlens.blogspot.in
>>



-- 
-=vipsy
http://through-dlens.blogspot.in

--047d7b2e3e68eb125d04e32d974e
Content-Type: application/octet-stream; name="Assoc & snmp logs"
Content-Disposition: attachment; filename="Assoc & snmp logs"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjzb8u7p0

KEhPU1QgQSBydW5pbmcgYXMgU0VSVkVSICYgSE9TVCBCIGFzIENsaWVudCkKIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKSG9zdCBBIHdpdGhvdXQgYW55
IElQIG9uIGV0aDAuCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpzaC0zLjIjIGNhdCAv
cHJvYy9uZXQvc2N0cC9hc3NvY3MgCiBBU1NPQyAgICAgU09DSyAgIFNUWSBTU1QgU1QgSEJLVCBB
U1NPQy1JRCBUWF9RVUVVRSBSWF9RVUVVRSBVSUQgSU5PREUgTFBPUlQgUlBPUlQgTEFERFJTIDwt
PiBSQUREUlMgSEJJTlQgSU5TIE9VVFMgTUFYUlQgVDFYIFQyWCBSVFhDCmZmZmY4ODAwNWJlNzE4
MDAgZmZmZjg4MDAwYTQ4Y2U0MCAyICAgMSAgIDMgIDUxNTE0ICAgIDIgICAgICAgIDAgICAgICAg
IDAgICAgICAgMCAgNjA5OCA3MTY4ICA1MTY5OSAgMTI3LjQuMjUyLjEgPC0+ICoxMjcuNC4yNTMu
MSAxMjcuMy4yNTMuMSAxMjcuMy4yMS4xIDEyNy4yLjI1My4xIDEyNy4xLjIyMS4xIAkgICAgNzUw
MCAgIDMwMCAgIDMwMCAgIDEwICAgIDAgICAgMCAgICAgICAgMCAKZmZmZjg4MDAwOWY3ZjAwMCBm
ZmZmODgwMDBhNDhjOTgwIDIgICAxICAgMyAgNTg4MzkgICAgMSAgICAgICAgMCAgICAgICAgMCAg
ICAgICAwICA2MDk3IDcxNjkgIDU4NDE5ICAxMjcuNC4yNTIuMSA8LT4gKjEyNy40LjI1My4xIDEy
Ny4zLjI1My4xIDEyNy4zLjIxLjEgMTI3LjIuMjUzLjEgMTI3LjEuMjIxLjEgCSAgICA3NTAwICAg
MzAwICAgMzAwICAgMTAgICAgMCAgICAwICAgICAgICAwIApzaC0zLjIjIApzaC0zLjIjCgpzaC0z
LjIjIGNhdCAvcHJvYy9uZXQvc2N0cC9zbm1wICAgClNjdHBDdXJyRXN0YWIgICAgICAgICAgICAg
ICAgICAgCTIKU2N0cEFjdGl2ZUVzdGFicyAgICAgICAgICAgICAgICAJMApTY3RwUGFzc2l2ZUVz
dGFicyAgICAgICAgICAgICAgIAkyClNjdHBBYm9ydGVkcyAgICAgICAgICAgICAgICAgICAgCTAK
U2N0cFNodXRkb3ducyAgICAgICAgICAgICAgICAgICAJMApTY3RwT3V0T2ZCbHVlcyAgICAgICAg
ICAgICAgICAgIAkyClNjdHBDaGVja3N1bUVycm9ycyAgICAgICAgICAgICAgCTAKU2N0cE91dEN0
cmxDaHVua3MgICAgICAgICAgICAgICAJMTU0ClNjdHBPdXRPcmRlckNodW5rcyAgICAgICAgICAg
ICAgCTEzODEKU2N0cE91dFVub3JkZXJDaHVua3MgICAgICAgICAgICAJMApTY3RwSW5DdHJsQ2h1
bmtzICAgICAgICAgICAgICAgIAkxMTQ0ClNjdHBJbk9yZGVyQ2h1bmtzICAgICAgICAgICAgICAg
CTExNzEKU2N0cEluVW5vcmRlckNodW5rcyAgICAgICAgICAgICAJMApTY3RwRnJhZ1Vzck1zZ3Mg
ICAgICAgICAgICAgICAgIAkxMDYKU2N0cFJlYXNtVXNyTXNncyAgICAgICAgICAgICAgICAJMQpT
Y3RwT3V0U0NUUFBhY2tzICAgICAgICAgICAgICAgIAkxNDM2ClNjdHBJblNDVFBQYWNrcyAgICAg
ICAgICAgICAgICAgCTE3MzUKU2N0cFQxSW5pdEV4cGlyZWRzICAgICAgICAgICAgICAJMApTY3Rw
VDFDb29raWVFeHBpcmVkcyAgICAgICAgICAgIAkwClNjdHBUMlNodXRkb3duRXhwaXJlZHMgICAg
ICAgICAgCTAKU2N0cFQzUnR4RXhwaXJlZHMgICAgICAgICAgICAgICAJMApTY3RwVDRSdG9FeHBp
cmVkcyAgICAgICAgICAgICAgIAkwClNjdHBUNVNodXRkb3duR3VhcmRFeHBpcmVkcyAgICAgCTAK
U2N0cERlbGF5U2Fja0V4cGlyZWRzICAgICAgICAgICAJNjkKU2N0cEF1dG9jbG9zZUV4cGlyZWRz
ICAgICAgICAgICAJMApTY3RwVDNSZXRyYW5zbWl0cyAgICAgICAgICAgICAgIAkwClNjdHBQbXR1
ZFJldHJhbnNtaXRzICAgICAgICAgICAgCTAKU2N0cEZhc3RSZXRyYW5zbWl0cyAgICAgICAgICAg
ICAJMApTY3RwSW5Qa3RTb2Z0aXJxICAgICAgICAgICAgICAgIAkxNjYyClNjdHBJblBrdEJhY2ts
b2cgICAgICAgICAgICAgICAgCTczClNjdHBJblBrdERpc2NhcmRzICAgICAgICAgICAgICAgCTIK
U2N0cEluRGF0YUNodW5rRGlzY2FyZHMgICAgICAgICAJMApzaC0zLjIjIAoKCkhvc3QgQiB3aXRo
b3V0IGFueSBJUCBvbiBldGgwLgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpzaC0z
LjIjICBjYXQgL3Byb2MvbmV0L3NjdHAvYXNzb2NzCiBBU1NPQyAgICAgU09DSyAgIFNUWSBTU1Qg
U1QgSEJLVCBBU1NPQy1JRCBUWF9RVUVVRSBSWF9RVUVVRSBVSUQgSU5PREUgTFBPUlQgUlBPUlQg
TEFERFJTIDwtPiBSQUREUlMgSEJJTlQgSU5TIE9VVFMgTUFYUlQgVDFYIFQyWCBSVFhDCmZmZmY4
ODAwMGExZWMwMDAgZmZmZjg4MDAwOTg0MDRjMCAyICAgMSAgIDMgIDEyMDYxICAgIDEgICAgICAg
IDAgICAgICAgIDAgICAgICAgMCAgNTg4MCA1ODQxOSAgNzE2OSAgMTI3LjMuMjUzLjEgMTI3LjMu
MjEuMSAxMjcuNC4yNTMuMSAxMjcuMi4yNTMuMSAxMjcuMS4yMjEuMSA8LT4gKjEyNy40LjI1Mi4x
IAkgICAgNzUwMCAgIDMwMCAgIDMwMCAgIDEwICAgIDAgICAgMCAgICAgICAgMCAKZmZmZjg4MDAw
YTg0ZTAwMCBmZmZmODgwMDA5ODQwMDAwIDIgICAxICAgMyAgNjEyMTIgICAgMiAgICAgICAgMCAg
ICAgICAgMCAgICAgICAwICA1ODc5IDUxNjk5ICA3MTY4ICAxMjcuMy4yNTMuMSAxMjcuMy4yMS4x
IDEyNy40LjI1My4xIDEyNy4yLjI1My4xIDEyNy4xLjIyMS4xIDwtPiAqMTI3LjQuMjUyLjEgCSAg
ICA3NTAwICAgMzAwICAgMzAwICAgMTAgICAgMCAgICAwICAgICAgICAwIAoKc2gtMy4yIyAgY2F0
IC9wcm9jL25ldC9zY3RwL3NubXAgIApTY3RwQ3VyckVzdGFiICAgICAgICAgICAgICAgICAgIAky
ClNjdHBBY3RpdmVFc3RhYnMgICAgICAgICAgICAgICAgCTIKU2N0cFBhc3NpdmVFc3RhYnMgICAg
ICAgICAgICAgICAJMApTY3RwQWJvcnRlZHMgICAgICAgICAgICAgICAgICAgIAkyClNjdHBTaHV0
ZG93bnMgICAgICAgICAgICAgICAgICAgCTAKU2N0cE91dE9mQmx1ZXMgICAgICAgICAgICAgICAg
ICAJMApTY3RwQ2hlY2tzdW1FcnJvcnMgICAgICAgICAgICAgIAkwClNjdHBPdXRDdHJsQ2h1bmtz
ICAgICAgICAgICAgICAgCTc1MApTY3RwT3V0T3JkZXJDaHVua3MgICAgICAgICAgICAgIAkxMjA3
ClNjdHBPdXRVbm9yZGVyQ2h1bmtzICAgICAgICAgICAgCTAKU2N0cEluQ3RybENodW5rcyAgICAg
ICAgICAgICAgICAJMTA3OApTY3RwSW5PcmRlckNodW5rcyAgICAgICAgICAgICAgIAkxNDE3ClNj
dHBJblVub3JkZXJDaHVua3MgICAgICAgICAgICAgCTAKU2N0cEZyYWdVc3JNc2dzICAgICAgICAg
ICAgICAgICAJMQpTY3RwUmVhc21Vc3JNc2dzICAgICAgICAgICAgICAgIAkxMDYKU2N0cE91dFND
VFBQYWNrcyAgICAgICAgICAgICAgICAJMTgwNwpTY3RwSW5TQ1RQUGFja3MgICAgICAgICAgICAg
ICAgIAkxNDA0ClNjdHBUMUluaXRFeHBpcmVkcyAgICAgICAgICAgICAgCTAKU2N0cFQxQ29va2ll
RXhwaXJlZHMgICAgICAgICAgICAJMApTY3RwVDJTaHV0ZG93bkV4cGlyZWRzICAgICAgICAgIAkw
ClNjdHBUM1J0eEV4cGlyZWRzICAgICAgICAgICAgICAgCTAKU2N0cFQ0UnRvRXhwaXJlZHMgICAg
ICAgICAgICAgICAJMApTY3RwVDVTaHV0ZG93bkd1YXJkRXhwaXJlZHMgICAgIAkwClNjdHBEZWxh
eVNhY2tFeHBpcmVkcyAgICAgICAgICAgCTU5NwpTY3RwQXV0b2Nsb3NlRXhwaXJlZHMgICAgICAg
ICAgIAkwClNjdHBUM1JldHJhbnNtaXRzICAgICAgICAgICAgICAgCTAKU2N0cFBtdHVkUmV0cmFu
c21pdHMgICAgICAgICAgICAJMApTY3RwRmFzdFJldHJhbnNtaXRzICAgICAgICAgICAgIAkwClNj
dHBJblBrdFNvZnRpcnEgICAgICAgICAgICAgICAgCTEzOTIKU2N0cEluUGt0QmFja2xvZyAgICAg
ICAgICAgICAgICAJMTIKU2N0cEluUGt0RGlzY2FyZHMgICAgICAgICAgICAgICAJMApTY3RwSW5E
YXRhQ2h1bmtEaXNjYXJkcyAgICAgICAgIAkwCnNoLTMuMiMgCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KCkFkZGluZyBQcml2YXRlIElQICgxMC4xLjEuMS8yNCkgb24gSE9T
VCBCCioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgpzaC0zLjIjICBj
YXQgL3Byb2MvbmV0L3NjdHAvYXNzb2NzCiBBU1NPQyAgICAgU09DSyAgIFNUWSBTU1QgU1QgSEJL
VCBBU1NPQy1JRCBUWF9RVUVVRSBSWF9RVUVVRSBVSUQgSU5PREUgTFBPUlQgUlBPUlQgTEFERFJT
IDwtPiBSQUREUlMgSEJJTlQgSU5TIE9VVFMgTUFYUlQgVDFYIFQyWCBSVFhDCmZmZmY4ODAwMDI5
Mzg4MDAgZmZmZjg4MDAwOTg0MDRjMCAyICAgMSAgIDMgIDMyMDI4ICAgIDQgICAgICAgIDAgICAg
ICAgIDAgICAgICAgMCAyMzk5NyA0MTA1NyAgNzE2OCAgMTI3LjMuMjUzLjEgMTI3LjMuMjEuMSAx
MjcuNC4yNTMuMSAxMjcuMi4yNTMuMSAxMjcuMS4yMjEuMSAxMjcuMy4yNTQuMSA8LT4gKjEyNy40
LjI1Mi4xIAkgICAgNzUwMCAgIDMwMCAgIDMwMCAgIDEwICAgIDAgICAgMCAgICAgICAgMCAKZmZm
Zjg4MDA0MzM4ZjAwMCBmZmZmODgwMDA5ODQwMDAwIDIgICAxICAgMyAgNTQ4MTMgICAgMyAgICAg
ICAgMCAgICAgICAgMCAgICAgICAwIDIzOTk2IDUxNjU4ICA3MTY5ICAxMjcuMy4yNTMuMSAxMjcu
My4yMS4xIDEyNy40LjI1My4xIDEyNy4yLjI1My4xIDEyNy4xLjIyMS4xIDEyNy4zLjI1NC4xIDwt
PiAqMTI3LjQuMjUyLjEgCSAgICA3NTAwICAgMzAwICAgMzAwICAgMTAgICAgMCAgICAwICAgICAg
ICAwIApzaC0zLjIjIAoKaC0zLjIjICBjYXQgL3Byb2MvbmV0L3NjdHAvc25tcCAgClNjdHBDdXJy
RXN0YWIgICAgICAgICAgICAgICAgICAgCTIKU2N0cEFjdGl2ZUVzdGFicyAgICAgICAgICAgICAg
ICAJNApTY3RwUGFzc2l2ZUVzdGFicyAgICAgICAgICAgICAgIAkwClNjdHBBYm9ydGVkcyAgICAg
ICAgICAgICAgICAgICAgCTM3ClNjdHBTaHV0ZG93bnMgICAgICAgICAgICAgICAgICAgCTIKU2N0
cE91dE9mQmx1ZXMgICAgICAgICAgICAgICAgICAJMApTY3RwQ2hlY2tzdW1FcnJvcnMgICAgICAg
ICAgICAgIAkwClNjdHBPdXRDdHJsQ2h1bmtzICAgICAgICAgICAgICAgCTExMzYKU2N0cE91dE9y
ZGVyQ2h1bmtzICAgICAgICAgICAgICAJMTc1MwpTY3RwT3V0VW5vcmRlckNodW5rcyAgICAgICAg
ICAgIAkwClNjdHBJbkN0cmxDaHVua3MgICAgICAgICAgICAgICAgCTE2MjMKU2N0cEluT3JkZXJD
aHVua3MgICAgICAgICAgICAgICAJMTk1MQpTY3RwSW5Vbm9yZGVyQ2h1bmtzICAgICAgICAgICAg
IAkwClNjdHBGcmFnVXNyTXNncyAgICAgICAgICAgICAgICAgCTgKU2N0cFJlYXNtVXNyTXNncyAg
ICAgICAgICAgICAgICAJMTA3ClNjdHBPdXRTQ1RQUGFja3MgICAgICAgICAgICAgICAgCTI3MTAK
U2N0cEluU0NUUFBhY2tzICAgICAgICAgICAgICAgICAJMjEwMgpTY3RwVDFJbml0RXhwaXJlZHMg
ICAgICAgICAgICAgIAk2ClNjdHBUMUNvb2tpZUV4cGlyZWRzICAgICAgICAgICAgCTAKU2N0cFQy
U2h1dGRvd25FeHBpcmVkcyAgICAgICAgICAJMApTY3RwVDNSdHhFeHBpcmVkcyAgICAgICAgICAg
ICAgIAkwClNjdHBUNFJ0b0V4cGlyZWRzICAgICAgICAgICAgICAgCTAKU2N0cFQ1U2h1dGRvd25H
dWFyZEV4cGlyZWRzICAgICAJMApTY3RwRGVsYXlTYWNrRXhwaXJlZHMgICAgICAgICAgIAk5MzMK
U2N0cEF1dG9jbG9zZUV4cGlyZWRzICAgICAgICAgICAJMApTY3RwVDNSZXRyYW5zbWl0cyAgICAg
ICAgICAgICAgIAkwClNjdHBQbXR1ZFJldHJhbnNtaXRzICAgICAgICAgICAgCTAKU2N0cEZhc3RS
ZXRyYW5zbWl0cyAgICAgICAgICAgICAJMApTY3RwSW5Qa3RTb2Z0aXJxICAgICAgICAgICAgICAg
IAkyMDg2ClNjdHBJblBrdEJhY2tsb2cgICAgICAgICAgICAgICAgCTE2ClNjdHBJblBrdERpc2Nh
cmRzICAgICAgICAgICAgICAgCTAKU2N0cEluRGF0YUNodW5rRGlzY2FyZHMgICAgICAgICAJMApz
aC0zLjIjIAoKRHVyaW5nIHRoaXMgdGltZSBIT1NUIEEgdmFsdWVzOgoqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqIApzaC0zLjIjIGNhdCAvcHJvYy9uZXQvc2N0cC9hc3NvY3MgCiBBU1NP
QyAgICAgU09DSyAgIFNUWSBTU1QgU1QgSEJLVCBBU1NPQy1JRCBUWF9RVUVVRSBSWF9RVUVVRSBV
SUQgSU5PREUgTFBPUlQgUlBPUlQgTEFERFJTIDwtPiBSQUREUlMgSEJJTlQgSU5TIE9VVFMgTUFY
UlQgVDFYIFQyWCBSVFhDCmZmZmY4ODAwNGM0MjM4MDAgZmZmZjg4MDA0ZmY5NGU0MCAyICAgMSAg
IDMgIDQxMTUzICAgIDIgICAgICAgIDAgICAgICAgIDAgICAgICAgMCAgNjA4NCA3MTY4ICA0MTA1
NyAgMTI3LjQuMjUyLjEgPC0+ICoxMjcuNC4yNTMuMSAxMjcuMy4yNTMuMSAxMjcuMy4yMS4xIDEy
Ny4yLjI1My4xIDEyNy4xLjIyMS4xIDEyNy4zLjI1NC4xIAkgICAgNzUwMCAgIDMwMCAgIDMwMCAg
IDEwICAgIDAgICAgMCAgICAgICAgMCAKZmZmZjg4MDA1YzI3ZDgwMCBmZmZmODgwMDRmZjk0MDAw
IDIgICAxICAgMyAgNTEyMDMgICAgMSAgICAgICAgMCAgICAgICAgMCAgICAgICAwICA2MDUyIDcx
NjkgIDUxNjU4ICAxMjcuNC4yNTIuMSA8LT4gKjEyNy40LjI1My4xIDEyNy4zLjI1My4xIDEyNy4z
LjIxLjEgMTI3LjIuMjUzLjEgMTI3LjEuMjIxLjEgMTI3LjMuMjU0LjEgCSAgICA3NTAwICAgMzAw
ICAgMzAwICAgMTAgICAgMCAgICAwICAgICAgICAwIApzaC0zLjIjIAoKc2gtMy4yIyBjYXQgL3By
b2MvbmV0L3NjdHAvc25tcCAgIApTY3RwQ3VyckVzdGFiICAgICAgICAgICAgICAgICAgIAkyClNj
dHBBY3RpdmVFc3RhYnMgICAgICAgICAgICAgICAgCTAKU2N0cFBhc3NpdmVFc3RhYnMgICAgICAg
ICAgICAgICAJMgpTY3RwQWJvcnRlZHMgICAgICAgICAgICAgICAgICAgIAkwClNjdHBTaHV0ZG93
bnMgICAgICAgICAgICAgICAgICAgCTAKU2N0cE91dE9mQmx1ZXMgICAgICAgICAgICAgICAgICAJ
MzEKU2N0cENoZWNrc3VtRXJyb3JzICAgICAgICAgICAgICAJMApTY3RwT3V0Q3RybENodW5rcyAg
ICAgICAgICAgICAgIAk1NDcKU2N0cE91dE9yZGVyQ2h1bmtzICAgICAgICAgICAgICAJNzYyClNj
dHBPdXRVbm9yZGVyQ2h1bmtzICAgICAgICAgICAgCTAKU2N0cEluQ3RybENodW5rcyAgICAgICAg
ICAgICAgICAJNjY3ClNjdHBJbk9yZGVyQ2h1bmtzICAgICAgICAgICAgICAgCTkzOApTY3RwSW5V
bm9yZGVyQ2h1bmtzICAgICAgICAgICAgIAkwClNjdHBGcmFnVXNyTXNncyAgICAgICAgICAgICAg
ICAgCTEKU2N0cFJlYXNtVXNyTXNncyAgICAgICAgICAgICAgICAJODkKU2N0cE91dFNDVFBQYWNr
cyAgICAgICAgICAgICAgICAJMTE3MgpTY3RwSW5TQ1RQUGFja3MgICAgICAgICAgICAgICAgIAk5
MzMKU2N0cFQxSW5pdEV4cGlyZWRzICAgICAgICAgICAgICAJMApTY3RwVDFDb29raWVFeHBpcmVk
cyAgICAgICAgICAgIAkwClNjdHBUMlNodXRkb3duRXhwaXJlZHMgICAgICAgICAgCTAKU2N0cFQz
UnR4RXhwaXJlZHMgICAgICAgICAgICAgICAJMApTY3RwVDRSdG9FeHBpcmVkcyAgICAgICAgICAg
ICAgIAkwClNjdHBUNVNodXRkb3duR3VhcmRFeHBpcmVkcyAgICAgCTAKU2N0cERlbGF5U2Fja0V4
cGlyZWRzICAgICAgICAgICAJMzIxClNjdHBBdXRvY2xvc2VFeHBpcmVkcyAgICAgICAgICAgCTAK
U2N0cFQzUmV0cmFuc21pdHMgICAgICAgICAgICAgICAJMApTY3RwUG10dWRSZXRyYW5zbWl0cyAg
ICAgICAgICAgIAkwClNjdHBGYXN0UmV0cmFuc21pdHMgICAgICAgICAgICAgCTAKU2N0cEluUGt0
U29mdGlycSAgICAgICAgICAgICAgICAJOTIyClNjdHBJblBrdEJhY2tsb2cgICAgICAgICAgICAg
ICAgCTExClNjdHBJblBrdERpc2NhcmRzICAgICAgICAgICAgICAgCTMxClNjdHBJbkRhdGFDaHVu
a0Rpc2NhcmRzICAgICAgICAgCTAKc2gtMy4yIyAKCgoKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQoKQWRkaW5nIFByaXZhdGUgSVAgKDE2NC40OC4xLjEvMjQpIG9uIEhPU1Qg
QgoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgpzaC0zLjIjICBj
YXQgL3Byb2MvbmV0L3NjdHAvYXNzb2NzIAogQVNTT0MgICAgIFNPQ0sgICBTVFkgU1NUIFNUIEhC
S1QgQVNTT0MtSUQgVFhfUVVFVUUgUlhfUVVFVUUgVUlEIElOT0RFIExQT1JUIFJQT1JUIExBRERS
UyA8LT4gUkFERFJTIEhCSU5UIElOUyBPVVRTIE1BWFJUIFQxWCBUMlggUlRYQwpmZmZmODgwMDU2
ZWMyMDAwIGZmZmY4ODAwNGQzOTgwMDAgMiAgIDEgICAzICAxMzA5ICAgIDMgICAgICAgIDAgICAg
ICAgIDAgICAgICAgMCAxNTc2NCA0ODkyMSAgNzE2OSAgMTI3LjMuMjUzLjEgMTI3LjMuMjEuMSAx
MjcuNC4yNTMuMSAxMjcuMi4yNTMuMSAxMjcuMS4yMjEuMSAxNjQuNDguMS4xIDEyNy4zLjI1NC4x
IDwtPiAqMTI3LjQuMjUyLjEgCSAgICA3NTAwICAgMzAwICAgMzAwICAgMTAgICAgMCAgICAwICAg
ICAgICAwIApmZmZmODgwMDI0Mzg5ODAwIGZmZmY4ODAwNGQzOTg0YzAgMiAgIDEgICAzICA3MTk2
ICAgIDUgICAgICAgIDAgICAgICAgIDAgICAgICAgMCAyMjI2NSAzNTU4NCAgNzE2OCAgMTI3LjMu
MjUzLjEgMTI3LjMuMjEuMSAxMjcuNC4yNTMuMSAxMjcuMi4yNTMuMSAxMjcuMS4yMjEuMSAxNjQu
NDguMS4xIDEyNy4zLjI1NC4xIDwtPiAqMTI3LjQuMjUyLjEgCSAgICA3NTAwICAgMzAwICAgMzAw
ICAgMTAgICAgMCAgICAwICAgICAgICAwIApzaC0zLjIjICBjYXQgL3Byb2MvbmV0L3NjdHAvc25t
cCAKU2N0cEN1cnJFc3RhYiAgICAgICAgICAgICAgICAgICAJMQpTY3RwQWN0aXZlRXN0YWJzICAg
ICAgICAgICAgICAgIAk1ClNjdHBQYXNzaXZlRXN0YWJzICAgICAgICAgICAgICAgCTAKU2N0cEFi
b3J0ZWRzICAgICAgICAgICAgICAgICAgICAJMzQKU2N0cFNodXRkb3ducyAgICAgICAgICAgICAg
ICAgICAJMgpTY3RwT3V0T2ZCbHVlcyAgICAgICAgICAgICAgICAgIAkwClNjdHBDaGVja3N1bUVy
cm9ycyAgICAgICAgICAgICAgCTAKU2N0cE91dEN0cmxDaHVua3MgICAgICAgICAgICAgICAJNzA3
ClNjdHBPdXRPcmRlckNodW5rcyAgICAgICAgICAgICAgCTE3NzMKU2N0cE91dFVub3JkZXJDaHVu
a3MgICAgICAgICAgICAJMApTY3RwSW5DdHJsQ2h1bmtzICAgICAgICAgICAgICAgIAkxNDYwClNj
dHBJbk9yZGVyQ2h1bmtzICAgICAgICAgICAgICAgCTE3NzQKU2N0cEluVW5vcmRlckNodW5rcyAg
ICAgICAgICAgICAJMApTY3RwRnJhZ1Vzck1zZ3MgICAgICAgICAgICAgICAgIAk4NgpTY3RwUmVh
c21Vc3JNc2dzICAgICAgICAgICAgICAgIAk4NwpTY3RwT3V0U0NUUFBhY2tzICAgICAgICAgICAg
ICAgIAkyMjMzClNjdHBJblNDVFBQYWNrcyAgICAgICAgICAgICAgICAgCTE5OTcKU2N0cFQxSW5p
dEV4cGlyZWRzICAgICAgICAgICAgICAJNgpTY3RwVDFDb29raWVFeHBpcmVkcyAgICAgICAgICAg
IAkwClNjdHBUMlNodXRkb3duRXhwaXJlZHMgICAgICAgICAgCTAKU2N0cFQzUnR4RXhwaXJlZHMg
ICAgICAgICAgICAgICAJMApTY3RwVDRSdG9FeHBpcmVkcyAgICAgICAgICAgICAgIAkwClNjdHBU
NVNodXRkb3duR3VhcmRFeHBpcmVkcyAgICAgCTAKU2N0cERlbGF5U2Fja0V4cGlyZWRzICAgICAg
ICAgICAJNTI5ClNjdHBBdXRvY2xvc2VFeHBpcmVkcyAgICAgICAgICAgCTAKU2N0cFQzUmV0cmFu
c21pdHMgICAgICAgICAgICAgICAJMApTY3RwUG10dWRSZXRyYW5zbWl0cyAgICAgICAgICAgIAkw
ClNjdHBGYXN0UmV0cmFuc21pdHMgICAgICAgICAgICAgCTAKU2N0cEluUGt0U29mdGlycSAgICAg
ICAgICAgICAgICAJMTkxNApTY3RwSW5Qa3RCYWNrbG9nICAgICAgICAgICAgICAgIAk4MwpTY3Rw
SW5Qa3REaXNjYXJkcyAgICAgICAgICAgICAgIAkwClNjdHBJbkRhdGFDaHVua0Rpc2NhcmRzICAg
ICAgICAgCTAKCkF0IHRoaXMgcG9pbnQgSE9TVCBBIChTZXJ2ZXIpIFJlY2VpdmVkIHRoZSBFcnJv
ci4KXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl4KCnNo
LTMuMiMgIGNhdCAvcHJvYy9uZXQvc2N0cC9hc3NvY3MgCiBBU1NPQyAgICAgU09DSyAgIFNUWSBT
U1QgU1QgSEJLVCBBU1NPQy1JRCBUWF9RVUVVRSBSWF9RVUVVRSBVSUQgSU5PREUgTFBPUlQgUlBP
UlQgTEFERFJTIDwtPiBSQUREUlMgSEJJTlQgSU5TIE9VVFMgTUFYUlQgVDFYIFQyWCBSVFhDCmZm
ZmY4ODAwNTZlYzIwMDAgZmZmZjg4MDA0ZDM5ODAwMCAyICAgMSAgIDMgIDEzMDkgICAgMyAgICAg
ICAgMCAgICAgICAgMCAgICAgICAwIDE1NzY0IDQ4OTIxICA3MTY5ICAxMjcuMy4yNTMuMSAxMjcu
My4yMS4xIDEyNy40LjI1My4xIDEyNy4yLjI1My4xIDEyNy4xLjIyMS4xIDE2NC40OC4xLjEgMTI3
LjMuMjU0LjEgPC0+ICoxMjcuNC4yNTIuMSAJICAgIDc1MDAgICAzMDAgICAzMDAgICAxMCAgICAw
ICAgIDAgICAgICAgIDAgCnNoLTMuMiMgIGNhdCAvcHJvYy9uZXQvc2N0cC9zbm1wIApTY3RwQ3Vy
ckVzdGFiICAgICAgICAgICAgICAgICAgIAkyClNjdHBBY3RpdmVFc3RhYnMgICAgICAgICAgICAg
ICAgCTcKU2N0cFBhc3NpdmVFc3RhYnMgICAgICAgICAgICAgICAJMApTY3RwQWJvcnRlZHMgICAg
ICAgICAgICAgICAgICAgIAkzNQpTY3RwU2h1dGRvd25zICAgICAgICAgICAgICAgICAgIAkyClNj
dHBPdXRPZkJsdWVzICAgICAgICAgICAgICAgICAgCTAKU2N0cENoZWNrc3VtRXJyb3JzICAgICAg
ICAgICAgICAJMApTY3RwT3V0Q3RybENodW5rcyAgICAgICAgICAgICAgIAk3MTkKU2N0cE91dE9y
ZGVyQ2h1bmtzICAgICAgICAgICAgICAJMTgzNQpTY3RwT3V0VW5vcmRlckNodW5rcyAgICAgICAg
ICAgIAkwClNjdHBJbkN0cmxDaHVua3MgICAgICAgICAgICAgICAgCTE0OTQKU2N0cEluT3JkZXJD
aHVua3MgICAgICAgICAgICAgICAJMTgzMQpTY3RwSW5Vbm9yZGVyQ2h1bmtzICAgICAgICAgICAg
IAkwClNjdHBGcmFnVXNyTXNncyAgICAgICAgICAgICAgICAgCTg5ClNjdHBSZWFzbVVzck1zZ3Mg
ICAgICAgICAgICAgICAgCTg4ClNjdHBPdXRTQ1RQUGFja3MgICAgICAgICAgICAgICAgCTIyODIK
U2N0cEluU0NUUFBhY2tzICAgICAgICAgICAgICAgICAJMjA0NApTY3RwVDFJbml0RXhwaXJlZHMg
ICAgICAgICAgICAgIAk2ClNjdHBUMUNvb2tpZUV4cGlyZWRzICAgICAgICAgICAgCTAKU2N0cFQy
U2h1dGRvd25FeHBpcmVkcyAgICAgICAgICAJMApTY3RwVDNSdHhFeHBpcmVkcyAgICAgICAgICAg
ICAgIAkwClNjdHBUNFJ0b0V4cGlyZWRzICAgICAgICAgICAgICAgCTAKU2N0cFQ1U2h1dGRvd25H
dWFyZEV4cGlyZWRzICAgICAJMApTY3RwRGVsYXlTYWNrRXhwaXJlZHMgICAgICAgICAgIAk1MzQK
U2N0cEF1dG9jbG9zZUV4cGlyZWRzICAgICAgICAgICAJMApTY3RwVDNSZXRyYW5zbWl0cyAgICAg
ICAgICAgICAgIAkwClNjdHBQbXR1ZFJldHJhbnNtaXRzICAgICAgICAgICAgCTAKU2N0cEZhc3RS
ZXRyYW5zbWl0cyAgICAgICAgICAgICAJMApTY3RwSW5Qa3RTb2Z0aXJxICAgICAgICAgICAgICAg
IAkxOTU3ClNjdHBJblBrdEJhY2tsb2cgICAgICAgICAgICAgICAgCTg3ClNjdHBJblBrdERpc2Nh
cmRzICAgICAgICAgICAgICAgCTAKU2N0cEluRGF0YUNodW5rRGlzY2FyZHMgICAgICAgICAJMApz
aC0zLjIjICBjYXQgL3Byb2MvbmV0L3NjdHAvYXNzb2NzIAogQVNTT0MgICAgIFNPQ0sgICBTVFkg
U1NUIFNUIEhCS1QgQVNTT0MtSUQgVFhfUVVFVUUgUlhfUVVFVUUgVUlEIElOT0RFIExQT1JUIFJQ
T1JUIExBRERSUyA8LT4gUkFERFJTIEhCSU5UIElOUyBPVVRTIE1BWFJUIFQxWCBUMlggUlRYQwpm
ZmZmODgwMDI0MjQ5MDAwIGZmZmY4ODAwNGQzOTg0YzAgMiAgIDEgICAzICAxMDUyICAgIDYgICAg
ICAgIDAgICAgICAgIDAgICAgICAgMCAyMzM2NyA0NDgyNCAgNzE2OCAgMTI3LjMuMjUzLjEgMTI3
LjMuMjEuMSAxMjcuNC4yNTMuMSAxMjcuMi4yNTMuMSAxMjcuMS4yMjEuMSAxNjQuNDguMS4xIDEy
Ny4zLjI1NC4xIDwtPiAqMTI3LjQuMjUyLjEgCSAgICA3NTAwICAgMzAwICAgMzAwICAgMTAgICAg
MCAgICAwICAgICAgICAwIAoKCkhPU1QgQSBWYWxlcyA6CioqKioqKioqKioqKioqKioKSnVzdCBi
ZW9mcmUgcmVjZXZpbmcgZXJyb3IKKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKc2gtMy4y
IyBjYXQgL3Byb2MvbmV0L3NjdHAvYXNzb2NzIAogQVNTT0MgICAgIFNPQ0sgICBTVFkgU1NUIFNU
IEhCS1QgQVNTT0MtSUQgVFhfUVVFVUUgUlhfUVVFVUUgVUlEIElOT0RFIExQT1JUIFJQT1JUIExB
RERSUyA8LT4gUkFERFJTIEhCSU5UIElOUyBPVVRTIE1BWFJUIFQxWCBUMlggUlRYQwpmZmZmODgw
MDU1YmM1ODAwIGZmZmY4ODAwNGQzMDQ5ODAgMiAgIDEgICAzICA0ODgwNiAgICAxICAgICAgICAw
ICAgICAgICAwICAgICAgIDAgIDU5NDYgNzE2OSAgNDg5MjEgIDEyNy40LjI1Mi4xIDwtPiAqMTI3
LjQuMjUzLjEgMTI3LjMuMjUzLjEgMTI3LjMuMjEuMSAxMjcuMi4yNTMuMSAxMjcuMS4yMjEuMSAx
NjQuNDguMS4xIDEyNy4zLjI1NC4xIAkgICAgNzUwMCAgIDMwMCAgIDMwMCAgIDEwICAgIDAgICAg
MCAgICAgICAgMCAKc2gtMy4yIyBjYXQgL3Byb2MvbmV0L3NjdHAvc25tcCAKU2N0cEN1cnJFc3Rh
YiAgICAgICAgICAgICAgICAgICAJMQpTY3RwQWN0aXZlRXN0YWJzICAgICAgICAgICAgICAgIAkw
ClNjdHBQYXNzaXZlRXN0YWJzICAgICAgICAgICAgICAgCTMKU2N0cEFib3J0ZWRzICAgICAgICAg
ICAgICAgICAgICAJMgpTY3RwU2h1dGRvd25zICAgICAgICAgICAgICAgICAgIAkwClNjdHBPdXRP
ZkJsdWVzICAgICAgICAgICAgICAgICAgCTMxClNjdHBDaGVja3N1bUVycm9ycyAgICAgICAgICAg
ICAgCTAKU2N0cE91dEN0cmxDaHVua3MgICAgICAgICAgICAgICAJNDE2ClNjdHBPdXRPcmRlckNo
dW5rcyAgICAgICAgICAgICAgCTYxOApTY3RwT3V0VW5vcmRlckNodW5rcyAgICAgICAgICAgIAkw
ClNjdHBJbkN0cmxDaHVua3MgICAgICAgICAgICAgICAgCTUyMApTY3RwSW5PcmRlckNodW5rcyAg
ICAgICAgICAgICAgIAk3ODYKU2N0cEluVW5vcmRlckNodW5rcyAgICAgICAgICAgICAJMApTY3Rw
RnJhZ1Vzck1zZ3MgICAgICAgICAgICAgICAgIAkxClNjdHBSZWFzbVVzck1zZ3MgICAgICAgICAg
ICAgICAgCTg1ClNjdHBPdXRTQ1RQUGFja3MgICAgICAgICAgICAgICAgCTg4NgpTY3RwSW5TQ1RQ
UGFja3MgICAgICAgICAgICAgICAgIAk3NzMKU2N0cFQxSW5pdEV4cGlyZWRzICAgICAgICAgICAg
ICAJMApTY3RwVDFDb29raWVFeHBpcmVkcyAgICAgICAgICAgIAkwClNjdHBUMlNodXRkb3duRXhw
aXJlZHMgICAgICAgICAgCTAKU2N0cFQzUnR4RXhwaXJlZHMgICAgICAgICAgICAgICAJMApTY3Rw
VDRSdG9FeHBpcmVkcyAgICAgICAgICAgICAgIAkwClNjdHBUNVNodXRkb3duR3VhcmRFeHBpcmVk
cyAgICAgCTAKU2N0cERlbGF5U2Fja0V4cGlyZWRzICAgICAgICAgICAJMTg2ClNjdHBBdXRvY2xv
c2VFeHBpcmVkcyAgICAgICAgICAgCTAKU2N0cFQzUmV0cmFuc21pdHMgICAgICAgICAgICAgICAJ
MApTY3RwUG10dWRSZXRyYW5zbWl0cyAgICAgICAgICAgIAkwClNjdHBGYXN0UmV0cmFuc21pdHMg
ICAgICAgICAgICAgCTAKU2N0cEluUGt0U29mdGlycSAgICAgICAgICAgICAgICAJNzY5ClNjdHBJ
blBrdEJhY2tsb2cgICAgICAgICAgICAgICAgCTQKU2N0cEluUGt0RGlzY2FyZHMgICAgICAgICAg
ICAgICAJMzEKU2N0cEluRGF0YUNodW5rRGlzY2FyZHMgICAgICAgICAJMApzaC0zLjIjIEF1ZyA0
IDIzOjMwOjQ5OiAqKioqKiByZWN2IGVycm9yICgtMSkgRXJyb3I6IENvbm5lY3Rpb24gcmVzZXQg
YnkgcGVlcgoKSnVzdCBBZnRlciBFcnJvcgoqKioqKioqKioqKioqKioqKgpjYXQgL3Byb2MvbmV0
L3NjdHAvYXNzb2NzIAogQVNTT0MgICAgIFNPQ0sgICBTVFkgU1NUIFNUIEhCS1QgQVNTT0MtSUQg
VFhfUVVFVUUgUlhfUVVFVUUgVUlEIElOT0RFIExQT1JUIFJQT1JUIExBRERSUyA8LT4gUkFERFJT
IEhCSU5UIElOUyBPVVRTIE1BWFJUIFQxWCBUMlggUlRYQwpmZmZmODgwMDViYjg5ODAwIGZmZmY4
ODAwNGQzMDRlNDAgMiAgIDEgICAzICAzNTg2NyAgICA1ICAgICAgICAwICAgICAgICAwICAgICAg
IDAgMTAzOTMgNzE2OSAgMzYyNDYgIDEyNy40LjI1Mi4xIDwtPiAqMTI3LjQuMjUzLjEgMTI3LjMu
MjUzLjEgMTI3LjMuMjEuMSAxMjcuMi4yNTMuMSAxMjcuMS4yMjEuMSAxNjQuNDguMS4xIDEyNy4z
LjI1NC4xIAkgICAgNzUwMCAgIDMwMCAgIDMwMCAgIDEwICAgIDAgICAgMCAgICAgICAgMCAKc2gt
My4yIyBjYXQgL3Byb2MvbmV0L3NjdHAvc25tcCAKU2N0cEN1cnJFc3RhYiAgICAgICAgICAgICAg
ICAgICAJMQpTY3RwQWN0aXZlRXN0YWJzICAgICAgICAgICAgICAgIAkwClNjdHBQYXNzaXZlRXN0
YWJzICAgICAgICAgICAgICAgCTUKU2N0cEFib3J0ZWRzICAgICAgICAgICAgICAgICAgICAJNApT
Y3RwU2h1dGRvd25zICAgICAgICAgICAgICAgICAgIAkwClNjdHBPdXRPZkJsdWVzICAgICAgICAg
ICAgICAgICAgCTM1ClNjdHBDaGVja3N1bUVycm9ycyAgICAgICAgICAgICAgCTAKU2N0cE91dEN0
cmxDaHVua3MgICAgICAgICAgICAgICAJNDU0ClNjdHBPdXRPcmRlckNodW5rcyAgICAgICAgICAg
ICAgCTY3OQpTY3RwT3V0VW5vcmRlckNodW5rcyAgICAgICAgICAgIAkwClNjdHBJbkN0cmxDaHVu
a3MgICAgICAgICAgICAgICAgCTU1OQpTY3RwSW5PcmRlckNodW5rcyAgICAgICAgICAgICAgIAk4
NTEKU2N0cEluVW5vcmRlckNodW5rcyAgICAgICAgICAgICAJMApTY3RwRnJhZ1Vzck1zZ3MgICAg
ICAgICAgICAgICAgIAkyClNjdHBSZWFzbVVzck1zZ3MgICAgICAgICAgICAgICAgCTg4ClNjdHBP
dXRTQ1RQUGFja3MgICAgICAgICAgICAgICAgCTk1NApTY3RwSW5TQ1RQUGFja3MgICAgICAgICAg
ICAgICAgIAk4MzEKU2N0cFQxSW5pdEV4cGlyZWRzICAgICAgICAgICAgICAJMApTY3RwVDFDb29r
aWVFeHBpcmVkcyAgICAgICAgICAgIAkwClNjdHBUMlNodXRkb3duRXhwaXJlZHMgICAgICAgICAg
CTAKU2N0cFQzUnR4RXhwaXJlZHMgICAgICAgICAgICAgICAJMApTY3RwVDRSdG9FeHBpcmVkcyAg
ICAgICAgICAgICAgIAkwClNjdHBUNVNodXRkb3duR3VhcmRFeHBpcmVkcyAgICAgCTAKU2N0cERl
bGF5U2Fja0V4cGlyZWRzICAgICAgICAgICAJMTk5ClNjdHBBdXRvY2xvc2VFeHBpcmVkcyAgICAg
ICAgICAgCTAKU2N0cFQzUmV0cmFuc21pdHMgICAgICAgICAgICAgICAJMApTY3RwUG10dWRSZXRy
YW5zbWl0cyAgICAgICAgICAgIAkwClNjdHBGYXN0UmV0cmFuc21pdHMgICAgICAgICAgICAgCTAK
U2N0cEluUGt0U29mdGlycSAgICAgICAgICAgICAgICAJODI3ClNjdHBJblBrdEJhY2tsb2cgICAg
ICAgICAgICAgICAgCTQKU2N0cEluUGt0RGlzY2FyZHMgICAgICAgICAgICAgICAJMzUKU2N0cElu
RGF0YUNodW5rRGlzY2FyZHMgICAgICAgICAJMAoKc2gtMy4yIyBjYXQgL3Byb2MvbmV0L3NjdHAv
c25tcCAKU2N0cEN1cnJFc3RhYiAgICAgICAgICAgICAgICAgICAJMApTY3RwQWN0aXZlRXN0YWJz
ICAgICAgICAgICAgICAgIAkwClNjdHBQYXNzaXZlRXN0YWJzICAgICAgICAgICAgICAgCTUKU2N0
cEFib3J0ZWRzICAgICAgICAgICAgICAgICAgICAJNQpTY3RwU2h1dGRvd25zICAgICAgICAgICAg
ICAgICAgIAkwClNjdHBPdXRPZkJsdWVzICAgICAgICAgICAgICAgICAgCTM2ClNjdHBDaGVja3N1
bUVycm9ycyAgICAgICAgICAgICAgCTAKU2N0cE91dEN0cmxDaHVua3MgICAgICAgICAgICAgICAJ
NDU5ClNjdHBPdXRPcmRlckNodW5rcyAgICAgICAgICAgICAgCTY4MQpTY3RwT3V0VW5vcmRlckNo
dW5rcyAgICAgICAgICAgIAkwClNjdHBJbkN0cmxDaHVua3MgICAgICAgICAgICAgICAgCTU2MwpT
Y3RwSW5PcmRlckNodW5rcyAgICAgICAgICAgICAgIAk4NTMKU2N0cEluVW5vcmRlckNodW5rcyAg
ICAgICAgICAgICAJMApTY3RwRnJhZ1Vzck1zZ3MgICAgICAgICAgICAgICAgIAkyClNjdHBSZWFz
bVVzck1zZ3MgICAgICAgICAgICAgICAgCTg4ClNjdHBPdXRTQ1RQUGFja3MgICAgICAgICAgICAg
ICAgCTk2MQpTY3RwSW5TQ1RQUGFja3MgICAgICAgICAgICAgICAgIAk4MzUKU2N0cFQxSW5pdEV4
cGlyZWRzICAgICAgICAgICAgICAJMApTY3RwVDFDb29raWVFeHBpcmVkcyAgICAgICAgICAgIAkw
ClNjdHBUMlNodXRkb3duRXhwaXJlZHMgICAgICAgICAgCTAKU2N0cFQzUnR4RXhwaXJlZHMgICAg
ICAgICAgICAgICAJMApTY3RwVDRSdG9FeHBpcmVkcyAgICAgICAgICAgICAgIAkwClNjdHBUNVNo
dXRkb3duR3VhcmRFeHBpcmVkcyAgICAgCTAKU2N0cERlbGF5U2Fja0V4cGlyZWRzICAgICAgICAg
ICAJMjAwClNjdHBBdXRvY2xvc2VFeHBpcmVkcyAgICAgICAgICAgCTAKU2N0cFQzUmV0cmFuc21p
dHMgICAgICAgICAgICAgICAJMApTY3RwUG10dWRSZXRyYW5zbWl0cyAgICAgICAgICAgIAkwClNj
dHBGYXN0UmV0cmFuc21pdHMgICAgICAgICAgICAgCTAKU2N0cEluUGt0U29mdGlycSAgICAgICAg
ICAgICAgICAJODMxClNjdHBJblBrdEJhY2tsb2cgICAgICAgICAgICAgICAgCTQKU2N0cEluUGt0
RGlzY2FyZHMgICAgICAgICAgICAgICAJMzYKU2N0cEluRGF0YUNodW5rRGlzY2FyZHMgICAgICAg
ICAJMAoKCgoK
--047d7b2e3e68eb125d04e32d974e--
