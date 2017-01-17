From: Julian Cordes <julian.cordes@gmail.com>
Date: Tue, 17 Jan 2017 13:08:52 +0000
Subject: Suboptimal handling of packets containing FORWARD-TSN and DATA chunks
Message-Id: <20170117130852.GC6494@aomx-netbook>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="oTHb8nViIGeoXxdp"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

WWhenever receiving packets containing FORWARD-TSN chunks bundled with a
DATA-Chunk the linux kernel sends currently two SACK-Chunks.
This is suboptimal, because after processing both received chunks, it
could send one SACK-Chunk.

 Testscripts available at:
 - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/ordered/ordered-packet-loss-5.pkt
 - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/ordered/ordered-packet-loss-12.pkt
 - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/ordered/ordered-packet-loss-13.pkt
 - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/unordered/unordered-packet-loss-2.pkt
 - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/unordered/unordered-packet-loss-5.pkt
 - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/unordered/unordered-packet-loss-12.pkt


--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJYfhdkAAoJEAvjb6G8Rb/j85cH/0oCV7vQjKxhxZD4dvECTRsi
9Kj6few3yf64/6idVi1WCP/Dvhu6S6bntvwqk+LnQZ/lAMnchGb5ovuFOdmUSduW
PclpjbQRz0JqOzvcNb39w9YpttSdLYCX5jD77PWa9kXk7LMWEy83srz2cBFvYqdR
UZE+vFmsyRRviiPhKk28eofZD0otxJfbCpiSBYw9FvAvGzLyGzO5/ERz49mI5nYT
7NYQF692IDYMnYb+Vmai2eblKgyaWbAhA3G9m7wcp5P7912YXYVZNY0Emm51UCDg
eHxVflMk+GIFXjPqczQj6yQ0ZbUfrgct6fWcd9NkH3XeAXbkQ/5q7IHFlv0smU0=
=pvKc
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--
