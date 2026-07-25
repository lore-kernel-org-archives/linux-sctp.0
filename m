Received: from mail-08.mail-europe.com (mail-08.mail-europe.com [57.129.93.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4A1375F67;
	Sat, 25 Jul 2026 03:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.129.93.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784949693; cv=none; b=r9sSNZxRW7AjLFHzH5NyATDPZcdz5qWP4D9KtNf0jDTFAVUwahdjv2hXLIH8PXTl+cEn0QaxhUVNO0WnqQIX/jUCoSHDpkzaW6/lgUXEG4XJs7mK6Q0yowr0JvWK3xOilLat1ISoWmWMEJ60y1jZOyKSrAg8/O19p9wuQSpDoII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784949693; c=relaxed/simple;
	bh=bw360Oxj8oT+9y61YumhjBMMnkQZ4t2z+HXfra1HcJE=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Qs0I3Dl9GfoAuWyenfHXREOY80216Ig5WBb670irs2GL8M+f3qpLzHQlSypKNoFj2mxHbOZ7h+Z3BLEsfxB0qzFoezyoM9PvEoW1yVQq9DMiGGW8aPzsu5/L9yCkUUbYBe7MAjNK3rKENz7/FwnbL95wJIwHrou7p9WzYI8RLjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=qaes6S6E; arc=none smtp.client-ip=57.129.93.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="qaes6S6E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1784949673; x=1785208873;
	bh=bw360Oxj8oT+9y61YumhjBMMnkQZ4t2z+HXfra1HcJE=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=qaes6S6E3Z+LWIApRLjxQuTEjtE/ZjOnPjjJqSPufomc49MBWFdDPiuTJnTPVcItu
	 qn+NibiJ/kcZ3ZQglzbCe7kg0Q4XE0v05etJhJUbzd9VtWYETovqNOTktmaYoISJpt
	 3PIvZkP+UJzszntQtfaIAR5XAavUqXz7cJRnPkLe8yQWgEEy94jl+ru59Hc+ONMOb2
	 KHO+hhToLkIz8EnU2RBQPDXYTUfePprfLezqBXv9VdiEGb2jvY967xQwNMc/36+Zw0
	 4fTd6YKgXjrD6RebJHetAQdKYWCmtve0voWudO1rZlQ4mohtoiRxe8uynYiuZRxOJr
	 VRnIOYc9wjLkw==
Date: Sat, 25 Jul 2026 03:21:06 +0000
To: netdev@vger.kernel.org
From: Asim Viladi Oglu Manizada <manizada@pm.me>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] sctp: prevent peer transport count overflow
Message-ID: <20260725032053.521705-1-manizada@pm.me>
Feedback-ID: 37265593:user:proton
X-Pm-Message-ID: a74a3a363e920bd1c088e1ed1fb1c464dcd28a83
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

sctp_assoc_add_peer() increments the association's 16-bit transport_count
for every new unique peer. Adding the 65,536th transport wraps the count to
zero.

SCTP sock_diag uses transport_count to reserve the INET_DIAG_PEERS payload,
then copies one sockaddr_storage for every entry in transport_addr_list.
After the wrap, a diagnostic dump reserves an empty payload and writes
8 MiB of peer addresses past the skb tail.

Reject a new unique peer when transport_count has reached U16_MAX. Perform
the check after the existing-peer lookup so a duplicate address continues
to return its existing transport at the limit.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Cc: stable@vger.kernel.org
Assisted-by: avom-custom-harness:gpt-5.5-qwen3.6-mod-mix
Signed-off-by: Asim Viladi Oglu Manizada <manizada@pm.me>
---
 net/sctp/associola.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 62d3cc155809..b6ac0966420a 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -614,6 +614,9 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_=
association *asoc,
 =09=09return peer;
 =09}
=20
+=09if (asoc->peer.transport_count =3D=3D U16_MAX)
+=09=09return NULL;
+
 =09peer =3D sctp_transport_new(asoc->base.net, addr, gfp);
 =09if (!peer)
 =09=09return NULL;
--=20
2.53.0

