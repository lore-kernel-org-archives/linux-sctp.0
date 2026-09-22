Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAEE556BA5
	for <linux-sctp@vger.kernel.org>; Tue, 22 Sep 2026 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090528; cv=pass; b=JdqiiVhqBsW8AuT4M6+XCqUpxPAyorXwYu1+eGaimnhoS63Wphdoxaj7ugj0OVSReLFpQnUV4wvlFP6ZaiOBmMFOBMS0Drsm5ypAP4OMEKFaDnAMbQ1eDcbwSte/Tpd4yjpzM+rRF3X9vvrCvSNHa3xqVUn+LmhB69tCejPhbPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090528; c=relaxed/simple;
	bh=Ux57whVgmek86Umyip3QwJFc6Zvz2svPkJYNqoOZN04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o3GEKUnnPGYbpn1t5sMbE2wkr0xZScKNxonqGJaSJvyjbWblRj0H96MWiulP9aJ8fnkoYqE4UGliWJz5hnRxW2s+q+Bh6eC2HYqfJXHd7qjbRFns5BqZJnlVanlpRb21cnP63qBmcLfXRCxKlsqvBlw5Y+cRlisFkVCf5/ube7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gw7Zm0Og; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gw7Zm0Og"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469a34908so19512b3a.0
        for <linux-sctp@vger.kernel.org>; Tue, 22 Sep 2026 08:22:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790090526; cv=none;
        d=google.com; s=arc-20260327;
        b=Ib/QKm3wPT3yMTySjOyKp91fYPPQh8wWzlQ6lTIwzX6+U8EGaW5jkUlldSjNGY/MyP
         RDotjvc1PcLTiUeteSIY4R0WLjaajr7OzKjOavYxs4576cDu96FBQcppWc2+VgNzFr9v
         L/gXrLK2szfLlsfO/iHoQPMAtwBNwFCysG53P8jMAh2VMzvxkcGX2wKceUq1bE0A8tqT
         4c6sHUEb0ttVMyVRQ8aIuaDwg7Re2dtheemtMOnVhun43RKxLKRzWnYI5v7sxdmJdhll
         PuuuhpP2hvHb41TBm4HKxWwcMiUSBFx80iqrc/LSJt9RTVHjWEirbExbTkltGJ+yxDDD
         O/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CvfOZgoOtU/thwhhWKuNi2Vuwt2keTuqPas09RuZUtM=;
        fh=cAEx3dDfb2yAFPVMAIUWnrbu2XqJFStYJGpVT280mic=;
        b=NFo+FYNuG9mCjq8q71YTeIyUcpmBmnbfaF20HeyVuVDxkF0NCaPnhZ0LgKmdRPP+2x
         xW+O7udiVtQ7D+eHJmeDpdenscwYW26NlF9TRH+bh5dh4mhAyWRVRKshyyWgYvRZ5Psl
         4UbZGrgHN1BfylhGZCOxySAfWrgIgIACVb6SOivhEUEoelo968PSxmSI0EbwCRycHFWb
         7DOPQlab113D7UrEzfxToMBilp9AhR6XMMcFI4EbSpKF2qpd3IUk0S6nFWrEZtDdZDgb
         sCAerVhKoqBjI5LM6Ba2E6QtjJhUb/qcy/NjrI7KD7OO0Q0Ci8NyWYnZFzN37gBs2Geb
         vBcA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790090526; x=1790695326; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CvfOZgoOtU/thwhhWKuNi2Vuwt2keTuqPas09RuZUtM=;
        b=Gw7Zm0OgiJva8OvI2NtjBX/cKKw8gIOwds6QtftZjdqU7MY0wnms7FRiMLuT07vsjG
         Pyp6lkIHZGaZJ++twN7zm922t5oEv9Mz7JRHa97uFud3qgsltAYmL89+ailcyeYK0ppT
         7bKUnxPHqslOspsjXaxp3YdH/rR3zpCH05CQhgq4zPjSkvKa62VbP2aNfO/KbT5J+mAe
         nrg7s7RB3mdo+91ZHDhXgEYcQe8ZeMjPNcDyjg9uEokM0QecQRCV144FhBOqt6n7szDk
         QPHzG1o/guwNEAYqZe+gOqcXJbghS37F9a2oBaRbCkF+RvhRznwN3NufUmjemZRvfTsK
         olKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090526; x=1790695326;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CvfOZgoOtU/thwhhWKuNi2Vuwt2keTuqPas09RuZUtM=;
        b=u33RGflVDUS8Dws8kOeBIzuky6WnyXrARY9wwn1vGhc4egC6uwSFtKXJM5MOBOPOqM
         fsv7QJ8mBYc9//2xnXqkMbzqunGGUrxjj/m16mplJWp44L+K9EiLCSzPtTegRyfVrvTR
         0WioP+5MGzyFAwDtUYd8wao5BidrxkNt6TMj53WVa8N9umHfvKMUZnnwSx/xeFJjlpAS
         DljHA2hFHrwrfULKy2uMlRCti9vLcJSyQwK0gx5F7hqoPLK7qbvFEUq7p46ZnmM/VQnu
         wz5TBiwsaWNw9dLBn77H/6inje46ADyasv8nMnqX+kd//Z0oFNaQdGOZbiRgphuFNn8k
         Q/ng==
