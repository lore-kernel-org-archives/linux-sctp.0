Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795421135;
	b=oZeVJRTC06ecQWTuWLcN0lL761MCJ/Izvb4lOAAOsbD4IDp5wYBfvX/Bcq8w34zQuOx9
	 cqjBtR75vVBR2yyj28vTcJEBTG+WgLURFNSYwNylR5NiNqucr6NBlLlNZyVAyByKai0ry
	 n9Ro3OCQGYnXzgwNepjfVtA73W8lIBDfEk5yqIgBKnTOY2gM7UD89mQ/DhOqJl0M+moyk
	 /XASDeN02gsb7sNFKATgScjerFEedyAqqLJ+6YcfnkW24CylG49HK5IID64bg7DoLHvxV
	 sbAq246pTwvB3zwkVErLXbEzwgi64BVczqxYyeHFn/eCFZrxj8KxBHrbMbRqs7iu8+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795421135;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=Pu4yypJl6coCX7FrhDOYrF2bQ4S6oHs6DmVHvAaSKII=;
	b=Y5FhXTJfXqduHUc2qZzGC62av1faUqYNnAsLpiOxvQdNkdG7ak/YZSPj9x3agfJwDEFB
	 KWXzjuhT9W/PTcRBvqIFOibid0MKTDiZp3SJGnRv72M/i5svSF/P+ug806ndkVbadVhKD
	 LFEHBhUoo2eoYq8vM5k0cPLu3KJBfXyjGmuP7PYVYr6uacy5DFozdSiBpSVGsVTMqAKCV
	 hixszESx963kYz/h82inmKaN+ZU6GFnIICMDPVDHezK/Dj0PA9nQaGlrZ37bRxiXvFSzM
	 /h1+7RK948rZOsH3gRqqdAV3lJM6IfD7DDND7anTps8cZmx95cFX3jsEaiTrLDAaKFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="J8lnH6T/";
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C33F606F63F
	for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 08:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C33F606F63F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J8lnH6T/
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2f03920c4a0so18245655ad.3
        for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 00:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795421135; x=1796025935; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Pu4yypJl6coCX7FrhDOYrF2bQ4S6oHs6DmVHvAaSKII=;
        b=J8lnH6T/iPoKZQTYPXS+7m92CxkIDbF3kbq1rFBp1sMhB+DMCya9n1m+zS7AdtfcU8
         +4ugcIKOF16Wzs71XYDG99Xl3+AiP9ozh9H8h3jvdmFsZ37VqF310KOgGX9K/QeMEZF6
         1b3jD58aotCBiUfOUFG1A6l6S3GdpSAE3lF0FwfAXMbJDp4PUPvzDuIYytcpU+thySZt
         HayFkqAIe8rgdVssZ95SPVMkX1RGdL7K7shqWxIRxT6stBQLiFPy7vSe4n2qLCSgRTdl
         4nDAqz/tc6Dp9/0KtDEFP8nkQ12gpUwcxYZPICf6dvVXrOfMFHup3YqfJlyG6mGPrfnW
         NEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795421135; x=1796025935;
        h=mime-version:content-transfer-encoding:content-type:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pu4yypJl6coCX7FrhDOYrF2bQ4S6oHs6DmVHvAaSKII=;
        b=w/up34Bvn3XBe8fho8fc7VS6eDHmB75830F92XeLyHd1d9fCiDDn7sQvXxnEQu2p8H
         8Rv8SCDPmEC0zRjnUpB3OJT71Y7yzcJNPDOz7dtwTv+1eieY2q0y6D7NzlJ0L/wQM08U
         E1F3M1qCBIfOgJU/YrU6FXAyPmxNETJ/7Dt/a+u+dSINQuNAkaMuCsmy7HoHSMEfjy+2
         A0vky0Q0GSlIuX71M3iwS3hXIfmiXbls/7E3clCz/sRf/IjSd99vXbZbtLA7+DHUXRVa
         RzmJgp3FuguxF3Mufv9ZqXXghQcDhU/xsKzQH/MegTY443e5XPIoKdG2vANS6HN+eOeN
         JO3A==
