From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 20 Feb 2013 16:38:58 +0000
Subject: Re: [PATCH 2/3] sctp: fix association hangs due to reassembly/ordering logic
Message-Id: <5124FC22.2090706@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1361374925.3450.2.camel@laptop.lroberts> <D64EC45690EF85409BA6C4730E0162244310CBB5@G4W3231.americas.hpqcorp.net>
In-Reply-To: <D64EC45690EF85409BA6C4730E0162244310CBB5@G4W3231.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: "Roberts, Lee A." <lee.roberts@hp.com>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 02/20/2013 10:55 AM, Roberts, Lee A. wrote:
> From: Lee A. Roberts <lee.roberts@hp.com>
>
> Resolve SCTP association hangs observed during SCTP stress
> testing.  Observable symptoms include communications hangs
> with data being held in the association reassembly and/or lobby
> (ordering) queues.  Close examination of reassembly queue shows
> missing packets.
>
> In sctp_ulpq_renege_list(), do not renege packets below the
> cumulative TSN ACK point.  Events being reneged from the
> ordering queue may correspond to multiple TSNs; identify
> and renege all affected packets from the tsnmap.
>
> Patch applies to linux-3.8 kernel.
>
> Signed-off-by: Lee A. Roberts <lee.roberts@hp.com>
> ---
>   net/sctp/ulpqueue.c |   30 +++++++++++++++++++++++++-----
>   1 file changed, 25 insertions(+), 5 deletions(-)
>
> diff -uprN -X linux-3.8-vanilla/Documentation/dontdiff linux-3.8-SCTP
> +1/net/sctp/ulpqueue.c linux-3.8-SCTP+2/net/sctp/ulpqueue.c
> --- linux-3.8-SCTP+1/net/sctp/ulpqueue.c	2013-02-18 16:58:34.000000000
> -0700
> +++ linux-3.8-SCTP+2/net/sctp/ulpqueue.c	2013-02-20 08:17:53.679233365
> -0700
> @@ -962,20 +962,40 @@ static __u16 sctp_ulpq_renege_list(struc
>   		struct sk_buff_head *list, __u16 needed)
>   {
>   	__u16 freed = 0;
> -	__u32 tsn;
> -	struct sk_buff *skb;
> +	__u32 tsn, last_tsn;
> +	struct sk_buff *skb, *flist, *last;
>   	struct sctp_ulpevent *event;
>   	struct sctp_tsnmap *tsnmap;
>
>   	tsnmap = &ulpq->asoc->peer.tsn_map;
>
> -	while ((skb = __skb_dequeue_tail(list)) != NULL) {
> -		freed += skb_headlen(skb);
> +	while ((skb = skb_peek_tail(list)) != NULL) {
>   		event = sctp_skb2event(skb);
>   		tsn = event->tsn;
>
> +		/* Don't renege below the Cumulative TSN ACK Point. */
> +		if (TSN_lte(tsn, sctp_tsnmap_get_ctsn(tsnmap)))
> +			break;
> +
> +		/* Events in ordering queue may have multiple fragments
> +		 * corresponding to additional TSNs.  Find the last one.
> +		 */
> +		flist = skb_shinfo(skb)->frag_list;
> +		for (last = flist; flist; flist = flist->next)
> +			last = flist;
> +		if (last)
> +			last_tsn = sctp_skb2event(last)->tsn;
> +		else
> +			last_tsn = tsn;
> +
> +		/* Unlink the event, then renege all applicable TSNs. */
> +		__skb_unlink(skb, list);
> +		freed += skb_headlen(skb);


This is no longer correct.  You are actually freeing more space if you 
are reneging a reassembled event from the the ordered queue.

Please separate the 2 patches since they fix 2 distinct bugs.

Thanks
-vlad

>   		sctp_ulpevent_free(event);
> -		sctp_tsnmap_renege(tsnmap, tsn);
> +		while (TSN_lte(tsn, last_tsn)) {
> +			sctp_tsnmap_renege(tsnmap, tsn);
> +			tsn++;
> +		}
>   		if (freed >= needed)
>   			return freed;
>   	}
>
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���i�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+��ݢj"��!tml>

