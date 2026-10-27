Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793091864;
	b=GoKmhZZ5X/cwWh9/o6lTuejyHaA9YaQ0JLDkds1TdgB8AKe6VIzAiieLgi8iy6JC9yyt
	 Te7Lorx81ZTfeXIW3ikocR6BktjGLE6RML8475efyCYHfHx205elYzko4FLIy75dPq4X9
	 xXKCV5ehmtA5fgCidUZfn7xPp2xo3M+UUxDyKUPzU27fGJyMX4nj/yB4fbExGB62UVO93
	 7k3J8vljsvlGPpbiLUBhGIdZGX6AmUCR1jWzQZ8Pa21yv/Y85aXhGSYt3LlQwVxXjf3oQ
	 cwa049o9CrBTjR0CEaEISzp2dR83FFBnoQfRhCBqwbzHRMH/uOFZOHiFc8JNY2D8CPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793091864;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=IC4ICtskpaMr1BDvtcg7zj+mYWKpW8yLLny0A2JJ3ZM=;
	b=ITL4nUnuoGjvQGjni8uLbVdRFVBzgMajFWDspY62g7Rws2QBKb2GOFD/iLV7UgZVzIi6
	 ifwamJurCo9ZlSwA9MclTU4mOVFHWoBmtgPAWbYpRmRQZk7YXk5oPt2JCWcIArYEQ1rcv
	 Zcf+Ss+JYCP2cfJ9Yliwe/VJGkt9Un9zncEgBoE3ejZAQ2tB8nmd8afogeOJ4HXpvs7/2
	 /noTZpdUAy3fyPG9gHO7oxrDCZfTP+a1mlrHumwvWsKRYaKI4TKHXXA8Q7m9esbEA5U+5
	 Sut9abQas9A4QJsGtBm6Ri1vcMYHcRzTv9u+3Ng+bNlsU9R7LrOdCmrSxJObq8nbr1A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nuXcgjgI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.175
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C27F606A31A
	for <linux-sctp@vger.kernel.org>; Tue, 27 Oct 2026 09:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C27F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nuXcgjgI
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8ab43af5e97so8680627b3.1
        for <linux-sctp@vger.kernel.org>; Tue, 27 Oct 2026 02:04:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793091863; cv=none;
        d=google.com; s=arc-20260327;
        b=eIx7qdZJYqtRzZHWVT/aWgP6NyDRj09CydVd36aKOzCNvHbQVXdjA4vo3pNK5y0htC
         INFtnDGm2M6OJzpEYY3UiRzViAgi6MbZphmuSTM5ue5kiWJOb/WUX+PhsN788bPeu6X6
         qiIDyPcccLE8aLsi3318EpSLRdagESCBzcH771jPN384FxLdAsN9KQaGaEO5VoxM/WZj
         eS+oWeRwkGcbPruNECiBfIQgZ4FAzZ/+L0qdaSq5/sbPpfuKv8veiHM99ozIvJ0hk+9i
         TvZC7pFiHtUTIp/AW7hW/i8mig9Lq1dkzviP2Tt9MO+F8OxZBvOeSg5E2gQNDlU+dHat
         R02Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IC4ICtskpaMr1BDvtcg7zj+mYWKpW8yLLny0A2JJ3ZM=;
        fh=DGcCgQWStoHOj3+ktdf/NLeqGbxGGHt0LmWwVK+r014=;
        b=gVeHJrhhMR31IInfX14Z7E9s2RnYgzMhf6gzmEUF7HiOoBG3PeYHnTDivEmDPHlO80
         ssl69DhiLjJcqaO1J/gK/LB6oRWXUeL0anR31OVGvvzLOlCaDbCCLvvKiJqNyA/y01F2
         q1YDoUx2ECKnZWr0r2aH5FExHx7xy6F1XNlZVaTKUaE8fkxOOrl8qDGpZLjoJSJiNwxq
         tbB1EM/dh5RZfQhnFvbi4jlo9x3TaZ6l9GjYQjA6hay3aDGoHmS6BGNPjH/p/gkWMXzY
         Uv3e/X4LC1+nlgUAy/bV1Asj0hUt+OeZShRrw6dNn+aPrCY2f2HY+7wA2X89NS/ctT+H
         2JnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793091863; x=1793696663; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IC4ICtskpaMr1BDvtcg7zj+mYWKpW8yLLny0A2JJ3ZM=;
        b=nuXcgjgImRLpr33nbQdXKUCCrMD6AEqN2Xnpc+EfrpyBTbxxXk68hY0rQmm/6syrel
         u2dPxtll6lq7LM0pUYwkJWqgo/KhNVQdQkBWIwm9Yd0qB9uH6hSuqcw2p0/+CqZk6S9K
         0yQu0+Htg5AeXpEnh4Msr6+u9UGMoZj4NT8IXQZj0MCj/O6qBq0Qaz+DUTD+uq9tmE9g
         kFCUXvOVFVeRROMpTCRF+Odr833ULEPnJge1NfbZN0elhwcGdRQ7qiXcg9u1sAypjdvJ
         LCGMitjTkGnJnD8qpgZ4gxH4BhVcyKwO+bbaK92JN4UVpYBqf0+4EmgmcUkWbQ6d3ePE
         thLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793091863; x=1793696663;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IC4ICtskpaMr1BDvtcg7zj+mYWKpW8yLLny0A2JJ3ZM=;
        b=orYwwvXKD9HjYKgtJEB0+zP1mNqPaw95weBuSpj4RLtaa+f74wpN5vHj5iamyIIWmp
         B/otuCcBNmNvGOOhokO0BG2o1DX7k76U1tCYqXYwTupk7aJLW0b7SCPLN9iM7A7l1IKc
         5bFtRog9XfU2beVIrmVXNbM+xXUVt8ANXLldWWHNCRe/KE2uWjWOPt2pZxKblyJJAh2V
         F0ZKW4pmeNm0+B908Mjvno8hk57M41R3nIDSbvkDtMyqoTtM4TkjS9qOd89dZxlxgzlR
         v0DZv/9N05V8rb5gvPUYLeWezBRpDidWp/Z2Zlg8v3ZFkV+FDccqpo9pEIAVNLiScf53
         1v3A==
