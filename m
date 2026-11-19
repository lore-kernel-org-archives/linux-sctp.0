Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049333;
	b=gp/dIlh5FdDMAxgu4hAmg0CID8xv76zewlhXp+JH8IsitW8n1eNFzATIcwYlzrTf5wE6
	 j0ksV9BlkEmQq7GcWRS9NXf/dFBySvFcADHi899uipK/g0Yv9IxRCYd0pOKEiIiPbcap8
	 tVrt6sjiHabm9ijaM94E+ZIMB7N5hUn8fu52Ik3uAbet5qr/Xb33LjNmHTHuBkjwG6RuY
	 ZnPdZyUIRmvVXTi+BTOwyfoMJ85S5nsmcGtjHubgJfYt00rEllzGAMJb/p3BIvTqv8fYV
	 lu21et8hSM2p2wFzGQREl8wcm4/3mUNrEblgSrphFABHlMmIMB52NGYzJeYvAcB8Omw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049333;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:From:To:Cc:Subject:In-Reply-To:References:Date:
	 Message-ID:User-Agent:MIME-Version:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=4UH4MuHKqQSdHfWzmTuo+LVB7QPfsbG6UhR9RvJMQ7U=;
	b=tfnjQshFiLqtC4OkSrbqYhFI9APbc9IxFH4KmFas/mFpMN3lqzVyZw9o6zNlWUtjkKCb
	 xMljn3lWnjyDuqutxkXrRfZsXuOGLJaE8YBEmhtxe+1/JYjeJ4KKIqnQQUr7ZIzqKWvv0
	 /89u4mc7+HjhYhK3csxnTI4idCnTg7F6d88yJcE1tLljJxOuZEBSGBTg8UX1v2M1rujFX
	 HFMwJzRsYtJ/XwVVzsgDjxRSji5UENhU8tM9/wgzDd4GLZ9Xf6h6MtJMEDWjciHskfpSE
	 MaULv60cZ8mf1rpZBns0ip1zLDyURVKyJLyneiEDKlDj7nYol0pQBJEAy+l/pFTdGFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Rq4ig2Iq;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FC360A2604
	for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 00:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3FC360A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Rq4ig2Iq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795049329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4UH4MuHKqQSdHfWzmTuo+LVB7QPfsbG6UhR9RvJMQ7U=;
	b=Rq4ig2IqXBN5XKSJH9BsTHm3faDM0V6z7nYZyzX+AomEocAZesmcxEghD6rS/RTX1pwsb2
	fwds2dqBoXjpjCnEUi6tDzPxAiMopvo9ypFnxqodo1Mjd9x/A6Qqv/+kIXQISaKc/+OqSe
	skYsPBOTC2EWvGIPXu6UhHF2Qv8yGmE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-lnS2uv-5NfazI3sbje0ooA-1; Wed, 18 Nov 2026 19:48:48 -0500
X-MC-Unique: lnS2uv-5NfazI3sbje0ooA-1
X-Mimecast-MFC-AGG-ID: lnS2uv-5NfazI3sbje0ooA_1795049327
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-49d70f45b22so995908f8f.2
        for <linux-sctp@vger.kernel.org>; Wed, 18 Nov 2026 16:48:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795049327; x=1795654127;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4UH4MuHKqQSdHfWzmTuo+LVB7QPfsbG6UhR9RvJMQ7U=;
        b=QnDhgXvwAnZ7GPOgA0kUCq7f/M4vQ+xrNzcNXLX1Nr6M245P09cZz/QiCbZ7oQ2Z2Z
         Esqbta3wNf+CYFpSXIE7M8+17CiQCg61VZHnozWHlD+F5+F8IYwIckdIm+03g4/UjpYR
         LMXcoKqT81970pHQSHOMCsL4mA+bQ8+MJ/qTrkkQy7phD8Lg8sKiFXGFGZqU4Jj4XTEJ
         Di8heg3/65axVIGYmbEkc+PoPOoCzNWIqlP0IyKXizAlANO4Lqxtuo2nQ52VcxMcpvk+
         FJR8deN6s55D0WI9d6hePLp0NNoOlZympiFBi+rOGAhTiVSaYFUVX+GL5RPH3C95OU4o
         +Ryg==
