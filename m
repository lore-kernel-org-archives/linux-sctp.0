Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795493638;
	b=s8jknzigtrexJk9amBU7zAN8CB6BYStfyIX9zAcd+PaNJ6v1Dv+k95Lor/XzlwKVTj0U
	 z1hm65t7ojLBuRvXnBJd5JxMwJ+5C9uIguyhGHzzdLSYbhK3Nf8rcbF38HRD4fdey4CMO
	 fNZtHHorUlfTyBcOwknkixxjQme65AA+2fTU/xtAm697akDvhUtu/f/+Lb5XI5oBOT1/l
	 Cfp3FB69bnjGqZk/Ok/XqDbYsVvPNe/K7UtF3HmOnFq3EkNmcH2WEPdUc8DavyszxMNZ5
	 ZamWB+gMMkwOpInzmh2koNorpgykVIOxXCUql9fOfzc8zWZ/nL7eP6B4fsVXdlaQtTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795493638;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=6Mz18uN2p/y0avRq1l5xM0rYtAsdCZ52cJXPtpBaXLY=;
	b=h+wiWRKw+hFdCBuhc7oEQmRJZaUxVuhaWprkYxcfypPuoojdEYImjQu2jOdENTLkZe7G
	 oAVjzvxqz6fvFZ3eV87LB0GxtOKiybkGACm+2bQXSOSE4QtclPQM9ayEnt+9DXiWi0iT9
	 sMEdSniBmNmLCydlJYO3gHzKOm/Ya+0Qu8kmFvSUrMMz5MbGTVbarsnlJ8vQ4OstqAghi
	 Mkk5wX4edsvXjOnGVTJaH8aI7rBEvunKD8fIEGXQddKozPJv0bsFKlMzAs5g0vhsEoiJH
	 MpiR6q4kk15+8Arv2/P2QxonbrBSVZlFHjQQbCnNqyN49hl+3SIhWMGLdYrgdq45XxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="SpYJI/ax";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A02F606A31E;
	Tue, 24 Nov 2026 04:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SpYJI/ax
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79A81F000CA;
	Tue, 24 Nov 2026 04:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795493637;
	bh=6Mz18uN2p/y0avRq1l5xM0rYtAsdCZ52cJXPtpBaXLY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SpYJI/axf8WNeJkwDE7+V76Cv8RwmhFLP/Le5I3eJ5sRf4PpPaoEWaXNfGZySa0EM
	 UcAvBspjLQv6eu0Ka3FTdNQq8aqAZJt00yNn6c3KIWxDrCOREwIIXE+ERjSIMywt1A
	 EPOxl0g6V1wWY4mSxAvSQKe/7w8efIWOpu4W550iipiVMVvEpI/mdDWNgljMl6jZsF
	 2QNEz5jvlo3Svz/yCVQBB763Fo3hPwG0mLx57YvZ9lFORazkQB+RhraT+tooatqnK3
	 /04Yi5fgH0qCbqIGDrnutTnMSAckhExEM98xWwGZZxpJnWOZ9cC/as+JQt6rh2s6VH
	 zbWB+NUjY38gw==
Subject:
 Re: [PATCH net v4] sctp: fix use-after-free after association migration
From: netdev-bot+sashiko@kernel.org
To: pkfxxxing@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, kuba@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Tue, 24 Nov 2026 04:13:56 +0000
Message-ID: <179549363640.3135.12116855475874204489@kernel.org>
In-Reply-To: <20261120035521.2098757-1-pkfxxxing@gmail.com>
References: <20261120035521.2098757-1-pkfxxxing@gmail.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch makes deferred PMTU handling lose valid MTU
  reductions.
- [Medium] sctp: unlocked state mutation on migrated sock in
  sctp_icmp_frag_needed()

Pre-existing issues:
- [Medium] The deferral branch of sctp_icmp_frag_needed() does a non-
  atomic read-modify-write of the 1-bit field t->pmtu_pending…

--

sctp: fix use-after-free after association migration

Timer and ICMP handlers that cache asoc->base.sk now check, after taking
the BH lock, that the association still belongs to that socket. If it
has migrated, they defer the work as they would for a busy socket. The
patch also moves the PMTU size check from sctp_icmp_frag_needed() into
sctp_transport_update_pmtu(), and adds READ_ONCE()/WRITE_ONCE() pairing
for the socket pointer.

> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 9494cfa51106c..555695718abf9 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c

[ ... ]

