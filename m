Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792694805;
	b=xCijbyuxavUP6LVbhnHUC5IpCeLhJXUkCA1/yArQZn4PHmTVKXGrpsxS9Xwoj7RQhBK2
	 eVO7sLeHtRdTtstq+wsJM25kGm4QoyKgCQwUodhx2AtFdvfWCEiRTAu6fZHCf0pEoR4WO
	 B+nqcF2SUqd/GSx0m9iCfqnq1yQUp8DA6WhGrA23W8GKR9fLK6kDrlq+WyFXkrQtAgZne
	 JGLH/Dsb0AJchL/73EN4cXCOBPBc3hvv1WKn7wM9RuvZ0TsteyirLbSf205IaIO2creep
	 qQtrEFYl4ZC+KTqRhdH7nn3EKmEuK4cMF7uOQr4JDhDqhMvlYiHvrHkT0bYSxPpZv5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792694805;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VJ3fHdUL5SmQAXabxpkgaJOcxdg9wUPTydhIVNe9+f4=;
	b=yEfB6OGesQJYwob692AgaJ+fISdAA8r+GaNHcx8vF/Hn0bDTfgZsja0Fq9RLXLq5t7+b
	 eZNElPQjrD4R1cujvTrKXMki41NFuGwirGySemUlwwc6bEKhMERlg0jNsf8TUg6IZeDiF
	 ZDOnXOim5I4JxeeSbZyOOLAfULnQ6gW6mZXzSkYM6tC8jxw4k9LYo+0mHS291fS3izPDR
	 sX5vGd+hu1YmtXgdOqUibAHsMQOr8lgsa1Je6KR6FCe6Tpdr4AS+xBt8sSLcMYMxDHq5Z
	 pQETD8dH0bAeNQLh0CsN/8q76aMShZfjBtDErahUKLVkm5QlpIs0uDSObvh+VZBxkPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eCUYLTzw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70742606A31A
	for <linux-sctp@vger.kernel.org>; Thu, 22 Oct 2026 18:46:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70742606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eCUYLTzw
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a06c60065fso154699b3a.1
        for <linux-sctp@vger.kernel.org>; Thu, 22 Oct 2026 11:46:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792694805; cv=none;
        d=google.com; s=arc-20260327;
        b=hgS9M7CkwklCI2sghkLqQqDsVOFbyefcYyPAE93uExn9NJoAtHX85RBSPWL5HFfyPP
         Ikg4W87RJLeGLrdRO8GbYaf1Dz7Kn+rtM5yV7dyLzAuf3O6/Erx9tzqQPglMhYi7m3/F
         hdTeZ52KRCS+gYI/fh2WUJ2nWM2V9QQQjkcKrDohsIeN5UcBR3TgI/RxseZopktTgCCz
         QU+bRpPjj+5DL+wbHQaviKgAmcBAyGbkmof7ABjTiwEMy6WWZIe6pF7E7fis/k+xhuyS
         ixc4C6ltnRqvedNPd8+5mhsXiwZ/sCzsU8juPdyiCKDRT1NocCyFqFUl2FzxqxphTphD
         lSQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VJ3fHdUL5SmQAXabxpkgaJOcxdg9wUPTydhIVNe9+f4=;
        fh=k3AmSeeW+kJe0AHZGDN1FXUgAAC/hMZG790nRe/4NJ0=;
        b=nX9YKEnFL2awCTULjHX/09M9A6zrKnlMoEVjnFiOYWdN9abDMI1J6DElRS4oRb6wdi
         rhuqXflZet/YvT9JlellCQBYD3kbazMSawc6nOUa8pirdhVyVDmqlF17DR9iPenRfqQb
         liFwKoOjvZV+Yym1sDG142VqaDm6jp6M1ONcBrl9+QlsPckXeecAJHKA/S3q3KI/sWoS
         LWJr06B3k/LS3zYuGHqTW2tLdXZDlfbL+Zx5WYNGEp3qmPRN1C/EPuV3akY8QzaBx+TG
         dWo11Ovj/s+OBwHod+f+D2eEidBW1W6TE+AIMWJ+/K2wqb5ml7OG2uiN44RdiBOiixoO
         r1GA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792694805; x=1793299605; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VJ3fHdUL5SmQAXabxpkgaJOcxdg9wUPTydhIVNe9+f4=;
        b=eCUYLTzwJZfnxmvJY9lif6asT9vcmB2mq2KLsm86LPWGVoZxPtjKpSerjQHYcsIj4D
         egiAzCIIJObZgpd+Fnb/+IzuoC43KA53Onhu2BPNR8wXUQSNWmxQxU8J4demSlU4Jyvy
         Rk+qcJh6IfWE5OLhY8ZZvXS1tXDSz3IvgXCBf2wwB6+/ZXUVp+P26GASmU5c+X4/jnig
         SPJbKfm4LqSDhKuzVRvqs5qsR9LPgJrgYOa0sODJKY3QyAw33Jy4gDcNtFKRSk6Xz9gV
         Srk07x5b+lqGu/n0bH9Fywbd7BiKbTwKfU6aWAlya8HEHokfXZngpHgeZ61W3KK9yLmm
         Z6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792694805; x=1793299605;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VJ3fHdUL5SmQAXabxpkgaJOcxdg9wUPTydhIVNe9+f4=;
        b=iZI2xY4EKnfMPNaHs+cGQkN7w1AOWK8jLWQpo8osY7zRm/DgEXtXvhF4pcd1Z9ItUf
         UMZEhfkWwGiP34OAOcnJYb0MqzsdPNeSZeUiy2/KYnBssBUTSnMRIPYhyeescTVy8V5A
         u/XvMn3+Xa9fqXs8dgnN5LlqJzbiK9n3ijtjgKlO1vgXKYHhAdsMNdnrfcDg+E5SFEZm
         vPwtnz20H8qtXlz6p/GaJN/YDz8GZQ9LQpLieZew/Uizz8e3AUzHkcMvEB3a4RFwVVqj
         FuAtAlqqas3r5xaU5LqCu4IDKgEQLJcgNbs4n1hOtOqtUOHIkyf6BXATLAf+vMBEhVFf
         CFSQ==
