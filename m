From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Fri, 08 Dec 2017 20:37:43 +0000
Subject: Re: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <20171208203743.GG3328@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com>
 <20171208145630.GE3328@localhost.localdomain>
 <20171208153734.GB6955@hmswarspite.think-freely.org>
 <20171208160001.GF3328@localhost.localdomain>
 <e3256db09d434461acb5861b30ef6f65@AcuMS.aculab.com>
 <20171208160856.GC6955@hmswarspite.think-freely.org>
In-Reply-To: <20171208160856.GC6955@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Laight <David.Laight@ACULAB.COM>, 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>

On Fri, Dec 08, 2017 at 11:08:56AM -0500, Neil Horman wrote:
> On Fri, Dec 08, 2017 at 04:04:58PM +0000, David Laight wrote:
> > From: Marcelo Ricardo Leitner
> > > Sent: 08 December 2017 16:00
> > ...
> > > > Is it worth replacing the si struct with an index/enum value, and indexing an
> > > > array of method pointer structs?  That would save you at least one dereference.
> > > 
> > > Hmmm, maybe, yes. It would be like
> > > sctp_stream_interleave[asoc->stream.si].make_datafrag(...)
> > 
> > If you only expect 2 choices then an if () is likely
> > to produce better code that the above.
> > 
> > The actual implementation can be hidden inside a #define
> > or static inline function.
> > 
> Thats the real question though, will we expect more than two interleaving
> strategies?  Currently its a boolean operation so the answer seems like yes, but
> is there a possiblity of a biased interleaving, or other worthwhile algorithm?

For the chunk format, I don't think so. It would require another RFC
update.
For other possibilities on having a 3rd choice in there, I also don't
think so. Stream scheduling is handled apart from it and rx buffer
stuff is being covered by it now, don't see how we could have a 3rd
option without another chunk format.

But that said, I don't think the macro or even inline wrappers are as
clear as the struct with function pointers here and in some cases it
even won't avoid the second deref. I wouldn't like to compromise code
readability and OO because of 1 fetch, specially considering that this
will be barely noticeable.

Neil's idea on using the array of structs and indexing on it is nice.
Saves a deref and keeps the abstractions without inserting too much
noise on it. Plus, it also allows replacing the struct pointer in
sctp_stream with a bit. If then placed before the union in there, we
can save up to the whole pointer. Looks like a good compromise to me.

  Marcelo
