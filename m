Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3CF223DD4
	for <linux-sctp@vger.kernel.org>; Fri, 11 Sep 2026 00:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086349; cv=pass; b=dvzX/5anwulLm6Rb5YY1SHrt4EKeaU1y5NhpLqs15JvuabUPwSrdBZcQvdXeOalh3B3BtSYgJwrIKL9cX+BeQHMyIu1Z8W+gbrbi54vmgbvBNU9BLElo9VUykfvRnWaGl3u4j0mR1iUfYTz7r3l1o5YL4f3kB5kWCKri6XJIZ2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086349; c=relaxed/simple;
	bh=uCOZ0LrS3n3H3n+rg4kATp9ASsY5FD80qLKYusb39A0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vs0ZoUzbcSRnRVEmvQrMYyyX+7rP5qD/TkJKK18DuQ1vOBmBobMP+czFADIkAozIVtj8rLoeDEUBbPeic2NKg51hFUFFtPtpUX3xWSxqGcOWHL75Xm32js3c4mXra2BjbL1LoPl8yXKHB7xX+Kb2wyDB2NwchyLs57jR3FIwOwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kWzOrb13; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kWzOrb13"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8558c0b26a8so226696b3a.3
        for <linux-sctp@vger.kernel.org>; Thu, 10 Sep 2026 17:25:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789086347; cv=none;
        d=google.com; s=arc-20260327;
        b=JltXFJCqy6Zg5kIxaHsK2gFjurPR6LMNay1lTx8LTN0qMGu4Ozpt/yy9y2jzOGx1+W
         4IMnuK1uHLVOtfqCdrYC9eZMdl8OWGh+UdyB8WeVRPR2qU3iZnZbUqBHzcupig9ULpn7
         yp9UaqHlIbnY1rsZ9ynHMKwMrp66cm8Vg1zCVp0Bq88jbXbUTb77jZcBmXwiyl4dHuNg
         8ZxMq08pMI/n7/OOtOXFUu/zfMCZSEWYN1oCuEgjL02pu/7ov0qnrsaaejvaIBlaTv+a
         N31uYU9UN0+6oUDiPAOZKbcQj1vMUVFnQcbEwo58PojPoFohXkc82B/IBSMEfhLEZFiE
         kQXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6cY2czYH1vDPyw0bwgbm9H8oNJcDXC0fpW3vN39yQ0g=;
        fh=+v6YRHxGeNNQIJug0O1yCHfPQ9GLGCYruIUafA+naSA=;
        b=gENAbMhqjovsrv4V8ueiyqW49tM9H/JAnrmdON1tUIeGXQ3wgO0rMaljE2zTnMSeP0
         QA5txWBr28tyws0Sn8Yji/mBeAzFb1qS9xmqtZvCKBVOUKxIoa3lyF/HOAC6fiFFSr6v
         b8aULhOVz7x4SvGdr+xSxP+XFqo9Q4K0FVGK+AtDvZQU6XqGhQVHQ94a8C7eFwypGnLS
         M4JF5mCK7GAWUTtnIWpwsHBenpH1GIcoX7YoelWOwmaaugMBCMsUl2f0seBkgO1HtB7e
         BYJOtJWrb6EU0d9h4hMqnC71jMmCX5ZLjOPeRngTCqR3bVEk7BhcTYPACjU8XNYFRync
         2DeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789086347; x=1789691147; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6cY2czYH1vDPyw0bwgbm9H8oNJcDXC0fpW3vN39yQ0g=;
        b=kWzOrb13cmbYUWa5sQN7/F2vv/IT8LFBB5CXPspowCrhWl+5HIhEb8oU9lGqPLFdYG
         X/1vNU6Bo0seVZYkhzo56Dk6Jb30GDAbOA+d7uU6cxUXISlqk7bEtOCrTwFtBUXQ0lso
         yXNj8tV2J8LcLDMz78xWVpUrBzqTlZdWvlk2hz1EX/bZafmiEJDRGnB10M1aN2WpCe7i
         4rwKYBavbaVeiaYahDigksBmVSjjOFwkD298+FoFstnxn3Q/r5umklVz+TJrKYEHOm7n
         6Pk2nqxaFcnLUC7exsJtjqQ9rbsIWn//PfC4u3CLiZk5azYSyYL82NLa8xoF6hjgfkTQ
         fd4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789086347; x=1789691147;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6cY2czYH1vDPyw0bwgbm9H8oNJcDXC0fpW3vN39yQ0g=;
        b=GUgBxyelvaXqAg+X5nuypNqpp9DgYPYMRSxnm9RMrriAArrnf1cQbzuXVj5HhpggwY
         BmmZY5wh9zFMFTnA4SeSoyAA8DW0aC3n1Mt2FnkuTcEmG+yymcyWvwP62BhMfS1DV8FB
         IYD1dHcew9FoWX/TnZq5XCIjzR9w3obDEPkhqy2SKOXa8MXAnkQfssOfzg1+WcOcOwAG
         riFNhW5N63QChjPSXch2A29xV7gzQen6xRKsDhw9lvn2eC3reP1x6HdQWviVdCKVBu+s
         aFuF6LoMNYxFp2uqWoAq17DKBY1w/DUwK33afV6X7HGfuskd/A//vhgUNBV/8CSmVfZY
         M/Cw==
