Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793026068;
	b=wsf1+MgMku/pzN+LKCKAdJh5VGWW2Xq1wnHaPLH9y5cYbN3R6eRrR9Pj8f9zDgN2qhQz
	 tFBhUDo5pc0IJCYSuibOqrnOn8laTexnKmXUYvkiLZy1ZjGze2i6YFap77IPb9Njh2wcc
	 wIrV0M0iGAfDZSan+UcDG+x7oeBqbIx2zgw45f1WLralMWRL3IX5QG5detsbprQdrHHx8
	 /g2JSoD627xPI1DodfGLCxgSNMnKgeoM05NH3tosKdi1FSiqpgQHObHX33JjyCRi6tkxm
	 plpiGseO4u+JEaH/aukMKEIR899SokNz+Z0LL612Uq9Zw7jZZE/xrMK+rG3ex34QG0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793026068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=QKdQFJ+FO6S53u4bEibR73jMpDgxkOnbF5dGbreuSCU=;
	b=U59zysRANRmm4Ssw9DnbbqLBPGv28COmBpAKu5TVdr8803rAYx0NW8xCoK+TNWCq0ytV
	 jp/nqY9QtRmdnII3DvVHGb12EDlvBDBnuKY78fTfj1GdxE5BO48nvg6vqwu+yOieE568T
	 Q/6WqnSlAxr6kutA8WNbLF5Kz5/fASs16wArpa1eYDZxgcQrs0k433Kw5ASbm3DpB9uvW
	 ICQk3dzeIoTcFyEOXB98BrSsktYXZzkev5Lgb8ljsCc0bags/heYGvc+KJBwBOPp6b/DS
	 bcMQSDXXy1+EA+SNCGsLdzVOTzknm29hdNsZ32w0wPWQ+G5J+x4RFVPYNrz4VO4G/HQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lb56rzpI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5729A606A31A
	for <linux-sctp@vger.kernel.org>; Mon, 26 Oct 2026 14:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5729A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lb56rzpI
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a06c60065fso2342315b3a.1
        for <linux-sctp@vger.kernel.org>; Mon, 26 Oct 2026 07:47:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793026068; cv=none;
        d=google.com; s=arc-20260327;
        b=lhFPVGJKPLBOSMpIh3WEJkud9KPNf7jY1u1WVdxWjIRZFiWfV4Vrvn2ho5KNfC0l1R
         oTisvgQYkOfUWHUL+O9KWgAR8uWEuJpP+EnTs5K+oVTggjLYBFqcUQHMJXV2EX9P0gkV
         bjPsW0AlxvQ7vf7+Y10XtmHlRJVEqgUw1LXWa+qbidhJ7iM7/6HU6JkDRdY8PCHVEOE/
         2y+b6NK32c2tVjHtMBZu11RDcQJYfun7eg5/KDH4gg4jcrDW78YxmB8mO4AO+pGlHibw
         zVViCXyst8ajhjYQKRwljhrPS6JvUN9oeRCOJL2uXZDaBP4GZB7prPV9kE6E5HYykWsR
         7Hfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QKdQFJ+FO6S53u4bEibR73jMpDgxkOnbF5dGbreuSCU=;
        fh=DllQ7HDqFD5PrrnX24HIqN9BnMPTT7pRrAVhM6blEZI=;
        b=Lvtucbb9an1HmRdP02dva1MwfYrX6Es7jp9XNIFz2gCMbCWEjUs+QVGENZu+5t2Kko
         dDPLvls7H+qzFHhq3O/vr6/diJdpAzkV7Ga8mFjgf1kaPj+yTg8EcGC1DUc9gdPGJO3Z
         SEUf17nehHLsIGfevZ0blEt/XMG/XK+W4Ticl1WyZOL/Zfm1ySnlxzlWve57S8hVjT4G
         ViWNax+y+skK4QufSIEwdrPbicSQh+Tl1n9dSvuh9uCdeeZaWP4YjSWf04bEgJ2f35Vz
         3vWPYMizMFtrP4vrDkBwm+lGvv3AwGA4/Irg/gQuOc+kIBT3OKdiNY5FKwJkeb4mWfJA
         7Aug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793026068; x=1793630868; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QKdQFJ+FO6S53u4bEibR73jMpDgxkOnbF5dGbreuSCU=;
        b=lb56rzpIO1LxCDOU6SRaulK6a8nZmTn+nU5EVvwm3gZfwrveORS5n/PPE4qQbiRClu
         zgNtnm+OBarJydQrUmHhg1V6GMFxe8n3hYR2/dTYNyMO8ZgZmtUtSe780y4h5mtLYO55
         JGkYj3UtRTyzblawo222Fiq/wK3QioUUsMUHC748TeAOUOuhpox1YpddQDIZs6AGZ8HJ
         uKG+Ek0jo9GVErMeorxbWp7FKdjLIQ4iz9G3Uzqc+EqnKH2DJS6x0vFSWx+Gs47lMARA
         pllTlPWJmAViqJZO0abKhJW3nWGX+dkYsOQJKMfERjwehF8tMBgd/esRVP5N3eJWr4DJ
         zhmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793026068; x=1793630868;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QKdQFJ+FO6S53u4bEibR73jMpDgxkOnbF5dGbreuSCU=;
        b=YZDy3JJHTDGog3M/FChjjENcEcqep1uEpM4Xyf8ivpPGXSU/mF4HA9wa913g1AHMJ3
         BW38tQqj39eM2MXFxXIGwMv6oD5xwiBkn+qd8mIkx5o6IA3JhMQdusXn+NqMwn+9b2WA
         2s6PO24SYm68qgPO/YLmTicCxIoBcjjqbolpAUj7uzm/quVw9yT7NgzQbsUxHoffDkbW
         Uyy6bVLNDw7UqB8GYKXkHd7dOwMzz/iHm1DuGILIn5iW0Ei/aZAPzb/5nGwsD1/5ZlEO
         MCg7XYIkTH0AuD5noTMqI4vm/I+LZ3DrO+fns9tlL9YeSw+iy32ciwdkeuMkbhjjPl7Y
         kXMw==