X-Forwarded-Encrypted: i=1; AKwUvBzoLGurgseYZXHJUyacLvlR/399lKWImzx+0yQc23MmuJZZH6HK6Ilp1yk/LOBHMNHn5MRwsF33H/fM@vger.kernel.org
X-Gm-Message-State: AFq9FYIs8bz8Jmkmhsj+c259PkcifGTLHKsxXJieVRGCJWhuxbGivYE4
	EUhMSaau3Dh0mBdsHarBmpGYEnPSczRtSgEHqQrGjLRf526ITo9K+z+L2r4gRmRB6T+jmwh6f1d
	cZkl45neTyjDxl696c//3fC3o0ROzax4=
X-Gm-Gg: AYBFou0J3Zwl+QIm7yaIkTiED37WDTAeOHctK+Pe7XzQ/S22t87xEj/y0KrpU9sF6lx
	QAH4Drmb0/xWufpR925ws+rJX/nO3CmXZCWzaQLALdf2BU6ZkrF2b0NSLZfGMJ3OE6sOpU9UEkx
	6HO/IFzBRnrTDeVAXroonT5VAYsVvGTghDRKYe3PB/0nXMGh/D1w5VbssPN4CB1l4r4Clx7CvQ7
	fEVRexh+D/jbscrZXhRJt66SJYFN49AgcrVnOS4s3mVe9YF9Mys2HfOOLF69AKgduCP+GcgmcIS
	SQoC1RGNkU2sG1cFhSVqWUWe4VT0eALI2l7TNrSVsklPjd8ElUuYrAm8ssN/W23ANKorjs9gEyX
	OA9tY9JyhEPfhswmI1SOO52Kv0VTgZouFCrc=
