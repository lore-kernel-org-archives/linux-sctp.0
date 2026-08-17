Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BA13EAC75
	for <linux-sctp@vger.kernel.org>; Mon, 17 Aug 2026 20:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787000392; cv=pass; b=aXNm8LdodKdTUX7YnHqvdC8u6t4ftOAuoLXnpW2QgLhxNBO/c3I9QWhbfaI/DRwwAl00x9gGFiP7nPDKkbC26k5LxeYoxYNB+m9bEVyEJDJPJCzKKdNW8jZK0aJNXqjHfLg9HAiMOc7EPJo75SjSNcotZ1e/fyVo9Wkh7yHTN08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787000392; c=relaxed/simple;
	bh=GGsPWRK9FRWecXnz96hzeq1dlR1HRflM9Zj+Rwf39JU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rInukKbWHLqx7or77lAHTr+mv9xY3599wqkNtRpl7aRI2cpIJ8zxcbpYad7nj1MzOfcTq2KwKz6HEiICeDbNK990yTcO80lSNPToi3qQqFRID2OlAWBxqEaw9bxHTthFUVD8OVkNq9eOmRyaySJyLiKNYyw+q9o9qcag3Lk4y4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E+qpRyP+; arc=pass smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E+qpRyP+"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cbe827e3cb4so4147158a12.3
        for <linux-sctp@vger.kernel.org>; Mon, 17 Aug 2026 13:59:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787000391; cv=none;
        d=google.com; s=arc-20260327;
        b=K56PfFA9qW4WECrOCTziqTTldgzN+fKtCCcivbqp3vMJxS42GOr5bes4S2AR4bTsRw
         Dyxloganw6GKlGW4d8r3frGWIYP9fNQj9fb2Te+pFFLs0CoYUBP3d/b4VwVkJbBfdWc/
         mIEgxFYYBWKpLxmXOrpuq57qQjIBPJRBq1rZo0NLLcBOhcoDm40V2FKP9gkYIQoLrvLC
         3Gk5216RsJf89xs2p/pcP8mvREhInM76JKTOd/WFbopo0KU1olXTobG9KHy+DlXKB4Cb
         sqlyW9iHL9SIweGPsLdO8SY2CAkCw/p1rFvNxAAjYurrxy0ExkVYgPjm4yCrKQF6zwZU
         lABw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8mMkXFKPm9YtmcJaO4UnEV5UZT7iWIfb0O/4F18eXG4=;
        fh=o2YNAB+GDTTVAF3K82W6sL3r+9eab6ffvzVoP4f2gDM=;
        b=YqmGj14tWTleUBrb4fe3zOwVdV7JlndcxkGgx3bqDVR71mmBpBqA/iqPxP2y6QoG/S
         Z1uW3WU4hBAk5zHgmLd/eIcQGTTWvMC8m4h7XYPrW6ykkcSBxh1+Exr/E+6V7AN/nEze
         XTf1kj0lKPVaxaYhq7M43BKm0vjFLUyopfLcoP78pL5tcxVVF9fwfC5voRTxGdnK2ks9
         VLDDDJmRldmAqepWqqAU3o6z7MNdYd8dOgVSCh5LStGcAI0V1dVSpK3/QDCKOzb3RtDh
         ikZN5GEZqJEutW3USXex0d5l+Dkf6SlhXFnuaU0cJbMy7Iz+gK+xsoL1AvvSMUI1uecB
         fKTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787000391; x=1787605191; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8mMkXFKPm9YtmcJaO4UnEV5UZT7iWIfb0O/4F18eXG4=;
        b=E+qpRyP+2EBGpQapcEgizSUkjvCo+3l7Cg0pH8lgyyr7XgwLCXrlUM8ksusep0sk3q
         NTDZ/RuR2NZFXJGbG8xvqCJxXc9FyvJS9mMyHWOEVS33JHwwPbYCJ2zHsGm2cko6YOq5
         PQvRUFQhlnnOSqLrwOjRm9eB+8U1/WiBsz+ExVc4ORPkteqy9luXc3NcR2yBmYAsz38R
         3/5njOWfT4AkiW9X5VxjEX4KUNo4v4jElEEP1drukVX9WTPjgIqmj9ERkmQsfIq4B7OE
         JBn7MpB9Vtmn6eceyFR+1fH3i3y8mIIsYau4EM+8h6BwMEN4SLlNqHoygY7YT1snhDr0
         HXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787000391; x=1787605191;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8mMkXFKPm9YtmcJaO4UnEV5UZT7iWIfb0O/4F18eXG4=;
        b=coey+0NQxplRTMkOV0zVly6J+eWlXGtx/e69+4UyGPDSOtT/ym5r6lbag5ZgQXEGyz
         Lr1coLwK3EzxOwEP0F+FjBxobmA11FyqSCwndGn/0YJoQ2kqzMF4YMsEBXwd/etuOHAp
         LqzrgUdRUjjksK2Hg954hZgPUp7C2/DSAr6wXQyZDr6xS7M5aDlQ8P+tZM5uWCpi3Xsr
         5YJFcExrihAGqDEpd83qA6a9UwvyspDr6hg/R7v6+kUjIcEa4Pv6PpSsG46cDJNwqzYK
         KMFRHVZ2WuhwRrR3yhWx0tYZY+nagZf+0fj0DPvneh5pa555Syfdv9eIdlgOFoG01Fvk
         TwdQ==
