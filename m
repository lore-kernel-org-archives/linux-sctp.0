Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691043AFCE3
	for <linux-sctp@vger.kernel.org>; Mon, 10 Aug 2026 13:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786367374; cv=pass; b=Ii+2ARGfGjzk3QqFZ5/2Gm7am+Ggv8nBi51ok7Rfh/1fjySyH6iF4GIUqP0RgddudoHDVEEM6Ja28JzPn5RaR9Y4RdZX9qs/nR7yKJrbHJNXB5YhcJA4FrKn7XJ5Qo8ndDBINsE4YX4QhHBAgvOYDwGCIGyviVo50Y9XFnPa3kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786367374; c=relaxed/simple;
	bh=/OsoJ6WFMuNprCL2My0grk6w6fmGF77nobg7rrCwVqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hB5NATKxUz5HAP51I1WR6bMstlCJSgl/B4tgyxPHWBuDgD47JuZ6yonOsu/6FfCPQkTP0q6NdW020dGdP9z7WlSXepIed9v2n+J9sMLgqu5P6MODnKNISV20Z8fmNtwOdjNDZynncZEXvdHaBeDnSVxida3+avxa+GnrHalLNMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6DnQ0Lz; arc=pass smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6DnQ0Lz"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-74a86e9d4a8so181685137.2
        for <linux-sctp@vger.kernel.org>; Mon, 10 Aug 2026 06:09:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786367371; cv=none;
        d=google.com; s=arc-20260327;
        b=B7biJPL1Q0XYlvanVV4WE2K22rCeQwiko4zSD4RXnLNeF4uWIGIqLU67itGINjzUcJ
         /rrLxfMuztDQ7bXJs0LHeOUohjjBbxn93gJ2R8oh3ci5JFYhkNZmr5aeKs5hpTY+fMeH
         W4DjK/ZlWgqo/6A029UUfJ2UDEtL+SKDKVNF8U2Rv9dvNII9iNUONrGWVo4g7DCncyv3
         BEiia/fEGUs7wCTxsf5ejl2NjmyeHjN8/X8woXLcUHj+a69F/i23xnolph6jGuX/oXvo
         czNyv31ECROVeyH9OHShkbT5nUmD9yprDvXxPwEQtIAV6PfrikOTnAPlnC12t0cJRETw
         HYPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NHKwQBIE8Wzfaah998DNpv9XkkL4runk8ryU+O/Sfu0=;
        fh=3350oIKdy8dKxg7MmFIAO02Ol0LHGu8LHgmKF9Z+lA8=;
        b=CX2M99VzP89WyjR5Xtdf3TNi9moG3uuUyFzBgXXkQUqVgc9cqcXvnspHkoDVrsbwL/
         zQ2Hg9eccv/3YGrLDp3L27cKJvIJ80dPjxdN5yHEcF8rcoNnBnfZq9hZ8y1HXYYM+1Kw
         rHM9oOdxl2toIP0cM1JkOdZ4CRStXUW5pRg7agR3z5Qxi0UfNlocPXqWHySPrJ8Lxne5
         31eH53d0lBdfpX7mDrcBronaHFiMeh8Ls6IvNOtalxgl484M3OLZ6eihrFOF9TDwytrc
         IfY9gkaqwItPLn2h5RkRDZt9YvrcgRGyHSsbtVYdr/GKlAhdALEKi7qwsl0LehK8GcGX
         8thA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786367371; x=1786972171; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NHKwQBIE8Wzfaah998DNpv9XkkL4runk8ryU+O/Sfu0=;
        b=L6DnQ0LzA47xitcNNBNQLWHnYPE19sdz1coiB3IPO/kpJ26H9gBu4G9AZ7fiL6XjDE
         AAzhV7AzPcmm07tYax+nxgWDisgvw/2RPlXmp3NHlPhohLxZvPKDtxxFSxL8on2WFyWk
         HqWfBZZEaH9uOM4WnOKc6jhK8JKhf+iz2Q+cj3isgriqdlHWE3KFEDvpiH7/Jt/pDtC8
         k1s8us28Z0vjE5xFRDx1CcrORzfoepNf1JBHaB22jKwvDobhO2sr81fGA6ef+scx15OG
         TJWMs47plcfp+gnGGL737PS/rf/o1BiqqqEr4f/QFDoVrxNSGIbeLVLwMHtTpCbEnP8p
         UOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786367371; x=1786972171;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NHKwQBIE8Wzfaah998DNpv9XkkL4runk8ryU+O/Sfu0=;
        b=HKWQ7KFGbCslzEJ644d0hhmtO6jYPaDAYBN8OH5E911O+0HNmqoZGUgvBFlpaNgQdw
         Ssg7Zy4r5CUOaFgy1xzqmvdTMTVNQXQIR6MlS0URsdApP2HLCBYhh/EqPUru5+p3eCGn
         rHCG7tUCcFcF1jks4uXEu16bE5QqhSsDgzlA6Bxhb8om75N2Edeh4vDg2o830E+XnIbx
         Wpbx1UuoM6E+ynOPyKVoR36n9AZPePJyXNEh8geFb+vk31uJltyKUUXJ3ZrGPuI6jCYd
         PB0OdSVkunfD6KZLTt0Cn8JAl5bHPHAjgNrGAslhzPp/YVIt6oP8XLYcKBq9rvuWty3O
         nu5A==
