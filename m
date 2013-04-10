From: "Daya, Dilip (Telco Linux)" <dilip.daya@hp.com>
Date: Wed, 10 Apr 2013 21:02:19 +0000
Subject: [PATCH] sctp: Add buffer utilization fields to /proc/net/sctp/assocs
Message-Id: <4BC2A2E3B1AB5441B4415258B8908D4D10DBD103@G2W2530.americas.hpqcorp.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Dilip Daya <dilip.daya@hp.com>

This patch adds the following fields to /proc/net/sctp/assocs output:

	- sk->sk_wmem_alloc      (transmit queue bytes committed)
	- sk->sk_wmem_queued  (persistent queue size)
	- sk->sk_sndbuf              (size of send buffer in bytes)
	- sk->sk_rcvbuf               (size of receive buffer in bytes)

When small DATA chunks containing 136 bytes data are sent the TX_QUEUE 
(assoc->sndbuf_used) reaches a maximum of 40.9% of sk_sndbuf value when
peer.rwnd = 0. This was diagnosed from sk_wmem_alloc value reaching maximum
value of sk_sndbuf.

TX_QUEUE (assoc->sndbuf_used), sk_wmem_alloc and sk_wmem_queued values are
incremented in sctp_set_owner_w() for outgoing data chunks. Having access to
the above values in /proc/net/sctp/assocs will provide a better understanding
of SCTP buffer management.

With patch applied, example output when peer.rwnd = 0

where:
    ASSOC ffff880132298000 is sender
                 ffff880125343000 is receiver

# cat /proc/net/sctp/assocs
 ASSOC           SOCK            STY SST ST  HBKT ASSOC-ID TX_QUEUE RX_QUEUE \
ffff880132298000 ffff880124a0a0c0 2   1   3  29325    1      214656        0 \
ffff880125343000 ffff8801237d7700 2   1   3  36210    2           0   524520 \

UID   INODE LPORT  RPORT LADDRS <-> RADDRS       HBINT   INS  OUTS \
  0   25108 3455   3456  *10.4.8.3 <-> *10.5.8.3  7500     2     2 \
  0   27819 3456   3455  *10.5.8.3 <-> *10.4.8.3  7500     2     2 \

MAXRT T1X  T2X     RTXC sk_wmem_alloc sk_wmem_queued sk_sndbuf sk_rcvbuf
    4   0   0        72      525633         440320      524288    524288
    4   0   0         0           1              0      524288    524288



Signed-off-by: Dilip Daya <dilip.daya@hp.com>
---
 net/sctp/proc.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 7923164..56636db 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -293,10 +293,11 @@ static void * sctp_assocs_seq_start(struct seq_file *seq, loff_t *pos)
    *pos = 0;
 
  if (*pos = 0)
-   seq_printf(seq, " ASSOC     SOCK   STY SST ST HBKT "
-       "ASSOC-ID TX_QUEUE RX_QUEUE UID INODE LPORT "
-       "RPORT LADDRS <-> RADDRS "
-       "HBINT INS OUTS MAXRT T1X T2X RTXC\n");
+   seq_printf(seq, " ASSOC           SOCK            STY SST ST  HBKT "
+       "ASSOC-ID TX_QUEUE RX_QUEUE     UID   INODE LPORT  RPORT "
+       "LADDRS <-> RADDRS                    HBINT   INS  OUTS MAXRT T1X"
+       "  T2X     RTXC sk_wmem_alloc sk_wmem_queued sk_sndbuf"
+       " sk_rcvbuf\n");
 
  return (void *)pos;
 }
@@ -340,7 +341,7 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
    sk = epb->sk;
    seq_printf(seq,
         "%8pK %8pK %-3d %-3d %-2d %-4d "
-        "%4d %8d %8d %7d %5lu %-5d %5d ",
+        "%4d    %8d %8d %7d   %5lu  %-5d %5d ",
         assoc, sk, sctp_sk(sk)->type, sk->sk_state,
         assoc->state, hash,
         assoc->assoc_id,
@@ -353,11 +354,16 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
    sctp_seq_dump_local_addrs(seq, epb);
    seq_printf(seq, "<-> "); 
    sctp_seq_dump_remote_addrs(seq, assoc);
-   seq_printf(seq, "\t%8lu %5d %5d %4d %4d %4d %8d ",
+   seq_printf(seq, "\t%8lu %5d %5d %4d %4d %4d %8d  "
+                   "  %8d       %8d    %8d  %8d",
      assoc->hbinterval, assoc->c.sinit_max_instreams,
      assoc->c.sinit_num_ostreams, assoc->max_retrans,
      assoc->init_retries, assoc->shutdown_retries,
-     assoc->rtx_data_chunks);
+     assoc->rtx_data_chunks,
+     atomic_read(&sk->sk_wmem_alloc),
+     sk->sk_wmem_queued,
+     sk->sk_sndbuf,
+     sk->sk_rcvbuf);
    seq_printf(seq, "\n");
  }
  read_unlock(&head->lock);
-- 
1.5.6.5
