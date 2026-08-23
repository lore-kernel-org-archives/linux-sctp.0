Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B042BDC1C
	for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 20:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787518072; cv=pass; b=XVQwpna9RRoc87Nglo+5oett/h30hnoFPGxv4Sprobljlli+F2cAp4zl+WIMBtZQAYYKh5cDGEUD3FkMPX6/kKw2SwpCjBnYMHrA1ytwGcv5kNPX3rezmVz3Avo8MI41gO1mfCwZbwKyThKQJF/DBav5D8gX4fpaBTa7f7xMbCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787518072; c=relaxed/simple;
	bh=EdSkScQPivDj05j/2sLx7CQW8EZz3IaYzt7gqPhjb2Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d3ArOLyqlvLnvLI89CLlaqVeGNnuRysqO8zzEeL+0mttZRWevFhl+HipmLS1UhTpGGuY4mfIh8/zIg4tv0Wd2ZB0AbTIav0sXRF5s41EqYB5mO3KOHNEQHcwg3dTjhnXrgCRFoRkwf10ArY73aqXXna7z+OHsVsW/W5hN5mbqV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SKqnsg8M; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SKqnsg8M"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso2291386b3a.1
        for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 13:47:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787518069; cv=none;
        d=google.com; s=arc-20260327;
        b=lsVkMKr/+CRtiZDSz3VJ4dKjoPAV9Efo94OCX3tZihaRrs2Td55IRlM7dS56DrO9Ac
         aKSuKh/xVLuQ6IXMvJ8ihLlKCWrLPKOBMyAJTzsAML91NZ+NSvB7Dq3KQoA+BTyqQ4GH
         bghbhkY9bqjOmoEPoJbXMWRnHpQVxGZu0ylQ2bL47a7Fz9C7rEPiO0Kf3lDWkIfZ5sHF
         5jz4KE4VHkoBXEwCVrLCfuh3NS7HbEPuB3qpsmAI0iYstxEJWNBQ0I6LJcN1UqKR2AtN
         TMysqq7HizY2MGHh+7ZIJn1FdH4uPNJbQuuvjhhnjqJx8sPEQvt8hEflzKLACqy5NaJJ
         FyEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NaOd5F/ipfNJOZxCZ2AViEp5mUXDbyZwZgqkyHb5ep4=;
        fh=qdlv5ryuAFtw/c7dfh454L9XjjX2RrHy7EJRLROfOjA=;
        b=q8gjQ/pwp9uPD3NigegeysToVhdiuIxR2073pUqKzmvB82vVWx++VB9/ln/9fQJ7P5
         ay2EJsRo2gaATUVUGW9njP/eVZb9H5PjJrY31IGa6rIfphsf6dtfSjpgOYLAGD8AZ2Ku
         /mtrb1wZ3KaQ6Oey7ORPP4yG8VjJ+Rw8be3hX4Y0ED64buw9n4c3a1q4BMb709MKjPHo
         LNqeWZh43B0J4ofePAC9pS+Mr+nGF9bWfw9a0JV205EUiBwU/XGRcrQfGdWKg5wQ43UK
         HfsI1HASVBtAVo39lFQpS6UHjQLu3EAfh1ebHCdWmDLFoxhOYpCtbAytjvp+fv6YIHR4
         dNTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787518069; x=1788122869; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NaOd5F/ipfNJOZxCZ2AViEp5mUXDbyZwZgqkyHb5ep4=;
        b=SKqnsg8MrtfPrFjTPh1gKDno1moC592JeZ8/MtwK2l0NoowC209DRvWbaVGatvUCnh
         L/sjYkw8DG36clN1B5t4eOUTZyu1sVF7e58RLrkPXkyx2xYfDwsU1FSLaZPsMG+I+n26
         tiR/6RsONpyIaWWE0ZWbUKm+I4wuf8JXP7rMA/f56ish76m/OpNozinw6vz7qtNHjfj3
         2rKqyFmPckpq6h9XX3qf9iOQ28J+OyphALz4SpLvjVAERdTnvUXC293z0BY1N7lZAU4D
         CKPlC8A8NNb+CImJ/+uUXTPCSaoc/ZS0OOPFh0iCnBqScsGsrYketbJZZObkjt8mXbbb
         grrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787518069; x=1788122869;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NaOd5F/ipfNJOZxCZ2AViEp5mUXDbyZwZgqkyHb5ep4=;
        b=H1oiexf/FXJ7Cc6v7b5N+edj17rvN4E2SRGbr3FsofNrjsQKQrIz2zH24X+7v0d2zV
         vqw01MvIqwIt849uS9QT+tCxavZqPUhL82Ma9W4JubDft2cTL3kgJIVB2KmaBcKFVeUz
         XHqMnqHsv7nh3LPrct2CEVNFR6oix9Os16BQ81/+TSvkyUlxC/6kH36k6pkbaw4q4b/6
         OdD4htiRWgeh5RfD+Oitt/82CjN/esx93TWPCAeD1lbYiufpk4+PwCz11sW2NurNXOyP
         F+36m92GH1YMXHMIAu/8jLfruXldusKIym1H1jXe6dImU4QHn+gA0yFXdVV7xKZTH1od
         fbjQ==
