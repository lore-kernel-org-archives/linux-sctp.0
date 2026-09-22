Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4B0541E72
	for <linux-sctp@vger.kernel.org>; Tue, 22 Sep 2026 21:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790114263; cv=pass; b=Zs0sEx8MLKzn0lV1rMHApafhkO283UtHEn2+K0f0XzszmAcku8lE7yU3dpMckEBtvWwW46tJjnp5hA7gBoIgWQglDNK0Wh5Idt3k2tbYQFB1acq+ubxXu2WtkVzCFUk3YNIP9ftSm1NuSqJM4HZaM6tCq0r7TD4qQ7Sr6Ayjobc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790114263; c=relaxed/simple;
	bh=CO3As2TmPZjHhrml1U6HFpp8ONG/W6yW1foBj5kICTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AM+1xRQFjEvbUkFVoTjxF0CQGUVI6loU4DXE43N3uuJyZVSmmmlEKXgAEiLWzXXffezwVB2GNg3A0mqlJO6FyXO8Zheb24BQXuaBM2F/o5sZLJCNLgzR32l1OU+Yszlmpy3h7BlCoKFT6V7WnNVy9WHkk3c6NSKTnBbp04sD5jY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Us5TBGfs; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Us5TBGfs"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4d04d740cso232689a12.0
        for <linux-sctp@vger.kernel.org>; Tue, 22 Sep 2026 14:57:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790114252; cv=none;
        d=google.com; s=arc-20260327;
        b=n5/nnh77Pqf5ucxPXzkCnhDLc60Z7j5CizF+kMFRaI+rq89U9Fa9oAGw6VMaLuC0cl
         HMuiV/uWZokPp79mn34PvfbPss4ZOimZOR30/6pQGk6qBuIFvNKsEMaMTMwi23E4mDQn
         h5DigVBKnS7JOaSirj12439ZIIm6cuIBSY40Lnb7dKdXQ1lHQv6jyP0x/4cIcfOc0a8q
         n0HdaD1WgbVYRzSqL1w4qORkcTFeTRlfw09fgL7fzI9+RZeHw7xbAdoNOzd5bKlTPuFi
         eAvGsp6b9e2TBC90GbbsA1QuKphrNY7BshsECO62TDfTrhJHyhC9TMLEE78dv74ntiIZ
         u4PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2BfXLyRqjaoskONnpzQx5gIvbEJzshUx98T89RqkqU4=;
        fh=6LSQ9xPj0fYAl3U/DZL4Zp/C92wg+RldhwYTPvIFmyM=;
        b=chRZ+vjqVVM4CsGjVGK+zz89wVz24qJYq3i2ATH1HIIdE4Zz0qacIP4UNcRLKibMLx
         3gToncA64IBF6SDI+xevmPdPz0lu5ca0bGO+kf+E7FSS1ndxUksRQWE7DTeFp3fq0mpi
         P6dmfcwKdla8lrW52v2fOZjSrzVMADQ0UvsJ+KESYtGDLKBBavfPlGynD+JbEeaBADVp
         eR+nyUY2qTo4G05FlB/SJFAiDUGfztIm3siP8tkBcIwZEThTYMp7NYrgHw8xLf4v1wFa
         CsAOkk7oYu2oMutK2EVvBhjUq46W79+F/ZbthasgwYIt5HpSCtbcAUTLAgDcVkGhnh47
         GVqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790114252; x=1790719052; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2BfXLyRqjaoskONnpzQx5gIvbEJzshUx98T89RqkqU4=;
        b=Us5TBGfs3qeUoDvHlwFmC+tSk+tOUiIYUmkdxk1M782cBUKM4Qf0A7UehHiYOfZJ5v
         0Kz9TqdS3FH7E2gtjnYuhgiIv6FoIR14bvBhNZSSm6kVEbJeIHgWR9ENHw2p3OFUy+ld
         8lrM/oIl8ubdqz3YLpsJMvr7bFyr+XbJ56HfEXMyxgIHLuOSZ60QJvPqt6RA/+z0+9DO
         49Nqgnib+bSy9rw0ALx2Q33lDChp0cFdhmy7HKN6xZOxAgpDCVZJwj/amL2cD3NbmNhN
         BFm8ilOSy2mZsmMcGxvASomAh05FBM3D+WTZW+s3vs07/1Gjcz40EeBpG7HIM7iN1F0L
         1qaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790114252; x=1790719052;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2BfXLyRqjaoskONnpzQx5gIvbEJzshUx98T89RqkqU4=;
        b=y0c1E78Fm71YhI0lP+yza1x50mOD1FGymdWlHDXWHlQpT3ShRUECkHGv5MVObsscUr
         lX8KIJkKa5OoevPp8mhPyhmtgwyT3Fb6stWJB3mNEMmc+zh21msKCEy9wyomf0sJqo7w
         uKn+3Qc4iMDxbzYpchZ6IjeDknoTD+nDJau+fteWnE3sWdHURCksdEQQhiJpm329kLnl
         X1m3PP1HzXW4R0qway4aq4XeT16Th2mphkZz+/kTFQ28MWmvYQUMpg42GY00JJPSpCLY
         96+ihY3CIFlFmRl2lw87ng70mdrQjgjM6zL7glIUjugYpMNgSuKu4AejWBXI+65s5Ypj
         yXvw==
