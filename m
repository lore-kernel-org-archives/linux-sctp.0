From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 23 Dec 2019 17:49:04 +0000
Subject: Re: SCTP over GRE (w csum)
Message-Id: <20191223174904.GL4444@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191223174535.GF6274@localhost.localdomain>
In-Reply-To: <20191223174535.GF6274@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: netdev@vger.kernel.org, dcaratti@redhat.com, lucien.xin@gmail.com, linux-sctp@vger.kernel.org

[ Just Cc-ing linux-sctp@ ]

On Mon, Dec 23, 2019 at 06:45:35PM +0100, Lorenzo Bianconi wrote:
> Hi all,
> 
> I am currently working on the following scenario:
> 
> sctp --> ipv4 --> gretap --> ipv6 --> eth
> 
> If NETIF_F_SCTP_CRC is not supported by the network device (it is the
> case for gre), sctp will fallback computing the crc32 in sw with
> sctp_gso_make_checksum(), where SKB_GSO_CB(skb)->csum is set to ~0 by
> gso_reset_checksum(). After the gso segmentation, gre_gso_segment()
> will try to compute gre csum with gso_make_checksum() even if skb->ip_summed
> is set to CHECKSUM_NONE (and so using ~0 as partial).
> One possible (trivial and not tested) solution would be to recompute the
> gre checksum, doing in gre_gso_segment() something like:
> 
> 	if (skb->ip_summed = CHECKSUM_NONE) {
> 		...
> 		err = skb_checksum_help(skb);
> 		if (err < 0)
> 			return return ERR_PTR(err);
> 	} else {
> 		*pcsum = gso_make_checksum(skb, 0);
> 	}
> 
> One possible improvement would be offload the GRE checksum computation if the
> hw exports this capability in netdev_features and fall back to the sw
> implementation if not.
> Am I missing something? Is there a better approach?
> 
> Regards,
> Lorenzo
