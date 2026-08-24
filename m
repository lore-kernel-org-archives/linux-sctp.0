Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F351D3624C8
	for <linux-sctp@vger.kernel.org>; Mon, 24 Aug 2026 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787584485; cv=pass; b=R/COHhQ7BFQiDd5YzxhXzjY4gDFpWcMrZFsn+tV5XN0i78td16yHQyeXqZK0XNGIneKH06bhjyEBDQFBC3qlH071V41qwrHtKhJQqAhY0MaZCIzl96Y3QKWl9G6wlc9cGjO27Q24ImO6LqhtckzqVsoK7kjkYm5ZVedar4fZumo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787584485; c=relaxed/simple;
	bh=VJATUq+652VOGyti/HO0Gm3D5hCpmMFQ9J+4hCktu+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aufZLJgBCDby5kFtHYjW1jjrO16rXrWdEbbTMuxNyfaDtCPF+l2jQauzXF1Da5MxKOG8siFH7UQH1B5LGLrxVC/O3t2Tvg8BMrsMDZQVX1bL2C4ItdFSEs57g4R3EZwB9npT9lcw8V9T9PKQ5RKZDkll8ECaX15k+l1ZXRsfbUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRT1h3Ju; arc=pass smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRT1h3Ju"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84f77cc7302so1285173b3a.3
        for <linux-sctp@vger.kernel.org>; Mon, 24 Aug 2026 08:14:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787584483; cv=none;
        d=google.com; s=arc-20260327;
        b=LiOeAm/wbeS8laOCN/5J58RONzmHI3DmbkYjxsih3LpCzl5Ql8vJC9HD7/xVgj55fG
         xJfMUL9H1SBAzdv0pZFLz6G0xcuWt6qMWVmNT4qe8I2F7gXE4mnVelIkzwWbQVbA5iaP
         lu7J4PrkrDbEKuIqObzK1fTz4CgsZG+03AWt+yFl3k5pTWlGLfq6azOg2mGdNI5S/sYu
         WgNWTs3oKiFQoeDqr8z4fG5c9Y8gcG1CU/B8U4+6+A9NRNWkSjJIy1GZsXVAwVubgzFe
         lK0gAV5Prj3zmhyHM84TwVCoR5zwr5nn7AMEX6arAB2BdwBVkknG1PsfK/vplJ3J+Sr3
         1+WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nhOkI8BfwHJxYD+mu7kqK3AB9orV2yeL9tFKuyBojLk=;
        fh=wmz28FfiBpw51gPfwGg3k3Fe0lkBuptmyHNmLta2lu0=;
        b=UBC7r5CJWOUYJ3azPDPSsKLMgkWCW58RTLyeXLFt8lA58arIbuB2owqnYMDAXBnOrH
         KCRH/FtZKP7NX3ITgAOtsm8r9GF4tGqzI+eWXvwjB34cU1bJRmGz47SNBy4glOpV+VXX
         vFAuN0D83fYRmOL0rcmky7lEEnvVqX9JrRkGYsJzJEvX7H1xE+/KCTbhkKhgsp8Ecj+z
         7g5luyLMXVL6kEfRVTf7bTLnF3hBrk19WzOcQD4m7Hj/a1aftZMqcjcFMfrv8kOhnP+c
         VRlrcyJuYXgeEeO0adVaqjP7HeagH2rWullM7D956kD5WS3A7rZRa8GMilC6BZUAEJOM
         Dukw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787584483; x=1788189283; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nhOkI8BfwHJxYD+mu7kqK3AB9orV2yeL9tFKuyBojLk=;
        b=JRT1h3JuklS0Q2omBU/uTB/DzkpWaM6Bpsne5e6mjWwmDcdAFFSmSKP5asLWL+Np6P
         P4roxvwl+OJvC1iXNtB2S/xTJYHm4jTutD/US3+FEWxLt/NwswGGKEBnPDyXm+ssdnMO
         CITYQ1p3JzBXf5B2HN27xS3fubY2PEg6ZMb9zXafncEK8wey11w1iCWbqEUwBHuX77FS
         zRD6BmvCOaUddSFNCidsaPImGPLTKh9whXg44XAEbcsSGdkC5SqQ7nn+6Y9rn0PZL+2N
         VeZa4xYCjjrkIZBOlNLjg9OVM+50VgLI0srhb0onOdqNgQQWyxXyV9rolVg9mizICBFe
         YsAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787584483; x=1788189283;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nhOkI8BfwHJxYD+mu7kqK3AB9orV2yeL9tFKuyBojLk=;
        b=LFeZy6bGBphhUEJk6EGGTSM3/+JcFQaQxW2RA5aiFp/wfJYHJvFqNDMIE0nbE4kE9l
         CztcZyq99XRyMZyNtLFmPBspxbfI3B2I3iktj+0ZEvKK+wDKoAHqwlr/9aZLBpjfijeu
         D+d9VVqGNxnU+8PubpqGu4OWI3fioZiGKBn71PQgNoYtSypPqaQOdavWr40z6BzcuycU
         RlUdaF6SM3TPLgqr+1JI0ggbmUvKqYNnxaXV1pTUGrfKkW6NktPyW4bliiSGfwuJ9gFv
         kBCfjn718HOBQy8jB2Q2LPN5jbfRFmJ7ToArU66NXCpLAUWyc5mhAnXRFR6OTkqcSril
         1UlQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpaq577jlnrt+yMOcGnGebQX7fIg1QlAinDe+g+A9cIifcYqqPC+hhK2oDa5QxJEZKttZwO3+nAuAzZ@vger.kernel.org
