Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.215.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793382450;
	b=uUY0g2IZpx74s/aF837YH9rYkVKBvGH1LLbDwsxNhf/rkGhfPQtalZluBuky13DqTgpt
	 QG80hj4foB2/ETIJja1WfRFg0FSdqwmehgKY1moMvnzDztUSWIFMZxxEf+YIoiHeRSiBH
	 cxKGfrr08dpzjTjHCofQ6t1CuEfsJjC+efh6MX8OKY0QpJ95o1uVXw+37rccrxycby7aA
	 fL1CRgOqsRy+k25ri8uM/LsfQdeb9s4d4Xm3e6xWXtvGcN3gilZkR0vDQGnNHI30Tu4sf
	 Lg5qiMhwcyZHlmmw66f91zMen2Hs+1sJojFW1HMfkCPNLECeAhdyQ/mmUzB1Zqu1FCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793382450;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=sIhxZYiznvT7xWI+IfdwWWUWBk2bBwQUSMlQVrH0t28=;
	b=DjOlmHxh5zyNjpyyBjHIzFUUdGMm0NEZ64VlBjqOWbf3uy1zDJoBVsK7GewOtSl7pWV/
	 THP9Ld4mXYPBqnV6NJ0oK8x1ihUFLMFA7EcQJmfLbe/kqQi/+p6WzKSV6AQCMVczBDaPn
	 EoIaoD5QmsozFrqbtrMIsQS5oDny+G/Nk5bM9qYnqVD0F/16lmi+3r2d8sW6fpSExet3U
	 7pA6GdNvdiD/3mo8qZ7MK8SLVZnj+abSe2JD/IXvCNwtI7N6szXvCQ7+N6Gi6Nr/YJ+xl
	 Rkf7L7KGjNOFMvvRDoV8Z2dU3Sx/KLmdYE8a30m9Oo7wh60nrMfnxx1lJABqPmX6Ohw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XiJOZf2q;
	arc=fail smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAD9606A32F
	for <linux-sctp@vger.kernel.org>; Fri, 30 Oct 2026 17:47:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DAD9606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XiJOZf2q
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cdab6ae1ee9so472555a12.1
        for <linux-sctp@vger.kernel.org>; Fri, 30 Oct 2026 10:47:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793382450; cv=none;
        d=google.com; s=arc-20260327;
        b=WhFCkvdd15i/YN+se4d6y4b8uJS7bj7V1LqrLibQiFGQjrB5upJfNJ+AOYnpQrcMf/
         k+6X5joDcGXbPLxaG5ak8q/cI90UNDW1iynYI6T6NlCr9ZRZ6KPJS9qBFfZV77LO6CKi
         ZMrPE6BE2ADBUTHZcMdOSQmLqQ5Ruxh3J9dpoq1SsTumWT6ITKyKlRaRTR9CjlFbscYq
         20Drd1gzO6928Kb1tqqNOiquTCYzj8+0UkIcW5N5TWdDc8xe13uhyllfWHKtQtqnYEn9
         ZnugcyC0ljYDPJWYMkiR4GaUmegWAM3IE21lU2KReaVv1OPCjdmjHsHbB4Bn81XELJg8
         Mc6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sIhxZYiznvT7xWI+IfdwWWUWBk2bBwQUSMlQVrH0t28=;
        fh=iOHJzOUwsWkhoUAQT0mWjqLHsJ8+aaw/ejFgYMrHI7s=;
        b=U77kw9FB7I0LOinyY26vRyPCUIOJjPAvMr46G8M3odrXHGuYnf3Mjzv/1v/zlcwMjj
         v2ZyGWU5YLyc+aumPAwm019iME9Ss74AUJAsq4WjO778pLrGmErP++PpJlRw4jHh4olv
         Cswns6ibiJTXHsBYX5CD6j++UcHMcyb077tl2FgLThRUgmysdswhcpI/wsdesuofZtnk
         y8X3T8ZdOvh3f5Z9QWDCTj23bbPsLNXrlGhKawfaNvQJaC56K3qwcHT+aavfoaZZC+Ko
         5kCONAZwzN4Tm6zbJyk5agG/PXbPSRI7ehndqFqryl7uubWAfgC4sIfipv/1MCRJnPDd
         143w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793382450; x=1793987250; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sIhxZYiznvT7xWI+IfdwWWUWBk2bBwQUSMlQVrH0t28=;
        b=XiJOZf2qGnVvMOKzdKKgRpWoyWi7lo7RmWu0V8WqgQ1k3lzoL0/Dv5fQACqCRG6kM1
         PDsgKhCrs4wpWVvAYSFUP4vK7JaU/AJH9EGqZzKU82dbSRjoTp4O90spiuLfMo+YIHHM
         HaSLbVBL77GBIbulXUBDdFNIUrME8XK6DSOB1WKKJD3EZtLWKCPWxXTl7lZ+/+6tyYv5
         lVX69+D53vs8zH6azIL0M12NDNgxtlMKZXOtIaFgeKUewfILzXlkRBiV9y65ySTvgRak
         QVcOFQipiM98Snkj9OKCPpgX0q7tQgblxQkMG73TN6DbZaMN/diAXX0h4MtTjo7hF/xT
         DP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793382450; x=1793987250;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sIhxZYiznvT7xWI+IfdwWWUWBk2bBwQUSMlQVrH0t28=;
        b=wKGVb/d17ty1kOpoezth8oc005yc83L16DLBkrp4pfRyoie4VxDSF9a7jIiwz69Y4i
         OPUm9b6JHwNw28U9u7pnufD0/jAusZboF3WGy0aMV2tIcmmj5hUGdIaI1JaSKdSV0pfD
         loEJ0V5IIcdhtb0JsA+JekxfqPVzDFZOYxRtch7Jmql+IEP+mboN5UgCRJGF51zTSXYx
         n+PcDQdNRgvk5YwkXX3s/QuilbnxSpDvZHnb1trbC2Tfs0tTYZOzjOrDzeq4NWD3nFOZ
         uSRSpDKbgDg4bj820MeY5NPi65tUTMGdqWsgcKa0Ym4yCzdn4ALwFGPe1mjVU56RjWBO
         xvXg==
