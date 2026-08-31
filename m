Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7073443D501;
	Mon, 31 Aug 2026 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183457; cv=none; b=Wl+/O5P0lTpJ7Qt4/de2CV27je/IMSC6o++Z5GF0H9/1JQFJDM83QuP/Kb0uDQW6apN9AjX1EJZnUwy2NrBSkLnnSJrE7eKvZvbOj/FAJGeGUvgGc923ke8u62JHXDlhYciB04NcfiwcGMrBjPzdqw+uIij5xUXjeZw2Be1iMNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183457; c=relaxed/simple;
	bh=dLzeRbxNBKsm19Gk9l6YYc+DRokhsNN+nnG7Lq3bBhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZpLwmSHQGKmHHznzCPmFrlrNIoYxHBP6MbT4ijKYQXwyf8SifgPlM0DLkccfTwQp2Df0soIjmGTvivm64/526eeyZTGGiiy19gsO2gjBrreLd9Wq4R1D4pcKln8WdCPrYCb9Hr4R+49AGC46egTQmu0AGDYfIbLyq6jb6dQl83g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6VkjY5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6VkjY5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455451F00A3F;
	Mon, 31 Aug 2026 13:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183454;
	bh=WBA9T8SQtuTJbVa0s3dfG2rAFzmZzFX9rU5YRvEEfoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6VkjY5wHoHdkF7vv78FewB912PpL3kf5OSAkVRiCmSouGKwwXycl4Gciykfaj0l/
	 FBnLXtP61F+sFvshodv40zR24cMFdPw1eQ+UwdlJxjgiMwgsZoBqxuAje21WTAXnSD
	 A8KzIW1kh4SnctFQP7x21TV3T/4wVSUo6t8Vfe3IPVgZ5qMArncnzEyM/JrqpM/FnU
	 DUdZ0MFpellDAo/sPH9T1wCnxpWa9Ueo3e7s3DCqnrfp77hen75B8dV+elssnPwNf5
	 7sbgjAcGPSyuJ02EOT+SauBv8cK3Gt0p+yQGnMWJW6rkHcnDKAi/YEx35HkXWc2K5v
	 5vod1mbcir+iQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuho Choi <dbgh9129@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] sctp: Unwind address notifier registration on failure
Date: Mon, 31 Aug 2026 09:22:14 -0400
Message-ID: <20260831133314.4125787-106-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit c8459ee2fef502d6ef6c063751c33d9ac7943eab ]

sctp_v4_add_protocol() and sctp_v6_add_protocol() register their
address notifiers before registering the SCTP protocol handlers. If
protocol registration fails, the functions return without unregistering
the notifiers.

Unregister the notifiers on the protocol registration failure paths.
Also propagate notifier registration failures instead of ignoring them.

Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608162230.46644-1-dbgh9129@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1: Subject line**

Record: `[sctp]` `[Unwind]` — SCTP subsystem; unwind/cleanup on failure
in `sctp_v4_add_protocol()` and `sctp_v6_add_protocol()`.

**Step 1.2: Tags**

Record:
- **Signed-off-by:** Yuho Choi `<dbgh9129@gmail.com>` (author)
- **Link:**
  https://patch.msgid.link/20260608162230.46644-1-dbgh9129@gmail.com
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (net maintainer
  merge)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: netdev maintainer merge; no syzbot or user bug report

**Step 1.3: Body**

Record:
- **Bug:** Address notifiers are registered before protocol handlers; if
  `inet_add_protocol()` / `inet6_add_protocol()` fails, notifiers are
  not unregistered.
- **Symptom:** Leaked notifier registrations on SCTP module init failure
  paths.
- **Root cause:** Missing error-path cleanup in `sctp_v4_add_protocol()`
  and `sctp_v6_add_protocol()`; notifier registration return values
  ignored.
- **Version info:** None in the message.

**Step 1.4: Hidden bug fix?**

Record: **Yes.** Described as cleanup, but it fixes a real error-path
bug: dangling notifier registrations that can outlive a failed SCTP
module load and point at freed module text/data.

---

## Phase 2: Diff Analysis

