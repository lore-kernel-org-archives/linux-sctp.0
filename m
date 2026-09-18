Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7798D51EDF2
	for <linux-sctp@vger.kernel.org>; Fri, 18 Sep 2026 19:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789759101; cv=pass; b=YCzMyoBlC4weShk64JtiZ/YAdNF1U4cF7qs0MBePGkq+BAJS13AQ6tQPMmd7gmkHtW317d2M/KXXnWEr/ewcFB8O/zepJ7O+2L1nw6G+OvPvGcJ5lNNKPbconazg/HPr8CBHzlrptqSUzDOK+A13ahs05YUCr1y+WIdyugSQxgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789759101; c=relaxed/simple;
	bh=d+XJY6IjEfDw6B+KKS046I9YvRYsBRFL5fcv5i6AeZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/WPJeN6VZJa3DpOFOlE4k+HniZ2al/EmBSBm6zpGlCBbWcvJvhow6AJXoJ+FgbISpWSXikFkE0d6pEA2spzFY4D9U5xcuXybyFS0bXxaWk2op4CjIN65uOagfPJgV8yl8UMmFC/RXIP9341b8avRsBM3Z/vwEhn1kv/NFESCBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i2Pw+oiv; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i2Pw+oiv"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469b35601so725245b3a.3
        for <linux-sctp@vger.kernel.org>; Fri, 18 Sep 2026 12:18:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789759097; cv=none;
        d=google.com; s=arc-20260327;
        b=RIe2iwX9JzSonbx8ffRGwmRYlGPp6kEfmihozH4/wl4tW7IvEMifXh/wtVSGQ/Txus
         ZTMh/uQi+rtZVgHqEW3FT6s4FXMxezIInEKAS1ufz4NpNhbSSvEeZV6FP1uCzOHCjfr5
         XP9lQIMkIvUwe94w3f6MoxTa1Hza0RfYhjqgjNrEs3zGSV9bd6qkNRuK1vx3GDznfGRW
         YVy9JtfuNNK/61e9FIyuCmQUMaNkxVq/PRL+GS1mVCyIoz4L61iH+P+LtqBEzBs1bw4y
         3AvwIy18PDodELjqWU1KcR1yPV496iS3oZ9iU6pdxKO3JaCxMHnQ02lVJiePHyCCC0cx
         1SBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2troVCYCbvQMPjyP8m9Thskq3hQDCRWw6lGuoi8DN70=;
        fh=qpEyoXPQANZqbCrH92q+tLYc9FjbQh2mgjzsn+4geWQ=;
        b=YZe/9MyAviNzmb4hMfZtj4jtDfTC+zPs73Bbw1cgfmyybix9xBgOeR+roMJoKT/KZk
         E2FiUC2szvoGYSap0JoutRhs1cwNcbgqTNBq+T52P7XFkcQnhuBsxAY/ikLZn/BGpqJd
         QyLHGZSs6arLbg40ueKei+RWVZ2wuVWNvj5MdW1r+doZf+9rku7CgYOrcwfkUMUqoLOQ
         A4xiYZCN/2/9A4POwVkgt/nOFEjOvt2wB6cVL5pydnXMu5TRSdvL8uaew4VzPnR6Eoxo
         1ZKW3eVow4vyL7a1T0N/vvtFnrMp+eoWnV5+FcR2aaGvZyuVWfIIcK0VdZKZOdVz23/R
         RVsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789759097; x=1790363897; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2troVCYCbvQMPjyP8m9Thskq3hQDCRWw6lGuoi8DN70=;
        b=i2Pw+oivlDpwZA9WTvtnw+0/1M/n7/s5NjSEjRRbghCeabioGNa59ZCrMZ7Mbv1Je0
         FgXKpuS1E2A1LyIfN/QdEIKFh6qVX7VmE2GCllCGWkqqBZcqEZbOg9fX0dZ1PSAvkz5n
         Om0U0sJOmZoWDnY9nV6RJxQlxCgPj7jeKJwcmOpgajwi2LfynleHOOw5NCfBLATqTrNH
         e39v8RySMTRWQcEF04tDvUmhA++WWH/eYWHOmTs1I/6iKR3haHNE9qE9LWSm8n1zzXVq
         RoUis+EGa7GW0t1IvGlNCghW7Ssl9si39ErvYThos18K21NQdlMcydlxhoxlXxiQlncd
         2uIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789759097; x=1790363897;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2troVCYCbvQMPjyP8m9Thskq3hQDCRWw6lGuoi8DN70=;
        b=xazo2R22s1c/eH/fSG+BQrBQulRvaEqmX2PGw4UEPzKloVvh2lp9yqdQBybTc3xf4y
         MNXHWHZu60Je4VRXstUNZGlnnTrIFHzSXLDAm2ha0q9fQ1s+pAHAIxSEw1qmAq0N4k/6
         2YNDkRO12uls8HHs1ZqNCwqXrvThXIylhxOHmYLTJBNLBKaFWsbK2F+BG7LS21rDWAsL
         TPUm7raNZF+kc9LSmZrzlHIkkSw5vlQ7Xjfy+Vj1aK1NfRnjLq0WdmqV+PXTeRETRXY5
         0oacKfXhMBEOQpl/5RPEMNavnDqIez04BvZDCyVmKSc2zlbM7BKdQaOtRp30Z1M0L+wq
         eOUw==
