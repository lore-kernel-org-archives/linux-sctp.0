Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCF62FF675
	for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 20:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787517539; cv=pass; b=imXWqgbPKKtVyN1S/qD6040NbqO90wDOYrBBB+afyILxiAcmomSv7oTUpBErMTh3jcxGqnMsHzuR/Nz7IiOpUmA9JsZuBScWuj4LUA3uWysXRHqbcuPITBnhz6rzXRfbfmikerEUxbTBHtQ2CARMqhoVixocz7uvGJztnEvbQZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787517539; c=relaxed/simple;
	bh=DJJNdYFcgwSR7W4tBu+xudB5yEN+f2wuQhprkjKzETA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t1GVtfzlKicNm9MA17N2Q5qIWanjhbyzHa1DKL+Owd9vOZYHNXzMtqwWujVtUK91Vy+2yhZ5SiGDHGC6CxpBhAil/Ivl6tqOtjF3vtKZf8Fty0aLDexkTbatsG50sn5SF4P9CRawXf2lD8CaNerlQG3Z9+Zi2bPmk/5Kiyg2EF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mG6Tugno; arc=pass smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mG6Tugno"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84874b52eabso3684428b3a.0
        for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 13:38:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787517537; cv=none;
        d=google.com; s=arc-20260327;
        b=WrgtFKcrnWP3byoSzIrFG0B4eVXo2OooiSFfqkWVuSJMWlY9KOyDZnX6HAPUCtdiu/
         tgP4UOHSlrwEG07RcbYRqc5HVwePelrAw092oJCnaK1EnG+neJaIlmjJlJiZcQHDGxsV
         NnNh0wcEZY4wLrXj4oJoXHKabJ7SaSDs/Zeii0eb7OWQizj9enwLJcpIRJp0GNTL+Sk5
         1GO/lPE/dJfOGbhp5rx/Ck3xPZjq+Aq3x65iPul6R1ksGWUDKtnqXW97zuMZseB1iVhi
         OuUDKq33920DWlgJnqzQlvUB7MEwr3xqMeQ1mGxnW6Cla5q7iKt/iFdWiPo4Wz4hTdV2
         b35w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1HwZJJPTJ////Jd0Y6Z4z0mnZu6T/72VRo14Pnnjwlg=;
        fh=ZI21xfqYBluBTh9iC8tYxQOI+OKL52CtmhVaHh0hd6g=;
        b=BoEebNk5TpyFcCbgSol+XP4R9MuK6bPWwoKdRhummoCF94bI8k0xiTRJ8p28gF9nGG
         uYCT+Qpt0Feqd5oIK6suL3ZUsJSnNjwLpuWR17Kq7C8CVkCSdSVuhYxEYEL6OkDfUbvW
         mrUG+ZzcCEE0tOzMWFUNDaFvLWcXgbOT1eQtGxv9kiGgPbbOiw5fLeM07R+VrwqWJWhh
         TvZX1TnL9250Hht1JnwCuSkeG3bNh0B26ysaB/bBoNjWya+zxMN/3bXuSUHFZCZY91X9
         7d62+6AW2gdr/hh8ly/U/yLQQsvpwbtsGmZE9YsEzCaawW//QLkut1PEvhntHJVz8Him
         sHxg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787517537; x=1788122337; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1HwZJJPTJ////Jd0Y6Z4z0mnZu6T/72VRo14Pnnjwlg=;
        b=mG6TugnoWf6Il5s4UIwmxXGRRYbhN72tqX7aQjJXpS3I0Fm0LqkJHxZcUTDpoLmWCv
         q2z/QclVS3FqetN5FOUkpBRXjFaeeQrL9yOkzJBiOwzaTB4z8VoID5eMBAaW4Jg7Ty53
         jRZgJIk7W6ivh7cTD7sNzZatkU0x0zxgdsu6t5v+lyjGcAMEJdmbZ/kLgDfbjlF3w2Mj
         1j4BpytEnuJzlkCvzYE/BOOXElIXaaqUaW/Zt0KSWo2zmpzVorpTFIlQFgT43xWDCmQG
         7QbGBtRq0+IF1deE8jkhVVD8rxIK/MO9UozycUUa9aByc7sDEdbIMbpxbgFJ4mXzXJsc
         v6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787517537; x=1788122337;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1HwZJJPTJ////Jd0Y6Z4z0mnZu6T/72VRo14Pnnjwlg=;
        b=C+kUUHcOia9luKJ0aPbKi06GkDUYjaEaSDgNnkUGlIXQEDHWDtoCnkb+0quI5I9oXB
         NFJMATcXRG3/8ykCMbjcQXthOONes8NUJlaEyhXbpGDnHbWo84rLbkCfUjolrFzWD8gJ
         q6OYgnfYDDPRiKvBWvTKhxIsZV77kJqL9+ip2U4BJ8Z4FZMpipZMUd24nY1Nb7yZpHr9
         yJUoGNnuhMhnj7izyAQFRwtAK5VGXx/oNIC5tnUam6DmiX59ALG7utKj1xuuCaYOZ4pM
         o/zrkj80i9dCqa8yCZG/MLndCp1EEdpBW/Ej1oj4IzybjjUbM1Y7b+82dwmPkyx9jtQg
         DlvQ==
X-Gm-Message-State: AFuF++kluxFdlu3u80OoRhhX2HpuAM1omAFklJ0Li44y9sshEBK4B/EG
	kU7bqv+vCBKnvKRvNvrNXK8GdeHfxsoTvyBXkRmbocl/Bc/ESHRDW2AWI5i66q8LNYZoHbhOrlD
	/0cgk9o2zQit7UrautfxF7cZgFiGrYA0=
