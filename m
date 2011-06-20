From: Max Matveev <makc@redhat.com>
Date: Mon, 20 Jun 2011 08:36:58 +0000
Subject: Re: [PATCH] Update description of net.sctp.sctp_rmem and net.sctp.sctp_wmem
Message-Id: <19967.1706.245184.263047@regina.usersys.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <19967.385.752160.374716@regina.usersys.redhat.com>
In-Reply-To: <19967.385.752160.374716@regina.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, 20 Jun 2011 16:29:25 +0800, Shan Wei wrote:

 shanwei> I can't open the attachment.
 shanwei> Please include your patch contents in the mail.
 shanwei> So that be convenient to review.

commit 7bc21f45041b9e2619e59c9c1f8a2368f0bb0aa1
Author: Max Matveev <makc@redhat.com>
Date:   Mon Jun 20 18:08:10 2011 +1000

    Update description of net.sctp.sctp_rmem and net.sctp.sctp_wmem tunables
    
    sctp does not use second and third ("default" and "max") values
    of sctp_(r|w)mem tunables. The format is the same and tcp_(r|w)mem
    but the meaning is different so make the documentation explicit to
    avoid confusion.
    
    Signed-off-by: Max Matveev <makc@redhat.com>

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index d3d653a..81734c0 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1465,10 +1465,23 @@ sctp_mem - vector of 3 INTEGERs: min, pressure, max
 	Default is calculated at boot time from amount of available memory.
 
 sctp_rmem - vector of 3 INTEGERs: min, default, max
-	See tcp_rmem for a description.
+	Only the first value ("min") is used, "default" and "max" are
+	ignored and may be removed in the future versions.
+
+	min: Minimal size of receive buffer used by SCTP socket.
+	It is guaranteed to each STCP socket (but not association) even 
+	under moderate memory pressure.
+
+	Default: 1 page
 
 sctp_wmem  - vector of 3 INTEGERs: min, default, max
-	See tcp_wmem for a description.
+	Only the first value ("min") is used, "default" and "max" are
+	ignored and may be removed in the future versions.
+
+	min: Amount of memory reserved for send buffers for SCTP sockets.
+	Each SCTP socket has rights to use it due to fact of its birth.
+
+	Default: 1 page
 
 addr_scope_policy - INTEGER
 	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00


