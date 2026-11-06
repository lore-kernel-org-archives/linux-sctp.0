Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793982051;
	b=cca4iETKeoOe4VocavcKqRWksPcpjCBvoEDtS2ZC3W+XRAJ2JBW5cSNiqAPWgq8sCkml
	 uSvzcxzhtaqmPU/NvmpPbiVXELBs5HMvyDttT1GQ1QtLYWvILzj+D+MYZvyhkgjBauXfk
	 KcQ3M3c7FhAwZwAFx3Jn/sxcdlX/Huytyr4y/d+QkqJGv9uoJamsbicf2/+CQmtP3lTbw
	 KZqDrgCrWji5k/Nn+AAWmcdDlCecxrUooLZ5/tAB+eENJLNWM4ndsCPEBECB3VPemso5B
	 4onYw6mmhaQW900Ocy1YLXwWkFpeM6+5V+rnLKd3ot8nSrtD9PpBGAZSTGdwZk2NfZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793982051;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FOMXNC8nD2xemKf6gqby6O9Pz76l+PDCgCO/ntvf+XI=;
	b=eH9zmaL4BJC2kjxUfyCLi0/rVxK2TloburHhhm9pvTw8jKyL/9xkuAhip5D3RNh75/yw
	 0jCgxmgeLS7mNlVyvIF7i00cHadT64Q1KvZPm7JbDZE4xifM4/i8wIaCE7O/vDV3jrUjv
	 MBhiuRtbNP6/NbvQ/dMcGH8RJZT+x75d9R6WUeESlysw5YLMnzkBdMAtgaGxRmhKeDIGE
	 4vyuPX9uTcmYWMQDPAwDPXd8P4gG3+ziacLv1eXeF14oWMH3yFVzbD165AFdUFaEi8/yB
	 QG0gMUamlVYNSYCvQynA6BBVBx4Mil5LflWppRlfz20B/toH9jxoHoZBsmed98I0/Cw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GUl8lkLb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A64606A32C
	for <linux-sctp@vger.kernel.org>; Fri,  6 Nov 2026 16:20:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66A64606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GUl8lkLb
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8ac1f2ff78dso871449b3a.0
        for <linux-sctp@vger.kernel.org>; Fri, 06 Nov 2026 08:20:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793982051; cv=none;
        d=google.com; s=arc-20260327;
        b=WmumIp4y5bVbXwx3A0D7U/RZgOmTsTs1BnkAbFHLWc3rii/O1zOR1G6kykXVQOdAZw
         fynyiiDgwT8vd7WASbdN5u2YTdDip6Z0EX5MxAkD5FPmKwOHzY8xEHMzKm8KVgJrxoAV
         A3RbK7WeW/NPIEUWfBQrfZHDma9Ra7D4iI9dxPKX5fwrb/9rCgvBTM6b9Eld0L6BNLrx
         vpV6d4ryktYHxa05Jk7rsxwez4GFhrK+q35Mn08Vk3pNQFD4zRz0B6hOvYPJXOu8Jzgt
         iVRxnP+haVBwVNfvh31wWheEPZz1uMqUFApJyRe/McylcbcTJE9zQr6sWT/EYyq9fMkS
         yEqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FOMXNC8nD2xemKf6gqby6O9Pz76l+PDCgCO/ntvf+XI=;
        fh=xsuTIPKTUdTrYjAf6f0iRK+wTiretwdwM99dz8eMrl4=;
        b=YfomJH5FoR+3J5sRqUD/YxUGOwt3dnaq8EbnC/5usza+budSZJ4z+4I33Xii8uCZey
         NtYH38V0M70idMaA3CnFjCue+cQhLnnU2/vzwrXOcZQRIBrrcPsgZCdxUhrwmfBXQzc+
         PqsfzMlMfVdJHX9C6oo0rurotVIRFYsQU8QbUZXL67X2VY/Dfo2na9dO2krZ2eUsQVXU
         FddqvOgaulTGobF2c2RPtwq0Z/lseK9817Ln6TI9K2RO3zdfMGqkGGu82rd3spRU29KQ
         65d8A9CsFEdDNKKo4yc0hVvAsUE6Sy0AwwOR1f+JEVm7C/IL66iJZCuCtc8Czmk4VTcX
         qPTg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793982051; x=1794586851; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FOMXNC8nD2xemKf6gqby6O9Pz76l+PDCgCO/ntvf+XI=;
        b=GUl8lkLb9T+Pzb6MJ5gKOvfhdiPR1h6u7MFhhijOYQa6vFZ6s0fsM2d+8RM7szLX2r
         0x4646A3e5ANNqMVuQzxEUTniFemQg/ocKuw2XIqXfnxgaIjEuhIvVtzcIhL+LDQrFWU
         EWxUKI1gqiWDdlUfCOEYo3iFwzv/ixM8ZkBFYlNRT9OU9EuBt1Vt5ZD7fXGd8WDt6neh
         AqaBwkbzurgr9pn2UACr+JYfqnp2MUEJo9rttrLpXrZqKwKKsi4EC/lXQMYNV/Xci99W
         8VW+9/QPlccNLgltM/dCTp0G3LKn6oOhukd2POX2WhyNKM33VGgEgKSyML0SstgqVgd/
         zIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793982051; x=1794586851;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FOMXNC8nD2xemKf6gqby6O9Pz76l+PDCgCO/ntvf+XI=;
        b=Qp7NreLL5pUgJdATXE0Th0bPc6rnaxqahLjth+LBpcW8P7pHCzcA8YdkqsBOpMhziN
         T9BefbwphqPK3mA43taXs+TY1Rq/RvTstpI3Zt5o0uU/lihHzOqL3YfvO2Ucc3YmoWJN
         g4GdkFi3K4YgT0K+HYyZ373TGcEmwx4niBekkMyMD2xrBSGP0fuwcp1LZpdOIvUzO3Ji
         FyLuue98GoU/6wWithBL9DN8aTgOZVuVymO4W/r7mTB+FjY0yuxNoK9uV03+VW9+AoeG
         G7cXvLe0DwafNiaMf/V7XoO/oCLNFcb+S9eM4TcwCwRLiuND+TIoy40R8ofbZklNDD4t
         XOAQ==
