From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 03 Oct 2020 07:45:57 +0000
Subject: Re: [PATCH net-next 12/15] sctp: call sk_setup_caps in sctp_packet_transmit instead
Message-Id: <CADvbK_cV-yBX-NpPPQxTY+J8OFhv7DvH-UkeprAgtHW+mB0rqg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com> <3716fc0699dc1d5557574b5227524e80b7fd76b8.1601387231.git.lucien.xin@gmail.com>
 <20201003040915.GH70998@localhost.localdomain>
In-Reply-To: <20201003040915.GH70998@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>

On Sat, Oct 3, 2020 at 12:09 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:49:04PM +0800, Xin Long wrote:
> > sk_setup_caps() was originally called in Commit 90017accff61 ("sctp:
> > Add GSO support"), as:
> >
> >   "We have to refresh this in case we are xmiting to more than one
> >    transport at a time"
> >
> > This actually happens in the loop of sctp_outq_flush_transports(),
> > and it shouldn't be gso related, so move it out of gso part and
>
> To be more precise, "shouldn't be tied to gso"
right.

>
> > before sctp_packet_pack().
