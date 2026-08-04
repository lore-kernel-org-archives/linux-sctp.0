Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5692DCC05
	for <linux-sctp@vger.kernel.org>; Tue,  4 Aug 2026 18:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785868300; cv=pass; b=hIkB5sLRY6uCnV178HT+1WQBZesthpKCmQaFKPA4ZSv67qjxnlQl8DJZ8yZIezmIJWPqHGxylWy9qulxQAPBcKdqDMpm/18iuDcCnDu0E1mSAQD/g4sJTLCY6JYjgfjoRh/4HikC9hzC30fifyum0+vDWSUJhpVqxDigmDacF5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785868300; c=relaxed/simple;
	bh=J/En1C5hIlRgS5P+Kb5JhJHyJnF1jC529V+a2OjcoMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VuHpNyqhAlN0y4ypxivQWt8lqjHtsQP92vJqqKh0mHzzFAKhWHY5ZSdwZup7uCPMIXqForwc3We9R7f8ihqEzQQtRozq63pKemps4GnmkwmQS1aY/+hxdiqXsSFEN5yKloz7QG8K438h3XSI3PWy7PvBQ9J1A+6uOSgA9Q1he/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W8Hd0Bcu; arc=pass smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8Hd0Bcu"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84e3007a2b7so130321b3a.0
        for <linux-sctp@vger.kernel.org>; Tue, 04 Aug 2026 11:31:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785868299; cv=none;
        d=google.com; s=arc-20260327;
        b=c7Hv+RJoKOpBAa8Cdtg8gpYbOLMpN0pmA5Qd/Nim9FAU/n6WG+EfAoBx12P8UqgRhN
         oibR4nwiCifezVEhywC+mVXr+sF1I+1QEoCW+pQi6LhxN0vX8JEJKskcfqwvAO2nmsUA
         JTkKy63zHgo+Qd1wajMtzvHq7cixiSEMBzzSTNi+ZZ3OBjF+Tk4iqd00I7YQH0KFJIv0
         0tmrR4RgUY+vdmR8JnXbWKlZLF3liuOq3V2ab8seIzFiRHv0d6GhB/MJUBlJVserARSR
         adS5j/44cirKn0r7MHVTwF5ha0dWfJsPicw1WJ2O2QtztoNwdhPYTdXqFzKsXjq03cVN
         MWDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J/En1C5hIlRgS5P+Kb5JhJHyJnF1jC529V+a2OjcoMA=;
        fh=ZNUHrfypRSQnp/o4ZDjdYhRx4skGuJARqes6tGma2Fw=;
        b=ZUWPotm/yBdWCjKgN+vdOsCUEbw2M/Dyi/dLAphfYu8mzMe/ptDB4grd3DCqyQuNOs
         61bf5wxlUAdEDyf8jLcFFBfBy1PRVkmHvQ7LNp695DeUTCPAN3hxVLggpAN70rChLdyY
         uRr7YbPA7dbNSRBMw+FfaaswZOvoUdRZsJLDLzZGSs5bufT9LjbPBQq2apdDWQzED3gJ
         awP5gO2NTF25m9xB6CBLDXad0YbK0DhXMFTtVm9Dk2crfCcDmfJACqnVy/R+BE332jxb
         WCCGEpCx5JRpDZEI6PbgGbXBjIZXm63uisV+GIwpWNg4tPgZr35OWucqxYRwcFY5QwAh
         xzEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785868299; x=1786473099; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J/En1C5hIlRgS5P+Kb5JhJHyJnF1jC529V+a2OjcoMA=;
        b=W8Hd0BcusroryyIo1zuvxaxGE5/7vpCH7LNP3/omnil+3os5MOQcgb9Jyh+3hJG6LA
         R6C6UGqp4b9eaXpbHP7nTYQIERehm0yM0fnOl+pVHThcYaWGQxapdQdJ8Nw5O6V81ahn
         eRIu7IdqZMiCKkTA12fIoOHULCpIeal9ONuHwGT3ukHWb7O5hjvIvtUQSb+69zVLGESU
         fCwoaZ0zVt4ygH2RzWi1Fa9gRbhI5gkdeIyViNir5FHzvruS5ZC6P3x6mJerf3x4/elP
         LMzbZ3Gc1R/lTzcKMGEUZeza0nNBH2GnXxRVrvT0bLmQ9Eap/tjEYm/xymSCeC/B2lRw
         nwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785868299; x=1786473099;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J/En1C5hIlRgS5P+Kb5JhJHyJnF1jC529V+a2OjcoMA=;
        b=SW65CX5fGhs77m/bUyscWrDo+jydqLUBPg8DEt4hkF1ETLQkUBzPLucsnRMa/Yb+aX
         JBmMwkuSqQmxDv4fjdSfWPby70MA8Gqa3b0s2hbyePyeYk8vPz2qaMVZvdTv3GW6AaRt
         ztqhG/XuVaJ7nCcy27bCEc8OVZxFA0X6GY81tsZloD0PhF76yKjlwFMQfcISY9KqqA6a
         z9ueqmTMW5Qf1ibW2IH+H/UzQ7lGDJV8ozdz60GK+ofzOIYrKMCOZpWFNo+NGoFaRTho
         DLft0bKj0sJSVy5YjtRAjLLADAofLyZb09UzI4Y5bfZj3RBRTYXnxf6Uv/yqHFY1Z52A
         xZUg==
