From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 08 Sep 2017 15:42:21 +0000
Subject: RE: Multiple connections from the same source address.
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DD00717C6@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Michael Tuexen
> Sent: 08 September 2017 16:29
..
> OK, I see. I just double checked. If Linux follows RFC 6458,
> it should be possible to do
> fd = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
> setsockopt(fd, IPPROTO_SCTP, SCTP_REUSE_PORT, &on, sizeof(int));
> and then call bind().
> 
> I can run this kind of program on FreeBSD multiple times in
> parallel, each one talking to a different end-point.
> I'm not sure if Linux supports SCTP_REUSE_PORT.

Are you binding to a local address as well as a port?

	David

