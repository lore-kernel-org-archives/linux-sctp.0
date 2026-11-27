Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795757152;
	b=bmVd2KB54jC5bNUDBDmDis88sk96k8pNEFTIEn2Yz5RAdIHXm9Wgk6rPcImwuFZsYpZW
	 0iyVY/WdQjJOqzPBMgl5X6VMgfEJwjwEPKMIzFgJb4N9rCfNUXkyAAwY/Ab7m8aJVTBKb
	 nHCURgmf8kBhjX6/z45lym1cAIR/kieApMOWGThaDJlDxi/Zgn7nSSoB3kh9Pj1oyXj3L
	 ueDlXZliK4au8Ma0o8Q6lCeP8OHTIw1jHUW9Rz5d1EgKxcWarbx1vcuFJP8ndvxm4uiNh
	 +Jxm9sMTD32BnDlZQCOEQIHAtqyi8oC9fPloWSZgNmjZIHRMkC64JVR+9uHPK7pFm3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795757152;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=8zadYnSLJC4oWK4KEqW/pDBGl06U5XfACnUZ/V8R80A=;
	b=TB3hqhZkrDa9aaBekXFyujdukpXoREyPvO+tD40MYxR4UUwg5FxMZTYmKFwciRSZnmgQ
	 1PpS/J2m88QDIu6m0pD6TKEHi/gs5QVS72IXuD0uUMYwE9cHhQ0IUBCZOvl4MXpvZsj2W
	 yiNK8cIGxhNc6ojIxMIBFMKvGekgUXv/oUiMs/EE73xTkrz6Ovmhh81QqKjLdf1Aae97A
	 oRDWmn2zPyRRmk9aCa6nN8MK4/W8TubhttbfnP8aDGJjZ7NB35ldl9dS9YHanZWrcOYOW
	 ZacZ7qr8+UFOFWA0WLE9+21FV7TQyCJ3rkH3Ou94lQ0e8kSxb/Lba+i+yAlPj8v4/YQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="lCV/0I8i";
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.50
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F54606A321
	for <linux-sctp@vger.kernel.org>; Fri, 27 Nov 2026 05:25:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24F54606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lCV/0I8i
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-677bc4704cbso8968512d50.0
        for <linux-sctp@vger.kernel.org>; Thu, 26 Nov 2026 21:25:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795757151; cv=none;
        d=google.com; s=arc-20260327;
        b=gU5GdUx7XBu/kNgsuENs26trCFe1t/rA1Z7D61FzSjAIuzrOASVczkMJpP/ap0vIrM
         5iLEyUx04GfwKMxaw3p84h8+HdrWd57QBvpfgls7jeR+Em1+Db8alcb6Fvzxrb88bVFN
         IOiKqozzhgooabiFeH8TCj1tIuqcIRWvSzeC0VFCmwVIpUZDrgbqK4JN3r3zDzTSPG6t
         OuFXO3c/aw2hsBAZRuQMXoJalwxFV9JmP0KJ67axteMV7noEwZCtHRA3az71x+OX9y6m
         vKmHNpaFYUTRxhg3BfCSa15LVh6c4yID8rE5apr6UIsjelrcdFiS127CCkZT1JCxVoBu
         YztQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8zadYnSLJC4oWK4KEqW/pDBGl06U5XfACnUZ/V8R80A=;
        fh=6jcC1HyKhPjsXN+JFolTjKBOST1uwVhmFcYnRE1F724=;
        b=dFVWUdHKbAOSruap5qPNYagsDwFm1HZcr3KnRq3QWVKjq2MV3+0k7jEP4vExCe0il2
         v2EiqNLGXOSaGwtPiYsPQzbY5budE5MNh2z7s8rB1X3hfmubs2dvnrYtBM4ctBg13kkE
         AD4GFR0g6MzDi+ho1ggCK0HERhG+pJiQqkSV6y1sopqXXhZULokHd8peO1rnODM6gn4I
         CiV12hbT1kEHwDCpGHO3MnKE4h3zgbEQOOkAvNes9phF6I1zNyCsxy4Acy0PU2R9ef1h
         QLridKU12y+yZgBgLTRJWG1ZK7njGUVSvx2XIMvMhY7rXgx/Pqet2R4PDHZi8FPqsxFN
         mGMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795757151; x=1796361951; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8zadYnSLJC4oWK4KEqW/pDBGl06U5XfACnUZ/V8R80A=;
        b=lCV/0I8isypgadQcogTLtoCz/UVpKWFG0smPfTyt5A70tqt6zcF2BuGNrAz29vTJKZ
         Rk9DYHrTsfhFQVbp3hTzdcLzuu8K4NSWq9vBGrITpSyrDXj0rX+F+YmL7POqZhYj+29v
         DXWreCFIhMQOL6aJynZbDlkCNBYaQMpSXCNGHSakZSmEtjQ2AsJKa2dnfZGyWmdkoqCC
         c2vuRXV/eq2CSXdycCVKlJJ6Ba3Mkyt9s/tJmmcGsaRXtsSpMfTfJxR6zAg4TggIOjvA
         mZMO8d8pnLoYTcCjS3KX5sfi712uuLwPFjIqh8i+4OqtFy5jWTAOwX2eALsA8P5LKjAr
         YpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795757151; x=1796361951;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8zadYnSLJC4oWK4KEqW/pDBGl06U5XfACnUZ/V8R80A=;
        b=jb3Yjy2KdF2gYYWwAkcNY8/n1+gP+l504oP2jzDZFUBSXMdVCyVLDZaihyvNL6R+QV
         C/X4NHWIWvE76fTIuB1aHJN36Wg0WYpR1DIeh0gIv1J8oiUIahIrAnhjR9f52gPUJXPZ
         LRLM/35Jm/4iEmRfvGVFL3jrUNIc1Rurp7yqe7Ji/GSdIQSPBo0bzuR2Oy8DXEHhnnvC
         dk82W2DzjujOcO0UfVmhDp9a8kVdDxsH/GnlTG/TXXuxML5ZNESIV2R1z7acYF1ksU8R
         jJZQSHkYXsj76GRxm8ACcqpEh9VCKknv/9BqA59D1Z7igxfG2CIw+lCEo1XBxsddWh+O
         lHng==
