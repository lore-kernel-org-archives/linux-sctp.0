Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=121.127.44.66
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044633;
	b=nRLtxXyNUbcTYY05JxfC54mxRBK85WpxK0aicKRfmIizwemMLQA7b4XIbrhWbPVhfz4a
	 dD21twPAMN7tA+JaowrS/BSNqT2Kbne0mEVg4Xody28Hw3bKpqUDwdxnQYUbocSZffiZ0
	 bC+SQvdd/r/owo8V5l4ocXnai7a8n4YhuAd0NX/4eZt8ZfyQX/3V6VartMTfC8+zAsnBg
	 MNVcIIe19zwQwTpI5DWKAfcDrw8VUpFZk197t1XKmWdYow/SS6zUwBmFyLMMo9T1RiC29
	 zCVTk9BllpZQoG2XYbkVOmrkdPGwvTRCg2YRBVyjgu+t3BmjbabE0u6ASxBNv38a7BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044633;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:CFBL-Feedback-ID:
	 CFBL-Address:X-Forward-Email-ID:X-Forward-Email-Sender:
	 X-Forward-Email-Version:X-Forward-Email-Website:X-Complaints-To:
	 X-Report-Abuse:X-Report-Abuse-To:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=T5ei+rTyspl12UphSZDGCB/Ii5iXsqWblenPmKyEJ/I=;
	b=1pUtyEnH1XIuxmeuUPNYl5hWnDH7Pf4J4mfL1Xurx0AC5RSC5zeiPm+q3+q/NO/oYPLL
	 tAeKvwZOhvWXYh4UoGaQjkqtxDjdMo70AN0sw7+y8bJAaQv3Ltaf05Yye9IuYr34+H8r/
	 Z1u6hYnI0raewhNFV5ETrUV/mtRBtTdPOo9q4DI9l9E9UPjKGT9Df8fOEXp1a1+i6cJ4/
	 8/09yUPlTrUUkSilvdtM1sPdm5oWv4Iuk0dM6oaATbDR/+4ZLFhtIvzcN84XC5xlfZa2a
	 cAYC9kFFWFFJMyBEd7sf+pQ3dHY3unNNbaWzgK5v6KNKeh1ngtcocO8uEt3DHPtd8PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ovn.org;
	spf=pass smtp.mailfrom=fe-bounces.ovn.org;
	dkim=pass header.d=ovn.org header.i=@ovn.org header.a=rsa-sha256 header.s=fe-13eddc7e57 header.b=RNj0eL1V;
	dkim=pass header.d=forwardemail.net header.i=@forwardemail.net header.a=rsa-sha256 header.s=default header.b=MUP2+Hkp;
	arc=none smtp.remote-ip=121.127.44.66