X-Forwarded-Encrypted: i=1; AHgh+Rq243Ieq6ICZxzuFmmF4GX8lXN2aN5yJw2fqgkZ35ISbtoiTwdEGDEEu4uPGqlPps7K0x/QZK8lAy/n@vger.kernel.org
X-Gm-Message-State: AOJu0YyIl3Pj1rWZQZAv8/JC8jXLdPZNa8+PuqLV/Zaun6u3U4pLx9MY
	FvXbQfc9J6pcALY4owzAmBZ7tMXQyDYD+iQ/LwE+jDHeZujTdeXaN9Kq8TcGWHx0M6wodO/R6Tn
	FSvjHSjyLYgXNlUaj2XR0q/1Y9pz0kjc=
X-Gm-Gg: AR+sD11Lkkh+mAzi1Kz4ZY4IP8b35obidBSZYDUS2ixFhQZg18VOO3I9s2Ge5C/95PN
	6mUmJY9dzkOGvuy4yrAKApnP8wvUs5kZQfkIity9aCtqQDh3rQ9Nmxmo6M/V6gulO0svRUdCs0q
	SdSwn5hPXpPhKE3X6Q251gUBybRr8TQE4JweCA2qw+KRDeTMH46PMuOklX1bbHJIKbsXLeJftn4
	iVUtkYbnW281KEEW29cwmCgIi0AYACixbJowgKtRTMI0P0M1+QuorEViCzFjLbergNuAkz5AQJ6
	VVKUxL0KkIWIsW40HlSUfzohwo6oyuY6G5R+Wn0ltKWB1BLYyBdpfx28VMJXjtezmbXHCJUjvHj
	PtjwlHehZGvK1OyE/DrEgqjEAwvDm/Uls16MrbzaDehw=
X-Received: by 2002:a05:6a00:14d3:b0:848:63c9:ee38 with SMTP id
 d2e1a72fcca58-84f2e13adafmr699337b3a.39.1785868299014; Tue, 04 Aug 2026
 11:31:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723071818.459034-1-l1138897701@163.com> <20260804025514.241767-1-l1138897701@163.com>
In-Reply-To: <20260804025514.241767-1-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 4 Aug 2026 14:31:26 -0400
X-Gm-Features: AUfX_myhMPbxHNBRRr3ZaLA4Ti65K3gITutgTaweuLNmSAh8E6QJx-yjU8fnmS8
Message-ID: <CADvbK_eDoT4WC21QvP_Pnp4prMv6YUODYPGN_cPuNVc3bs46-g@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: fix addip_serial increment on ASCONF_ACK
 allocation failure
To: luoqing <l1138897701@163.com>
Cc: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, 
	netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 10:56=E2=80=AFPM luoqing <l1138897701@163.com> wrote=
:
>
> From: Qing Luo <luoqing@kylinos.cn>
>
> In sctp_process_asconf(), when sctp_make_asconf_ack() fails to allocate
> the ASCONF_ACK chunk due to memory pressure, the code jumps to the
> done label where asoc->peer.addip_serial is unconditionally incremented.
>
> This leaves the peer's ASCONF (serial N) unacknowledged while the local
> endpoint now expects serial N+1. When the peer retransmits serial N, it
> falls into the serial < addip_serial + 1 branch ,
> which attempts to look up a cached ACK for serial N. No cached ACK
> exists since the allocation failed, so the retransmission is silently
> discarded. The peer eventually times out and ABORTs the association.
>
> Move the addip_serial increment inside the if (asconf_ack) block so that
> the serial number is only advanced when the ASCONF_ACK is successfully
> created and cached. This way, on allocation failure, the serial number
> is unchanged and the peer's retransmitted ASCONF will be correctly
> re-processed.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>

Acked-by: Xin Long <lucien.xin@gmail.com>
