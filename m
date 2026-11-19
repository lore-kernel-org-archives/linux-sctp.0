Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795118530;
	b=iP3Blg861MPLu0lnnXnIy9kIPMQdx8RHtq8fBpWczT2V+dSIfWqla1aSonkJupLaSPB4
	 XAnJlnrgooTIeRKeyDvDGM29gboT0J246k2XAdwicR6MQ8IBGJ80EUluzBkO7cx1Lx6VY
	 /0q7vMbLT2m+gprn8ktCzWXR7t2WC154m2oMTQItVrsncI2Hy9okjG8UZ4K2FjEr990z6
	 MRnWt8oT0FAKQpViHPwIHqzoHsiv8VfyR2T+vJdYJskLlQjtjEhivSNQTi6W3iKAqlf8e
	 Vsv/YTAMDsdxK8jIRBGgmb+UtFibIPjeY5Wm4AuP1/1EmfBnM+3w9wBLLGqtePVItDQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118530;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=y4eem3MZHL+OJUpiUqcR8fCOWu+5ffSdx+AuciIXYFM=;
	b=UxmKvZ/JDo0SoTbbndQqbObgESVAl4F0A2wH4nbzr8bQFU6OHn5+tMIYfuShFEfkq0b3
	 XKf6JiolndAkUujkNybyWs0D/7fvhbLJKXDSvG1jqTl01EminhVMMqdLNjkqric+33nU9
	 ap9LNfsVXpQHI+gHsWEVyAW0y+85vBlWRws/pl+qyOsGt+OhoG63O8jCHjsHKuJmcOoSQ
	 vDb9CKWNbo3dicTHmBLGm6mJJqwVCKqXnMpnuaJtJATCOt6PI7SHjsjTJoYo6MOTxYOZs
	 5lNactwaAajyfDeU5/ondkSqq1XjfN6laF9t6OPVh3Own3aeMuTpv9X5m2se/zf2LAA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M3fG1mGz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2BC606A326
	for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 20:02:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE2BC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M3fG1mGz
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8c4cc85a315so171633b3a.0
        for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 12:02:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795118529; cv=none;
        d=google.com; s=arc-20260327;
        b=Z0mT+4oK49em2PsnN3ikwJMBwC/76aJdKsV+eLHrYnn/F/Ej03RwuF4JetdwHaesub
         FrsKFfS+unWvjuY+vZZSSpSKsl2qPFwhW/vq//G0PSgWLpVZMkHfGUp0mk6upTPx7h1S
         cqgJa+cgYWSr5eiemOwXsN1AScAp55QkdS2HP3bhBr5v12wkrEE/dHGlgpUXrjYPTibt
         Z+obY0uBmifaPcqpwRwK4b2VO+BcH9eN9p71FXrTd0N/T/7pubI8gYNZLbG1QtTc+hvn
         pnoNsIkn7+7lGHyrOvAKXEwUBpvICtF6+sOSC6GdL4A9OC0giOZjEW0nTD1hSOmUR3tZ
         fIoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y4eem3MZHL+OJUpiUqcR8fCOWu+5ffSdx+AuciIXYFM=;
        fh=FgGBuB8cMjk82FWG9w3oucTpcAzZHBrlKspv+tqQ/G8=;
        b=hiu8V7ZXYGxlC1StbIBNhYSQDyLWkdKgPz+Z7rjJ5ueBz+5NQm2P0q/K2Sw+BxbGxB
         H5G+/QB+dLxUh4HCNbyShhtBMwlEAuVzcPot6gkpe+kqcahpUKzCTvJIQsm41oLtkJx9
         00M5G09q7mN96vMcfv5UX+rED6W9s7rooN1ixOXMuYsqfOBI+Mty/VCvbO9+2uHEkmIz
         06zmZ4Jx1k/T9Y7Oy0D7QDf/ekI7fmOcSNNxEe7tANAMTMm2ESd1kNCHuXrLolmHPuZO
         0nax+E3Se12NFGaM0mW3m1pyEF5KfemeActZJOEaaHIpefkfbWvvnx1VbWtyFjOQ3L6I
         IfLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795118529; x=1795723329; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y4eem3MZHL+OJUpiUqcR8fCOWu+5ffSdx+AuciIXYFM=;
        b=M3fG1mGzEEkK5g7tak26ZQNGKd7qs9NXAy1TMsB82Nwso+Aptx1qWQVgo8Cp4FYXXs
         6dCdZfyEfFsjkmQzyIuP7py7yWf2sUr3E6zbpY0UbPMVVG/hCDp7r6OCU8QhY92fP7fb
         2BqvEu/y6MWxscIWT87NLch2a0NRJyfbRYUnUyakxrpco96/Lry3rD4NxzZQp6WgsEqW
         6EXSmFiiNb0vnfAp0ORPXQvFq4wc1uzM3C6wIfKmNqdXm4M+9ATW+r8ixkXprK4ca8O1
         +neYtapyEwGRaPSkmGUrNeA60ooaZI3OXnu1kMT9lxs1esQY/mR+a+fbDyqa8IppPFly
         gcvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795118529; x=1795723329;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y4eem3MZHL+OJUpiUqcR8fCOWu+5ffSdx+AuciIXYFM=;
        b=t5dwbWHFA/1dDTA5LJ1Rg3givScXCM9Z/kH1kqcZx5JBkrBX0kT8bojF1WdkbPAXLY
         j6mQCp0qa9qBtTQTQ9VlXENIfiBbGFXISjupP3XKNQyFOd/p8Hs9bJUb6yPwBlmUb5OV
         QHIkSbj03CGXltTgDDBpivddsUQEgvtqk0ZN/McKMhldAV4YeXGcmCqltUSMmeccHPaJ
         g/Ez3A0jo+9k20uq/MAnU6agSDZElgyzOSkLcBmLVgn2hN0atqiK3MppepSXcBSKFK/C
         PWGOaTrdwcZw9+0k3mzLwCcFyugY0c7pgwzZunKwGHdAJe+20uRdWUNxDi+G01W33EL0
         kIKQ==
