Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795404404;
	b=s1aB4nw5UV+73XnaPYl6Ox31J8j73MWu8ijzsHzwFvM8HOFjrc5t2NLa9/eeuqBS/vb+
	 vCzkOKMlq05py0auWlVrWCkQmKS/d/3THvcnO0F05OWkoOIiCjNpWh0Fc5Gf3GVESLhlR
	 31IrYRLHk5HweOK3k6NtDGqmQihU9OOv99j7DXYqeey8/opY64Vanj4z85Dq0I/u6RZ62
	 PmLv+ZrHrV51wtl/B1vJPBjVLI1kEpxaTj4JBXhqnaJww36WKxPwYPnUCZ/0J3bVtKqg0
	 h9qBa6LOMMZheNSrdkFAO884ZbR7XWZ0t4gvK0Grvdo3idEp/XHUO3FFBOoAv4QHl/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795404404;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=wc6ekr9cryGg73k6nk6oY3aWkmjnvr4TDpjauBGQjHM=;
	b=e8xgRmvRW8ybGTlB2Vzej8xLzZp4yBiGz9tKZuEMyWmv9+biFkr4nfjp/+C25o0Q0t+5
	 mYaifc1bBYj6Si4nh7G0C1bYmpc4AmnHZtVSC4pa8z0GgKG+cvweYRK7U3CUqIkJR1X5m
	 nskuAVvpGWzVQ5y2fWuc6DfHRmEmudd3/PJGNVhjpwzU0JagtkBm3UiUjiF3oHVmraLqh
	 CZi6ysfp9IPjTUt3DGrkeeH3DLVjFFafVXU1yW277u2PwvY+DfROzVGreey3IUK9UXUv8
	 NgwBgamCsAFKZ32nxIOAMpT9xo34mhlf4pmUgru6stUeacI6zdLuaTrYoWmPpSe51EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N9V3oaXf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B394D606A31A;
	Mon, 23 Nov 2026 03:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N9V3oaXf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4DE1F000D3;
	Mon, 23 Nov 2026 03:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795404404;
	bh=wc6ekr9cryGg73k6nk6oY3aWkmjnvr4TDpjauBGQjHM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=N9V3oaXfJVu8TmQHR3rUC4K5ZiDXFHSNdFSVyHLXtdJlCSzqQlSCB783vk6qRg+QB
	 YYcDkFheTwBssTfubNSjsxc4+L0HiMmXnhF/1bueAtDG3hWzuol3XWEzpWwpkCLzu1
	 HyKJjj6ICPWgR8HQSeyBLVBkgyUKGXyBOEEu0//yR8lQSKtiZaMWhk/dMgYIe2A1ae
	 SD4cVlwwbMryHpMlMfLi20YInXo1r48aI6KWzr3ag0OXWLjJRtbxIHQ+tPw0ud7OsK
	 nNCIWTz92y7PeQiCU5AUSh5kI8cR+84nwLZQSjvV6ehkulr22HUlOmjoWfZaxZT5KA
	 i2a0/C66QPyaQ==
Subject: Re: [BUG] sctp: auth: NULL asoc->shkey after a failed
 SCTP_CMD_ASSOC_SHKEY makes close() oops