X-Forwarded-Encrypted: i=1; AKwUvBxyRJNDrS9DHBMVPK+Nxm2+cP61jjR6fbdNRkeykeBDEbAIzIqdeRxUpKfcbYY+MaQas7Ztgs1PWVjy@vger.kernel.org
X-Gm-Message-State: AFuF++l3w8CGwGK6OQ4jTT6ArcOVvtQZkPw2/Bc5js+9Fk8oPzz9OArs
	pKPB6Sj5eE/RsyHFXlvrL4E8qPdJUB14+XW4jYMlaQ/15MZ57f3/EZN6/2s9V6rzsF9FjN8o9TW
	4zOInN4WpzLmcdDM1AGPKNv0kNIpyJEU=
X-Gm-Gg: AYBFou1gj5xZHk5kY4AF9Q6ZGcpiLSdo4aAyaUViLEUjvO4EZ/rl05r+7JJDikCDse0
	CZebuvVTqRMyfHDkbMtvjxmifwbdETIcfRrU+ZteKNDRhBgmpdfZs3FkyeVddYJTScqvI7Ow/7S
	A7u4JrhF9T8BN70r2nAjRCzztA6R3GTTrs2iVYLNxC3cytPq+3pBjpfsySpGoryb4f0tkvJt+zl
	LQLn3dRXfHruW61UbRSrTT9heG5p35PfXfGs71b/GyUd2bdgBFNT3Kp3tk0lbA8hpUPvm9cFtkD
	ubspDzmSZnD7haQ8aYwvjUb3VMCluzgJCiCOdJFBqHToNcRKmaarWuIFs+e1eBOKI/dvRz9Xjjg
	WeRqqZhYS8I7m8RPAppKVUgSpehjZTbiNmXnkDZTbdhSVEgCwjvEpQZFUXwHG/lsVFA==
X-Received: by 2002:a05:6a00:3a27:b0:869:9298:ba50 with SMTP id
 d2e1a72fcca58-86b2aad0ec4mr2473923b3a.0.1789086347093; Thu, 10 Sep 2026
 17:25:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADvbK_dFoagLs1c4b-3aFqsbDueu3VO0t-8S93+6GgevuoRBLQ@mail.gmail.com>
 <20260902025206.phbpyxmpf4zrtdpx@sunyiqi-llm-kernel>
In-Reply-To: <20260902025206.phbpyxmpf4zrtdpx@sunyiqi-llm-kernel>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 10 Sep 2026 20:25:35 -0400
X-Gm-Features: AcwNN1XUuVVtdAD4rJUmZCOIjcTX3a30cN5AS0GEJXKtJi13ZMB16vRmNezrcKU
Message-ID: <CADvbK_e-7_aLVKYUr1hogQLJJPGEOCG_HqrTE2+6TFC3Mg=Egw@mail.gmail.com>
Subject: Re: [PATCH v2 net] sctp: avoid livelock while updating retransmit path
To: Yiqi Sun <sunyiqixm@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, 
	marcelo.leitner@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 10:53=E2=80=AFPM Yiqi Sun <sunyiqixm@gmail.com> wrot=
e:
>
> On Thu, Aug 27, 2026 at 3:50 AM, Xin Long wrote:
> > After removing the continue, I think you can keep using
> > if (trans =3D=3D asoc->peer.retran_path) here without 'last' needed.
>
> Yes. The v1 'last' variable was redundant once the SCTP_UNCONFIRMED
> path no longer uses continue. Drop it in this revision and retain the
> original wraparound comparison after the candidate-selection block.
>
> The reproducer is attached.
>
> sctp_assoc_update_retran_path() walks the association transport list
> from the current retransmit path's successor and stops once it reaches
> the current retransmit path again. However, the loop skips transports in
> SCTP_UNCONFIRMED state before checking for the wraparound condition.
>
> This makes the loop non-terminating when the association contains only
> UNCONFIRMED transports at that point and asoc->peer.retran_path is also
> UNCONFIRMED. One way to reach that state is through ASCONF wildcard
> DEL-IP processing after an unconfirmed address is selected as the
> primary transport. sctp_assoc_del_nonprimary_peers() then removes the
> other transports one by one; when removing the current retran_path,
> sctp_assoc_rm_peer() calls sctp_assoc_update_retran_path() before
> unlinking it. If the remaining candidate and the current retran_path are
> both UNCONFIRMED, the loop repeatedly continues before it can observe
> that it has completed a full pass.
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
> Changes in v2:
> - Drop the redundant 'last' variable as suggested by Xin Long.
> - Link to v1: https://lore.kernel.org/r/20260827075006.3979566-1-sunyiqix=
m@gmail.com/
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

Hi Yiqi,

Could you repost the patch in a separate thread without including
the discussion below in the commit message?


    On Thu, Aug 27, 2026 at 3:50 AM, Xin Long wrote:
    > After removing the continue, I think you can keep using
    > if (trans =3D=3D asoc->peer.retran_path) here without 'last' needed.

    Yes. The v1 'last' variable was redundant once the SCTP_UNCONFIRMED
    path no longer uses continue. Drop it in this revision and retain the
    original wraparound comparison after the candidate-selection block.

Thanks.
