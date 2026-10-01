Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BFB3CD8CA
	for <linux-sctp@vger.kernel.org>; Thu,  1 Oct 2026 18:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790880795; cv=pass; b=rzckddTVBuQ2rzsf9ky/Fql7N3oOIrvNqvYp3zrh/G4OWZhsSMYZOhIiv1jWksoawYzncMzI4PDbINUMsjyCPaFLgvQmS7ZHFnTbhZ2n7VT0WQjaaBlMkzAzMyLq9+52dNnhqj+R/QfWfemjEGm/3ejXpfnPajEh843IVJmmEkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790880795; c=relaxed/simple;
	bh=Y+2Ni7PMqrXeJ+Ib9G+7B54AUw9Jq7EWt/AyyHD6kBU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U7yGZro2pJUyfc+EIVGuH2jxaRL+zyQ+WHHjopuksRH9UQK1UcKA7Uhu0gc2HsIGo24Y3ihTV2PvTjU1jtS3ZKhKihAsJ62rFEhGnPCwWruBaTc8/mo7/brEvwl46N+VY1rmP3IAs3RWq0QwRRRXo4pl7ZT/tTz3Ruom1ifNej4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QaHrE+hC; arc=pass smtp.client-ip=74.125.228.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QaHrE+hC"
Received: by mail-pz2-f38.google.com with SMTP id 41be03b00d2f7-cc7a15ba46fso2186327a12.2
        for <linux-sctp@vger.kernel.org>; Thu, 01 Oct 2026 11:53:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790880794; cv=none;
        d=google.com; s=arc-20260327;
        b=BMNlxhPqVWBEeWXsSstsxRFI/+grCfBc+s4Jq7Ykht0drTjtJFP5fDgBN6mTEoIZRF
         OBSqmAKFCoy4De7T8O4oITp4/LDPRMVhfZYz74T3ttUM3p/MLSncCQYbHHP2luKI37fo
         JEhQiAD9yHL0ZrdNgc1uSJfbmNNYbJUwVrs63I/RVOPG9s6zmotrLuNs9IOwtwjaZ/lG
         EcOQA922mv0ABuyQJZfJTEcUZlffxUSw0GDZDpUToAMfQ9JzYB2OSl+N+hPz+aWUxL1O
         8vzkk7LSrlZxO0nlLSgdDTEh0FtX4p8rMsHP/t9yE8fLdVWDeUeUMMlrDP3FTD++Bvoc
         f9pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y+2Ni7PMqrXeJ+Ib9G+7B54AUw9Jq7EWt/AyyHD6kBU=;
        fh=3Yq2xuMh/UGPh2O24YRQrc/9SLGysyTR0KAhOhV0X9U=;
        b=jIC9631UKCjtwIm5sSwds389sjW88pFj8TjZCNizK0F4j2XFid7CFX9aj8L1v44QHa
         3GuTB2EdzKHrFedbVazGlRbHARu7uZSvY47ZusHJWqpKo6VUoqTcaZuvfLVLey5xy9Q/
         bY3Nof9qvgyYn6/4Jt+AA8MLisvBpu8sGcFe4DYRwReu6crij6Kmoivnt463dTnrsX8s
         ogTLTkXog9xd0jr9otz0GrpCPJO1P67h7vs+u1/FSW335fN+8JGuhSFc63GVbm/jGu0n
         Z8HdSPKW3oezKvdZ371EKz+toeQ0RolVaWRYRCRTxoydBv3wNLb5EiUw8R0Z9QjRzb0k
         vl/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790880794; x=1791485594; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y+2Ni7PMqrXeJ+Ib9G+7B54AUw9Jq7EWt/AyyHD6kBU=;
        b=QaHrE+hCNs8GieY6eP5AQgY/PyRFHQ780LwDdjfXqNcIG4Z/WD9011G9Vl3+sk7UgR
         qc5vstTNGaTFMYvm0bzKAkJb6Xr4+SF6gJsP1gyJH5GbwchYAA7+HuqbwqBnlUI/NBX5
         mCb/R2mNEPrqiTubYL4A6e19MS0lmlQ16GU2X0E142W81oJipUKhSIvoly4YOyXJB6LD
         gfDT+g+XNpMENzsv3QR3R7Yu0Lsd7tUkUMHAYNriZpDQt9KeLE55AvyaklTIp7QXfJAD
         GbhN6rhsnYXTx7AfS78BNXfbXCrvWuZ3B78UrsT9iey+glF2ANw2rZynvzsN45pIvM45
         vuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790880794; x=1791485594;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y+2Ni7PMqrXeJ+Ib9G+7B54AUw9Jq7EWt/AyyHD6kBU=;
        b=Gc/4zNnsX0bAbtcha/feLU2coJZyCVTOpFiWgS3KHzQKqTdedorCqT5NkMQ7xbaljA
         km5q5he59Hm0Xn9FgfLF9dyia1tqUdwzMfTqVGSeSeRGvj4fh8m5RscMc27DuZlzdI1z
         L4gtRbUMEeZXeu2Sp8hKy0XmwsdJNFazxxMnGNQn3r3X4UhayCicuW1y+Er2V3Dv4LZx
         1Alze2itV7ZnOmbnIN92DGoDdCgtZF9jj7A82VNv4G3O8Yk8f+RtiT9M8dVztla6Oefa
         FIP+/tkypYllop0edngwi6x4N7R6p8AvgigWP68oaBh4MNRiAFZLc1c5b2BvYtuXN0N6
         w25w==
