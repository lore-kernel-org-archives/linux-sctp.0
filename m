From: Florian Westphal <fw@strlen.de>
Date: Mon, 07 Jul 2008 13:13:10 +0000
Subject: SCTP Uninitialized memory warnings
Message-Id: <20080707131310.GG23805@Chamillionaire.breakpoint.cc>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello sctp-developers,

I am seeing two uninizialized memory access warnings in valgrind,
using a recent git codebase:

 Conditional jump or move depends on uninitialised value(s)
    at 0x570E34A: sctp_assoc_sync_pmtu (associola.c:1324)
    by 0x57427DA: sctp_packet_transmit (output.c:403)
    by 0x5710EFF: sctp_outq_flush (outqueue.c:824)
    by 0x5710B88: sctp_outq_uncork (outqueue.c:701)
    by 0x5745262: sctp_cmd_interpreter (sm_sideeffect.c:1548)
    by 0x57444B7: sctp_side_effects (sm_sideeffect.c:976)
    by 0x5744460: sctp_do_sm (sm_sideeffect.c:945)
    by 0x572157D: sctp_primitive_ASSOCIATE (primitive.c:94)
    by 0x5725C04: __sctp_connect (socket.c:1094)
    by 0x57297DC: sctp_connect (socket.c:3297)
    by 0x5638DC8: inet_dgram_connect (af_inet.c:540)
    by 0x574A04D: nsc_soconnect (support.c:324)

[nsc_soconnect is from the network simulation cradle simulator
that runs the sctp code]

associola.c:1324 looks like this (in sctp_assoc_sync_pmtu):

1324                 if (t->pmtu_pending && t->dst) {
1325                         sctp_transport_update_pmtu(t, dst_mtu(t->dst));
1326                         t->pmtu_pending = 0;

The variable that is uninitialized is t->pmtu_pending.

For now, i've silenced this by setting
peer->pmtu_pending = 0; in associola.c:sctp_assoc_add_peer().

The commit 8a4794914f9cf2681235ec2311e189fe307c28c7
("[SCTP] Flag a pmtu change request") suggests this is the right thing to do.

The second is related to the hartbeat timer setup:
 Conditional jump or move depends on uninitialised value(s)
    at 0x575D3A5: mod_timer (timer.c:630)
    by 0x5752B78: sctp_cmd_hb_timers_start (sm_sideeffect.c:555)
    by 0x5754133: sctp_cmd_interpreter (sm_sideeffect.c:1448)
    by 0x5753607: sctp_side_effects (sm_sideeffect.c:976)
    by 0x57535B0: sctp_do_sm (sm_sideeffect.c:945)
    by 0x571E9AE: sctp_endpoint_bh_rcv (endpointola.c:474)
    by 0x573347F: sctp_inq_push (inqueue.c:104)
    by 0x572EF93: sctp_rcv (input.c:256)
    by 0x5689623: ip_local_deliver_finish (ip_input.c:230)
    by 0x5689759: ip_local_deliver (ip_input.c:268)
    by 0x5689CAC: ip_rcv_finish (dst.h:246)
    by 0x568A229: ip_rcv (ip_input.c:440)

This is the relevant code (sm_sideeffect.c:sctp_cmd_hb_timers_start()):

 553         list_for_each_entry(t, &asoc->peer.transport_addr_list, transports) {
 554
 555                 if (!mod_timer(&t->hb_timer, sctp_transport_timeout(t)))
 556                         sctp_transport_hold(t);
 557         }
 558 }

The value of t->hb_timer.expires is not initialized, but evaluated by mod_timer().

Thanks, Florian

PS: I'm not subscribed, please CC me in replies.
-- 
Florian Westphal <fw@strlen.de> // http://www.strlen.de
1024D/F260502D 2005-10-20
Key fingerprint = 1C81 1AD5 EA8F 3047 7555  E8EE 5E2F DA6C F260 502D
