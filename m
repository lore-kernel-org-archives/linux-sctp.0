Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049346;
	b=Pcra4mIboAa400R6xovhHYGmYaLADjPHKTfCsSxX4LTs+HqsoLXLH5FRbKoqOk5Dio2A
	 Q/I/ZKBdE1Jist7X7Xcg3LYJ+ajPDVQjUVgGfrtbqGl70KuD9nCduR9VF8+zR6z5sCa8g
	 wF5hYMbSdrFZoBqd4fsZP+73ik4jy/aHdtw9ATbfpKDqbesS/I57MlPTbTh9JX1tsmMDl
	 1RyzRsHi+HSe3dAs5jxHc4g7zPrDtihWc7s6qxyYQK0HUJU51VLerKZw4iqzrZO4TR33M
	 FSqfdA7b0yV25NrSBwmYkYXdkW9FWQP1pDvlL1aNppqjEgmilJj3DBzRGq3wqMj2+ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049346;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:From:To:Cc:Subject:In-Reply-To:References:Date:
	 Message-ID:User-Agent:MIME-Version:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=S65lyMMR1xE8IrA8zcxyTFGEF6srOPz5FeKYqMApl9g=;
	b=tpmSqj8StgqKKg6PLh1lB90M5boxPCCwdfJ3QSP5jwIWRvloaEuVMAvUkXwnWquiwgid
	 ybTJruRdIHGaAqjyeo71z4NTdM5xywOJv9qdy/OZfswQW3gniU8G6KMGmDWQ7EHhHZv6y
	 YcW5IzJ2M8NNiTfqQrI/qnG6Zw4IkHVKFgSiPmQOZxNZv4CxLo/4z7N60+qoEIB56Roia
	 JaMuhbfZPE8SvjHDfW8+mgxZmnz3Q4srv0D4AY6zBjdUQvO+QmA7SIk9p6WY5OEnyG8GE
	 RRfNEytONwBfg/KB57uo81Xf1+vqTFODGgZNR6r2ydY25n64r3YHsjk0i3aPdGeuHOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LnN7GAL+;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EFB606A320
	for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 00:49:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75EFB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LnN7GAL+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795049343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S65lyMMR1xE8IrA8zcxyTFGEF6srOPz5FeKYqMApl9g=;
	b=LnN7GAL+tvi5qBHyNXxxi+Dbpa0jwgIjbrDJYetD5ROdWphqgHscFdgVsMLYGqM/1Wca0V
	weqx0srGfqkU11WylG6xD+1udGJ9rXiJdBlv47uj9PdkHpMLUbDEkMAmf9PIL0rPBEFiXc
	1Gb3L1dtxoZuvMP/3RDPRvr3vpgJM6E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-iDyqU2LbMn-ZpBIpicL1Ww-1; Wed, 18 Nov 2026 19:49:00 -0500
X-MC-Unique: iDyqU2LbMn-ZpBIpicL1Ww-1
X-Mimecast-MFC-AGG-ID: iDyqU2LbMn-ZpBIpicL1Ww_1795049339
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a35db2d6b3so12121365e9.3
        for <linux-sctp@vger.kernel.org>; Wed, 18 Nov 2026 16:48:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795049339; x=1795654139;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=S65lyMMR1xE8IrA8zcxyTFGEF6srOPz5FeKYqMApl9g=;
        b=D1e/tYQBYd5M8XSE3ta2qxsv/jWloyYyjFyid5dAOPm/md184iYpi8Fv+C/5qQy/qA
         slQS4YDdkO2EV3adSm+CBKARCgtAXKzKqn3w4Ae1x72OxVkHNmLxbWj6LPkKcBPVkWh1
         lJPZrh4ge0QBtRwmi+fJxo5qmq7HfkOqE3vYbj4MIb4gH+dwaMJG1vBia7epIedKKwBJ
         PF9oQdIK69Y8uPBbcZ2LKlZlcCP4FRPLhV6Z8qcV22ZS7MfbxeKsgHdMilb3Kn9vKAaE
         Mv36xA0AgRTWGNETbRxxt6M+DZ1dJtuQGKNRbUXrQyy1moIB+cEZ/5TQANVKeYogslLP
         413A==
X-Forwarded-Encrypted: i=1; AL+hErFnCdBuAAKmSQMGZGV+mXxGzlxO4OYvSDLPI5newMDa5Ovcc62w09BvZLwY35QwvxpYfzHonuGlpe8A@vger.kernel.org
X-Gm-Message-State: APuU4Z8/cm5v9f1Cp0sVOH8ugwj/WPx15EKii+qUtQG8mTG0dtBgWNtg
	QFCShydoqLqETjpJ4Q62uiEqeXwzqQCxTjYu1GgTA47CTDWReg7Q7OSxP4k9Usxr+yZwY69h2MC
	zZb5Hf/EdjXnP3JISylTOEDUexU0bim6haFq4NUkO5SUrz8yUl+zuzgdsKo2iE3E=