X-Forwarded-Encrypted: i=1; AKwUvBzgTohvv6OCt6UP+gNDRij1MLDlIeHfKTvhku7zJ+Jt7A9PZoa2SCPT7D7R59GGQMn71in/mlZGXJdw@vger.kernel.org
X-Gm-Message-State: AFq9FYI/UjAbQ+Y8fpPkcXI0dnv9VNo2PTKifYyCoiPGFmDeFFczJAT6
	4JS8X3N++hq59O8Vu2UBu3OCuuPut2hbQpuuLbzRGridyOCVrVDI+jjW0T8bH4dy0K5lWUsLmsj
	7IqE3ieQyA+Hxr0f1XrElLQxmPLrWecw=
X-Gm-Gg: AYBFou0X1zneeho1ici/cyUQCFEkzPqngxbrC67yqPNbEIEOkms5pYtYWPoNg5Isdtw
	u96r88LU2tSIJQ3EBbXTnS2jlZ1uCrxsQwtiXVwCg7sRoPu/JbRoMtl3o2ou82XITBI9v0/cily
	ARe5ibJ3bDpuNMI3AB49ka//8BfnM1jsZW4CSdKO/4Ef+TDKhdEvq8DXYtr+SnBTSHXc43FXrg2
	wMtvMxEOr4QtdtLd6d/9O6eddsp1HB5BJvKQvV5as9069dXqcrzFYOJAq5XNmkTjgG4Ao3HqQl+
	YHpANLaFJpm9+GKvLWjomMOLZbCrELzgNDUw2YEU+Dprx/nbV3F9vO1gmHafr3qhq9UxBDzFF7l
	orFQd86RE5dDPt84HW1t+JMFOqOSv+tE0UjeZRZnduACg/r0mxy5iwZju7vfLwNLquFWdWNOnlw
	WVLDKvTL7cjCiO6gbm2orMXjvYJZt985ITX1Tw
X-Received: by 2002:a05:6a21:3b45:b0:3e2:325f:576b with SMTP id
 adf61e73a8af0-3e928a71e94mr2185777637.65.1793382449721; Fri, 30 Oct 2026
 10:47:29 -0700 (PDT)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027082405.1297-1-shengshilingmu97@gmail.com>
In-Reply-To: <20261027082405.1297-1-shengshilingmu97@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 30 Oct 2026 13:47:18 -0400
X-Gm-Features: AclHuK_iwRZMverILPQ6aqdRr0bJylTP3g7Evr_UNs3S8h82CvZ8DH_nxsbSAhw
Message-ID: <CADvbK_eGiwO13sCNqpqHeiTLkQgTU_6Dt+Q+EVZ-CQ6WvRB9mg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: account for chunk padding in sctp_init_cause()
To: Masafumi Suzuki <shengshilingmu97@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 4:32=E2=80=AFAM Masafumi Suzuki
<shengshilingmu97@gmail.com> wrote:
>
> sctp_init_cause() accepts a chunk when skb_tailroom() can hold the
> cause header and the payload. sctp_addto_chunk() then writes 0-3
> bytes of padding before that header so the chunk stays 4-byte
> aligned. The check does not include the padding, and the following
> skb_put() calls skb_over_panic() from softirq.
>
> Count the padding sctp_addto_chunk() is about to write. The cause
> length on the wire stays the header plus the payload.
>
> Fixes: 8914f4bace3f ("sctp: add sctp_make_op_error_limited and reuse inne=
r functions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Masafumi Suzuki <shengshilingmu97@gmail.com>
> ---
>  net/sctp/sm_make_chunk.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 84a4c97d0f75..8933caadcdb6 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -133,20 +133,27 @@ static const struct sctp_paramhdr prsctp_param =3D =
{
>   * cause codes will be embedded inside an abort chunk.
>   */
>  int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
>                     size_t paylen)
>  {
>         struct sctp_errhdr err;
> +       int chunklen, padlen;
>         __u16 len;
>
>         /* Cause code constants are now defined in network order.  */
>         err.cause =3D cause_code;
>         len =3D sizeof(err) + paylen;
>         err.length =3D htons(len);
>
> -       if (skb_tailroom(chunk->skb) < len)
> +       /* sctp_addto_chunk() pads the chunk up to a 4-byte boundary befo=
re
> +        * appending the cause, so account for that padding here as well.
> +        */
> +       chunklen =3D ntohs(chunk->chunk_hdr->length);
> +       padlen =3D SCTP_PAD4(chunklen) - chunklen;
> +
> +       if (skb_tailroom(chunk->skb) < padlen + len)
>                 return -ENOSPC;
>
>         chunk->subh.err_hdr =3D sctp_addto_chunk(chunk, sizeof(err), &err=
);
>
>         return 0;
>  }
> --
> 2.47.0

Acked-by: Xin Long <lucien.xin@gmail.com>
