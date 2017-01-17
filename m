From: Julian Cordes <julian.cordes@gmail.com>
Date: Tue, 17 Jan 2017 13:07:52 +0000
Subject: Issue with Forward-TSN-Chunks containing high cum_tsn
Message-Id: <20170117130752.GB6494@aomx-netbook>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="QTprm0S8XgL7H0Dt"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When a FORWARD-TSN-Chunk with a relative high cum-tsn-value is injected
then the linux kernel ignores this valid FORWARD-TSN-Chunk.
It should instead send an SACK-Chunk where the cum_tsn is equal to the
cum_tsn specified in the FORWARD-TSN.

Testscript available at:
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/receiver-side-implementation-11.pkt

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJYfhcoAAoJEAvjb6G8Rb/jTfcIAImF2GDSwfyarA8IXQxaQ+pN
gq3cvQXFBDCZ7snpj7iCiEAJtKUgb5d3juarEBc0J10TRjNwrWutdYNYdpGTP3BI
6pXvodVmoVhyhl7LYqDG9vSAJ5hsmV8K/AJumjsS+lIL5n+wUI1+e6HfeyC2/l/c
aY18JeePeX91nyQKv6Z9WjtpHaMMOXkD0I/OF+t8ru3jPi8FpSHNd3D2a6JxVvuz
T5ZN/G7Ac+gmes6x4dRg7iSfa5ta62MAkC/9AtMNBLwpSEGNe1/glScMdf1UjJEx
PPAKd3J6hVqlgT7dF1TOib8Rs3Q/B8qFHvdoMXlHhBl0w/QDyQOll+GFISxMCa0=
=j4FW
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
