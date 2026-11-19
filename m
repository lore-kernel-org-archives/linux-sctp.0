Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795090211;
	b=qkG20kC2yEBi9MOOm5skEEogXMDI/hvXI7J8EWIe2xMtq7TXM8ZgtL8K8RYvm0nBzQ60
	 tAH7w0AA3ukL8g7RGapgwEMzPpLE3rPrgyWURXQmRUViK1v3yHEZG8WN5pYxHFusBjloa
	 QyNf1LeJ7YdvO4IvGkuOfaovU3pheTY7q57cUpDPxpSYYLEfUyrX+9zXWr5R2OAX3khEc
	 ++Ecfrngba0ipULjgk4JJTj0m+ABIfBBYJeWwUyGUFars6CTyrNpdKjhjMeICvMEgefqM
	 ehxQD6XP+8KIN69Mvr/JPJa5GFbnccZcQbx0k5fjmwYm3eRRARijyFuH6SWoMTYeFeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795090211;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:From:In-Reply-To:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Language:
	 Content-Type:Content-Transfer-Encoding;
	bh=qQHDqukiWt3gb3Ynjw1ioSPmavArdSzM8YrNLICeLOU=;
	b=vObqpzvF9/fm6A7l/k33E9P5p9ShxAirHuGLvTaHS9Pl+3Oi1tSq4NhtD8sTO2yRZXrR
	 tC6Mr6zoYy0tojmQAPUEsANslkkALqgTsqnwZCDLE8pECBdEtSHaTSwnSIISajQbBz8D4
	 ptKmn5fGci7A+oyE/ottCw76jEy+3OKqo2RdDryRm6EbKQlzj7S8XThOroQGYqc1d0mOp
	 uSBUF5BBjFhO/QlfBsty1cuZM9c5DTBgHofyXAdnoy3RAcDNkW6bYB+kGIk13Jhb4Rh+8
	 OTr7HK2KI4zn8xCB07/L0D60pStWw968peiaVuAMulZELZLFGx/O6IzLzUDhMKVyBCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KsNzIs80;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F351606A324
	for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 12:10:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F351606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KsNzIs80
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795090209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qQHDqukiWt3gb3Ynjw1ioSPmavArdSzM8YrNLICeLOU=;
	b=KsNzIs80GcUwSkVGbypbIHD32utbVckdOz0CO7xwzi7yEnxHflgeuQmuSPclLzd10rWtNY
	525yphoR/e/9Y0F6UMyW1pRmLRxdOipA1ZUdeEcLZ/p1Gg3V5k8pp1QWqZIRKKrzcxoxzH
	5XLI9jSwHJb5ir2kJp9dYBrsHNxdCPY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-KZHYi7UvMhaUAx4Hjx2-RQ-1; Thu, 19 Nov 2026 07:10:08 -0500
X-MC-Unique: KZHYi7UvMhaUAx4Hjx2-RQ-1
X-Mimecast-MFC-AGG-ID: KZHYi7UvMhaUAx4Hjx2-RQ_1795090207
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-490d2ac331bso2063181f8f.0
        for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 04:10:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795090207; x=1795695007;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qQHDqukiWt3gb3Ynjw1ioSPmavArdSzM8YrNLICeLOU=;
        b=U/eMOxdD757Ch8Fboc4tQA/S3XWTTZjJK+b4RFEHFdfodyIv80HGhM+gtwKGktRdHJ
         QYkxCGBNmGR1YxQs9sdvWU/0jXcyrSw6s2BVeSMe7aNzjMKcaT2ryc+wO6oSPq0I1H9v
         Uqy88/YBFKW2+7hz5nvXe4Sqaju4URxCRlBrBj4QDviIJPFBhkIvFalJf8Qh3VwINrJp
         HpmcFe08h98bV3hOHLKTZwAKXCVTyeIXbPnlVQIfbUu7u9Hx/YiZYrlUwPx4zB8bcDhv
         kxtvcKkxWKNlHP3cYQbQFwp1IIqBI0eWTjCWpQOmoojdaK/s5gqtJ8TLQYVtStE/W6Zt
         kHpA==
