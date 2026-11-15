Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794753631;
	b=17wrBnNuNtV3TkAj1yi5Upho2gWFINUoR0fJYpuazcpJumyZ6LJpPvUeOi56kFmslOhV
	 +teIHXp0v+sjFQWbtvgSnwMGuGEmhGdMmU/BXstO6h7IicBWo6eOsC3R/uQAiUMRlngfW
	 LRVf0y8vVD8RT3fgrgnQsAjScPnud5QWhDjq26U0ERNSSihBfaIPLBYdBjz3O4RRewQEM
	 1pK6XTmpa8wWl2NUGJEN8XbLeRnbUrWW3n936gQxpBd32Ic/uX7LZF++3F/mW7RtvZhnY
	 hn3xWIUc7wQxqwl8N6SN07ieamkAK+Ln/9r8ETYNZk66o2jLoVDsxMxGAo3rgxUif1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794753631;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:From:To:Cc:Subject:Message-ID:In-Reply-To:
	 References:Organization:X-Mailer:MIME-Version:Date:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Transfer-Encoding;
	bh=1bihxelyVft2t/5mQ9f11F3fi1jsaO8+e8OfSOmmVx4=;
	b=c4cCxEs71js14tFOJWmJ0uuqPqDWl49UG0PdjrVv66VKKH/bvG4+wTkzUsmsVP0B3Ul+
	 Z7CAVA8iVngtg3cp/ui8UWATng0CR8ud4kriTBHWrHNWfLQb2tfkfdmTa/XpLNPgsL8pS
	 B12EDd2hB0vP08aEWebUmRKzHcNwbf8biUqiH3w0LPHi9IiChwuc14duMoMdWZPdQrU4a
	 HPgNSHEVGI8HwZweZ0OdlG99cIO1LlKFdTm0vI4iBsMGq0WCTDDNrXesPJVjFPp8y3Wiq
	 VEYmPx1mS+bT+Eysubo/bUc/v8Vk6D19Q/HpzmC0o45Sxi/PHEn1XL4dE1MCEHsn8AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b+sEoWtI;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC51606A334
	for <linux-sctp@vger.kernel.org>; Sun, 15 Nov 2026 14:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FC51606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b+sEoWtI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794753629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1bihxelyVft2t/5mQ9f11F3fi1jsaO8+e8OfSOmmVx4=;
	b=b+sEoWtI3YPxeWc19Rqv41UMQds3/kBhw9qdmFvnCBeEf8+zYq2o+fbalp9KTjc46UgLIv
	RwIFmUY8vjH+vjgttgKiiNYdve9PqNG2cJuDpAuR/M8XukvZ4dHj6pf2yZpY3SA5KdCRLo
	d6RwFrWykbHbM3rt9012N/Zh5A/huig=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-tCb0X2XpPG2wz6GgdgG7xg-1; Sun, 15 Nov 2026 09:40:28 -0500
X-MC-Unique: tCb0X2XpPG2wz6GgdgG7xg-1
X-Mimecast-MFC-AGG-ID: tCb0X2XpPG2wz6GgdgG7xg_1794753627
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4bb68a5e792so2747185e9.0
        for <linux-sctp@vger.kernel.org>; Sun, 15 Nov 2026 06:40:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794753627; x=1795358427;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1bihxelyVft2t/5mQ9f11F3fi1jsaO8+e8OfSOmmVx4=;
        b=cNHoAOr8+L+K1Yb85siF9SbmsVnkfSDMa7GByTSNzsgGQiGaaQGDgSfzPwbK0oXSdM
         D7VIfiabIFgDFpqrDXZfzgWmM8ktB6vuYicO2bz4cM7vYwqGqe2LDne6jcplEdJJRySN
         b60OCNyGj6fxjvnGt2RUKZ2JQI6s8LXHlaPq/EBFZqo5nQtYFuSVSq0L9+6+2BmwXaEz
         A8lTGhcrMQFmddnBoZUpdH/1QL5SaQ6nIDpWr0jw1sYnQLNU40h+ftABlWhGjRfftpJq
         Z27hcFN3mgri3Y8TGImzGxJuQXagZvZUTfACLdcMuB7pC06w/m5ICgFc5KIVx7WgAoM/
         TG0Q==
X-Forwarded-Encrypted: i=1; AL+hErHR0R0zLvmzIYIp8zpQ8tC8gX5uxzm0lISD8enqlvi3jXvn47wAJ9gBqjUdeapYrkHW9o6oy2hFEMO2@vger.kernel.org
X-Gm-Message-State: APuU4Z9TfuJ+tK94LUzpv52ppC5iVJS7Gm/dJkJxY+IGwoFxewbaazAh
	Q1wwpfNxF10JnQpwyoiMgkwufRP5Nw2NZvV20RH/3CLb0aLqF3LfFYSRl47lJG+Kg6UB6U1M4UA
	hOhTq95O71Uy/UT0C4mjLo6btjCyW7zeATnXSXLAaGJQ/oCcJDZY4yFvRabLDuDo=
