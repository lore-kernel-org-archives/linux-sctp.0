Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795540154;
	b=zgc+BJbmy2YSnVd1TIFWKMW78MvvpFKimfH/1gkTJ+113DYymC+/8B3B/ZY21gW7teNH
	 NC0Bqc3xfxSAyRycH+PiUfTYUuYQT1AnGn7GfmzsJ9gaOycPuHBhNXdVkB43pDqrTqkU3
	 OEHsBX0J7jPN+Rkn/8pkTTVuIvvlLhfBKtXyDVikxPf0pgMqvrixSUWlSUxPi6lezitfF
	 SwEOFSGlY906IXChqLt3FovPgiEshMUMRFKlh2SNHM7LMk3llLIWPAx0tTSxM+4gRClEE
	 2O8G+SBIad+6XJtwndqDxQxELdT8QwgIAjKEdYFsJOAPIeIeiu4kiSG/gZZkR0kT/mA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540154;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=X9VL+UZGuvvn+L4e88A9yFSdMmbH0iKnEH4T++PwoT0=;
	b=lNXqydxqd8QlRLz8OlMwc7u6ok3l2ZJpRmbLDHBpPcj/ErtuNDEY+bZHgOtdtTMGBFix
	 f89RriD/Vjz+eLQyXFNzGsaM9DtZekinUBTZ8sZziT5AcWZroZK6qEw2OumIWiQmpW0rC
	 Hw4Fr1WrHqByZ2N2g/2/jO2pAYuHn2RkJPHEQwa2zRnYM151ENRv2k/Q/MCXPaY08sY2o
	 1aZYzfxelqTb51cm/S1reZJKV81BS07Q+1h7ZIs/3NxIif4K/AZTMvdI2zi9WVGXMzl9Q
	 7oWNY5QKYBPDXC/wI9GMroDLfYctNefeT8v4bKtQCIAVyIdphDFkGwPjYWjjz8Xd9xw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q3ofmZ51;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BE660A2637
	for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 17:09:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20BE660A2637
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q3ofmZ51
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd6acc50b8dso2433009a12.3
        for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 09:09:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795540152; cv=none;
        d=google.com; s=arc-20260327;
        b=GdLuAXP46nBWniEqE+Flsf1z7n6HJmJsTzB/Ee2CvoTIZ7P3dnXogjgAnNIRvW70j0
         vT/gGQdfxrey6ifGfENWI7+O4FDv+irfFXnSUh0vZVq0fOwoOMet/HW6ff/TPZGCh40f
         aMBE41XSjq0SOOSiXTdR1xwNoc3/+IN/Oatx3IUU7yjqgG+crJq+kbqu0IlTF+rAanOz
         rvZ4sn11GCt+ABSiFTAxR1/kgkUNrS4J2HMRFF/V46z2bWlDLWQeeUkRNDtwaU7lxfNx
         oGsceLfwKWd5i3SUIfd2hpizSzH6jXl5hZhdyY7qDJYNquNrrtAF8r2iZrIm6CAr+9PJ
         8Tpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X9VL+UZGuvvn+L4e88A9yFSdMmbH0iKnEH4T++PwoT0=;
        fh=Nk7NKDdWIis3S166xO8y+5dDv+CfSa44ATxFyZuc8UQ=;
        b=q/oCUf8WLOE3Aw/OzoZniVb+baJGhpYbA2MX7DuKfBa6sj57TL8wfXxavUG3pIrdXy
         ZQohVgnXM/4LIlRb4NXNmXquynoiyYhLM6llaLIZV2dx31HejeKIpmuFpFslMcWyS4/Z
         /SZBFcULwmjuwxs7pvBdgd7abH9c3GAlljo4pvzjFY1+8t7nlLV9fIVhxyhUcQ+s5g1E
         zQG9QGHV2jz8rrkproi32ZzWPwV5rJuq1BqC3+eN2LGiQSwb9RhWBf8nWoN5oCT+Bykg
         QOqh5OS461DtGtBB/fDUTV/YRxPWrGO1nXEXuIa51yu89+zPySeAbZlO7movBm4wDXEl
         3KNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795540152; x=1796144952; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X9VL+UZGuvvn+L4e88A9yFSdMmbH0iKnEH4T++PwoT0=;
        b=q3ofmZ51KdDiSe31lFyb1pGcKM2i5v6DnKfzrg+Pky/e9KyGKb1/+AkYl9QZ9sR3du
         rj+nBMjVGvXqgjlFfny2JCQCIRfswUsErqN7P3Yu3Kl4Wr0hHhZg+XxKijd5Q6fAKWR4
         6NVEsE4P3Uib7ty8eOkbDpbZkWkUpOW6Onh7y4dGdlvMtpqtZIWn+8rKO+i/cpPY/HY7
         huQTRNe46nKtyvdSuzaLClrIVBxyPmYoJmfyspB53oTKgr8sZljTPJKBRbXPKmmzlweO
         g+U4obngtO0yjgCUOK3gaB5CYU5lHY96yfGFG2lH32X/OHwq1g9lzqUfrsKqhRLSnGCV
         4GXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795540152; x=1796144952;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X9VL+UZGuvvn+L4e88A9yFSdMmbH0iKnEH4T++PwoT0=;
        b=pHCUlZJ7RufINHyG4FJJH46VBuwi5yq3SSw69TvoyGzjAPQTYDrOpYbAckQJRE055w
         L0vWcqOAZfD0S/bY1nP3jSe85lBynBxEyUnaWmHQAFudDfN5cflnMxlPOX/JQYFnMBQk
         2YDadPuaRH5BY3lsTOhc65R7OVYG2+ZSappeGK6kE59z5hFEVN/nt1HJkqYKlbKvwc2u
         aeR3YIWuAz7oKjsnQ5mhKZFWvnPJycoPmPkrMROnk4oWHIjP8nDOfzVt8aG62IjJwi2I
         Bu8ovPnreIYEfim3vFLx4vJDfYkfhBNlCiNvsQAwTtKlAotVtiijhP4dnwgiUa/H/h0Z
         b6+A==
