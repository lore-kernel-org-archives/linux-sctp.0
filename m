From: Thomas Graf <tgraf@suug.ch>
Date: Thu, 06 Dec 2012 19:25:03 +0000
Subject: [PATCH 0/2 v2] sctp: RCU protection when accessing assoc members for procfs
Message-Id: <cover.1354821623.git.tgraf@suug.ch>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com

@Dave: This is a respin of the following patches:
  [PATCH] sctp: proc: protect bind_addr->address_list accesses with rcu_read_lock()
  [PATCH] sctp: Add RCU protection to assoc->transport_addr_list

Thomas Graf (2):
  sctp: proc: protect bind_addr->address_list accesses with
    rcu_read_lock()
  sctp: Add RCU protection to assoc->transport_addr_list

 include/net/sctp/structs.h |  2 ++
 net/sctp/associola.c       |  6 +++---
 net/sctp/proc.c            | 21 ++++++++++++++++++---
 net/sctp/transport.c       | 18 +++++++++++++-----
 4 files changed, 36 insertions(+), 11 deletions(-)

-- 
1.7.11.7