X-Forwarded-Encrypted: i=1; AKwUvBxfnx5LK+DV1RyxJnfS5sKKPeQFSszBFZP9+dNcOTH1DuQsfhsX/qOVId+S0sJ+iS/64tr+THXCtekY@vger.kernel.org
X-Gm-Message-State: AFq9FYISwZkguElmA/i18e+/36esgy6GWuCEk7hwDesUUKsByv8VhkBJ
	+n8uOrPjz1Xs4WjNEtdc/f+UEPnAzrXGIWZQWMuEWLN0qVJDZXkcxewqJ64DjS1gAb9WmQYsyiw
	I7T9fIac88CnPHd9H4fUx0qGsIuoaMk4=
X-Gm-Gg: AYBFou0pO60zGWf7zAQTJqn6YjDr+0wabil4ZDZRq+z2Omm8im00kknTLZUewEohpbn
	LsxBV1jph6c2J7DPhN5YvKn7GU+ArYCjc9pt97tjJovXV+nkhJGRoRR1BfUzKl/igi8FoTvkwue
	HpRnij90y7Gjlo5sFEJMN1ICx7yr1XCKKEE+eUsSINlxaK0bMNHlA6o4i02AWC4gLvRrSonZBsc
	hMSZxqR1Yn6MNDmBW/Ps8rzlS/rTFRgcXwohyNLs+mBJUdfjIlfGFxiQtIbGSAVWO3etdhkH3Nr
	S/lqe/MTIf9pbfvApv3IvMnAApO7FDD94r1FIAzAOCSV7lmqemwgvgzZtJKJcGW50wjDxxIuVIg
	FBiKsBEbYmDOTBJy3I7q84SQ44ng98RiZCL+lAA9oD6S7yRH16giIZgy+l9qZXr6WqaIjdvGypc
	QGvcM5VgjUTCCYzdzmI2WGEiDYD575RFuIl3I=