X-Forwarded-Encrypted: i=1; AL+hErEW+jPmEdTWrJUHHWR0OTMHLxOm/nYSmM3gtVLk598tsFuUvlPVt6Rn0Bh/74RjtgViN7N2xaVrOw0y@vger.kernel.org
X-Gm-Message-State: APuU4Z8xSmoifbmYdwrJCTYpJ7EJfmF6xT4xvDj8TldC5aN/AZiSZ3Gp
	Br3rOIMsMYzYsL9LI7fFTbFD/sKoGYOarliXGXEP0mXbGNDUNzIguKKQHXFmESMqxqVesWhyNpM
	PtI4pi4oeQsuqImlMygfzmKmz6YhUnYCberH6IYHmOrvOAXmSA5cFp7EIrFCHBo8=
X-Gm-Gg: AYBFou1qs4zAa14UE0Qz5S8ny1iL8ioY0QJUyeXBuDW0tHGlCGt7su5WTgvR/Sy/iaJ
	87oV1zN6ghZC4qBf2xUYTYJebT4Ny9bdpiKEBD2BcxBrDttKrny//WKrPlphp6jzkTdkQaaxIwM
	lTyb/y2lsYy0UfhpqmY2HGTF2mAYH7sZ/GVi3FI3kJc5b6s+kRy90TrIGYfvgVgOvg2Py+wxoBh
	zb0Occ4oKc6c8v03gGK/ZekSFNLmkLJjocuB/SJsf6njJLElhQqgkq5Um+8qUixjIFUvXwbXfbY
	SSFs3NQOVhFqSvwq86wbEDtr7+oJLDDxMXsJtA0XUzNOQaZKubDXDgfY7rlRAqNgg7/zfjxShgU
	u4oEibr4fWy6SumBh9dzRrZnxJdGKEYte//jD+eSay3H2CvQh5gOT7UIGM0qCXqB4fylHdHK0CO
	Zub/YMQckuQaoUdtqtC78/04OKkUU4TBOq8OFtCEBQpZeh
X-Received: by 2002:a05:600c:470a:b0:4bb:6fd3:5ac0 with SMTP id 5b1f17b1804b1-4bb7da2b98fmr114020935e9.28.1795090207426;
        Thu, 19 Nov 2026 04:10:07 -0800 (PST)
X-Received: by 2002:a05:600c:470a:b0:4bb:6fd3:5ac0 with SMTP id 5b1f17b1804b1-4bb7da2b98fmr114020285e9.28.1795090206926;
        Thu, 19 Nov 2026 04:10:06 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb84e4df2bsm30559485e9.3.2026.11.19.04.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 04:10:06 -0800 (PST)
Message-ID: <a1b7a992-3bed-43ef-80bd-a76cc697f58f@redhat.com>
Date: Thu, 19 Nov 2026 13:10:04 +0100
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 4/5] sctp: use skb_set_transport_header_careful() in
 sctp_v6_err()
To: Xin Long <lucien.xin@gmail.com>, netdev-bot+sashiko@kernel.org
Cc: edumazet@kernel.org, davem@davemloft.net, kuba@kernel.org,
 horms@kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 willemdebruijn.kernel@gmail.com, marcelo.leitner@gmail.com,
 aconole@redhat.com, echaudro@redhat.com, i.maximets@ovn.org,
 daniel@iogearbox.net, justin.iurman@gmail.com, linus.luessing@c0d3.blue,
 sd@queasysnail.net, sbrivio@redhat.com, imv4bel@gmail.com,
 netdev@vger.kernel.org, linux-sctp@vger.kernel.org, dev@openvswitch.org,
 stable@vger.kernel.org
