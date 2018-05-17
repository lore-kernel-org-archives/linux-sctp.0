From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 17 May 2018 16:58:27 +0000
Subject: RE: SCTP nailed down connections trouble
Message-Id: <05afbb61b14f4586b7003c210e073127@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
In-Reply-To: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner
> Sent: 16 May 2018 17:29
...
> On the simultaenous open, when you connect to Cisco ITP or the others,
> doesn't it send an Abort right after the INIT request reaches it? If
> they don't, I find it odd.

I thought that simultaenous connect requests (colliding INIT)
were expected to result in an actual connection.

So two hosts can establish a connection by sending INIT (etc)
with both the source and destination port numbers set to the
same (well known) value.

	David

