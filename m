Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A33494812
	for <linux-sctp@vger.kernel.org>; Thu, 24 Sep 2026 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790257472; cv=pass; b=nKzP1g7SIJj1CedokTGqdtGmgr7/rSvE5Im7w5JopMXWPKfvBUZn6ALsAsgx0MoDr0xfwt9mG3qtm4eDpsUQKYirsiL3rTwKcVdskDzM705NHxJQ1J5cORam1stAoyLm79/GLg7SmBESx5o4AvE1tXjwxnzwT9+b3XEu14WF3hU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790257472; c=relaxed/simple;
	bh=cFauOgA8z3U9PqAuxzmKGox+cZOoW7I+JwbiyAJGnfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=glG3zqUemzR0ILPAVcps22M7ODlYJvgDWF3tzeRDj0LRJYsuVrx06u51vRhRMXt1rgKfbnq9f23lIYSw0mITZG+a3/PjwbiwjmTrxZD5MN4mkLI+cRtSffYJBZGR+fb+rKcgdKEBVfdPgn05BPRO0WramBPUY/4BVtrLn4CEvoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SXp8GWtP; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SXp8GWtP"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469a34908so1452525b3a.0
        for <linux-sctp@vger.kernel.org>; Thu, 24 Sep 2026 06:44:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790257467; cv=none;
        d=google.com; s=arc-20260327;
        b=Lbod2Ta1PT8DaMMwGU1AHbhnbWP2Do+b5RuUb3bUDUCfRU8+02oIPLw+7stPN3jiod
         emuZ19lqeSpI8SPimAb0H3zPO2b0aLkQ5VxzsLf9iNQ8fyIDpNauAzKSL4OrxmsR2gz/
         2q22Dim2jqvXXkGskyaE504ArSJjruGPnj78T9RLPWhoNDY1GtlymwBjEXUlqMK6DxSj
         dyTH/vPOeq0AHLGXb47qhooSEPReD7pN0lXee593xenDszLAhAhlYqXelj3DfpHA7IGH
         vvOWykxb44EbFkDSQi20Fk/C48dr3bg5/F8P5aluW2IaUeBRyh3fLkDrqN13aKEiKz8i
         XZeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nlngpjoJXsEVxEuj2gq7hM2g/yYyiiwaQMo7R6hUNyI=;
        fh=1DO9HXSEVDom308/3oMKX8h9qf8d77lsIZcE08O1YqA=;
        b=SkF68+fyl7vcy9A5aCyZZquXAT1qM5TzguH5YKBOUQqIope2Gmwdwuq/W0eTlkAN7H
         yPT8c4cBp3twfmOlkfU5hbdxZoHxgUqtQj/t4M+N2S/NrL4qcuzgQK+qOYDI8P4+vS1q
         G5HWDp7Dcj7Qk7cSaYQFFYbPAhhPsbsjPSz+O2G/1UgaihiTloNVwNtqCpSos+iwW65K
         93hYtWqUDvXqq67Gon9lDG3DcdvHgIiXvox+lcM8mI0vG16kl29h2E8RHpphIsrcGHbE
         0M5TUt58jro7f/Q4RdT47GOxQeOLa0FRd/1/6qJvaIcpI7JsoIB2jvejAhuA2UMw/Z0d
         SSAQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790257467; x=1790862267; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nlngpjoJXsEVxEuj2gq7hM2g/yYyiiwaQMo7R6hUNyI=;
        b=SXp8GWtPMjoV9qkWkWx8Qa+9vDPPN5DessE0/O7/1AcXVzrgDft4U9eYgx6+Rh4g8q
         qGGbiLPh/WiGhqva63M66QptrjdqHv8OOmH9ZSWurw3CPNu565s62WwLNHIwai6TyteG
         UcWe+Ww1+v3QL9dSwXLjql5sK36P96rOinmbl9IrAymGgZpaneu0XUYvkBndmdAgub9i
         5sQnSjtUFSSx5GtYkpTN4VKRdHngxBqzyluO9z1Xik9GVCtsqP1ZQeOn7Q91sBIrf8Dk
         mbZWjAEynFhLBebnza6CpMQzH1+sz+MMPAt3cRnbf/tmIh0ztx2iFroRus6gYJTpIMqR
         w89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790257467; x=1790862267;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nlngpjoJXsEVxEuj2gq7hM2g/yYyiiwaQMo7R6hUNyI=;
        b=WJacZGKQddDVUXMI/jR1jAPlHs4t42prIfpfAWIjvdv23kvq7uJgePqgz0UjatSAlP
         T3VvcieeTn+JLH0ETYcZiS594JGcB8CmPWezxjDkNFFpcdk7zzgp+GgAAi1AnRw5TMUC
         vzyBfinfQd1JwDbd89qLjbduH5ZUKkzU6MgauG6N9Zyk8kiQbZ1IPBnJ7yxqi3Rf+1iw
         Q69QgwKoz/QFx4OxDsFxuoHyeUIkuPU5SFt+/JQAxOJ/e92Z297BQObq8FRWMSODMSqF
         ASpnqHl+ba+h37elIsYmg0ZGBAuVaOQYZmqgXsSerwrmce5LhyV0HwaWAXm03A+rqMPc
         bYeg==