X-Gm-Gg: AYBFou1Wc11QjFh7E3ZQs86TaOWkt0kY82txNPOjHNWXR6frDh96pg4mW/1mk3iXC9/
	twkMfxUW9J0vHPhSKh9nL5WZ86tegx6BeaofRFbtu9k0GYokM/p2H8ryrqBS7xKu2dqH1BJbsm3
	Z2JVN7addvLj1GvPfi7sNOP6sjRx02+BNfkd3nL3W97/whLqYOpKF3WIbGfwKLYjHcDdXRV48WO
	tOd8E+sH0sOi55DyLR42Hca/vR0nB0+peypQYP+1AmP7lLEeLz9z27VHjd4dMFpqqfBUF6/FBri
	wkwXm/xwal07ljj22zFTN4kwFg/h/GgCU5yuri9YAIWw3wHz/EwUD7PW1LTmEDBWjzH0gfycnJq
	szgH5Ic88eNFSHmmdFllgqmXV9x2DIfTQuDAEhAgRUgZ5W7nSepQZ0fCi+tlbAeZRV/U=
X-Received: by 2002:a05:600c:2784:b0:4a1:d49e:9ce with SMTP id 5b1f17b1804b1-4bb4e2918b1mr215622675e9.2.1794753626897;
        Sun, 15 Nov 2026 06:40:26 -0800 (PST)
X-Received: by 2002:a05:600c:2784:b0:4a1:d49e:9ce with SMTP id 5b1f17b1804b1-4bb4e2918b1mr215622085e9.2.1794753626265;
        Sun, 15 Nov 2026 06:40:26 -0800 (PST)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5d223b21sm18628968f8f.2.2026.11.15.06.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 06:40:25 -0800 (PST)
From: Stefano Brivio <sbrivio@redhat.com>
To: Eric Dumazet <edumazet@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, David Ahern <dsahern@kernel.org>, Ido Schimmel
 <idosch@nvidia.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, Aaron Conole <aconole@redhat.com>, Eelco Chaudron
 <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Justin Iurman <justin.iurman@gmail.com>, Linus
 =?UTF-8?B?TMO8c3Npbmc=?= <linus.luessing@c0d3.blue>, Sabrina Dubroca
 <sd@queasysnail.net>, Hyunwoo Kim <imv4bel@gmail.com>,
 netdev@vger.kernel.org, linux-sctp@vger.kernel.org, dev@openvswitch.org,
 stable@vger.kernel.org
Subject: Re: [PATCH net 5/5] udp: use skb_set_transport_header_careful() in
 __udp6_lib_err_encap()
Message-ID: <20261115154023.41187779@elisabeth>
In-Reply-To: <20261113124625.4010206-6-edumazet@kernel.org>
References: <20261113124625.4010206-1-edumazet@kernel.org>
	<20261113124625.4010206-6-edumazet@kernel.org>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sun, 15 Nov 2026 15:40:24 +0100 (CET)
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7OBk5n_NFxHMcPO8rgMAIxnmxJ6QgJ0sdSqFAxaWEXk_1794753627
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 13 Nov 2026 13:46:25 +0100
Eric Dumazet <edumazet@kernel.org> wrote:

> skb->transport_header is a 16-bit offset from skb->head, and U16_MAX is
> reserved as the "not set" value. skb_set_transport_header() silently
> truncates an offset that does not fit.
> 
> __udp6_lib_err_encap() stores @offset, computed by icmpv6_notify() from
> the extension headers of the packet embedded in an ICMPv6 error. Should
> the value be truncated, the tunnel encap_err_lookup() and err_handler()
> callbacks would read the UDP header at the wrong place.
> 
> Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
> parsing") a single chain is bounded to IP6_MAX_EXT_HDRS_CNT headers
> (24576 bytes), so this needs a large skb->data - skb->head on top of it,
> for instance after several nested decapsulations, each of them possibly
> pulling its own extension header chain, since @offset is relative to
> the IPv6 header embedded in the ICMPv6 error. No reproducer was written,
> this is hardening.
> 
> Use skb_set_transport_header_careful() and return an error if the
> offset can not be stored, in which case udpv6_err() ignores the
> ICMPv6 error. Do this before changing the network header, so that
> nothing has to be restored on failure.

Right, we can't call __udp6_lib_err_encap_no_sk() anyway in that case.

> Fixes: a36e185e8c85 ("udp: Handle ICMP errors for tunnels with same destination port on both endpoints")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Dumazet <edumazet@kernel.org>

Thanks for fixing this.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