**Step 2.1: Inventory**

Record:
- `net/sctp/protocol.c`: +6/−2 (10 net lines in mainline commit)
- `net/sctp/ipv6.c`: +6/−2
- **Functions:** `sctp_v4_add_protocol()`, `sctp_v6_add_protocol()`
- **Scope:** Small, two-file, symmetric fix

**Step 2.2: Code flow**

Record:
- **Hunk 1 (`sctp_v4_add_protocol`):** Before —
  `register_inetaddr_notifier()` return ignored; on
  `inet_add_protocol()` failure, return `-EAGAIN` with notifier still
  registered. After — check notifier registration; on protocol
  registration failure, call `unregister_inetaddr_notifier()`.
- **Hunk 2 (`sctp_v6_add_protocol`):** Same pattern with
  `register_inet6addr_notifier()` / `unregister_inet6addr_notifier()` /
  `inet6_add_protocol()`.
- **Paths affected:** SCTP module init error paths only.

**Step 2.3: Bug mechanism**

Record: **Category:** Error-path resource leak / dangling notifier
registration.
- `sctp_inetaddr_notifier` and `sctp_inet6addr_notifier` are static
  `notifier_block` structures in the SCTP module.
- `sctp_init()` calls these functions during `module_init`; on failure
  it unwinds other resources but does **not** call
  `sctp_v4_del_protocol()` from `err_add_protocol`, and
  `err_v6_add_protocol` only calls `sctp_v4_del_protocol()` (not v6
  notifier cleanup).
- A failed `module_init` unloads the module while a leaked notifier
  remains on the global inet/inet6 notifier chains → callbacks can run
  into freed module memory.

**Step 2.4: Fix quality**

Record: **Obviously correct**, minimal, mirrors the existing
`sctp_v4_del_protocol()` / `sctp_v6_del_protocol()` unwind pattern and
the mac80211 notifier registration pattern in `ieee80211_register_hw()`.
**Regression risk:** Very low; only affects failure paths.

---

## Phase 3: Git History Investigation

**Step 3.1: Blame**

Record:
- `sctp_v4_add_protocol()` notifier pattern: commit `270637abff0cd`
  (Vlad Yasevich, 2008-03-20) — present since ~2.6 era.
- `sctp_v6_add_protocol()` notifier pattern: commit `827bf12236fbaf`
  (Sridhar Samudrala, 2007-05-04).
- Bug has existed in this code for many years.

**Step 3.2: Fixes: tag**

Record: N/A — no Fixes: tag.

**Step 3.3: File history**

Record: Recent SCTP changes in this tree are unrelated (netns teardown,
UAF fixes, races). No duplicate fix for this notifier issue. Fix commit
on master: `c8459ee2fef50` (2026-06-10); **not** in current HEAD
(`6.18.44`).

**Step 3.4: Author**

Record: Yuho Choi — active contributor of similar error-path cleanup
fixes (watchdog PM notifier, OF node leaks, etc.). SCTP maintainers
(Marcelo Leitner, Xin Long) were CC'd per `b4 dig -w`.

**Step 3.5: Dependencies**

Record: **Standalone.** No series dependencies; single v1 patch merged
to net. `git apply --check` against current tree succeeds.

---

## Phase 4: Mailing List and External Research

**Step 4.1: Original discussion**

Record: `b4 dig -c c8459ee2fef50` →
https://patch.msgid.link/20260608162230.46644-1-dbgh9129@gmail.com
`b4 dig -a`: single v1 revision only. Lore fetch blocked by bot
protection; could not read thread replies.

**Step 4.2: Reviewers**

Record: `b4 dig -w` CC'd Marcelo Ricardo Leitner, Xin Long, David S.
Miller, Eric Dumazet, Jakub Kicinski, Paolo Abeni, Simon Horman, linux-
sctp@, netdev@.

**Step 4.3: Bug report**

Record: No external bug report or syzbot link.

**Step 4.4: Related patches**

Record: Standalone; not part of a multi-patch series.

**Step 4.5: Stable list**

Record: Could not search stable@ lore (blocked). No stable nomination
verified from available sources.

