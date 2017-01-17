From: Julian Cordes <julian.cordes@gmail.com>
Date: Tue, 17 Jan 2017 13:11:37 +0000
Subject: Issue with handling too long FORWARD-TSN-SUPPORTED parameter in INIT chunk
Message-Id: <20170117131137.GE6494@aomx-netbook>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="2hMgfIw2X+zgXrFs"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org


--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

An INIT-chunk with a FORWARD-TSN-SUPPORTED parameter having a length of
8 bytes is accepted by the linux kernel.
According to the definition in https://tools.ietf.org/html/rfc3758#page-5
the length of this parameter has to be 4 bytes long, so the
implementation should ideally react with an ABORT.

Testscript available at:
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/error-cases/init-with-forward-tsn-too-long.pkt

--2hMgfIw2X+zgXrFs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJYfhgJAAoJEAvjb6G8Rb/jQM8H/2aXwPQGk+uEirCAQGDdYHEs
y46kd9iyX9sNwUUsD+xBleK3DpgRpUnTqltRXr/4qLEz4JhNDsTmYziDlN5mUdA1
p0ZHWVBjySDkes/EQQUjHdAgGD3/TguQk3gl97kdG/5mGo/FVSWdIs5gaGjKA99R
0Bweh/VvrtZE6RtKCpu0ZmgP579Hbre6/gVm2Kwsv7jZGUHZIWwbGAe7rWKczk1T
6ljP9rdnNhO5SRBow+OazLtlpzRkckpKQTu8Nd2oiOd2ckAHwKOBB4Ar4OhRN/6v
pL4PA6XpSo1rTpMoZ6RSUDdWoDYzaDNoxS81Ryu9764+YRiXjm1KhoRUsRIzdVw=
=P+9e
-----END PGP SIGNATURE-----

--2hMgfIw2X+zgXrFs--
