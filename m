From: Andreas Fink <afink@list.fink.org>
Date: Tue, 22 May 2018 06:23:50 +0000
Subject: missing includes?
Message-Id: <09F4AF7E-1095-4F96-B499-4E347218DECD@list.fink.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Debian9 Stretch

the 
	         struct sctp_sndinfo  send_info;

seems not to be defined in

	netinet/sctp.h

it seems however be defined in
 
	linux/sctp.h

but including both headers results in tons of redefinitions.

Also the definition of sctp_sendv is not found anywhere.


Whats the proper approach to use sctp_sndinfo for sctp_sendv()  in this case?


