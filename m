From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 12 May 2019 05:52:48 +0000
Subject: Re: [PATCH net-next] sctp: remove unused cmd SCTP_CMD_GEN_INIT_ACK
Message-Id: <CADvbK_f3cmHB+gcY-h6df06kMbB8eB4oiXdL7A8BvxNqVF2aJw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <fa41cfdb9f8919d1420d12d270d97e3b17a0fb18.1557383280.git.lucien.xin@gmail.com>
 <20190509113235.GA12387@hmswarspite.think-freely.org> <20190509.093913.1261211226773919507.davem@davemloft.net>
 <20190510112718.GA4902@hmswarspite.think-freely.org>
In-Reply-To: <20190510112718.GA4902@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Fri, May 10, 2019 at 7:27 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Thu, May 09, 2019 at 09:39:13AM -0700, David Miller wrote:
> > From: Neil Horman <nhorman@tuxdriver.com>
> > Date: Thu, 9 May 2019 07:32:35 -0400
> >
> > > This is definately a valid cleanup, but I wonder if it wouldn't be better to,
> > > instead of removing it, to use it.  We have 2 locations where we actually call
> > > sctp_make_init_ack, and then have to check the return code and abort the
> > > operation if we get a NULL return.  Would it be a better solution (in the sense
> > > of keeping our control flow in line with how the rest of the state machine is
> > > supposed to work), if we didn't just add a SCTP_CMD_GEN_INIT_ACK sideeffect to
> > > the state machine queue in the locations where we otherwise would call
> > > sctp_make_init_ack/sctp_add_cmd_sf(...SCTP_CMD_REPLY)?
I think they didn't do that, as the new INIT_ACK needs to add unk_param from
the err_chunk which is allocated and freed in those two places
sctp_sf_do_5_1B_init()/sctp_sf_do_unexpected_init().

It looks not good to pass that err_chunk as a param to the state machine.

> >
> > Also, net-next is closed 8-)
> >
> Details, details :)
>
So everytime before posting a patch on net-next,
I should check http://vger.kernel.org/~davem/net-next.html first, right?
