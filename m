Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3787399892
	for <linux-sctp@vger.kernel.org>; Sat,  1 Aug 2026 01:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785549412; cv=pass; b=u/6ZerBlnHaHnAf2v6wfgmV3c5ugBz3MHG6I7vS4kNEpqRjdiUciQfV8+vaBBNRW7i0hBZzEmeT3Da/72lqPCMnTD/7PnhGByP53HoZHoWeSK2+VeK1H1uSSeJlmNWr79R49jeukk6H//xvREiG4M0sZNpvAUMf+x6xY41ABiOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785549412; c=relaxed/simple;
	bh=Cuy+ATXD/7LsKqNwVBhmSbzluquUF9Jy5UJIsCf5RmQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=INidRSkEGHG/ayTAzIDLlpiWZ5xUhx/Mj/PdecpVceVZ1H/UuZYyTs6KUGkO8UVt54zbVVuMExO9FK/tXTzXVLT/FszU4Fqm3Z7mhQJrWECmVGTgMh8+A0dzb8k/+nvQSv9XWHDmg6nX78GaRT9qxKk/2gFxadYcSkn1VQ3jOak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kxog0e9K; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kxog0e9K"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8485b358552so1849882b3a.2
        for <linux-sctp@vger.kernel.org>; Fri, 31 Jul 2026 18:56:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785549410; cv=none;
        d=google.com; s=arc-20260327;
        b=L2W+WL82orGdv+E5ZmVtSGvozQEdWXaWIBMw4nf0YZXtQ/Q0Zdf+ersZE59X4gWLBn
         f1OP3S60+1KymuAXQP9SH6TjTE4U+U8FGkQKcqn4mxeS9RvPDzIOJ8GxMnJbw9gbXsbn
         iz61cZ+7zpUKXOg2HItJNL1ZTIRUJrU9udOg5lVfYyx7Q7iVtv/a0Oo0TDfcDzqhV+x6
         3rVxNPcqG3G5599YXhbqixOjfdIlEWn+/ay0htRgzpkSCdnGiZd5yssM94C6w7MziSbg
         i3Rg649N6jdu+iiD5GLxGiNuoReUXpZxgP6Y6QRJ2v/z36zrNG424nZOyWPCEmY4UNZU
         ns2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XDk1j5u96BEbQkY+NvqlgkFtQLDQ28w5D6GMuTe7Mko=;
        fh=drTcfxqoCtPBoy3tVuZVK2tzK89KAhencvdLLKs/ZFs=;
        b=NLjPVMwVCZq4C3GaocFhcDn7Rm/y4JihaHoSPRp37roTs+UvGKVYMqU/6yUaB5hh+O
         W3qVC++fSYagYVsWgS70SO3bjEB13Z11FmQ1l688MJ4Hwl4Lafecyd9Ha/jgEStLxiF4
         w3BKTXYNy9s+bjNNIFr9so/cE1ljbRPtxJ7YVNru2sQiEollOJ/15q+4T4RKejIbjFDw
         40tLOilZ8iLsaZt7pTbfFMlwMPZyoEPJrhJddjF/3/l1HbIbWDfsR2znla4wqbZR/uCW
         eBgMj30fIYq5skF/3nLEvNT1ouqUHYQH3VrSgYnRlTiBeadSyJUyoDjmQsW6Wpn7Ubio
         v0cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785549410; x=1786154210; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XDk1j5u96BEbQkY+NvqlgkFtQLDQ28w5D6GMuTe7Mko=;
        b=Kxog0e9KWHPKTo8vXsisr1iIfqCjxzdlPPgYOqLMhBqNkS/hCo7o0LzP1CEZpWvRYn
         jvnToSC7TUayhvGtMqNmF8p8LbANIpJZ5qaVC2yoZx70njJ8MkQnNLmwsbsCFx0CMgsu
         FqHqQXlpHucjUMLkiB0GHU611Df0zG/TMrY3KRfbGTxlXUWmA2mKy/IbYJMDzXMnc57F
         znne7URXuML+9rO4U1IsoNrgJgLYCjF+jUFZsyklvR5iGbMmin/ZdJ3ItN/C3pRcB5dT
         NSuxrhY3PhHlqyZm8x0XNl7zCZj2WnMSlYirUl9lx3zx8HY5kLfxxZrQ8SRvKiHKtjyu
         NIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785549410; x=1786154210;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XDk1j5u96BEbQkY+NvqlgkFtQLDQ28w5D6GMuTe7Mko=;
        b=rJPVaomurn4jle4CfAaEsO5uzNLxzCC5Z2cxCDhVXtk83fGCxa8ahtt5dLZj1n5JNR
         TdXOmIWPGKfO77LxuGK7z8jghDiLjSPzetXzdZjUP2dcrX7u7Iqf9ZZ+fO+mZMLxY9Pd
         eupXo+/MXTJvd5zp4K52tftC/DJbI6Mo5e8OFSOGBCjyLN/f2ETupd4I+5szjglHk7bV
         kDs+okTlw1f4X320MqVsegWryQxFHgCI4YbLqvEKyx90bhVZdOue72Cj18rBhobz8FYP
         7Z1hk2BD0DMe/92zFLA9WlVKHNvlGtx3OKDkBKhutFeIRcQgbuT3W3+BOZBZDnr5xn+z
         BOag==
