Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500A21FBEA6
	for <linux-sctp@vger.kernel.org>; Fri,  9 Oct 2026 01:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791508358; cv=pass; b=d2Bwn9puQaK5XOpQZueughcj2rOV0diZOt1SMn+EBdom+5ThXeNknfg80N8szdZkpMg923gPeOcJNd7TBB4BxMocpAE5eZunKJWE/UiBV++4DiR4CVqmwWlDlLvzpnjsWhu39QxKopLA1ZpE8Tj887VnaSkCC5iCQaAa/L+pPoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791508358; c=relaxed/simple;
	bh=2bXMDwVEYUSw/XMXG+524Ph7e3RM6JayBzXlJizXsCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hbhjUxeFbI778q8BRrxk0PT9CHG3VxnzLgxGpdfND8BYQYL+012ajl6iWg9HC+mrRdXPU3xXkteMfxX4UD/mZzXDJ+h3c/qS2aM3NI0g7nfz9Y/PQVCu+t234EXgkPx+NVlnAfk+C4TVap2wXcClkYYBiFOJsKOALuhjZnZf9QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cR4OtYHV; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cR4OtYHV"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8875d220446so1920955b3a.3
        for <linux-sctp@vger.kernel.org>; Thu, 08 Oct 2026 18:12:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791508356; cv=none;
        d=google.com; s=arc-20260327;
        b=Zg9Vy9RJL1l05jydIjj6FitJKC8e9HWljaquOM7229SB1TQj+WwWUtPbCETL1ZfXXy
         4gRmC4nSeUsvQF9MyhneUF0tEf8jFied6LSU8+JcW4fmLnEPplIJr/Nwb9bgIv9YIOFH
         /iabwRS/sO2IBHaXZTVP81mKhDkQ2Yo3xqGxddcAWP9kbTD1yhX5baEQ7eqBMnkQEqfj
         yPanFkPmaDhyirwRUCiz5lf91dmyjS+arLa9IxesFSU/ZQLu73qKFtdidKy5J9L+jYQV
         q8/PlOAR9EEXDk2jvTycyxWb3Q2z3N9SP8heZgmia4E+jYez4MnQKyf/2eqJJzt5rtSq
         Aygw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rhKDa4MSCyA+5vwLc+awp1rXxilBjr3kpw4ZExutEJg=;
        fh=r964UZLq5GAgVQmJ70VIYSlDCRqAmlT5POp/Xg7B58c=;
        b=njGNX6AW/bxYYU/ZUClHt8hGCSK3z/N9G3SqqBuMiy+Vgi9iyGVsiRPs2jBRMQt2SC
         6r0fn0BC+IDXCBwvA/1Ga+Lc05TI13rQO2FJjJCzwzhoUbQsbhAnAbkVRYlYcSsWMsmd
         dFz6nAv1na1UffRtSm5v6PIs4vwr5hSK/CqsYJ+qw4NJM+7ZIc3JUfZXjvdED+fbLvwf
         aARWLjdAKaFsHE0+JAh3GNm1R3Yn/sAH1LXhyeDXBjoJOvYrWSdAvBKkJwdYnPwC+6r6
         +lrLzEYcvstcxHyCYbMv5wdOERHqC35dDjKay2t15q8569HbqOiFIqSR0lX/O1ruaP6y
         nxnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791508356; x=1792113156; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rhKDa4MSCyA+5vwLc+awp1rXxilBjr3kpw4ZExutEJg=;
        b=cR4OtYHVgcibPwmHiavkY/FAB5ENYmg/QDtUb/1IryRfPVgKg+ubFht40ut4t7WU1A
         oMqT9r3HYcVBB85yVxtVOy+JF8zVQbSQCJ/oNyWKav6AaAAZGp5yD4DAyMHMk7yLWJ6B
         Fyao3AgC7Q6btwdwe0WMjciuc6YHmwdpZ8Bnq94uRN/Ny5lpCCSv8RzNaY+ZjbdK7Qxi
         NwnCnTgc5Hn6lD+hqrlMr7btrpWuR8KYiaUOVKiUIZJ65r23Liw+/d9CqtFIgkyp5gwR
         nJO4tV132WxG9IpaKgxRj/rokle9+w8AYRVYyAcNHy32PbwSiux8B4Bc58QYCHsnC5Gt
         wzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791508356; x=1792113156;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rhKDa4MSCyA+5vwLc+awp1rXxilBjr3kpw4ZExutEJg=;
        b=AllLV4UNn3JpxuGG6OcoTmfmx4y45t8XxnU9wX1XVFd2ZIxVVaEIxBtFEidhRAzwWh
         f5wQ/ATZnl2Rc0YMs0kbKuG8Iej0LD0yi9quXVxxJFsIL3jdGUWZsVADnzaw3OwnnIK4
         6nFOMF9x3Uz0oOdqhHQdzaP6KXQUw3HmHmeKBnN+WCn7oQeOivYZWNiq9S3dZCYMjFwR
         tU93sOrIetjFheQZuHHBudEYL4FplDAA+Bw3XKj6Yv/2EOFbPPXg1FvOO0re7w9bxt5C
         5pdQ3vKb5oEOBZH7bVA8tkoUIgQAmVOHk5gIwGA+rNlRt2WZMNjfnBfr6vTxCHbFAwN6
         70vA==
