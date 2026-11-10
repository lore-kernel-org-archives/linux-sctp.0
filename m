Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794324164;
	b=vng6NyWq/fF730jSkOJ7sdgif1RBew4+RpFNGAKiMfpy5mVsgOu/Zxsr4Qu9iM5Z1eMW
	 IkQJ9G+8w9pooNjsJlj9Bh/n7JteKefh7pPhXH8s3tTOpNrVXaYicHMZM9SqOJQ19oCOv
	 UiGX4mTx9gTOU3+Fzw7rajpydmzKsAAXRV09FDWW/V6RV3Mttu48ufpXhofSTPItxXd6w
	 KvDLSimd4ir+7S3qsuKyMqXdn4qCRNGR4Z3Ng3wuOzdOV2S37ttOGyx8ZhKvnYKJ8TtPm
	 2LvY0CIT/lTb2mAOiVJdBfz3161hlS7x301akPYCjAjUoPM5fMTK6rRr/oUMS5cVo7w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324164;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=CJiQL5sKqyZVeUNg8rOn7a2I+JT7y6AYk1VYUPMSMjA=;
	b=m3FIm6rMjgbnr1bq9OLqsXBozoSPNNTgyQSBkBSO7u5Pgz6xQD2Y2Aa76RKFTzB934Mh
	 tiH2SuurdURCbGDxdXr78B5eVbRpELAs5/6xhGgZnEQ1Bs6U2XNNaY6WEX4pQubXO+DIW
	 N7KvSxuD+gQl6S2DW923i9jrYbB9QPB7pAtS4LZ1QcQijDtB1rTSWek1qwWHWli9YQByw
	 6MFxVS6+eNyrfpdHPGxI6Fo7PDnf7D1C9GsAj8CMLa9zpnQmYa3Rd5dPvOBpMc3oYWfEA
	 jawa4IiCfmwzxZvloBEUCE/3gBDZk5CVZzWh2ueKZ85xNtEiSdXc3tdtveabeZK0hjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vpPk5dhh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.48
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2FB606A31C
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 15:22:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B2FB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vpPk5dhh
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-7cc91ddf447so871737137.2
        for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 07:22:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794324163; cv=none;
        d=google.com; s=arc-20260327;
        b=Gif486qk6hOufAqpMIhkdth3wnl4+hoOPIFifnUQBNeaup8kWtMrw/TrTjYhvUdA1o
         BEG/adEbCvQrKlLtYP7z7Q7A4BjSXg2X1NpU8ADWR3wuAH9pWEuABS1iuZkJEUi806AQ
         g+T2F7U6njzVMG2RssXSvOWSOOZkluYXaRuURxdCgFiu4AlHPiJLFHwvhAxDPUAczFLU
         X4yCYY+xahuv8BazGkoTcmpAAEqseaFnAniyqMkoKgBH3xTrG63xfqW2FrSgkv9eUrIG
         g4Sb7+q91QQ69EAeA0m/T4ojgBBVo1QY28BtmdeBXQefWNKDA/JYf3QKlCKxepCb5GG9
         g/pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CJiQL5sKqyZVeUNg8rOn7a2I+JT7y6AYk1VYUPMSMjA=;
        fh=pDLOiZ7tXMOvWRwpnjb0+cKUZB77VatLrihDuN3oqvk=;
        b=HEyCZB43m+0b4vknX3kozfl9AVdUqq6WgavpEf2K/LGlFDZaDEHnrN82Wd882zSFIn
         78vCm9o+PNbz1bSvQKR5cgD/49pokXqoOV5pnzEpLgXV3zbIGWNjv97OKM3vNBbW5x4j
         rDkemkG/4xzU7l45qEHWj015l3CW0kUhj3P60nSZT3cYBOmPoJ4zKtB9zE0jfaaors5H
         CGzDQRMALM0LLt8a5Fb5WUq87jDogpQaUuJDipL8dfcLKRV16Je7tJcW64wbsTmg2c7w
         K85bcBv3+aJXULNs+jH3sgJVBc2W5+gPHvuTa1YakbYgCSNWbRt6CkcugvM6myYf0iqa
         7INg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794324163; x=1794928963; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CJiQL5sKqyZVeUNg8rOn7a2I+JT7y6AYk1VYUPMSMjA=;
        b=vpPk5dhhI/RU6k/kmNTxujQ8ynYzj/ulpvfjhDI8C4HfIDgv9TpbrH9qB2B6IhOLhb
         XnJC6w49DVW62pNYEsgW+CICmDNSLQ89K7ocLHaXQIcQzxN1VuNR61e/wfH+r47HD72j
         9fNs4c80+R+6KUQ6lIaIRzSsljX9OoaRPiH883FIRRx9gNJBx6X3oOLDGIuvEd0U7eYr
         Lx5ztZC7X31XPNfaVZMaUTc5gtFrUhu4cotfxnYYjbutuy1VOnRacmaslrgMI87MSrZ7
         2XxwoFiZn3HHv1AED277aqYeuIFlkEX/tI3JV3g81UDiqIDlmo/b9wXlbqAvCiqjgm3b
         VXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794324163; x=1794928963;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CJiQL5sKqyZVeUNg8rOn7a2I+JT7y6AYk1VYUPMSMjA=;
        b=hpXvD2ZmYqBwV6sM6nciddTc8pouWYJOdO6sjg6RjqMkSucRhcVVzXW+5KxALDakWd
         o1M4Y430pvZqvHZbbh4caZkp4+/tfbxIGATe+og0pw0KVR4RtCopiM5HSoAbEpxTGWZh
         MbXRZl+W1PTumihfHVkgEd4DK8n2GleWcjuZty3h/tJY8AR5DJ0F5KLpEdvhvsxGHPuG
         4q7WdcECOwh3m+YexMCSZroJFl8qQfGOvPI8zKiwXRgNGGeKqQCp85m3YPaEfu1y9sR7
         xv2PnLMAThV67BQxzByDpkjMx/TuRxHOrbI8KR5CD+MeTlJXNz1Er8gB0h/rBaA3NuFS
         Fe1A==
