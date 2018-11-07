From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 07 Nov 2018 10:01:48 +0000
Subject: Broken sack processing
Message-Id: <5dcd9eb4ccf44ce293a73fb9ec4457cf@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I've a customer trace from a very old system (RHEL 5.7) that shows the
kernel failing to respond to some SACK packets like:

SACK chunk (Cumulative TSN: 3327915808, a_rwnd: 224400, gaps: 12, duplicate TSNs: 0)
Chunk type: SACK (3)
Chunk flags: 0x00
Chunk length: 64
Cumulative TSN ACK: 3327915808
Advertised receiver window credit (a_rwnd): 224400
Number of gap acknowledgement blocks: 12
Number of duplicated TSNs: 0
Gap Acknowledgement for TSN 3327915813 to 3327915814
Gap Acknowledgement for TSN 3327915818 to 3327915818
Gap Acknowledgement for TSN 3327915822 to 3327915838
Gap Acknowledgement for TSN 3327915842 to 3327915852
Gap Acknowledgement for TSN 3327915856 to 3327915858
Gap Acknowledgement for TSN 3327915860 to 3327915864
Gap Acknowledgement for TSN 3327915866 to 3327915866
Gap Acknowledgement for TSN 3327915868 to 3327915869
Gap Acknowledgement for TSN 3327915873 to 3327915877
Gap Acknowledgement for TSN 3327915881 to 3327915892
Gap Acknowledgement for TSN 3327915894 to 3327916102
Gap Acknowledgement for TSN 3327916104 to 3327916172
[Number of TSNs in gap acknowledgement blocks: 337]

Does this ring a bell, any idea how long ago it was fixed?
Not sure why the connection isn't dropped because of the unacked packets?

We probably need to tell the customer how new a kernel they need to
upgrade to - I doubt they'll like anything that isn't on extended support
(aka death row).

RHEL 5.7 is a 2.6.18 kernel, it is a wonder SCTP works at all.
I remember some changes from (about) 2.6.22 that made things better,
then there were further fixes around 3.4.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
