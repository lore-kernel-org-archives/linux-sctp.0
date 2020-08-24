From: Harald Welte <laforge@gnumonks.org>
Date: Mon, 24 Aug 2020 10:46:50 +0000
Subject: Re: SCTP multi-homed association (::1)->(::1+127.0.0.1) attempting HEARTBEAT on 127.0.0.1->127.0.0.1
Message-Id: <20200824104650.GC3822842@nataraja>
List-Id: <linux-sctp.vger.kernel.org>
References: <552de663-8aeb-ff84-a425-988da88ca5cd@sysmocom.de>
In-Reply-To: <552de663-8aeb-ff84-a425-988da88ca5cd@sysmocom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Pau and list,

On Mon, Aug 24, 2020 at 12:00:27PM +0200, Pau Espin Pedrol wrote:

> Quick similar scenario setup would be something like:
> 
> SERVER:
> server_fd = socket(AF_INET6, SCTP, STREAM);
> sctp_bindx(server_fd, "127.0.0.1", "::1");
> listen(server_fd); accept(server_fd);
> 
> CLIENT:
> client_fd = socket(AF_INET6, SCTP, STREAM);
> sctp_bindx(client_fd, "::1");
> sctp_connectx(client_fd, "::1");
> 
> And then after client connects ::1<->::1 and gains info about server's
> 127.0.0.1 address, it tries to INIT 127.0.0.1->127.0.0.1 despite it was
> never bound to 127.0.0.1.

Thanks for reducing the example to the above.  I think it should be pretty
clear now.  The client side kernel SCTP is misbehaving here.

One minor amendment:  I don't think it's a question of whether or not the client
side socket ever was bound to 127.0.0.1.  The key issue here is that the client side
socket was not bound to any IPv4 address at all.

Sidenote: What I also find puzzling is that both sockets in your example are
created as AF_INET6 sockets, not as AF_UNSPEC.  But let's stay focused on the 
actual problem here: A client-side socket being exclusively bound to IPv6 adresses
attempting to send INIT chunks from an IPv4 address!

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
======================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
