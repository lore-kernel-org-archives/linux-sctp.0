Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568B5416116
	for <linux-sctp@vger.kernel.org>; Thu, 16 Jul 2026 11:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784200375; cv=pass; b=aj2mE9PJ+18vIBKbUse/fjfWZN8JqWPa4AGEKJ0s52uPIHhc7jHEY68Hed4WCCEiXDyeQvBWkqUxLqxs+VEz85UnxWcLZ84dOtwG04H7PC4s7Y0MowpZkOm/NayYuOMB8Mx3L/DZX77qUYFO7vGQimrXSBxsvOxe70mSraCeVhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784200375; c=relaxed/simple;
	bh=2Mf1yi7rcpKQx+KVf6gqOog7j/QWN72FP0RMqbdb1Bs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ph+l+YT6XuD5QYOUrCcU/q/K6YAWVAzjhw8Tc3myHjoKUeweINp+KLLZyIPxCUXUe66uUfjwRto2kw+zmTf10N0qNsjOag71TV5S/iiRYIH7RQYgbtZXAa5NrO/wcb+VB9Ld1WK5A8Y+QQlg2iV1cxT0F2Vfdea3GSlhzNQNchA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GksKhXvt; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GksKhXvt"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b15c6fb864so1708100e87.1
        for <linux-sctp@vger.kernel.org>; Thu, 16 Jul 2026 04:12:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784200369; cv=none;
        d=google.com; s=arc-20260327;
        b=SEqiSmJ5LVbG3Lnr3N1hJSScasZdwKxWTPErCOfQ2P16T/c726rX92W6qxFLKzI39d
         8AjCCGaOfe5kKWU4bxxqnfrTKZ6tvQfS0r3qGqWq4leF75dsKt0nmfAG4lH4DUuqvvlQ
         bYHNTeVXUfO+Ce9pq3r0ygrFizoZ5IKHRSopYs3sn0jS9n0I2pZlbU/IBdvtBORR9B/f
         PEzGp42a/Pnc3Uhgz7BQ7OEscx7KX4YVitNkpxvSod9rPaGjFF9tty4bndzJHlDKVvlC
         H+ugF09HyyllnBaI9zIVl5hD9g9GrdFLGuemxm/3wmLkgXkUJIAxRdbcHGqMgY0eNFdM
         Xeqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t160BcIOQs3DWtYC6cP5bgMx0h1OMSJInLdyfc/dF0g=;
        fh=mQyeAVysHapb8Yaisb3SUumi1LUirULor14PauhV0w0=;
        b=mr0lwLOQFMXaLpoRu8RBlI/tBLH0eNlnF8cczYJVEqwpqP6vXswRp3AEhBap+DmZo/
         5qhwfVFZ9WdHQbwtYvGYdc41ugNAj2uvPrgwq2+XcYmT+cLHXzwtRk23QP25H4eIbMyZ
         xB+YKms7UjeJWfwKQU9+TQv7cQBUhG9Skl5/Eai9DqOqVvB1xf1wCFX7JygEU2/IbII0
         9edggVcEoO30AWqgTdofk7prKQENgQ2mIhJr//wV05xv6hJ75Vohvm9zrighfu7mdqG9
         nob+8JRs48mmYSo83i7gY8qZ4jHI6fu8NmJL/AWu6bbX3HLy0mLbhMG2A47ktAhP4uEe
         da3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784200369; x=1784805169; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t160BcIOQs3DWtYC6cP5bgMx0h1OMSJInLdyfc/dF0g=;
        b=GksKhXvtnwBvUj0gLkAqD11G1Yx5WfhZ+src/qJ3Uv2n44i615qy/aXyNnUaozeBbl
         KuMp5BH99UidbdwkjYxwh3+t3qadzKQVQJKYTbRgZJOcUFcdXcW4+A8xG9RQ1tKw8yd5
         52/KiKkpCnsUh3+Kx4uKQY/ZapBS3qJTSi9WVwBKVodXiEZtJGB/i0uH8tUcVsdibfHe
         eocvyHaOwQKw1obh9+UFHdKOScC7PjpnyOXfIab61Uw5pHHHewGwNMqucA8YS3mBxStH
         GbCD2JZ3TEdhjO9Mdo5A5hT0Q0ztl3y3dopvK3gseZA+o9RHMFNn5jelyywjdv/j9aqf
         greA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784200369; x=1784805169;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t160BcIOQs3DWtYC6cP5bgMx0h1OMSJInLdyfc/dF0g=;
        b=idPBKnbViWIIqhJgHrUhlNM+YzSDEtIyYeCIUZzAJacZK9DwottmMKH/TlF6+uQSks
         NXPC18FNSVUQWd7SRJ/VZ/pvB6d32pLM2nlb/WlDwKqE/Iy4wbF82R/m1h0Us/YGWYou
         8/gKOuLyCdiIi0tt+TywTq0XI+jQNsI3+ZLB6GAPmFvhgovncKnzJSx0AlVMKs/bg7nZ
         i7DjAilSRx4WlJNyHGjK93H0NMEh6xfcyP4BGgmndDeels4ceCLAjKKVVWdt78FX91d0
         cKd7KJyZg7ML8ByAtRs8aaJgj/tYXYy6rspS0RegDYrvRnsmRnYEoDGYgSBaak+kEz1J
         VQCQ==