X-Gm-Message-State: AOJu0YyQ3b5WNZEJDrilKGbztiXhMOpHu5e6ARildwWPXKbywnBA9gAP
	wvii2BY/xbKKYWqUrUfz59hcaCFgWLMkLaWMgItQGv1BlB2WCCFe8u7DIOpm0KBIfffn8i3/k7S
	LsWc1ShpvCt9XIP4sEnB7dKReEoBmQKE=
X-Gm-Gg: AR+sD109PfWPyu+18o+JOwOZ+0PykMfaATwQhyAGefoASEmiVuOrHukGe+/p9FPurHb
	yr0mwZMyEiB9inuaD7aapSX9/cA+3FPUUMeGPV7RpRsOU9/BR8d9000RDoOo1gnoTayBt9IfDDU
	M+FtMtanxvqqWN2QHilEaGaqce5/TDSiKreKxnxlZ4Nodwdz93O/EBzJiyuZqaAg7yNzkjE9EOl
	4SYFCQaUNwdy1CJZ3TkLvUxG3WGpGanhUPPIhFFibGOZ0iGbN7chVnVsTZwL7wGQG9sEMaRIVqv
	NNDZ6raj7MzvEkbzBSfLL9INWwn3MJwEeiPbAb9rD1oWE08u76Sddmeqjus5bAmuo8k1IDQWEqy
	eOgAK6LF5X48/Hk3O7LH4S7w+UECpeiSMH61A23cCP/BS+Q==
X-Received: by 2002:a05:6102:f84:b0:73a:128b:ea07 with SMTP id
 ada2fe7eead31-760e8f3a718mr10041605137.14.1786367371255; Mon, 10 Aug 2026
 06:09:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260809043806.2768302-1-yangyx22@mails.tsinghua.edu.cn>
In-Reply-To: <20260809043806.2768302-1-yangyx22@mails.tsinghua.edu.cn>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 10 Aug 2026 09:09:15 -0400
X-Gm-Features: AUfX_mzsbeYdYkOlQZHCVgoV17rwfrw_tCfsBSPvbAc2yHIWo94HLmGEcrDrukY
Message-ID: <CADvbK_cv+Wkb5r-8_sGnKsuA5tfErvLoiPZYVN=yXALbWfBOGw@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: fix use-after-free of cached ASCONF chunk
To: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>, Ao Wang <wangao@seu.edu.cn>, 
	Xuewei Feng <fengxw06@126.com>, Qi Li <qli01@tsinghua.edu.cn>, Ke Xu <xuke@tsinghua.edu.cn>, 
	yyxroy22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 9, 2026 at 12:38=E2=80=AFAM Yuxiang Yang