X-Forwarded-Encrypted: i=1; AL+hErFzMrao1chdi0DKfpHDdqLu+FFQK49qFu52MJhesJCoaoUcrWmj6H6XFIcSi6OpNLHgAOZrw5ke2l4U@vger.kernel.org
X-Gm-Message-State: APuU4Z8O988+baqnQZ1+kOlV/CKNjtFq29pMokmX042TRp4mQBZM0i/U
	CarkE4E6I/W0wRvypxTD5y/I7is0ALxYiB2oZG0gZVDXdz+nJPP9IcZdNFpjhGNYl6wnxir4OAx
	1VcJ3vrEsmj/wY82z+I8/19XjFxhgqZo=
X-Gm-Gg: AZFdTZfRDfwU0T8WCsqpaeq9J3Hk4rUs42Et79sHDbh8+RMGTRuzgSDi+GZNOPrvEP1
	hGJdZ92noeaoBlaGlmJ9pQUVwQTJSAljv3faP4V7u3+pJeS8k3BRxSjPXi64ORaYxEmhYpXowo4
	K35A28Pynn7PzeWlmI7OVH27g7AbQ7nIVFKX4w36eA0Bmr2+rikF15oh6qv/zWQmQj0cME8ZAr5
	s295Cl1oiTgG4GYukyp77svfirHfvgvpFNmZP9HGVO+MYy3OFXYHlCUf3thiudDhBhByjcZf4/e
	Cqy2V37NxdGLqoZvKNxu2Eoxv70629QqvE3LmhBd0csp26e901fFzDq8h96KqcOHcU8kG/Lj/RK
	dQBULPRLt07LlESyYeGcfJLZgOKZbP+n0Z6mGi5vJ52DrYT1GzKEHAxSC6djeSNDpsmg05bQQSc
	BDvtFlUbSFR7Le/NmMiA==
X-Received: by 2002:a05:690e:151a:b0:67d:ea44:eed0 with SMTP id
 956f58d0204a3-67df43f342amr5944468d50.31.1795757151192; Thu, 26 Nov 2026
 21:25:51 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261127033534.175-1-sunyiqi2@huawei.com> <179575078181.3294.2500218795739226970@kernel.org>
In-Reply-To: <179575078181.3294.2500218795739226970@kernel.org>
From: Charles Research <trilobyte777@gmail.com>
Date: Fri, 27 Nov 2026 00:25:39 -0500
X-Gm-Features: Aa3M54pM9aMwykZrmzdwnraMcKFs8w_Vab-aMEV-uj23ITBp-ElUf2aBFcAeAHE
Message-ID: <CAPS2u-V_bfyuZFwqB8KOswp8YT4EjYiO8Oj+xUjh+veyNGTpdA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: validate Cookie Preservative in the first pass
To: netdev-bot+sinfo@kernel.org
Cc: Sun Yiqi <sunyiqi2@huawei.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, 
	marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net, 
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, willemb@google.com, 
	horms@kernel.org, luoxiaoxing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

For the missing discovery/runtime context:

I originally found the Cookie Preservative length issue during
AI-assisted/manual review of the SCTP fixed-format parameter
validation following the Adaptation Indication issue, and then
independently reproduced it at runtime in an owned KVM/QEMU
environment.

The malformed Cookie Preservative parameter was accepted on the
unpatched kernel in both header-only and overlong forms. The
header-only case causes sctp_process_param() to read
lifespan_increment beyond the declared parameter and use that value
when calculating the State Cookie lifetime returned to the peer.

For my July 29 testing, the unpatched kernel accepted both malformed
forms. With the original validation patch applied, both malformed
forms were rejected while the baseline and valid eight-byte Cookie
Preservative controls continued to pass.

Sun's patch moves the validation into the first parameter walk, which
addresses the additional path where the second verification pass can
return before all parameters are checked.

Since this is a follow up on the Cookie Preservative issue I
originally reported and runtime-tested in the linked July patch,
please feel free to add Reported-by: Charles Vosburgh
<trilobyte777@gmail.com>.

Thanks,
Charles

On Thu, Nov 26, 2026 at 10:39=E2=80=AFPM <netdev-bot+sinfo@kernel.org> wrot=
e:
>
> Hi!
>
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
>
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by LLM and not proven at runtime). If it was triggered
>    please include the symptoms, like the stack trace or kernel messages.
>
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account.
>
> *IMPORTANT*: If you do repost (for other reasons) - please include
> the relevant info in the cover letter or commit messages.
> --
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
