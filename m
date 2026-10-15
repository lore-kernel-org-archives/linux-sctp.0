Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629F549A3A9;
	Thu, 15 Oct 2026 09:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.13.80.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792057845; cv=none; b=oklHv7CG+5yDe9MysoArTaZNaAdRM5Gx/E3sODC2AsnAuI/o5295AOCGlVcb8FKHzODCEsW5UoHVus5uQaODWJps5skzX0rEckFAYJaSeUbMajOWYvi+Q6yzRHBsizSwObxtkW49Zy2xqMyw7+4iWF3iOL3pTUpB/wZgaUaJudk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792057845; c=relaxed/simple;
	bh=Xc1hYw7D6ZaqqHWFn6BUKh7r1NtME5QXhC1PSsJMpwI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=UKIjgVAwSukl9brE0sd8lFihUBu+GTqNBGln950I+nSFspcKHB18cNs1qqhboZCb1n8+kkdacubpGqh3R56b69Mxdrp1IQA/BTBURdkyfvtj+hhMVWPTYhZcbeq6sQcPLicu8Y9njYCTjrN6z22xGaIDuF8SSmucunDa9Iw0REs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de; spf=pass smtp.mailfrom=tipi-net.de; dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b=YLUgKPjK; arc=none smtp.client-ip=194.13.80.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b="YLUgKPjK"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B1D90A157F;
	Thu, 15 Oct 2026 11:50:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1792057837; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=b+1MJgfWUFrA4BRtF7VJVIaMVyc2kzmrHujQqeSpphw=;
	b=YLUgKPjKiD5YhKJ8Gg7zPpNjfuXqDEQ4Zbbx+GDXT7hDnGk7BILNhNa+Kj5/J8XtgkBXBb
	47ECAOR+t+8TcuXCPlLX27Sa/L76ieodAVu6rEUOg2M850I56+Eyv5Yery4yC+qUlkJfKM
	ilLOkEMUahknUAP+lU69EWXKVqxESAIgXcJ1yFblZQ3/5QUdk/aF8MAnP0YWuZ9XvBNcZH
	+VmpBJ34/6QHFb835vOd/l6qlO66vjiVsuNTVpuaiR5zYMlvdVC/wn8SlPfUIXCM4o9nW7
	5H96WKMD7DAXP0z2TnyUa/Fp71yltFKa1jL6ei1RdmKTfKGB0+3AZbhcEXKZ8Q==
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 15 Oct 2026 11:50:30 +0200
From: Nicolai Buchwitz <nb@tipi-net.de>
To: Raju Rangoju <Raju.Rangoju@amd.com>, Prashanth Kumar K R
 <PrashanthKumar.K.R@amd.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Ioana Ciornei
 <ioana.ciornei@nxp.com>, Sunil Goutham <sgoutham@marvell.com>, Geetha
 sowjanya <gakula@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>,
 Subbaraya Sundeep <sbhatta@marvell.com>, Bharat Bhushan
 <bbhushan2@marvell.com>, Maxime Chevallier <maxime.chevallier@bootlin.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, Sabrina Dubroca <sd@queasysnail.net>, Simon
 Horman <horms@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Luiz
 Augusto von Dentz <luiz.dentz@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, Alexander Aring <alex.aring@gmail.com>, Stefan Schmidt
 <stefan@datenfreihafen.org>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jeremy Kerr <jk@codeconstruct.com.au>, Matt Johnston
 <matt@codeconstruct.com.au>, Stephen Hemminger <stephen@networkplumber.org>,
 Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>, Marcelo
 Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Tung Quang Nguyen
 <tung.quang.nguyen@est.tech>, idosch@nvidia.com, kuniyu@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-bluetooth@vger.kernel.org,
 linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net-next] net: rename skb_unshare() to skb_unclone_full()
In-Reply-To: <20261015-nb-skb-unclone-full-v1-1-0dfbf01f60f2@tipi-net.de>
References: <20261015-nb-skb-unclone-full-v1-1-0dfbf01f60f2@tipi-net.de>
Message-ID: <5f6b4dfc8339d5147fc08ab7503adc79@tipi-net.de>
X-Sender: nb@tipi-net.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Patchwork claims that b4 aut missed Ido and Kuniyu in the list of 
recipients:

+TO both