X-Forwarded-Encrypted: i=1; AL+hErGKiPz8cdUnLvn3/PuPLQhooaNU4Nz5go24eKFe/jPjtTugi+tvumwr5Sh941i92QX/K6y/2ZmgRNGo@vger.kernel.org
X-Gm-Message-State: APuU4Z8EoAtiz5GrOzpCxW1xQbEqlL7NPKJ4dVcjEyArmkG4K1Ol/Wz0
	pb0glcmFbJUQDAXoOE7G1Rky+NSREskZjrHpn0nZ7/cBU03IHpz5mA0zZK3Ev95SYv6Tni3iKV5
	dIzNB0i1gUpras6DJIV0ezHyOx3BuRjs=
X-Gm-Gg: AZFdTZfWbWItkA5AL17tbUY8W0Ki4onBjvpfo7bTAQjDlaJREFxEME+Q0C4ZzOdYmgR
	jJqxYvKq7WeQdhDbFBC1sGT4IkT7jg/46/qZCnTifLsHoTwamyg4aCMVoi9l8Xs+pfmkQNKdubH
	g1LEvrNQSwjBYxRMIa0Hq6R3l6cJiCPXmWxh3KlDwKdPFxPZtQSGVoz09MVoozrwrVsW2KjRs/D
	YUlkaEHYjGs2It6iPlekhPx9hxY3GmuTVPK1loiOjCEdKCa8Ud+K8niN0Dl3zbXnQ/cE9soRJ2e
	M9EYtjQAjUaPA/WviE/OBF4AcEde/fQclDn7JMvXtUu2+4zW+FOtGNrsah4CoHr3/X0DBjwqE8R
	y14XHD/1KwCc/fXi4Sjch1Py1Ob45ggRzOPu1mg/G7wcpaaUlkf2ISBI/Xj/fH7S9KDh++CN2+P
	KxzrvH783xwznLtefUJKZRd4WV9j7kobLhoK1UkQ==
X-Received: by 2002:a05:6a20:6a06:b0:3f8:443c:4ce1 with SMTP id
 adf61e73a8af0-4014db57950mr17323321637.29.1795540152313; Tue, 24 Nov 2026
 09:09:12 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <179539544818.3016044.13738712075053349592@gmail.com> <179539544818.3016044.18009252996572506068@gmail.com>
In-Reply-To: <179539544818.3016044.18009252996572506068@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 24 Nov 2026 12:09:01 -0500
X-Gm-Features: Aa3M54o3Mm28v-FnGzbOeKj4VXKtMVAJcVd8119mGvZOM1SygJE7tskfr7xggbY
Message-ID: <CADvbK_de1zGLfjvEk-BJYcv5SsEzqC2RwL3R7qt7sWL09aCmow@mail.gmail.com>
Subject: Re: [PATCH net v3 1/1] sctp: fail the association when the INIT-ACK
 cannot be processed
To: Kyuwon Cho <kyuwoncho18@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Willem de Bruijn <willemb@google.com>, Jun Yang <junvyyang@tencent.com>, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 22, 2026 at 11:09=E2=80=AFPM Kyuwon Cho <kyuwoncho18@gmail.com>=
 wrote:
