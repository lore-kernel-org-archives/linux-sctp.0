From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Fri, 20 Apr 2018 18:32:24 +0000
Subject: Re: [PATCH net-next 0/5] virtio-net: Add SCTP checksum offload support
Message-Id: <20180420213118-mutt-send-email-mst@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180402134006.10111-1-vyasevic@redhat.com>
 <20180402144730.GA6001@localhost.localdomain>
 <6bc762f6-d6fb-5471-2893-a888cce199f9@redhat.com>
 <20180418162633-mutt-send-email-mst@kernel.org>
 <20180420172219.GR4716@localhost.localdomain>
In-Reply-To: <20180420172219.GR4716@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Vlad Yasevich <vyasevic@redhat.com>, Vladislav Yasevich <vyasevich@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, jasowang@redhat.com, nhorman@tuxdriver.com

On Fri, Apr 20, 2018 at 02:22:19PM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Apr 18, 2018 at 05:06:46PM +0300, Michael S. Tsirkin wrote:
> > On Tue, Apr 17, 2018 at 04:35:18PM -0400, Vlad Yasevich wrote:
> > > On 04/02/2018 10:47 AM, Marcelo Ricardo Leitner wrote:
> > > > On Mon, Apr 02, 2018 at 09:40:01AM -0400, Vladislav Yasevich wrote:
> > > >> Now that we have SCTP offload capabilities in the kernel, we can add
> > > >> them to virtio as well.  First step is SCTP checksum.
> > > >
> > > > Thanks.
> > > >
> > > >> As for GSO, the way sctp GSO is currently implemented buys us nothing
> > > >> in added support to virtio.  To add true GSO, would require a lot of
> > > >> re-work inside of SCTP and would require extensions to the virtio
> > > >> net header to carry extra sctp data.
> > > >
> > > > Can you please elaborate more on this? Is this because SCTP GSO relies
> > > > on the gso skb format for knowing how to segment it instead of having
> > > > a list of sizes?
> > > >
> > >
> > > it's mainly because all the true segmentation, placing data into chunks,
> > > has already happened.  All that GSO does is allow for higher bundling
> > > rate between VMs. If that is all SCTP GSO ever going to do, that fine,
> > > but the goal is to do real GSO eventually and potentially reduce the
> > > amount of memory copying we are doing.
> > > If we do that, any current attempt at GSO in virtio would have to be
> > > depricated and we'd need GSO2 or something like that.
> >
> > Batching helps virtualization *a lot* though.
> 
> Yep. The results posted by Xin in the other email give good insights
> on it.
> 
> > Are there actual plans for GSO2? Is it just for SCTP?
> 
> No plans. In this context, at least, yes, just for SCTP.
> 
> It was a supposition in case we start doing a different GSO for SCTP,
> one more like what we have for TCP.
> 
> Currently, as the SCTP GSO code doesn't leave the system, we can
> update it if we want. But by the moment we add support for it in
> virtio, we will have to be backwards compatible if we end up doing
> SCTP GSO differently.

At least for TX you can always just disable the optimization. Won't be
worse than what is there now. RX is trickier - but that's GRO
not GSO.

> But again, I don't think such approach for SCTP GSO would be neither
> feasible or worth. The complexity for it, to work across stream
> schedules and late TSN allocation, would do more harm then good IMO.
> 
> >
> > >
> > > This is why, after doing the GSO support, I decided not to include it.
> > >
> > > -vlad
> > > >   Marcelo
> > > >