---

## Phase 5: Code Semantic Analysis

**Step 5.1: Key functions**

Record: `sctp_v4_add_protocol()`, `sctp_v6_add_protocol()`, callbacks
`sctp_inetaddr_event()`, `sctp_inet6addr_event()`.

**Step 5.2: Callers**

Record:
- `sctp_v4_add_protocol()` — called from `sctp_init()` (`module_init`)
- `sctp_v6_add_protocol()` — called from `sctp_init()` after v4 succeeds
- Not hot-path; module initialization only.

**Step 5.3: Callees**

Record: `register_inetaddr_notifier()` →
`blocking_notifier_chain_register()`; `register_inet6addr_notifier()` →
`atomic_notifier_chain_register()`; `inet_add_protocol()` /
`inet6_add_protocol()` use `cmpxchg` and return `-1` if the protocol
slot is already occupied.

**Step 5.4: Reachability**

Record: Trigger requires SCTP module init failure after notifier
registration — uncommon but possible (e.g. `inet6_add_protocol()` fails
after v4 succeeds; `inet_add_protocol()` fails on occupied
`IPPROTO_SCTP` slot). After failure, any subsequent IPv4/IPv6 address
event can invoke the leaked notifier → **reachable from normal network
interface activity**.

**Step 5.5: Similar patterns**

Record: `net/mac80211/main.c` correctly unwinds notifier registration on
failure (`fail_ifa6` → `unregister_inetaddr_notifier`). SCTP lacked the
same pattern.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1: Buggy code present?**

Record: **Yes.** Tree is `v6.18.44` (`stable/linux-6.18.y`, detached
HEAD). Current code at `net/sctp/protocol.c:1298-1307` and
`net/sctp/ipv6.c:1226-1234` matches the pre-fix state. Fix
`c8459ee2fef50` is **not** an ancestor of HEAD.

**Step 6.2: Backport complications**

Record: **Clean apply** — `git show c8459ee2fef50 | git apply --check`
passes with no conflicts.

**Step 6.3: Related fixes already present?**

Record: None for this notifier unwind issue.

---

## Phase 7: Subsystem Context

**Step 7.1: Subsystem**

Record: **net/sctp** — networking protocol (IMPORTANT; used in
telecom/enterprise, optional `CONFIG_IP_SCTP` module).

**Step 7.2: Activity**

Record: SCTP in 6.18.y receives active stable fixes (UAF, races, netns
teardown); mature subsystem with ongoing maintenance.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1: Who is affected**

Record: Systems with SCTP built as a module (`CONFIG_IP_SCTP=m`) where
module initialization fails after notifier registration but before full
protocol registration completes.

**Step 8.2: Trigger conditions**

Record:
- `register_*addr_notifier()` succeeds, then `inet*_add_protocol()`
  fails (returns `-EAGAIN`)
- More plausible v6 path: v4 fully registered, v6 notifier registered,
  v6 protocol registration fails → `err_v6_add_protocol` cleans v4 but
  leaves v6 notifier registered
- **Likelihood:** Low on typical systems; **not** user-triggerable in
  normal operation, but possible on init failure/retry scenarios

**Step 8.3: Failure mode severity**

Record: Leaked notifier on global chain after failed module unload →
callback into freed module memory on address events → **kernel oops /
use-after-free**. Severity when triggered: **HIGH (CRITICAL)**. Trigger
rarity: **LOW**.

**Step 8.4: Risk-benefit**

Record:
- **Benefit:** Prevents dangling notifier / UAF on error paths; enables
  clean SCTP module reload after init failure
- **Risk:** Very low — 16 lines, error-path only, mirrors established
  kernel patterns
- **Ratio:** Favorable for stable despite rare trigger

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Real bug in long-standing code (since 2007/2008)
- Can cause UAF/kernel crash if module init fails and addresses change
  afterward
- Small, obviously correct, applies cleanly to 6.18.44
- Merged to net with maintainer sign-off
- Matches established notifier registration cleanup patterns (mac80211,
  nf_nat_masquerade)

