Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491D443A7E8
	for <linux-sctp@vger.kernel.org>; Thu, 23 Jul 2026 15:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820823; cv=pass; b=BJxhZymd6va1XO4w0kMiAQR8EoJ32yaIMprRsX3VhKao+tRH0miJ8ZNKNKpkKD8TDluSeuRNVtdKTVLCpulMfdKhxAIY9naFFpQU/qCtW1wZObCl29dKhhirZwcpB0bIkhRXoRp+6VJVrH95xVdR+1QH6y9AkoJp1keMUaSpR5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820823; c=relaxed/simple;
	bh=Rz7upTm4pxfuFzgQz7YjZms6gbEYTpepr7z+iFrlmB8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MGgOwON/FoSiMVEUfuuaHWpY5ScFStda3UfQIMhM8YCEZLuNAMRMtxBk1Upyg5BbDO21Z7tlVW9hjoFVQmQuWzTZcX7ExLTA6pvWEwVRZwLoWBXB+8AKNFb890UBB15oYcMivUz+SaA7r9f8wmxo5PJJXyfKAsjLaWYr7nXFN3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XepvaSm1; arc=pass smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XepvaSm1"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-738cdd667ceso207808137.3
        for <linux-sctp@vger.kernel.org>; Thu, 23 Jul 2026 08:33:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784820821; cv=none;
        d=google.com; s=arc-20260327;
        b=XWC7TmLV9zW+zjAXtUkahkoxl4iXhArhj3wnTCsyvboAAjAkYmvrQ88FSwO3Q5cga9
         ThWqRPaHiPCaQ4hpowXjxIN9uPPLf2DjPWGPcjZ95779ak8bMQBy3NQH8cT1MzBvQdoe
         5G3kBTg8rmZErxlYsgnPg2dM8CFELwqfBm5vxvcAdVnvyVYG384E4NYHU8TUJI2TtsXr
         3idJBZn9/1fK1QcoDfTSqa+s50tBvBt+bSUGC++ygTXUWvDpumcMcppSn2wfYkVhW5pC
         T8d2exmCC9fE+ByDm+j/z1+NRLbrhfgm/Lo1qAq+wNn0uwTfYYS1lztg3jZVHuoqa8KN
         xeGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rz7upTm4pxfuFzgQz7YjZms6gbEYTpepr7z+iFrlmB8=;
        fh=QyfqvYo0+eNUCJhFXQBZerHv6s4VMuxjLmFHrGq667c=;
        b=h63BFF4Bihs7nWox+6HuVB9m8i+6+5+CwhwVkdSQN6IRUdkx+bBD4Nvmy7YIv6R8Gr
         rCO7wn/zydXSiCb9potQCrV1Y6mVZtRRYjVbnlkUZarx/piLneZ7zH+aUnyWtO9RA6GJ
         XEzYJRVy+Wz2O+RIi8+UBYtPrqAncHc3lNWp2IOFbDkzEI1jHILopY9g39Z3WOX5DrB2
         XzAQEDZ2LxkuDHQstSE5rB0QcKu7nDmuLxU6nueP6zvKOx0FtoD47AXOgfXiiakETzoB
         NkPJ6NLj1XoPMYU/+1H40olvTZs6MJ517lnxOSq5YCFH1C+KXcMq9t31YjM3z1L1URpZ
         cvLQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784820821; x=1785425621; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Rz7upTm4pxfuFzgQz7YjZms6gbEYTpepr7z+iFrlmB8=;
        b=XepvaSm1ZJjICMWMi7bJn2+veSsV13hGLscDC7OXQ5R3z9HwgYaU166c7bSMq7OfxV
         lJ0VV6vrqrW7LenMpXy4Inn/8TcQ834zwgllI6NroY34fBI2MRFiWo7jItiqhFclZmoh
         GBWIHyEj8NMK9ZsEt+s+iH/9XP4dVVSJHQs5E9sOPNqWfbt2B/JWBd8fHhGpklixgHZB
         f6JlyzQVuPThsBSy+6szs2gsMVav8Y2iV0eQ8wdg5Io6jY//FiwvBBSY3GAIax/7TJdK
         u6CV0cVap/ihi4cmOmV0MfYrwgrzHx+GwoAJpOCO7ZuuL/pocypwyCDFpmUebZbePPRF
         Twaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784820821; x=1785425621;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rz7upTm4pxfuFzgQz7YjZms6gbEYTpepr7z+iFrlmB8=;
        b=PWcQRb2h5SM82hlOqgpDfTCvv5QomvevJ8CsnbzDwi/KMv4KGJFhEFo10QnikV0suk
         1dwd8tycXwqq9q2/kdKes7FURtuav2uTH5Adxt3VMr19NQWNOOJsX7i3fiEaWw2IuLWe
         1oWeP8TnSHa94WrMq0mn/ULQ6Ea2enr00jJ+X18uxnCF5UGhSgfsGdSjUUsOrdolSdqi
         PfNI5v0g2TcaK7Wh4KPpBycnqRiIBgPei475tFvtRG63yacXDOOMe0nX5jS7k11EYq8q
         9GbLviFOsTxILf7U+320G6R1fNaiR+a4dQJjz6acD23pc7fWlYe4zY7RF/zcmRXtgrPr
         +gGg==