> @@ -372,12 +372,7 @@ static int sctp_add_backlog(struct sock *sk, struct sk_buff *skb)
>  void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
>  			   struct sctp_transport *t, __u32 pmtu)
>  {
> -	if (!t ||
> -	    (t->pathmtu <= pmtu &&
> -	     t->pl.probe_size + sctp_transport_pl_hlen(t) <= pmtu))
> -		return;
> -
> -	if (sock_owned_by_user(sk)) {
> +	if (sock_owned_by_user(sk) || sk != READ_ONCE(asoc->base.sk)) {
>  		atomic_set(&t->mtu_info, pmtu);

[Severity: Medium]
The association can migrate between the READ_ONCE() of asoc->base.sk
and bh_lock_sock(sk). When that happens, sctp_err_lookup() still
returns the old socket with only the old socket's slock held. It
counts the ICMP in LINUX_MIB_LOCKDROPPEDICMPS, but it still hands asoc
and transport back to the callers.

sctp_rcv() handles the same window differently. It drops the old
lock, rereads rcvr->sk and takes the new socket's lock. Is there a
reason sctp_err_lookup() can't do the same?

As written, the migrated case falls into the deferral branches of
sctp_icmp_frag_needed() and sctp_icmp_proto_unreachable(). Those
branches still modify shared association and transport state.

sctp_icmp_frag_needed() writes t->mtu_info, asoc->pmtu_pending and
t->pmtu_pending. t->pmtu_pending is a bitfield that shares a word with
t->dead, rto_pending, hb_sent and the other transport flags. BH and
process context on the new socket update those flags under the new
socket's lock, not the one held here.

sctp_icmp_proto_unreachable() checks timer_pending() on
t->proto_unreach_timer, then takes a transport reference and calls
mod_timer(). If sctp_transport_free() runs on the new socket at the
same time, its timer_delete() of proto_unreach_timer can land before
this mod_timer(). The timer is then re-armed after teardown and keeps
the transport alive until it fires. sctp_generate_proto_unreach_event()
should then see asoc->base.dead set and bail out.

None of this is serialized against the new socket's owner. The only
lock held belongs to a socket that no longer owns the association.

The busy-socket case has a similar shape and predates this patch.
Before the patch, the migrated case ran full ICMP processing under the
wrong lock, so this is an improvement. It still isn't fully closed.

Would it be simpler to switch to the new socket's lock in
sctp_err_lookup()? Alternatively, the ICMP could be dropped entirely
once the association has moved, instead of recording deferred PMTU and
proto-unreach state.

[Severity: Medium]
Can a pending PMTU reduction get lost here?

The size filter used to run before this deferral branch. Now that it has
moved, the branch stores every Frag-Needed/PTB value in t->mtu_info,
including values at or above t->pathmtu. t->mtu_info holds only one
value, so a later report that cannot lower the MTU overwrites an earlier
pending reduction.

For example, with pathmtu=1500 and the socket owned by the user:

ICMP#1: mtu_info = 1200, pmtu_pending = 1
ICMP#2 (stale, or from another ECMP path, matching vtag): mtu_info = 1500

On the next transmit, sctp_packet_config() or sctp_sendmsg_to_asoc()
calls sctp_assoc_sync_pmtu():

net/sctp/associola.c:sctp_assoc_sync_pmtu() {
    ...
		if (t->pmtu_pending && t->dst) {
			sctp_transport_update_pmtu(t,
						   atomic_read(&t->mtu_info));
			t->pmtu_pending = 0;
		}
    ...
}

sctp_transport_update_pmtu() is called with 1500. The relocated check
returns false:

	if (t->pathmtu <= pmtu &&
	    t->pl.probe_size + sctp_transport_pl_hlen(t) <= pmtu)
		return false;

t->pmtu_pending is then cleared anyway, so the 1200 reduction is never
applied or retried.

Wouldn't the association then keep sending packets larger than the real
path MTU until another ICMP is processed? The new migrated-socket
condition also sends more ICMPs into this unfiltered branch.

>  		asoc->pmtu_pending = 1;
>  		t->pmtu_pending = 1;

[Severity: Medium]
This is a pre-existing issue, and the patch did not introduce it.
t->pmtu_pending is a 1-bit field that shares one __u32 word with other
transport flags in struct sctp_transport:

	__u32	dead:1,
		rto_pending:1,
		hb_sent:1,
		pmtu_pending:1,
		dst_pending_confirm:1,
		sack_generation:1;

Here only the cached socket's slock is held. In the busy-socket case,
the process context that owns the socket can update those bits at the
same time.

In the migrated case, code running under the new socket's lock can do
the same. Two examples are sctp_transport_free() setting
transport->dead = 1 and sctp_assoc_sync_pmtu() clearing pmtu_pending.

Could this read-modify-write of the bitfield word lose a concurrent
update to one of the other bits, such as transport->dead?

The busy-socket form of this race goes back to the original SCTP code.
This patch adds the migrated case as a second way into the same branch.
Before the patch, that case did full PMTU and retransmit processing
under the wrong lock, so the patch reduces this exposure rather than
creating it.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261120035521.2098757-1-pkfxxxing%40gmail.com
