Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC41A34388F
	for <linux-sctp@vger.kernel.org>; Thu,  1 Oct 2026 01:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790819925; cv=pass; b=UfsaBMT4TEJP6U5YCBC6tlZ+iFQffiFNYc7Po+or3SpXs27BWVbDqvOxuc1b/HKRx6sDZolPxQpu0QPGEEgqAnRFzblTFZLdZ7qllmfgGmsnePZrAX1TTOgSKgEZBA6UzxeHv1B+oD/72Iwv0oqRRfBp2DFZrQFknHElwXgfNLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790819925; c=relaxed/simple;
	bh=ucPcDmschbjRsDAtpjXx3xo9SCLRl8ATbWFyF8W3TTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kT6Rl3aPjSkYe1GdjjsBioM8Rbjw09/TB9+fDPsIiFHP3sWK1gVhp5gO/k0DdSX07gwZnLOJhnKbNMEtnqmHIHE5jaY8R7m4kVS/otMUjrSYTFJ+WPAVGpaSm+CevGEML15GyECkBavfsrKeGKzxXnsfEnSL87akGhsSgQatnS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m27v9j6l; arc=pass smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m27v9j6l"
Received: by mail-pz2-f37.google.com with SMTP id d2e1a72fcca58-886a5cb66beso839915b3a.2
        for <linux-sctp@vger.kernel.org>; Wed, 30 Sep 2026 18:58:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790819923; cv=none;
        d=google.com; s=arc-20260327;
        b=JKSX5ZWO5a6ASONkWPiZNDrOMq6EOOi0UyYffpft4irSPvA6kEAKoFsJueYMYa2ppP
         ZnMAp7Lu0hDgB6Jb3FO22SGyhVGrZbwGcFCo5KedeejIMbszARQzIW+eVheIx18Ufty2
         zaVDrY+VMOaI0cuSdNp+GCBnJr8QB3jW2zHX/3Ful1jjg7SYNUWBIh3ffjKzp2e7wrsS
         bAlmKi9LvIQwVtqjDF36Dk8fJIvRmvms3hue25BizxyAIzW3bJUfFGp1xEeBPd1WRQzT
         kD4JINZVyd/g3TOZatJ53nK9F/Y7ucJNbJJKP4sDcaBwmWDO8R0fVt3cKXejg2VDWC5b
         6dPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RZ3g8lebCg5gxaDx43eqFNvHTc9ZLhzRK/aSjALn6zM=;
        fh=/bY+Qf7fRhVrN95hLTMgDcyjpKZAJWMjhEdQ2LaHLdc=;
        b=cq/9+THUO7s12uI3ENb0GzFLFX4mTVHV1K+YYtToN+WTEkRsTcnLkuTRuDWzlA3ivQ
         hBGvXC7EXFam2g/9Bom/XipMQe7+N+0gmqV9zP6uxltdeNLa0XYySuDMpBVaRYgHcvi5
         szbOuN7o+LIdcSxhnB37ZDSKPWL3QooUPl5Mb4PTi3ANIVbjcs6x3JHTb7kz1DCYfLyq
         QipfFG6JIIJ2AyeRbDwFkZbpsrf3xIAO6PuUfnTKhGlmTnKPibQUgxvNYAYVPA7i8lh9
         kCb3aZ+dvkCfd7lMtmroI+t4sbiSqtCqqAxrPPxMB1NQ+9z/pEFpoP4C3GZVeNgXv6N7
         uOxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790819923; x=1791424723; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RZ3g8lebCg5gxaDx43eqFNvHTc9ZLhzRK/aSjALn6zM=;
        b=m27v9j6lwz2RAeIRUQqj1dqqcbeI60quYwxQh/79nzj+9hbcB0h8on0wloctHRXpJA
         gnQ2X/xRtdIVifCCrXfHODkhaU33yuHgvmh2Gj1+A5C0rMY+X+Mp0ZVA5lQAqcr5Ra+A
         SPUTkkqgcCF1uScSI2jHUF1szuLAmeW3k9Y0ohD173iOWvseoRop0hn8rwy2JLIs4JnH
         eXqXj+/AHcuKLX9/z/2q565oHiDY6jgS3gevYdSspnDOWCDph3BrtzsIj91vuSY8GmY9
         bEM3/bl8QS8JztXBVjRj56eUwOgSc4YLpVotu6dLgeGMusUp7bmMD0MWG3k/uWVwT8bL
         n3DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790819923; x=1791424723;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RZ3g8lebCg5gxaDx43eqFNvHTc9ZLhzRK/aSjALn6zM=;
        b=xbi1ywv39WH9fIydMiwuMjdnZgz+tr2gX256fkpIBXIG7SiriZwp1ZdDYDdVO/3kry
         23O7k13c4COgZtsmV1JFMrhJ/8eK6c7o0w61lffo5quDqMW4Pol9LhuxvklxqHcdBbXt
         eeTi4riM6BVbCaYDGlu1DQ42XtKmwgUF1qESi2qSH72NENrtRl4K0FCkvgaIcgS+CTb/
         EYM3jD3rmcdrAL/FcBMkIm6lW0AAf6jsYYPeHkmKE92ULZSiUBFPRzvyAGlfHJv6fLRv
         txf4RZhe/DNFc3Lsst3Shaxp4lOr6qinVTHh5c9A+a8R6pQjNvLMmQyxdT/5mEOi4Ryk
         VS+A==
