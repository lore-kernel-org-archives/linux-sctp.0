From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 01 Feb 2019 14:15:22 +0000
Subject: [PATCH net] sctp: walk the list of asoc safely
Message-Id: <20190201141522.GA20785@kroah.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

In sctp_sendmesg(), when walking the list of endpoint associations, the
association can be dropped from the list, making the list corrupt.
Properly handle this by using list_for_each_entry_safe()

Fixes: 4910280503f3 ("sctp: add support for snd flag SCTP_SENDALL process in sendmsg")
Reported-by: Secunia Research <vuln@secunia.com>
Tested-by: Secunia Research <vuln@secunia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f93c3cf9e567..65d6d04546ae 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2027,7 +2027,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_transport *transport = NULL;
 	struct sctp_sndrcvinfo _sinfo, *sinfo;
-	struct sctp_association *asoc;
+	struct sctp_association *asoc, *tmp;
 	struct sctp_cmsgs cmsgs;
 	union sctp_addr *daddr;
 	bool new = false;
@@ -2053,7 +2053,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 
 	/* SCTP_SENDALL process */
 	if ((sflags & SCTP_SENDALL) && sctp_style(sk, UDP)) {
-		list_for_each_entry(asoc, &ep->asocs, asocs) {
+		list_for_each_entry_safe(asoc, tmp, &ep->asocs, asocs) {
 			err = sctp_sendmsg_check_sflags(asoc, sflags, msg,
 							msg_len);
 			if (err = 0)
