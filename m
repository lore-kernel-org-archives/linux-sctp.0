Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795532026;
	b=TJykMLwjNEBpGRywHR+vf1cyVik1yeUR/4crwf3bNMC7eGexhZ8xsCwJp4rem3UAwCR3
	 QW3VURD2aQK2uFonmosymYHGnzTXnN1KfEZyx9eGOyHUDw5nRm3w6JyuoqIl7xiTY1Joj
	 ZMBEBC1TCaTBVZVi+SuNdx205QO6mczvlD5d2o+cO4KNfEuDVfthYuUdWReW1USofHBut
	 LxO5sCymKUwaD2ZQvQ4bskm41qwLb2oSpf9uRYjxZm0QngWY/iEOJNTmF2F52kh8Vzn+/
	 j1Kevjrsm4Ov/mEMB99shxbFWkRJvvukU9epU+9cwGuYOmbWxT/HLOMhQWPtDuxAyoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795532026;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=p4wXMx28wnrcUl8Oo79c8VzU0Hk3YuGD1icb2+Qx9Ck=;
	b=X/GuJpXS/ph2BEucVYVftVyDmKg1MmHsZinrh+ZHP3/pmQ2NouULfpnGUfiGBUtJSa7P
	 vE5YeRKDHCSd7xPN6bhUrufE9YZNQf5PQSpwbqHtB8zi/BEhdC3Obco9cayrvuS0YrBjb
	 mIrNEnsU0iPNRGQYyheiS8HTBHcOF+9uPnWx6zNGYGjbYhQQ7mkFluxjFBL2Bjm1p0XzE
	 gBmxuQ9Ax+LZIrerQbuVyr7fY4j5yieqC2N1oNTrlgi5B1JVi3oAhaYOJJ+j+cNOSb37C
	 HbtlbUnKyd5eMbwUoMYROh8Imxy000ttlZPw6VjQ7MwzbPNm7iSyqiNz/LoRZc71iAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kCwzg31b;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.53
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD1C606A326
	for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 14:53:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBD1C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kCwzg31b
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-99e156fe905so3656540241.1
        for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 06:53:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795532023; cv=none;
        d=google.com; s=arc-20260327;
        b=jnp1sqY/y+rY3QqhRpL7HHI/lfR5w6RzoYxLTFSGt6yO5QGhUBQxjn52qI9sTGFGKN
         Ppkj2W1gJmxjs85A6E3qa22i/aSjvuigf1AtwiYm4FamxJqEUzQhWbw4avna2DJN0jKg
         9EIoHXlFonTfw8ueHfNlSTrdl7IzfF2HX8qFKX9Sm4CD3RmNzUve5SZt10Is9OV5B1xc
         8rHcr7ZayS99Pgwwyqo/pbspXDHy1ktOZdd47y6FeXudBgMk7VJ0xYXOUsOrHN0s4p5W
         bDMNP1tg1EZrpaJ+jKl3yOcgw8cCCkuc8ra32M5ipXejK4WtvcBoFtMh3bNInLIWepHC
         RqWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p4wXMx28wnrcUl8Oo79c8VzU0Hk3YuGD1icb2+Qx9Ck=;
        fh=hg83RoA5ITgjiUYAzihdOloCZaNT3HW0LNPheIRMLoc=;
        b=dWl2gR/Y2NHsh0QZv4eovydG8fDo0DM5AsdAzZFKBN4vvEFxopmbldBrxjrstczhfY
         8AjpjTkMa9rZnWAt7w+dYFU+oiKqx1nXI49Ca23tTM4e8QhlN5oMIj6S7XjzRLxyrUyq
         WMwhj49+deuzVg2UhKVWbLgl9GSXVtZQBDN6NnNlM9fYU1wy0BaDwoSCT+iAamkbJxrp
         UfWFhhydh1A4nWxVrKHAlqsqVkLhnyL00eZlHKTygkp6aJGWFI4DePphypQLmDBJnP5W
         5ZPYFwa6r5RAs5KWiIaFrdaZBAhrMa7PpqWjUdasmqVCk/kjwXSl9Zvm0UuCl6LErH2G
         oadQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795532023; x=1796136823; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p4wXMx28wnrcUl8Oo79c8VzU0Hk3YuGD1icb2+Qx9Ck=;
        b=kCwzg31b61xUyZ1Njmby56I4y75QoAPpwh26ScOgN4ObCP0v3GTn/gcSpD6Ai3+HTT
         cPjO8rJTx3sKEr3drMT5RdCV/3SucTbD90GkS+RQ9zIQqGnhM6Nk6TnU7bsdepsmYKWm
         O88NbMPfBePRhUQQbmmky7hr2J6qSvk2NDdfXlcf1ViRjvuxcU3A3a+nffyHdNTyzP04
         I/rcTyISn/ZcLnRsweDHSZflYNaIFGB2RgLBJ8l41EB1hEzeFGCvdGHuD9QanpWGwvbE
         E/vS2mkkfsPFSuHrUPO66LnWor+wVe4coX9xwu82qObIiQQEsgLPciMG3NCoVapZfKbF
         salw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795532023; x=1796136823;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p4wXMx28wnrcUl8Oo79c8VzU0Hk3YuGD1icb2+Qx9Ck=;
        b=fLcYmtlWZ4bMTTU7fJhwFE8LMZ/poH9YS2r6ZpD1aS38JIAWAmiZ6MkWhw/g6CBYZO
         6F7uNR54GforG03JJ4G1MJPDnez/0lgh6xlQFeSI+s41dzwGhLnQ4UmLE1XrCNkGn68K
         yP1kDkQOlLjlyLslBpNR8GXYn8CX1bq87VGxtJrr48AEEeDUqhZJBTbbU0VD/mgrp9eI
         iT8qBozN/PTYi7p8Adi+bzgoUp+fymKetTFFLcwvC2VmX+Vi1Cx2YB/EI+s1PZiYDhdI
         Z6mBHhnkRhNWPuybHIKkx21Io0/UO9MwSwYHqGWZTR+YB8LOXCSe7L64ydSnq430T67d
         oebA==
