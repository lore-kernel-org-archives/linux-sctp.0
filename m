From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 17 Jun 2014 15:36:36 +0000
Subject: RE: [PATCH net-next 0/6] A step closer to RFC 6458 compliancy
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1725DEC9@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403017296-28469-1-git-send-email-geirola@gmail.com>
In-Reply-To: <1403017296-28469-1-git-send-email-geirola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Geir Ola Vaagland' <geirola@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

From: Of Geir Ola Vaagland
> These patches are part of my master thesis project. I have been searching for discrepancies between
> the socket API specificiation in RFC 6458 and the current Linux SCTP implementation. The following
> patches are my humble attempts at getting somewhat closer to compliancy.

I've just been reading RFC 6458 - HTF did it get past the editors and
then published in its current form?
Lots of the structures have implied padding.
There is an embedded 'struct sockaddr_storage' in the middle of
one structure. In some OS this should never actually be instantiated.

Maybe the interface could have been changed in 2001, but not in 2011.

	David