X-Forwarded-Encrypted: i=1; AHgh+RoxzVX0nmsOSrS7XjQSDVURYU+lA90lhzaw37WFQ5ol9lOw5Z0T1W8pkmwB7ANUPVwnt4mhWrOZVdhE@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs2/rbScVZvlADYqzZzEm4X0iBrFbwns9eMOw5L0k2Yedru3bQ
	uaTnYhx792wS01XZ6FOtj1RRQ2p82sMYcp0RYCIaH6bRmc3bL41mlwCyizCC7oqdgUvGa7xhu51
	4Hjoazp4HI90BQ814zSdjjkeNAxzcYqc=
X-Gm-Gg: AR+sD12BK6iI5I5nkMa2mKT1/nO0dz5v9qTwvgQTpkzPM9MjXR24wdqAx2j9pIxRTBn
	EK8w44lbu6Lj+Qy6doIbtwdKY4xGlycZK4x+72x1nZcsOuRkRNOt/P5yPxHF0D02sTweMNPW+hV
	vpLD5qCH+rReE4R9eeaGopKnxwiojSHmkl6drZdfWXg/BHceJTm1vR+hh0BT7TrrltQZBgcv971
	4VCJJtrhR/tndZwhmklvYq2NdeIwuGZw4ZFlecnrNnKdrvGW42dlxhQjg1lZJ87UkwE4FJVYXQF
	zOEW8ZoOazP4cUFHEVF/lXJ1MvLMzAdWcs/GV1iqjI7CmPB+P69TUDkuWiMAF1V7K6ziE5HWTTL
	nrtbr67qORh6iSq4WKMdjPyrTCSCo1+InZZ9x63igLQTZxe4d/NnKeb4=
X-Received: by 2002:a05:6a00:9296:b0:848:2c6c:dfe3 with SMTP id
 d2e1a72fcca58-84ee47e6a57mr1561877b3a.17.1785549410080; Fri, 31 Jul 2026
 18:56:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730090537.27629-1-juny24602@gmail.com>
In-Reply-To: <20260730090537.27629-1-juny24602@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 31 Jul 2026 21:56:38 -0400
X-Gm-Features: AUfX_mz8_lhPM3hKRVtFzdmE3NAwfT-wPZABXbnOKXlRfkDZPzedSphHheHJx8g
Message-ID: <CADvbK_cucNJp9pDs94o4BDAH4hi-Jtpk_k5i-thSW4XhVZQgFQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: re-point retained control chunks on association migration
To: Jun Yang <juny24602@gmail.com>
Cc: netdev@vger.kernel.org, Jun Yang <junvyyang@tencent.com>, stable@kernel.org, 
	TencentOS Corvus AI <corvus@tencent.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 5:05=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrot=
