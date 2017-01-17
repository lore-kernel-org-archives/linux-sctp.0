From: Julian Cordes <julian.cordes@gmail.com>
Date: Tue, 17 Jan 2017 13:06:48 +0000
Subject: Issues on handshake with PR-SCTP
Message-Id: <20170117130648.GA6494@aomx-netbook>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When one side of an association does not support PR-SCTP and does not
announce the support with the FORWARD-TSN-Supported- Parameter in the
INIT-Chunk or INIT-ACK chunk during the handshake there are two issues:

If the peer does not include the FORWARD-TSN-Supported-Parameter in the
INIT-Chunk and later sends an FORWARD-TSN-Chunk, then the linux kernel
does not respond with an ERROR-Chunk like defined in https://tools.ietf.org/html/rfc3758#section-3.3.1.
It instead silently discards the FORWARD-TSN-Chunk.

Testscript available at:
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/handshake-with-forward-tsn/handshake-with-forward-tsn-4.pkt

If the peer does not include the FORWARD-TSN-Supported-Parameter in the
INIT-ACK-Chunk but sends later an FORWARD-TSN-Chunk, then the behaviour
is different. The Forward-TSN-Chunk is processed and an SACK-Chunk is sent
by the linux kernel. This should also be an ERROR-Chunk, because the peer
has not announced support for PR-SCTP.

Testscript available at:
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/handshake-with-forward-tsn/handshake-with-forward-tsn-5.pkt

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJYfhblAAoJEAvjb6G8Rb/jsecIAIzzGgwJsA7mmpo3+e64y6q8
2Zbv7WjLePVCbOxGtMZYG0InI9MqiT3zRZqtG7cdIGKRCyznbzM1bBd3WaTk78ch
pSs8A3fNnE8YY6YC1mYQySf/e6yv6qhIYMvJD9t23uOAIysc/FeMDZBy0TpzWr+N
F1uaQEaAMZO2jakIle0BM0EjzpvAuAFl7UbHF16xqXbZuFS8AS/HYnGzgOPYzJZV
zTp2jk/45h9vNG0X8cS/7hR4cYtF5PkJWfGHgsiDk5YpnbBHeSt2qJABnuIYd5tw
ZTuRdoTRkSloK8s98HlJn25fxocDEr4Ms8OE70uTkjp3ttmwT+RSvEofSA94wLA=
=Jggz
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
