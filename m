From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 27 Nov 2017 10:06:39 +0000
Subject: RE: [PATCH net 3/5] sctp: only allow the asoc reset when the asoc outq is empty
Message-Id: <3550c48ecea24515965aeb4753b2caac@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511614961.git.lucien.xin@gmail.com>
 <49b01e67e4cc1f8a0be85ffefdee51dad6ae3286.1511614961.git.lucien.xin@gmail.com>
In-Reply-To: <49b01e67e4cc1f8a0be85ffefdee51dad6ae3286.1511614961.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: "davem@davemloft.net" <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

From: Xin Long
> Sent: 25 November 2017 13:06
> 
> As it says in rfc6525#section5.1.4, before sending the request,
> 
>    C2:  The sender has either no outstanding TSNs or considers all
>         outstanding TSNs abandoned.
> 
> Prior to this patch, it tried to consider all outstanding TSNs abandoned
> by dropping all chunks in all outqs with sctp_outq_free (even including
> sacked, retransmit and transmitted queues) when doing this reset, which
> is too aggressive.
> 
> To make it work gently, this patch will only allow the asoc reset when
> the sender has no outstanding TSNs by checking if unsent, transmitted
> and retransmit are all empty with sctp_outq_is_empty before sending
> and processing the request.

Doesn't that rather defeat the point of a reset?

	David

