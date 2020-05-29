From: Christoph Hellwig <hch@lst.de>
Date: Fri, 29 May 2020 12:09:39 +0000
Subject: remove kernel_setsockopt v4
Message-Id: <20200529120943.101454-1-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, netdev@vger.kernel.org

Hi Dave and Marcelo,

now that only the dlm calls to sctp are left for kernel_setsockopt,
while we haven't really made much progress with the sctp setsockopt
refactoring, how about this small series that splits out a
sctp_setsockopt_bindx_kernel that takes a kernel space address array
to share more code as requested by Marcelo.  This should fit in with
whatever variant of the refator of sctp setsockopt we go with, but
just solved the immediate problem for now.

Changes since v3:
 - dropped all the merged patches, just sctp setsockopt left now
 - factor out a new sctp_setsockopt_bindx_kernel helper instead of
   duplicating a small amount of logic

Changes since v2:
 - drop the separately merged kernel_getopt_removal
 - drop the sctp patches, as there is conflicting cleanup going on
 - add an additional ACK for the rxrpc changes

Changes since v1:
 - use ->getname for sctp sockets in dlm
 - add a new ->bind_add struct proto method for dlm/sctp
 - switch the ipv6 and remaining sctp helpers to inline function so that
   the ipv6 and sctp modules are not pulled in by any module that could
   potentially use ipv6 or sctp connections
 - remove arguments to various sock_* helpers that are always used with
   the same constant arguments
