From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Mar 2019 16:07:34 +0000
Subject: [PATCH net] selinux: add the missing walk_size + len check in selinux_sctp_bind_connect
Message-Id: <1e5accb3a4a5575ada1dbdfc6e5d9e4358131f83.1552061254.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux@vger.kernel.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Paul Moore <paul@paul-moore.com>, Richard Haines <richard_c_haines@btinternet.com>

As does in __sctp_connect(), when checking addrs in a while loop, after
get the addr len according to sa_family, it's necessary to do the check
walk_size + af->sockaddr_len > addrs_size to make sure it won't access
an out-of-bounds addr.

The same thing is needed in selinux_sctp_bind_connect(), otherwise an
out-of-bounds issue can be triggered:

  [14548.772313] BUG: KASAN: slab-out-of-bounds in selinux_sctp_bind_connect+0x1aa/0x1f0
  [14548.927083] Call Trace:
  [14548.938072]  dump_stack+0x9a/0xe9
  [14548.953015]  print_address_description+0x65/0x22e
  [14548.996524]  kasan_report.cold.6+0x92/0x1a6
  [14549.015335]  selinux_sctp_bind_connect+0x1aa/0x1f0
  [14549.036947]  security_sctp_bind_connect+0x58/0x90
  [14549.058142]  __sctp_setsockopt_connectx+0x5a/0x150 [sctp]
  [14549.081650]  sctp_setsockopt.part.24+0x1322/0x3ce0 [sctp]

Fixes: d452930fd3b9 ("selinux: Add SCTP support")
Reported-by: Chunyu Hu <chuhu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 security/selinux/hooks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f0e36c3..dac9bdb 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5120,6 +5120,9 @@ static int selinux_sctp_bind_connect(struct sock *sk, int optname,
 			return -EINVAL;
 		}
 
+		if (walk_size + len > addrlen)
+			return -EINVAL;
+
 		err = -EINVAL;
 		switch (optname) {
 		/* Bind checks */
-- 
2.1.0