X-Forwarded-Encrypted: i=1; AHgh+RoAmvzACfK6KPAMhO7i+1Feb9uBMY7Tkp3d3Cg1U+EXX65UTSUy3cvLaE5cmDnPnzAFP6cjatepp6rj@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh3fMGrDWRoKTgK/PD4swtxFSLj66NlE9KdysVPDO8gV7HXkUs
	BSDDgJKisuGb9bki9dx/cGt25UlB5zYmo1773mcvh9Zw9ONOaV+2qHHBrHNszHUysERHqp4SgQy
	V8cKOeBeHaDzIA2HlMVfGRNwAKDb2IIo=
X-Gm-Gg: AR+sD111gZ4J/qZmdmmv9hHqR9EFxwtLDobO285/dOvcjKneaucg4LOs9DRZ9IxO4Ll
	KipxuTlrMlrsb56nfyV4JNP6a4hMddqlOOwPFedpZKVtkiUHR7QyuDxK45Gsd7ghMeIjT13DKLu
	Zln+MVdJeW7kh5Sac4jG0fTXXzo/dSRBNhkIryR5JGvA5xjT8bv+IgcloI33ise+nD/Sk6W0285
	/oPUp8/QQdi3BiZ5hwbuDfdg0/F+90gNv+rWRCPmvUmOwn96LnYPIPddA7YHndb9BHA1E40JRdd
	/nCCxN1NNqNMeEj+OW9KBFRKyryzoIZEexuxKTQxrRwYCz9gE9HRjTAo2NlQ3dM1JBJsXGXuGem
	pssmDMNv+j7u+Ypm8wfvgSxv9vLBgfsITaGb6fFXNna0=
X-Received: by 2002:a05:6a00:12d1:b0:845:40d1:87fa with SMTP id
 d2e1a72fcca58-851b882e7admr2836763b3a.25.1787000390987; Mon, 17 Aug 2026
 13:59:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <an-oGfEatacPTSX-@v4bel> <CADvbK_e60CFEVUVo25Tkcw_p4y16o8vZCf0N=hH+bUoEqpu6Qg@mail.gmail.com>
In-Reply-To: <CADvbK_e60CFEVUVo25Tkcw_p4y16o8vZCf0N=hH+bUoEqpu6Qg@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 Aug 2026 16:59:39 -0400
X-Gm-Features: AcwNN1VOnIN_7JXsuyS_viaYzaB2zKZsu4VQVWQVlF-17_QueSTRw30EbptT5bY
Message-ID: <CADvbK_c4V6cWiS=fTfCeS602bazwXy0mYCXnF6=eYH08PaRznQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: drop a backlogged chunk if its transport was removed
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 17, 2026 at 1:48=E2=80=AFPM Xin Long <lucien.xin@gmail.com> wro=
te:
>
> On Fri, Aug 14, 2026 at 7:43=E2=80=AFPM Hyunwoo Kim <imv4bel@gmail.com> w=
rote:
> >
> > sctp_rcv() resolves the transport once per packet and leaves it in
> > chunk->transport. If the socket is owned by userspace the packet goes t=
o
> > the socket backlog, and sctp_add_backlog() takes a reference on that
> > transport.
> >
> > An authenticated ASCONF DEL-IP in an earlier backlogged packet can remo=
ve
> > it. sctp_assoc_rm_peer() takes the transport out of the association and
> > calls sctp_transport_free(), which tags it dead and drops the reference
> > the association held. The backlogged packet still holds a reference, so
> > the transport stays around.
> >
> > The DATA chunk in that packet puts the removed transport back into
> > asoc->peer.last_data_from. Once the packet is done that reference goes
> > away and the transport is freed by RCU, so the next delayed SACK carrie=
s
> > the pointer into the SACK chunk and sctp_outq_select_transport() reads =
the
> > freed transport's state.
> >
> > Drop the chunk in sctp_backlog_rcv(), next to the existing rcvr->dead
> > check. The peer retransmits it. Guarding the last_data_from assignment =
is
> > not enough, sctp_assoc_rm_peer() clears more than that one pointer and
> > letting the packet run fills them in again. sctp_wait_for_sndbuf() alre=
ady
> > uses the dead flag this way on the send side.
> >
> > Fixes: df132eff4638 ("sctp: clear the transport of some out_chunk_list =
chunks in sctp_assoc_rm_peer")
Please also double check the 'Fixes' tag, commit df132eff4638 doesn't
seem to cause the issue.

Thanks.

> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > ---
> >  net/sctp/input.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sctp/input.c b/net/sctp/input.c
> > index 864741fae4187e..83b8361d149251 100644
> > --- a/net/sctp/input.c
> > +++ b/net/sctp/input.c
> > @@ -285,9 +285,10 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_bu=
ff *skb)
> >
> >         /* If the rcvr is dead then the association or endpoint
> >          * has been deleted and we can safely drop the chunk
> > -        * and refs that we are holding.
> > +        * and refs that we are holding.  Same if the transport
> > +        * we looked up has been removed in the meantime.
> >          */
> > -       if (rcvr->dead) {
> > +       if (rcvr->dead || (t && t->dead)) {
> >                 sctp_chunk_free(chunk);
> >                 goto done;
> >         }
> > --
> > 2.43.0
> >
> Can you try to move the check to sctp_inq_push() to also cover the
> case Sashik reported?
>
> https://netdev-ai.bots.linux.dev/sashiko/#/patchset/an-oGfEatacPTSX-%40v4=
bel
>
> Thanks.