X-Forwarded-Encrypted: i=1; AL+hErFWbjheJ2lMsRKbAlSDgFKPHTHqXonv2yPQfdqNRfMGdlc4pm+nQYmzA+Rr4a0prioBHwk2mYv1TlPE@vger.kernel.org
X-Gm-Message-State: APuU4Z+kpJVIvN5VAKIdu+Pb64zOQEDG0n+EXjt3rgYD10ZnV9Przw30
	CxIW8xCPIQx2FUrQwFDVp6AehsNGF8Tu7fHUzEc9uNetODzMY46Xh7xr
X-Gm-Gg: AZFdTZfsuIzoeG0w0a+Dp4Ujbw3CHuX71otOvM8eJ+VU5ovcKjuQJM3grpVJIo33a/U
	SixcB40Ov6JGbP6N/l/eizMW6LOPi5GfT8K2/9U259W/jNPwzpIs6T+WjdSpA8s2G0ChX1IHnQM
	HyDO+IL41Y2lTkGoVKTEqCGroPCC/ora21mjMejQKxwOOfOu8hYyGFa5S6mxxlhUg+T/qmZW0jO
	u/xxrB843P0vyFdcCuaCsbtGpmAqDzSHushExOjllI4md3v6tDKUKW89q89aWxcc4KnxG85C5fT
	gpziEh+EeO0jcUj30wxfnKeV3Vk4gnYEsKkfDWXfEjmhLljzORvE4K+sY5MEh8PSTLVWHz4ZMHR
	TkIs275wlHqtakveezc0UyuS9SpdSJO8y3O/jbVwcGBGfscBihZ+OprDuqRpUJX3UTVAOchEqnO
	WGkJHwWy9yi1ni8mrZaugHMEPuLBcLBUuv5Mv8jXius2TahYfuoHk7tvjNAWm/6bO0wJuWQ9u2U
	000g/aETSpOMGGpiFyiXFcw/RZ0RTjE7jjsPOT3C1TPYAPY7oBPJlDUjoCMl8UBP3E41Lo=
X-Received: by 2002:a17:903:2b0f:b0:2e9:5175:2eb with SMTP id d9443c01a7336-2f03ef3d695mr105076155ad.1.1795421134729;
        Mon, 23 Nov 2026 00:05:34 -0800 (PST)
Received: from [172.21.0.2] (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee84425sm49848635ad.6.2026.11.23.00.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 00:05:33 -0800 (PST)
Date: Mon, 23 Nov 2026 00:05:33 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: netdev-bot+sashiko@kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Jun Yang <junvyyang@tencent.com>, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] sctp: auth: NULL asoc->shkey after a failed
 SCTP_CMD_ASSOC_SHKEY makes close() oops
In-Reply-To: <179540440300.3135.8565987128928534228@kernel.org>
References: <179505710266.3511678.14017674052424733262@gmail.com>
 <179540440300.3135.8565987128928534228@kernel.org>
Message-ID: <179542086425.3214459.13730708805653555091@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 23 Nov 2026 03:26:43 +0000, netdev-bot+sashiko@kernel.org wrote:
> [Severity: High]
> Is this check enough to cover the keyless state?

No. As Xin suggested, v2 and v3 replace this approach: when processing
the INIT-ACK or setting up the association key fails,
sctp_sf_do_5_1C_ack() now fails the association with
SCTP_CMD_INIT_FAILED, so no keyless AUTH-capable association is left:
https://lore.kernel.org/netdev/179539544818.3016044.13738712075053349592@gmail.com/

The I-DATA key selection in sctp_datamsg_from_user() is a separate
issue; we will look at it.

Kyuwon Cho

pw-bot: cr
