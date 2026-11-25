Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795629035;
	b=KzXI+VI3J4+P9j+47HO6SYWLWoajkUdNNMkrzIU2oIIwq1r4uc3taNhULjY/dmI6Y4la
	 scK7X8Vyn2sYoVznF4tOrCI5Ji7KGPSwS/dJ2gD7OCcb9LFsovKE3JOvH+TEs6Oywzlem
	 X+AcQ3jnxhse9dZ54tY9m5flejp2PgKAWunC4LMdlYjS6pyf3jlIAWcZdvPl/HMd1GEMl
	 7pfGQHdw4KdbAh+BBo56HH5aNZCc6JOW9Hkal7OPCWxw+pPV8kbVQe4PPZA1h4sVmtBZf
	 m9VqmrbMxA5EMiRc856nG9W8c5/Pi9R2HGAc4v2eLElX/WAxyaFo4rzt52/KNqWzNkA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629035;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=RfPxo/aBNHz+uEsj4QdIP7gFGpuoo0qtgUa4pVHLuDE=;
	b=wK0fXRPv+3S+e9o/KAvfkfVtgVvAm5uETBNKF3HXJxHUfsjFbNSAAYx0xV6se4uriqVM
	 vuiwlz8gcbX6ZWJF/AV7LRTHcqWoUG5oRuZBTdjHs/ibTwdU+xqG3d5PNyhpnDKiROZ+w
	 pJKZJflwgy9ke1CWw1+NZqnOa9j53ONBsbysN3eW06E4oKk4SQbRSziMPmL5VwK34LjYq
	 NdREne9Bul6NoSa6Zbawz30Q/a7mwl8dAwjikn5cLL78cltBQ3Niv71mzLN5vFi/C/Ey1
	 l9qD6JU9eiKL2dEv+G18f6rN/jFiBfQ1fmaC0cLeDURtCuxYT2+IjxbZBaOb0De9mjA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RzrnzIOd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD306606A32C
	for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 17:50:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD306606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RzrnzIOd
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a4c72951b8so3924629b3a.3
        for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 09:50:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795629034; cv=none;
        d=google.com; s=arc-20260327;
        b=Uegf4MvM2CjNRF0gQVn/iQ+VnFPimHagI9qTRnwtUtyLJeRQgIwF77ghCoiOCI2XUy
         hEtC7GxLxmHzaMBosZulbrJ/P48a6GeQVSBm7lXZA7pW9tf6zXWwgqbXv7hlICiKTtdQ
         2dcVRM9JjieQhrLKEgAnv+vRlvRzCoq5zsXvpY6E5WpVu3Pwo5ad4vSJtVPiT39UJsEa
         qzaJv6svFPcliOXmuqgEzVQ/w+u3N2ycrQM6NdhjP/SOdeaGSNIwlazhAkqgz5652Srk
         1Ip1el+jJWlA7HtZzUVpKOmUsFuBEWs6ZyctpenrzBfqUnP0d6a/GubbeAozPEetHdaS
         Nk1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RfPxo/aBNHz+uEsj4QdIP7gFGpuoo0qtgUa4pVHLuDE=;
        fh=3N7IRt911rqMpRPcIQv9oNoWbiljPaJOEzN6v7Mvw+g=;
        b=l1IlvFdbATExRrYO5uLvsZcDGAaNIHaavkbmwyu5xbcjyBlHKoKueDiK9y85mSemPo
         ORTYRLKmIMALpmczTpmlsLOl72liimrA4k7UxaSVAuxNB10EhFnP84qF9xZ+8rFjs8EW
         04QRQgPr6zplmv8NeHOZeNo/EyyxE38h808qy9vcemKxbf/etGhs2sVl7jQ1YovQji91
         b+bCZMl0sNMqGI3VW1rdVZWNb2B/wid/kZPDrWY2OPtPTjhqvPrLhDB0TNfa9wd4SDsM
         gqdtZCe7YPB2Lz5HL+owyFqsmk85ldEpwpH2eET59lGnLvYjP5EgdBhgwwjtcLW0lT+y
         DVOg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795629034; x=1796233834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RfPxo/aBNHz+uEsj4QdIP7gFGpuoo0qtgUa4pVHLuDE=;
        b=RzrnzIOddMSy0/gtb8UILgu3s7kq+AW6xMj8vnNYFlLsUstmpxo2bu+ZL/+t6ZA395
         ZgNjTGGZS8Iis6a1xMG3pPHiF2pS+lzMfEdajHXNHC5vIkDtY1ektkGYxh8fsCEalPl9
         bjMP/hJ7scXuutgpkiha1/sTpcU04wlV7ZKqA0HzLXF7oLzTSRsn+6PhBIY/WfOIKf4E
         iqJq81myqrwEybsZpA0H1mbCincek5Sez0jIQsuMApfR3WrPaLdWWts4UzTTARM+UOKF
         1VJYEVYhGBCh8rM6LzVZGGxsitpbmTDtypVh4HvV2IdxbHox3ImYtRQggVwFMdKbuohZ
         5e7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795629034; x=1796233834;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RfPxo/aBNHz+uEsj4QdIP7gFGpuoo0qtgUa4pVHLuDE=;
        b=O8cVeRSFISlK6sDx4v81uXKes4e1MW+ucQF3kAXjyZ1+VT0KqyavFef2WycruF5xTn
         Eb8TAswN928OL2NXC94aMFfE+zMxwQEemSJC8zEPiAUZfBH6nBMHk7kvzRLbCVGVeUMq
         +sfgLoq+rAMadEB4+tCMDCIzwUzBiSrFhPpIy3clnKvc/Tu0dILU6YCZjHkX7FxBWxvO
         Z/Qxr5bYurZcZZadWpdRHscawguPwUMlPw5Njl2DrMc83evbru9dorQp0zxCHICoqjDV
         foHWxr8oe2MiN687Zp/YIOYl3ybjsZXj1OVlLu/aguUAda0qu/JBhFmgDtYV9ajgls5h
         swhA==
