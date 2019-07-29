From: Qian Cai <cai@lca.pw>
Date: Mon, 29 Jul 2019 20:23:58 +0000
Subject: [PATCH] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Message-Id: <1564431838-23051-1-git-send-email-cai@lca.pw>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>

In file included from ./include/linux/sctp.h:42,
                 from net/core/skbuff.c:47:
./include/uapi/linux/sctp.h:395:1: warning: alignment 4 of 'struct
sctp_paddr_change' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:728:1: warning: alignment 4 of 'struct
sctp_setpeerprim' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:727:26: warning: 'sspp_addr' offset 4 in
'struct sctp_setpeerprim' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage sspp_addr;
                          ^~~~~~~~~
./include/uapi/linux/sctp.h:741:1: warning: alignment 4 of 'struct
sctp_prim' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:740:26: warning: 'ssp_addr' offset 4 in
'struct sctp_prim' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage ssp_addr;
                          ^~~~~~~~
./include/uapi/linux/sctp.h:792:1: warning: alignment 4 of 'struct
sctp_paddrparams' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:784:26: warning: 'spp_address' offset 4 in
'struct sctp_paddrparams' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage spp_address;
                          ^~~~~~~~~~~
./include/uapi/linux/sctp.h:905:1: warning: alignment 4 of 'struct
sctp_paddrinfo' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:899:26: warning: 'spinfo_address' offset 4
in 'struct sctp_paddrinfo' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage spinfo_address;
                          ^~~~~~~~~~~~~~

This is because the commit 20c9c825b12f ("[SCTP] Fix SCTP socket options
to work with 32-bit apps on 64-bit kernels.") added "packed, aligned(4)"
GCC attributes to some structures but one of the members, i.e, "struct
sockaddr_storage" in those structures has the attribute,
"aligned(__alignof__ (struct sockaddr *)" which is 8-byte on 64-bit
systems, so the commit overwrites the designed alignments for
"sockaddr_storage".

To fix this, "struct sockaddr_storage" needs to be aligned to 4-byte as
it is only used in those packed sctp structure which is part of UAPI,
and "struct __kernel_sockaddr_storage" is used in some other
places of UAPI that need not to change alignments in order to not
breaking userspace.

One option is use typedef between "sockaddr_storage" and
"__kernel_sockaddr_storage" but it needs to change 35 or 370 lines of
codes. The other option is to duplicate this simple 2-field structure to
have a separate "struct sockaddr_storage" so it can use a different
alignment than "__kernel_sockaddr_storage". Also the structure seems
stable enough, so it will be low-maintenance to update two structures in
the future in case of changes.

Signed-off-by: Qian Cai <cai@lca.pw>
---
 include/linux/socket.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 97523818cb14..301119657125 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -38,7 +38,13 @@ struct linger {
 	int		l_linger;	/* How long to linger for	*/
 };
 
-#define sockaddr_storage __kernel_sockaddr_storage
+struct sockaddr_storage {
+	__kernel_sa_family_t	ss_family;		/* address family */
+	/* Following field(s) are implementation specific */
+	char		__data[_K_SS_MAXSIZE - sizeof(unsigned short)];
+				/* space to achieve desired size, */
+				/* _SS_MAXSIZE value minus size of ss_family */
+} __aligned(4);			/* force desired alignment */
 
 /*
  *	As we do 4.4BSD message passing we use a 4.4BSD message passing
-- 
1.8.3.1
