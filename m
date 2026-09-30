Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7473468C11
	for <linux-sctp@vger.kernel.org>; Wed, 30 Sep 2026 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790800232; cv=pass; b=qNjZQXBVTZ5bjbp6XEXjUkF2D76W/jM15ZrZ1NGiPoEIF/oMgguOLim7SUbxIXYy+7dXlPuYpbyvQEflRyXG3UFdy1KjjmlfycYMkwaIWMyROVJP4Li2UT3EwgkR72OQko2id5Au4H/ON1cAPBdlOfJH0i9I+lKaKpFZhtYZB6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790800232; c=relaxed/simple;
	bh=G8k5XV1SWWAdy+RGfAj3dXa4DNUX8KUBtzKy/T8o1zs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jtZnDZmAlzcP7RXTJr3O6r70SijGP58G5m4NhcbaNASI88Wy0ZmQq7AHhSszcwnixWLLWEeHefkafkB0IldF4SDO4blaKyoV1XnDgQUebr/wAOV7THzca6sYmxtXGvv+UzigDPEpbUOtbdfP3QsgFs7nIH15C0zbBEFooQQHvmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H18oGY2r; arc=pass smtp.client-ip=74.125.228.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H18oGY2r"
Received: by mail-pz2-f38.google.com with SMTP id d2e1a72fcca58-88582e2153eso1774730b3a.2
        for <linux-sctp@vger.kernel.org>; Wed, 30 Sep 2026 13:30:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790800230; cv=none;
        d=google.com; s=arc-20260327;
        b=K4oUlnQhYpIuSYtw4NPl+obkUpXhLHxfmJ/Ns0T1AMtjLFRgZiH8q/gHLlUIcbkgvC
         ghZcN0AyVzLeFDvmevizeU1vcaT5rhRshoqlUtRjWjYHo2+mjudDNo+kdlnt/YsFJ9T5
         SntVjzUSrm0NsbDzEzw5Q2GlVyYehE7XEHeyxQKwP2d1IWRh9j59joDx0N//F15BKitP
         jJG7dIJwrlER0s1O2RRilzYHdSQAAhxE1pm1WtmwfK1rp3zvUVGsanT1kmd+QJYUuZj3
         RahBoiJTYFf3UnZr9HVC6zCe3b+eg4jv382Fr+hjP7sKLtseWyZRfPE0dtIHmv7m141Z
         12ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CjbSFyqOnw6JPYqmCBCI/LQ67eLhGfYCrMua/TXCkJg=;
        fh=ikVQ32suBCtdXsFL6KjmXIA8zrteUpvQiB+OYmwYsuw=;
        b=J9jkIf3gmSPRw80JuX2jJyz9z5gw9AXi1kBMRTSn0y+NJv7YgPtKpVtrJmpZRk7nVp
         7rayH9cYhW2GJ6dRlzqmsxkXl8Q4hKy8KYFH1Xps1ExCOAy1/q1DumVHKrl85v6WihCr
         hIPzcyBSBRnCA9tkiqs5MViuE9wGGf25JKq5U1tV+AyuVXFSQQlUlNrzDeo+1yPQ1pr4
         29SIy5UujMbq5ef9fhkM38bBBSECBKQ9CDkBVjhjfyGiyccN3a/ISvd2qsd2MDmwXQUs
         cTobQndvbxekOCid5CktxXpL6tWQCdhBQgUOX6nJtdOq6hBxzAT9ldLq+w29FRk1j6Cr
         AJMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790800230; x=1791405030; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CjbSFyqOnw6JPYqmCBCI/LQ67eLhGfYCrMua/TXCkJg=;
        b=H18oGY2rxPaodBLCo9ETzXF3R2XFiNFXK98UaHZfb0IKrJYX1zkxKMjVHJbQg+emd6
         0YJf442E3GigFVZMI3MT5D34zVNRRsUpWo9B7KNi017F2dYP1e/QnKfWiG9AGLeYf8sZ
         zIIGb6CfQ5FsYiXdPCy1K0JLK9rsZWrx3t0sPE7Tyc7Bjps3I7aSCjBaYhyMCMMQs58f
         j/xST5BdqXp5kghHqS9xwPZp8V5CsUD7lJzq3mzA7xK1oQ+FpVmo326jqhgCMeyWpprM
         ErgnI81MOLSaiZ/OvEI0hg6TrLLK1jG+3dlb/XQJiz6pzyvRnLrk6kl5wUNukTyApxkP
         r5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790800230; x=1791405030;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CjbSFyqOnw6JPYqmCBCI/LQ67eLhGfYCrMua/TXCkJg=;
        b=F2KKfrjjYtjnV36oT0bP25vTJgGpsOsHnpBiHWwQPFLsDkMwA1n0M3Gd1KqFJsgcvF
         deNk7gCPB5VEoysAvb3Cg5jpv4/9jZ1LtH8Uqn6EKVJKWmgE4fjTXmfkAt5QOZWSKt6C
         9V45edUEu7XPc4x8z9Sr+bQyMQvtgxqJL7AWNfra3jwv2U3ywD5r4kq45RfPwlDqa9oO
         h+VkufdwvHpE5FhjdWFtvopa2Eg+fFYDjNNPZgqdCgba8hcwMAGjOwfhCBog32MriqiH
         hB8nq6lu6hdHS5hOVlBGUa3nez0GoJMrGOZ9cWauqD6QofvGiVT+IGbG0IDOYror+hQL
         +3tQ==
