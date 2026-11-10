Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794323472;
	b=YK88rp5yoRdzcsJ5VWyWOgv42W2EDDceA7tyczRu8l39YMO80XaLWTW13nzIiTc+6pcu
	 sSVlU6U5e1nM1r/38i+2hwnHpGXYnUHEAOBSI5ehqxpwjKhxyQAEDucVDzs783EZM5hss
	 LVbJySTwyOXPgKN1zTEtm79fNbTbd9WTQNwTW6PfhUdgJ6v/jzJIazRy7qjjhg4jobKeE
	 HfOQl3v0FmiH6vJYuTjDNdJfdHbeDwq8iIRNyHmh9c1I7plUbmdAbSenS6rwxEU14qhaI
	 n+FG2Bl/D615sAiAUBiFrR8H+Rv2j5sXJB/ctmi4YDQEKrJmAe/2qtZ0C28BfcyZKlw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323472;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=W6z7e3dW4mp2FHGp4Wv7zZVkrXVosanAgrqH1yhT3tk=;
	b=Vd8jUtFGugXeknHoRLmuMGipCS4JGQxtCJ7VFcdC7+KZkW2aNi5cT0LHj/Z+amc+qi3h
	 yPucIyHRHdsc050Dy4BVm8M6Xh0/qPKjw0aY7exO6kKCyyb9qEv1XLEPyRDkaI2gysDjE
	 v9I3gwMAtGNqiZ8futdgW8Pseq82LVx1bho1ta6YqJFbZ3JMqZTnmTK23yL6ScCYV4Dzk
	 6c65b0tITyOTBZxgfQZff7Gh9AQI9dDX2Ywu9eAlSuLZHpo0N0379aefsWZuEn0fjbrYT
	 MDdBGKkk5zrm0D0YNCVgcFrOB/1XLmgZIzUgQYdTnU4Ns2pDvofEeHC5G5v/tufVxkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R3mOPevA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.182
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678CF606A321
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 15:11:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 678CF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R3mOPevA
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5e948e56af3so798745e0c.2
        for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 07:11:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794323471; cv=none;
        d=google.com; s=arc-20260327;
        b=pkYEgX2jUuDVCR6y3tWgQlGHmWugAS4rQ1WcFz7JNyPHQeas9+avSm8ue0+R4XJHB+
         +JawWzJSeTlLUubAQH3bMG3dbtvjUZbsXfU15bEyN2wleJbNAhKjUCorvCcS1CcZ18Bb
         nWjtR9pqb73h9iTch/4u7I5cb90u1hRDeq35BYt0nOmdHw0s2oXkz4EriUyg0Ci/lvwb
         Hk8cwWDwy2qRe37F2ekjyoJk4S16KchUwmuPwrdoTsyE2NT31bEztKsO+zzB+YHLK5oZ
         RHS7Fl1ziiQGWYqgUpBcCi533dHVREk8qIKMdKBW06/D8LQFTbEQuY7smTwNqpzpc3xW
         5G/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W6z7e3dW4mp2FHGp4Wv7zZVkrXVosanAgrqH1yhT3tk=;
        fh=4wKtRrWB8zi6QQ2lJBb5G1yvz/ZvHJg7SDd9Fc61LFE=;
        b=fdHxem9fFw7yDDIUGhlq+XrlZTa3BkHXiiWptDd8L2eoQD2bSzLupiU28Agl2ciXkj
         c4HhSaq6HC7U//i7eDxFNjs4Tu5IsfKJqh1SonvP7hKzhC5wzScHhXxnTITih3+Znikf
         C17UYfpXJ5BDeDOvJyc9pvdPCyFs14GF6mu8bLzGdeypFLQj4SpESrFvquTuTkZfg1mV
         N0/4CmMoXnVR+il34fOaRkifuqlMZhnzaYf6ivMTLi92QszsGxRx3uKqcY3qJqtbKopD
         BzCHwGTjew24rK02+jJUk+f77MTFUMQPByfhGpBGq+QZ3siUMxSgWEE/lzljIzhPUbrX
         RjxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323471; x=1794928271; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W6z7e3dW4mp2FHGp4Wv7zZVkrXVosanAgrqH1yhT3tk=;
        b=R3mOPevAZ7M3aSBnsKq16hoySYLGfaI5yJUCH5GXNQs1FM29zQSTv1h/jQxwUzRjLH
         Ok6NGMWWQqBsR+BlbsSH8zfsFYjtYet8HABNxpsL1sDH0s/r4cKapFMvOq0ae2Oj5qBf
         zbTwXS1Aqfmx+A1DceEEORM9jXM4/qZLxaiuqX2dJZedD93VDszsRu6Tvb/+BMBiUapX
         AULumKrUlz9KgwMJ1985fLoNUkrLz+6rFmK2XrMvcHMEHsyOYgtHt2M8zfRsZpXJk+IQ
         910iyXRqof8fCk+/21+4chNobdOhcfbhvH9ppdp+QCfMVAv7Vgxds+i8gVShrbDOPQ5H
         /4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323471; x=1794928271;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W6z7e3dW4mp2FHGp4Wv7zZVkrXVosanAgrqH1yhT3tk=;
        b=uElXw1IQn0fCq7rLSfFHQsiS/v4kPzhVlLDRzfvejMPkRoChuJ2Udh+MZJf4HPGfxY
         bnLNt5gu3TJ+tpvxnZJBm1qPay6H46DsArFZ1+wtgAo4Alvp3lpSz723HCr9OXbskGPa
         QWdY/TXRKsn+g9WzXsCHT/fIoBM9xO0k0Q6O6VgN1i35QAKTjjQIOU+rxosqNja4x55N
         lDg2S7cy3rZN5L9JgDH8SE+b9W/dAoBFyVzhOBdwIRNb9R4mqWzaHcxQas3Z/AixpR0f
         E92MwjHDN4ZZxR7ycfcOD+VIQmWOMSTdV9Uob4EsffTPh1Qx1cX+qOv+OriY6FJeFM3W
         9oJA==
