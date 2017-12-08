From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 08 Dec 2017 16:08:56 +0000
Subject: Re: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <20171208160856.GC6955@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com>
 <20171208145630.GE3328@localhost.localdomain>
 <20171208153734.GB6955@hmswarspite.think-freely.org>
 <20171208160001.GF3328@localhost.localdomain>
 <e3256db09d434461acb5861b30ef6f65@AcuMS.aculab.com>
In-Reply-To: <e3256db09d434461acb5861b30ef6f65@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>

On Fri, Dec 08, 2017 at 04:04:58PM +0000, David Laight wrote:
> From: Marcelo Ricardo Leitner
> > Sent: 08 December 2017 16:00
> ...
> > > Is it worth replacing the si struct with an index/enum value, and indexing an
> > > array of method pointer structs?  That would save you at least one dereference.
> > 
> > Hmmm, maybe, yes. It would be like
> > sctp_stream_interleave[asoc->stream.si].make_datafrag(...)
> 
> If you only expect 2 choices then an if () is likely
> to produce better code that the above.
> 
> The actual implementation can be hidden inside a #define
> or static inline function.
> 
Thats the real question though, will we expect more than two interleaving
strategies?  Currently its a boolean operation so the answer seems like yes, but
is there a possiblity of a biased interleaving, or other worthwhile algorithm?

Neil

> 	David
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