X-Forwarded-Encrypted: i=1; AKwUvBzlUnWh8a05BrH05JKlPHSzxIgfYiDJYXxgKZdtHRZ2ImbqVXScakv93h1XmLw7l1WDHczjuouz8TuC@vger.kernel.org
X-Gm-Message-State: AFuF++nq2udhBhuzaSeI+MNMtN5tZCYg3jMJeSLdkl4ovYh2ag3q4SV+
	J/vSaaBVeAz9Tqyh9NWghZAiEY/W9vvtCMIs10We3ECPk9OYnHtnaU6+ls2ipNaDmkDiVi35i05
	RCGo2AfK7PR/i3RhSWQ4+EHBnlqcpdTjQeqrQjL4=
X-Gm-Gg: AYBFou1fErWba5vsXPWcDcZQxQye7UaZFy7vWLq+yjIYu3oGrlUkRTIbdVovKVI3LPE
	sWir9/DLz+RzxYNZdWDbOC2b3/kW7DC82PiV1NFNoJZjHppGbkEMItPlGNWk0UDMk45FBu+vCWs
	6uT6VtqzDbgljH1CT3Wn3JE7rPq8ZtZYa7tFA91DT10M/0R9BxR4mfqMMmvLtuLT/YP30Fv2NCw
	nud5XG5WRWXm9XtIejxqsqbSIhupLN15If26thZ9qwGgDfaGvktNP2L+VQCz4VPB3s1kyDQ2ZKg
	tFi/OagacYDa5bNR2G7k3P1VsLfeWi5PUsE0UgiF3a1caUDLOOYAHdSUZxeiztJD2GYWEr5hK8W
	IgaBP+O1N1oNMfD+b0Z4n+EnLN7m8Fhd2leLgjsKiOwXDvKiKT5PU+qylL7c2nqiIEw==
X-Received: by 2002:a05:6a21:ed0e:b0:3dd:85aa:4524 with SMTP id
 adf61e73a8af0-3ddf7f621c9mr671555637.31.1790114251607; Tue, 22 Sep 2026
 14:57:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADvbK_eQjfg_-HLT3zJ5Bt5LWbUTx_+fLG5ggLPNY1Ah+sF9GA@mail.gmail.com>
 <20260921093707.1432184-1-ljp1205831794@gmail.com>