X-Forwarded-Encrypted: i=1; AHgh+RqaPqWxqiXRCk2TNjHui3xmNASUDfmaGDpb3tsJn7g5GEgpXZ9dmwuTVogzsEIf3y0rSBfwkKU/K4m9@vger.kernel.org
X-Gm-Message-State: AOJu0YwUg+Pigwzuvy/gRqXf8QQEl7pKkkpiZf2BGSLm5itSzDwlvmkL
	Z8FxOkxyBc8+Z9ruwlrx4XaYbnncsE8gK87q9sY7JbfY+jb8uW0W2BGf2ST81/uKTqPOF/9NFUw
	sSYAaDWO4eRe42yfixT27dfJdfLi/T/s=
X-Gm-Gg: AfdE7clNxJ0oy5K4X4pzceCr0iFEGTQzKIf0VIzWBhAYJWAw1Ln9iCBmXgIRoPLtvSi
	278Fvv45nrR070UQNVOa4aeE2q644Gzo9TsEftYJKNyTfIYgyc8ajW3LNlOy68SV6fVWAMRES7F
	wWvoHP6hTnZPs7pg3MOd+V+Ipt3JCI2f2eQUnfJbUdjgNlDuPKu5jxholdc2VdIgh1j5Ss0ALAJ
	z5XpuNzWsomZRW6kT0TqsVqFX3SN5xttHy7dRuhafWUxjsCwTE8ezJqON2O0+SjxLl8Jc0j4/wr
	ykGtEYs7+FOSLZYhglOHQ8cqVDqgXj1vbxnLnpVjRYAw0kjZVFFTToAxBkjg9a6kt2wBoMQn0A5
	AwkOXI2iPFdep
X-Received: by 2002:a05:6512:66da:b0:5b0:1f61:f5e with SMTP id
 2adb3069b0e04-5b15d79d300mr1002660e87.33.1784200368660; Thu, 16 Jul 2026
 04:12:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <80818E6580896D22+20260716091212.43126-1-junvyyang@tencent.com>
In-Reply-To: <80818E6580896D22+20260716091212.43126-1-junvyyang@tencent.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Thu, 16 Jul 2026 13:12:10 +0200
X-Gm-Features: AUfX_mwHCtQnLYHwyJACRbZaSuoOmgR_fxhvzgV2tOwIYEgCwlBYYl3bVBeunEU
Message-ID: <CAL+tcoD_BH0xhyAJ1p=TcX8KW8_heVjN8wHeVwWzkMKS4MMgNA@mail.gmail.com>
Subject: Re: [PATCH] sctp: don't free the ASCONF's own transport in DEL-IP processing
To: =?UTF-8?B?5pyx6ZuA6JOd5YabQUlHQm906YKu566x?= <aigbot@tencent.com>
Cc: netdev@vger.kernel.org, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jun Yang <junvyyang@tencent.com>, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 11:16=E2=80=AFAM =E6=9C=B1=E9=9B=80=E8=93=9D=E5=86=
=9BAIGBot=E9=82=AE=E7=AE=B1 <aigbot@tencent.com> wrote:
>
> sctp_process_asconf() caches the transport the ASCONF chunk is processed
> against in asconf->transport (=3D=3D chunk->transport, set once in sctp_r=
cv()).
> For an ASCONF located through its Address Parameter by
> __sctp_rcv_asconf_lookup(), that cached transport corresponds to the
> Address Parameter, which need not be the packet's source address.
>
> sctp_process_asconf_param() rejects a DEL-IP for the packet source addres=
s
> (ADDIP D8, SCTP_ERROR_DEL_SRC_IP), but nothing protects asconf->transport=
.
> A single ASCONF can therefore carry, in order:
>
>     [Address Parameter L] [DEL-IP L] [DEL-IP 0.0.0.0]
>
> where L differs from the source. The DEL-IP for L passes the D8 check and
> calls sctp_assoc_rm_peer() on the transport that asconf->transport still
> points at, freeing it (RCU-deferred). The following wildcard DEL-IP then
> reuses the now-dangling asconf->transport in sctp_assoc_set_primary() and
> sctp_assoc_del_nonprimary_peers(): set_primary() dereferences the freed
> transport (->ipaddr, ->state) and plants the dangling pointer into
> asoc->peer.primary_path / active_path, and del_nonprimary_peers(), keepin=
g
> only the pointer that is no longer on the list, removes every real
> transport, leaving the association with a transport_count of 0 and
> primary_path/active_path pointing at freed memory.
>
> Reject a DEL-IP that targets the transport the ASCONF is being processed
> against, mirroring the existing source-address guard, so the wildcard
> branch can never reuse a freed transport.
>
> Fixes: 42e30bf3463c ("[SCTP]: Handle the wildcard ADD-IP Address paramete=
r")
> Cc: stable@kernel.org
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> Acked-by: Xin Long <lucien.xin@gmail.com>

It should explicitly target the net branch?

Thanks,
Jason

> ---
>  net/sctp/sm_make_chunk.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 8adac9e0cd66..b14251214896 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3153,6 +3153,12 @@ static __be16 sctp_process_asconf_param(struct sct=
p_association *asoc,
>                 if (!peer)
>                         return SCTP_ERROR_DNS_FAILED;
>
> +               /* Don't free asconf->transport; a later wildcard DEL-IP
> +                * parameter reuses it.
> +                */
> +               if (peer =3D=3D asconf->transport)
> +                       return SCTP_ERROR_DEL_SRC_IP;
> +
>                 sctp_assoc_rm_peer(asoc, peer);
>                 break;
>         case SCTP_PARAM_SET_PRIMARY:
> --
> 2.55.0
>
>
