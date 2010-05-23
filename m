From: Andrea Gelmini <andrea.gelmini@gelma.net>
Date: Sun, 23 May 2010 19:56:31 +0000
Subject: [PATCH 076/199] Documentation/networking/sctp.txt: Checkpatch cleanup
Message-Id: <1274644605-25181-35-git-send-email-andrea.gelmini@gelma.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Documentation/networking/sctp.txt:1: ERROR: trailing whitespace
Documentation/networking/sctp.txt:4: ERROR: trailing whitespace
Documentation/networking/sctp.txt:10: ERROR: trailing whitespace
Documentation/networking/sctp.txt:11: ERROR: trailing whitespace
Documentation/networking/sctp.txt:12: ERROR: trailing whitespace
Documentation/networking/sctp.txt:14: ERROR: trailing whitespace
Documentation/networking/sctp.txt:15: ERROR: trailing whitespace
Documentation/networking/sctp.txt:18: ERROR: trailing whitespace
Documentation/networking/sctp.txt:19: ERROR: trailing whitespace
Documentation/networking/sctp.txt:20: ERROR: trailing whitespace
Documentation/networking/sctp.txt:23: ERROR: trailing whitespace
Documentation/networking/sctp.txt:25: ERROR: trailing whitespace
Documentation/networking/sctp.txt:26: ERROR: trailing whitespace
Documentation/networking/sctp.txt:28: ERROR: trailing whitespace
Documentation/networking/sctp.txt:29: ERROR: trailing whitespace
Documentation/networking/sctp.txt:36: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 Documentation/networking/sctp.txt |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/sctp.txt b/Documentation/networking/sctp.txt
index 0c790a7..7a45f00 100644
--- a/Documentation/networking/sctp.txt
+++ b/Documentation/networking/sctp.txt
@@ -1,38 +1,38 @@
-Linux Kernel SCTP 
+Linux Kernel SCTP
 
 This is the current BETA release of the Linux Kernel SCTP reference
-implementation.  
+implementation.
 
 SCTP (Stream Control Transmission Protocol) is a IP based, message oriented,
 reliable transport protocol, with congestion control, support for
 transparent multi-homing, and multiple ordered streams of messages.
 RFC2960 defines the core protocol.  The IETF SIGTRAN working group originally
-developed the SCTP protocol and later handed the protocol over to the 
-Transport Area (TSVWG) working group for the continued evolvement of SCTP as a 
-general purpose transport.  
+developed the SCTP protocol and later handed the protocol over to the
+Transport Area (TSVWG) working group for the continued evolvement of SCTP as a
+general purpose transport.
 
-See the IETF website (http://www.ietf.org) for further documents on SCTP. 
-See http://www.ietf.org/rfc/rfc2960.txt 
+See the IETF website (http://www.ietf.org) for further documents on SCTP.
+See http://www.ietf.org/rfc/rfc2960.txt
 
 The initial project goal is to create an Linux kernel reference implementation
-of SCTP that is RFC 2960 compliant and provides an programming interface 
-referred to as the  UDP-style API of the Sockets Extensions for SCTP, as 
-proposed in IETF Internet-Drafts.    
+of SCTP that is RFC 2960 compliant and provides an programming interface
+referred to as the  UDP-style API of the Sockets Extensions for SCTP, as
+proposed in IETF Internet-Drafts.
 
 
-Caveats:  
+Caveats:
 
--lksctp can be built as statically or as a module.  However, be aware that 
-module removal of lksctp is not yet a safe activity.   
+-lksctp can be built as statically or as a module.  However, be aware that
+module removal of lksctp is not yet a safe activity.
 
--There is tentative support for IPv6, but most work has gone towards 
-implementation and testing lksctp on IPv4.   
+-There is tentative support for IPv6, but most work has gone towards
+implementation and testing lksctp on IPv4.
 
 
 For more information, please visit the lksctp project website:
    http://www.sf.net/projects/lksctp
 
 Or contact the lksctp developers through the mailing list:
-   <lksctp-developers@lists.sourceforge.net> 
+   <lksctp-developers@lists.sourceforge.net>
 
 
-- 
1.7.1.251.gf80a2