X-Forwarded-Encrypted: i=1; AKwUvBxvJQ1xUqbsEwV6fs8iBQha/VSvX4fGUI9ipbjN+iFc0G3BJpJhyZjePNZ3/ANs0w1jEUQIAMVFmfGR@vger.kernel.org
X-Gm-Message-State: AFuF++nqukwF/6jgcej3P+d2ioCe4bNFfA4XzDxKyiSdp6zl6UiCJyhl
	/5MHRSN1UkvmYrqY6MXWJHMio14wgg1A0HXVCsJdhrRj3b3Gu/Sg9aUUCEL+iUX66lDSkXi30kh
	DvuzOSW6BnWlEXDgOdGBSPGrst4xRe/8=
X-Gm-Gg: AYBFou3VSvltWPh8U+IVvPyaUMJLTvh68dGFAvATLsYN4XhllDz5AOB1Mp1h4qii3Jk
	N7pzeKOaUjiBwQvdwe9PJAGUmmGlGZfWZYu+B2TAM4N57nwZFzloPd3FDAXN+oG3BS7ZpOk2toe
	RD0v1UJyCDa8F42wCDQwEHu7QZY+c/26bVWLft+IHaFu8hU9f0CeS6NFMmaOhyG8bQfOVjQTKws
	aHegWvSxUiXdwFGwgGp4sX8vREKFbNvIMQlgeg3Hzi+I6H54dvTbz2VMhU9RE0KTMIG0tk9K7i+
	q5bGQloFCIuY8GSCmDBzJ5FovnPN0q/5AxWj8T2NRExxidzPsgk5rPe7t+psMipediaZlEyX51o
	zPunxQPTYot5OwmwP39/RQnjFjQJomezeSbGawDuFyzTZckJsiYoZBuEJQg==
X-Received: by 2002:a05:6a21:8289:b0:3dd:a197:736e with SMTP id
 adf61e73a8af0-3e0bd24822amr308001637.71.1790880793837; Thu, 01 Oct 2026
 11:53:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928152132.3705137-1-guncraft2000@naver.com>
In-Reply-To: <20260928152132.3705137-1-guncraft2000@naver.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 1 Oct 2026 14:53:02 -0400
X-Gm-Features: AclHuK8d7NtbaPQb6Cfc9lQW_joRcJ6ZbSCH6q966PeL3ZPj33mszk9mvkCU-9o
Message-ID: <CADvbK_eJTrNFyPRSwCtUXqQRe7=_KnbDjsNEK97J4sYp+YpSxw@mail.gmail.com>
Subject: Re: [PATCH] sctp: hold transport reference across connect wait
To: Seung Min Shin <guncraft2000@naver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 11:21=E2=80=AFAM Seung Min Shin <guncraft2000@naver=
.com> wrote:
>
> sctp_sendmsg_to_asoc() selects a transport before waiting for a new
> interleaved association to become established. sctp_wait_for_connect()
> drops the socket lock while sleeping.
>
> While the lock is dropped, backlog processing can handle a COOKIE ACK and
> an ASCONF DEL-IP that removes the selected transport. sctp_assoc_rm_peer(=
)
> then marks the transport dead and drops its association-owned reference.
> The transport can be freed through RCU before the send path resumes.
>
> After the wait, the stale pointer is assigned to newly created DATA or
> I-DATA chunks and later dereferenced by sctp_outq_select_transport().
>
> Hold a reference to the selected transport across
> sctp_wait_for_connect(). After the socket lock is reacquired, abort the
> send if the transport was marked dead. Callers without a selected
> transport pass NULL and retain their existing behavior.
>
> Cc: stable@kernel.org
> Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_inter=
leave")
> Assisted-by: LLM
> Signed-off-by: Seung Min Shin <guncraft2000@naver.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