X-Forwarded-Encrypted: i=1; AKwUvBxoebL2y2wZyMr4sjZ2z4+887eCg2FMBky+KvR0IxjL7hlki3f4RVwvF6RIeOiRjBix1C6EKxWDZF4x@vger.kernel.org
X-Gm-Message-State: AFuF++mcWTNNTXNT0YRMv4+ma60VYWXohl9rvE4GYOk2XZbSDV6uIj82
	FKJKxQjTe381E1XGQICyjOHCxCBQl/X5FwZlcz6apnV6F6ls4UChHb0o20Wddeb4PROTQg8HiEd
	Boh0XH53mZZRJgzZFGAueAtxoZng+9Bk=
X-Gm-Gg: AYBFou1ZrSl1WYs98oeB2bvacF1GhLdC4ZC1c5ItsQ+0YfSUXLQoqbXDVfhN+e6AZ2j
	B8IOMBWoyFpy10CUXsk16BnGGrvCsoXg/07X0foQHI/JzZVPJ9nZg5Y1qtedjsXMvGEs5ghiv/T
	L0KjPi7Jxe/2k0n89HK9WSr+gOFjB6BcVgYuwXK4i9zznfJCgA+g23jAEQhA3XR2HY0+L6ebRrY
	mpSVrUO6fYFjXesueyEUcJ1iKslusqBKdtzzIadXy3z9uJp7jzI0ArKQRgzZ3N9PUatDI+R8PSa
	Ff5IkMX1YovDocjH6WvlIUbsett2YI+VAaN+fzOGrefFCLJj4RZ+UqVhbO0ewFzsV6ULWYJF9sb
	0z3wTJhtIvHNGdcUxYLLMTCZ1UpRs9VxIr1YYY1tVNalnd10ql+NfqA==
X-Received: by 2002:a05:6a20:1f28:b0:3dd:a196:69e1 with SMTP id
 adf61e73a8af0-3de0ea1cec2mr2440252637.60.1790257466883; Thu, 24 Sep 2026
 06:44:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260919213634.3314055-1-benquike@gmail.com> <4745a390-6859-4a5e-8ee1-ab9634b3bc10@redhat.com>
In-Reply-To: <4745a390-6859-4a5e-8ee1-ab9634b3bc10@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 24 Sep 2026 09:44:13 -0400
X-Gm-Features: AclHuK8jtpDrFAVJeOq2D55eedj6RdtFuoTdSF_mfwp1fcThXvzJ0oWBMiBjo5M
Message-ID: <CADvbK_c0+KxZ-AZA4vhWpOT1DFBic-iy9gfrd18s0KQAdskvTA@mail.gmail.com>
Subject: Re: [PATCH] sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus()
 when !streamoute
To: Paolo Abeni <pabeni@redhat.com>
Cc: Hui Peng <benquike@gmail.com>, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 6:14=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 9/19/26 23:36, Hui Peng wrote:
> > @@ -7589,6 +7585,8 @@ static int sctp_getsockopt_pr_streamstatus(struct=
 sock *sk, int len,
> >                       streamoute->abandoned_sent[__SCTP_PR_INDEX(policy=
)];
> >       }
> >
> > +     retval =3D 0;
> > +
>
> AFAICS the above is not needed; retval will be zeroed later, if in case o=
f
> no errors.
Agree.

>
> Also this is IMHO net-next material with no fixes tag.
>
If users call getsockopt(SCTP_PR_STREAM_STATUS, &param) without zeroing
param, the kernel should still initialize the output fields when the call
succeeds (return 0).

So we may think of it as a Fix.

Thanks.