**Evidence AGAINST backport:**
- No user reports or syzbot reproduction
- Trigger path is SCTP module init failure — uncommon in production
- Impact limited to systems using SCTP as a module

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — logic is straightforward; no
   Tested-by, but maintainer-merged
2. Fixes a real bug? **PASS** — notifier leak on error path
3. Important issue? **PASS** — UAF/crash potential (HIGH when triggered)
4. Small and contained? **PASS** — 2 files, ~16 lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

**Exception category:** Error-path cleanup (not device ID/quirk/docs).

**Decision rationale for 6.18.y:** The buggy code is present, the fix is
minimal and correct, and the failure mode (dangling notifier → UAF on
address events after failed module load) is serious enough for stable
despite low trigger frequency. This is standard stable material for
error-path resource cleanup.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  `git show c8459ee2fef50`
- [Phase 2] Read current `sctp_v4_add_protocol()` /
  `sctp_v6_add_protocol()` in tree; confirmed pre-fix state
- [Phase 2] Read `sctp_init()` error paths (`err_add_protocol`,
  `err_v6_add_protocol`) — v4 notifier not unwound on v4 failure; v6
  notifier not unwound on v6 failure
- [Phase 3] `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- [Phase 3] `git blame` on changed lines — bug present since 2007/2008
- [Phase 3] `merge-base --is-ancestor c8459ee2fef50 HEAD` → fix NOT in
  current tree
- [Phase 3] `git apply --check` with mainline patch → applies cleanly
- [Phase 4] `b4 dig -c c8459ee2fef50` → lore URL found
- [Phase 4] `b4 dig -a` → v1 only
- [Phase 4] `b4 dig -w` → SCTP/netdev maintainers CC'd
- [Phase 4] UNVERIFIED: Lore thread content (Anubis bot blocked fetch)
- [Phase 5] Read `register_inetaddr_notifier()` / `inet_add_protocol()`
  implementations
- [Phase 5] Read `sctp_inetaddr_event()` / notifier block definitions
- [Phase 5] Compared with mac80211 notifier unwind pattern
- [Phase 6] Confirmed buggy code exists at current line numbers in
  6.18.44
- [Phase 8] Assessed failure mode: leaked notifier after failed
  `module_init` → UAF on address events

**YES**

 net/sctp/ipv6.c     | 10 ++++++++--
 net/sctp/protocol.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 7434309785cc5..922b19982d4fe 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1225,11 +1225,17 @@ void sctp_v6_protosw_exit(void)
 /* Register with inet6 layer. */
 int sctp_v6_add_protocol(void)
 {
+	int ret;
+
 	/* Register notifier for inet6 address additions/deletions. */
-	register_inet6addr_notifier(&sctp_inet6addr_notifier);
+	ret = register_inet6addr_notifier(&sctp_inet6addr_notifier);
+	if (ret)
+		return ret;
 
-	if (inet6_add_protocol(&sctpv6_protocol, IPPROTO_SCTP) < 0)
+	if (inet6_add_protocol(&sctpv6_protocol, IPPROTO_SCTP) < 0) {
+		unregister_inet6addr_notifier(&sctp_inet6addr_notifier);
 		return -EAGAIN;
+	}
 
 	return 0;
 }
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 5718328cb8a79..c718dc066f3a9 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1297,12 +1297,18 @@ static void sctp_v4_protosw_exit(void)
 
 static int sctp_v4_add_protocol(void)
 {
+	int ret;
+
 	/* Register notifier for inet address additions/deletions. */
-	register_inetaddr_notifier(&sctp_inetaddr_notifier);
+	ret = register_inetaddr_notifier(&sctp_inetaddr_notifier);
+	if (ret)
+		return ret;
 
 	/* Register SCTP with inet layer.  */
-	if (inet_add_protocol(&sctp_protocol, IPPROTO_SCTP) < 0)
+	if (inet_add_protocol(&sctp_protocol, IPPROTO_SCTP) < 0) {
+		unregister_inetaddr_notifier(&sctp_inetaddr_notifier);
 		return -EAGAIN;
+	}
 
 	return 0;
 }
-- 
2.53.0

