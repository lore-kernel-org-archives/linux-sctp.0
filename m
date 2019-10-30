From: Wei Zhao <wallyzhao@gmail.com>
Date: Wed, 30 Oct 2019 15:54:45 +0000
Subject: Re: [PATCH] sctp: set ooo_okay properly for Transmit Packet Steering
Message-Id: <CAFRmqq42HqX5KctcNjwyZJ4jdknLSZ1EyBqHnJQQJx211mWopw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com> <20191030132420.GG4326@localhost.localdomain>
In-Reply-To: <20191030132420.GG4326@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, wally.zhao@nokia-sbell.com

On 10/30/19, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Wed, Oct 30, 2019 at 12:07:17PM -0400, Wally Zhao wrote:
>> Unlike tcp_transmit_skb,
>> sctp_packet_transmit does not set ooo_okay explicitly,
>> causing unwanted Tx queue switching when multiqueue is in use;
>
> It is initialized to 0 by __alloc_skb() via:
>         memset(skb, 0, offsetof(struct sk_buff, tail));
> and never set to 1 by anyone for SCTP.
>
> The patch description seems off. I don't see how the unwanted Tx queue
> switching can happen. IOW, it's not fixing it OOO packets, but
> improving it by allowing switching on the first packet. Am I missing
> something?

Thanks for pointing this out. You are right. This ooo_okay is default to false.

I was observing some Tx queue switching before when testing with
iperf3 (modified to be able to set window size, for higher throughput
with long RTT), so I thought ooo_okay was set to true somewhere else
after allocation. Just now I did the test again, it turns out that
iperf3 made a re-connect silently which caused the Tx queue change.

As for the improving purpose of this patch, that is not that critical
from my side, and the patch description is not correct for this
purpose. So I will give up this patch attempt. Thank you again for
your time on this.

>
>> Tx queue switching may cause out-of-order packets.
>> Change sctp_packet_transmit to allow Tx queue switching only for
>> the first in flight packet, to avoid unwanted Tx queue switching.
>>
>> Signed-off-by: Wally Zhao <wallyzhao@gmail.com>
>> ---
>>  net/sctp/output.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/net/sctp/output.c b/net/sctp/output.c
>> index dbda7e7..5ff75cc 100644
>> --- a/net/sctp/output.c
>> +++ b/net/sctp/output.c
>> @@ -626,6 +626,10 @@ int sctp_packet_transmit(struct sctp_packet *packet,
>> gfp_t gfp)
>>  	/* neighbour should be confirmed on successful transmission or
>>  	 * positive error
>>  	 */
>> +
>> +	/* allow switch tx queue only for the first in flight pkt */
>> +	head->ooo_okay = asoc->outqueue.outstanding_bytes = 0;
>
> Considering we are talking about NIC queues here, we would have a
> better result with tp->flight_size instead. As in, we can switch
> queues if, for this transport, the queue is empty.
>
>> +
>>  	if (tp->af_specific->sctp_xmit(head, tp) >= 0 &&
>>  	    tp->dst_pending_confirm)
>>  		tp->dst_pending_confirm = 0;
>> --
>> 1.8.3.1
>>
>
