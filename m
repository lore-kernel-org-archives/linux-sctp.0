From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 07 Dec 2016 12:37:28 +0000
Subject: Re: multihoming client question
Message-Id: <CADvbK_cDRhXbyYky0YsagBLmcaHmCZ9owoz64eJJz7pLi7Gtrw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
In-Reply-To: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Dec 1, 2016 at 3:04 PM, tsoi andrew <tsoiandrew@gmail.com> wrote:
> Dear Sir,
>
> The connection is broken so that no data is sending at this moment.
> While testing failover(force no heartbeat ack replied from the IP X),
> I find that IP A try to send the heartbeat to IP Y but no heartbeat
> ack finally.  Can lksctp client try to send heartbeat from IP B to IP
> Y?     As only connection between IP B and IP Y is valid at that time.
>
I got your issue now.

http://marc.info/?l=linux-sctp&m3714727725657&w=2

This patch probably affect that.

after that fix, sctp asks the route oif address must be the src when
using secondary addresses

so in your case, oif's ip of that route to Y  must be A, instead of B.
that's why sctp never choose path B->Y.

if you want B->Y, I need you need to adjust your route.