X-Forwarded-Encrypted: i=1; AHgh+Ro2MXmtCfkubD+hYBLM7+aClKG7avb6474w33Jv8B6vPAY3tqdrETVYE3cEG/oulc0RY2Xw1msREWai@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq7Y3Ba0mIPI7rkGel6kOPZ+I8ZXYuKmgCzwoD6Esc4BshpSDt
	sMrMxa32ucOX8chAJOZjgMsY9q7SOqd0d8oifXJFMcHy+VnNJhaeYN/tey82seDwr/ZeRAl001I
	NAgSKsgsMJRZVGm0kRFsxlA6I2YYEA/w=
X-Gm-Gg: AR+sD10R5KbvP0h3fUj+qUv3+JQSAwCQ442V9jbTMpnJzyKhbGTQ+q8xv7CyytdPrrU
	JGuWrSQrRMOLFS53r8Be1mGQd18MLJ26DNb0d8CjZhAQiWMlu3ytGE+RiZ7vbTgD9hjBQCYOyc7
	i1Ii+6fOPdXTD1ErcwyYWD46ZzXg9hu+V3Kc/jppWcJ9O6cbeferMhmfgWOoaLqcYKGPcd+cWDb
	A5Ysf2mpHrdNPRTzUPNEezLQbPvTUk6fwRujwkw4wg3hYN1KA/NKHSM7oFa9+6PrJeq0psL7+g4
	dBf0mWFAw2UDRhJDKq1og/PTsRzqOEAfnrJo6N5YLdh9t2MRCteOxEDzfj/rIA==
X-Received: by 2002:a05:6102:8606:10b0:74d:d2be:b164 with SMTP id
 ada2fe7eead31-74dd2beb556mr544798137.29.1784820821119; Thu, 23 Jul 2026
 08:33:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <tencent_73762ED1DF08CC9D5F5F61954B01350CFE0A@qq.com> <20260723072924.7db6b065@kernel.org>
In-Reply-To: <20260723072924.7db6b065@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 23 Jul 2026 11:33:27 -0400
X-Gm-Features: AUfX_mx90Lhga-KS7yDsLk2MwoKth3UsEIGFsDBzPx31uQtuZ_euYpTHkPTC9go
Message-ID: <CADvbK_fjH_XGMVjZGXAk_Zj6_GOHu3u2bj9wOSMRymwNMK-k5g@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: don't free the ASCONF's own transport in
 DEL-IP processing
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jun Yang <1753810072@qq.com>, netdev@vger.kernel.org, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jun Yang <junvyyang@tencent.com>, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 10:29=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Tue, 21 Jul 2026 21:14:05 +0800 Jun Yang wrote:
> > Acked-by: Xin Long <lucien.xin@gmail.com>
>
> Could you point me to where Xin Long acked this?
> I don't see the ack in replies to v1 or v2.
Hi Jakub,

He initially sent the patch to security@kernel.org, and I asked him to
submit it to netdev with my Ack.

By the way, there's a question about whether patches for security fixes
should include the PoC in the patch/cover-letter when they're posted to
the netdev ML?

Thanks,