X-Forwarded-Encrypted: i=1; AL+hErHemcxQk+AWl1kpb9XyOWlfddA8V9C+t5npvNkN5pjzv6zNOrKH4hhPbFAnjU0GvJ2lJEcPCHkl/kUN@vger.kernel.org
X-Gm-Message-State: APuU4Z+ZmSxkJW5KRha1CxGvEwuUO05Mo1WDTa+Zv0cgrQGNdFcsFd4E
	/gM90pYx1WlJIBzpwqgy/0JkSWz1WzoqhpGknlIGH+WEAQmfTNPMfl63PBwuGL/wu7yeaCKurbG
	jPNxCOWEFXbD+pducuMrdtw1whGakF38=
X-Gm-Gg: AZFdTZcWEaefUw5hVp3hm6SlS3O1euwCn8xzvR91nZrUYlY3TMnkKnNZN4Wj5KBpBkd
	kxM/drgQA7xR2hP2D3E+1SLDf7ikS0sGSypksmdiZSuyumzDy+9dVn1DCC2wQzjoC6F1aneGKlu
	akzqYNPz4mf0Su2mkBlC7icFV2BKNOVGVfmKzq7IIAhfl7phBoozllTJABnCZHjtLhyYTTmixtF
	lgA/kEbeGdqExxzkjQ59TfWEXspiCAdbl2V14DcgXn+ykk8Jor3myMOPJyv3N8GPDVvV07Lcknj
	+nyb9JWSAcNN7Ge25p3bolSQyVfWbeWDCi4NA71y/MS7hk4WAkdY8eN08j0V/1EO5nXf5HOasvl
	oF8Yfn4/O8NVUOZxk6WavqcfMGQtYq0mxE0u27oXsuJFFNLv2eCT7VLjPRvbJNTZOM9rpI5T6EW
	dcWh5alFQe/e2b86e1drdKGCozMCzAJNtt+vUfNA==
