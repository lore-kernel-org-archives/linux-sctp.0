From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 11 Nov 2013 12:56:47 +0000
Subject: Re: Multi-homing question
Message-Id: <20131111125647.GA6355@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
In-Reply-To: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sat, Nov 09, 2013 at 10:44:48AM +0800, tsoi andrew wrote:
> Dear Neil,
> 
> I agree with you so that I already review code related to Accept and
> Bind are listed below but still can't find the problem at this moment.
>  Would you give me some hint?
I really don't know, and can't guarantee that the problem is in these functions.
If I had the whole client and server program, perhaps, but I don't see any
problem here.  The problem may also be on the connect side of the application.

> Moreover, in your utility, can your secondary IP return heartbeat ACK to client?
> 
Yes, Heartbeak ACKs always need to be sent on the same transport that received
the heartbeat in the first place.
Neil

> int SctpAcceptor::accept(
>                 Handle  *newHandle,
>                 SctpAssociation *newChannel,
>                 InetAddr *remoteAddrCopy)
> {
>         void            *addrPtr = NULL;
>         SOCKLEN_T       peersize = 0;
>         if (remoteAddrCopy) {
>                 addrPtr = remoteAddrCopy->getAddr();
>                 peersize = remoteAddrCopy->size();
>         }
>         SOCKET  newSockFd = ::accept((SOCKET)handle.fd, (struct
> sockaddr *)addrPtr, &peersize);
>         if (newSockFd = INVALID_SOCKET) {
>                 int errorCode = errno;
>                 if (errorCode)          perror("accept ");
>                 return -1;
>         } else {
>                 // We should check the validity of the new socket here
>                 //make sure we receive MSG_NOTIFICATION (without this,
> we can't read sinfo_ppid correctly)
>                 struct sctp_event_subscribe event;
>                 memset(&event, 0, sizeof(event));
>                 event.sctp_data_io_event = 1;
>                 event.sctp_association_event = 1;
>                 event.sctp_address_event = 1;
>                 event.sctp_send_failure_event = 1;
>                 event.sctp_peer_error_event = 1;
>                 event.sctp_partial_delivery_event = 1;
>                 event.sctp_shutdown_event = 1;
>                 // Must hardcode sizeof(sctp_event_subscribe) to 8;
> otherwise will fail
>                 if (::setsockopt(newSockFd, IPPROTO_SCTP, SCTP_EVENTS,
> & event, 8) < 0) {
>                         perror("setsockopt(SCTP_EVENTS): ");
>                         // Unable to set socket option
>                         CLOSE_SOCKET(newSockFd);
>                         return -3;
>                 }
>                 Handle  h((int *)newSockFd, Handle::SOCKET);
>                 if (newHandle) {
>                         *newHandle = h;
>                 }
>                 if (newChannel) {
>                         newChannel->setHandle(&h);      // Once the
> handle is set, we can retrieve the local & remote addr
> 
> newChannel->setReadStatus(StreamConnection::STATUS_READ_READY);
>                 }
>                 if (!newHandle && !newChannel) {
>                         // Both pointers are null is disallowed.
>                         CLOSE_SOCKET(newSockFd);
>                         return -2;
>                 }
>                 return 0;
>         }
> }
> int SctpAcceptor::bind(SOCKET fd, const MultiHomedInetAddr &addr)
> {
>         char    ipStr[128];
>         int     rc;
>         int     secondaryAddrCount = addr.getSecondaryAddrCount();
>         InetAddr        primaryAddr = addr;             // Get the
> primary address first
>         if (secondaryAddrCount = 0 && primaryAddr.getPort() = 0) {
>                 return -1;      // Acceptor must have a port to bind
>         }
>         primaryAddr.getIp(ipStr);
>         printf("fd=%d. Binding to primary addr %s:%d...\n", (int)fd,
> ipStr, primaryAddr.getPort());
>         // We must call bind() first before calling bindx()
>         if ((rc = ::bind(fd, (struct sockaddr *)primaryAddr.getAddr(),
> primaryAddr.size()))  < 0) {
>                 int errorCode = errno;
>                 if (errorCode)          perror("bind ");
>        }
> 
>         if (!rc && secondaryAddrCount > 0) {
>                 SOCKADDR_IN     *addrList = new SOCKADDR_IN[secondaryAddrCount];
>                 addr.getSecondaryAddr(addrList, secondaryAddrCount);
>              for(int i=0; i<secondaryAddrCount;i++) {
>                    char ip[32];
>                    inet_ntop(addrList[i].sin_family, &addrList[i].sin_addr, ip,
>                    (addrList[i].sin_family = AF_INET) ?
> INET_ADDRSTRLEN : INET6_ADDRSTRLEN);
>                        unsigned port = ntohs(addrList[i].sin_port);
>                    printf("Bind to secondary (%s : %d)\n", ip, port);
>                }
>                 rc = sctp_bindx(fd, (struct sockaddr *)addrList,
> secondaryAddrCount, SCTP_BINDX_ADD_ADDR);
>                 delete  [] addrList;
>                 if (rc < 0) {
>                         int errorCode = errno;
>                         if (errorCode)          perror("bindx ");
>                 }
>         }
>         // No need to close the socket if rc < 0, because outer
> function will close it for us
>         return rc;
> }
> 
> Regards,
> Andrew
> 
> On Fri, Nov 8, 2013 at 8:12 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Fri, Nov 08, 2013 at 11:35:51AM +0800, tsoi andrew wrote:
> >> Dear Neil,
> >>
> >> The 176 routing is ok because when I shift 172.28.129.176 to primary address.
> >> The 176 can be establish but 48 failed.
> >> I guess it is related to primary and secondary setting.  Can secondary
> >> IP be established also?
> >>
> >> sctp                172.28.129.176:9082
> >>      LISTEN
> >>                     172.28.129.48:9082
> >>
> >> sctp       0      0 172.28.129.176:9082         10.82.29.240:9082
> >>      ESTABLISHED
> >> Regards,
> >> Andrew
> >>
> > If thats the case I would suspect that something is wrong with either your
> > sysctl settings or your application.  I can use the sctp_darn utility included
> > in lksctp-tools to set up a multihomed connection here without issue
> > Neil
> >
> >> On Thu, Nov 7, 2013 at 10:16 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >> > On Thu, Nov 07, 2013 at 11:45:25AM +0800, tsoi andrew wrote:
> >> >> Dear Neil,
> >> >>
> >> >> Attached file is our tcpdump.
> >> >> Now our secondary IP doesn't work.
> >> >> Please advise. Thanks.
> >> >>
> >> >> IP info:
> >> >> lksctp primary IP is 172.28.129.49
> >> >> lksctp secondary IP is 172.28.129.176
> >> >>
> >> >> Client IP is 10.82.29.240/10.82.29.241
> >> >>
> >> >>
> >> >  I think you mean the lksctp primary is 172.28.129.48, not 49, but no matter.
> >> >
> >> > Looking at this, its not just heartbeats that arent getting answered, nothing is
> >> > getting responded to via the 176 address.  The only data that I see come out of
> >> > that address are two abort frames (not sure what the cause is there yet).
> >> >
> >> > I would start by verifying basic connectivity via that address.  I'd try
> >> > something like:
> >> > ping -I 172.28.129.176 10.82.29.240
> >> > and
> >> > ping -I 172.28.129.176 10.82.29.241
> >> >
> >> > while running a tcpdump on the interface that holds the 176 address specifically
> >> > to make sure that you're routing tables locally and network in generally can
> >> > pass traffic over that address
> >> >
> >> > Neil
> >> >
> >> >>
> >> >>
> >> >>
> >> >> Regards,
> >> >> Andrew
> >> >>
> >> >> On Thu, Nov 7, 2013 at 10:43 AM, tsoi andrew <tsoiandrew@gmail.com> wrote:
> >> >> >  Dear Neil,
> >> >> >
> >> >> > For more information, our secondary IP doesn't response COOKIE_ECHO
> >> >> > also. Only our primary IP can response COOKIE_ECHO with COOKIE_ACK.
> >> >> >
> >> >> > Regards,
> >> >> > Andrew
> >> >> >
> >> >> > On Thu, Nov 7, 2013 at 10:36 AM, tsoi andrew <tsoiandrew@gmail.com> wrote:
> >> >> >> Dear Neil,
> >> >> >>
> >> >> >> Please find my network diagram first.
> >> >> >> Now at server side, can't see our lksctp client 4 connection but only
> >> >> >> 2 2 connection.  The reason is that heartbeat ACK not found.
> >> >> >>
> >> >> >> Regards,
> >> >> >> Andrew
> >> >> >>
> >> >> >> On Mon, Nov 4, 2013 at 8:09 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >> >> >>> On Mon, Nov 04, 2013 at 09:59:44AM +0800, tsoi andrew wrote:
> >> >> >>>> Dear Sir,
> >> >> >>>>
> >> >> >>>> I got a problem when set multi-homing to active/active.
> >> >> >>>> That mean, It is expected that our lksctp server have 2 IP to connect
> >> >> >>>> 2 IP of destination client with total 4 connections.
> >> >> >>>> The flow is that client send "INIT" message with 2 (primary and
> >> >> >>>> secondary) IP to our server and lksctp server return INIT_ACK. But
> >> >> >>>> when second client send 'heartbeat' to us, lksctp server cannot return
> >> >> >>>> ACK.
> >> >> >>>> Moreover, we already proved our connectivity correct because when our
> >> >> >>>> lksctp server send heartbeat to both destination client and they can
> >> >> >>>> return ACK.
> >> >> >>>> Would you mind sharing if lksctp lib already configure those
> >> >> >>>> multi-homing purpose.
> >> >> >>>>
> >> >> >>> Can you provide a network diagram and a tcpdump of your connection?
> >> >> >>> Neil
> >> >> >>>
> >> >> >>>>
> >> >> >>>>
> >> >> >>>> Best Regards,
> >> >> >>>> Andrew Tsoi
> >> >> >>>> --
> >> >> >>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> >> >> >>>> the body of a message to majordomo@vger.kernel.org
> >> >> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >> >>>>
> >> >
> >> >
> >>
> 
