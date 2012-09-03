From: David Miller <davem@davemloft.net>
Date: Mon, 03 Sep 2012 17:24:44 +0000
Subject: Re: [PATCH] sctp: Don't charge for data in sndbuf again when transmitting packet
Message-Id: <20120903.132444.1801063740284928920.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <ed0aceea14e890e55829f42d1594ae9417b8ca25.1346681739.git.tgraf@suug.ch>
	<378685E0-7225-4C9D-AE0F-7B8767ECB16A@gmail.com>
In-Reply-To: <378685E0-7225-4C9D-AE0F-7B8767ECB16A@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: tgraf@suug.ch, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vyasevic@redhat.com, nhorman@tuxdriver.com

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 3 Sep 2012 11:02:51 -0400

> 
> 
> On Sep 3, 2012, at 10:27 AM, Thomas Graf <tgraf@suug.ch> wrote:
> 
>> SCTP charges wmem_alloc via sctp_set_owner_w() in sctp_sendmsg() and
>> via
>> skb_set_owner_w() in sctp_packet_transmit(). If a sender runs out of
>> sndbuf it will sleep in sctp_wait_for_sndbuf() and expects to be waken
>> up
>> by __sctp_write_space().
>>
>> Buffer space charged via sctp_set_owner_w() is released in
>> sctp_wfree()
>> which calls __sctp_write_space() directly.
>>
>> Buffer space charged via skb_set_owner_w() is released via
>> sock_wfree()
>> which calls sk->sk_write_space() _if_ SOCK_USE_WRITE_QUEUE is not set.
>> sctp_endpoint_init() sets SOCK_USE_WRITE_QUEUE on all sockets.
>>
>> Therefore if sctp_packet_transmit() manages to queue up more than
>> sndbuf
>> bytes, sctp_wait_for_sndbuf() will never be woken up again unless it
>> is
>> interrupted by a signal.
>>
>> This could be fixed by clearing the SOCK_USE_WRITE_QUEUE flag but ...
>>
>> Charging for the data twice does not make sense in the first place, it
>> leads to overcharging sndbuf by a factor 2. Therefore this patch only
>> charges a single byte in wmem_alloc when transmitting an SCTP packet
>> to
>> ensure that the socket stays alive until the packet has been released.
>>
>> This means that control chunks are no longer accounted for in
>> wmem_alloc
>> which I believe is not a problem as skb->truesize will typically lead
>> to overcharging anyway and thus compensates for any control overhead.
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied and queued up for -stable, thanks everyone.
