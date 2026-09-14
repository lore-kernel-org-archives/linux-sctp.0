Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C6247ACD4
	for <linux-sctp@vger.kernel.org>; Mon, 14 Sep 2026 14:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789395224; cv=pass; b=Yo+o8lRRwb6gyTH1/WyDgDrZgdmt0+yiSaJK6BqhSAOBkYiI40zOo92onZ2CC1FDzE6Zjmg76Pj4LG3s7GwzdJgHMlZ9pUR0kZz6CfdeYsZqU/DK/udCFjK1kKBlPMBe5RL0N68cAgteNr3vcnNwp5EtvpVGv1XqFYMOQ00CefY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789395224; c=relaxed/simple;
	bh=MC56LfzMCt6fRP9BGhVtIAMB79iWC8di+yYNzRqau0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=peTvaSQYKe2EFlWUYadOPFV4Oe/Pybr5FtMrk+EFXE6l6+oejTSteiKCBljL4IVqN0MHaSOXeMybCXf5V55T2dK3mXvzUTCUE7Hl/pJg7hHlDy55kWR0laVf4Hii8tvi/HNomrAxaZzuSP+DdPSQEyEjBL3SYLNFhbnnPFUJGrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SXte80Yd; arc=pass smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SXte80Yd"
Received: by mail-pz2-f42.google.com with SMTP id d2e1a72fcca58-86dd69a1b15so462118b3a.0
        for <linux-sctp@vger.kernel.org>; Mon, 14 Sep 2026 07:13:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789395222; cv=none;
        d=google.com; s=arc-20260327;
        b=GoMR+M4QROARSNQSpLxI0AODp42gb+MvUkDGs4Pic92Q6e+M4YkwP9S2IYLCIkv4bw
         r6oNEQEslKgoR5ki2QfNyvil0FaskRGgdk3RK9jsWtSOoF2J/S4nXxGZrbxFwIZ2/tvR
         s5/2QeEuABZ73ZSB2LDs/XBUzCnq7FiQvW9WmAX4XpdkY50d6vp3vE3tpbqo3gRwnapQ
         VJkychsCHPo9vk5Q9saLfyizFB41w43IkyBKnb5dbDV4/T5ljntpWCrgYUH7MaE6/O2P
         kp+OJoM++Th6YSrWoEfwoZZve3qFFsBS3D+WTmuraoGYhanZ1z5ROFvrIn3VkVzLwTpU
         2c0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RiYN36uVRN3S+33iMVULloRHEVKnum5eOFw9VkWTBRk=;
        fh=ShvbTciP9yZUm1cbFcv57VAt/i6bOdJei5v69C6B41U=;
        b=hNwcPjMTmSt2zBtY/BM/yTxjsbj8Vi63ZtygWEMI3a86VdgGwCwHAzmEgNiUJNAB5E
         skYpKle9u6I0g63otyjjrjz43OTXG+JliuX1yDVtgeMQXwoGyEgEJLu6y9pcgpUsh4Bt
         6ZEZYVKcIj4wqyvDs3JaGERYdl6Cmpn5wykm1rpEXUDxrjLoRvLUIbfu2PP7C45W54Vm
         TucxgG/mmhMMLtiaDAZh0bCkKCZQBIr4Z6H1ghRTfoDK6fY2Lv9kTvgwr+xWkGkPBO8F
         Cu4k/U10IZ0+Wq1+AyDTRbw/kR4gK1Zzlh+VVFkbwbyQq47QtgD8nsuuM9ocsNp6KMad
         nRtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789395222; x=1790000022; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RiYN36uVRN3S+33iMVULloRHEVKnum5eOFw9VkWTBRk=;
        b=SXte80YdEHZ3OPCjGDoakf31K+yp+wdg+qCiVQ7q90Mm+AtReQYjnYrlHgrI9tN/QZ
         FRkAU0om1GMBDJAbnIyqHZl+UU5vnWPvTBxIQRDg4FukHTw5mDhsalRkMoUsl06kLQ2p
         a6PpAGaID7QBtNJa+3cJ2Snj0Fxa0h4NsX5rWHORNN32u0bx9OcYfQkC6z54XQz3q640
         v1mgXr/7NJv2aPH9uP87sXOhkG9LrCzOcxQiBsJ1AsZMfPmdiyWOKDBFgEjlBmvz+8b6
         DbDh4labc9HBfqG3/baHbBInsZNFFTDkPV8xXSYowhaG4NL7eWIxZ3NiKqpLbttToUD9
         z3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789395222; x=1790000022;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RiYN36uVRN3S+33iMVULloRHEVKnum5eOFw9VkWTBRk=;
        b=et4i36D38hvkH+tI5gcKWqItuAOsHoCqolfg09baX9DbaZrDVfwMWPCMilk5kcwtrq
         5kytNQ5hs8WSWh1wOOu6LLpQZTloZcrSfT1eUqJAi1msiT4J1s1V16NmdOyh3iy+wVpb
         r6EAXcsi+u9fKJD1gYP0rlFXfivTpMQw3RxdJYVXZVkxCK8iZnhUetpjBS7kPulun+vZ
         KbIru/jLt3okH3XtJ0voEaiI8t7/ChBa1UKUFiOuPjzvgrpn/1jTa2snKqyacMy/V9ol
         mdkPesaYVW3ARE/gfyDCCiaO9R3dzBXGqjMj0CQlWDV6lG4LD3kG7kP9b+YCRrlbNt5N
         djDg==