X-Gm-Message-State: AFuF++lBGRUhKC6W/syZZl4htvcR0lg4omQWU6gRUycqm50C1S/2hEGb
	TNyT1sHd68Re8P7oyMgm74U/xDaPf4cgBTnI9D+7bDp69MpDi9XrqG1b0QZydRDNRYcBm7PWKHk
	c6kH6etgGkMI07+O9gdFGcSi8xxiSJTM=
X-Gm-Gg: AR+sD12oQxVMEW2VO/6quhi/ZjoPR2epA8P4M4DJFQMSdry9SEhky90dKJQJ77xfpsO
	YDCr042kYSyTPruNWiaq+e4i2OVxNp2yldQ+I5T8i8w7LBZAPELK+jbVX+U3M/515eKewUoFTQX
	HnGsWL7dBBoE0tfyFt+NKmlubcgem6XGsf+XrPb9ES74BMXa6kR9m8OlT5hoBFASbmZwylcK3GA
	NKO7PzwcyeHlQDec3HXYMJUG4MUHLw2xbpN8GN2Mn7Ew9audkurq9oUpLwdKhPjIP8eYjYZP0mg
	YixOJUqMD5eXm3/iS53TTE6oqSJSBhEy8Ca3xyesNINvAX1gytS+q91stlmGceg2S05YgGMRGLV
	SKK/xNFjSKldJArSXqxERoQDuWAcLE72lHKs9OCPnjp0Asg==
X-Received: by 2002:a05:6a00:a585:b0:847:97a4:d6b3 with SMTP id
 d2e1a72fcca58-851fa017b6emr50017161b3a.16.1787584483231; Mon, 24 Aug 2026
 08:14:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260823130510.1341584-1-bsdhenrymartin@gmail.com>
In-Reply-To: <20260823130510.1341584-1-bsdhenrymartin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 24 Aug 2026 11:14:31 -0400
X-Gm-Features: AcwNN1Vq5tzN8r2zBbD7fXHd8EuGLLynOeV-kIP_OlLCpzFNsL2qNZD6BOJE3d4
Message-ID: <CADvbK_dr8Oz7DFpA3YJ_YH0HXgWJgkQPRK7QNDCUQrQzQnw-MQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix soft lockup from unpadded ASCONF-ACK
 parameter iteration
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 23, 2026 at 9:05=E2=80=AFAM Henry Martin <bsdhenrymartin@gmail.=
com> wrote:
>
> sctp_verify_asconf() walks ASCONF-ACK parameters with
> sctp_walk_params(), which advances by SCTP_PAD4(length), and its
> SCTP_PARAM_ERR_CAUSE case performs no length checks, so an odd-length
> parameter passes verification. The consumer sctp_get_asconf_response()
> then iterates the same parameters advancing by the raw length, without
> padding. A single odd-length parameter desynchronises the two walks and
> makes the consumer interpret attacker-controlled bytes at a misaligned
> offset.
>
> When those bytes yield a length of zero, the while loop over
> asconf_ack_len makes no progress, spinning forever in softirq context,
> and the watchdog reports a soft lockup. A remote peer can trigger this
> with a crafted ASCONF-ACK on an ADD-IP enabled association with an
> outstanding ASCONF (RFC 5061 section 4.1.2 requires the chunk to be
> authenticated, but the predefined empty key id 0 allows the peer to
> compute the same association HMAC from publicly exchanged parameters,
> so the gate does not help).
>
> All reads stay within the received skb, so this is a pure remote
> denial of service.
>
> Advance the iterator with the same padding rule as the verifier and
> reject zero or truncated lengths to guarantee forward progress.
>
> The issue was found by ZeroHive, a vulnerability hunting agent at
> Tencent Yunding Lab.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> ---
>  net/sctp/sm_make_chunk.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 5a335c980a7a4..0634241fd6649 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3452,8 +3462,10 @@ static __be16 sctp_get_asconf_response(struct sctp=
_chunk *asconf_ack,
>                 }
>
>                 length =3D ntohs(asconf_ack_param->param_hdr.length);
> -               asconf_ack_param =3D (void *)asconf_ack_param + length;
> -               asconf_ack_len -=3D length;
> +               if (length < sizeof(struct sctp_paramhdr))
> +                       return SCTP_ERROR_INV_PARAM;

This check doesn't seem necessary, as sctp_walk_params() together with the
following check in sctp_verify_asconf():

        if (param.v !=3D chunk->chunk_end)
                return false;

already ensures this. Please confirm.

Please also add the following check for the SCTP_PARAM_ERR_CAUSE case in
sctp_verify_asconf():

      if (length < sizeof(struct sctp_addip_param))
          return false;

This fixes the issue reported by Sashiko:

https://sashiko.dev/#/patchset/20260823130510.1341584-1-bsdhenrymartin%40gm=
ail.com

> +               asconf_ack_param =3D (void *)asconf_ack_param + SCTP_PAD4=
(length);
> +               asconf_ack_len -=3D SCTP_PAD4(length);
>         }
>
>         return err_code;
> --
> 2.43.0

Please share the PoC with maintainers if there's any.

Thanks.