X-Forwarded-Encrypted: i=1; AKwUvBwRU2N2AQpf1l7xYoEd+7lfTmoD/RmVtXajdlJJkiSiZ832KSZkrBd2BojWTfG87sVLHiuknXpAqOBY@vger.kernel.org
X-Gm-Message-State: AFuF++kZ+62lER1mj8i4dhEWoDRsZskE88rkpunJ8OLNIcL+8OfWr+eL
	Rur6+9yqe2hMvgxRhuP3rqN4igT1XZcktJwk+t97fathWiNyWW80CFx3Yrdx8aJbKw26Ee1B4Me
	NhX8xHYYO8f47l5ZkrXQj5Pr/Zk8Dh0U=
X-Gm-Gg: AYBFou0GVMMhw5yZaGSZ4OJtAaLMG3VhP4QNMTaUvkfb87VoK6sNMQ4NocU8BqNTuJC
	7L/ZyWPArAIeSgiEtLWafcLo8orM73Zt4wirm3ItvmyOkBCby9P6+72cIwpEC0ErD9yLZ2hioyL
	TfYnCByACwHajW5JtLGWfaB0nmpgwJk8Q6+9qqOwTRxqMWwMCnAiOG8CZZtGRb6y5MqCwJyiIQ9
	mN/sbhiPySu2zccpWBba5L0hp0BIySUR7L+gBhus4vdRMgHcXYYLRynUoqxIzbAtuUFogoBrgmY
	D47Qjo/43YXWyP2tCMuX5m8l9NyfYBkqyK6nXJzA2lEiNuxiLbMd77WD2LbGuTjRyglSdezG0ae
	SjPOvDn21npcqnM4NBSXAJjGtqUI/Mur61+hB3AO6E7O2QoE+uWULdwQU
X-Received: by 2002:a05:6a00:92a4:b0:874:708d:b62d with SMTP id
 d2e1a72fcca58-87c83c4a1f3mr1664017b3a.34.1790090525563; Tue, 22 Sep 2026
 08:22:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADvbK_eQjfg_-HLT3zJ5Bt5LWbUTx_+fLG5ggLPNY1Ah+sF9GA@mail.gmail.com>
 <20260921093707.1432184-1-ljp1205831794@gmail.com>
In-Reply-To: <20260921093707.1432184-1-ljp1205831794@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 22 Sep 2026 11:21:52 -0400
X-Gm-Features: AcwNN1VaL5YpI7cXSQJvRWkj7ir1pHQpUQ28632JQSb9uVIAxMUZLTctxev2-Pc
Message-ID: <CADvbK_dXMHK=1mzofgCchuhEo2LZ95=P72M+nyEyOTuF5m2egw@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: discard the rest of the packet on a
 stale-cookie error
To: Aohan Mei <ljp1205831794@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, 
	marcelo.leitner@gmail.com, imv4bel@gmail.com, 
	Aohan Mei <henrymei@tencent.com>, TencentOS Corvus AI <corvus@tencent.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 5:37=E2=80=AFAM Aohan Mei <ljp1205831794@gmail.com>=
 wrote:
