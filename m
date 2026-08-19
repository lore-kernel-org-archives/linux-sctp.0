Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329E33B6352
	for <linux-sctp@vger.kernel.org>; Wed, 19 Aug 2026 01:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787102117; cv=none; b=DzEOCYx7GmQ3BqJU71Ah9aExaqtAXCULfs8MqgVAUpEfxuwp1CRua+YZ+MDbcsiwC3k7sU1CnGqU0rHcUV2+DXpJJV5AiFPwVB3hLEJNbDW5WkRXlY5t9koqFl4sbrzg/kcFTJt6LG/FwqyX/tLS0yuBWi7AAlkIAqIGT0aVI+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787102117; c=relaxed/simple;
	bh=NUDv2JcJ7RwZhBTmVl0jXBgtN2f3GYCncPfUY+N2/Ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEiaQB1HbaMcok8RkkNybpmPR9SdprH8k5xp7rplYB55rIVveIWScOIHLdrHkVKPPkSFrZ+Abe00SNxYt7NhGl5rWdYh2bb+O4KjDwzKm/C5jqN1HXhpPyQzjjjvA+neOk1IsabC8qwkHasRo+A0x1SRdi9YLHMNV6ADF/DxLkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XBYhNNng; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBYhNNng"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cca0c5799eso4098065ad.0
        for <linux-sctp@vger.kernel.org>; Tue, 18 Aug 2026 18:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787102115; x=1787706915; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NUDv2JcJ7RwZhBTmVl0jXBgtN2f3GYCncPfUY+N2/Ec=;
        b=XBYhNNngXOVdKiqFqgl7JKD8RrYX5gphtnTTQu4kb4ARiOQ7N+KML7fj/tED9g0d82
         lE8+LDaRmReINL0DKHYDfM8L9qiR9EgWnn4mKypOtuuFfgKbl+J13gDtbyUWWFQ3CT6n
         IGAldr5YjFRyKc6PMNorGHjrzsDUAhbKXqA1KMYnX04Au6HNgc/e5kqsed8QIIzCvGhw
         J/n7JIU8AJDbnfxCM8OrtmNlu1dZVOQJ1OoGZchnC41QjQCEhhkFzd4zMt9CjxDsd5fh
         usyEII4rIbiyirwkOJ75stYpeSCtI0l8LlOHw5kyX32S4rly9VqSIWYUr099TrPnPw9B
         A0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787102115; x=1787706915;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NUDv2JcJ7RwZhBTmVl0jXBgtN2f3GYCncPfUY+N2/Ec=;
        b=sqh8st3eWEndGVfBcPelkBrtVNuZKWpAo3goHwzI0mcymG9jz/em4c3M7OmHlXA9kj
         nekbvdgI3Apn+M+Wh9KAw+HbXdl49MsJEh3SObKM/satf6BUY2C903H3WeqFwbh/ZhHu
         icJ8LGDCNAz7kKQOttKo1SQja8f7bbRr4qTkujYHJV/1gvAy9bw8F6DXeSzt1tV5aeoE
         Ey/z/hCyncegPdU/Pxx1i/oYE1vFRD/j8m8byDs25g0iWAJDg9J5mMYpJXB/9ZK+SPhB
         fqrAn7v6wY8fPAva+4pR6lKuRpWjNIAay2scOb/fuUqMDdNy6IrEF3f4JNkgRvUfSPIG
         82pw==
X-Forwarded-Encrypted: i=1; AHgh+Rr7gtIP65wId4kRjOXUaplXb09Thzgp7EdVVQKRFJqFL3XqY/fxpSLWEgZaBBt0/LAsW02zlLuv8FsO@vger.kernel.org
X-Gm-Message-State: AOJu0YwbO102JDsVv9qGWPzR1+KTH2/rLQMbGKNUnatdj+kDhPYFSrws
	t+KUrBfZ8IYWavhpFNJRXmEJb/CfDYNSBUq7frUAl8wVNH4rszYi3n63
