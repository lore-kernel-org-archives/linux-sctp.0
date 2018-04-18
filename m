From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 18 Apr 2018 01:33:33 +0000
Subject: Re: [PATCH net-next 0/5] virtio-net: Add SCTP checksum offload support
Message-Id: <20180418013333.GO4716@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180402134006.10111-1-vyasevic@redhat.com>
 <20180402144730.GA6001@localhost.localdomain>
 <6bc762f6-d6fb-5471-2893-a888cce199f9@redhat.com>
In-Reply-To: <6bc762f6-d6fb-5471-2893-a888cce199f9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevic@redhat.com>
Cc: Vladislav Yasevich <vyasevich@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, mst@redhat.com, jasowang@redhat.com, nhorman@tuxdriver.com, Xin Long <lucien.xin@gmail.com>

On Tue, Apr 17, 2018 at 04:35:18PM -0400, Vlad Yasevich wrote:
> On 04/02/2018 10:47 AM, Marcelo Ricardo Leitner wrote:
> > On Mon, Apr 02, 2018 at 09:40:01AM -0400, Vladislav Yasevich wrote:
> >> Now that we have SCTP offload capabilities in the kernel, we can add
> >> them to virtio as well.  First step is SCTP checksum.
> >
> > Thanks.
> >
> >> As for GSO, the way sctp GSO is currently implemented buys us nothing
> >> in added support to virtio.  To add true GSO, would require a lot of
> >> re-work inside of SCTP and would require extensions to the virtio
> >> net header to carry extra sctp data.
> >
> > Can you please elaborate more on this? Is this because SCTP GSO relies
> > on the gso skb format for knowing how to segment it instead of having
> > a list of sizes?
> >
>
> it's mainly because all the true segmentation, placing data into chunks,
> has already happened.  All that GSO does is allow for higher bundling
> rate between VMs. If that is all SCTP GSO ever going to do, that fine,
> but the goal is to do real GSO eventually and potentially reduce the
> amount of memory copying we are doing.
> If we do that, any current attempt at GSO in virtio would have to be
> depricated and we'd need GSO2 or something like that.
>
> This is why, after doing the GSO support, I decided not to include it.

Gotcha. I don't think it will ever go further than what we have now.
Placing data into chunks later is not really feasible/wanted,
especially now with stream schedulers and idata chunks. Doesn't seem
worth the hassle... we would have to support things like, "segment
half of this message plus a third of this other one from that other
stream." (in case it's round robin).

  Marcelo