X-Forwarded-Encrypted: i=1; AL+hErFsWjUqv7F032MaZXQ2NCLbXcex5DVEVOlWALKrkg/FV+ekfpNqpXimTe7I4R4GpzNhGSnk8ZXikzxh@vger.kernel.org
X-Gm-Message-State: APuU4Z/IFxWBEI2Wyrtcrv9CTr8uyRwozuTSyiDXW5Wi4S5IH2qM7zRO
	gi4AKA3iimnTAwfgpBtklcjmCVZqS9YKBQlM+d+ZnajkbATO+fCE1fxDvGTEP3KzbS+HHe3WfHy
	+wTPoVLaJcQwh2ID4Lsu7/JzCNdml0Wg=
X-Gm-Gg: AYBFou0SyZ1oEfm1v3YTxJgzoUinUL/0ysUJFm6Mh5kExNbI1vpfsZyO9okifpOnd3M
	H0RTd/xAnTPITwqZiB4ZUSYe/dGtTsuEIgqDW6TJCg0mo+AttqYNZWmslGpQE4ciwLVOyqUqOzn
	s0iR0kjzNw8Bi3eSxJ7glkZYpFub+kq1KNoiMz4QM4hFYI00TjAqeJD1KlgsJ4cEYWE1DYjZcDk
	8aIRyYqFch+1/2vH8jFRC4Li/buBkRzY45aMblxhBLJE7DdP/QEi6sqHmckv/yZfuIQkjkQNgri
	8/B+dgRg0GUpIFU29vGIkOkCWPv/X0zU+9qy3VZCDn6CIl6KV+P3vFHkBTEb+XO0bcJvDILHqaa
	VAyw/jBdeAKMt6ImKQ8QOmFbme38ZHBzHB2tat0bQ2pFQc8yai2xLKbFGntI/tr0n7rBix2THt8
	w5g5M0amuW3kmSn3jY9DRe/j+8GsDaplfNPQI=
X-Received: by 2002:a05:6a21:39a:b0:3e2:aab8:4eb6 with SMTP id
 adf61e73a8af0-4014db602b4mr721063637.47.1795118528518; Thu, 19 Nov 2026
 12:02:08 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <179505710266.3511678.14017674052424733262@gmail.com>
In-Reply-To: <179505710266.3511678.14017674052424733262@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 19 Nov 2026 15:01:57 -0500
X-Gm-Features: AclHuK_QNEvmBX1MCKcJp6gFprpzU6I8eQIOW2c22-DHXFZThro3p5SjaiyInMM
Message-ID: <CADvbK_citvtZ4eumLcx_szUvth7sQMP1oKu0mLbo0a3bD-eSxQ@mail.gmail.com>
Subject: Re: [BUG] sctp: auth: NULL asoc->shkey after a failed
 SCTP_CMD_ASSOC_SHKEY makes close() oops
