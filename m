Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BF846AEF0
	for <linux-sctp@vger.kernel.org>; Wed, 12 Aug 2026 14:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546091; cv=pass; b=ZcaBzLcUsi1F3mE2NntjBxFiY72us0bkArd9l9Ms/9+12/WQb1UjoVeUFhc/Ls4ONDz4HL0WukxTflmuyhMLXkgPvGx9dTru7G/fD62qUrGvrtO2sqM0sA6uupTEDaktD2diC07QQn9yZPqrtG0v2s4A2JOihY0zlVo5um3MHxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546091; c=relaxed/simple;
	bh=KyRouPkzlT8rYZU1MroXIcZmKsT6ZyhKSTMgIpK8nEM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YSNniLnRGCeM01Zx0XdptroN5/oIOGdV/DWkhBHWE6VwIzJbx4Uj/f/geUhl1brFiEmBYMPN1LdxOPN4tv3M6eW7mVIlXYfyqyrsIA9Fn26Mp7euf2mmXOjXZEofrwObKmL6NTS5saym1GSLe/XR5zDf82bkTD+W7O7eihxk0cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tOokjULn; arc=pass smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tOokjULn"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso1111223b3a.1
        for <linux-sctp@vger.kernel.org>; Wed, 12 Aug 2026 07:48:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786546080; cv=none;
        d=google.com; s=arc-20260327;
        b=B3EBdjGUDokTzmL9cJ7T240rgFsXPnE4DOyhcvacb0gALLmvIevne2r2qjMYoMZSeN
         WXZcZ0QP8YAxFulB5yAvw+oyxw3aBXRDuP3MmgxYvRIt6ax1lnPUrBU8ly7ZXaxkh59i
         0CT/zTCbr6OlM9PRKiVIaze7SQN6xasGGYoAnbd47VxTvwg3/8eAOE+XRwhHjEa+um93
         qsKNhwjauf4h3/c4yjZCENe2BPJsnvc2H8jJ/J2lHUax7dq+MoDAfyIoSWL+QmEjuSbg
         HB6YTzS5sLTiA9fYkhEnEWIpP3sWUuqTjI3GE0MyS8JNT4Wzb5UJK/AsxMN60Sw9Lm9A
         I0TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ly+eS6auCcsMiu+Z/Trwar5yfkD4ejbCJRhO7pUpTkI=;
        fh=AoXlGLtNYJgoxnIOorHseTdTKYwFU2vdvXujBCCj6MQ=;
        b=VF22t+fyw71boXbko0QZDuvSyVBw9ii15Uiz3FK0S8buMoaEneE9oKkA3U515EnKOW
         X3sjT99XJC1Ky3tjidpt6fOCU03mg69N1UygsubORUrMg7RB1nx1h//o1iM58DKPBURP
         8qzKtcvD0HxzzLAv5SDwXGrqUH+a0LgXc+cSx57TDffZTCwLKDNrMTZjisKGW/sM0qpY
         gjZeaQNK1cCXXahhHfvBBpdcaTulPaSsLIagRjw3uaYLCQRUzapQVDY06w8kS1EdH1FY
         Llr954LuuJxOj7AVKrToJ14KYNZZh0XaZbs+LqwtfFwwAxDMjV5vJM53Nxilnb3VtWi+
         IQ/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786546080; x=1787150880; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ly+eS6auCcsMiu+Z/Trwar5yfkD4ejbCJRhO7pUpTkI=;
        b=tOokjULnNcr4Ed9FT4AqazHaCobmqCpKd5jb+/xlhQf68+42WfQ8SK+knYK7S3TKer
         ZLLLI6e7uqaU5fJm8SXwZ8j0xToyb2H/lajOXV5xZ1kmrW8NjLDQ9EgCQsabyGA1KIwG
         Chs0jT43SwCUKpcN3Soooq2gkFWMBWEh7uc5RuXtH+6ueTY1ngB3KFKWgCsj23SE17A3
         /otOLJeoAIIRoHKa2XYECBkHRnnTIGwiopQmnmCFq1OSd+eXlnFziZmDXGR6sFVp7/xz
         f+nA5ZF/Jadkd/BYFDzbaUSM+ta6GoLT3x41B9w7Dqso3ogDM6U8dK3kOjSCLOU9gpHJ
         4rBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786546080; x=1787150880;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ly+eS6auCcsMiu+Z/Trwar5yfkD4ejbCJRhO7pUpTkI=;
        b=FTOsJ32J97noKlQUFEoVyWv0TmR87kbs0sagafFdAv0RvjHXCPTEaSHaOtv6tFbrp/
         UFEjZZV1zcqXHmmUHI7sgogEhX9sf2OWh/0hiJwNm9gdubbV+9BdWwFW07Ggi7fJr/gF
         MmApcI67gfK3Eii4evY8fZw94R8nS00x1QJmv0h5MQntNdUKzG2c53XcVrPBrZRIwHl/
         q9JKGUchFp5RiVwWXHWxe4lTwFjjAna6kj+XsScq6CmR0QU1R43ux3MKgotN9yw/+SDU
         ulCx1SdbnG38Iicj+sEZIRmpMAWC6Lm2bYq6DVxq/nxpnyKqYbHL3m4egDpq1I+rO/hF
         vhKA==
