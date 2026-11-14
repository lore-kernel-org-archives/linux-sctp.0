Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794687465;
	b=XWK/l85L8VPQiPc/lRJoXO05CFpJ/l/BrqxhRI4S/SaswOE2jQeN/6/MjeVIfJfdsItE
	 o8ChCZozy5ydWnpcGSApH2GTDu1KiH98S+Ep5LoYSLyTAKKYastc5GgSD+vYfnEi+Elje
	 +xnw2dMkYqP0+h2ZT070x+prAXr5CUTl6+oS/TD+2+7HNt5E1ll31++JkWcsFdarDmNyn
	 eVHqxkPVwQWNAlyBFXRWcn0E4Qya0rN+FSBkx6y7s19g5geODnVVGH4cJ/06o1xwQzR4x
	 WAYX3T6pQBP9NWO3nvjdTSxz5dX/3BmqfonVxN+bM493EsVDgUOVJPxltbCbbTCckjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794687465;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=hwJZ69vicp6RFveDrtsinePrWwv3SffhCB8NelD+72Q=;
	b=twrpF6LSUzAkIvV2t72UqfG6bR7LW5d2c4B4tkTF8RCgEDE3L8f3sc/p6u9CCfZEa9qL
	 sjW+STUu/yKdEANHXMZJqIWA7G3EdPGF+ZgR1jqrWv6vgmsz6XAk/HGwAxHLp8Sstzdct
	 Pk1voGOb/DoutFllYWOLx9oZDif4xB7MO0a22vVqiDQ6j710YNI6OVcAXX7iR4Aav0j74
	 q5wDbcsczxuLYdqI/D1KREJd1hksBddAlOO6TlJbsGldfrWCdzN+MY/U/mYq/h1DC8XnL
	 UOwiAaK6on7KScjbBz5gKMOznybA5yhrUVw4YjQj06/zG5CV3Ef+6XIMWDXL85FjriA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DjLW68oR;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C75606A323
	for <linux-sctp@vger.kernel.org>; Sat, 14 Nov 2026 20:17:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77C75606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DjLW68oR
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-498f5fa4f70so2516197f8f.0
        for <linux-sctp@vger.kernel.org>; Sat, 14 Nov 2026 12:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794687464; x=1795292264; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hwJZ69vicp6RFveDrtsinePrWwv3SffhCB8NelD+72Q=;
        b=DjLW68oRhwkqA0PK2vF8zsRowzuA5L08dpWNALguxW+zv+saLzwh/HANv05JZ6fHX6
         RrnnMTp2MojzsfAkB+hjsNSBcpgorGtN904+kKRCOkK4gZbOMd4Lb+Xy99txirR3q9jO
         vSG8XQsAs0VTmluD7/YLWB11snxj04TrTjANo+Tp7uwT4cMa9NH6D+JAlVJoyxCbymRh
         lujzrTSGHh2knQ69H/n1n+85Li/XmJtwC3sp8CJjemjoMc/SIdQCNC+JOyWHmDSzBoW1
         4yaSnKhP82KDSLrARC09xUooAD5YEcqPtLJ6uaeByMLDJGUkBRQfG8TpmoIjeb6t6jcw
         4jbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794687464; x=1795292264;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hwJZ69vicp6RFveDrtsinePrWwv3SffhCB8NelD+72Q=;
        b=yiQpASrxOcigc8lE0HA+sqr3TsJ1U/Ir/hMHF4s8cLA+zGTVYXuiI4+Zen4W7Rj3A/
         YJcsey8KkkARn+Tr2xnG0qFktHoviigjwMZcqU/fPj8eTn4B7us9Q7R7HgQd5QaVI6sv
         h2eTxgTBq6VJhFt9+6XyTFxDrkCbGyoYl8htImAHw1FpErVbCZYDzkr3jWEE9R+kI9KJ
         GArbX1fFZyzBW7PSm1/cZxnM7eq/GMORq/mMPTtNqUtyPcsMwTpiUurBkdWNNnWTP7bx
         NlqzbG3Qcm9IgyM632ESezR1Wjg4M296GS4nK54YSvd9++rULmRo+kxlMdyFg6NB3OoW
         mjQg==
X-Forwarded-Encrypted: i=1; AL+hErGV9lnYuJEx0aX/ClUZjlZP204cqQQfDBwhO6Xfhx8/Ide6xOGm1co9+O8xLumGnr5R1t5IYDLho0MI@vger.kernel.org
X-Gm-Message-State: APuU4Z8S0U15m1ANRXHZex0fJsN4+z9gyqL7goAgIXqorn1/a/jpJzeV
	H1ogLTQxz/kUFQWHGQS9eWhlKWWp25smQf9DR8/OwXX/AfLmlMui7SMO
