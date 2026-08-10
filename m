Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741432FD69E
	for <linux-sctp@vger.kernel.org>; Mon, 10 Aug 2026 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786370194; cv=pass; b=ESgt01ArSl6XxQlChj9j1zLivyA1wXMopEKwBzT0L6WCtmonw6jY2z0pJ0s1wgIbvbRikIzA8zJGcVPgHjh+1v/sCA7EijCPsAOZNTF4PRmvdCeItaRIZtRQN64GcsCi97gz92RK2m0lg6m2S9nFTidaGKwvVONjdF3kuruR+6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786370194; c=relaxed/simple;
	bh=JIaBxECDgeLrglNTVL7uEQ8ZAUKZE2cQsl7TRwoqsBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M6aH+Y7hRnHQp9KKOmcFdMGZvG+fc7NT8uldvw1VPrXuX7RGnV9ft2a9p5cWN/oKKBrppsGlXxd5LoZ5gEQwFYDh7VhUsy17V1OzjeF1aKmxncEMCu01UR7qxKNMpodL/D+3THkcouG5VlgUWoe+9K8nMQWcMqQveXfHMm/KGb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ght7qXDz; arc=pass smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ght7qXDz"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so2096301a12.2
        for <linux-sctp@vger.kernel.org>; Mon, 10 Aug 2026 06:56:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786370193; cv=none;
        d=google.com; s=arc-20260327;
        b=KOCYGF/zpjIZj1kC7g0fMdnaPZ6caac2fYAZN5+2RhWaWQZzT/mS5KhUVr4xUFhKp9
         J54bBe7thBWgCUveekQysyOFa57uN30kKsn/4+MIDfj4LlFiw212++K7Qpfd2Wl0ArCX
         AtBwpgbVc3ToqBSkHioz9LmUcjcDU1XqvYZE39xbh9CrjKwbKZYtALv6dYsPXwTdvVL+
         Uza3Iu8ODJ8zpkQNyGEh6GvRJxko+9pI6mbMPh3A1t0WBXxPxUZtp5v4AmGvFhnBxzHO
         dyzSwF/c5ZCvuITzWzCDDlYJsV8YNylerMncAXbINqW2c2zrze4T1gufHlnNG1wnM+z7
         wSLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZiMjoEB+rAgTIeNvxZB7ySmeM47GF7ZvAX9I7YT8opg=;
        fh=nkKEbMcqJF67c+WpTLK4liVXVYBhPRubgRzimnvl3cE=;
        b=dNup4UJuPMTK/ZnVicZ95LswGugmSdMqRyNAbAM25yvkMkOV/qHzMqmbBA7VQAkyRb
         MGeSFFUb8KPqJ5E0d5L4/z2l/KbtWVPncc5MVfkD7FTJ8ICuG2MaRWpwSLG8O/NibA+8
         n7No9L18fLupwXSYo2IGzfBuaeJt12g+8K/mnmmhrwlBBzGniGNHkbb8TDrHuQAit5gU
         DmJa2QGzXA1bAIrwaXeaDl8JbvZx+DpKytXETBLD/Mp2OxCTVbvqc3ySUJjMKpJt9NBv
         SHRSDdBghJv3mDKT7GQN4RTryHswOuc6X46psgYbceLhac/xQp7shGqJVIi4UJ73e5qz
         jEGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786370193; x=1786974993; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZiMjoEB+rAgTIeNvxZB7ySmeM47GF7ZvAX9I7YT8opg=;
        b=ght7qXDzRGKZJ+LhdU5sniBUuY4oZS4RXtw6jWr+KfGhoMGL9kLZcCKSTOB0rC7gKj
         b7PosnYRjwtgqbNhp8EQHUSyxDYKWGxJMyIO9R75CKAEUuQc7zc5wgSkInr508A6I962
         Jke/c2BOCWmAhJx1Pd5FiQCTCNwBtjsudDuZuh1Z8ZHhLyhbqXlwKLysbadOhXVS0Te1
         aP36W/BFAeFu/euw9fI5AwjPcMQGtSe9YS0yolRqgSE4uMurIHjoj77M2L8Bk03/Z1Il
         7NATrI/uEag2F/6lRkjHiXz0zAaAdeYJvnfjWvua5rzUAzkn/deWWfKA0bkE0xcO99es
         eKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786370193; x=1786974993;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZiMjoEB+rAgTIeNvxZB7ySmeM47GF7ZvAX9I7YT8opg=;
        b=ohHSS+7leJD5rpEk72gmybjBVQ8Ea0bWzblM3WKDpx3RmeJjJKwmrWFWe00GLNPd97
         LNUExQZlaziBPAQogWKrPSf3Po0uTsiQA7z1yPYM3eVdWCenh7zoeqdmmcmstbjAbTjl
         g8wCo82GDgJkfbgfg/PddypS7UMmNUUTEhVi4fw44qITY+q9sR/zGycuVw4Oso95aMDe
         ChFKR220Bu1Jwg2CVhOW/VpcFwtZp3ejSF4LzR7FDmMjcea/fF9S5vLe5c8FI+JOeS6a
         DN17rE5M82TYKaWh+baFw50aCclAKvrmGFZkeOUrRlNk783h5m75+6KQ4miFaZqDih3m
         qalA==