X-Gm-Gg: AR+sD1140YpqF4bU2+xiILz3m6zaLL8DjuoSzdVb6w1E+pjYNknYXyByp2mFEwzUap/
	Bow9zXoe52GXKAirVe1S4kmQ7i6QnB4u+nTIGAd6pjmu71QVmj2/7l3syL6Tr1NOWch90J9ic6S
	yaAw0TeYpaj8Yu+ANiIRAiSpNBej2suMmdqAMQyfIWeZQtZfzY9Q8OLH/xUjvGeId1Gar2G0bB0
	7OfJcEW5PZBHBhVSQffdydCmNxPLawyoladHPXXTPXfUIbaReHcRN9rDGRGIWcLdCOVY+dTElSm
	FspvvuQk4jNZmS0AHx3Qg1uFBbeoEorT16DaodXX2J6aI6/0MLTnhyqezWaM8JBuzXdqeoVZbwM
	pxSkSXT4/IrVBxd13No8y6H6UN6cfjv3EsnfLFl7T6Io=
X-Received: by 2002:a05:6a00:849:b0:848:467d:293b with SMTP id
 d2e1a72fcca58-851f9fad812mr34125434b3a.11.1787517536858; Sun, 23 Aug 2026
 13:38:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821091440.6496-1-junvyyang@tencent.com> <20260821091440.6496-2-junvyyang@tencent.com>
In-Reply-To: <20260821091440.6496-2-junvyyang@tencent.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 23 Aug 2026 16:38:45 -0400
X-Gm-Features: AcwNN1Vtdpiyi-mad4Kq_Ow6hY5unHMhUT1IH4gML7cm2btc5kpkQuUlRebDKCc
Message-ID: <CADvbK_dAyck-AsK-b1JYcbUXdhr7FR4ndQiYfNYkCxsu0F5tEg@mail.gmail.com>
Subject: Re: [PATCH net v3 1/2] sctp: distinguish sequence zero from wildcard
 in reconf lookup
To: Jun Yang <juny24602@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	Jun Yang <junvyyang@tencent.com>, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 5:14=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrot=
e:
>
> Zero is a valid response sequence after strreset_outseq wraps, but
> sctp_chunk_lookup_strreset_param() currently treats it as a wildcard.
>
> Add match_seq so response lookups match zero exactly while the one
> type-only lookup can still ignore the sequence.
>
> Fixes: 50a41591f110 ("sctp: implement receiver-side procedures for the Ad=
d Outgoing Streams Request Parameter")
> Cc: stable@kernel.org
> Suggested-by: Simon Horman <horms@kernel.org>
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> ---
>  net/sctp/stream.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 34ffe6c..cfca5aa 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -482,7 +482,7 @@ out:
>
>  static struct sctp_paramhdr *sctp_chunk_lookup_strreset_param(
>                         struct sctp_association *asoc, __be32 resp_seq,
> -                       __be16 type)
> +                       __be16 type, bool match_seq)
>  {
>         struct sctp_chunk *chunk =3D asoc->strreset_chunk;
>         struct sctp_reconf_chunk *hdr;
> @@ -499,7 +499,7 @@ static struct sctp_paramhdr *sctp_chunk_lookup_strres=
et_param(
>                  */
>                 struct sctp_strreset_tsnreq *req =3D param.v;
>
> -               if ((!resp_seq || req->request_seq =3D=3D resp_seq) &&
> +               if ((!match_seq || req->request_seq =3D=3D resp_seq) &&
>                     (!type || type =3D=3D req->param_hdr.type))
>                         return param.v;
>         }
> @@ -564,7 +564,7 @@ struct sctp_chunk *sctp_process_strreset_outreq(
>         if (asoc->strreset_chunk) {
>                 if (!sctp_chunk_lookup_strreset_param(
>                                 asoc, outreq->response_seq,
> -                               SCTP_PARAM_RESET_IN_REQUEST)) {
> +                               SCTP_PARAM_RESET_IN_REQUEST, true)) {
>                         /* same process with outstanding isn't 0 */
>                         result =3D SCTP_STRRESET_ERR_IN_PROGRESS;
>                         goto out;
> @@ -816,7 +816,7 @@ struct sctp_chunk *sctp_process_strreset_addstrm_out(
>
>         if (asoc->strreset_chunk) {
>                 if (!sctp_chunk_lookup_strreset_param(
> -                       asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS)) {
> +                       asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS, false))=
 {
>                         /* same process with outstanding isn't 0 */
>                         result =3D SCTP_STRRESET_ERR_IN_PROGRESS;
>                         goto out;
> @@ -927,7 +927,8 @@ struct sctp_chunk *sctp_process_strreset_resp(
>         struct sctp_paramhdr *req;
>         __u32 result;
>
> -       req =3D sctp_chunk_lookup_strreset_param(asoc, resp->response_seq=
, 0);
> +       req =3D sctp_chunk_lookup_strreset_param(asoc, resp->response_seq=
, 0,
> +                                              true);
>         if (!req)
>                 return NULL;
>
> --
> 2.55.0
>

Acked-by: Xin Long <lucien.xin@gmail.com>

The issue reported by Sashiko [1] is mainly a changelog improvement.
It=E2=80=99s not a big deal to me.

[1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260821091440.6496=
-1-junvyyang%40tencent.com
