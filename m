From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 18 Jan 2019 13:10:22 +0000
Subject: Re: [PATCH 6/7] sctp: Convert to genradix
Message-Id: <20190118131022.GA22165@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181217131929.11727-1-kent.overstreet@gmail.com>
 <20181217131929.11727-7-kent.overstreet@gmail.com>
 <20181217125001.8e89ac2565417d55ef7a624e@linux-foundation.org>
 <20181217210021.GA7144@kmo-pixel>
 <20190115142926.GQ23855@localhost.localdomain>
In-Reply-To: <20190115142926.GQ23855@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

On Tue, Jan 15, 2019 at 12:29:26PM -0200, Marcelo Ricardo Leitner wrote:
> On Mon, Dec 17, 2018 at 04:00:21PM -0500, Kent Overstreet wrote:
> > On Mon, Dec 17, 2018 at 12:50:01PM -0800, Andrew Morton wrote:
> > > On Mon, 17 Dec 2018 08:19:28 -0500 Kent Overstreet <kent.overstreet@gmail.com> wrote:
> > > 
> > > > @@ -535,9 +470,6 @@ int sctp_send_add_streams(struct sctp_association *asoc,
> > > >  		goto out;
> > > >  	}
> > > >  
> > > > -	stream->incnt = incnt;
> > > > -	stream->outcnt = outcnt;
> > > > -
> > > >  	asoc->strreset_outstanding = !!out + !!in;
> > > >  
> > > 
> > > I'm seeing a reject here for some reason.  Using todays's linux-next,
> > > but there are no changes against net/sctp/stream.c in -next.  The
> > > assignment to stream->incnt has disappeared.  I did this:
> > > 
> > > @@ -535,8 +470,6 @@ int sctp_send_add_streams(struct sctp_as
> > >  		goto out;
> > >  	}
> > >  
> > > -	stream->outcnt = outcnt;
> > > -
> > >  	asoc->strreset_outstanding = !!out + !!in;
> > >  
> > >  out:
> > > 
> > > 
> > > We're at 4.20-rc7 and this series is rather large.  I'll merge them all
> > > to see what happens, but I don't think it's 4.21-rc1 material?
> > 
> > Yeah, agreed. Thanks!
> 
> Ping? Where did this go?
> 
As I recall kent reposted his series convirting flex_arrays to radix trees such
that it included sctp's uses.

I think xin needs to repost the sctp reallocation patch to make use of those
radix trees appropriately still (assuming any additional work still needs to be
done)

Neil

>   Marcelo
> 