e:
>
> From: Jun Yang <junvyyang@tencent.com>
>
> sctp_control_set_owner_w() records the owning socket in a control chunk's
> skb->sk as a bare pointer.  sctp_sock_migrate() re-owns the association's
> DATA chunks via sctp_for_each_tx_datachunk(), but that walk keys off
> chunk->msg and so skips control chunks: any control chunk the association
> still holds (for example the saved stream-reset request
> asoc->strreset_chunk, the ASCONF request/ack lists, or
> asoc->addip_last_asconf) keeps pointing at the old socket after the
> association is moved to the new one.
>
> Once the old socket is freed, a later retransmit reaches
> sctp_packet_transmit() -> skb_set_owner_w(head, chunk->skb->sk) and
> operates on the freed socket -- refcount_add() on its sk_wmem_alloc,
> then sk->sk_write_space() from sock_wfree() -- a use-after-free of
> struct sock.
>
> Re-point every control chunk the association still holds at the new
> socket right after sctp_assoc_migrate(), as is already done for DATA
> chunks.  Control chunks carry no socket wmem charge and their skb
> destructor does not use skb->sk, so a bare owner update is sufficient.
>
> Fixes: d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues =
when migrating a sock")
> Cc: stable@kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> ---
>  net/sctp/socket.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index c7b9e325ec1c..9a6da4e0d741 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9522,6 +9522,30 @@ static void sctp_skb_set_owner_r_frag(struct sk_bu=
ff *skb, struct sock *sk)
>         sctp_skb_set_owner_r(skb, sk);
>  }
>
> +/* Control chunks record their owning socket in skb->sk as a bare pointe=
r and
> + * are not reached by sctp_for_each_tx_datachunk(); re-point the ones th=
e
> + * association still holds so migration does not leave them on the old s=
ocket.
> + */
> +static void sctp_ctrl_set_owner_w(struct sctp_chunk *chunk, struct sock =
*sk)
> +{
> +       if (chunk && chunk->skb)
> +               chunk->skb->sk =3D sk;
> +}
> +
> +static void sctp_for_each_tx_ctrlchunk(struct sctp_association *assoc, s=
truct sock *sk)
> +{
> +       struct sctp_chunk *chunk;
> +
> +       list_for_each_entry(chunk, &assoc->outqueue.control_chunk_list, l=
ist)
> +               sctp_ctrl_set_owner_w(chunk, sk);
> +       list_for_each_entry(chunk, &assoc->asconf_ack_list, transmitted_l=
ist)
> +               sctp_ctrl_set_owner_w(chunk, sk);
> +       list_for_each_entry(chunk, &assoc->addip_chunk_list, list)
> +               sctp_ctrl_set_owner_w(chunk, sk);
> +       sctp_ctrl_set_owner_w(assoc->strreset_chunk, sk);
> +       sctp_ctrl_set_owner_w(assoc->addip_last_asconf, sk);
> +}
> +
>  /* Populate the fields of the newsk from the oldsk and migrate the assoc
>   * and its messages to the newsk.
>   */
> @@ -9633,6 +9657,7 @@ static int sctp_sock_migrate(struct sock *oldsk, st=
ruct sock *newsk,
>         sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
>         sctp_assoc_migrate(assoc, newsk);
>         sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
> +       sctp_for_each_tx_ctrlchunk(assoc, newsk);
>
>         /* If the association on the newsk is already closed before accep=
t()
>          * is called, set RCV_SHUTDOWN flag.
> --
> 2.55.0
>

Can you rename sctp_for_each_tx_datachunk() to sctp_for_each_tx_chunk() and
move the control chunk traversal there?

        list_for_each_entry(chunk, &q->control_chunk_list, list)
                cb(chunk);

        list_for_each_entry(chunk, &asoc->asconf_ack_list, transmitted_list=
)
                cb(chunk);

        list_for_each_entry(chunk, &asoc->addip_chunk_list, list)
                cb(chunk);

        if (asoc->strreset_chunk)
                cb(asoc->strreset_chunk);

        if (asoc->addip_last_asconf)
                cb(asoc->addip_last_asconf);

The in-progress patch:

https://lore.kernel.org/netdev/20260731120558.558957-1-david.lee@trailofbit=
s.com/

will use sctp_set_owner_w_migrate() as the callback for
sctp_for_each_tx_datachunk(). Based on that, you can simply handle control
chunks (msg is NULL) in sctp_set_owner_w_migrate():

        if (chunk->msg)
                sctp_set_owner_w(chunk);
        else
                sctp_control_set_owner_w(chunk);

This avoids introducing additional helpers such as
sctp_for_each_tx_ctrlchunk() and sctp_ctrl_set_owner_w().

Thanks.