In-Reply-To: <20260921093707.1432184-1-ljp1205831794@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 22 Sep 2026 17:57:19 -0400
X-Gm-Features: AcwNN1U7cgG6CZuztU84c0xhghDR4KjaSxl8F5SVHRVMSVuORbENN7O2ZFigJc4
Message-ID: <CADvbK_ftzE++ETSSjwUL8qHAzjy6eZY6uU0oMJyfBABC1CdFKg@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: discard the rest of the packet on a
 stale-cookie error
To: Aohan Mei <ljp1205831794@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, 
	marcelo.leitner@gmail.com, imv4bel@gmail.com, 
	Aohan Mei <henrymei@tencent.com>, TencentOS Corvus AI <corvus@tencent.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 5:37=E2=80=AFAM Aohan Mei <ljp1205831794@gmail.com>=
 wrote:
>
> Hi Xin,
>
> Thanks a lot for the review and the suggestion.  Implemented in v2:
> SCTP_CMD_DISCARD_PACKET queued at the end of the stale-cookie retry.
>
> Verified with the reproducer: the kprobe trace now shows the ERROR
> chunk still removing the transport (sctp_assoc_rm_peer/
> sctp_transport_free fire as before) but no further chunk of the packet
> being processed, and asoc->peer.last_data_from keeps the redirection
> done by sctp_assoc_rm_peer().  The KASAN use-after-free is gone and
> the association completes the retry handshake normally.
>
> This also takes care of the other same-packet sinks the sashiko review
> pointed out (sctp_cmd_setup_t2() and the sctp_make_*() reply chunks
> copying chunk->transport into association-lifetime state): the
> remaining chunks are now dropped before they can run, in line with
> what sctp_inq_push() does for chunks whose transport was removed
> before processing.
>
> Regarding the cookie-echo restart path the review mentioned
> (sctp_assoc_update() removing the arrival transport mid-packet, with a
> bundled [COOKIE ECHO][SHUTDOWN] reaching SCTP_CMD_SETUP_T2): discarding
> the packet does not look like an option there, as bundling DATA with
> COOKIE-ECHO is a legitimate fast path.  I can look into clearing the
> in-progress chunk's transport on removal, or a loop-level check, as a
> follow-up - please let me know if you'd rather have it handled here.
>
Thanks for checking the AI comments from the last version.

First, you need to check if it's possible to remove a transport that is
the same as chunk->transport in sctp_assoc_update(). As far as I know,
the chunk->transport should always be included in the new asoc.

> On the bitfield concern: v2 no longer reads transport->dead at all.
> The race described (sctp_icmp_frag_needed() in softirq doing a
> non-atomic read-modify-write of pmtu_pending racing dead =3D 1) would
> also defeat the existing transport->dead check in sctp_inq_push() from
> 03a9d10ecf71, so it might be worth moving that flag into its own word
> separately.
>
Sounds good to me.

But move pmtu_pending instead, as I think it's the only one bit that might
get updated without holding the sock lock.

Also, split this __u32 field to two __u16 fields without changing the size
of struct sctp_transport.

> As for the reproducer: it is a single static binary that plays both
> roles over a TUN device - the victim side is a plain SCTP client
> socket, while the peer side answers the INIT-ACK advertising a primary
> and a non-primary address plus FWD-TSN support, injects the bundled
> [ERROR(Stale Cookie)][DATA] from the non-primary address while the
> association is COOKIE-ECHOED, completes the retry handshake, and sends
> an FWD-TSN one second later to consume the dangling pointer.  It was
> verified on tlinux 6.6.119 and on mainline v7.2-rc6-343, where it
> still fires with 03a9d10ecf71f applied and is clean with this patch on
> top.
>
> Since it is a ready-to-run trigger for the bug, I'd prefer not to post
> it to the public list - would it be OK if I send it to you and Marcelo
> off-list instead?  Happy to share it in whatever way you prefer.
>
Sure, sending to the maintainers is okay to me.

Thanks.
