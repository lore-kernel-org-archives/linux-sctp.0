Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3958345EA2
	for <linux-sctp@vger.kernel.org>; Mon, 17 Aug 2026 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787000093; cv=pass; b=KW36DTEVLKjr2YVnpXL3TPqVARyrAXWL1W0gnTVi41sswSs7f0mmP26Z9BUCFPfp5q3VKvZvbgSRgvwYt6Vg3CNhTNzte4SD7b4EjEOSw0Q/NW2vMnGqwSdylup0uiaLC+co+zy9YLcaMKCu+M737eCtE5B4BI7zZm0X76SHOY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787000093; c=relaxed/simple;
	bh=4zt5jyZW6qLEmymqr6lbsWEB9Oh7ETJPK3ZySvB9Lfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cRCq1cHd0vhAzMkgO/qxL7UDqegxIy/0aSZd3pyRitKHCLjtn3P31NDedy7TwQsj16rFmFysitx28sE4LOqQp9z7XLVp9D/qtxenpppepd+NHtM20bxOf9xyo3Av1AIe5HiBg84NouRmxM+eVAlSgbR+YZfFO/fMtiKgdMGREpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dBsTaV63; arc=pass smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBsTaV63"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84a2dcede83so5313405b3a.3
        for <linux-sctp@vger.kernel.org>; Mon, 17 Aug 2026 13:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787000091; cv=none;
        d=google.com; s=arc-20260327;
        b=IqTnzCKqr4aZjG4nYhQKVIDOtRrK4bHGvfdyd7POMm1IEMpYhNylHI8OlWOIXmz6fa
         F8tW78K5qSUiExjXnJm/Eg+c0ChaeEcW32S7M3pj1aVljnU3Z1eB+ai2pe8xEDTloNUo
         ecr90+OwEylb13uavJ9p9hbBWRJXZPb+Nv0Hxu3jDe/BW414UHHEr+OnyoZr/boU2DuI
         GtPA5FJZ44Qw3z1fZiIH9O/8e1h+rUxydW+tqyt94WcAej+rGLRV5E80cCl3gHI0tWBG
         RH9qnFNIbKDlpf9otgBgqbr/bofRuRbXqfYKH6+Hl27hu5D0w+vDNn+0/6BPoKlWsZo+
         UnNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TZzvkyfzcnxRFEfgSgwbrJFbE3ozE/bmeORKlNaSn9Q=;
        fh=gf/9vvyuE/AzpdRU8CBvcd0V0/grurlRvSje39pMWo0=;
        b=iBaFYJVGn+EOMbm0wgrpcph0CPvZFQCOnDVUzC0xppnPD9pxLu3Sq/j2feDTcyQaQh
         tyQBfAnBQ2thhicJiiZpVMKbCWR8d9KuhSdJXmNOyEykBS7DXFC0mfQ42mEojW7m27Y4
         k94S7LB2GLNEm5hAhIxqNq4YIbJDwOsrqt6e0uubUy2C1HXyy/Qp1k+aH6s6SLpRDUg1
         rl7lHymiKKXDsoB6OHThLg3UnKRO6Jx9dGrHUZi4oDuu3ELjJbEsskI3wtoNCIAOyp4q
         v4eZ4DAQwdRau0+vxF96JDsx0ap6/vurckNBXvFFra/cWuk1wosRVHNPXxtpEVvhu1J1
         AQfA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787000091; x=1787604891; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TZzvkyfzcnxRFEfgSgwbrJFbE3ozE/bmeORKlNaSn9Q=;
        b=dBsTaV63zVdIFsaEf+kB3CdlhRwvunbkEst2jS/In+H8yKtj3FR6d6jOdO7rYlGquw
         5fJdxNfYPfuk5Yg7Pbwyru9sWXao2bBuE8OSf1OB30jDsin6vpRGnpXQQ4NR/a6Xl2vO
         /TrhnxHulvU8ChYV59JiH3gwns8GpqSD9ZkYzKvtDGeBasA0caOU10pAwn9QqV2tRKK+
         wURWtJxSn2zgTx8yFgQBMHpvj27tlCXMSHdyEjfBjCUrIln+qAcmEnm0hBOcBWRUdqVP
         60TUL99CmuhObb3Ss4GCeSE00LfqQSvhUaqQi7bBQhqJog0gs2zbKg6tf9JW9JTIH4ht
         HrSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787000091; x=1787604891;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TZzvkyfzcnxRFEfgSgwbrJFbE3ozE/bmeORKlNaSn9Q=;
        b=mRDzgx56Ee/ec/WKe0YnwV06wt5WdBTSgNelVK1XAfqguVmaaKTTqHuHW+8Cd9g981
         TBe0Ky6BwbyEWo+1JyFklt56Swy7tZGzzklVUh2jwTU0g3/6aZuI+nIChbD3QXdgizQp
         bbgju1EI7SFkDI3KTaoUl3nGi82iinCYvMYCwd452kOmhmtJWNEwO7nr0dNyy8qg5Ya3
         tklfxhBAncnthwToYqZ1N7UEXCREgCtSI9BHROahfMWymB9JYGX1fPFGNkh6UoBRdzDE
         dREFKu4pEhn8a4mKitxDVtvYJEIQmWLbdaR5YXn3umC1OaPHqp3RjIpXWh25HNAN7LaP
         aSjg==
