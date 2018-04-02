From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 02 Apr 2018 14:47:30 +0000
Subject: Re: [PATCH net-next 0/5] virtio-net:  Add SCTP checksum offload support
Message-Id: <20180402144730.GA6001@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180402134006.10111-1-vyasevic@redhat.com>
In-Reply-To: <20180402134006.10111-1-vyasevic@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vyasevich@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, mst@redhat.com, jasowang@redhat.com, nhorman@tuxdriver.com, Vladislav Yasevich <vyasevic@redhat.com>

On Mon, Apr 02, 2018 at 09:40:01AM -0400, Vladislav Yasevich wrote:
> Now that we have SCTP offload capabilities in the kernel, we can add
> them to virtio as well.  First step is SCTP checksum.

Thanks.

> As for GSO, the way sctp GSO is currently implemented buys us nothing
> in added support to virtio.  To add true GSO, would require a lot of
> re-work inside of SCTP and would require extensions to the virtio
> net header to carry extra sctp data.

Can you please elaborate more on this? Is this because SCTP GSO relies
on the gso skb format for knowing how to segment it instead of having
a list of sizes?

  Marcelo