X-Gm-Message-State: AFuF++kh4SPaP51XW8B/w73XRXHnHW6qsP6V3/UCgV7Wb83K1khDFmi7
	WLf2TMrgCNxLxgP6/VkC8WfjuVgOcwfHaW5qM6xVOdwdRwWuU7Nq4NCBd6iDVcPrmdqg6ccupaX
	jL1Q2PAbi0CA99kdASnPNGs3c/ATOnx0=
X-Gm-Gg: AYBFou36hWMLmenEyI9tV62Ggag2qpKVUNNSFzGmASWEtJ+IbTAo09hs2k3nJKsFBso
	PAYxPaC7nbKYzzhHZkgN968TlnrMm8X5pvOqZ6YjeGG1REtwAtJZ9vCzqgVG6WrtXJ6I3v27gtz
	iZRSGuaTe/dYn3zQ/L6Lqun499rS0E0Uz/Afa8JG4YnDrXs9XAWSa5Hp2uGOonlepCa57Luyd8O
	aGD0jkb78VsFgInYmU9LJSG7vPtIVAb+8JDkVUFkH+pVwjOuSHYz/EfbRIl4V0sszmU6h4W/1xJ
	J+wI4/19kO8+znQMFEfsT6vQtOhY2vF962L5LDDpJDXbX576OU+GlD9cKTPeCIoqTqK08Kaxr47
	h+O0QjmX91Mj2Vt0dO0gTkJoUSlAuSaiEnoNHN5QcUDmWwTH63UV3Eg==
X-Received: by 2002:a05:6a00:98e:b0:869:4ab2:8e with SMTP id
 d2e1a72fcca58-86f93cc125emr3520459b3a.7.1789395222076; Mon, 14 Sep 2026
 07:13:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911090039.75646-1-juny24602@gmail.com>
In-Reply-To: <20260911090039.75646-1-juny24602@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 14 Sep 2026 10:13:30 -0400
X-Gm-Features: AcwNN1Vj8GzyWsGKCy4gSL-vBNjPpWPKXvnEtKLMrlOakSBuY2Unq606Yu3xBrE
Message-ID: <CADvbK_f=S-2waid_92PbOCh-LWjU5oiZT+__xWfttVeTHEPQTg@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: keep the association alive across the
 sendmsg connect wait
To: Jun Yang <juny24602@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	Jun Yang <junvyyang@tencent.com>, stable@vger.kernel.org, 
	TencentOS Corvus AI <corvus@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 11, 2026 at 5:00=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrot=
e:
>
> From: Jun Yang <junvyyang@tencent.com>
>
> sctp_wait_for_connect() drops the socket lock while it sleeps.  An
> out-of-the-blue ABORT can then be processed from the socket backlog and
> unlink the association.  If a concurrent shutdown(fd, SHUT_RD)
> sets RCV_SHUTDOWN, the waiter breaks with err =3D=3D 0.  Its final put ca=
n
> then free the association.  sctp_sendmsg_to_asoc() consequently continues
> with a dangling pointer.
>
> An earlier version moved the asoc->base.dead check ahead of the
> RCV_SHUTDOWN break in sctp_wait_for_connect().  That changes behavior for
> the connect() caller of the shared wait helper and reportedly breaks SCTP
> selftests.
>
> Keep the change local to the vulnerable sendmsg caller instead.  Hold an
> extra association reference across sctp_wait_for_connect(), sample
> base.dead while the socket lock is still held, and only then drop the ext=
ra
> reference.  Reject either a wait error or a dead association with the
> existing -ESRCH result.  The extra reference prevents the waiter's
> final put from freeing the object before the check, while the socket lock
> prevents a new teardown between the check and the following send path.
>
> Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_inter=
leave")
> Cc: stable@vger.kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Assisted-by: tencentos-corvus-ai:hy4-preview
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> ---
> v2:
> - Leave sctp_wait_for_connect() unchanged to preserve connect() semantics=
.
> - Hold and validate the association in the sendmsg-only caller.
> - Run the in-tree SCTP VRF selftest and the original reproducer.
>
>  net/sctp/socket.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index c7b9e325e..09fd6b951 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1842,9 +1842,14 @@ static int sctp_sendmsg_to_asoc(struct sctp_associ=
ation *asoc,
>                         goto err;
>
>                 if (asoc->ep->intl_enable) {
> +                       bool dead;
> +
>                         timeo =3D sock_sndtimeo(sk, 0);
> +                       sctp_association_hold(asoc);
>                         err =3D sctp_wait_for_connect(asoc, &timeo);
> -                       if (err) {
> +                       dead =3D asoc->base.dead;
> +                       sctp_association_put(asoc);
> +                       if (err || dead) {
>                                 err =3D -ESRCH;
>                                 goto err;
>                         }
Adding another asoc hold doesn't look nice. Could you try fixing it by
adding sk->sk_shutdown & RCV_SHUTDOWN to this error check, like:

                        err =3D sctp_wait_for_connect(asoc, &timeo);
                        if (err || sk->sk_shutdown & RCV_SHUTDOWN) {
                                err =3D -ESRCH;
                                goto err;
                        }

Thanks.
