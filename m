From: Joshua Kinard <kumba@gentoo.org>
Date: Wed, 16 Apr 2014 04:52:10 +0000
Subject: [PATCH]: NULL pointer dereference in sctp_auth_asoc_set_default_hmac
Message-Id: <534E0C7A.9070309@gentoo.org>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------010509070703060909060800"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------010509070703060909060800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi linux-sctp,

I stumbled into a NULL pointer dereference on amd64 and mips when receiving
an INIT chunk containing the HMAC Algorithm Parameter (0x8004) when
net.sctp.auth_enable = 1.

From some quick debugging I did, even if net.sctp.auth_enable = 1, the if
statement on line 448 in net/sctp/auth.c::sctp_auth_init_hmacs() checks
net->sctp.auth_enable and gets '0' back, which causes ep->auth_hmacs to get
set to NULL:

448         if (!net->sctp.auth_enable) {
449                 ep->auth_hmacs = NULL;
450                 return 0;
451         }


Later, the if statement on line 621 in
net/sctp/auth.c::sctp_auth_asoc_set_default_hmac() attempts to access
ep->auth_hmacs without first checking for NULL, which triggers the oops:

620                 /* If this TFM has been allocated, use this id */
621                 if (ep->auth_hmacs[id]) {
622                         asoc->default_hmac_id = id;
623                         break;
624                 }


I am not sure why net->sctp.auth_enable is initially returning '0' when it's
set in sysctl, and verified in /proc/sys/net/sctp/auth_enable.  Adding a
check for NULL on ep->auth_hmacs in the if statement stops the oops from
happening, though I am not sure if this is the correct fix.

Another thing I noticed, is that I cannot trigger the Oops from the
SCTP/DTLS samples on this page:
http://sctp.fh-muenster.de/dtls-samples.html

But if I patch OpenSSH with the SCTP patch below, that does trigger it on
the sshd server machine as soon as I issue 'ssh -z user@host ...'.  I've
looked at both INIT chunks sent out by the respective programs in Wireshark,
but nothing stands out.

OpenSSH SCTP:
https://bugzilla.mindrot.org/show_bug.cgi?id=2016

If anyone's got other ideas to try out, let me know, thanks!

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
4096R/D25D95E3 2011-03-28

"The past tempts us, the present confuses us, the future frightens us.  And
our lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic

--------------010509070703060909060800
Content-Type: text/x-patch;
 name="net_sctp_auth-sctp_auth_asoc_set_default_hmac-NULL.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="net_sctp_auth-sctp_auth_asoc_set_default_hmac-NULL.diff"

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 683c7d1..2244508 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -618,7 +618,7 @@ void sctp_auth_asoc_set_default_hmac(struct sctp_association *asoc,
 			continue;
 
 		/* If this TFM has been allocated, use this id */
-		if (ep->auth_hmacs[id]) {
+		if (ep->auth_hmacs && ep->auth_hmacs[id]) {
 			asoc->default_hmac_id = id;
 			break;
 		}

--------------010509070703060909060800--