X-Received: by 2002:a05:6a00:428f:b0:8a0:70ff:aaf0 with SMTP id
 d2e1a72fcca58-8a2c7656184mr31128b3a.49.1792694804726; Thu, 22 Oct 2026
 11:46:44 -0700 (PDT)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019073747.178626-1-hdthky0@gmail.com>
In-Reply-To: <20261019073747.178626-1-hdthky0@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 22 Oct 2026 14:46:33 -0400
X-Gm-Features: AclHuK-PDx0jP5an3A6M6WQQwIMwVAosfNCvGR5QppU0ezO-BznZ8wHlN5NdZ1U
Message-ID: <CADvbK_ft9t1ipGawiOGsKU+qf0PFhctvewV6v+P0XmSMZOyA3Q@mail.gmail.com>
Subject: Re: [PATCH v5] sctp: reject forged cookie peer_addr with unknown
 address family
To: Xingyuan Mo <hdthky0@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, 
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 3:38=E2=80=AFAM Xingyuan Mo <hdthky0@gmail.com> wro=
te:
>
> When cookie authentication is disabled, COOKIE-ECHO peer_addr is
> attacker-controlled. An invalid sa_family made sctp_get_af_specific()
> return NULL and crash in sctp_transport_init() on
> af_specific->sockaddr_len. Validate it with af->addr_valid() in
> sctp_unpack_cookie(), which also rejects a mismatched family, e.g.
> an AF_INET6 peer_addr on an IPv4 socket that would later crash in
> sctp_v6_get_dst() on inet6_sk(sk)->opt. Validate a copy of peer_addr,
> since addr_valid() rewrites a v4-mapped v6 address in place and the
> cookie still lives in the received skb, which is not guaranteed to
> be unshared. Store the validated copy in the new association and
> pass it to sctp_process_init() instead of the raw cookie, so a
> v4-mapped v6 address is normalised to AF_INET before the association
> and its primary transport are built from it.
>
> For that, sctp_v6_addr_valid() has to return 0 for a non-v4-mapped
> address when it is called with a socket that is not PF_INET6, so that
> IPv6 addresses are never used on IPv4 sockets. The check is done after
> the v4-mapped handling, so v4-mapped addresses passed to an IPv4
> socket through the socket API keep being accepted. As addr_valid()
> now also checks sk_family and ipv6_only_sock, simplify the address
> handling in sctp_process_param() with it, as it additionally filters
> out non-unicast addresses. As a side effect, a v4-mapped address in
> an IPv6 address parameter is now normalised to AF_INET before the
> transport is created, matching what the socket API paths already do.
>
> Also add the missing !af check in sctp_process_init(), as
> sctp_get_af_specific(AF_INET6) returns NULL on CONFIG_IPV6=3Dn builds.
>
>   BUG: KASAN: null-ptr-deref in sctp_transport_new+0xa7/0x350
>   Read of size 4 at addr 00000000000000b4 by task poc/682
>   Call Trace:
>    <IRQ>
>    sctp_transport_new+0xa7/0x350
>    sctp_assoc_add_peer+0x153/0x850
>    sctp_process_init+0xf9/0x1180
>    sctp_sf_do_5_1D_ce+0x464/0xbc0
>    sctp_do_sm+0x114/0x2990
>    sctp_endpoint_bh_rcv+0x280/0x430
>    sctp_inq_push+0xdd/0x100
>    sctp_rcv+0x17f5/0x1ae0
>    sctp4_rcv+0x2b/0x40
>    ip_protocol_deliver_rcu+0x25b/0x270
>    ip_local_deliver+0xd1/0xe0
>    </IRQ>
>   Kernel panic - not syncing: Fatal exception in interrupt
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: opencode:deepseek-v4
> Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>

Acked-by: Xin Long <lucien.xin@gmail.com>