X-Gm-Message-State: APuU4Z9l8ysfT3EeQMGFj50SwGqFl0efpRlWC6tbH2Gfp10f0A8Bv9re
	cVWx8XbUtBSVMh0kZ/FgCD3mbg+4+ZUtsfLhVdD7WSAv/0vY4599vlvMnLKIUNZbjrBxkfCPuia
	5xdRi4CGdjLokYih9rK1iyi01HxwCu2wPwLyJLRg=
X-Gm-Gg: AYBFou3VRatW5FUQzVR/Lx5SSqNkwUo2Swde0fA3Xj6PpDFKair/X/R1laYfCUzHPUv
	ZjcDMB/OwloHYWLVZuSlnfHkCQR+ZBaeZHNfamFIr91OevX1tDV80hOShCLLcqR0VPzh5giAOeZ
	mv+vIqil9Vock8YaatyO6NBr5TRJhtnZ9jOSvRekWVF8W4gCKpWbTb7QQMxWoQInhUgTXxiB5ZL
	JiI2zCpzsB2MNQ4e803y3vXnWtfGc98b1nA51vJ6a9f9eN9Z8pvfqash89iOCv5eU1Wy6Kwky1s
	RSW5hJPm192OIxQ3EmRmmr/f94i9AgHZTlveFLhjKjcCr9h2tPc4YEBBKgzADJhXcLMccUx5Hkf
	ZJkLXX4uW+a19cnWl2j+72t6vmpH0ALcC/YRWNU0iNQ6tclAdSLS22yDbZiSZVp1q5PFhaUJ4DB
	1WW9aCJJsbM59ff+wSLAUxGFZTYTRa/z+RJmKkKg==
X-Received: by 2002:a05:6102:5087:b0:7c8:1fd5:82b5 with SMTP id
 ada2fe7eead31-7d301bc9d82mr797847137.14.1794324163139; Tue, 10 Nov 2026
 07:22:43 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261107030532.32310-1-kylebot@openai.com>
