From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 05 Oct 2016 16:55:01 +0000
Subject: Re: 64000 simultaneous connections
Message-Id: <20161005165501.GB2958@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CADz2ZUCDHyskrezX4mqFgnzHXZD3i=tC3MFXapDaEZniacyJBg@mail.gmail.com>
In-Reply-To: <CADz2ZUCDHyskrezX4mqFgnzHXZD3i=tC3MFXapDaEZniacyJBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Oct 05, 2016 at 12:34:03PM -0400, Al Gambardella wrote:
> Thanks for the reply.
> In addition to the net.ipv4.ip_local_port_range there are parameters
> to check such as: sctp.rto_initial and somaxconn. Also the number max

Why rto_initial? It shouldn't be related.
somaxconn, probably yes, if you're going to storm the listener.

> number of threads and file handles will have to been configured

It depends on how you will test it. SCTP can have all the 64k
associations under the same socket, if you want. But if you use it in a
1-1 style (TCP style), then yes probably you need to boost the number of
file handles.

Same applies for number of threads, only depends on your application.

> appropriately. Does the SCTP source code itself have built in resource
> limits or assumptions about max connections? I am trying to limit the

It might not scale well, but no, no limits like that comes to mind.

> surprises that I know are going to come up as I do this. So any and
> all suggestions are welcome.

Understand, yet as said, it really depends on how you will test it.

> 
> Thanks
> 
> 
> On Wed, Oct 5, 2016 at 11:38 AM, Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> > On Wed, Oct 05, 2016 at 11:33:24AM -0400, Al Gambardella wrote:
> >> Is there a how-to on what linux parameters and resources to check and
> >> or modify to support 64000 simultaneous SCTP connections.
> >>
> >> Its for a load test scenario. Each connection would only have to
> >> exchange one message with the remote side then just do keep alives.
> >
> > Seems at least sysctl net.ipv4.ip_local_port_range on client would have
> > to be changed, or you would have to have tons of client IP addresses.
> > Nothing else comes to mind, tough.
> >
> >   Marcelo
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