X-Forwarded-Encrypted: i=1; AHgh+RqgqZXSYy6QayBeHc+GfJhruVHIb5SRh4oQUD+d3w3Iv4YpelB6yT4kHS+2CBPleIw2zIbYTlCQpcmJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw6rSlOv/wONDuGeyD9PLk3hB+sg9I/Y0rTOHPOsZ5rdg7zjeX
	/SFpp2KGlsHn2tAmH2CmkFUO2VElnI9q7nl1mR4u+luw15prNC9KqMdSlYo8oSDCsqlIvV2iOA4
	AxGwpR2sh6JQIDzyLQQLtsMvK9066ftQ=
X-Gm-Gg: AR+sD11s0eTHw7gcAKGi7+MsX9TUerDoNXXNC/LRsTri0kB8Jg4QZG+eD2IQE7c9S2/
	d4Gf7JS/B90IwT7x8vmYHIJArkrD4S4N8M8LYCu+xB23lyDu9htOJVYP6m0dzuy/x50RYrzn309
	hOCNk0JqOvQpIfazpgc0K8QxDEOWLph2V2NXy9bKltuDyQKjFPL04YPTwL0Ly4CddqnGSDXfU99
	0avqOXoSO+Zz1i9H9IX6PoHQS0oN8Qvg4a3S8pCT4wgt+OVqxLvui83wfU3Rjk+qjOQDauMFrH+
	e/BAoQEsWeA54Y+TmGTI6DQN7QAnOd9mwYwJKFJdH6YIxchIrOQlQQNGr1B/+bY4WPpXTdaTayh
	kf873JLMxdW70vvNkn5BT4y50amkZdHHXw9/PtahAdbvFMlqHegY3xsoz+w0M+Majj2jrGT0iF0
	AY
X-Received: by 2002:a05:6a00:ad8e:b0:837:f111:b70 with SMTP id
 d2e1a72fcca58-84faf9b9105mr10063380b3a.4.1786546080284; Wed, 12 Aug 2026
 07:48:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811152803.5629-1-a0yami@mailbox.org>
In-Reply-To: <20260811152803.5629-1-a0yami@mailbox.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 12 Aug 2026 10:47:48 -0400
X-Gm-Features: AUfX_mxOks_9sP1fncoI_F9OdQEsQZPYw2j_n0LrkRuaytrYSKObi2_mPZBuwv4
Message-ID: <CADvbK_cop11Jju3TBE58-tG5OhY4AsZMvCEFC8Neh=rjF-rTsw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: clear new_transport when removing a peer
To: Qing Ming <a0yami@mailbox.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Michio Honda <micchie@sfc.wide.ad.jp>, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 11:28=E2=80=AFAM Qing Ming <a0yami@mailbox.org> wro=
te:
>
> sctp_process_asconf_param() stores a newly added peer transport in
> asoc->new_transport. After all parameters in the ASCONF chunk have been
> processed, sctp_sf_do_asconf() uses this pointer to send a HEARTBEAT to t=
he
> new transport.
>
> An authenticated ASCONF from a remote SCTP peer can add a transport and
> remove it again with a wildcard DEL-IP parameter in the same chunk. The
> wildcard deletion preserves the transport on which the ASCONF arrived, bu=
t
> removes the newly added transport through
> sctp_assoc_del_nonprimary_peers(). The removal does not clear
> asoc->new_transport, leaving it pointing to the removed transport.
>
> sctp_sf_do_asconf() then creates a HEARTBEAT whose chunk->transport point=
s
> to the removed transport without holding a transport reference. During
> local address replacement, src_out_of_asoc_ok keeps this HEARTBEAT on
> control_chunk_list. After the transport is freed by RCU, a successful
> ASCONF_ACK for the replacement address releases the queued HEARTBEAT and
> sctp_outq_select_transport() reads the freed transport's state.
>
> The issue was found during a static audit of SCTP objects. With an
> authenticated peer, the reproducer triggered the same KASAN report in 2
> of 2 unpatched runs on a KASAN-enabled netdev/main kernel:
>
>   BUG: KASAN: slab-use-after-free in sctp_outq_select_transport
>   Read of size 4 at addr ffff88800b9bd95c by task python3/197
>
>   Call Trace:
>    sctp_outq_select_transport+0x549/0x8b0 [sctp]
>    sctp_outq_flush+0x306/0x2c60 [sctp]
>    sctp_transport_immediate_rtx+0xaf/0x260 [sctp]
>    sctp_process_asconf_ack+0xa48/0xf70 [sctp]
>
>   Allocated by task 197:
>    sctp_transport_new+0x68/0x650 [sctp]
>    sctp_assoc_add_peer+0x258/0x12a0 [sctp]
>    sctp_process_asconf+0x5e9/0x1090 [sctp]
>
>   Last potentially related work creation:
>    __call_rcu_common.constprop.0+0x77/0xb70
>    sctp_assoc_del_nonprimary_peers+0x7c/0xd0 [sctp]
>    sctp_process_asconf+0xd9c/0x1090 [sctp]
>
> The first invalid access was a four-byte read of transport->state at
> net/sctp/outqueue.c:833. The same reproducer completed the full
> authenticated ASCONF and local-address replacement sequence with this
> change without a KASAN report or oops.
>
> Clear new_transport when its peer is removed, before it can be used to
> create the HEARTBEAT.
>
> Fixes: 6af29ccc223b ("sctp: Bundle HEAERTBEAT into ASCONF_ACK")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5
> Signed-off-by: Qing Ming <a0yami@mailbox.org>

Acked-by: Xin Long <lucien.xin@gmail.com>
