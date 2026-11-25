Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795632780;
	b=QPulhsoGWHfMkPHkYDKJrnNFm4C+W0MgdNJB0ZbLlkLMBacY9n4xtfuCb5sqRArrfcTU
	 N+eluDyu2gRbKs0eT+fGGNnpBhxTXVeZRw2UMxPeiyEA9XtlPONeV7d7f1WGBrDERDyY1
	 I09q7a5MCFBGHSBQIpf8OdRP5C9dTlHr7SYFrlux/qsc3uMDcP6TPxo0IZDTXCXKilAgt
	 nW4ATEw2Z6KKQxlUFESIRb1hg4YVZcdBhXxrKhmcv1eANIVT9hYz0HBfy7FncdqHKh+TG
	 aNRHRo7x1DbSpCDDazgwoZJ15/293V3fuKU4gvkHFKZdu+L10TC4gyVW3pNy7021xSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795632780;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=IZVbbZbujlD5JJFyB1xbx4SO9f/2Crn3lUovbiEC2mg=;
	b=Bl8XSsCAx5Ue7owRxKrv8g9CcEpZjC6WIPxu1zI0pJLbveFgUxtCs9TLgV22GlcElOH2
	 1kov+6Es7sm2e+6vTWZUwBTlb51Uor5awJwOmND6r/qKMmiyCHiTVfePqr57xL0aYr5nk
	 oaXRgWiYkme9IJYy48P2zJINV2XJs2DxGJrT4hk6T62wVFgTInoc8P5J2vtGPHd3pNLng
	 6IWgRrbJYfiC0meq8Hoer7iQ5TGmW1EhZgNmk7e2oIEl9KY0/q0Iv75QjljLLo5avmsQm
	 IzDGo7w1Y58yGENS95i7MFMB0J/FarvNBxe91GJzKwr3r+XPEQb9GfTrX9Dd/cM2Ozw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lVqNacN7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A8D606A321
	for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 18:53:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44A8D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lVqNacN7
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8b3577deeb0so2833152b3a.3
        for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 10:53:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795632779; cv=none;
        d=google.com; s=arc-20260327;
        b=nTc9E2B5LQVcxUzacR9s4i8CLcdkBO7I9bj6MWRM5fLVMd9rjGHjvKt16miwLcVDn6
         bX/W9Pndp+A9szE4KAhs8LJXfn6gtuqoy5LadpJe42/CZJgskElL47TpXuddtFH9MjD9
         7+NrhTrUz22gHJUap92vffsAz0daONpA5qclLGp3bKA+FvBXFIoB2GFcnnPQ8PkMxtC6
         4uXXuRNfKVC4ZXg0hvhLm58ZmWw+IokbSG+4uqAdXcwmanwOJNxeM8GfAv+mon8ju1vC
         6tlqrfYBHZ4wPegbz3GS7j2KEs8loVQUjbEscZUVRbiQxLDb2SLBOyxM7tTaxg2/BVzE
         6oxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IZVbbZbujlD5JJFyB1xbx4SO9f/2Crn3lUovbiEC2mg=;
        fh=+NXdMp+v/JejkNaURFIF88a82me5tDXgN4ad9/a2k2o=;
        b=KDTbbbuweTsdqlIucI4/+VNTfR7rjbdbDFKEUjA95jr+bJTAj97cp4+LS9ontbofCC
         OPyLQkjak+PC4eNv7VbY1QTfKMMLqnYke5QtFZHqAn4d9+OY894j2gcnn0GWGBEOyzTi
         haw+31XVmk8nMEpOR0vNTetJtULk5fFQ2jqwG708UzJitP2Tv22xkZquQCmL3BibMzrR
         eWGxJBoYMiiMuVLLLIuOEUQWXuyBP+HcrAKal6w1d8LYqPE3A3gWHkpil4gc+opOzqWy
         F/FdC7mJAmWeh7iHdQBF0ZU90Gog2z/twFqpGwq+61jSkWsvsd3ZxS4KILxP80IeuE2V
         bj9Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795632779; x=1796237579; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IZVbbZbujlD5JJFyB1xbx4SO9f/2Crn3lUovbiEC2mg=;
        b=lVqNacN7LdzQjJTMNHqQ7/MUcNe5hD+PE8EIybVfKW6KfzGViUEDzr8OufzAB08c+T
         5r4r+nOK1nvHFSq8X540dDBC6p+Q/IlMzIzyqHZkhqgQ2R0RkotNZvSzptNEXan1adBp
         STiFOSUUaP1nHFRtGl/eijLnj5jkesENMKg6TJYds+VNVGkJMsgxf6I6OC1Tjvtu/8x+
         eohA1mlgvLGG3epvEpUJbvD3Y6I0fcTsVCNB8Dzp/8JV32keqrb8XS9Np07TxmEXIIH4
         oVOt46dPWsqvSn3FCaE/K23N9hZvVA3x/jLo7Sa0VEl/JL8YOcpNN020OUodSqR6HHBT
         UL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795632779; x=1796237579;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IZVbbZbujlD5JJFyB1xbx4SO9f/2Crn3lUovbiEC2mg=;
        b=R8nQrxzjatKrxcwBQe/0dCuNCUS1Z5vbESbGwXYLoTN7rpquSg68kc3X9Tn0Oji1cf
         zw7M4ZZ3Sn1aX3DTjKELT7qcEgO6JZ8mESwO5xSkslL7x6IUOhRTs0Rw8sI1W+JvmXHa
         B2fA3sVi2NKFFjmWhyIt6MPzkw61uuFt3Tts4c5W/4XlrL0G5y6PtIiNz96hrXlBzyVD
         3yWRBF+8vtLo+CkVGHPI0lOfb0EfPgLNvCBqdveQJKWb7TTN0p9XXCUM4W9/vSnSEhXe
         TV3W315JiB9mtKW9cfrQpU7ElbXTwLES2m5/mW2C6NKGR6wBp78eTzLnZZb46sDQpPCx
         HIEg==