References: <20261113124625.4010206-5-edumazet@kernel.org>
 <179484404697.3136.10852363970744263229@kernel.org>
 <CADvbK_dKiTF4gSjsRuVKUDVTJn-EVVvunmhOOEGyG7Bt6jjeVw@mail.gmail.com>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CADvbK_dKiTF4gSjsRuVKUDVTJn-EVVvunmhOOEGyG7Bt6jjeVw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2xkoUD3UNXdN8P2Okiy-Kzn6jtGeRUTyQfMFYbi9qYg_1795090207
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/16/26 20:20, Xin Long wrote:
> On Mon, Nov 16, 2026 at 10:47 AM <netdev-bot+sashiko@kernel.org> wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential
>> issue(s) to consider.
>>
>> Critical: 0 · High: 0 · Medium: 1 · Low: 0
>>
>> If you believe none of the issues are legitimate, please reply to each
>> issue of Medium severity or higher and explain why the AI is wrong.
>> If any of them are legitimate and you plan to respin, please let patchwork
>> know by including "pw-bot: cr" as a separate line at the end of your reply
>> (one such reply per series is enough).
>>
>> - [Medium] The main part of this concern is fixed later in the series.
>>
>> --
>>
>> sctp: use skb_set_transport_header_careful() in sctp_v6_err()
>>
>> sctp_v6_err() now stores the ICMPv6 inner transport offset with
>> skb_set_transport_header_careful(). If the offset does not fit in the
>> 16-bit skb->transport_header field, the ICMPv6 error is ignored. Before,
>> the offset was silently truncated and sctp_err_lookup() read the SCTP
>> header from the wrong place.
>>
>>> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
>>> index 97390569c4bdc..ad5c951efdf06 100644
>>> --- a/net/sctp/ipv6.c
>>> +++ b/net/sctp/ipv6.c
>>> @@ -170,8 +170,11 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>>>        /* Fix up skb to look at the embedded net header. */
>>>        saveip   = skb->network_header;
>>>        savesctp = skb->transport_header;
>>> +     if (unlikely(!skb_set_transport_header_careful(skb, offset))) {
>>> +             __ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
>>> +             return -EINVAL;
>>> +     }
>>>        skb_reset_network_header(skb);
>>> -     skb_set_transport_header(skb, offset);
>>>        sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &transport);
>>
>> [Severity: Medium]
>>
>> This covers native SCTP. Can the SCTP-over-UDPv6 handler in the same file
>> still hand a wrapped transport header to sctp_err_lookup()?
>>
>> sctp_udp_v6_err() is installed as encap_err_lookup. It still does an
>> unchecked 16-bit add:
>>
>> net/sctp/ipv6.c:sctp_udp_v6_err() {
>>      ...
>>          skb->transport_header += sizeof(struct udphdr);
>>          sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &t);
>>      ...
>> }
>>
>> A later patch in this series ("udp: use skb_set_transport_header_careful()
>> in __udp6_lib_err_encap()") makes __udp6_lib_err_encap() store the UDP
>> header offset carefully. That check only makes sure the UDP header offset
>> itself fits and is not U16_MAX, so transport_header can still be as high
>> as 0xFFFE when sctp_udp_v6_err() runs.
>>
>> For a UDP header offset between 0xFFF7 and 0xFFFE, adding 8 gives a bad
>> value:
>>
>>    - 0xFFF7 becomes 0xFFFF, the "not set" value. With CONFIG_DEBUG_NET this
>>      trips the DEBUG_NET_WARN_ON_ONCE() in skb_transport_header().
>>    - 0xFFF8 to 0xFFFE wrap to 0..6, so sctp_hdr(skb) points at
>>      skb->head + 0..6.
>>
>> In the wrapped case, sctp_err_lookup() reads vtag from the wrong bytes.
>> sctp_v6_from_skb(), called through af->from_skb, also reads sh->source and
>> sh->dest from there for the association lookup. When vtag == 0, the INIT
>> chunk is read with skb_header_pointer() at a negative
>> skb_transport_offset().
>>
>> The commit message says "Should the value be truncated, sctp_err_lookup()
>> would read the SCTP header at the wrong place". Would it make sense to
>> also check, before the += in sctp_udp_v6_err(), that transport_header +
>> sizeof(struct udphdr) fits in 16 bits and is not U16_MAX? Another option
>> is for __udp6_lib_err_encap() to reserve room for the payload header.
>>
>> This needs the same large skb->data - skb->head precondition the series
>> describes, and there is no reproducer.
>>
>>>        /* Put back, the original pointers. */
>>>        skb->network_header   = saveip;
>>
>> --
>> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113124625.4010206-1-edumazet%40kernel.org
> 
> The new skb->transport_header is used by sctp_hdr(skb) in af->from_skb()
> in sctp_err_lookup(). I think it's better to avoid changing
> skb->transport_header by passing sctphdr to af->from_skb(), which also
> makes code cleaner.
> 
> Hi Eric, you can either continue with the idea, or discard this patch and
> leave it to me.
The rework looks out-of-scope for a 'net' target. I think it should land
on net-next.

And I think the missing sctp over udp call-site could be a follow-up.

/P