X-Forwarded-Encrypted: i=1; AL+hErHQd5Kq8hpOIz6qNDRvSZLMqAXSjzz+9v+N1Me6XsxGCYBTCamkhsRM66AcmtrKiBhW8HRE427qbnqg@vger.kernel.org
X-Gm-Message-State: APuU4Z8YKYLnDk1O5RUsmt0045OEWlEtePyF6DOLLksvS3yTPhQX7fGR
	D+3F4Ssgj4+Utg/4vIu52TnmPWBrH6sldiA1vEuNqqr0NBReJOKXM5nkP5IMl5Z1CABtTMxPNfk
	TxHn+K0i8y4wyarshlA0Z9AVN05QOOe8PUm88l8K1hlLtLn4oCZFWRX2OpuSOv6A1zm1HnmE=
X-Gm-Gg: AYBFou0RePDRqO+/MaUVegDWb3Yb4Td2K8uoRHvKR9CDKuqlbjsZGsVt8ePmY1b8bUx
	J9KNVgRAKi2eodC719XBJKw5Uy3G9AXZDgl0IR+x5+JBomlEBrJRyTNYVay0MZ0DMEtE81y8vYu
	k4aOtait8zxwV1T8WUuCXkJPHqX+mLEVu41BTXOyf3f8/hzLZUvgwEXu+1cSaaRTvh4TOniNOha
	fJrFUx9gems2lDm1BMyXbFvave2Xcmk/eywK+R2hYBUdxyTRx4A7weXR2wJHwB/SlNNNYVdTUsg
	3UL3296DLytC4Llv/Q6YEXv8mNaeP5g75PS3PRc/pgYGbzuqnvd1s1Wfh76PYg5w6ZgizHNdjUt
	BcfJYhZqies8/yCtr4MjJPOmatpn8gzvVp+Yb74+JoMJd69Nqw0jQy6L8M51KzJMrHACGzYQkHT
	iBgJE=
X-Received: by 2002:a05:600c:4e93:b0:4a4:4d57:8487 with SMTP id 5b1f17b1804b1-4bb7da138f5mr88386095e9.5.1795049327523;
        Wed, 18 Nov 2026 16:48:47 -0800 (PST)
X-Received: by 2002:a05:600c:4e93:b0:4a4:4d57:8487 with SMTP id 5b1f17b1804b1-4bb7da138f5mr88385915e9.5.1795049327215;
        Wed, 18 Nov 2026 16:48:47 -0800 (PST)
Received: from aconole-thinkpadt14gen4.rmtusnh.csb ([216.212.39.190])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8450fa2csm10785465e9.7.2026.11.18.16.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 16:48:46 -0800 (PST)
From: Aaron Conole <aconole@redhat.com>
To: Eric Dumazet <edumazet@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,  Jakub Kicinski
 <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  Simon Horman
 <horms@kernel.org>,  David Ahern <dsahern@kernel.org>,  Ido Schimmel
 <idosch@nvidia.com>,  Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
  Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,  Xin Long
 <lucien.xin@gmail.com>,  Eelco Chaudron <echaudro@redhat.com>,  Ilya
 Maximets <i.maximets@ovn.org>,  Daniel Borkmann <daniel@iogearbox.net>,
  Justin Iurman <justin.iurman@gmail.com>,  Linus =?utf-8?Q?L=C3=BCssing?=
 <linus.luessing@c0d3.blue>,  Sabrina Dubroca <sd@queasysnail.net>,
  Stefano Brivio <sbrivio@redhat.com>,  Hyunwoo Kim <imv4bel@gmail.com>,
  netdev@vger.kernel.org,  linux-sctp@vger.kernel.org,
  dev@openvswitch.org,  stable@vger.kernel.org
Subject: Re: [PATCH net 3/5] net: openvswitch: use
 skb_set_transport_header_careful() in parse_ipv6hdr()
In-Reply-To: <20261113124625.4010206-4-edumazet@kernel.org> (Eric Dumazet's
	message of "Fri, 13 Nov 2026 13:46:23 +0100")
References: <20261113124625.4010206-1-edumazet@kernel.org>
	<20261113124625.4010206-4-edumazet@kernel.org>
Date: Wed, 18 Nov 2026 19:48:42 -0500
Message-ID: <f7th5hdk5n9.fsf@aconole-thinkpadt14gen4.rmtusnh.csb>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MtYSPbF8lzUhPsJIZFM8E5K1Y57xbSVZ5ezh2wltMYg_1795049327
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Eric Dumazet <edumazet@kernel.org> writes:

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

Reviewed-by: Aaron Conole <aconole@redhat.com>