To: Kyuwon Cho <kyuwoncho18@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jun Yang <junvyyang@tencent.com>, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 10:04=E2=80=AFPM Kyuwon Cho <kyuwoncho18@gmail.com>=
 wrote:
>
> Hi Marcelo, Xin,
>
> While testing v7.4-rc3 with an LLM-guided test generator that we are
> developing as a research prototype, we found that an SCTP association
> whose shared key could not be set up still builds authenticated chunks,
> with a NULL key. Closing such a socket with SO_LINGER {1, 0} then
> oopses in sctp_auth_shkey_hold(); here as an unprivileged user:
>
>   BUG: KASAN: null-ptr-deref in sctp_auth_shkey_hold (include/linux/refco=
unt.h:366 net/sctp/auth.c:113)
>   Write of size 4 at addr 0000000000000018 by task test/115
>   CPU: 1 UID: 65534 PID: 115 Comm: test Not tainted 7.4.0-rc3 #1 PREEMPT(=
lazy)
>   Call Trace:
>    <TASK>
>    sctp_auth_shkey_hold (include/linux/refcount.h:366 net/sctp/auth.c:113=
)
>    sctp_control_set_owner_w (net/sctp/sm_make_chunk.c:112)
>    sctp_make_abort_user (net/sctp/sm_make_chunk.c:1492 net/sctp/sm_make_c=
hunk.c:953 net/sctp/sm_make_chunk.c:1016)
>    sctp_close (net/sctp/socket.c:1564)
>    inet_release (net/ipv4/af_inet.c:443)
>    __sock_release (net/socket.c:735)
>    sock_close (net/socket.c:1529)
>    __fput (fs/file_table.c:512)
>    fput_close_sync (fs/file_table.c:618)
>    __x64_sys_close (fs/open.c:1574 fs/open.c:1597 fs/open.c:1584)
>    do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_6=
4.c:89)
>    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>    </TASK>
>
> When the INIT-ACK arrives, sctp_sf_do_5_1C_ack() queues
> SCTP_CMD_PEER_INIT, which records that the peer supports AUTH and which
> chunks it wants authenticated, and then SCTP_CMD_ASSOC_SHKEY:
>
>         case SCTP_CMD_ASSOC_SHKEY:
>                 error =3D sctp_auth_asoc_init_active_key(asoc,
>                                         GFP_ATOMIC);
>                 break;
>
> sctp_auth_asoc_init_active_key() returns -ENOMEM before it sets
> asoc->shkey when the secret cannot be allocated:
>
>         secret =3D sctp_auth_asoc_create_secret(asoc, ep_key, gfp);
>         if (!secret)
>                 return -ENOMEM;
>         ...
>         asoc->shkey =3D ep_key;
>
> sctp_cmd_interpreter() then drops the remaining commands, but the
> association stays, with peer.auth_capable set and asoc->shkey NULL. If

The association should NOT stay with a broken state, but be deleted in such
cases. But it seems we can't do it in the loop of sctp_cmd_interpreter().

Can you please try fixing it by directly calling sctp_process_init() and
sctp_auth_asoc_init_active_key() in sctp_sf_do_5_1C_ack()? like:

        if (!sctp_process_init((struct sctp_association *)asoc, chunk,
                               sctp_source(chunk), initchunk, GFP_ATOMIC)) =
{
                sctp_add_cmd_sf(commands, SCTP_CMD_INIT_FAILED,
                                SCTP_U16(SCTP_ERROR_NO_RESOURCE));
                return SCTP_DISPOSITION_CONSUME;
        }

        /* SCTP-AUTH: generate the association shared keys so that
         * we can potentially sign the COOKIE-ECHO.
         */
        if (sctp_auth_asoc_init_active_key((struct sctp_association *)asoc,
                                           GFP_ATOMIC)) {
                sctp_add_cmd_sf(commands, SCTP_CMD_INIT_FAILED,
                                SCTP_U16(SCTP_ERROR_NO_RESOURCE));
                return SCTP_DISPOSITION_CONSUME;
        }

instead of using SCTP_CMD_PEER_INIT and SCTP_CMD_ASSOC_SHKEY.

Then you can delete SCTP_CMD_PEER_INIT and SCTP_CMD_ASSOC_SHKEY commands
from sctp code, as they're no longer used.

Also, please use git-send-email to send your patch, not send it as an
attachment.

Thanks.
