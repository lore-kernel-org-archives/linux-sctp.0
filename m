Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649993446B9;
	Mon,  3 Aug 2026 23:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800257; cv=none; b=mWESzrUlgouqMlhbmvkB0YhylgHaW+IVOxcDwQusQjB0MJvFfI5/khBiG53iWh+PxNWK1AODWqc1YuCc4/+FSfjSKz+d1SA6LpsLy/62gFTOETI/1MA46mSXvATOBBrk8dN3fY3n9S9RsqGPCTJyAUUvUq73t+UG0VL9Esl3EsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800257; c=relaxed/simple;
	bh=f4r+OA1YXFzxcVZDEagM7bsXcOeHfDvXh4Hm4TZliwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGEmrYcC+RSm42hniBdGpMd8V1jLNj2IC4Qlp4rWoKn8hw6FU6xBKwrPFgsBofd6o4sqLpif41lDKFTZikQMPa6X7mQjrbe++RuwUyUrqQvOtssKiPxLyyJQ+pZBQJOp9XDgWWj56SJwWqoinuN4XuT07HnR2V+tL93qd/kclys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSRF9FEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSRF9FEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EBE1F000E9;
	Mon,  3 Aug 2026 23:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785800255;
	bh=ptPCPkekjvqSpOCYieRgFnA5RnLa/tU7Dy8rwBETuI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSRF9FEVSh5kqD5Td2G4E+hebPod8mRDoP52TcEruGsTCquX6TsSVYI3pAQF9eK4o
	 isFNN7eLxH375x2yOYfHfQJiED163pzSqb0vnSKlDTrzhN9prmj0bCZrMsfxcpbzyr
	 Abl60jTI+CrinAODEfbxGk80tPuhwiUwu5z71V2Vovm9eqxuC03LdvWzoTbInn0vvg
	 DOx7u5EMEY0DsC3PDYqP7je+2uoISOtQ7wImk1BsQIoyK2L1EXfJfab/suUT8UiZxr
	 qdW/1R0uFS+qyZ9gOUZxCUElskar/8Z42RAt2NBVb0vGIOfHPfUsq6x9d+vlQqhBCZ
	 CCm0wzV6lpd3Q==
From: Jakub Kicinski <kuba@kernel.org>
To: omeux327@gmail.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] sctp: diag: fix uninitialized stack leak via INET_DIAG_LOCALS/PEERS
Date: Mon,  3 Aug 2026 16:37:19 -0700
Message-ID: <20260803233718.2336399-2-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730023309.21654-1-omeux327@gmail.com>
References: <20260730023309.21654-1-omeux327@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email says "AI seems to have spotted another related stack leak, and
suggests an alternative fix."
---
sctp: diag: fix uninitialized stack leak via INET_DIAG_LOCALS/PEERS

The patch changes inet_diag_msg_sctpladdrs_fill() and
inet_diag_msg_sctpaddrs_fill() to zero the whole sockaddr_storage slot
first and then copy only the family-dependent prefix of the stored
union sctp_addr, so the sockaddr_in6-only tail of an AF_INET address is
no longer exported through the netlink attributes.

A few questions about the changelog and the placement of the fix.

[Severity: Low]
[Finding: main-1-2]
[Sources: opus-5]
The changelog says:

>     inet_diag_msg_sctpladdrs_fill() copies sizeof(union sctp_addr) (28 bytes,
>     the size of sockaddr_in6) from each sctp_sockaddr_entry.a into the netlink
>     INET_DIAG_LOCALS attribute and then only zeroes the bytes from offset 28 to
>     sizeof(sockaddr_storage).  The same pattern is used by
>     inet_diag_msg_sctpaddrs_fill() for INET_DIAG_PEERS.

Can the INET_DIAG_PEERS path actually leak anything?  transport->ipaddr
is allocated zeroed and only ever written with sockaddr_len bytes:

net/sctp/transport.c:sctp_transport_new() {
	transport = kzalloc_obj(*transport, gfp);
	...
}

net/sctp/transport.c:sctp_transport_init() {
	peer->af_specific = sctp_get_af_specific(addr->sa.sa_family);
	memcpy(&peer->ipaddr, addr, peer->af_specific->sockaddr_len);
	...
}

So bytes 16..27 of from->ipaddr look guaranteed to be zero for AF_INET,
which would make the inet_diag_msg_sctpaddrs_fill() change hardening
rather than a fix.  Should the changelog say that instead?

The changelog also says:

>     region) are left uninitialized.  Those bytes are propagated verbatim through
>     sctp_add_bind_addr() (which copies sizeof(union sctp_addr)=28 bytes) and then