X-Forwarded-Encrypted: i=1; AKwUvBx5adBx907y+xyqKOPEMmh86t8nPwHJI8e+D9SoOAEq8DTXrZ43QRUuINYSQ5PB1BcsujNWYyKZCrVP@vger.kernel.org
X-Gm-Message-State: APuU4Z9vrpQvVtQowRqmqt6mKrq7KVKMOdaZJ1L4xT/kpuQ4dWRbmMDm
	LXBfrFOgrnvEuOyFc7xfeUd9clVA2wK21f4vLlyHCA1KfgQgxl2F2MsrObUrZ8IW3o8MlbMwjT2
	W6O+K1Uw04+wofZ4C8KTF+lL7rdlfjCE=
X-Gm-Gg: AYBFou1gGw+/GuMm97EXi+IIkf+8Fid3TyklDXJt9UD+yQElEmdI0Tz3lFVgVrSUmlx
	yUtOc1+kgOTWjHn1bImDjWkKD1bDwtyJg7IDZmeqzOoRwZVn+UMPB1gAkutaTeVGIq/t4yWd5VK
	XI5k/wF+CvVfw8IFl1BoJJmYuWpvnP/N7xvS7qGiuALYIf6UwQJ7Tib6ieqE5WhLm0awZINmEGw
	Kj4PVEMW5oFyb5phNQo7TRDn9ev4yFi1agOvRA94Qk+B7FfJYRaGIFiV4Yy+LBw+Z+/5WLigQt+
	dREqmBt+rVZpPFVrcy+T7dN3YzYdUCYFqTYILCBJ9xf1+qFTSWxcjChpVjRRJ4tpwwqByWVQLu4
	mdlJIdheRpo1BvgjV1wwCvJcQUNiapNZAtZOH+X3nos2JIfzb++CIFbYWXszE2Wk5qdH94ok8SZ
	Pg+EqpbLzSoya5MnCMwuPdZXwpEUrA6mUjCxQ=
X-Received: by 2002:a05:6a00:9298:b0:898:a77f:2833 with SMTP id
 d2e1a72fcca58-8b37bc5f939mr2052745b3a.21.1793982050713; Fri, 06 Nov 2026
 08:20:50 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106091938.112942-1-18983559317@163.com>