>
> sctp_sf_do_5_1C_ack() queues SCTP_CMD_PEER_INIT and SCTP_CMD_ASSOC_SHKEY.
> If either fails to allocate memory, sctp_cmd_interpreter() stops there,
> but the association stays: with the peer marked AUTH capable and
> asoc->shkey still NULL, a chunk that the peer wants authenticated, such
> as the ABORT built by close() with SO_LINGER {1, 0}, takes a reference
> on the NULL key:
>
>   BUG: KASAN: null-ptr-deref in sctp_auth_shkey_hold (net/sctp/auth.c:113=
)
>   Write of size 4 at addr 0000000000000018
>   Call Trace:
>    sctp_auth_shkey_hold (net/sctp/auth.c:113)
>    sctp_control_set_owner_w (net/sctp/sm_make_chunk.c:112)
>    sctp_make_abort_user (net/sctp/sm_make_chunk.c:1016)
>    sctp_close (net/sctp/socket.c:1564)
>
> Process the INIT-ACK and set up the association key directly in
> sctp_sf_do_5_1C_ack(), and fail the association if either step fails.
> SCTP_CMD_PEER_INIT and SCTP_CMD_ASSOC_SHKEY have no other users, so
> remove them.
>
> Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
> Suggested-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
> ---
>  include/net/sctp/command.h |  4 ----
>  net/sctp/sm_sideeffect.c   | 40 --------------------------------------
>  net/sctp/sm_statefuns.c    | 15 +++++++++++---
>  3 files changed, 12 insertions(+), 47 deletions(-)
>
> diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
> index 2058fabffbf6..8596e96c321a 100644
> --- a/include/net/sctp/command.h
> +++ b/include/net/sctp/command.h
> @@ -34,7 +34,6 @@ enum sctp_verb {
>         SCTP_CMD_GEN_SACK,      /* Send a Selective ACK (maybe).  */
>         SCTP_CMD_PROCESS_SACK,  /* Process an inbound SACK.  */
>         SCTP_CMD_GEN_INIT_ACK,  /* Generate an INIT ACK chunk.  */
> -       SCTP_CMD_PEER_INIT,     /* Process a INIT from the peer.  */
>         SCTP_CMD_GEN_COOKIE_ECHO, /* Generate a COOKIE ECHO chunk. */
>         SCTP_CMD_CHUNK_ULP,     /* Send a chunk to the sockets layer.  */
>         SCTP_CMD_EVENT_ULP,     /* Send a notification to the sockets lay=
er. */
> @@ -86,7 +85,6 @@ enum sctp_verb {
>         SCTP_CMD_ASSOC_CHANGE,   /* generate and send assoc_change event =
*/
>         SCTP_CMD_ADAPTATION_IND, /* generate and send adaptation event */
>         SCTP_CMD_PEER_NO_AUTH,   /* generate and send authentication even=
t */
> -       SCTP_CMD_ASSOC_SHKEY,    /* generate the association shared keys =
*/
>         SCTP_CMD_T1_RETRAN,      /* Mark for retransmission after T1 time=
out  */
>         SCTP_CMD_UPDATE_INITTAG, /* Update peer inittag */
>         SCTP_CMD_SEND_MSG,       /* Send the whole use message */
> @@ -117,7 +115,6 @@ union sctp_arg {
>         struct sctp_association *asoc;
>         struct sctp_transport *transport;
>         struct sctp_bind_addr *bp;
> -       struct sctp_init_chunk *init;
>         struct sctp_ulpevent *ulpevent;
>         struct sctp_packet *packet;
>         struct sctp_sackhdr *sackh;
> @@ -158,7 +155,6 @@ SCTP_ARG_CONSTRUCTOR(CHUNK, struct sctp_chunk *, chun=
k)
>  SCTP_ARG_CONSTRUCTOR(ASOC,     struct sctp_association *, asoc)
>  SCTP_ARG_CONSTRUCTOR(TRANSPORT,        struct sctp_transport *, transpor=
t)
>  SCTP_ARG_CONSTRUCTOR(BA,       struct sctp_bind_addr *, bp)
> -SCTP_ARG_CONSTRUCTOR(PEER_INIT,        struct sctp_init_chunk *, init)
>  SCTP_ARG_CONSTRUCTOR(ULPEVENT,  struct sctp_ulpevent *, ulpevent)
>  SCTP_ARG_CONSTRUCTOR(PACKET,   struct sctp_packet *, packet)
>  SCTP_ARG_CONSTRUCTOR(SACKH,    struct sctp_sackhdr *, sackh)
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 35f540fb15fc..a95bf10b852b 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -698,32 +698,6 @@ static void sctp_cmd_assoc_failed(struct sctp_cmd_se=
q *commands,
>         sctp_add_cmd_sf(commands, SCTP_CMD_DELETE_TCB, SCTP_NULL());
>  }
>
> -/* Process an init chunk (may be real INIT/INIT-ACK or an embedded INIT
> - * inside the cookie.  In reality, this is only used for INIT-ACK proces=
sing
> - * since all other cases use "temporary" associations and can do all
> - * their work in statefuns directly.
> - */
> -static int sctp_cmd_process_init(struct sctp_cmd_seq *commands,
> -                                struct sctp_association *asoc,
> -                                struct sctp_chunk *chunk,
> -                                struct sctp_init_chunk *peer_init,
> -                                gfp_t gfp)
> -{
> -       int error;
> -
> -       /* We only process the init as a sideeffect in a single
> -        * case.   This is when we process the INIT-ACK.   If we
> -        * fail during INIT processing (due to malloc problems),
> -        * just return the error and stop processing the stack.
> -        */
> -       if (!sctp_process_init(asoc, chunk, sctp_source(chunk), peer_init=
, gfp))
> -               error =3D -ENOMEM;
> -       else
> -               error =3D 0;
> -
> -       return error;
> -}
> -
>  /* Helper function to break out starting up of heartbeat timers.  */
>  static void sctp_cmd_hb_timers_start(struct sctp_cmd_seq *cmds,
>                                      struct sctp_association *asoc)
> @@ -1397,16 +1371,6 @@ static int sctp_cmd_interpreter(enum sctp_event_ty=
pe event_type,
>                                         SCTP_CHUNK(new_obj));
>                         break;
>
> -               case SCTP_CMD_PEER_INIT:
> -                       /* Process a unified INIT from the peer.
> -                        * Note: Only used during INIT-ACK processing.  I=
f
> -                        * there is an error just return to the outter
> -                        * layer which will bail.
> -                        */
> -                       error =3D sctp_cmd_process_init(commands, asoc, c=
hunk,
> -                                                     cmd->obj.init, gfp)=
;
> -                       break;
> -
>                 case SCTP_CMD_GEN_COOKIE_ECHO:
>                         /* Generate a COOKIE ECHO chunk.  */
>                         new_obj =3D sctp_make_cookie_echo(asoc, chunk);
> @@ -1772,10 +1736,6 @@ static int sctp_cmd_interpreter(enum sctp_event_ty=
pe event_type,
>                         sctp_cmd_peer_no_auth(commands, asoc);
>                         break;
>
> -               case SCTP_CMD_ASSOC_SHKEY:
> -                       error =3D sctp_auth_asoc_init_active_key(asoc,
> -                                               GFP_ATOMIC);
> -                       break;
>                 case SCTP_CMD_UPDATE_INITTAG:
>                         asoc->peer.i.init_tag =3D cmd->obj.u32;
>                         break;
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 6a4205de0aa6..fd9f94c12d42 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -603,13 +603,22 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct ne=
t *net,
>
>         initchunk =3D (struct sctp_init_chunk *)chunk->chunk_hdr;
>
> -       sctp_add_cmd_sf(commands, SCTP_CMD_PEER_INIT,
> -                       SCTP_PEER_INIT(initchunk));
> +       if (!sctp_process_init((struct sctp_association *)asoc, chunk,
> +                              sctp_source(chunk), initchunk, GFP_ATOMIC)=
) {
> +               sctp_add_cmd_sf(commands, SCTP_CMD_INIT_FAILED,
> +                               SCTP_PERR(SCTP_ERROR_NO_RESOURCE));
> +               return SCTP_DISPOSITION_CONSUME;
> +       }
>
>         /* SCTP-AUTH: generate the association shared keys so that
>          * we can potentially sign the COOKIE-ECHO.
>          */
> -       sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_SHKEY, SCTP_NULL());
> +       if (sctp_auth_asoc_init_active_key((struct sctp_association *)aso=
c,
> +                                          GFP_ATOMIC)) {
> +               sctp_add_cmd_sf(commands, SCTP_CMD_INIT_FAILED,
> +                               SCTP_PERR(SCTP_ERROR_NO_RESOURCE));
> +               return SCTP_DISPOSITION_CONSUME;
> +       }
Please change the error process to:

                if (err_chunk)
                        sctp_chunk_free(err_chunk);
                return sctp_stop_t1_and_abort(net, commands,
                                              SCTP_ERROR_NO_RESOURCE, ENOME=
M,
                                              asoc, chunk->transport);

in the two places above as Clashiko [1] suggested.

You may also want to confirm and address the issue reported in
sctp_assoc_update()
in a separate patch.

Thanks.
>
>         /* Reset init error count upon receipt of INIT-ACK.  */
>         sctp_add_cmd_sf(commands, SCTP_CMD_INIT_COUNTER_RESET, SCTP_NULL(=
));
> --
> 2.43.0
>

[1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/179539544818.301604=
4.18009252996572506068%40gmail.com