X-Received: by 2002:a05:6102:3f8f:b0:7d2:cc91:1aaf with SMTP id
 ada2fe7eead31-7d6dba78adfmr6131696137.43.1795532023428; Tue, 24 Nov 2026
 06:53:43 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120035521.2098757-1-pkfxxxing@gmail.com> <179549363640.3135.12116855475874204489@kernel.org>
In-Reply-To: <179549363640.3135.12116855475874204489@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 24 Nov 2026 09:53:30 -0500
X-Gm-Features: Aa3M54oPzesmcTAa1PYzdqgYL028mdClhKf8Jmt-5seWny9gepW1GQ9oSpeVJM8
Message-ID: <CADvbK_c8yk1taX2whZHTn=F-yhkvZjBLXtmJ-JqVrFU7o9kkFA@mail.gmail.com>
Subject: Re: [PATCH net v4] sctp: fix use-after-free after association migration
To: netdev-bot+sashiko@kernel.org
Cc: pkfxxxing@gmail.com, marcelo.leitner@gmail.com, kuba@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 11:13=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wr=
ote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 2 (1) =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] The patch makes deferred PMTU handling lose valid MTU
>   reductions.
> - [Medium] sctp: unlocked state mutation on migrated sock in
>   sctp_icmp_frag_needed()
>
> Pre-existing issues:
> - [Medium] The deferral branch of sctp_icmp_frag_needed() does a non-
>   atomic read-modify-write of the 1-bit field t->pmtu_pending=E2=80=A6
>
> --
>
> sctp: fix use-after-free after association migration
>
> Timer and ICMP handlers that cache asoc->base.sk now check, after taking
> the BH lock, that the association still belongs to that socket. If it
> has migrated, they defer the work as they would for a busy socket. The
> patch also moves the PMTU size check from sctp_icmp_frag_needed() into
> sctp_transport_update_pmtu(), and adds READ_ONCE()/WRITE_ONCE() pairing
> for the socket pointer.
>
> > diff --git a/net/sctp/input.c b/net/sctp/input.c
> > index 9494cfa51106c..555695718abf9 100644
> > --- a/net/sctp/input.c
> > +++ b/net/sctp/input.c
>
> [ ... ]
>
> > @@ -372,12 +372,7 @@ static int sctp_add_backlog(struct sock *sk, struc=
t sk_buff *skb)
> >  void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *a=
soc,
> >                          struct sctp_transport *t, __u32 pmtu)
> >  {
> > -     if (!t ||
> > -         (t->pathmtu <=3D pmtu &&
> > -          t->pl.probe_size + sctp_transport_pl_hlen(t) <=3D pmtu))
> > -             return;
> > -
> > -     if (sock_owned_by_user(sk)) {
> > +     if (sock_owned_by_user(sk) || sk !=3D READ_ONCE(asoc->base.sk)) {
> >               atomic_set(&t->mtu_info, pmtu);
>
> [Severity: Medium]
> The association can migrate between the READ_ONCE() of asoc->base.sk
> and bh_lock_sock(sk). When that happens, sctp_err_lookup() still
> returns the old socket with only the old socket's slock held. It
> counts the ICMP in LINUX_MIB_LOCKDROPPEDICMPS, but it still hands asoc
> and transport back to the callers.
>
> sctp_rcv() handles the same window differently. It drops the old
> lock, rereads rcvr->sk and takes the new socket's lock. Is there a
> reason sctp_err_lookup() can't do the same?
>
> As written, the migrated case falls into the deferral branches of
> sctp_icmp_frag_needed() and sctp_icmp_proto_unreachable(). Those
> branches still modify shared association and transport state.
>
> sctp_icmp_frag_needed() writes t->mtu_info, asoc->pmtu_pending and
> t->pmtu_pending. t->pmtu_pending is a bitfield that shares a word with
> t->dead, rto_pending, hb_sent and the other transport flags. BH and
> process context on the new socket update those flags under the new
> socket's lock, not the one held here.
>
> sctp_icmp_proto_unreachable() checks timer_pending() on
> t->proto_unreach_timer, then takes a transport reference and calls
> mod_timer(). If sctp_transport_free() runs on the new socket at the
> same time, its timer_delete() of proto_unreach_timer can land before
> this mod_timer(). The timer is then re-armed after teardown and keeps
> the transport alive until it fires. sctp_generate_proto_unreach_event()
> should then see asoc->base.dead set and bail out.
>
> None of this is serialized against the new socket's owner. The only
> lock held belongs to a socket that no longer owns the association.
>
> The busy-socket case has a similar shape and predates this patch.
> Before the patch, the migrated case ran full ICMP processing under the
> wrong lock, so this is an improvement. It still isn't fully closed.
>
> Would it be simpler to switch to the new socket's lock in
> sctp_err_lookup()? Alternatively, the ICMP could be dropped entirely
> once the association has moved, instead of recording deferred PMTU and
> proto-unreach state.
>
This is a pre-existing issue.

> [Severity: Medium]
> Can a pending PMTU reduction get lost here?
>
> The size filter used to run before this deferral branch. Now that it has
> moved, the branch stores every Frag-Needed/PTB value in t->mtu_info,
> including values at or above t->pathmtu. t->mtu_info holds only one
> value, so a later report that cannot lower the MTU overwrites an earlier
> pending reduction.
>
> For example, with pathmtu=3D1500 and the socket owned by the user:
>
> ICMP#1: mtu_info =3D 1200, pmtu_pending =3D 1
> ICMP#2 (stale, or from another ECMP path, matching vtag): mtu_info =3D 15=
00
>
> On the next transmit, sctp_packet_config() or sctp_sendmsg_to_asoc()
> calls sctp_assoc_sync_pmtu():
>
> net/sctp/associola.c:sctp_assoc_sync_pmtu() {
>     ...
>                 if (t->pmtu_pending && t->dst) {
>                         sctp_transport_update_pmtu(t,
>                                                    atomic_read(&t->mtu_in=
fo));
>                         t->pmtu_pending =3D 0;
>                 }
>     ...
> }
>
> sctp_transport_update_pmtu() is called with 1500. The relocated check
> returns false:
>
>         if (t->pathmtu <=3D pmtu &&
>             t->pl.probe_size + sctp_transport_pl_hlen(t) <=3D pmtu)
>                 return false;
>
> t->pmtu_pending is then cleared anyway, so the 1200 reduction is never
> applied or retried.
>
> Wouldn't the association then keep sending packets larger than the real
> path MTU until another ICMP is processed? The new migrated-socket
> condition also sends more ICMPs into this unfiltered branch.
>
> >               asoc->pmtu_pending =3D 1;
> >               t->pmtu_pending =3D 1;
>
The scenario requires two ICMPs for the same transport to hit the deferral
path in quick succession, with the second carrying a stale, higher MTU.
This is already a narrow race.

Even if it occurs, PMTU discovery self-corrects on the next oversized
packet, when a non-deferred update can take effect.

The original sock_owned_by_user path already had the same single-slot
overwrite limitation. The patch only extends it to migration; it does not
introduce a new bug.

Thanks.

> [Severity: Medium]
> This is a pre-existing issue, and the patch did not introduce it.
> t->pmtu_pending is a 1-bit field that shares one __u32 word with other
> transport flags in struct sctp_transport:
>
>         __u32   dead:1,
>                 rto_pending:1,
>                 hb_sent:1,
>                 pmtu_pending:1,
>                 dst_pending_confirm:1,
>                 sack_generation:1;
>
> Here only the cached socket's slock is held. In the busy-socket case,
> the process context that owns the socket can update those bits at the
> same time.
>
> In the migrated case, code running under the new socket's lock can do
> the same. Two examples are sctp_transport_free() setting
> transport->dead =3D 1 and sctp_assoc_sync_pmtu() clearing pmtu_pending.
>
> Could this read-modify-write of the bitfield word lose a concurrent
> update to one of the other bits, such as transport->dead?
>
> The busy-socket form of this race goes back to the original SCTP code.
> This patch adds the migrated case as a second way into the same branch.
> Before the patch, that case did full PMTU and retransmit processing
> under the wrong lock, so the patch reduces this exposure rather than
> creating it.
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20261120035521.2098757-1-pkfxxxing%40gmail.com