X-Forwarded-Encrypted: i=1; AKwUvBxDMJvXmE+snx5UOvK76Awd38pkJcAUtYzDlRZ2m0/a0lLw2mtUAjhrE6KGnXtXw7wyFxqzuYPnLvTy@vger.kernel.org
X-Gm-Message-State: AFuF++lXBdV+wxgJ1Uy5mJz0EybG3ohw0WJiR2FW24B7l+j0oD5i/ltE
	Ltahu9eA15EtfR/uVN5/lRWa0SdzAO8m22tMBSdjF4Zt86CnK06dBcgF8y/5SruOc1rjutzrsqz
	YSyf5cuItsSRVWFwqHlUdRPlROCwLp1Y=
X-Gm-Gg: AYBFou3zwu+Nmuxo1kZRfWBGG/p9rwJRaMXSISjJUBm4wk5Hlh+FqyDDmhRZ/TR1WL8
	56TYvT8ppIxKRXXaH5AZ+3gZct5YeslYqekSzDcokNP8GsTocC3sABdMsUdBDsLd7B/OLYTs126
	ZRI3o2pkt83ip2TByb0byKdemM128p/gNJDUqclIBf64kaNzNDygRIzuqNae1w6Kbf6/gFA97bO
	uaVzKgNNLQ7vjz5Tcl2kZOeN7l3lewXfeWAdmyxSlyu769SPIDiSxxFG36HWN+Du1+f+24aWqUU
	lOXm5KAXOJkpXIEMT4SQ5midhe7NEly4c0c4ft4gLillQisSM0bkDbssU6k62DjZCIBhiKji0Bm
	JZE2qWw+rg8bl24A8kjr9840X2tK0xZV5vRxF19T2hSyOg+72NyIemuJgj+VCW+iL
X-Received: by 2002:a05:6a00:14c2:b0:880:8fe8:a3ea with SMTP id
 d2e1a72fcca58-8874be0d724mr2061194b3a.45.1790800230179; Wed, 30 Sep 2026
 13:30:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926095606.68601-1-juny24602@gmail.com>
In-Reply-To: <20260926095606.68601-1-juny24602@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 30 Sep 2026 16:30:18 -0400
X-Gm-Features: AclHuK_OSjgLkfBVMNxA26PGQ3HWO34j9O67roB4yluK7AQb7eV-UK8ZIUS6bCo
Message-ID: <CADvbK_fU6+=ea87yFXk5HxT4-MQLuejH38Bq4wruP+2KfqY-vw@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: check RCV_SHUTDOWN after the sendmsg connect wait
To: Jun Yang <juny24602@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	Jun Yang <junvyyang@tencent.com>, stable@vger.kernel.org, 
	TencentOS Corvus AI <corvus@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 26, 2026 at 5:56=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrot=
e:
>
> From: Jun Yang <junvyyang@tencent.com>
>
> sctp_wait_for_connect() drops the socket lock while it sleeps. An
> out-of-the-blue ABORT can then be processed from the socket backlog and
> unlink the association. If a concurrent shutdown(fd, SHUT_RD) sets
> RCV_SHUTDOWN, the waiter breaks with err =3D=3D 0 before checking
> asoc->base.dead. Its final sctp_association_put() can then free the
> association, leaving sctp_sendmsg_to_asoc() to continue with a dangling
> pointer.
>
> Check RCV_SHUTDOWN along with the wait error in sctp_sendmsg_to_asoc()
> before using the association again. The check only accesses the socket,
> so it needs no additional association reference. Return the existing
> -ESRCH so that sctp_sendmsg() skips freeing a new association that may
> already have been destroyed.
>
> Keep sctp_wait_for_connect() unchanged to preserve its behavior for the
> connect() caller.
>
> Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_inter=
leave")
> Cc: stable@vger.kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Assisted-by: tencentos-corvus-ai:hy4-preview
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> ---
> v3:
> - Check RCV_SHUTDOWN after the sendmsg connect wait, as suggested by
>   Xin Long, instead of taking an extra association reference and checking
>   asoc->base.dead.
> - Keep the shared wait helper unchanged and retain the -ESRCH error path.
> - Link to v2: https://lore.kernel.org/all/20260911090039.75646-1-juny2460=
2@gmail.com/
> - Review: https://lore.kernel.org/all/CADvbK_f=3DS-2waid_92PbOCh-LWjU5oiZ=
T+__xWfttVeTHEPQTg@mail.gmail.com/
>
> v2:
> - Leave sctp_wait_for_connect() unchanged to preserve connect() semantics=
.
> - Hold and validate the association in the sendmsg-only caller.
>
>  net/sctp/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index c7b9e325ec1c..4652fd90d9a6 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1844,7 +1844,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_associa=
tion *asoc,
>                 if (asoc->ep->intl_enable) {
>                         timeo =3D sock_sndtimeo(sk, 0);
>                         err =3D sctp_wait_for_connect(asoc, &timeo);
> -                       if (err) {
> +                       if (err || sk->sk_shutdown & RCV_SHUTDOWN) {
>                                 err =3D -ESRCH;
>                                 goto err;
>                         }
> --
> 2.54.0 (Apple Git-157)

Acked-by: Xin Long <lucien.xin@gmail.com>