X-Gm-Gg: AYBFou31LwwPrdhrym2D2QxHE195Omnass9hSKBeh+Qe6naktMcCN9P2RnPX2FL9jAh
	6hnnCS0S4RwNwpSfpDxE1ALr4kMxFoiPfglq5hfLDZIPws7dcfhFf4ktP1DK8nB0FIiE837Bnce
	MerrsqHddzPXDBXwVM0iTXxqx1O6o23OA67LYbxQu75IspwBM2BHujvRAkbb+ymj/JyXqmgOZQc
	9dSZzSmJGqY6QEypttSxvhkk3nDgoDp4FBQNe1yqZ8F0Q2E5tB/9U47hp26iDPUNN4KfDR8mVx8
	MKd7KvgXqbRTeP6ZJzE4lUMUAd9nB4mAOKQe0jB6x0/+LMsik28RuInC2EJAAE1cUrJhFTafNAK
	y9Xo1NUvMWvJFNN6CSNqf2uAIuTYMcaCmtxCLZIvgYSB39UDP9RZyhVGHdZQlEfkIUTU/HGPHaf
	UClUo=
X-Received: by 2002:a05:600c:4ec7:b0:49f:fd2d:23c7 with SMTP id 5b1f17b1804b1-4bb7da3b3e8mr86398865e9.27.1795049338992;
        Wed, 18 Nov 2026 16:48:58 -0800 (PST)
X-Received: by 2002:a05:600c:4ec7:b0:49f:fd2d:23c7 with SMTP id 5b1f17b1804b1-4bb7da3b3e8mr86398765e9.27.1795049338658;
        Wed, 18 Nov 2026 16:48:58 -0800 (PST)
Received: from aconole-thinkpadt14gen4.rmtusnh.csb ([216.212.39.190])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8450fa2csm10795485e9.7.2026.11.18.16.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 16:48:58 -0800 (PST)
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
Subject: Re: [PATCH net 1/5] ipv6: gro: limit the number of extension headers
In-Reply-To: <20261113124625.4010206-2-edumazet@kernel.org> (Eric Dumazet's
	message of "Fri, 13 Nov 2026 13:46:21 +0100")
References: <20261113124625.4010206-1-edumazet@kernel.org>
	<20261113124625.4010206-2-edumazet@kernel.org>
Date: Wed, 18 Nov 2026 19:48:54 -0500
Message-ID: <f7tfqwxk5mx.fsf@aconole-thinkpadt14gen4.rmtusnh.csb>
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
X-Mimecast-MFC-PROC-ID: FYayuS_EYd9n-xHSIOAe3DbIkc8X0ucy2WQfAbFWENs_1795049339
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Eric Dumazet <edumazet@kernel.org> writes:

> Hyunwoo Kim reported that a long chain of IPv6 extension headers
> can push the transport header offset of a GRO packet beyond what
> the 16-bit skb->transport_header can store. The truncated offset
> is later used by gro_receive_network_flush() to locate the network
> header of a packet held in the GRO list, leading to an out-of-bounds
> read.
>
> Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
> parsing"), ip6_protocol_deliver_rcu() drops packets carrying more than
> IP6_MAX_EXT_HDRS_CNT extension headers, but ipv6_gro_pull_exthdrs()
> was left unbounded.
>
> There is no point trying to aggregate packets that the stack is going
> to drop anyway if they are locally delivered. Apply the same limit in
> ipv6_gro_pull_exthdrs().
>
> When the limit is hit, @proto still designates an extension header.
> Extension header offloads have no gro_receive() callback, so
> ipv6_gro_receive() takes its existing "goto out" path with flush set,
> and the packet is given to the normal receive path. Local delivery
> drops it with SKB_DROP_REASON_IPV6_TOO_MANY_EXTHDRS, while forwarded
> packets are simply not aggregated.
>
> An extension header being at most 2048 bytes, this bounds a chain
> to 24576 bytes.
>
> Note that offsets can still accumulate over nested encapsulations,
> so the places storing them should be hardened separately.
>
> Fixes: 4b0ebbca3e16 ("net: gro: move L3 flush checks to tcp_gro_receive and udp_gro_receive_segment")
> Cc: stable@vger.kernel.org
> Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
> Link: https://lore.kernel.org/netdev/avTTQNyvwPP6LtGx@v4bel/
> Signed-off-by: Eric Dumazet <edumazet@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Ido Schimmel <idosch@nvidia.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