X-Forwarded-Encrypted: i=1; AKwUvBxcDc7HWl0JRT6ZvgF6TmXAUUOTgjUFxtpH1OgGomzxUyud6WDbK/M/+aamJ6XCS8ZQwot42uBNQ/xb@vger.kernel.org
X-Gm-Message-State: AFuF++lSHVL1l7ZdJ/rr40Irr2wnzKqbND3TIox0Q/bcPzvxc4Mr1E72
	mxRnHpK4gTwqWWbt52KN6ewkfPyY+eZ22B0MdE2g6dcqgovjCyVuTzU/PZBhSarxtOqbjadNPvu
	1nEUQ0h03aM/9zK3OERmfZhkN3Ad6Tw1RdWl0lGs=
X-Gm-Gg: AYBFou2q8yviCJOxjDXjo/AIpY80PAiext7gWOo5yaPn//XFhGlFkLAlQ0E4u8BSGj5
	0hMgJI7SEeq2frKoysiLfm94kbfYWR5Lwkie84HpA/ykeW4a7+pOKmiV8xpaza8y7p3WjkYU9wV
	ZM0M4KdL+5fKVgTMD0nwF7IMGsYig32D5BBiqCQDse7kMuJoR7qp7+p3tKghfpnGY/38l6TduFi
	x8yAb5C6BZ34WmSmk3w/Q2BxaMJ8YayRjhli1vTEq6YuBv9OzmItMB5DlHcwyTf44d2SOAniSnS
	8j+fLc0oy0b9C12VPQGqBSlHvFJp9LDEkaPHxK3Xv5y5TU+N9dGccn9ckBulwqtz2fmpl80EDu4
	PFnAmiC/y7g2hezBUqjn0ZwdO3a3fMi8FWNqTGOkrVPBLdKVFlD6J0j1z
X-Received: by 2002:a05:6a21:a382:b0:3d3:ad3c:49aa with SMTP id
 adf61e73a8af0-3dd8c5161d0mr8117225637.24.1789759097369; Fri, 18 Sep 2026
 12:18:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915095017.942213-1-sunyiqixm@gmail.com>
In-Reply-To: <20260915095017.942213-1-sunyiqixm@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 18 Sep 2026 15:18:05 -0400
X-Gm-Features: AcwNN1X66cAUN51FSkageQ3G0yykNkwaD2lYLObSNsrm0QVEPTOJRupGwVR0DZU
Message-ID: <CADvbK_f2oTzRA4x5+5QsTkKeXAmodgD3Noypi7sULf3-7MKQPA@mail.gmail.com>
Subject: Re: [PATCH v3 net] sctp: avoid livelock while updating retransmit path
To: Yiqi Sun <sunyiqixm@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	stable@vger.kernel.org, sunyiqixm@hotmai.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 5:51=E2=80=AFAM Yiqi Sun <sunyiqixm@gmail.com> wrot=
e:
>
> sctp_assoc_update_retran_path() can loop forever when every remaining
> transport, including retran_path, is SCTP_UNCONFIRMED: the state check
> runs before the wraparound test, so the loop cannot observe that it has
> completed a full pass.
>
> Fix this by considering a transport only when it is not UNCONFIRMED,
> then checking whether the walk has returned to retran_path. This makes
> the full-pass termination independent of the transport state while
> preserving the existing fallback selection semantics.
>
> Also restore the NULL guard around the retran_path assignment. In the
> all-UNCONFIRMED case there is no eligible replacement transport, and
> installing NULL would leave later retransmit-path users and the debug
> print with a NULL path.
>
> Fixes: 4c47af4d5eb2 ("net: sctp: rework multihoming retransmission path s=
election to rfc4960")
> Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
> ---
> Changes in v3:
> - Post as a new, independent thread.
> - Drop quoted review discussion and the reproducer attachment claim from
>   the commit message.
> - Link to v2: https://lore.kernel.org/r/20260902025206.phbpyxmpf4zrtdpx@s=
unyiqi-llm-kernel/
> ---
>  net/sctp/associola.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index c0512c827d0f..4521be3bd85a 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1289,18 +1289,19 @@ void sctp_assoc_update_retran_path(struct sctp_as=
sociation *asoc)
>                 /* Manually skip the head element. */
>                 if (&trans->transports =3D=3D &asoc->peer.transport_addr_=
list)
>                         continue;
> -               if (trans->state =3D=3D SCTP_UNCONFIRMED)
> -                       continue;
> -               trans_next =3D sctp_trans_elect_best(trans, trans_next);
> -               /* Active is good enough for immediate return. */
> -               if (trans_next->state =3D=3D SCTP_ACTIVE)
> -                       break;
> +               if (trans->state !=3D SCTP_UNCONFIRMED) {
> +                       trans_next =3D sctp_trans_elect_best(trans, trans=
_next);
> +                       /* Active is good enough for immediate return. */
> +                       if (trans_next->state =3D=3D SCTP_ACTIVE)
> +                               break;
> +               }
>                 /* We've reached the end, time to update path. */
>                 if (trans =3D=3D asoc->peer.retran_path)
>                         break;
>         }
>
> -       asoc->peer.retran_path =3D trans_next;
> +       if (trans_next)
> +               asoc->peer.retran_path =3D trans_next;
>
>         pr_debug("%s: association:%p updated new path to addr:%pISpc\n",
>                  __func__, asoc, &asoc->peer.retran_path->ipaddr.sa);
> --
> 2.34.1
>
Acked-by: Xin Long <lucien.xin@gmail.com>