<yangyx22@mails.tsinghua.edu.cn> wrote:
>
> addip_last_asconf caches the outstanding outbound ASCONF chunk. The norma=
l
> ASCONF-ACK completion path releases the chunk and clears the pointer.
>
> However, sctp_asconf_queue_teardown() releases the cached chunk without
> clearing addip_last_asconf. During peer restart handling,
> sctp_sf_do_dupcook_a() queues SCTP_CMD_PURGE_ASCONF_QUEUE, which invokes
> sctp_asconf_queue_teardown() while the association remains alive and leav=
es
> the pointer dangling.
>
> A delayed authenticated ASCONF-ACK can then reach sctp_sf_do_asconf_ack()=
,
> which accesses the stale chunk and passes it to sctp_process_asconf_ack()=
,
> causing a use-after-free and a second release.
>
> Clearing the pointer exposes a race with T4 expiry. Peer restart handling
> queues the timer stop before the purge, but SCTP_CMD_TIMER_STOP uses
> timer_delete(), which does not wait for a callback already running on
> another CPU. Such a callback can reach sctp_sf_t4_timer_expire() after
> the purge and dereference NULL.
>
> Clear addip_last_asconf after releasing the cached chunk, and make
> sctp_sf_t4_timer_expire() consume a stale T4 expiry if no outstanding
> ASCONF remains.
>
> Fixes: a000c01e60e4 ("sctp: stop pending timers and purge queues when pee=
r restart asoc")
> Cc: stable@vger.kernel.org
> Suggested-by: Xin Long <lucien.xin@gmail.com>
> Assisted-by: Claude-Code:GLM-5.2
> Signed-off-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
> ---
> Changes in v3:
> - Resend as a new, independent thread as requested by pv-bot. No code
>   changes.
> - Link to v2:
>   https://lore.kernel.org/netdev/20260808005748.1981039-1-yangyx22@mails.=
tsinghua.edu.cn/
>
> Changes in v2:
> - Guard sctp_sf_t4_timer_expire() against a cleared cached ASCONF pointer=
,
>   as requested by Xin Long.
> - Explain why the T4 callback may run after the restart purge.
>
>  net/sctp/associola.c    | 4 +++-
>  net/sctp/sm_statefuns.c | 6 +++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 5b0ae61..737f8ea 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1713,6 +1713,8 @@ void sctp_asconf_queue_teardown(struct sctp_associa=
tion *asoc)
>         sctp_assoc_free_asconf_queue(asoc);
>
>         /* Free any cached ASCONF chunk. */
> -       if (asoc->addip_last_asconf)
> +       if (asoc->addip_last_asconf) {
>                 sctp_chunk_free(asoc->addip_last_asconf);
> +               asoc->addip_last_asconf =3D NULL;
> +       }
>  }
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 708fa07..3a8e16b 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -6145,8 +6145,12 @@ enum sctp_disposition sctp_sf_t4_timer_expire(
>                                         struct sctp_cmd_seq *commands)
>  {
>         struct sctp_chunk *chunk =3D asoc->addip_last_asconf;
> -       struct sctp_transport *transport =3D chunk->transport;
> +       struct sctp_transport *transport;
> +
> +       if (!chunk)
> +               return SCTP_DISPOSITION_CONSUME;
>
> +       transport =3D chunk->transport;
>         SCTP_INC_STATS(net, SCTP_MIB_T4_RTO_EXPIREDS);
>
>         /* ADDIP 4.1 B1) Increment the error counters and perform path fa=
ilure
> --
> 2.25.1
>

Acked-by: Xin Long <lucien.xin@gmail.com>