>
> From: Aohan Mei <henrymei@tencent.com>
>
> When an association is in COOKIE-ECHOED state and the peer sends a
> bundled [ERROR(Stale Cookie)][DATA] packet from one of its non-primary
> addresses, processing the ERROR chunk takes the non-fatal stale-cookie
> retry path sctp_sf_do_5_2_6_stale(), which queues
> SCTP_CMD_DEL_NON_PRIMARY while keeping the association alive.
> sctp_cmd_del_non_primary() removes every non-primary transport -
> including the very transport this packet arrived on, which is still
> referenced by the receive lookup and shared by all chunks of the
> packet via chunk->transport.
>
> sctp_assoc_rm_peer() does redirect asoc->peer.last_data_from away from
> the removed transport, but right afterwards the bundled DATA chunk
> makes sctp_assoc_bh_rcv() re-register
> asoc->peer.last_data_from =3D chunk->transport unconditionally, undoing
> the redirection with the just-removed transport.
>
> Once the packet is done, the receive reference is dropped and the
> transport is RCU-freed, while the surviving association keeps the
> dangling last_data_from.  A later FWD-TSN (or the delayed SACK timer)
> makes sctp_gen_sack() dereference it (->param_flags and friends), and
> sctp_make_sack()/sctp_outq_select_transport() may write to the freed
> object and link it into the live transport list.  This is a
> use-after-free triggerable by any malicious SCTP peer (or a local
> unprivileged user acting as one) with no capabilities required:
>
>   BUG: KASAN: slab-use-after-free in sctp_do_sm+0x498a/0x5660
>   Read of size 4 at addr ffff88800e1e356c by task poc/115
>   Call Trace: sctp_do_sm <- sctp_assoc_bh_rcv <- sctp_inq_push <-
>               sctp_rcv <- ip_protocol_deliver_rcu <- ip_rcv
>   Allocated: sctp_transport_new <- sctp_assoc_add_peer <-
>              sctp_process_init (INIT-ACK processing)
>   Freed: kfree <- sctp_transport_destroy_rcu <- rcu_core
>          (call_rcu queued by sctp_transport_put at end of sctp_rcv)
>   The buggy address is located 364 bytes inside of freed 1024-byte
>   region [ffff88800e1e3400, ffff88800e1e3800), cache kmalloc-1k
>
> Note that commit 03a9d10ecf71 ("sctp: drop a chunk if its transport
> was removed") only covers the window between the receive lookup and
> the chunk processing (e.g. an ASCONF DEL-IP racing the socket backlog);
> here the transport is removed *while* the packet is being processed,
> by an earlier chunk of the same packet, so the drop in sctp_inq_push()
> does not reach this path.  Verified with the bundled [ERROR(Stale
> Cookie)][DATA] + FWD-TSN reproducer: the KASAN report above still
> fires with that commit applied, and is gone with this patch on top.
>
> Fix it by discarding the rest of the packet on this path, as suggested
> by Xin.  After the stale-cookie ERROR has sent the association back to
> COOKIE-WAIT and removed the non-primary transports, the remaining
> chunks of the packet can only run against the restarted handshake
> while referencing the removed arrival transport through
> chunk->transport: besides the last_data_from registration above,
> sctp_cmd_setup_t2() and the sctp_make_*() reply builders would also
> copy that pointer into association-lifetime state that
> sctp_assoc_rm_peer() has already sanitized.  Let the peer retransmit
> them, in line with what sctp_inq_push() does for chunks whose
> transport was removed before processing.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Suggested-by: Xin Long <lucien.xin@gmail.com>
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Cc: stable@vger.kernel.org
> Assisted-by: CodeBuddy:Kimi-K3
> Signed-off-by: Aohan Mei <henrymei@tencent.com>
> ---
>
> Hi Xin,
>
> Thanks a lot for the review and the suggestion.  Implemented in v2:
> SCTP_CMD_DISCARD_PACKET queued at the end of the stale-cookie retry.
>
> Verified with the reproducer: the kprobe trace now shows the ERROR
> chunk still removing the transport (sctp_assoc_rm_peer/
> sctp_transport_free fire as before) but no further chunk of the packet
> being processed, and asoc->peer.last_data_from keeps the redirection
> done by sctp_assoc_rm_peer().  The KASAN use-after-free is gone and
> the association completes the retry handshake normally.
>
> This also takes care of the other same-packet sinks the sashiko review
> pointed out (sctp_cmd_setup_t2() and the sctp_make_*() reply chunks
> copying chunk->transport into association-lifetime state): the
> remaining chunks are now dropped before they can run, in line with
> what sctp_inq_push() does for chunks whose transport was removed
> before processing.
>
> Regarding the cookie-echo restart path the review mentioned
> (sctp_assoc_update() removing the arrival transport mid-packet, with a
> bundled [COOKIE ECHO][SHUTDOWN] reaching SCTP_CMD_SETUP_T2): discarding
> the packet does not look like an option there, as bundling DATA with
> COOKIE-ECHO is a legitimate fast path.  I can look into clearing the
> in-progress chunk's transport on removal, or a loop-level check, as a
> follow-up - please let me know if you'd rather have it handled here.
>
> On the bitfield concern: v2 no longer reads transport->dead at all.
> The race described (sctp_icmp_frag_needed() in softirq doing a
> non-atomic read-modify-write of pmtu_pending racing dead =3D 1) would
> also defeat the existing transport->dead check in sctp_inq_push() from
> 03a9d10ecf71, so it might be worth moving that flag into its own word
> separately.
>
> As for the reproducer: it is a single static binary that plays both
> roles over a TUN device - the victim side is a plain SCTP client
> socket, while the peer side answers the INIT-ACK advertising a primary
> and a non-primary address plus FWD-TSN support, injects the bundled
> [ERROR(Stale Cookie)][DATA] from the non-primary address while the
> association is COOKIE-ECHOED, completes the retry handshake, and sends
> an FWD-TSN one second later to consume the dangling pointer.  It was
> verified on tlinux 6.6.119 and on mainline v7.2-rc6-343, where it
> still fires with 03a9d10ecf71f applied and is clean with this patch on
> top.
>
> Since it is a ready-to-run trigger for the bug, I'd prefer not to post
> it to the public list - would it be OK if I send it to you and Marcelo
> off-list instead?  Happy to share it in whatever way you prefer.
>
> Thanks again!
>
>  net/sctp/sm_statefuns.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 708fa07d5fffc..43ebceb5e15f5 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -2654,6 +2654,8 @@ static enum sctp_disposition sctp_sf_do_5_2_6_stale=
(
>
>         sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(reply));
>
> +       sctp_add_cmd_sf(commands, SCTP_CMD_DISCARD_PACKET, SCTP_NULL());
> +
>         return SCTP_DISPOSITION_CONSUME;
>
>  nomem:
> --
> 2.43.7
>
Acked-by: Xin Long <lucien.xin@gmail.com>