X-Forwarded-Encrypted: i=1; AKwUvBzBnxpMgjGajV2RoPfYcQZsx8dYLM5QDJWi9ylfDNBw1djhJIo35nyGyFXLvH4yQqf30BAnOSXoSbAu@vger.kernel.org
X-Gm-Message-State: AFq9FYLs4LShKuUTDxUBBVfW3bE3JkjMXuI6YfUQV9JyH4WV+kBawPIM
	SvNY1B21PysjkPV4ti8GukW6XDrhStFzzJDGzMXnuBffoh3n3U4GR7SOqslvdrImYTpjTcPEXcy
	mF2mir6kkOHKkfk58djMJSrGyf+43diW+wQ==
X-Gm-Gg: AYBFou0iozWwEsgxh9ocizIfqTmnV7D1obI/tRTSeoN0XSegHHS3gYmlkojnR7+Zd/a
	2y995lpV4/FOqmeNsfFg9m0uzl+NhfOFiSOXsqXI6XP816hvfC2fHSEN74mPWJml8SqUi9CInZL
	n/HmJhQFsYFKOnmBN1djk59r+yS/6Qqx4X42BkjgZdohFu+V0Yl2h1eep/7YPbmwfPGRJzFWiBs
	oD2tBCWeOU8T4qtdLvDY/3zIvGWI42DjluU9GAX1pUXftYdS8+unfpJfO+fPmZHbwCGduaYKb44
	BAP9YC7CivxFvEjWq36fIeiQTqEEJiD3q2pVt+yRYvOQN9ndRKWc1I7ydAXJH0Ta1lCiGbZXZRI
	EXYXpcQxIcxzNxV9+5ID/LGJpp9TXvLl+NpiIYvp1LPQwZDhfQiDNzcK8RlrxJDoS3/jfVrry6x
	nuwFeTmXnPrr72edDKjPjm3C/cJqqo7PrSpos7jaMBN9nKtKGA+jNYLMn5jw==
X-Received: by 2002:a05:6a21:1bc4:b0:3e0:f6be:1988 with SMTP id
 adf61e73a8af0-3e7cd4d6324mr5359941637.73.1793026067638; Mon, 26 Oct 2026
 07:47:47 -0700 (PDT)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAO-4RZ1ZCPNR2Z4xoHDh0Vp3SO51oX7ojuH0CG4MsD14-RegcA@mail.gmail.com>
 <CADvbK_e+ogH4zafpqz8N=jY-oBruke8OLd4PEz9xa-y13Ys_3g@mail.gmail.com> <CAO-4RZ3_m4BN-+dkGdteAGdUwRHd4SA2pfAD+_+6z+iH+btrHg@mail.gmail.com>