X-Forwarded-Encrypted: i=1; AL+hErHAvDoLXvekBlXJgZEvWtsL8qxe5YaBlzl4CpqBTWLS/idjMWAot+yM+WINsFIss8JmoVGYpReQ4WND@vger.kernel.org
X-Gm-Message-State: APuU4Z/hlF5I5IekmhLv5EGnczlDRdrnf72otGE4s2c9erP/EmxOA+JI
	B7lIhYyZHHTAeIn96phNtslajZxhmT2ddOQX1WXRf+buCw/hlvoSJUekcgrbSrToCTCLbfTdj19
	bAvda9oWbj534qHsrnwnBG7aERHfycd6Gn228cGg=
X-Gm-Gg: AYBFou1M20LGcU4LtSePxnU0urQfNnN40z6KA+zOVGfNZtpjhCqdqVfv1dC4H1iaFaF
	0yNVHWv0vyH6pfKi4LRB0THY+d1qmg8UQfkxss/oXGFNoptHxUiGAuzFZAJF6dk10OIP9YOfTdK
	qTr6o93DvAGkJyGps7oZlFf0bblE3sKcaE63DSYLBYHZKquun/mBBIStB78Vxf1787jNHpVg1YT
	z2Q5B52mwETDNw3jzgNMaXnZtmYYo8K8pmZ1Gc/pe2mG6VHitzkmoabX6k/i9bk9skyGTvWdBYU
	nqyJ98G9J2RIS4EaOZ9zphN3kdAN0cONZD4mnauBwTf9nbqql9o9+o09hmSD9ONqfAnPotT2y6S
	bfnc/9EDKSYpokT4lWh8mNtAJuB50ak6M4b+oxfOiUaFEIkh1CG+XGw3eYiJXKeYOvzL0EGFQLx
	mPc7rQ6N6ui1IZVqj0nK7k2/ehrgOy0+khHV0chA==
X-Received: by 2002:a05:6122:208a:b0:5ea:c214:b5cf with SMTP id
 71dfb90a1353d-5ee0cf0d54emr1101844e0c.1.1794323471135; Tue, 10 Nov 2026
 07:11:11 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104105507.62743-1-juny24602@gmail.com> <179413871612.994134.359540125574426236@kernel.org>
In-Reply-To: <179413871612.994134.359540125574426236@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Nov 2026 10:10:58 -0500
X-Gm-Features: AclHuK89HgIbQyXWmaLQCesjdGtHdS-e5P_FfWBaym-EosoON5UnawsVLzWAcXE
Message-ID: <CADvbK_fUOSLtD2=r2UUU+YLCVCEOPYpH+S9Pnc12oO_YjjfHOg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: preserve stream scheduler across outq teardown
To: netdev-bot+sashiko@kernel.org
Cc: juny24602@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, junvyyang@tencent.com, 
	stable@kernel.org, corvus@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 8, 2026 at 6:51=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wrot=
e:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] The patch changes how outqueue teardown behaves in the common
>   case, and the commit message does not say so.
>
> --
>
> sctp: preserve stream scheduler across outq teardown
>
> This patch keeps q->sched in sctp_outq_init() across the memset, so that
> sctp_sched_set_sched() can free the old scheduler's per-stream state when
> sctp_outq_teardown() reinitializes a live outqueue. Without that,
> installing a different default scheduler could read stale data through
> the shared union in struct sctp_stream_out_ext.
>
> > diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> > index e92fb9da4647a..6cb4b4339d8b7 100644
> > --- a/net/sctp/outqueue.c
> > +++ b/net/sctp/outqueue.c
> > @@ -190,9 +190,13 @@ static inline int sctp_cacc_skip(struct sctp_trans=
port *primary,
> >   */
> >  void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q=
)
> >  {
> > +     const struct sctp_sched_ops *sched =3D q->sched;
> > +
> >       memset(q, 0, sizeof(struct sctp_outq));
> >
> >       q->asoc =3D asoc;
> > +     /* Retain the scheduler to allow freeing its per-stream state. */
> > +     q->sched =3D sched;
>
> [Severity: Medium]
> The commit message only talks about the case where the installed schedule=
r
> differs from sctp_sk(sk)->default_ss. Does this also change behaviour in
> the more common case, where the two are the same?
>
> Before this patch, q->sched was NULL after the memset. That meant
> sctp_sched_set_sched() never took its early return, and every outqueue
> purge ran n->init() and n->init_sid() on each stream:
>
> net/sctp/stream_sched.c:sctp_sched_set_sched() {
>     ...
>         n =3D sctp_sched_ops[sched];
>         if (old =3D=3D n)
>                 return ret;
>     ...
>         n->init(&asoc->stream);
>         for (i =3D 0; i < asoc->stream.outcnt; i++) {
>                 ...
>                 ret =3D n->init_sid(&asoc->stream, i, GFP_ATOMIC);
>     ...
> }
>
> With q->sched kept, old =3D=3D n whenever default_ss matches the installe=
d
> scheduler, so the per-stream reset is skipped. The init_sid callbacks tha=
t
> no longer run on teardown are:
>
> net/sctp/stream_sched_prio.c:sctp_sched_prio_init_sid() {
>         ...
>         return sctp_sched_prio_set(stream, sid, 0, gfp);
> }
>
> net/sctp/stream_sched_fc.c:sctp_sched_fc_init_sid() {
>         ...
>         soute->fc_length =3D 0;
>         soute->fc_weight =3D 1;
>         ...
> }
>
> As a result, PRIO priorities and WFQ weights set through
> SCTP_STREAM_SCHEDULER_VALUE now survive a peer restart and a stale-cookie
> retry. Previously both paths reset them to 0 and 1:
>
> sctp_sf_do_dupcook_a() / sctp_sf_do_5_2_6_stale()
>   -> SCTP_CMD_PURGE_OUTQUEUE
>     -> sctp_outq_teardown()
>       -> sctp_outq_init()
>         -> sctp_sched_set_sched()   /* returns early, old =3D=3D n */
>
> For FC and WFQ there is a second effect. __sctp_outq_teardown() calls
> sctp_sched_dequeue_done() on every leftover data chunk it discards:
>
> net/sctp/outqueue.c:__sctp_outq_teardown() {
>     ...
>         while ((chunk =3D sctp_outq_dequeue_data(q)) !=3D NULL) {
>                 sctp_sched_dequeue_done(q, chunk);
>
>                 /* Mark as send failure. */
>                 sctp_chunk_fail(chunk, q->error);
>     ...
> }
>
> sctp_sched_fc_dequeue_done() then adds ch->skb->len to soute->fc_length.
> That used to be cleared by init_sid. Now it isn't, so a stream with a
> large unsent backlog at restart begins the restarted association with
> fc_length inflated by bytes that were never sent.
>
That's expected. purged chunks were queued on those streams,
so the fc_length stays consistent and converges as new data flows.

You may just need to mention it in the commit message when
addressing my last comment.

Thanks.

> Keeping the user-configured values may well be the preferred behaviour.
> Since this is going to stable, could the commit message describe it? If
> it isn't intended, should teardown reset the per-stream scheduler state
> explicitly, or at least the fc_length accumulated from discarded chunks?
>
> >       INIT_LIST_HEAD(&q->out_chunk_list);
> >       INIT_LIST_HEAD(&q->control_chunk_list);
> >       INIT_LIST_HEAD(&q->retransmit);
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20261104105507.62743-1-juny24602%40gmail.com