sctp_add_bind_addr() copies a caller-supplied length:

net/sctp/bind_addr.c:sctp_add_bind_addr() {
	memcpy(&addr->a, new, min_t(size_t, sizeof(*new), new_size));
	...
}

Callers such as sctp_do_bind() pass af->sockaddr_len and store nothing
uninitialized; only the callers that pass sizeof(union sctp_addr) do.
Could that be spelled out so the scope of the stable backport is clear?

> diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> index c2a0de2adf6fd..610c937deffd7 100644
> --- a/net/sctp/diag.c
> +++ b/net/sctp/diag.c
> @@ -85,8 +85,12 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_buff *skb,
>  	info = nla_data(attr);
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(laddr, address_list, list) {
> -		memcpy(info, &laddr->a, sizeof(laddr->a));
> -		memset(info + sizeof(laddr->a), 0, addrlen - sizeof(laddr->a));
> +		size_t copy_len = laddr->a.sa.sa_family == AF_INET ?
> +				  sizeof(struct sockaddr_in) :
> +				  sizeof(struct sockaddr_in6);

[Severity: Low]
[Finding: main-1-1]
[Sources: opus-5]
This isn't a bug, but the AF_INET/AF_INET6 to length mapping already
exists as struct sctp_af::sockaddr_len, and the exact "zero a
sockaddr_storage, then copy only the valid part" idiom is already in the
tree:

net/sctp/ulpevent.c:sctp_ulpevent_notify_peer_addr_change() {
	memset(&addr, 0, sizeof(struct sockaddr_storage));
	memcpy(&addr, &transport->ipaddr,
	       transport->af_specific->sockaddr_len);
	...
}

Would sctp_get_af_specific(laddr->a.sa.sa_family)->sockaddr_len in
inet_diag_msg_sctpladdrs_fill(), and from->af_specific->sockaddr_len in
inet_diag_msg_sctpaddrs_fill(), work here?

Also, the else branch hardcodes sizeof(struct sockaddr_in6) as a stand-in
for "the whole union", so an unexpected sa_family copies the maximum
length rather than the minimum, and the constant silently diverges if
union sctp_addr ever grows a larger member.

> +
> +		memset(info, 0, addrlen);
> +		memcpy(info, &laddr->a, copy_len);
>  		info += addrlen;
>  
>  		if (!--addrcnt)

[Severity: Low]
[Finding: main-1-0]
[Sources: opus-5]
Does this leave the uninitialized tail sitting in the bind address list
itself?  The residue is stored by the producers, and this hunk only stops
one consumer from exporting it:

net/sctp/socket.c:sctp_send_asconf_add_ip() {
	memcpy(&saveaddr, addr, af->sockaddr_len);
	retval = sctp_add_bind_addr(bp, &saveaddr,
				    sizeof(saveaddr),
				    SCTP_ADDR_NEW, GFP_ATOMIC);
	...
}

net/sctp/bind_addr.c:sctp_raw_to_bind_addrs() {
	union sctp_addr addr;
	...
	!af->from_addr_param(&addr, rawaddr, htons(port), 0)
	...
	retval = sctp_add_bind_addr(bp, &addr, sizeof(addr),
				    SCTP_ADDR_SRC, gfp);
}

In both cases only 16 bytes of the 28-byte stack union are written for
AF_INET, and sctp_add_bind_addr() then persists all 28 bytes into the
kzalloc'ed entry, so offsets 16..27 of the stored address stay as stack
residue after this patch.  The second path is driven by peer-supplied
INIT/INIT-ACK address parameters.

Would zeroing the union in sctp_v4_from_skb() / sctp_v4_from_sk() /
sctp_v4_from_addr_param(), or clamping sctp_add_bind_addr() to
af->sockaddr_len, close this for every present and future consumer?  That
seems worth considering given the Cc: stable tag.

> @@ -114,9 +118,12 @@ static int inet_diag_msg_sctpaddrs_fill(struct sk_buff *skb,
>  	info = nla_data(attr);
>  	list_for_each_entry(from, &asoc->peer.transport_addr_list,
>  			    transports) {
> -		memcpy(info, &from->ipaddr, sizeof(from->ipaddr));
> -		memset(info + sizeof(from->ipaddr), 0,
> -		       addrlen - sizeof(from->ipaddr));
> +		size_t copy_len = from->ipaddr.sa.sa_family == AF_INET ?
> +				  sizeof(struct sockaddr_in) :
> +				  sizeof(struct sockaddr_in6);
> +
> +		memset(info, 0, addrlen);
> +		memcpy(info, &from->ipaddr, copy_len);
>  		info += addrlen;
>  	}
>
-- 
pw-bot: cr