X-Gm-Message-State: AFuF++n6SJ7DTwHN5n8+3/WC3txl+hQv1SQwRK9+N3+NICTD7T+u1lVo
	2QxHqyBASLfAMhO8euQFAwUYVs9XFeUqX0gKDCIKJrIYQwO4kAXsWcdz9JAGEdT/wjJjLWRlOv/
	i581r+IGHNZFYl2OeGj0pH3CU/kRkg7Y=
X-Gm-Gg: AR+sD11pW5hXia4H92cAzqqJS7kPHzJNjeyy8QIBQQMfFV8via/L9e537z310xVviGm
	+d2j0gGLq9nqscRzv5KQE7Tok1hJmm9hSsUCWWw71xuPb7m7RaUl8KrKaCaBkNz+iGxMtfj1XUR
	S5RJR7w58xo8oyJiI1jmQGC9YxhCX2OBEB5pIKh/QpWJ0a5hBFRyotdMqiwmVQrwZeeqL/BhRz7
	y1ZeF37eYTshT0yF6A8enncmoYuMBUUtqFVpVeOxprG13pxU2NCoyyA+KT2QgUEzPPkNGlDiccN
	jyj1Fje+283fxF4FKtu5KELrzalbAMvhJCpcpTKefA8TcBVmNqSGiPSD7prGFH8iSoyIT4mLbeJ
	YG5yqy6r/DtcJRbg3PTyGqpgLf4HNFCclIXU5u/oiJJw=
X-Received: by 2002:a05:6a00:12c6:b0:845:3033:6cbb with SMTP id
 d2e1a72fcca58-851dfa05cf7mr30925366b3a.11.1787518069023; Sun, 23 Aug 2026
 13:47:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821091440.6496-1-junvyyang@tencent.com> <20260821091440.6496-3-junvyyang@tencent.com>
In-Reply-To: <20260821091440.6496-3-junvyyang@tencent.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 23 Aug 2026 16:47:36 -0400
X-Gm-Features: AcwNN1UtODEX5ElhnYKDPtmKRWtoo8kix_cFHZ7Lkb49-rKEd-u3jvvIpcZYJTE
Message-ID: <CADvbK_dABUb_=VnO60AO=pj=jvjCG5dCBRj3wDAt7kM4=71_zQ@mail.gmail.com>
Subject: Re: [PATCH net v3 2/2] sctp: fix stream->outcnt underflow on
 duplicate RECONF responses
To: Jun Yang <juny24602@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	Jun Yang <junvyyang@tencent.com>, stable@kernel.org, 
	TencentOS Corvus AI <corvus@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 5:14=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrot=
