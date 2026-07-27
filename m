Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB42243E49F
	for <linux-sctp@vger.kernel.org>; Mon, 27 Jul 2026 17:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785174161; cv=pass; b=h0LAn578ROqL9o7MImEErnFK009GvmU0dSxDtrBsB5qDR2NeVhq6kj6OfdBYZ4HEm6vpE7U8Std1fr1MXBXf33fe1HZsn7UWovfEeu3zWw6tqbmmiUerSKLw8XYk+BhNHmarB64AxKP5/S1b6GtFhK4eaqhPD15/UP40dohEsak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785174161; c=relaxed/simple;
	bh=fmw3ZK1Zy8eC2d3FwnmI6CzZ0BTv5CWLe3Aey1QFDTo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SNj6ZqI6jMqc6AJEB/O+RuvYqA/p7fw9kMuniiq/LZogjciJZL5Vb9YlKm9bQiuw1FOnXmbXDwJbDLoeaBPIiS6JabMxFwpSr4IVSlcMyR3mdZINySxt7br/spRG6JIgbyBe5IXCfNZMxSfkc9Lqo0tv8oYdifDJR1mV+tNd5PI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CZ7Z/KXl; arc=pass smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZ7Z/KXl"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8485bd28dd0so3064744b3a.2
        for <linux-sctp@vger.kernel.org>; Mon, 27 Jul 2026 10:42:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785174158; cv=none;
        d=google.com; s=arc-20260327;
        b=MekaIz0bIgqERjphuDvwgijHJ3mAB+0cXyF9M1keDl4sy8m/VlK5UkFn7siV+kSfk7
         cJPOcQ5e/gcqrKlriQB8KRvSXqhDyuxlRsG5nZX4TyKwG6T9zcwBhySZI7QAYw4+unTn
         RGabTdhAAlEv7t1x7TSIZ0DaUIIEyeg9RmhZ5M4LrmyVQzmOqUW84hGMvD4aNGTws+vU
         g38Jr2eLBRZI7aB8rq9nJu1Y8X0N2KXYVBRNZf/KCPOjgajMcdgkf/wYE3odR6fqC/dj
         vzQm0wH/qJbaQ18gpVc6utApV/pleVqBEO9AaN2UKUk7ROJ/YPLu+a7hQu98kxKd19vE
         E6Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QobJDhQM3EFzE5CfaULEs1c9Xyh8eT+RN0WimZuC2ok=;
        fh=WgTwQI9yUPt5X0qVY4vhK6qjEzpkaeNXdaClj7WC1Kc=;
        b=eneZgFlcLJmnqAvpbMd0Oqcj8u2Qmx47IcdT4FWutzJ5QWs01ZF+UwDyNlBj8LkuVJ
         4Z93JgqFTazeJ57QeQ+MYF9zfYbenSfQcwjnz1OltIOD8JgjZ7fXdyX3k8DglUbWg19b
         vYhJWdq8BlBtfO9GD4puoYL+t6TizJ/CR15oshEyEhhyIipOqQUwj5c7h6FWEgvExr3C
         xzIWDwq0mLPAh1wtXl4tRAuFjXCItHjX6lQTOgz6v5RX2klIL7bP1x229Akte8AuBn30
         mw9E5amUhhxwfsSMHRtLkxHPHPYtcdfti5nYr/haGGXeE34D+9V8xemefZ3taOKIHr3F
         UnaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785174158; x=1785778958; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QobJDhQM3EFzE5CfaULEs1c9Xyh8eT+RN0WimZuC2ok=;
        b=CZ7Z/KXlFU3s4q//cZq5HpablcbI70i72j5T3k3CprckIf3SdC12ytVjLTiZylbcmY
         pFeu7CO1HNo0UUHCePK564zxANRBLQljdR5yOcbAr1CiZZGi7E/mvNUIYHVfpNf0jh+x
         2VN1C/g7vu/D63LTHRYiZvF61qe9ssvLVnIcw0571j4dTujywKIAGnjEVW4SQA472e+e
         G5pkQCD6wHykXvao+b+TEyvVCfzo4/kDN3bYtysLUzgyE1wKId/k4G9ZXuv6Be6MAIMa
         40d+TBacUX09x4e5FFbFZ+i0pwQkaQmkGfJwsjbH9EzeCrJM+b0+bBTxSgIB98PgwQpS
         yHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785174158; x=1785778958;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QobJDhQM3EFzE5CfaULEs1c9Xyh8eT+RN0WimZuC2ok=;
        b=KQrr/jS/f8TexJnN0hNOOWeJ9gb3p3DEt5O2R/0L+3RnJZdaKtlpb4lE9Gs2lrwSni
         suDjifuGoQ/6rZahhyTTccjHvGtwQjjEvnsVx4OSTzdUTiipBIJMaVCaNafVNtxWg3Xd
         QdmoE4oRY6XaM+VPeSoXH6tSKc1CxfkhmztsMPLdRBvnfXmPUZUsTPiz0gyknqnVeJMp
         hoE8TFt2XduEeAASZoKV8Sxaxa0D0Yz5UcZA8UXZBnV3pJutK+A7hWA0HVvfr1N7TQ9z
         enoDpLNPEVncDI9CGDniQoDNW/NeEG6RgUmY60oUJcik07GWx6qoobUONSxcY6WmSEaG
         twqg==