X-Forwarded-Encrypted: i=1; AKwUvBzbwZSc2wc6x9weffnLDL/KFZgHhmYwIq7PeFQqPv3C3o3QlRErFMS0gAySoF3jqAWK6RM1va4q7mNe@vger.kernel.org
X-Gm-Message-State: AFuF++knCo+s0xqunJmeRupKVp3zUWHq1tC8NfXuT9+azUcmgkXRPClF
	y97qzglrmigWjMxrB+9ISZ85J9qnMu4uSkOwsLGIEE0kWYVQDWB8uSgD86UC4czJQkUJ7tcOQeh
	Y+SnUeEflJ5NGJYPGHQOHp99gAYGhi10=
X-Gm-Gg: AYBFou3IDghk59Vfu+IeIQLNkW/StDHo7ITsusWyeY0VLdnq7swTKgZm3Y/RXYi/FDI
	hGL7xtF04gwFVjfFa8BcKg4YtQp+JzQ6g+9h0/KjmAf3ZBkjKaPera+eTcvQk+MAmkr5GPnvGis
	IhWTFaY6HHj9sWIl5XuRykI0iis/IooZRZCaPTerzUEZQEDUFaIfY/6mEVvzK/OeTKe39hQSwUT
	mWV1ykWbjl2RMYCGCQejhAIe10w6SnQVCnF2L9LMTCgUcXcCj5R7ye1kO5IoqeKFNPJsh2btItk
	p/cx0gFlYrFaF7+lBAAp+n7cpAOsK9nvUD5xpV2HFf/7GAKIQwX9O1cc18oD0QipIRagxruBtpl
	3ZQX+MdGn/xmoN8Eyc/Yq7XBt2nCyrjKOF8gVHwSiXHO7SGLRR4Ml
X-Received: by 2002:a05:6a00:1caa:b0:878:34d7:6977 with SMTP id
 d2e1a72fcca58-8874c8d3209mr2417687b3a.37.1790819923066; Wed, 30 Sep 2026
 18:58:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926100359.78731-3-juny24602@gmail.com> <179072681524.434549.16395137413640226954@kernel.org>
In-Reply-To: <179072681524.434549.16395137413640226954@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 30 Sep 2026 21:58:31 -0400
X-Gm-Features: AclHuK-uAB9OL6Fc9XCxZHiO7yuELOW_Hf8r2bDZ31PBlEBXw0WK5jgL__0Vwlw
Message-ID: <CADvbK_cuZd-TSGstgcToVKOMXFFB8ZeH83j6GtsxAbn7xwU=+Q@mail.gmail.com>
Subject: Re: [PATCH net v3 2/2] sctp: re-point retained control chunks on
 association migration