X-Forwarded-Encrypted: i=1; AL+hErHmkLY+gY4jH9URuzioeSAk3Px4m3P9FJFUU1hzKFi25M3wVKxrKLSpDRRgjcGQ17Ob7+zXyymsyj7T@vger.kernel.org
X-Gm-Message-State: APuU4Z/LU1T1BIiXPONGRKn1zBC8DxOx8tvdHbecKYPeQhs4tArivj9E
	CN2Hh8U3OJFjAuMWWVjLBbLHZvARnSDIR4n0QZRKrH+2qRe9SHMha4dvZGoRd1F/c7z8FU+TV2M
	jdAoKXGiBGtKIpIVHWrx2lVC15FWiJgE=
X-Gm-Gg: AZFdTZcmFZXikwRhWqq0N+LujO3hYN9IFSuEPkIvlQYb5w2Py0xoASoRKbDSTv5+FDs
	jWVdTNFIh2OUb5b+dSEtzntfpPyI0DF+oMQBIhi4fKlsmCOUrYMonvOwJfLVzJOB7m+AzTKJaeL
	af8Otj63BzV2nx8cka5n66TvwfwnQWwWiVZixnzGZWUSlQN9X8wHB/Yz4tGNCGTd5tvMGF7GE2S
	XK68P/qI/NIs6TP8CqTWOV3zAp4pNJiaq1Yhop2wNOcfZJeZmuEpQCx8b1Oq3hgIGNrQGQNf0b6
	otAcpaqQOWFi6eE+DWfpjYJbTyfkSckX+Y/PXxeWS4fGFFu1db0/0EwdwXxAvmNczwJe7vwfzYT
	jDYJvdjMKBabWazTcbnwQhl1CVerOQYqz4a63LG/N7Pc1WsfEBL0cLKuN3TswEqAsPZmCqq4nKi
	64evXo2PWy+54i7wKTVRtRPLUAvXXAHrw0C6swliVUCu4fiCKkNfH/U2HY7HPyIO5CSrmM
X-Received: by 2002:a05:6a00:85:b0:8cc:9373:fbe7 with SMTP id
 d2e1a72fcca58-8cc93740d87mr6993000b3a.11.1795632779404; Wed, 25 Nov 2026
 10:52:59 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <179560159232.2963157.3418291084812904092@gmail.com>
In-Reply-To: <179560159232.2963157.3418291084812904092@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 Nov 2026 13:52:46 -0500
X-Gm-Features: Aa3M54qZsmTLB5jdsFQl6LWvai0mPjGnFjyppTnAjbm-rMJPAX5Hrj5RsV-2zbA
Message-ID: <CADvbK_cNs_X+6VmJd_RqJsWMzdH2oY3BEp4O3e+ymTwcDQPdYg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: keep the port of a bound socket when adding an
 address fails
To: Kyuwon Cho <kyuwoncho18@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>, 
	Neil Horman <nhorman@tuxdriver.com>, Mao Wenan <maowenan@huawei.com>, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 8:49=E2=80=AFAM Kyuwon Cho <kyuwoncho18@gmail.com> =