X-Forwarded-Encrypted: i=1; AHgh+RrKp6l0+37Vp/38Gk0MzIN80s2Bkv0Ra7pQDZoCX8jbLgieZhQcDLxY4SiG0aZ2oyPlJIqc3D6iWeqB@vger.kernel.org
X-Gm-Message-State: AOJu0YxLbvd2iQT2T8uDWkHALS3gUDP9E9mHQ6+fn4ll9ES5vWcqP7RS
	fPa2d/HDHspAYl7L2nFBP268/JqJjloEpsI9ewMC0Vpru0SAImMqPmGgYLy2hxsNJ7Cn/ufEbMs
	DbJ5qSeAe0vz6dPc/WHF4L08d4scQ2YLcfMiC
X-Gm-Gg: AR+sD11Ng0DY2btbEvaxRWwMDlVubOeKj6icFskedeG0D0ULNjo1RPslSfOKglbwYtS
	4Yx48Y4SQSKU1++Fml8Puv9S8xjT+PVHQhvkxn4M3HT9gRcxCeQwrdsZ3IFJNQLYxh1P1l42jnH
	rSDfChsq3Z03cxAKidXL5JOqZdPdJ7vR8pHlhZgsSEOnmB2+tCyLFqWNjCzV3dsbKxCoOhXbaKm
	y6/KFXHQIoWDWrgJi2gLOV88KeQb6Z1VfzwfbL71Ge6P/02DmW1j+Hhwe209JcVKNWbO+V6cPjP
	X634VRBXjSD2v/XMHPNNbFFs3K2uMPhEf4DehowrV0BVCEb9/smoXKk50bxC
X-Received: by 2002:a05:6a00:9a6:b0:848:2f73:8ff6 with SMTP id
 d2e1a72fcca58-84e8d4b0d15mr331661b3a.63.1785174157906; Mon, 27 Jul 2026
 10:42:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260726060453.42730-1-baul.lee@xbow.com>