X-Forwarded-Encrypted: i=1; AL+hErH2ZjvrEAlKjyW7GcpQA4BTd6VMIkIFRAKauA9nxNElhcqPyoT5CcZGAsZwh4v3YI9GfBO00+OBCN0a@vger.kernel.org
X-Gm-Message-State: APuU4Z/pPc0DgCrHt3TNES/0emvZM6M65eK43xOK6zDnUrYGXShFmcY5
	b1sUosNQvMCujmYQExncBZQV/7/UjGmKnXcwcqVMFiDw88b+InRy1nk5oPoNZgFX59sX4uYtkrq
	cWzn3RYBc8laO2uf+Lc5pddXe3izAygg=
X-Gm-Gg: AZFdTZcpA/xO8XYY+45wJk3SnQmrUT2MbMB6kNYV67S1XEfGIehSdwQZGh6F42CSjlm
	UIn7JnfF8UjQY4o4ThaHGQSZzMre8uhuF0SHjQ7ZEE2Zwmh1FsorhQx7Ep9jDOW9JE7vpz00Hp4
	lEVynWfxpByJyDS40I50LmfKaMk2zjZwo3A2LnLHxfBaQadfZwiHcK1aENblSjsk2TayBmos2IB
	9kUCS+na1WsIxa301sOx5ijqHAmX4En9ju7LZ078fxnMDdz8jLj/Pb8SWbY9EJd/1pw0eNomw6X
	z+aLE15w1Oa1HAHB2kARZuQr8nVO/HN9oBlCn6fnJN9Zs1r7CqyIrSyRJjM4qINxgqrBbJGNn+Q
	zdzLMP9UDwM2h3xmKOaVLWtHJwqhq1YNIAzfLTPn24mD7jh6IQV9CRERk3HMosnXsSbd5qKlCEv
	5WhbTE98JjWnSuDgEyF+KMTNyWCj+6sn/G7mbtIo5BT1ybC5rPUUfWGssMAocvgX90RwTX
