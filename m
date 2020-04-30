From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Thu, 30 Apr 2020 16:04:22 +0000
Subject: [PATCH 27/37] docs: networking: convert sctp.txt to ReST
Message-Id: <5bbbf00c3aba45253e9d6ba0efeaf34bf2a8450f.1588261997.git.mchehab+huawei@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

- add SPDX header;
- add a document title;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../networking/{sctp.txt => sctp.rst}         | 37 +++++++++++--------
 MAINTAINERS                                   |  2 +-
 3 files changed, 24 insertions(+), 16 deletions(-)
 rename Documentation/networking/{sctp.txt => sctp.rst} (64%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index cd307b9601fa..1761eb715061 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -100,6 +100,7 @@ Contents:
    rds
    regulatory
    rxrpc
+   sctp
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/sctp.txt b/Documentation/networking/sctp.rst
similarity index 64%
rename from Documentation/networking/sctp.txt
rename to Documentation/networking/sctp.rst
index 97b810ca9082..9f4d9c8a925b 100644
--- a/Documentation/networking/sctp.txt
+++ b/Documentation/networking/sctp.rst
@@ -1,35 +1,42 @@
-Linux Kernel SCTP 
+.. SPDX-License-Identifier: GPL-2.0
+
+========+Linux Kernel SCTP
+======== 
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
+Caveats
+=== 
--lksctp can be built as statically or as a module.  However, be aware that 
-module removal of lksctp is not yet a safe activity.   
+- lksctp can be built as statically or as a module.  However, be aware that
+  module removal of lksctp is not yet a safe activity.
 
--There is tentative support for IPv6, but most work has gone towards 
-implementation and testing lksctp on IPv4.   
+- There is tentative support for IPv6, but most work has gone towards
+  implementation and testing lksctp on IPv4.
 
 
 For more information, please visit the lksctp project website:
+
    http://www.sf.net/projects/lksctp
 
 Or contact the lksctp developers through the mailing list:
+
    <linux-sctp@vger.kernel.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index 93e1b253ae51..64789b29c085 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15044,7 +15044,7 @@ M:	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
 L:	linux-sctp@vger.kernel.org
 S:	Maintained
 W:	http://lksctp.sourceforge.net
-F:	Documentation/networking/sctp.txt
+F:	Documentation/networking/sctp.rst
 F:	include/linux/sctp.h
 F:	include/net/sctp/
 F:	include/uapi/linux/sctp.h
-- 
2.25.4