X-Forwarded-Encrypted: i=1; AHgh+RqXMGd1YyfUpnYWt97fOxXyfc+cvc89U2rax13UUhUF6hJQRVczcrVJrbZgmwJGetLRXp0YV64P2wez@vger.kernel.org
X-Gm-Message-State: AOJu0YzrBN9TbG0krVWp5+/1UQcCrRW8Jg8Uv0n1nZ2R4oHNXUTIi4I1
	b7hPhn5z4+JU3fNfc7rIvZWfnnSB6BMeZbkeR7eHDzffr7GYmyXsOrMnIsaey04NnloX+dnM/oB
	fub38sz/eDcHcB0YbHpJFc7J4PkSD/8Y=
X-Gm-Gg: AR+sD10HyBaUvWuNa0Ex7ZDhP0ymwbPIF066F/JgEUhe4wyjuAv62vTI3Dz9jYU4w4p
	XAM3CUo6svIpTP+amkZufh+7vElfBp+ThM0qMpe4xMbECLvZwXQcDw+1EDe5k3WvSS1aSFx+AGS
	DAwa9qWdz/5QZU09gN5e324byTM2RW2YzcCY76GUCWv4qfXHm4sl44X3ncCNeLFE0n2QWDJRvGO
	CqjafTEdiHDqsyGAdvXlpCF50G1sDzLyUR3WlDz6MknDTWULxP6RJDDycO1YrdwvUWNqvKgbaJx
	8qBMmddyT+9fQFhFqdZrQf1IuNnZW+JolwzEYZIUBcI4M0WT1mn0+e8ROq7Wqm8qcebZL2odaA1
	N1HMZyioHq+bE8zMb2wx3mbZYODA4LAdSGbGBbju47+Xg1A==
X-Received: by 2002:a05:6a00:1405:b0:848:2c6c:dfe3 with SMTP id
 d2e1a72fcca58-84f9c914a9cmr1689714b3a.17.1786370192660; Mon, 10 Aug 2026
 06:56:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730064202.792809-1-l1138897701@163.com> <20260807064314.500742-1-l1138897701@163.com>
In-Reply-To: <20260807064314.500742-1-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 10 Aug 2026 09:56:20 -0400
X-Gm-Features: AUfX_mx9V_SVYfZyMczkkkNKo2kfHaPSv0laG0eJ0CyEwUXRtjkhxqMLG_jjaxs
Message-ID: <CADvbK_fS_8AoMpqSosUYA7zhqtYx=wXcB_DvkZXe7_DKaJJ0PQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] sctp: auth: propagate HMAC calculation errors
 to callers
To: luoqing <l1138897701@163.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 7, 2026 at 2:44=E2=80=AFAM luoqing <l1138897701@163.com> wrote:
>
> From: Qing Luo <luoqing@kylinos.cn>
>
> sctp_auth_calculate_hmac() can fail when building the association secret
> under memory pressure, but its void return silently leaves the HMAC diges=
t
> zeroed.  On the receive path, sctp_sf_authenticate() compares this zeroed
> digest against the peer-supplied one using crypto_memneq(), potentially
> accepting an all-zero HMAC from the peer if the allocation failed.  On th=
e
> send path, sctp_packet_pack() transmits a packet with a zeroed HMAC that
> the peer would reject.
>
> Improve error handling by making sctp_auth_calculate_hmac() return int:
> - sctp_sf_authenticate() returns SCTP_IERROR_NOMEM instead of accepting
>   a zero HMAC.
> - sctp_packet_pack() drops the packet on failure instead of transmitting
>   a zeroed HMAC.
>
> Update the declaration in auth.h accordingly.
>
> Assisted-by: LLM
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>

Fixes: 1f485649f529 ("[SCTP]: Implement SCTP-AUTH internals")
Acked-by: Xin Long <lucien.xin@gmail.com>

>
> Hi Longxin
>
> Thank you very much for your patient guidance on community patch submissi=
on conventions and your valuable review. I fully take your comment.
>
> As you mentioned, returning 0 is acceptable for the moment, given `sctp_p=
acket_transmit()` always returns zero today, while `sctp_packet_pack()` ret=
urns the count of generated packets.
>
> Although there is no functional bug in the current code, unifying the ret=
urn=E2=80=91value semantics makes the interface more consistent, which can =
prevent latent risks when this code path is extended in the future.
>
> I will implement this optimization as a standalone patch for net=E2=80=91=
next as you suggested.
>
> Please help to evaluate whether this improvement is necessary for mainlin=
e. If maintainers think it brings limited practical benefit, I am okay to d=
rop this patch entirely.
>

It's fine to make the code look cleaner even if there's little practical
benefit. However, for the sctp_auth_chunk_verify() change, I don't think
it looks better for all its callers to have:

+       error =3D sctp_auth_chunk_verify(net, chunk, new_asoc);
+       if (error !=3D SCTP_IERROR_NO_ERROR) {
+               if (error =3D=3D SCTP_IERROR_NOMEM)
+                       return SCTP_DISPOSITION_NOMEM;
                return SCTP_DISPOSITION_DISCARD;
+       }

If there's no clean way to improve it, I'd prefer to keep
sctp_auth_chunk_verify() returning bool.

About the return value of sctp_packet_transmit(), I just checked the
history and found this comment in the code:

  /* FIXME: Returning the 'err' will effect all the associations
   * associated with a socket, although only one of the paths of the
   * association is unreachable.
   * The real failure of a transport or association can be passed on
   * to the user via notifications. So setting this error may not be
   * required.
   */
   /* err =3D -EHOSTUNREACH; */

I think that's why its return value is currently always 0. IMHO,
sctp_packet_transmit() should return void, and all its callers should stop
processing the return value.

Thanks.