In-Reply-To: <20261107030532.32310-1-kylebot@openai.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Nov 2026 10:22:30 -0500
X-Gm-Features: AclHuK_as0CyVKCysZAXlMmcRhg8HgWxQZlIW2p68ZFwPAUogqt6LAxG2x9OdwQ
Message-ID: <CADvbK_eK=sgA5Yvm9fpFjmREg61Aof5ci6J_zFNp0wbQHJiLzA@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: avoid requeueing pending control chunks
To: Kyle Zeng <kylebot@openai.com>
Cc: linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 10:05=E2=80=AFPM Kyle Zeng <kylebot@openai.com> wrot=
e:
>
> The T4 and RE-CONFIG timeout handlers take a reference to their cached
> control chunk and submit it through SCTP_CMD_REPLY. A previous
> transmission can still be on the control outqueue when output is corked
> or suppressed, or when sctp_packet_transmit_chunk() could not append the
> chunk.
>
> sctp_outq_tail() then adds the same list node a second time. Re-adding a
> non-tail entry can corrupt the list without being caught by the
> insertion-time list checks. A subsequent flush or association teardown
> can access an already freed chunk. The ASCONF path is reproducible by an
> unprivileged SCTP socket owner in a user/network namespace, with KASAN
> reporting a use-after-free in __sctp_outq_teardown().
>
> Check sctp_chunk_pending() in both timeout handlers before taking the
> extra reference and issuing SCTP_CMD_REPLY. If the chunk is already
> linked, leave the existing entry for normal output processing. Keep
> the remaining timer and error-handling commands unchanged. This also
> covers RE-CONFIG retransmission after sctp_assoc_rm_peer() moves the
> request to another transport and starts its timer.
>
> The issue was found by an LLM.
>
> Fixes: 2e3216cd54b1 ("sctp: Follow security requirement of responding wit=
h 1 packet")
> Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
> Cc: stable@kernel.org
> Suggested-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Kyle Zeng <kylebot@openai.com>
> ---
> v1: https://lore.kernel.org/netdev/20261030042321.74407-1-kylebot@openai.=
com/
> v2: Move the pending checks into the T4 and RE-CONFIG timeout handlers.
> v3: Drop OUTQ_FLUSH and use the two pending checks as suggested. Leave
> already-queued chunks for normal output processing.
>
> I have a reproducer for this issue and can share by DM.
>
>  net/sctp/sm_statefuns.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index b2f609f177fb..64519fd8f943 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -1122,9 +1122,11 @@ enum sctp_disposition sctp_sf_send_reconf(struct n=
et *net,
>                 return SCTP_DISPOSITION_DELETE_TCB;
>         }
>
> -       sctp_chunk_hold(asoc->strreset_chunk);
> -       sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
> -                       SCTP_CHUNK(asoc->strreset_chunk));
> +       if (!sctp_chunk_pending(asoc->strreset_chunk)) {
> +               sctp_chunk_hold(asoc->strreset_chunk);
> +               sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
> +                               SCTP_CHUNK(asoc->strreset_chunk));
> +       }
>         sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE, SCTP_TRANSPORT(transpo=
rt));
>
>         return SCTP_DISPOSITION_CONSUME;
> @@ -6197,9 +6199,11 @@ enum sctp_disposition sctp_sf_t4_timer_expire(
>          * chunk, it MUST be the same (including its serial number) as th=
e last
>          * ASCONF sent.
>          */
> -       sctp_chunk_hold(asoc->addip_last_asconf);
> -       sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
> -                       SCTP_CHUNK(asoc->addip_last_asconf));
> +       if (!sctp_chunk_pending(asoc->addip_last_asconf)) {
> +               sctp_chunk_hold(asoc->addip_last_asconf);
> +               sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
> +                               SCTP_CHUNK(asoc->addip_last_asconf));
> +       }
>
>         /* ADDIP 4.1 B5) Restart the T-4 RTO timer. Note that if a differ=
ent
>          * destination is selected, then the RTO used will be that of the=
 new
>
> base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
> --
> 2.55.0.openai.911.g06873a30d2f3
>

Acked-by: Xin Long <lucien.xin@gmail.com>
