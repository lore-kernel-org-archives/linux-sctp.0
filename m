From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 21 Feb 2017 14:27:25 +0000
Subject: RE: [PATCH net-next 2/2] sctp: add support for MSG_MORE
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DCFE6C9B9@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1487440272.git.lucien.xin@gmail.com>
 <d6f2835b0bd655a563896e86648cbd9b4e01374e.1487440272.git.lucien.xin@gmail.com>
In-Reply-To: <d6f2835b0bd655a563896e86648cbd9b4e01374e.1487440272.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>

From: Xin Long 
> Sent: 18 February 2017 17:53
> This patch is to add support for MSG_MORE on sctp.
> 
> It adds force_delay in sctp_datamsg to save MSG_MORE, and sets it after
> creating datamsg according to the send flag. sctp_packet_can_append_data
> then uses it to decide if the chunks of this msg will be sent at once or
> delay it.
> 
> Note that unlike [1], this patch saves MSG_MORE in datamsg, instead of
> in assoc. As sctp enqueues the chunks first, then dequeue them one by
> one. If it's saved in assoc,the current msg's send flag (MSG_MORE) may
> affect other chunks' bundling.

I thought about that and decided that the MSG_MORE flag on the last data
chunk was the only one that mattered.
Indeed looking at any others is broken.

Consider what happens if you have two small chunks queued, the first
with MSG_MORE set, the second with it clear.

I think that sctp_outq_flush() will look at the first chunk and decide it
doesn't need to do anything because sctp_packet_transmit_chunk()
returns SCTP_XMIT_DELAY.
The data chunk with MSG_MORE clear won't even be looked at.
So the data will never be sent.

I wouldn't worry about having messages queued that have MSG_MORE clean
when the final message has it set.
While it might be 'nice' to send the data (would have to be tx credit)
waiting for the next data chunk shouldn't be a problem.

I'm not sure I even want to test the current patch!

	David