Received: from smtp.forwardemail.net (smtp.forwardemail.net [121.127.44.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A3A60A2611
	for <linux-sctp@vger.kernel.org>; Wed, 18 Nov 2026 23:30:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9A3A60A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.ovn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ovn.org header.i=@ovn.org header.a=rsa-sha256 header.s=fe-13eddc7e57 header.b=RNj0eL1V;
	dkim=pass (1024-bit key) header.d=forwardemail.net header.i=@forwardemail.net header.a=rsa-sha256 header.s=default header.b=MUP2+Hkp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ovn.org;
 h=Content-Transfer-Encoding: Content-Type: In-Reply-To: Autocrypt: From:
 Content-Language: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: CFBL-Address: CFBL-Feedback-ID; q=dns/txt; s=fe-13eddc7e57;
 t=1795044632; bh=T5ei+rTyspl12UphSZDGCB/Ii5iXsqWblenPmKyEJ/I=;
 b=RNj0eL1VsYqdVwhSjrs6zNsPzeQq52XfS1ZAhnnFUH60Pt6RjzsnuUT/rxf3vn8FkJmNRCVtX
 09mX6bddMZWC9hTg8n+F2R935ikR5IaYid1POXFQ81nj9c8UjcBIPs7IhSqsNw0GCQ4pdX/26HW
 PjEXpSd3ab4j3K+S0yIfChk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=forwardemail.net;
 h=Content-Transfer-Encoding: Content-Type: In-Reply-To: Autocrypt: From:
 Content-Language: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: CFBL-Address: CFBL-Feedback-ID; q=dns/txt; s=default;
 t=1795044632; bh=T5ei+rTyspl12UphSZDGCB/Ii5iXsqWblenPmKyEJ/I=;
 b=MUP2+HkpCckKA6eQNN0/xVkl8WG7GNsvMd0ecPHXjxRIF6m4Du+aI0yOipLWd4S13F5ZDuTcI
 GwByijQYDi98E5u8CEHvNr2EHhI0gYld2qd9GX/LJKUivuFopqP8NkuKp4XmrDnlnyg448XsoHd
 Bfqx/YLVq2vFIK8y6ww/GXM=
CFBL-Feedback-ID: 6afe350ec76be1cb82abe42e:f3a1cd2deda071716b7988e65b87f544
CFBL-Address: abuse@forwardemail.net; report=arf
X-Forward-Email-ID: 6afe350ec76be1cb82abe42e
X-Forward-Email-Sender: rfc822; i.maximets@ovn.org, smtp.forwardemail.net,
 121.127.44.66
X-Forward-Email-Version: 2.19.33
X-Forward-Email-Website: https://forwardemail.net
X-Complaints-To: abuse@forwardemail.net
X-Report-Abuse: abuse@forwardemail.net
X-Report-Abuse-To: abuse@forwardemail.net
Message-ID: <53e641d2-1ffa-46dd-abb4-033dbe344b45@ovn.org>
Date: Thu, 19 Nov 2026 00:30:15 +0100
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 3/5] net: openvswitch: use
 skb_set_transport_header_careful() in parse_ipv6hdr()
To: Eric Dumazet <edumazet@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Aaron Conole <aconole@redhat.com>,
 Eelco Chaudron <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Justin Iurman <justin.iurman@gmail.com>,
 =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>,
 Sabrina Dubroca <sd@queasysnail.net>, Stefano Brivio <sbrivio@redhat.com>,
 Hyunwoo Kim <imv4bel@gmail.com>, netdev@vger.kernel.org,
 linux-sctp@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
References: <20261113124625.4010206-1-edumazet@kernel.org>
 <20261113124625.4010206-4-edumazet@kernel.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <20261113124625.4010206-4-edumazet@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/26 1:46 PM, Eric Dumazet wrote:
> skb->transport_header is a 16-bit offset from skb->head, and U16_MAX is
> reserved as the "not set" value. skb_set_transport_header() silently
> truncates an offset that does not fit.
> 
> parse_ipv6hdr() stores the payload offset found by ipv6_find_hdr(),
> which depends on the extension headers found in the packet. Should the
> value be truncated, key_extract_l3l4() would parse the L4 header at the
> wrong place.
> 
> Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
> parsing") a single chain is bounded to IP6_MAX_EXT_HDRS_CNT headers
> (24576 bytes), so this needs a large skb->data - skb->head on top of it,
> for instance after several nested decapsulations, each of them possibly
> pulling its own extension header chain. No reproducer was written,
> this is hardening.
> 
> Use skb_set_transport_header_careful() and return -EPROTO if the offset
> can not be stored. As for other ipv6_find_hdr() failures, the caller
> then sets the transport header to the network header and does not
> parse L4. While at it, use payload_ofs directly, since
> nh_ofs + nh_len == payload_ofs.
> 
> Fixes: 1a37e412a022 ("net: Use 16bits for *_headers fields of struct skbuff")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Dumazet <edumazet@kernel.org>
> ---
>  net/openvswitch/flow.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> index 3734416b518d..5fbeb0cca9dc 100644
> --- a/net/openvswitch/flow.c
> +++ b/net/openvswitch/flow.c
> @@ -438,7 +438,8 @@ static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
>  		return -EPROTO;
>  
>  	nh_len = payload_ofs - nh_ofs;
> -	skb_set_transport_header(skb, nh_ofs + nh_len);
> +	if (unlikely(!skb_set_transport_header_careful(skb, payload_ofs)))
> +		return -EPROTO;
>  	key->ip.proto = nexthdr;
>  	return nh_len;
>  }

We don't really need the nh_len variable anymore in this function, but I guess
it can be used as sort of a documentation for what the function is returning.
So, it's OK to keep.

Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
