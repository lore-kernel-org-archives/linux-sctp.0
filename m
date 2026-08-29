Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0CB187346
	for <linux-sctp@vger.kernel.org>; Sat, 29 Aug 2026 21:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788040056; cv=pass; b=pRG3Kd7sajQDw9bDh1JoxxLU2Iow0UST2sOWx6kf2c2ttWwJSfZIcfru8XlRnA+Bzqnz1mPdsIfbtUBZk+tBRAXsLOIhHcDsuBHerTV2+2udZt6kF2D4nVhmf/vd85RuBYIuLT7W22CPhsT6kB9hhVHJFUVyvmo8j/3TQeAOhYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788040056; c=relaxed/simple;
	bh=dL+VDFU45yCois3gxJcRVnfvOnaaUK1D9SRMNEOKK0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lp3QTVOdkJUJwZxIJn9/lvh7Rzx9aQdR8CDPn5JVjX6ip3H+RAXMSa3vJhHrIOj/86hg9lboXU8U3GuSCMGa8gYer4DH9t77K0/g0CVATMLB5u8KWV5oS+WeD4nVynzlcSrnmUAgE75kujCwF+//SLb10KRVCzf5abi+3jjyKWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y6X0Bi7Q; arc=pass smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y6X0Bi7Q"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-854f8068301so1372085b3a.0
        for <linux-sctp@vger.kernel.org>; Sat, 29 Aug 2026 14:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788040055; cv=none;
        d=google.com; s=arc-20260327;
        b=lb2n2ZqcIzMjR6nN0zcPv9GbG7MEHsPpPhFWBlx3+v82wwRiN/AZKHOUIZtvaXFjEv
         5oy/X9L5ux+nZhN2s/OjqkcQCa3WbYRHXN/S8Xo2lKH6KNET7VsLjutKNmOgC3wqub0r
         3hj/E/KN2lafuKM14DYnzbjl3HwmbNozH4ulzuTPccPpXymBBFI5iXG4WV7XpudXsNAJ
         6Z7pe0a9yTJXEWJANp7lYex60Sj1GcWqvWCftcNFGKHu+9J0VlwWiguqfg9cq5I1thHB
         kRQFYrf4g2IrjOAUoG36ol+H8AYxoKhgrUfwcuYY2scbLTDpfjI4AjORg04l9L+lV/B8
         1X5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dL+VDFU45yCois3gxJcRVnfvOnaaUK1D9SRMNEOKK0A=;
        fh=GYo02MI//aioYyPj5oX1uOj8QNnP3K1ilPA0BXyWcn0=;
        b=DrDnAmB6xW0W6TMgun+zdRNSxBFztsIdriSvNkU6uZ8oGmlMt2b3O9LKRyycL0/gCZ
         qYtHzSbYbmMN1OqXn3z7xle5hp5H5q9NHJCGKBBuFvXNYo8VrSHw/+631LIP9aWe5PyR
         PJWK5k+Xg0LoMwuEr7kUcnaDLm3GGNlkHd9QaHpIarOzSKKryUY4gGG+VU0OW+irLhiF
         j7pJXdVCBbGX2Q7w2pa8N3Abv16WIAqNq+kzg3CVkeRdVEVKwXNIVCj/feNvI+h7kWyK
         kGAei3nx4Lyrj0kj3M1EzPI3cDyYbngpDCPmENDjXCm9h9C446KcMaPw40/EOENHvJWY
         aE7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788040055; x=1788644855; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dL+VDFU45yCois3gxJcRVnfvOnaaUK1D9SRMNEOKK0A=;
        b=Y6X0Bi7QXUjqQaAY+GIi1/+XeXVPhstyiKaMSHVCMnW4mbwYtq837X+JApXDrK1IZg
         jhwfzErd9om8vcBeBaVZhitL5kjBgttEP8oFcR+NEh+CQfQ/Nax3q1g3cPXpeCF+g/VG
         tkDvfnwzwnl7X49SaKl+Jg6ttFcxX8vfJX7wp7N7vbtzMqXIwuZ/JHGl7LfEykvHT+zZ
         8OYJvCWzeoj5EckB+OMDwqrdFczUb+KGa2CxH6fWy7ID5ahMcspsmZFA+dNm/QKPLzk0
         dcP33v3GiEJD6A/7oVqCi1MKzNeg3RvEuKTYaDyNkZSuF1O+pdSYfaAEbwk+2tr8kaUU
         kV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788040055; x=1788644855;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dL+VDFU45yCois3gxJcRVnfvOnaaUK1D9SRMNEOKK0A=;
        b=sL43j707FrBrJabKwqtuD2GOue0UyccdQDalfh9GIu55+p3oftcTchorSl4J776fKw
         ZM0/iGf5nUE+2obYGQcyP2H4E9VoUNsFFHUJlkkc11rFZdV1t55JvkKTeLNomhsJ1AUQ
         wiab1z616esHSbeLyeEiDZCkcGsnWr1vNVXme4JLypVgBroIEPVtTqDk1SjuK5uUTeTw
         2Lku1BJH+p5RwBnllNQw+ZaW3OpI5LmlaX/+dzm+IXq1bu9in/hyAf0cgfL5TnhhZVj9
         xB2LRJrS9pvMLfUvCsSqQA+/AAhch1qNl2rqB75s2BaGKQrATmZEn7D+Lw2hE1x1vI1m
         M00Q==