From: netdev-bot+sashiko@kernel.org
To: kyuwoncho18@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 junvyyang@tencent.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Mon, 23 Nov 2026 03:26:43 +0000
Message-ID: <179540440300.3135.8565987128928534228@kernel.org>
In-Reply-To: <179505710266.3511678.14017674052424733262@gmail.com>
References: <179505710266.3511678.14017674052424733262@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.
- [Low] The changelog leaves out the directly related prior fix
  a80c9d945aef55 ("sctp: move SCTP_CMD_ASSOC_SHKEY right after…
- [Low] The recorded commit message is the raw bug-report email, not the
  patch changelog.
- [Low] The comment above sctp_auth_send_cid() in net/sctp/auth.c still
  says "Check if peer requested that this chunk is authenticated".

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the same
  'authenticated chunk with a NULL key' crash can be reached through a…

--

sctp: auth: NULL asoc->shkey after a failed SCTP_CMD_ASSOC_SHKEY makes close() oops

This patch makes sctp_auth_send_cid() return 0 when asoc->shkey is NULL.
Chunks are then not marked for authentication after
sctp_auth_asoc_init_active_key() fails while the INIT-ACK is processed.
The target is the NULL dereference in sctp_auth_shkey_hold() reached
from sctp_close()->sctp_make_abort_user() with SO_LINGER {1, 0}.

> sctp: auth: NULL asoc->shkey after a failed SCTP_CMD_ASSOC_SHKEY makes close() oops
>
> --===============7735770531491749088==
> Content-Type: text/plain; charset="us-ascii"
> Content-Transfer-Encoding: 7bit
>
> Hi Marcelo, Xin,

[Severity: Low]
This isn't a bug, but the recorded commit message looks like the raw
bug report email rather than the patch changelog. The subject describes
the symptom, not the change.

The body contains the salutation, MIME boundary lines, Content-Type
headers, the full repro.c and a base64-encoded config.gz attachment.

The real subject ("sctp: auth: don't authenticate chunks without an
association key"), the changelog, and the Fixes: and Signed-off-by:
trailers only appear inside the embedded format-patch attachment.

Could this be resent as a proper patch that uses the attached changelog
as the commit message?

[ ... ]

> The reference on the shared key comes from 1b1e0bc99474 ("sctp: add
> refcnt support for sh_key"). ad1320865b18 ("sctp: hold shkey across
> socket migration") and 52ffeaa358d1 ("sctp: re-point retained control
> chunks on association migration"), both in v7.4-rc3, handle the
> migration paths and not this one.

[Severity: Low]
Should this also mention a80c9d945aef55 ("sctp: move
SCTP_CMD_ASSOC_SHKEY right after SCTP_CMD_PEER_INIT")? That commit
handled the same failure: SHKEY fails, shkey stays NULL, auth_capable is
set, and a chunk is sent with auth=1.

That commit also reordered the commands in sctp_sf_do_5_1C_ack() so
that this one runs before TIMER_STOP/TIMER_START/NEW_STATE:

    sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_SHKEY, SCTP_NULL());

Because of that ordering, the failed association stays in COOKIE_WAIT.
There AUTH is discarded, and T1-init retransmits INIT, so key setup is
retried. This patch appears to depend on that behaviour.

Trees without a80c9d945aef55 leave the failed association in
COOKIE_ECHOED with T1-cookie running. Backporters who follow only
"Fixes: 1b1e0bc99474" get no warning about this. Would it be worth
stating the dependency here, instead of the two migration-path commits?

> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index cbeb8a87a17a7..5f8e110929d46 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -660,7 +660,7 @@ int sctp_auth_send_cid(enum sctp_cid chunk, const struct sctp_association *asoc)
>  	if (!asoc)
>  		return 0;
>  
> -	if (!asoc->peer.auth_capable)
> +	if (!asoc->peer.auth_capable || !asoc->shkey)
>  		return 0;

[Severity: High]
Is this check enough to cover the keyless state? After
SCTP_CMD_ASSOC_SHKEY fails in sctp_sf_do_5_1C_ack(), SCTP_CMD_PEER_INIT
has already set peer.auth_capable, peer_chunks, peer_hmacs and
c.peer_vtag. Both asoc->shkey and asoc->asoc_shared_key are still NULL.
This change only affects the transmit side.

During an INIT collision, the COOKIE_WAIT association can receive the
peer's COOKIE-ECHO. sctp_sf_do_5_2_4_dupcook() then gets action 'D' from
sctp_tietags_compare(), because PEER_INIT already set a non-zero
peer_vtag:

    if ((asoc->c.my_vtag == new_asoc->c.my_vtag) &&
        (asoc->c.peer_vtag == new_asoc->c.peer_vtag))
        return 'D';

If an AUTH chunk comes before the COOKIE-ECHO, sctp_sf_do_dupcook_d()
verifies it against the existing keyless association:

    if (!sctp_auth_chunk_verify(net, chunk, asoc))
        return SCTP_DISPOSITION_DISCARD;

The call chain
sctp_auth_chunk_verify()->sctp_sf_authenticate()->sctp_auth_calculate_hmac()
then uses the NULL key:

    if (key_id == asoc->active_key_id)
        asoc_key = asoc->asoc_shared_key;
    ...
        hmac_sha1_usingrawkey(asoc_key->data, asoc_key->len,

Without that AUTH chunk, dupcook_d moves the association to ESTABLISHED
and never calls sctp_auth_asoc_init_active_key(), unlike dupcook_a and
dupcook_b. sctp_sf_eat_auth() checks only peer.auth_capable before it
calls sctp_sf_authenticate(). Any later AUTH chunk from the remote peer
then hits the same NULL asoc_shared_key dereference in the receive path.

The patch also changes behaviour in a way the changelog doesn't mention.
sctp_auth_send_cid() now returns 0 in this state. So DATA, ABORT and any
other chunk the peer listed in its CHUNKS parameter are sent without
AUTH. The peer silently drops them in sctp_assoc_bh_rcv():

    if (sctp_auth_recv_cid(subtype.chunk, asoc) && !chunk->auth)
        continue;

The association then looks established but delivers nothing.

Would it be better to stop a keyless auth-capable association from
leaving COOKIE_WAIT or processing AUTH? For example, dupcook_d could
initialise the key or fail, or AUTH could be rejected while
asoc_shared_key is NULL. That would replace the approach in
sctp_auth_send_cid() rather than add to it.

>  
>  	return __sctp_auth_cid(chunk, asoc->peer.peer_chunks);

[Severity: Low]
The comment above sctp_auth_send_cid() still says:

    /* Check if peer requested that this chunk is authenticated */

After this change, the function also returns 0 when the local
association key is not set up, even if the peer listed the chunk.
Callers rely on the documented meaning. sctp_datamsg_from_user() says
"If the peer requested that we authenticate DATA chunks", and
_sctp_make_chunk() says "Determine if the chunk needs to be
authenticated".

Should the comment be updated to mention the local key check?

[Severity: High]
This isn't a bug introduced by this patch, but the same crash (an
authenticated chunk with a NULL key) looks reachable through stream
interleaving. The new !asoc->shkey check does not cover that path.

sctp_datamsg_from_user() picks the per-chunk key by asking about DATA:

    if (sctp_auth_send_cid(SCTP_CID_DATA, asoc)) {
        ...
            shkey = asoc->shkey;

With interleaving, the chunk is built by
sctp_make_idatafrag_empty()->sctp_make_idata()->_sctp_make_chunk(asoc,
SCTP_CID_I_DATA, ...). That function sets the auth flag by asking about
I-DATA:

    if (sctp_auth_send_cid(type, asoc))
        retval->auth = 1;

If the peer lists I-DATA (0x40) but not DATA in its CHUNKS parameter,
every I-DATA chunk gets auth=1 with shkey=NULL. asoc->shkey itself is
valid in this case, so the new check does not apply. On transmit,
sctp_packet_append_chunk()->sctp_packet_bundle_auth() then dereferences
NULL:

    auth = sctp_make_auth(asoc, chunk->shkey->key_id);

In the reverse case (DATA listed, I-DATA not), shkey is set and auth is
0. No AUTH chunk is ever bundled, so sctp_packet_will_fit() returns
SCTP_XMIT_PMTU_FULL every time, even for an empty packet:

    if ((packet->auth && chunk->shkey != packet->auth->shkey) ||
        (!packet->auth && chunk->shkey &&
         chunk->chunk_hdr->type != SCTP_CID_AUTH))
        return SCTP_XMIT_PMTU_FULL;

The I-DATA chunk is then never sent.

No fault injection is needed. The local side has to enable AUTH and
interleaving (SCTP_FRAGMENT_INTERLEAVE and SCTP_INTERLEAVING_SUPPORTED,
plus the net.sctp.intl_enable sysctl, which is off by default). The
first sendmsg() then triggers the NULL dereference.

Should the key selection in sctp_datamsg_from_user() use the same chunk
type as the chunk that make_datafrag builds?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/179505710266.3511678.14017674052424733262%40gmail.com