X-Forwarded-Encrypted: i=1; AKwUvBzSnV0hxYeHNgekC9kEcXJpsDJZLNx/Gz7yP+ZfOurr2GMMFI6qRfgTlP1qgqvMtM/hOMUA2VBj0YJp@vger.kernel.org
X-Gm-Message-State: AFq9FYJqpSJudXtacr70wfkUBb/jBefPKAOlfiZYPvixRKSMtCKS/6Am
	LcVzK+oC90v8kyCAEHL3X7OjzDcNbkSFdK6rNU8UQWqlpkOJmNwi0ZBWhEyNNyoZgJSfpO5zZeD
	CDDoiwtbv9aZhO8xV+8+V6OieEqrJkdg=
X-Gm-Gg: AYBFou0aEbA8LLwc1QcyMn0RX/JQRCvOu7Zqa15XnLMzWXq7kjpy3kl3k4loGshTnTZ
	eCBET3Mk2tcwCkKCQYNWqW7qYOXGdOBy1qdpsFhYDMJGfbcBSwY0A4uEhDj8BJh9rtLEaG8F8++
	ENJNy3NlbrBNlOTx4/gqeLiTtPQrwFqnI2bJe+iZDZGNB0jVbRuoT5A2+6JfUFY1o5umU8saQun
	m8r4HHMYWbb912yDDBmQ3VuQtJpS6/cLUSpuPXoqapNfj2J0Cf4OTaWHl5MoK1IeG4aUt/AF/7+
	VXPQre+76moNKUcuklUn+/uVwYYU/f1OSweI7zodPreZ6nrrBkS42XBG4YU/mwOcV/pVFxb5un2
	0O8sYa+Pc/Ym9JEsyTfpllaNIneV+sUy9JtMiHX6G/fmV4/MykTHN
X-Received: by 2002:a05:6a00:178f:b0:88b:72d6:b80e with SMTP id
 d2e1a72fcca58-897c5d55bc4mr259823b3a.13.1791508355601; Thu, 08 Oct 2026
 18:12:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007035739.3472432-1-4ncienth@gmail.com>
In-Reply-To: <20261007035739.3472432-1-4ncienth@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 8 Oct 2026 21:12:23 -0400
X-Gm-Features: AclHuK_m_kMGuBUY_F3PNA9Ts1xvaJcfDaoJFu7BhbCtEygkfb1YNmNxMxISybs
Message-ID: <CADvbK_fEWi7XFJgU-7Zo_pQ-a2AiQoJZHs-jhspYQ7xgNCKNyg@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: revalidate output stream after association
 connect wait
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 6, 2026 at 11:57=E2=80=AFPM Daehyeon Ko <4ncienth@gmail.com> wr=
ote:
>
> When message interleaving is enabled, the first send waits for associatio=
n
> establishment before building its data chunks.  The wait drops the socket
> lock, and handshake processing can reduce the output stream count to the
> peer-advertised inbound stream count.  sctp_stream_init() then frees the
> extension of every removed stream.
>
> The sender resumes with the stream that it checked before the wait.  If t=
he
> peer removed that stream, sctp_outq_tail() later dereferences its NULL
> extension.  Fatal-oops policies then panic the host.
>
> KASAN: null-ptr-deref in range [0x38-0x3f]
> RIP: sctp_outq_tail+0x49e/0xaa0
> Call Trace:
>  sctp_primitive_SEND
>  sctp_sendmsg_to_asoc
>  sctp_sendmsg
>
> A range check alone is insufficient.  Stream reconfiguration can grow the
> output count again while the lock is released without recreating extensio=
ns
> freed by the earlier shrink.  The stream can then be in range while its
> extension remains NULL.  The send-buffer wait has the same issue.
>
> Factor the range and extension checks into a helper and repeat both after
> each send-path wait that drops the socket lock.  Once the lock is
> reacquired, the validation remains stable through data creation and
> queueing.
>
> If validation fails after the connect wait, the auto-created association =
is
> already established.  Return ESRCH so the existing caller path keeps it
> under state-machine ownership instead of freeing it directly, which would
> leave protocol, counter and socket state inconsistent.
>
> Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_inter=
leave")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>

Acked-by: Xin Long <lucien.xin@gmail.com>