X-Gm-Gg: AR+sD135Ii9T618cLpVdTIoPwLbThwbA/5c58v2IP2rKAqKzgrsJTeuD/E7yhdSkqcd
	e4sBB5tuIFVexSrDD3Axt8mg8cBrwx7GMy40uE71Oab/Nosjq+d89GEAhWpku5w5c+eqMhxqjy0
	YsmVUsS9z/0verV5TY0aKLypvrPXR4hYBZdGZ42GuDaRjWAAVsl/KlS64K3CFqabAKTWJ2sbBlD
	ts3RmG+eDcgwdXhDQ/Oyj9oEW2DWWJ1GYY0HL9zUWHWau6oWDGFrWxyzn4JK41+uNKoeAJhXti2
	dHiw+7uenaZW3e1o+3BXM/8zYyOl6rr9hadPab0zTr8AairiXi/LnMVC8dLkM4aXz5uxYvU1qPI
	MMrWEoAvccNpsvefmID2fNURypii0JImjHVQ4IpYfcdQIg89BqkSSrSqIi/NUjuTaNsBXIv4vZC
	XWV0z/Rufq6WmfIvApczeIKw/tAebIvijwDXbjW5HJEEpgg49lOJ1tu5AH48OED+6qUft0kjDKJ
	79dcqYS
X-Received: by 2002:a17:903:28c:b0:2cc:aa36:c04c with SMTP id d9443c01a7336-2d5fd5b087fmr18298765ad.1.1787102115407;
        Tue, 18 Aug 2026 18:15:15 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1ecb2absm18986855ad.71.2026.08.18.18.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 18:15:13 -0700 (PDT)
Date: Wed, 19 Aug 2026 10:15:10 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
	imv4bel@gmail.com
Subject: Re: [PATCH net] sctp: drop a backlogged chunk if its transport was
 removed
Message-ID: <aoUDnh13j4c2KCYY@v4bel>
References: <an-oGfEatacPTSX-@v4bel>
 <CADvbK_e60CFEVUVo25Tkcw_p4y16o8vZCf0N=hH+bUoEqpu6Qg@mail.gmail.com>
 <CADvbK_c4V6cWiS=fTfCeS602bazwXy0mYCXnF6=eYH08PaRznQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADvbK_c4V6cWiS=fTfCeS602bazwXy0mYCXnF6=eYH08PaRznQ@mail.gmail.com>

On Mon, Aug 17, 2026 at 04:59:39PM -0400, Xin Long wrote:
> On Mon, Aug 17, 2026 at 1:48 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Fri, Aug 14, 2026 at 7:43 PM Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > >
> > > sctp_rcv() resolves the transport once per packet and leaves it in
> > > chunk->transport. If the socket is owned by userspace the packet goes to
> > > the socket backlog, and sctp_add_backlog() takes a reference on that
> > > transport.
> > >
> > > An authenticated ASCONF DEL-IP in an earlier backlogged packet can remove
> > > it. sctp_assoc_rm_peer() takes the transport out of the association and
> > > calls sctp_transport_free(), which tags it dead and drops the reference
> > > the association held. The backlogged packet still holds a reference, so
> > > the transport stays around.
> > >
> > > The DATA chunk in that packet puts the removed transport back into
> > > asoc->peer.last_data_from. Once the packet is done that reference goes
> > > away and the transport is freed by RCU, so the next delayed SACK carries
> > > the pointer into the SACK chunk and sctp_outq_select_transport() reads the
> > > freed transport's state.
> > >
> > > Drop the chunk in sctp_backlog_rcv(), next to the existing rcvr->dead
> > > check. The peer retransmits it. Guarding the last_data_from assignment is
> > > not enough, sctp_assoc_rm_peer() clears more than that one pointer and
> > > letting the packet run fills them in again. sctp_wait_for_sndbuf() already
> > > uses the dead flag this way on the send side.
> > >
> > > Fixes: df132eff4638 ("sctp: clear the transport of some out_chunk_list chunks in sctp_assoc_rm_peer")
> Please also double check the 'Fixes' tag, commit df132eff4638 doesn't
> seem to cause the issue.

Understood. I'll run a few more tests and then submit v2.


Best regards,
Hyunwoo Kim