In-Reply-To: <CAO-4RZ3_m4BN-+dkGdteAGdUwRHd4SA2pfAD+_+6z+iH+btrHg@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 26 Oct 2026 10:47:35 -0400
X-Gm-Features: AclHuK-IERqiBgrQvteRGbBqttOJKFiUd95YICzl26fPZNFkD0zcsHfchiXbLiE
Message-ID: <CADvbK_c5HG5hY-RE_YHRyCvUnTLy4taWRGC1PW6OT2rQ7pBocw@mail.gmail.com>
Subject: Re: [BUG] SCTP: KASAN use-after-free in sctp_unpack_cookie with
 fail_skb_realloc (7.3.0)
To: =?UTF-8?B?6ZOu?= <fengaojigui88@gmail.com>
Cc: marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the test.

net-next is closed now, i will prepare a patch for this once it's open.

Thanks.

On Sun, Oct 25, 2026 at 6:56=E2=80=AFAM =E9=93=AE <fengaojigui88@gmail.com>=
 wrote:
>
> Hi Marcelo and Xin,
>
> Thanks for the analysis; that matches what we observe.
>
> We reverted 62b08083ec3d by hand on top of 7.3.0 (the surrounding code ha=
s
> changed since 2006, so we dropped the goto nomem error checks). The three
> sites are sctp_sf_do_5_1D_ce(), sctp_sf_beat_8_3() and
> sctp_sf_do_5_2_4_dupcook(), replacing the pskb_pull()+goto nomem with
> skb_pull():
>
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -751,9 +751,8 @@
>   */
>   chunk->subh.cookie_hdr =3D
>   (struct sctp_signed_cookie *)chunk->skb->data;
> - if (!pskb_pull(chunk->skb, ntohs(chunk->chunk_hdr->length) -
> - sizeof(struct sctp_chunkhdr)))
> - goto nomem;
> + skb_pull(chunk->skb, ntohs(chunk->chunk_hdr->length) -
> + sizeof(struct sctp_chunkhdr));
>
>   /* 5.1 D) Upon reception of the COOKIE ECHO chunk, Endpoint
>   * "Z" will reply with a COOKIE ACK chunk after building a TCB
> @@ -1211,8 +1210,7 @@
>   return sctp_sf_violation_paramlen(net, ep, asoc, type, arg,
>    param_hdr, commands);
>
> - if (!pskb_pull(chunk->skb, paylen))
> - goto nomem;
> + skb_pull(chunk->skb, paylen);
>
>   reply =3D sctp_make_heartbeat_ack(asoc, chunk, param_hdr, paylen);
>   if (!reply)
> @@ -2253,9 +2251,8 @@
>   * are in good shape.
>   */
>   chunk->subh.cookie_hdr =3D (struct sctp_signed_cookie *)chunk->skb->dat=
a;
> - if (!pskb_pull(chunk->skb, ntohs(chunk->chunk_hdr->length) -
> - sizeof(struct sctp_chunkhdr)))
> - goto nomem;
> + skb_pull(chunk->skb, ntohs(chunk->chunk_hdr->length) -
> + sizeof(struct sctp_chunkhdr));
>
>   /* In RFC 2960 5.2.4 3, if both Verification Tags in the State Cookie
>   * of a duplicate COOKIE ECHO match the Verification Tags of the
>
> We rebuilt 7.3.0 with the same configuration (7.3.0-kernsight-kasan #2,
> gcc 11.4.0 Ubuntu 22.04, KASAN/KCOV, CONFIG_FAIL_SKB_REALLOC=3Dy) and re-=
ran the
> same 42-program sequence that triggered the UAF on the unmodified 7.3.0.
>
> Results:
> - Unmodified 7.3.0: the previously recorded run triggered the UAF
>   (1/1), with the first report at t=3D212.7 s.
> - 7.3.0 with the manual revert: both runs completed without panic
>   (2/2), and neither serial log contains the KASAN UAF report.
>
> The same input sequence and fail_nth annotations were used. However,
> removing these pskb_pull() calls changes the fault-injection sequence:
> the reverted runs logged failslab injections instead of the original
> fail_skb_realloc injection. Therefore, these results show that the
> original reproducer no longer triggers the reported UAF after the
> revert; they do not establish equivalent injection coverage.
>
> As you noted, this issue requires CONFIG_FAIL_SKB_REALLOC; our tests enab=
le it.
>
> The revert patch, the two serial/console logs and the syz-execprog output=
s are
> in the repository:
>   https://github.com/Zheng-zheng-codes/sctp-unpack-cookie-repro
>   (see revert-test/)
>
> I can also test the other two paths (5.1D COOKIE_ECHO / HEARTBEAT) or 7.1=
.3 if
> useful.
>
> Best regards,
> Zheng Zheng
