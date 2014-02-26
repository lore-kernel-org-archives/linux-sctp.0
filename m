From: "Roger Nyberg" <roger.nyberg@aastra.com>
Date: Wed, 26 Feb 2014 07:27:01 +0000
Subject: Why is not const used for parameters in the socket API?
Message-Id: <D7BA2F9242E12945A40DB1D20344484413C3DD3D@stomail01.se.aastra.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Why isn't const used in the socket API to make it clearer?
Example:
 
int sctp_sendmsg(int s, const void *msg, size_t len, struct sockaddr
*to,
                 socklen_t tolen, uint32_t ppid, uint32_t flags,
                 uint16_t stream_no, uint32_t timetolive, uint32_t
context);

If i am not missing something, i guess the "struct sockaddr *to" could
be const (that is: "const struct sockaddr *to").

Please use const for every paramater where it is possible. This makes
usage simpler. There are more functions than the (sctp_sendmsg) where
parameters can const.

/Roger
