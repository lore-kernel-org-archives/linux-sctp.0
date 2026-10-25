Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.72
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792925777;
	b=fOEVj7S+U8GImHT89vZ8YehTGtpI/UmQv2sUX7roBdA6BECASyMWAM1ZmH1c52nhdctN
	 QM0bcXXBGm7ABVrX2aQ7wkN0/xJI3JMUr3KAiZjrlLrRzhfTNoOu/52l+xHPMJXVo2ABH
	 c2N79x1LC7wVBGo6LYX3YHXtlovVzNsAveMDqdaQztzMinpjybf6Zd1SWfrBz44hGl0TR
	 UYUggU2/FHn+biMIqEVE4OCuDV6uwxdB7PcOp1ID51qhBncJjzyc2c1YtGVr2xfOHFBGk
	 R98Xo95j92NdcJG4zC8BwlSGjDkA69F9syVBAin3j9MbA+AD75aI2x5AMQXK9GxjvTA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792925777;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=PQ9oPbDcyFUu9vKXUdSTs+d8wwqivnD6ZFmNWnp5kLo=;
	b=QtsVstq+K8i26CsJkND018QiTCqTIZYAmRNKtEP8weZhQYfjYzw385y2IQKlUF5MkOVo
	 KbiFrmrTkBKTmtLyJKc4I+NCgaABiy19R2JZpmnEgsbnauilmGXDUck48/C4UfTBusUPi
	 /i4sgXQQFCobul6I0MLA7vg/tI69QNQgbBe4q//ySO5U4g4EzbL3EOAUKDEiSrN6GJMJ+
	 6f3nP9NYwOXZoSr5vQXk5Idw9AMo+PtvgaOlZFXnqvbzlbDNzUVXWX8Hdsm84YuHht7qi
	 5n+KT3ZStQzMf6VYhh626QgnJDvPiNuWargctyptl1L5l6NI7PMUaeq+4wOTGLbyjFQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aBsBQbbG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.72