X-Received: by 2002:a05:6a00:3686:b0:8b1:e117:3978 with SMTP id
 d2e1a72fcca58-8c87b4efa61mr19112715b3a.18.1795629034041; Wed, 25 Nov 2026
 09:50:34 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124022107.32283-1-ljp1205831794@gmail.com>
In-Reply-To: <20261124022107.32283-1-ljp1205831794@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 Nov 2026 12:50:21 -0500
X-Gm-Features: Aa3M54rTrVlRJogvLdZlOlBUntzVGX-lKN5GyjMtLtm6uLQGHabDbIb2QZZt7fY
Message-ID: <CADvbK_ekpmyug=RZ4nLUotK7jimxKrw9gUiEyF0zzopM-rzPUw@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: preserve the peer transport during INIT
 error cleanup
To: Lin Jiapeng <ljp1205831794@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Lin Jiapeng <jiapenglin@tencent.com>, 
	stable@vger.kernel.org, TencentOS Corvus AI <corvus@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 9:21=E2=80=AFPM Lin Jiapeng <ljp1205831794@gmail.co=
m> wrote:
>
> From: Lin Jiapeng <jiapenglin@tencent.com>
>
> sctp_process_init() removes non-ACTIVE peer transports when INIT processi=
ng
> fails. The transport matching peer_addr may itself be UNCONFIRMED, becaus=
e
> sctp_assoc_add_peer() only promotes an existing UNKNOWN transport to
> ACTIVE.
>
> If no ACTIVE transport remains, the cleanup can remove the last transport=
.
> sctp_assoc_rm_peer() then interprets the empty list head as a transport a=
nd
> passes the invalid replacement to sctp_assoc_set_primary(). KASAN reports=
 a
> null-ptr-deref in sctp_ulpevent_notify_peer_addr_change() through
> sctp_assoc_rm_peer() and sctp_process_init().
>
> Keep the transport matching peer_addr while removing the other non-ACTIVE
> transports. This preserves a valid replacement path without retaining an
> arbitrary UNCONFIRMED address from failed INIT processing. On a live
> COOKIE_WAIT association, T1-init remains armed and can continue using the
> retained transport until association teardown. Successful INIT processing
> is unchanged.
>
> Fixes: add52379dde2 ("sctp: Fix oops when INIT-ACK indicates that peer do=
esn't support AUTH")
> Cc: stable@vger.kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Link: https://lore.kernel.org/netdev/20261112092114.12458-1-ljp1205831794=
@gmail.com/
> Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
> ---
> v2:
> - Keep the transport matching peer_addr instead of an arbitrary last
>   transport, as suggested by Xin Long.
> - Update the subject, cleanup comment, and commit message to describe the
>   retained transport's use by a live COOKIE_WAIT association.
>
>  net/sctp/sm_make_chunk.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 15c2d87575a8..65594eaaeacd 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2525,10 +2525,14 @@ int sctp_process_init(struct sctp_association *as=
oc, struct sctp_chunk *chunk,
>         return 1;
>
>  clean_up:
> -       /* Release the transport structures. */
> +       /*
> +        * Release non-ACTIVE transports except the one for peer_addr.
> +        * Keep it so sctp_assoc_rm_peer() always has a replacement path.
> +        */
>         list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
>                 transport =3D list_entry(pos, struct sctp_transport, tran=
sports);
> -               if (transport->state !=3D SCTP_ACTIVE)
> +               if (transport->state !=3D SCTP_ACTIVE &&
> +                   !sctp_cmp_addr_exact(&transport->ipaddr, peer_addr))
>                         sctp_assoc_rm_peer(asoc, transport);
>         }
>
>
> base-commit: 145480b28ca82e9fae789427cc4569e596515a32
> --
> 2.55.0
>
Acked-by: Xin Long <lucien.xin@gmail.com>