On 15.10.2026 10:16, Nicolai Buchwitz wrote:
> skb_unshare() only copies cloned skbs. A shared skb that is not a clone
> comes back unchanged, which the name doesn't suggest. The loopback
> selftest hooks got caught by this and hit BUG_ON(skb_shared()).
> 
> Rename it to skb_unclone_full(). Like skb_unclone() it only acts on
> clones, but it copies the whole skb, not just the head.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
> ---
> Follow-up to Jakub's suggestion on the selftest shared-skb series:
> https://lore.kernel.org/all/20261014130618.4c50f817@kernel.org/
> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-selftest.c            |  2 +-
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c         |  4 ++--
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c      |  4 ++--
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c |  2 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c   |  2 +-
>  drivers/net/macsec.c                                     |  6 +++---
>  include/linux/if_vlan.h                                  | 16 
> ++++++++--------
>  include/linux/skbuff.h                                   | 11 
> +++++++----
>  net/bluetooth/6lowpan.c                                  |  2 +-
>  net/dsa/tag.c                                            |  2 +-
>  net/ieee802154/6lowpan/rx.c                              |  2 +-
>  net/ieee802154/6lowpan/tx.c                              |  2 +-
>  net/mctp/route.c                                         |  2 +-
>  net/sched/sch_netem.c                                    |  4 ++--
>  net/sctp/ulpqueue.c                                      |  2 +-
>  net/tipc/msg.c                                           |  2 +-
>  16 files changed, 34 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-selftest.c 
> b/drivers/net/ethernet/amd/xgbe/xgbe-selftest.c
> index cfdbd4639a1e..7ebae08ddf29 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-selftest.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-selftest.c
> @@ -44,7 +44,7 @@ static int xgbe_test_loopback_validate(struct sk_buff 
> *skb,
>  	struct iphdr *ih;
>  	int eat;
> 
> -	skb = skb_unshare(skb, GFP_ATOMIC);
> +	skb = skb_unclone_full(skb, GFP_ATOMIC);
>  	if (!skb)
>  		goto out;
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c 
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index def2d5c0e7f7..7227a35dfaf2 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -1418,9 +1418,9 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff 
> *skb,
>  	/* We'll be holding a back-reference to the skb until Tx 
> Confirmation;
>  	 * we don't want that overwritten by a concurrent Tx with a cloned 
> skb.
>  	 */
> -	skb = skb_unshare(skb, GFP_ATOMIC);
> +	skb = skb_unclone_full(skb, GFP_ATOMIC);
>  	if (unlikely(!skb)) {
> -		/* skb_unshare() has already freed the skb */
> +		/* skb_unclone_full() has already freed the skb */
>  		percpu_stats->tx_dropped++;
>  		return NETDEV_TX_OK;
>  	}
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c 
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
> index 8cabce0eb2ab..fe8ac5e85259 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
> @@ -1276,9 +1276,9 @@ static netdev_tx_t dpaa2_switch_port_tx(struct 
> sk_buff *skb,
>  	}
> 
>  	/* We'll be holding a back-reference to the skb until Tx confirmation 
> */
> -	skb = skb_unshare(skb, GFP_ATOMIC);
> +	skb = skb_unclone_full(skb, GFP_ATOMIC);
>  	if (unlikely(!skb)) {
> -		/* skb_unshare() has already freed the skb */
> +		/* skb_unclone_full() has already freed the skb */
>  		net_err_ratelimited("%s: Error copying the socket buffer\n", 
> net_dev->name);
>  		goto err_exit;
>  	}
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c 
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 77c5cfbe4ce4..4e418c7456b7 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -2117,7 +2117,7 @@ dma_addr_t otx2_dma_map_skb_frag(struct otx2_nic 
> *pfvf,
>  	/* Crypto hardware need write permission for ipsec crypto offload */
>  	if (unlikely(xfrm_offload(skb))) {
>  		dir = DMA_BIDIRECTIONAL;
> -		skb = skb_unshare(skb, GFP_ATOMIC);
> +		skb = skb_unclone_full(skb, GFP_ATOMIC);
>  	}
> 
>  	/* First segment is always skb->data */
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c 
> b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
> index dbe8339947be..40811df8f2b7 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
> @@ -920,7 +920,7 @@ static int stmmac_test_vlan_validate(struct sk_buff 
> *skb,
> 
>  	proto = tpriv->svlan ? ETH_P_8021AD : ETH_P_8021Q;
> 
> -	skb = skb_unshare(skb, GFP_ATOMIC);
> +	skb = skb_unclone_full(skb, GFP_ATOMIC);
>  	if (!skb)
>  		goto out;
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 409fd855235b..b714052e1a37 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -639,7 +639,7 @@ static struct sk_buff *macsec_encrypt(struct 
> sk_buff *skb,
>  			return ERR_PTR(-ENOMEM);
>  		}
>  	} else {
> -		skb = skb_unshare(skb, GFP_ATOMIC);
> +		skb = skb_unclone_full(skb, GFP_ATOMIC);
>  		if (!skb) {
>  			macsec_txsa_put(tx_sa);
>  			return ERR_PTR(-ENOMEM);
> @@ -948,7 +948,7 @@ static struct sk_buff *macsec_decrypt(struct 
> sk_buff *skb,
> 
>  		aead_request_set_crypt(req, sg, sg, len, iv);
>  		aead_request_set_ad(req, 
> macsec_hdr_len(macsec_skb_cb(skb)->has_sci));
> -		skb = skb_unshare(skb, GFP_ATOMIC);
> +		skb = skb_unclone_full(skb, GFP_ATOMIC);
>  		if (!skb) {
>  			aead_request_free(req);
>  			return ERR_PTR(-ENOMEM);
> @@ -1154,7 +1154,7 @@ static rx_handler_result_t 
> macsec_handle_frame(struct sk_buff **pskb)
>  	if (hdr->eth.h_proto != htons(ETH_P_MACSEC))
>  		return handle_not_macsec(skb);
> 
> -	skb = skb_unshare(skb, GFP_ATOMIC);
> +	skb = skb_unclone_full(skb, GFP_ATOMIC);
>  	*pskb = skb;
>  	if (!skb)
>  		return RX_HANDLER_CONSUMED;
> diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
> index 975892367136..c863cdf60f01 100644
> --- a/include/linux/if_vlan.h
> +++ b/include/linux/if_vlan.h
> @@ -427,8 +427,8 @@ static inline int __vlan_insert_tag(struct sk_buff 
> *skb,
>   * Inserts the VLAN tag into @skb as part of the payload at offset 
> mac_len
>   * Returns a VLAN tagged skb. This might change skb->head.
>   *
> - * Following the skb_unshare() example, in case of error, the calling 
> function
> - * doesn't have to worry about freeing the original skb.
> + * Following the skb_unclone_full() example, in case of error, the 
> calling
> + * function doesn't have to worry about freeing the original skb.
>   *
>   * Does not change skb->protocol so this function can be used during 
> receive.
>   *
> @@ -458,8 +458,8 @@ static inline struct sk_buff 
> *vlan_insert_inner_tag(struct sk_buff *skb,
>   * Inserts the VLAN tag into @skb as part of the payload
>   * Returns a VLAN tagged skb. This might change skb->head.
>   *
> - * Following the skb_unshare() example, in case of error, the calling 
> function
> - * doesn't have to worry about freeing the original skb.
> + * Following the skb_unclone_full() example, in case of error, the 
> calling
> + * function doesn't have to worry about freeing the original skb.
>   *
>   * Does not change skb->protocol so this function can be used during 
> receive.
>   *
> @@ -480,8 +480,8 @@ static inline struct sk_buff 
> *vlan_insert_tag(struct sk_buff *skb,
>   * Inserts the VLAN tag into @skb as part of the payload
>   * Returns a VLAN tagged skb. This might change skb->head.
>   *
> - * Following the skb_unshare() example, in case of error, the calling 
> function
> - * doesn't have to worry about freeing the original skb.
> + * Following the skb_unclone_full() example, in case of error, the 
> calling
> + * function doesn't have to worry about freeing the original skb.
>   *
>   * Return: modified @skb on success, NULL on error (@skb is freed).
>   */
> @@ -524,8 +524,8 @@ static inline void __vlan_hwaccel_copy_tag(struct 
> sk_buff *dst, const struct sk_
>   *
>   * Pushes the VLAN tag from @skb->vlan_tci inside to the payload.
>   *
> - * Following the skb_unshare() example, in case of error, the calling 
> function
> - * doesn't have to worry about freeing the original skb.
> + * Following the skb_unclone_full() example, in case of error, the 
> calling
> + * function doesn't have to worry about freeing the original skb.
>   */
>  static inline struct sk_buff *__vlan_hwaccel_push_inside(struct 
> sk_buff *skb)
>  {
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 27ec1e38c828..cd969dd73841 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2125,14 +2125,14 @@ static inline struct sk_buff 
> *skb_share_check(struct sk_buff *skb, gfp_t pri)
>  }
> 
>  /*
> - *	Copy shared buffers into a new sk_buff. We effectively do COW on
> + *	Copy cloned buffers into a new sk_buff. We effectively do COW on
>   *	packets to handle cases where we have a local reader and forward
>   *	and a couple of other messy ones. The normal one is tcpdumping
>   *	a packet that's being forwarded.
>   */
> 
>  /**
> - *	skb_unshare - make a copy of a shared buffer
> + *	skb_unclone_full - make a private copy of a cloned buffer
>   *	@skb: buffer to check
>   *	@pri: priority for memory allocation
>   *
> @@ -2142,10 +2142,13 @@ static inline struct sk_buff 
> *skb_share_check(struct sk_buff *skb, gfp_t pri)
>   *	the original buffer is returned. When called with a spinlock held 
> or
>   *	from interrupt state @pri must be %GFP_ATOMIC
>   *
> + *	Unlike skb_unclone(), the paged data is copied as well. A buffer 
> with
> + *	skb->users > 1 that is not a clone is returned as is, use
> + *	skb_share_check() for that case.
> + *
>   *	%NULL is returned on a memory allocation failure.
>   */
> -static inline struct sk_buff *skb_unshare(struct sk_buff *skb,
> -					  gfp_t pri)
> +static inline struct sk_buff *skb_unclone_full(struct sk_buff *skb, 
> gfp_t pri)
>  {
>  	might_sleep_if(gfpflags_allow_blocking(pri));
>  	if (skb_cloned(skb)) {
> diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
> index 30f4afa18bc8..a1c9c0d75da1 100644
> --- a/net/bluetooth/6lowpan.c
> +++ b/net/bluetooth/6lowpan.c
> @@ -515,7 +515,7 @@ static netdev_tx_t bt_xmit(struct sk_buff *skb, 
> struct net_device *netdev)
>  	/* We must take a copy of the skb before we modify/replace the ipv6
>  	 * header as the header could be used elsewhere
>  	 */
> -	skb = skb_unshare(skb, GFP_ATOMIC);
> +	skb = skb_unclone_full(skb, GFP_ATOMIC);
>  	if (!skb)
>  		return NET_XMIT_DROP;
> 
> diff --git a/net/dsa/tag.c b/net/dsa/tag.c
> index 991732d6eae2..6a5aa7fc331c 100644
> --- a/net/dsa/tag.c
> +++ b/net/dsa/tag.c
> @@ -64,7 +64,7 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct 
> net_device *dev,
>  		return 0;
>  	}
> 
> -	skb = skb_unshare(skb, GFP_ATOMIC);
> +	skb = skb_unclone_full(skb, GFP_ATOMIC);
>  	if (!skb)
>  		return 0;
> 
> diff --git a/net/ieee802154/6lowpan/rx.c b/net/ieee802154/6lowpan/rx.c
> index 517e6493f5d1..9148f1be7cba 100644
> --- a/net/ieee802154/6lowpan/rx.c
> +++ b/net/ieee802154/6lowpan/rx.c
> @@ -294,7 +294,7 @@ static int lowpan_rcv(struct sk_buff *skb, struct 
> net_device *wdev,
>  	 */
>  	if (lowpan_is_frag1(*skb_network_header(skb)) ||
>  	    lowpan_is_iphc(*skb_network_header(skb))) {
> -		skb = skb_unshare(skb, GFP_ATOMIC);
> +		skb = skb_unclone_full(skb, GFP_ATOMIC);
>  		if (!skb)
>  			goto out;
>  	}
> diff --git a/net/ieee802154/6lowpan/tx.c b/net/ieee802154/6lowpan/tx.c
> index b261daedc290..d346e906e41e 100644
> --- a/net/ieee802154/6lowpan/tx.c
> +++ b/net/ieee802154/6lowpan/tx.c
> @@ -279,7 +279,7 @@ netdev_tx_t lowpan_xmit(struct sk_buff *skb, struct 
> net_device *ldev)
>  			return NET_XMIT_DROP;
>  		}
>  	} else {
> -		skb = skb_unshare(skb, GFP_ATOMIC);
> +		skb = skb_unclone_full(skb, GFP_ATOMIC);
>  		if (!skb)
>  			return NET_XMIT_DROP;
>  	}
> diff --git a/net/mctp/route.c b/net/mctp/route.c
> index e7c95eeacb48..d18ed9d0db1d 100644
> --- a/net/mctp/route.c
> +++ b/net/mctp/route.c
> @@ -396,7 +396,7 @@ static int mctp_frag_queue(struct mctp_sk_key *key, 
> struct sk_buff *skb)
>  		 * this will free the skb; callers can no longer access it
>  		 * safely.
>  		 */
> -		key->reasm_head = skb_unshare(skb, GFP_ATOMIC);
> +		key->reasm_head = skb_unclone_full(skb, GFP_ATOMIC);
>  		if (!key->reasm_head)
>  			return -ENOMEM;
> 
> diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
> index 8a1b89a289d8..1dc2924890eb 100644
> --- a/net/sched/sch_netem.c
> +++ b/net/sched/sch_netem.c
> @@ -460,7 +460,7 @@ static int netem_enqueue(struct sk_buff *skb, 
> struct Qdisc *sch,
>  			 struct sk_buff **to_free)
>  {
>  	struct netem_sched_data *q = qdisc_priv(sch);
> -	/* We don't fill cb now as skb_unshare() may invalidate it */
> +	/* We don't fill cb now as skb_unclone_full() may invalidate it */
>  	struct netem_skb_cb *cb;
>  	struct sk_buff *skb2 = NULL;
>  	struct sk_buff *segs = NULL;
> @@ -528,7 +528,7 @@ static int netem_enqueue(struct sk_buff *skb, 
> struct Qdisc *sch,
>  			qdisc_skb_cb(skb)->pkt_len = skb->len;
>  		}
> 
> -		skb = skb_unshare(skb, GFP_ATOMIC);
> +		skb = skb_unclone_full(skb, GFP_ATOMIC);
>  		if (unlikely(!skb)) {
>  			WRITE_ONCE(q->allocation_errors, q->allocation_errors + 1);
>  			qdisc_qstats_drop(sch);
> diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
> index b05daafd369a..93823eebd727 100644
> --- a/net/sctp/ulpqueue.c
> +++ b/net/sctp/ulpqueue.c
> @@ -339,7 +339,7 @@ struct sctp_ulpevent 
> *sctp_make_reassembled_event(struct net *net,
>  		if (skb_cloned(f_frag)) {
>  			/* This is a cloned skb, we can't just modify
>  			 * the frag_list.  We need a new skb to do that.
> -			 * Instead of calling skb_unshare(), we'll do it
> +			 * Instead of calling skb_unclone_full(), we'll do it
>  			 * ourselves since we need to delay the free.
>  			 */
>  			new = skb_copy(f_frag, GFP_ATOMIC);
> diff --git a/net/tipc/msg.c b/net/tipc/msg.c
> index b0bba0feef56..39dfd33c8eec 100644
> --- a/net/tipc/msg.c
> +++ b/net/tipc/msg.c
> @@ -145,7 +145,7 @@ int tipc_buf_append(struct sk_buff **headbuf, 
> struct sk_buff **buf)
>  		if (skb_has_frag_list(frag) && __skb_linearize(frag))
>  			goto err;
>  		*buf = NULL;
> -		frag = skb_unshare(frag, GFP_ATOMIC);
> +		frag = skb_unclone_full(frag, GFP_ATOMIC);
>  		if (unlikely(!frag))
>  			goto err;
>  		head = *headbuf = frag;
> 
> ---
> base-commit: 0c20cb4cfb40cf270d6c4c2c2ff5e5d72322644a
> change-id: 20261015-nb-skb-unclone-full-dafb147b8aa9
> 
> Best regards,
> --
> Nicolai Buchwitz <nb@tipi-net.de>