Received: from mail-lr2-f8.google.com (mail-lr2-f8.google.com [74.125.230.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2C1606A31B
	for <linux-sctp@vger.kernel.org>; Sun, 25 Oct 2026 10:56:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B2C1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aBsBQbbG
Received: by mail-lr2-f8.google.com with SMTP id 38308e7fff4ca-3ab28382b92so13112321fa.0
        for <linux-sctp@vger.kernel.org>; Sun, 25 Oct 2026 03:56:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792925775; cv=none;
        d=google.com; s=arc-20260327;
        b=XQ/ddOp2DFG6o+kT0UdvK5H51YhZHItD55wR/0LvFRbcbwpPpDIYT3PFAkNyNfGOVM
         5Ydyzh8LH+oqvpRE+n7KN5qrsOFhaT5ICquyYn+ovBLOk58sOLkiHmFWWmor4FEuZeDv
         afem2VayR5lQ24YfiPZ8up9TDIDlu4SVo+e2CB0XO4N5c+0TVa0c5diiPBMLeA8ybUcJ
         VS8AH+IOuuWSDjRUDDRq0TzXT74rEwuDCz7npB57wve3fPsjPM318sZMlgv6Vodmp7kw
         1wxg57H7OAh5fs1mTaYKjFa+J5WAQwa1PE33VOgz9sifydNHVfe+u1iTj3ZuCc2DH4db
         w87g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=PQ9oPbDcyFUu9vKXUdSTs+d8wwqivnD6ZFmNWnp5kLo=;
        fh=qRn8fpluxFbyJz8DdigLsfXY2WGSuKdSBPeJ5x/xEaQ=;
        b=q0Me0UB5cYuNn3td8Ay14ggbkk1RdgZcim9ybYP2mlE4tqDXGpGSgk9GaluuLSZTyu
         PBA92EcLFzKR2LJLa26SaOJaoMFLPSM+GsdQsU+wrzaNArnxCZygH1MyjXilaEW3jfeY
         pFdWM/uaMEx3gAPPsfn4CbuzQ7ZTeXsacAO/RrJPL4UHI/MtizhUL2rPZVKLckZMKIH8
         37GfuTdCG3TCfsxKT25Wf29MGVjaF+AlZDOctQuRT2O/YSj7UO5+mLDv6pLDaunmch9W
         3uU7slQRvRczXg5NlEmccuy+DFyz8LkZ2htMkIWiGlEBXmqUMoBMNwPz7db54z726XCv
         nHCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792925775; x=1793530575; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PQ9oPbDcyFUu9vKXUdSTs+d8wwqivnD6ZFmNWnp5kLo=;
        b=aBsBQbbGrR5oIcMkRpjhIJOCRIj0IBNpXKDrD9zx6fjxtqAjanBd8Os8H1+r/zx4xl
         6+d9iCDWj/+HcSqnEi5qIBrwLPwFKxrm2Z4z8DNQ6nYnOI2+JfH07UoDN719vncV98CI
         Gb0i+IhAzhpM3ubcWw1leJy/SqXVZy5Bo9MphwDvPUdirxwG8qsXq4EHsJKd3yuj4puY
         AP+aDID/3bVQoeMc2hu7+IJytNzYAFpiGaKEu6W/cCARUEAteXrW0q1ieeacIrAP61Tw
         fLiyUBmegszzpiqM9eBq0VC4YUVJdYtl8hjrr9hie3DXXg03neioxurhKqjl2HANR2eO
         zuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792925775; x=1793530575;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PQ9oPbDcyFUu9vKXUdSTs+d8wwqivnD6ZFmNWnp5kLo=;
        b=Fm2CqPZ4bxOVc58MNNrQtKA882pvb55ED6OY/CA+N+iK6BrGLObSGCBi7/lXeb5wWh
         B3jQlb0nFk5354PbBmW2G5jhDQKF0BwULVGYPiPKDmCrBn2MrgIMYbFL7eIHDdpcdn9v
         ISBrEZAI+zn7jROWGbIaBMuV2DvRtEJstXTZ+s7gc/asbTIdu65KDDV9pL79YWK44KEN
         dNvxhQMIhaNbHEtw2QSqYuzY7NGhFrak2ckDKpXcyyjx77EGxoC5U76Bx6EphOm+5Bxj
         qimP3dlwBbpLqZJKDD2n//bO6G9WjeNBUL5QLiTN8w8JMir/1kGdN98OryPzc8nR/Non
         cugg==
X-Forwarded-Encrypted: i=1; AKwUvBxg2+zZQijGo0Puty9ZVWQuqQNowSI9GS1yAFPISTbu+R8E84k3r44AGioK3KKNtR9IA8G3GOPU7FQ6@vger.kernel.org
X-Gm-Message-State: AFq9FYLWp0CZocp8hVc+Bv0sGJpCUcw6izoe2PUoyf55o4SreIWAxslq
	7hTx8Co9ddPmu4JLoC87kx92p3TcSqQEMcOb8MIml8vuPSGnoV2TYU6BzK2nh6qTHCF4oVejCL4
	FEI3wgiRBr8ohwTUrFPRsL06RNbwaATY=
X-Gm-Gg: AYBFou2gLORn8HlaRRactqyswv33g8OXBPhqkMfoyJs/UN4SfpH8DQUqxE2JbBtLWoH
	92ivGzbttgHsDiXbQyf9cLar7A8X13U08bNBqle3WOXDiYs5tJSP+pGOpq97hvArDI/lmWS7XoT
	Sy30tRw3uY5byH6mCKDzlcXQkQ+I2H0tgRNtkHeai4G5fzbKPLZ46omA7RQZmRReCWw04/tooy2
	bsmROuo0EDVtTAtiJmoDMl8g/5eutokERXCExZK4TW+NtDdJKnZ1CDADc+l7Mt6MTo8MqIIh7qG
	JOihMaEq52tytffjky5j64PindLiZAQneGyHcx98k6KwcGAfX/4roqEb9DadNDcuU7ccOV9Q+JC
	+td8s88fAKFRQYFqOzWq/9ss/LunG5vmzNJCkvA==
X-Received: by 2002:a05:651c:1a08:b0:3ab:1532:1d71 with SMTP id
 38308e7fff4ca-3ac6fd438c8mr9891841fa.23.1792925774545; Sun, 25 Oct 2026
 03:56:14 -0700 (PDT)
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
 <CADvbK_e+ogH4zafpqz8N=jY-oBruke8OLd4PEz9xa-y13Ys_3g@mail.gmail.com>
In-Reply-To: <CADvbK_e+ogH4zafpqz8N=jY-oBruke8OLd4PEz9xa-y13Ys_3g@mail.gmail.com>
From: =?UTF-8?B?6ZOu?= <fengaojigui88@gmail.com>
Date: Sun, 25 Oct 2026 18:56:02 +0800
X-Gm-Features: AclHuK-trGKoI9DjC2wqpShC4KLQ6ZGpweFu80pdhBG5d1lHmaC4sUY362mgIH4
Message-ID: <CAO-4RZ3_m4BN-+dkGdteAGdUwRHd4SA2pfAD+_+6z+iH+btrHg@mail.gmail.com>
Subject: Re: [BUG] SCTP: KASAN use-after-free in sctp_unpack_cookie with
 fail_skb_realloc (7.3.0)
To: Xin Long <lucien.xin@gmail.com>
Cc: marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marcelo and Xin,

Thanks for the analysis; that matches what we observe.

We reverted 62b08083ec3d by hand on top of 7.3.0 (the surrounding code has
changed since 2006, so we dropped the goto nomem error checks). The three
sites are sctp_sf_do_5_1D_ce(), sctp_sf_beat_8_3() and
sctp_sf_do_5_2_4_dupcook(), replacing the pskb_pull()+goto nomem with
skb_pull():

--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -751,9 +751,8 @@
  */
  chunk->subh.cookie_hdr =
  (struct sctp_signed_cookie *)chunk->skb->data;
- if (!pskb_pull(chunk->skb, ntohs(chunk->chunk_hdr->length) -
- sizeof(struct sctp_chunkhdr)))
- goto nomem;
+ skb_pull(chunk->skb, ntohs(chunk->chunk_hdr->length) -
+ sizeof(struct sctp_chunkhdr));

  /* 5.1 D) Upon reception of the COOKIE ECHO chunk, Endpoint
  * "Z" will reply with a COOKIE ACK chunk after building a TCB
@@ -1211,8 +1210,7 @@
  return sctp_sf_violation_paramlen(net, ep, asoc, type, arg,
   param_hdr, commands);

- if (!pskb_pull(chunk->skb, paylen))
- goto nomem;
+ skb_pull(chunk->skb, paylen);

  reply = sctp_make_heartbeat_ack(asoc, chunk, param_hdr, paylen);
  if (!reply)
@@ -2253,9 +2251,8 @@
  * are in good shape.
  */
  chunk->subh.cookie_hdr = (struct sctp_signed_cookie *)chunk->skb->data;
- if (!pskb_pull(chunk->skb, ntohs(chunk->chunk_hdr->length) -
- sizeof(struct sctp_chunkhdr)))
- goto nomem;
+ skb_pull(chunk->skb, ntohs(chunk->chunk_hdr->length) -
+ sizeof(struct sctp_chunkhdr));

  /* In RFC 2960 5.2.4 3, if both Verification Tags in the State Cookie
  * of a duplicate COOKIE ECHO match the Verification Tags of the

We rebuilt 7.3.0 with the same configuration (7.3.0-kernsight-kasan #2,
gcc 11.4.0 Ubuntu 22.04, KASAN/KCOV, CONFIG_FAIL_SKB_REALLOC=y) and re-ran the
same 42-program sequence that triggered the UAF on the unmodified 7.3.0.

Results:
- Unmodified 7.3.0: the previously recorded run triggered the UAF
  (1/1), with the first report at t=212.7 s.
- 7.3.0 with the manual revert: both runs completed without panic
  (2/2), and neither serial log contains the KASAN UAF report.

The same input sequence and fail_nth annotations were used. However,
removing these pskb_pull() calls changes the fault-injection sequence:
the reverted runs logged failslab injections instead of the original
fail_skb_realloc injection. Therefore, these results show that the
original reproducer no longer triggers the reported UAF after the
revert; they do not establish equivalent injection coverage.

As you noted, this issue requires CONFIG_FAIL_SKB_REALLOC; our tests enable it.

The revert patch, the two serial/console logs and the syz-execprog outputs are
in the repository:
  https://github.com/Zheng-zheng-codes/sctp-unpack-cookie-repro
  (see revert-test/)

I can also test the other two paths (5.1D COOKIE_ECHO / HEARTBEAT) or 7.1.3 if
useful.

Best regards,
Zheng Zheng
