From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 20 Mar 2017 17:49:55 +0000
Subject: SCTP MSG_MORE code
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DCFFB5839@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

Something needs to be done with SCTP MSG_MORE before the end of the rc cycle.
The current code is definitely broken.

I objected to the last 'fix' patch because it clears the flag is a place where
I don't think it is necessary to do so - so could generate extra ethernet frames.

	David