X-Received: by 2002:a05:690c:6387:b0:8b1:567c:e7d3 with SMTP id
 00721157ae682-8b19c7985ffmr16596757b3.7.1793091863585; Tue, 27 Oct 2026
 02:04:23 -0700 (PDT)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027082405.1297-1-shengshilingmu97@gmail.com>
 <179309014594.3327.16979359855381839184@kernel.org> <CAGGuW1XarBs3ZD7eKeysDs7qGL3=Zgd5-vsY1ReuF57gz8aLFQ@mail.gmail.com>
In-Reply-To: <CAGGuW1XarBs3ZD7eKeysDs7qGL3=Zgd5-vsY1ReuF57gz8aLFQ@mail.gmail.com>
From: =?UTF-8?B?44K944O844K544OI44Oe44OI?= <shengshilingmu97@gmail.com>
Date: Tue, 27 Oct 2026 18:04:12 +0900
X-Gm-Features: AclHuK8kmj6WVIj8zol8TSlhzkemES5oLPxGf7X0ktRixJ_-10JdWdLfo56K8xM
Message-ID: <CAGGuW1UGKtQUGyqY5fKNhBRnmBJ5L+QggeLtbdtvXiaDo+Mmsg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: account for chunk padding in sctp_init_cause()
To: netdev-bot+sinfo@kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The missing tailroom was found by reading sctp_init_cause()
against the padding that sctp_addto_chunk() writes first.
AI assistance was used for that reading.

The bug was triggered, not only found by inspection. The panic
was confirmed on local virtual machines running 7.3.0-rc7 and
7.3.0-ga1c2b1da93f5 (CONFIG_KASAN unset). The symptom is a
softirq panic:

  kernel BUG at net/core/skbuff.c:214!
  Kernel panic - not syncing: Fatal exception in interrupt

skb_put() calls skb_over_panic() before the copy. The observed
pointers were tail 0x6c1 and end 0x6c0. The same panic occurred
for a listening socket, an established association, and an
unprivileged client socket.


2026=E5=B9=B410=E6=9C=8827=E6=97=A5(=E7=81=AB) 17:50 =E3=82=BD=E3=83=BC=E3=
=82=B9=E3=83=88=E3=83=9E=E3=83=88 <shengshilingmu97@gmail.com>:
>
> The missing tailroom was found by reading sctp_init_cause()
> against the padding that sctp_addto_chunk() writes first.
> AI assistance was used for that reading.
>
> The bug was triggered, not only found by inspection. The panic
> was confirmed on local virtual machines running 7.3.0-rc7 and
> 7.3.0-ga1c2b1da93f5 (CONFIG_KASAN unset). The symptom is a
> softirq panic:
>
>   kernel BUG at net/core/skbuff.c:214!
>   Kernel panic - not syncing: Fatal exception in interrupt
>
> skb_put() calls skb_over_panic() before the copy. The observed
> pointers were tail 0x6c1 and end 0x6c0. The same panic occurred
> for a listening socket, an established association, and an
> unprivileged client socket.
>
> 2026=E5=B9=B410=E6=9C=8827=E6=97=A5(=E7=81=AB) 17:35 <netdev-bot+sinfo@ke=
rnel.org>:
>>
>> Hi!
>>
>> This is an automated message. This series looks like a fix, but its
>> commit messages seem to be missing some information:
>>
>>  - How the issue was discovered, e.g. hit in production, hit during
>>    development, syzbot report, manual code inspection, LLM or static
>>    analysis tool scan.
>>
>>  - Whether the issue was actually triggered, or is only theoretical
>>    (e.g. found by code inspection). If it was triggered please include
>>    the symptoms, like the stack trace or error messages.
>>
>> Please do not repost the series just to address the above. Instead,
>> reply to this email with the missing information, so that reviewers
>> can take it into account. If the series needs another revision for
>> other reasons, please include the information in the commit messages
>> then.
>>
>> The evaluation is done by an LLM so it may be wrong, if you think
>> that is the case please reply and explain.
