From: Thomas Dreibholz <dreibh@simula.no>
Date: Thu, 17 Oct 2013 16:20:07 +0000
Subject: Re: potential bug on SFR-CACC
Message-Id: <1736507.KZrl4XQOYC@nordmarka.simula.nornet>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="nextPart11643972.rs49uCPTBl"
List-Id: <linux-sctp.vger.kernel.org>
References: <525A728E.8040007@gmail.com>
In-Reply-To: <525A728E.8040007@gmail.com>
To: linux-sctp@vger.kernel.org


--nextPart11643972.rs49uCPTBl
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi Chang,

the first block should find the highest acknowledged TSN. If it is a Ga=
pAck, the=20
receiver may revoke this acknowledgement later.

For the congestion control, it is important to find out whether there h=
ave been=20
*new* acknowledgements. A TSN only counts as new once (when it is ackno=
wledged=20
for the very first time). After that, particularly also when the=20
acknowledgement is revoked (reneging) and the TSN has to be transmitted=
 and=20
acknowledged again, any further acknowledgements of the same TSN do not=
 count=20
any more as "new".


S=F8ndag 13. oktober 2013 12.11.22 skrev Chang:
> Hi all,
> I'm reading the source code of LK-SCTP and find something that I
> couldn't understand on the SFR-CACC feature of LK-SCTP, which might b=
e a
> bug.
>=20
> When a sender receiving a SACK, ***sctp_check_transmitted()*** would =
be
> invoked to update the state variables related to SFR-CACC, including
> ***highest_new_tsn_in_sack*** and ***cacc_saw_newack***.
>=20
> ---------------------------------------------------------
> The scripts to update ***highest_new_tsn_in_sack*** is as follow.
> Function ***sctp_acked*** checks if the tsn is acked(*either*
> *cumulatively* *or* *selectively*) in the sack reply.
> ---------------------------------------------------------
> if(sctp_acked(sack, tsn)) {
>      ......
>      *highest_new_tsn_in_sack  =3D tsn;
>      ......
> }
> ---------------------------------------------------------
> The scripts to upate ***cacc_saw_newack*** is as follow. It checks if=

> the tsn is less/euqal than the *cumulatively* acked TSN in the sack
> reply, which is *INCONSISTENCY* with the abovementioned.
> ---------------------------------------------------------
> if (TSN_lte(tsn, sack_ctsn)) {// sack_ctsn is cumulatively-acked
>      ......
>      if (!tchunk->tsn_gap_acked) {
>          if (transport && sack->num_gap_ack_blocks &&
> q->asoc->peer.primary_path->cacc.changeover_active)
>          transport->cacc.cacc_saw_newack =3D 1;
>      }
>      ......
> }
>=20
> I would appreicate if anyone could confirm this is a work-as-design o=
r a
> bug?
>=20
> Cheers!

--=20
Best regards / Mit freundlichen Gr=FC=DFen / Med vennlig hilsen

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 Thomas Dreibholz

 Simula Research Laboratory
 Simula Innovation AS, Network Systems Group
 Visiting address: Martin Linges vei 17, 1364 Fornebu, Norway
 Mailing address:  P.O.Box 134, 1325 Lysaker, Norway
-----------------------------------------------------------------------=

 E-Mail:     dreibh@simula.no
 Homepage:   http://simula.no/people/dreibh
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--nextPart11643972.rs49uCPTBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlJgDjcACgkQ32BbsHYPLWVkcQCgjZVbPWxMZ16KKmbbQNA2mPYn
RSYAn1ujyK0OH7+77ddv28nxXUejBRQa
=WVZj
-----END PGP SIGNATURE-----

--nextPart11643972.rs49uCPTBl--