In-Reply-To: <20261106091938.112942-1-18983559317@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 6 Nov 2026 11:20:38 -0500
X-Gm-Features: AclHuK-yIHMUp58UeoDDDdnzrU0Ccta1sECn_2m1xLJeYcw_aDI-1ekYnwksz88
Message-ID: <CADvbK_c2A18x7H6jgFqdQjFO8h7OS=WFYCtoFN715LJXLtmB6g@mail.gmail.com>
Subject: Re: [PATCH v1] sctp: fix race between addr_wq timer handler and
 backlog draining
To: Binbin Deng <18983559317@163.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 4:20=E2=80=AFAM Binbin Deng <18983559317@163.com> wr=
ote:
>
> sctp_addr_wq_timeout_handler() walks net->sctp.auto_asconf_splist and,
> holding only bh_lock_sock(), calls sctp_asconf_mgmt() on every
> auto-asconf socket. Unlike every other asynchronous SCTP entry point
> (sctp_rcv() queuing packets to the backlog, and the timer handlers in
> sctp_sm_side_effect()), it does not check sock_owned_by_user() to defer
> its work while a user context owns the socket.
>
> While a user thread owns the socket (e.g. recvmsg() blocked in a copy
> to user, or release_sock() draining the backlog), sk_lock.owned is set
> but the socket spinlock has been dropped, so bh_lock_sock() succeeds
> and the timer enters
>
>     sctp_asconf_mgmt() -> sctp_send_asconf_add/del_ip() -> sctp_do_sm()
>
> concurrently with the backlog drain path
>
>     release_sock() -> __release_sock() -> sk_backlog_rcv()
>       -> sctp_assoc_bh_rcv() -> sctp_do_sm()
>
> Two state machines then run on the same association with no common
> serialization and mutate shared state concurrently: the outqueue
> control chunk list, transport->packet.chunk_list and packet->auth, and
> the transport/dst lifetime.
>
> The bug was found by code review of this timer entry point against the
> sock_owned_by_user() avoidance used by all other SCTP asynchronous
> entries, and confirmed with a reproducer that races an RTM_DELADDR
> address event against a user-owned auto-asconf socket. It triggers the
> following, observed with KASAN and refcount debugging:
>
>   - rcuref "imbalanced put()" from dst_release() in
>     sctp_transport_route() racing the timer's transport routing,
>   - a GPF in sctp_packet_transmit() dereferencing a chunk pointer
>     corrupted by concurrent packet/chunk list use, and
>   - associations dying silently (ETIMEDOUT, GET_PEER_ADDRS failure).
>
> Defer the work like the other entries do: if the socket is owned by
> the user, drop both locks, leave the addr_waitq entry queued and
> re-arm addr_wq_timer to retry after SCTP_ADDRESS_TICK_DELAY. Sockets
> processed earlier for the same address event will see a duplicate
> ASCONF on retry; the peer reports that in an ASCONF-ACK error
> indication, which the association tolerates.
>
> Fixes: 9f7d653b67ae ("sctp: Add Auto-ASCONF support (core).")
> Signed-off-by: Binbin Deng <18983559317@163.com>
> ---
>  net/sctp/protocol.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 27c26e12f95d..7528a40a87f5 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -645,6 +645,14 @@ static void sctp_addr_wq_timeout_handler(struct time=
r_list *t)
>                         if (!sctp_is_ep_boundall(sk))
>                                 continue;
>                         bh_lock_sock(sk);
> +                       if (sock_owned_by_user(sk)) {
> +                               bh_unlock_sock(sk);
> +                               spin_unlock_bh(&net->sctp.addr_wq_lock);
> +                               /* Try again later. */
> +                               mod_timer(&net->sctp.addr_wq_timer,
> +                                       jiffies + msecs_to_jiffies(SCTP_A=
DDRESS_TICK_DELAY));
> +                               return;
> +                       }

Can you merge these two mod_timer(), and move it out of the loops? like:

...
+
+       if (retry)
+               mod_timer(&net->sctp.addr_wq_timer,
+                         jiffies + msecs_to_jiffies(SCTP_ADDRESS_TICK_DELA=
Y));
+
        spin_unlock_bh(&net->sctp.addr_wq_lock);

Thanks.