To: netdev-bot+sashiko@kernel.org
Cc: juny24602@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, david.lee@trailofbits.com, 
	kylebot@openai.com, junvyyang@tencent.com, stable@kernel.org, 
	corvus@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 8:06=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] In net/sctp/socket.c, sctp_for_each_tx_chunk() walks the control
>   chunks with a bare cb(chunk) on q->control_chunk_list,=E2=80=A6
> - [Medium] sctp_set_owner_w_migrate() passes control chunks to
>   sctp_control_set_owner_w().
>
> --
>
> sctp: re-point retained control chunks on association migration
>
> This patch extends the tx walk in sctp_sock_migrate() to cover retained
> control chunks as well: control_chunk_list, asconf_ack_list,
> addip_chunk_list, strreset_chunk and addip_last_asconf. Their owner is
> moved to the new socket. It exports sctp_control_set_owner_w() for chunks
> that have no datamsg, and saves the old chunk->shkey so that key can be
> released after the new owner is set.
>
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 4a08023d52aae..efee9e3e671ef 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -155,9 +155,15 @@ static void sctp_clear_owner_w(struct sctp_chunk *=
chunk)
> >
> >  static void sctp_set_owner_w_migrate(struct sctp_chunk *chunk)
> >  {
> > -     sctp_set_owner_w(chunk);
> > -     if (chunk->shkey)
> > -             sctp_auth_shkey_release(chunk->shkey);
> > +     struct sctp_shared_key *shkey =3D chunk->shkey;
> > +
> > +     if (chunk->msg)
> > +             sctp_set_owner_w(chunk);
> > +     else
> > +             sctp_control_set_owner_w(chunk);
> > +
> > +     if (shkey)
> > +             sctp_auth_shkey_release(shkey);
> >  }
>
> [Severity: Medium]
>
> For control chunks with chunk->auth set, sctp_control_set_owner_w() alway=
s
> does this:
>
>         if (chunk->auth) {
>                 chunk->shkey =3D asoc->shkey;
>                 sctp_auth_shkey_hold(chunk->shkey);
>         }
>
> After peeloff/accept, a retained control chunk (an ASCONF-ACK,
> addip_last_asconf or strreset_chunk) that was built under key K is
> switched to whatever key is active at migration time. Is that intended?
>
> The DATA path through sctp_set_owner_w() keeps the key that was already
> selected. The prerequisite shkey patch also describes the transfer as
> keeping the selected authentication key.
>
> The commit message says:
>
>   "since sctp_control_set_owner_w() may select a different asoc->shkey."
>
> It doesn't mention that retransmissions of these chunks would then be
> authenticated with a different key id.
>
> Can this also lose the SCTP_AUTH_FREE_KEY event for K? Suppose K was
> deactivated while chunk C still holds it, so K's refcnt is 2. K cannot
> be the active key at that point, per sctp_auth_deact_key_id():
>
> clear pass:
>   sctp_clear_owner_w()
>     sctp_auth_shkey_hold(K)            K refcnt 3
>     skb_orphan()
>       sctp_control_release_owner()     sees refcnt 3, no event
>         sctp_auth_shkey_release(K)     K refcnt 2
>
> set pass:
>   sctp_set_owner_w_migrate()
>     sctp_control_set_owner_w()         C->shkey =3D K', hold K'
>     sctp_auth_shkey_release(K)         K refcnt 1
>
> The last chunk reference on K is dropped by the plain
> sctp_auth_shkey_release() in sctp_set_owner_w_migrate(). That call skips
> the refcnt =3D=3D 2 check, so no later code path sends SCTP_AUTH_FREE_KEY
> for K.
>
> [ ... ]
We should not allow sctp_control_set_owner_w() to select a different
asoc->shkey if chunk->shkey already exists like in sctp_set_owner_w(),
and we may need a change like:

        if (chunk->auth) {
-               chunk->shkey =3D asoc->shkey;
+               if (!chunk->shkey)
+                       chunk->shkey =3D asoc->shkey;
                sctp_auth_shkey_hold(chunk->shkey);
        }