e:
>
> A cached RECONF chunk may contain more than one request parameter.  A
> duplicate response can therefore find and process the same ADD_OUT reques=
t
> again while another parameter is still outstanding, rolling back outcnt
> twice and possibly underflowing it.
>
> Track outstanding request types as bits and clear each bit after its firs=
t
> response.  Later responses for the same request are then ignored.
>
> Fixes: 11ae76e67a17 ("sctp: implement receiver-side procedures for the Re=
conf Response Parameter")
> Cc: stable@kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Link: https://lore.kernel.org/netdev/20260730110225.37371-1-juny24602@gma=
il.com/
> Suggested-by: Xin Long <lucien.xin@gmail.com>
> Assisted-by: tencentos-corvus-ai:kimi-k3
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> ---
> v3:
>  - Split the response_seq =3D=3D 0 lookup fix into patch 1 (Simon Horman)=
.
>  - Keep the request bit helper local to stream.c.
>
> v2:
>  - Track outstanding requests by type instead of sequence (Xin Long).
>  - Drop the redundant arithmetic guard (Xin Long).
>
> v1: https://lore.kernel.org/netdev/20260730110225.37371-1-juny24602@gmail=
.com/
>
>  include/net/sctp/structs.h |  2 +-
>  net/sctp/stream.c          | 39 +++++++++++++++++++++++++++-----------
>  2 files changed, 29 insertions(+), 12 deletions(-)
>
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index cccc662..b21f23b 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -2057,7 +2057,7 @@ struct sctp_association {
>              force_delay:1;
>
>         __u8 strreset_enable;
> -       __u8 strreset_outstanding; /* request param count on the fly */
> +       __u8 strreset_outstanding; /* request param bitmask on the fly */
>
>         __u32 strreset_outseq; /* Update after receiving response */
>         __u32 strreset_inseq; /* Update after receiving request */
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index cfca5aa..e1a215d 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -22,6 +22,9 @@
>  #include <net/sctp/sm.h>
>  #include <net/sctp/stream_sched.h>
>
> +#define SCTP_STRRESET_BIT(type) \
> +       BIT(ntohs(type) - ntohs(SCTP_PARAM_RESET_OUT_REQUEST))
> +
Hi, Jun Yang,

Any reason for removing SCTP_STRRESET_RET/CLEAR/TEST()?
Each of these macros is used at least twice below, so removing
them increases the number of lines of code.

Note: The pre-existing issue reported in sashiko [1] is false positive,
as a peer can't answers an IN_REQUEST or ADD_IN_STREAMS with
SCTP_STRRESET_PERFORMED according to rfc6525.

[1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260821091440.6496=
-1-junvyyang%40tencent.com

Thanks.

>  static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 out=
cnt)
>  {
>         struct sctp_association *asoc;
> @@ -372,7 +375,9 @@ int sctp_send_reset_streams(struct sctp_association *=
asoc,
>                 goto out;
>         }
>
> -       asoc->strreset_outstanding =3D out + in;
> +       asoc->strreset_outstanding =3D
> +               (out ? SCTP_STRRESET_BIT(SCTP_PARAM_RESET_OUT_REQUEST) : =
0) |
> +               (in ? SCTP_STRRESET_BIT(SCTP_PARAM_RESET_IN_REQUEST) : 0)=
;
>
>  out:
>         return retval;
> @@ -417,7 +422,8 @@ int sctp_send_reset_assoc(struct sctp_association *as=
oc)
>                 return retval;
>         }
>
> -       asoc->strreset_outstanding =3D 1;
> +       asoc->strreset_outstanding =3D
> +               SCTP_STRRESET_BIT(SCTP_PARAM_RESET_TSN_REQUEST);
>
>         return 0;
>  }
> @@ -474,7 +480,9 @@ int sctp_send_add_streams(struct sctp_association *as=
oc,
>                 goto out;
>         }
>
> -       asoc->strreset_outstanding =3D !!out + !!in;
> +       asoc->strreset_outstanding =3D
> +               (out ? SCTP_STRRESET_BIT(SCTP_PARAM_RESET_ADD_OUT_STREAMS=
) : 0) |
> +               (in ? SCTP_STRRESET_BIT(SCTP_PARAM_RESET_ADD_IN_STREAMS) =
: 0);
>
>  out:
>         return retval;
> @@ -564,13 +572,16 @@ struct sctp_chunk *sctp_process_strreset_outreq(
>         if (asoc->strreset_chunk) {
>                 if (!sctp_chunk_lookup_strreset_param(
>                                 asoc, outreq->response_seq,
> -                               SCTP_PARAM_RESET_IN_REQUEST, true)) {
> +                               SCTP_PARAM_RESET_IN_REQUEST, true) ||
> +                   !(asoc->strreset_outstanding &
> +                     SCTP_STRRESET_BIT(SCTP_PARAM_RESET_IN_REQUEST))) {
>                         /* same process with outstanding isn't 0 */
>                         result =3D SCTP_STRRESET_ERR_IN_PROGRESS;
>                         goto out;
>                 }
>
> -               asoc->strreset_outstanding--;
> +               asoc->strreset_outstanding &=3D
> +                       ~SCTP_STRRESET_BIT(SCTP_PARAM_RESET_IN_REQUEST);
>                 asoc->strreset_outseq++;
>
>                 if (!asoc->strreset_outstanding) {
> @@ -669,7 +680,8 @@ struct sctp_chunk *sctp_process_strreset_inreq(
>                         SCTP_SO(stream, i)->state =3D SCTP_STREAM_CLOSED;
>
>         asoc->strreset_chunk =3D chunk;
> -       asoc->strreset_outstanding =3D 1;
> +       asoc->strreset_outstanding =3D
> +               SCTP_STRRESET_BIT(SCTP_PARAM_RESET_OUT_REQUEST);
>         sctp_chunk_hold(asoc->strreset_chunk);
>
>         result =3D SCTP_STRRESET_PERFORMED;
> @@ -816,13 +828,16 @@ struct sctp_chunk *sctp_process_strreset_addstrm_ou=
t(
>
>         if (asoc->strreset_chunk) {
>                 if (!sctp_chunk_lookup_strreset_param(
> -                       asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS, false))=
 {
> +                       asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS, false) =
||
> +                   !(asoc->strreset_outstanding &
> +                     SCTP_STRRESET_BIT(SCTP_PARAM_RESET_ADD_IN_STREAMS))=
) {
>                         /* same process with outstanding isn't 0 */
>                         result =3D SCTP_STRRESET_ERR_IN_PROGRESS;
>                         goto out;
>                 }
>
> -               asoc->strreset_outstanding--;
> +               asoc->strreset_outstanding &=3D
> +                       ~SCTP_STRRESET_BIT(SCTP_PARAM_RESET_ADD_IN_STREAM=
S);
>                 asoc->strreset_outseq++;
>
>                 if (!asoc->strreset_outstanding) {
> @@ -899,7 +914,8 @@ struct sctp_chunk *sctp_process_strreset_addstrm_in(
>                 goto out;
>
>         asoc->strreset_chunk =3D chunk;
> -       asoc->strreset_outstanding =3D 1;
> +       asoc->strreset_outstanding =3D
> +               SCTP_STRRESET_BIT(SCTP_PARAM_RESET_ADD_OUT_STREAMS);
>         sctp_chunk_hold(asoc->strreset_chunk);
>
>         stream->outcnt =3D outcnt;
> @@ -929,7 +945,8 @@ struct sctp_chunk *sctp_process_strreset_resp(
>
>         req =3D sctp_chunk_lookup_strreset_param(asoc, resp->response_seq=
, 0,
>                                                true);
> -       if (!req)
> +       if (!req || !(asoc->strreset_outstanding &
> +                     SCTP_STRRESET_BIT(req->type)))
>                 return NULL;
>
>         result =3D ntohl(resp->result);
> @@ -1079,7 +1096,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
>                         nums, 0, GFP_ATOMIC);
>         }
>
> -       asoc->strreset_outstanding--;
> +       asoc->strreset_outstanding &=3D ~SCTP_STRRESET_BIT(req->type);
>         asoc->strreset_outseq++;
>
>         /* remove everything for this reconf request */
> --
> 2.55.0
>