X-Forwarded-Encrypted: i=1; AHgh+RoF86bCo55otlkjkUM+R5MQSg4vfy4h/wly9I03fnPHguRBh4+jPkccWfGHgatL+ufUB2kn3GOAtL2G@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ0yXSkKnwirs3DRrM8wkrFfESVtdIiy6YYiAwkhnLyLtRtPw7
	SDZRiFHv3Y2RizCI/EorYmpeHwGBJihMzAsvWUjNYFoV2EPdyY1fePsX1KmssR1pCeHhjhWyEXK
	MYjvvN5C0ZJSk+CpfP1q40E79qq9j2Zg=
X-Gm-Gg: AR+sD10ZD53U0mjwB6NH0m7q/RWWvLHb0nrCDZAb0DUAV51o5oTcx8C78MiHkkh/Knr
	smIVUjYR5l+3qWxGOAEjkITtBAzn1tCysEgepHVRYJI+Obkf0KVsHGWDtZtEcw1u+iDMBqMLrGO
	aDyXWtlNUBfJyrn74uiw0RGMuRxkwWSze5hFVtyrEdTuNui+ZXxpkUYDDBDVqsK/eEwabQPcVnC
	xP8dw4ICAcyBbxBPeEh8gB10y/zq+PHqHdkQMhgCaPEtjIaOi+h28KtDPdtf4VmL4IzaViuRHl3
	w+z02U2F49eg1CMbhUiv4k9FJzF9hdusgf3u2z3/crzCESwVZfAAa6eP9IVRtgufjppjAnwfPR2
	xurPeCJbxL5ApSBF1aomCEXHDlxrlFLztEuKIRP9q4a0=
X-Received: by 2002:a05:6a00:338f:b0:848:4424:2b8e with SMTP id
 d2e1a72fcca58-84fddf9258fmr28183545b3a.3.1787000091116; Mon, 17 Aug 2026
 13:54:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <an-YYtoqw1QpTXUL@v4bel>
In-Reply-To: <an-YYtoqw1QpTXUL@v4bel>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 Aug 2026 16:54:39 -0400
X-Gm-Features: AcwNN1Wa_-XbpcJpjQ1aDnUYAmjLOxacmUIvkiau5yGSOhYY4ESNLzUUiYe5h0I
Message-ID: <CADvbK_egNorDqoGeHb_wOZ6wVxQ_f_1jFJ5uNvXu93-KAd3rXQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: stop processing a packet once its association
 is deleted
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 6:36=E2=80=AFPM Hyunwoo Kim <imv4bel@gmail.com> wro=
te:
>
> sctp_endpoint_bh_rcv() looks the association up only when chunk->asoc is
> NULL, and caches the result in chunk->asoc and chunk->transport without
> taking a reference.
>
> A packet that matches no association is handed to the endpoint, so a peer
> can bundle COOKIE ECHO, SHUTDOWN and SHUTDOWN ACK in one packet. The
> COOKIE ECHO creates the association, the SHUTDOWN chunk caches it, and
> with the outqueue empty the SHUTDOWN ACK reaches sctp_sf_do_9_2_final(),
> so the association and its transports are freed.
>
> The endpoint loop has no counterpart to the asoc->base.dead check in
> sctp_assoc_bh_rcv(). The next chunk writes to last_time_heard in the free=
d
> transport and is then passed to sctp_do_sm() with the freed association.
> The transport is freed through RCU, so this needs the packet to come off
> the socket backlog, where the loop runs in task context.
>
> The endpoint loop cannot do the same check: it holds no reference on the
> association, so reading asoc->base.dead would itself be a use-after-free.
> Mark the packet for discard in the command interpreter, just before it
> deletes the association. That is also before sctp_inq_free() releases the
> chunk on the association receive path.
>
> sctp_sf_do_5_2_4_dupcook() issues SCTP_CMD_DELETE_TCB for the temporary
> association, while the one the packet belongs to stays alive. A restartin=
g
> peer can bundle DATA behind its COOKIE ECHO, so compare against
> chunk->asoc and leave that case alone.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
>  net/sctp/sm_sideeffect.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 424f10a6fdba9b..94716406d602ce 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -1332,6 +1332,10 @@ static int sctp_cmd_interpreter(enum sctp_event_ty=
pe event_type,
>                                 sctp_outq_uncork(&asoc->outqueue, gfp);
>                                 local_cork =3D 0;
>                         }
> +                       /* No chunk left in this packet may use this asoc=
. */
> +                       if (event_type =3D=3D SCTP_EVENT_T_CHUNK &&
> +                           chunk->asoc =3D=3D asoc)
> +                               chunk->pdiscard =3D 1;
>                         /* Delete the current association.  */
>                         sctp_cmd_delete_tcb(commands, asoc);
>                         asoc =3D NULL;
> --
> 2.43.0
>

Acked-by: Xin Long <lucien.xin@gmail.com>

Note: I don't think the pre-existing issue reported in sashiko-gemini [1]
can be reproduced, as the SCTP GSO packet can never bundle a chunk after
SHUTDOWN_ACK.

[1] https://sashiko.dev/#/patchset/an-YYtoqw1QpTXUL%40v4bel