X-Gm-Gg: AYBFou3dPjjVuSCx4uPy6AVnJQMLqWUyik7CWz1ha8rIWnxzQx/Wl7WxhXIyseBa/ls
	1rD9tC3081YE3QM85aEYEDeCUiZ8Uel2//EOGOczSpdKdu+hh+YUuAUc+j4PuRVBGouoWFst/gP
	5JACUY7Jy4AaaWi2C0BffNN2joTZTXznkaq87LrNRsDe0PuFtQOojDXNriIekH4e24DeMvwJj/G
	YeAs13JnrXfry6x5tAOujPIpR7NEt27W6lKZBvbJtC9b3iLmj3o2uzw5+RplY0/9iIF30aH6UJV
	PSdrVmhVw4MZ9oSqBPLojVr26+0dmiUxkQQxk2vpandCh4XS7z01l4lTWmvlSDfeZsVkimYoz04
	arM+6/bPbEbuhKo21bw7uV4I/zlOzJE5CFFtqK6oZD2Fx6YSG5gdGIoGY33maWBT7ud+I2T6gqk
	KJoSpDco+PZkyoWCCn4KbZOzyvTJa3Zc0e8lzMmwjk7VNTxIF6p+1eAOwEYuy1k60pn/WWF7C/a
	K091lWXc8Dx1u/yP0/FLmcpXs4dlQskGXW/rxUJBX00rP49oeBSKCnktguvfhQWoFgPdDDE+AyI
	PJoghLSzI95YjbMPPOTAk6shkGZDReP2Il9PPvEs77UaAFOyVQRYIlC5yzl+bYZAlz3wCyt8nvU
	c9bw7FOQ=
X-Received: by 2002:a05:6000:178e:b0:48d:f488:f32a with SMTP id ffacd0b85a97d-49c73a0550fmr14049604f8f.56.1794687463516;
        Sat, 14 Nov 2026 12:17:43 -0800 (PST)
Received: from ?IPV6:2a02:a03f:a75e:9a00:a644:3b4b:4691:92a4? ([2a02:a03f:a75e:9a00:a644:3b4b:4691:92a4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c608c5debsm12226094f8f.42.2026.11.14.12.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 12:17:43 -0800 (PST)
Message-ID: <9a75d365-fff0-42b1-95fa-8907ed69106e@gmail.com>
Date: Sat, 14 Nov 2026 21:17:41 +0100
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
Subject: Re: [PATCH net 0/5] net: avoid truncated transport header offsets
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
 =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>,
 Sabrina Dubroca <sd@queasysnail.net>, Stefano Brivio <sbrivio@redhat.com>,
 Hyunwoo Kim <imv4bel@gmail.com>, netdev@vger.kernel.org,
 linux-sctp@vger.kernel.org, dev@openvswitch.org
References: <20261113124625.4010206-1-edumazet@kernel.org>
Content-Language: en-US
From: Justin Iurman <justin.iurman@gmail.com>
In-Reply-To: <20261113124625.4010206-1-edumazet@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 13:46, Eric Dumazet wrote:
> skb->transport_header is a 16-bit offset from skb->head, and U16_MAX
> is reserved as the "not set" value. skb_set_transport_header() silently
> truncates an offset that does not fit.
> 
> The first patch addresses the report from Hyunwoo Kim, by applying
> the IP6_MAX_EXT_HDRS_CNT limit to ipv6_gro_pull_exthdrs().
> 
> The four following patches convert places storing an offset derived
> from an IPv6 extension header walk to skb_set_transport_header_careful().
> A single chain being bounded to 24576 bytes, these need a large
> skb->data - skb->head to overflow, for instance after nested
> decapsulations. They are hardening, no reproducer was written.
> 
> The same change for nf_ct_frag6_gather() is sent separately to
> the netfilter tree.
> 
> Eric Dumazet (5):
>    ipv6: gro: limit the number of extension headers
>    ipv6: mcast: use skb_set_transport_header_careful() in
>      ipv6_mc_check_exthdrs()
>    net: openvswitch: use skb_set_transport_header_careful() in
>      parse_ipv6hdr()
>    sctp: use skb_set_transport_header_careful() in sctp_v6_err()
>    udp: use skb_set_transport_header_careful() in __udp6_lib_err_encap()
> 
>   net/ipv6/ip6_offload.c | 8 ++++++++
>   net/ipv6/mcast_snoop.c | 3 ++-
>   net/ipv6/udp.c         | 7 ++++---
>   net/openvswitch/flow.c | 3 ++-
>   net/sctp/ipv6.c        | 5 ++++-
>   5 files changed, 20 insertions(+), 6 deletions(-)

For the series:

Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