X-Forwarded-Encrypted: i=1; AHgh+RrIlbjnWiADbexE4p3Y6hoGG22pv9E+pi4Gvenx5EAJebPro/farRArAFp992iYWPrNUBVPFQ2Poo3Y@vger.kernel.org
X-Gm-Message-State: AFuF++mErnPaZDaz6bThtuLMPLombzZYH6g4f8W4qNfvZLFG+jdbLN1o
	OeGE01Zuvkn5sH1Nknf8Qm9WeJM6Udi6INktvjOZjxNmQJA5/AkVSZuYXCGyDsuhLFwf0oeOZvk
	zgdfO0mVKSX64KA+ZYui3Etg0BTB1sBc=
X-Gm-Gg: AR+sD12t9uqsvEtvhADjF7TDW4Iqc2fFV+3ilGBbOVU4tXIB7S4f35oP1Ge57MkOnZ/
	V4pXGJhT8kTewVC2bvdfpoeb9T8l4HoGpdqebrsFyF5tAvS/BUKhUOGzg6yVn90zqWkhxCCxY6w
	1zGCebBTtKRHAt/cJNy5RKuI5MqCts21RBHkMDm2xCMqC989wgsWlCFj/WFywtCCr9aP44HjRej
	xF4n4o0kKs76Cl0Gyf/BqhAx7Df/hSge5WeKjNGxPawbbqCndwkCRWrO/bNpOwhiClFzBUw+7Gf
	BDtLyFmL/59R/op3LwM1HgGprCVRtyMalBskb93hqqhuJYzkquw84PeeZ1M2gwa5K3abuOsJj+e
	H7ToWAoefCBXsDMDffoZ1kpTkX8xMp3KWq9fG91b1ZjtC/55N2hb1EGSre0473x9S6s+htSPxZn
	MP6w==
X-Received: by 2002:a05:6a00:1784:b0:845:3d82:10fc with SMTP id
 d2e1a72fcca58-8562496610fmr24817174b3a.0.1788040054857; Sat, 29 Aug 2026
 14:47:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828042431.3873725-1-bsdhenrymartin@gmail.com>
In-Reply-To: <20260828042431.3873725-1-bsdhenrymartin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 29 Aug 2026 17:47:23 -0400
X-Gm-Features: AcwNN1WiOSynrEt77wHMbuhlYYcsQEJr0-lkDpv1WrESJeoHxsfDDV0uqJIQ4mE
Message-ID: <CADvbK_e6K5UZDy=BzjE7OLTQm-h5n0MQD5n6fOOD=F4s3sbqAA@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: fix soft lockup from unpadded ASCONF-ACK
 parameter iteration
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 28, 2026 at 12:24=E2=80=AFAM Henry Martin <bsdhenrymartin@gmail=
.com> wrote:
>
> sctp_verify_asconf() walks ASCONF-ACK parameters with
> sctp_walk_params(), which advances by SCTP_PAD4(length), while the
> consumer sctp_get_asconf_response() iterates the same parameters
> advancing by the raw length, without padding. A single odd-length
> parameter desynchronises the two walks and makes the consumer
> interpret attacker-controlled bytes at a misaligned offset.
>
> When those bytes yield a length of zero, the while loop over
> asconf_ack_len makes no progress, spinning forever in softirq
> context, and the watchdog reports a soft lockup. All reads stay
> within the received skb, so the lockup is a pure remote denial of
> service. A remote peer can trigger it with a crafted ASCONF-ACK on
> an ADD-IP enabled association with an outstanding ASCONF (RFC 5061
> section 4.1.2 requires the chunk to be authenticated, but the
> predefined empty key id 0 allows the peer to compute the same
> association HMAC from publicly exchanged parameters, so the gate
> does not help).
>
> The SCTP_PARAM_ERR_CAUSE case of sctp_verify_asconf() also performs
> no length check, letting a parameter without a complete error
> header reach the consumer, which reads errhdr.cause past the end of
> the parameter, an out-of-bounds read.
>
> Reject SCTP_PARAM_ERR_CAUSE parameters shorter than
> sizeof(struct sctp_addip_param) + sizeof(struct sctp_errhdr) at the
> verifier, and advance the consumer iterator with the same padding
> rule as the verifier to keep the two walks in lockstep. The verifier
> change guarantees a complete error header in every ERR_CAUSE
> parameter the consumer can see, so the consumer's asconf_ack_len
> check is dropped and it returns err_param->cause directly. The
> consumer padding fix is still required because odd lengths remain
> valid for SCTP_PARAM_ERR_CAUSE per RFC 5061.
>
> The issue was found by ZeroHive, a vulnerability hunting agent at
> Tencent Yunding Lab.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>

Acked-by: Xin Long <lucien.xin@gmail.com>