In-Reply-To: <20260726060453.42730-1-baul.lee@xbow.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 27 Jul 2026 13:42:25 -0400
X-Gm-Features: AUfX_mzQbBCIW_SD0RyVpIs29DmCPGe-cmG1TE8bleV2eUauPaK-NJgYkr5m9vg
Message-ID: <CADvbK_f5RdD0DAzXZJ8c4-Vm5EDEWRoz4Jz-FsfJBvdEDVS7BA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix transport UAF via the retransmit queue
To: Baul Lee <baul.lee@xbow.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-kernel@vger.kernel.org, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	federico.kirschbaum@xbow.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 26, 2026 at 2:05=E2=80=AFAM Baul Lee <baul.lee@xbow.com> wrote:
>
> sctp_assoc_rm_peer() clears the cached chunk->transport back-pointer on
> only two of the output queue's chunk lists before freeing the transport:
> peer->transmitted and asoc->outqueue.out_chunk_list.  A DATA chunk parked
> on asoc->outqueue.retransmit keeps pointing at the transport, so once
> sctp_transport_free() drops the last reference and the object is
> RCU-freed, that chunk is left with a dangling pointer.
>
> While the chunk sits on the retransmit queue the dangling pointer is not
> followed: sctp_check_transmitted() skips the flight-size accounting both
> for transmitted_queue =3D=3D &q->retransmit and for gap-acked chunks.  Tw=
o
> steps remove that cover.  First, sctp_outq_flush_rtx() moves a gap-acked
> chunk onto a live transport's transmitted list without reassigning
> chunk->transport, unlike the ordinary resend path, which rebinds it in
> __sctp_packet_append_chunk().  Second, a later SACK that reneges on the
> TSN clears tsn_gap_acked.  The chunk now sits on a transmitted list with
> tsn_gap_acked =3D=3D 0, so the next SACK reaches
>
>         tchunk->transport->flight_size -=3D sctp_data_size(tchunk);
>
> a read-modify-write inside the freed sctp_transport.
>
> The transport is freed by an ASCONF Delete-IP and the faulting accesses
> are driven by ordinary SACKs, both coming from the association peer, so
> an application that speaks SCTP and accepts multihoming is enough to
> reach this.  KASAN reports a slab-use-after-free read of 4 bytes at
> offset 216 of a freed kmalloc-1k sctp_transport in
> sctp_check_transmitted(), the object having been freed from
> sctp_assoc_rm_peer() via sctp_process_asconf().
>
> Clear ->transport for chunks on the retransmit queue as well, mirroring
> the existing out_chunk_list handling.  The sink already guards with
> if (tchunk->transport), so a cleared back-pointer is skipped exactly like
> an already-acked chunk.  The sacked and abandoned queues do not need the
> same treatment: chunks there never have ->transport dereferenced and are
> never migrated onto the retransmit queue or onto a transport's
> transmitted list.
>
> Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>
> Reported privately to the maintainers on 2026-07-10 with root-cause
> analysis, a PoC, a KASAN log and this fix; posting to the list was
> requested as the follow-up.
>
> Fixes: df132eff4638 ("sctp: clear the transport of some out_chunk_list ch=
unks in sctp_assoc_rm_peer")
I think the issue exists since the very beginning, Fixes tag should be:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

> Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
> Reported-by: Baul Lee <baul.lee@xbow.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Baul Lee <baul.lee@xbow.com>
> ---
>  net/sctp/associola.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 62d3cc155809..c95f68d21670 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -569,6 +569,10 @@ void sctp_assoc_rm_peer(struct sctp_association *aso=
c,
>                                 sctp_transport_hold(active);
>         }
>
> +       list_for_each_entry(ch, &asoc->outqueue.retransmit, transmitted_l=
ist)
> +               if (ch->transport =3D=3D peer)
> +                       ch->transport =3D NULL;
> +
```
[sashiko-genimi]
This isn't a problem introduced by this patch, but does the new loop cover
the ordering where the gap-acked migration happens before the ASCONF
Delete-IP?

[sashiko-claude]
This is a pre-existing issue, but can gap-acked data chunks bypass this
cleanup if they were already migrated to another active transport's
transmitted list?
```

Both AI reviews report that the change may not cover the case where the
gap-acked data chunks bypass this cleanup if they were already migrated
to another active transport's transmitted list.

As you described in the changelog, the issue actually was caused by:

> ... sctp_outq_flush_rtx() moves a gap-acked
> chunk onto a live transport's transmitted list without reassigning
> chunk->transport.

Can you try fixing this in sctp_outq_flush_rtx() by updating
chunk->transport after both list_move_tail() calls? This makes sure the
chunk's transport pointer always matches the list it is queued on.

Thanks.