in sctp_control_set_owner_w() for this issue.

>
> > @@ -198,6 +204,21 @@ static void sctp_for_each_tx_datachunk(struct sctp=
_association *asoc,
> >
> >       list_for_each_entry(chunk, &q->out_chunk_list, list)
> >               traverse_and_process();
> > +
> > +     list_for_each_entry(chunk, &q->control_chunk_list, list)
> > +             cb(chunk);
> > +
> > +     list_for_each_entry(chunk, &asoc->asconf_ack_list, transmitted_li=
st)
> > +             cb(chunk);
> > +
> > +     list_for_each_entry(chunk, &asoc->addip_chunk_list, list)
> > +             cb(chunk);
> > +
> > +     if (asoc->strreset_chunk)
> > +             cb(asoc->strreset_chunk);
> > +
> > +     if (asoc->addip_last_asconf)
> > +             cb(asoc->addip_last_asconf);
> >  }
>
> [Severity: High]
>
> These new walks call cb() without any filter. The DATA walks go through
> traverse_and_process(), which checks c->skb->sk against asoc->base.sk so
> each chunk is processed only once. Can a retained control chunk be
> reachable from more than one of these lists or pointers at once?
>
> sctp_process_asconf() links the ASCONF-ACK on asconf_ack_list through
> transmitted_list:
>
>         sctp_chunk_hold(asconf_ack);
>         list_add_tail(&asconf_ack->transmitted_list,
>                       &asoc->asconf_ack_list);
>
> sctp_sf_do_asconf() then queues the same chunk on control_chunk_list
> through ->list with SCTP_CMD_REPLY. sctp_assoc_lookup_asconf_ack()
> already skips entries where sctp_chunk_pending() is true, so being on
> both lists is an expected state.
>
> strreset_chunk and addip_last_asconf are also queued on
> control_chunk_list while the pointer is still held.
>
> These chunks can stay on control_chunk_list across a flush.
> sctp_outq_flush_ctrl() skips them while src_out_of_asoc_ok is set, which
> userspace can trigger through sctp_send_asconf_del_ip():
>
>                 if (ctx->asoc->src_out_of_asoc_ok &&
>                     chunk->chunk_hdr->type !=3D SCTP_CID_ASCONF)
>                         continue;
>
> It also puts back chunks that fail to transmit:
>
>                         if (status !=3D SCTP_XMIT_OK) {
>                                 /* put the chunk back */
>                                 list_add(&chunk->list, &ctx->q->control_c=
hunk_list);
>
> Take such a chunk with chunk->auth set, old key K and new key K'. The
> refcounts go like this:
>
> clear pass, first visit:
>   sctp_clear_owner_w()        hold K
>     skb_orphan()              destructor releases K, clears destructor
> clear pass, second visit:
>   sctp_clear_owner_w()        hold K
>     skb_orphan()              no destructor, nothing released
> set pass, first visit:
>   sctp_set_owner_w_migrate()  hold K', release K
> set pass, second visit:
>   sctp_set_owner_w_migrate()  hold K', release K' (chunk->shkey is K')
>
> Does this leak a reference on K? The net change is +1 on K. The struct
> sctp_shared_key and its sctp_auth_bytes would then never be freed, and
> the refcnt =3D=3D 2 check in sctp_control_release_owner() could never fir=
e
> for K.
>
> A local user who controls both ends over loopback could repeat this for
> each association.
>
> Could these walks skip chunks that were already handled, for example
> with the same skb->sk check that traverse_and_process() uses?
>
It looks like bringing back sctp_process_tx_chunk() from your v2 patch
will fix this. Sorry about it.

Thanks.
