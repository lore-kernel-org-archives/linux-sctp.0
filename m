From: David Miller <davem@davemloft.net>
Date: Fri, 09 Feb 2018 19:32:23 +0000
Subject: Re: [PATCH net v2] sctp: verify size of a new chunk in _sctp_make_chunk()
Message-Id: <20180209.143223.1410582840717699699.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1518186923-28650-1-git-send-email-alexey.kodanev@oracle.com>
In-Reply-To: <1518186923-28650-1-git-send-email-alexey.kodanev@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: alexey.kodanev@oracle.com
Cc: netdev@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Alexey Kodanev <alexey.kodanev@oracle.com>
Date: Fri,  9 Feb 2018 17:35:23 +0300

> When SCTP makes INIT or INIT_ACK packet the total chunk length
> can exceed SCTP_MAX_CHUNK_LEN which leads to kernel panic when
> transmitting these packets, e.g. the crash on sending INIT_ACK:
 ...
> Here the chunk size for INIT_ACK packet becomes too big, mostly
> because of the state cookie (INIT packet has large size with
> many address parameters), plus additional server parameters.
> 
> Later this chunk causes the panic in skb_put_data():
> 
>   skb_packet_transmit()
>       sctp_packet_pack()
>           skb_put_data(nskb, chunk->skb->data, chunk->skb->len);
> 
> 'nskb' (head skb) was previously allocated with packet->size
> from u16 'chunk->chunk_hdr->length'.
> 
> As suggested by Marcelo we should check the chunk's length in
> _sctp_make_chunk() before trying to allocate skb for it and
> discard a chunk if its size bigger than SCTP_MAX_CHUNK_LEN.
> 
> Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>

Applied and queued up for -stable, thanks.
