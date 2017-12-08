From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 08 Dec 2017 16:04:58 +0000
Subject: RE: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <e3256db09d434461acb5861b30ef6f65@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com>
 <20171208145630.GE3328@localhost.localdomain>
 <20171208153734.GB6955@hmswarspite.think-freely.org>
 <20171208160001.GF3328@localhost.localdomain>
In-Reply-To: <20171208160001.GF3328@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>
Cc: 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>

From: Marcelo Ricardo Leitner
> Sent: 08 December 2017 16:00
...
> > Is it worth replacing the si struct with an index/enum value, and indexing an
> > array of method pointer structs?  That would save you at least one dereference.
> 
> Hmmm, maybe, yes. It would be like
> sctp_stream_interleave[asoc->stream.si].make_datafrag(...)

If you only expect 2 choices then an if () is likely
to produce better code that the above.

The actual implementation can be hidden inside a #define
or static inline function.

	David

