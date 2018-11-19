From: David Miller <davem@davemloft.net>
Date: Mon, 19 Nov 2018 20:39:55 +0000
Subject: Re: [PATCH net] sctp: count sk_wmem_alloc by skb truesize in sctp_packet_transmit
Message-Id: <20181119.123955.865697238943438515.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b3325c7aa29d1981dabd897b25eae421f7055b0d.1542524858.git.lucien.xin@gmail.com>
In-Reply-To: <b3325c7aa29d1981dabd897b25eae421f7055b0d.1542524858.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 18 Nov 2018 15:07:38 +0800

> Now sctp increases sk_wmem_alloc by 1 when doing set_owner_w for the
> skb allocked in sctp_packet_transmit and decreases by 1 when freeing
> this skb.
> 
> But when this skb goes through networking stack, some subcomponents
> might change skb->truesize and add the same amount on sk_wmem_alloc.
> However sctp doesn't know the amount to decrease by, it would cause
> a leak on sk->sk_wmem_alloc and the sock can never be freed.
> 
> Xiumei found this issue when it hit esp_output_head() by using sctp
> over ipsec, where skb->truesize is added and so is sk->sk_wmem_alloc.
> 
> Since sctp has used sk_wmem_queued to count for writable space since
> Commit cd305c74b0f8 ("sctp: use sk_wmem_queued to check for writable
> space"), it's ok to fix it by counting sk_wmem_alloc by skb truesize
> in sctp_packet_transmit.
> 
> Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