wrote:
>
> Since commit 29b99f54a8e6 ("sctp: destroy bucket if failed to bind
> addr"), sctp_do_bind() releases the port when sctp_add_bind_addr()
> fails. sctp_bindx_add() also calls it for each extra address of a
> socket that is already bound, and possibly listening. There
> sctp_get_port_local() takes no new reference, but the failure path
> still calls sctp_put_port(), which unhashes the port and clears
> bind_hash and inet_num while the socket keeps its other addresses and
> stays listening. listen(0) then writes through the NULL bind_hash, and
> accept() of a pending association oopses in sctp_clone_sock():
>
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   RIP: 0010:sctp_inet_listen (net/sctp/socket.c:8723)
>   Call Trace:
>    __sys_listen (net/socket.c:2016)
>    __x64_sys_listen (net/socket.c:2021)
>    do_syscall_64 (arch/x86/entry/syscall_64.c:61)
>
> Release the port only when this call took it, that is, when the socket
> had no bind_hash before.
>
> Fixes: 29b99f54a8e6 ("sctp: destroy bucket if failed to bind addr")
> Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
> ---
> The issue was found by an LLM-guided test generator that we are
> developing as a research prototype. A reproducer, which runs as any
> user with CONFIG_FAILSLAB:
>
> #define _GNU_SOURCE
> #include <arpa/inet.h>
> #include <fcntl.h>
> #include <net/if.h>
> #include <sched.h>
> #include <stdio.h>
> #include <sys/ioctl.h>
> #include <sys/socket.h>
> #include <unistd.h>
>
> #define SCTP_SOCKOPT_BINDX_ADD  100
>
> /* needs CONFIG_FAULT_INJECTION and CONFIG_FAILSLAB; runs as any user */
> int main(void)
> {
>         struct ifreq lo =3D { .ifr_name =3D "lo", .ifr_flags =3D IFF_UP }=
;
>         struct sockaddr_in a =3D {
>                 .sin_family =3D AF_INET,
>                 .sin_port =3D htons(30114),
>                 .sin_addr.s_addr =3D htonl(INADDR_LOOPBACK),
>         };
>         int s, one =3D 1, nth =3D open("/proc/thread-self/fail-nth", O_WR=
ONLY);
>
>         if (unshare(CLONE_NEWUSER | CLONE_NEWNET))
>                 return perror("unshare"), 1;
>         s =3D socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
>         ioctl(s, SIOCSIFFLAGS, &lo);
>         bind(s, (void *)&a, sizeof(a));
>         listen(s, 5);
>         setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));
>
>         /* fail the allocation in sctp_add_bind_addr() */
>         a.sin_addr.s_addr =3D inet_addr("127.0.0.2");
>         if (write(nth, "1", 1) !=3D 1)
>                 return perror("fail-nth"), 1;
>         printf("bindx add: %d\n",
>                setsockopt(s, IPPROTO_SCTP, SCTP_SOCKOPT_BINDX_ADD, &a, si=
zeof(a)));
>
>         printf("listen(0): %d\n", listen(s, 0));
>         return 0;
> }
>
> Without the patch, listen(0) oopses as above; with it, it returns 0,
> and in a variant that accepts a pending association, accept()
> returns the new socket.
>
> The patch was written with LLM assistance; we reviewed and tested it.
>
>  net/sctp/socket.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index bc68af88e271..519063833aac 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -420,6 +420,7 @@ static int sctp_do_bind(struct sock *sk, union sctp_a=
ddr *addr, int len)
>         struct sctp_bind_addr *bp =3D &ep->base.bind_addr;
>         struct sctp_af *af;
>         unsigned short snum;
> +       bool bound;
>         int ret =3D 0;
>
>         /* Common sockaddr verification. */
> @@ -467,6 +468,7 @@ static int sctp_do_bind(struct sock *sk, union sctp_a=
ddr *addr, int len)
>          * The function sctp_get_port_local() does duplicate address
>          * detection.
>          */
> +       bound =3D sp->bind_hash;
>         addr->v4.sin_port =3D htons(snum);
>         if (sctp_get_port_local(sk, addr))
>                 return -EADDRINUSE;
> @@ -484,7 +486,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_a=
ddr *addr, int len)
>                                  SCTP_ADDR_SRC, GFP_ATOMIC);
>
>         if (ret) {
> -               sctp_put_port(sk);
> +               if (!bound)
> +                       sctp_put_port(sk);
>                 return ret;
>         }
>         /* Copy back into socket for getsockname() use. */
> --
> 2.43.0
>
Acked-by: Xin Long <lucien.xin@gmail.com>
