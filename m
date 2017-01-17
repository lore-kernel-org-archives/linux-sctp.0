From: Julian Cordes <julian.cordes@gmail.com>
Date: Tue, 17 Jan 2017 13:10:41 +0000
Subject: Resources not freed when calling sctp_sendmsg() after shutdown()
Message-Id: <20170117131041.GD6494@aomx-netbook>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="n2Pv11Ogg/Ox8ay5"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org


--n2Pv11Ogg/Ox8ay5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Somehow after calling sctp_sendmsg after calling shutdown with SHUT_WR a
resource is not freed anymore.

I can reproduce the following behaviour:
When running for example the following test case
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-tests/ttl-policy/shutdown-14.pkt
on my machine, it succeeds the first time. This means that the test case
worked as expected. But if I run the same test case
on the same machine again then the bind-call in the test-case will fail.
I waited longer than 30 minutes but only a reboot of the operating
system seems to help in this case.

See the following test-cases that all reproduce this issue. All call
sctp_sendmsg after calling shutdown, therefore i suspect
that this is the cause of the issue.

Testscripts available at:
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-tests/ttl-policy/shutdown-14.pkt
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-tests/ttl-policy/shutdown-1.pkt
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-tests/ttl-policy/shutdown-2.pkt
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-received-tests/ttl-policy/shutdown-1.pkt
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-received-tests/ttl-policy/shutdown-2.pkt

--n2Pv11Ogg/Ox8ay5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJYfhfRAAoJEAvjb6G8Rb/jWKwIAJn1UK7lT890dKVTwsQpcW4p
tkOzhnDMBVF5GxcMzpfAPD8fDGJNCPt+8RpaZg9LHZNZL3+YtCQYF+/e6IlynbA9
kx6oD6rHsCEgFNyBZAgGEf+Z3TSODkjBy673NssVgGxNXpcIqGbYlH5JFDLT5D9W
wDaxldaJbjluqY1DSHyAjja2yWpRE9LH+rUZRavQZRhsk+kxDZoIehc2L8yqbHz5
QFmIHJQiTTP737+giSGeqIKrUF/xfZgR72HE1ugAFO1mSaaOzJVkL06f7W+EcKwV
s0WINssAKNHcth3n2G9N+mhOX0OUBWichF1/vDtv0YZc++xys3X/WUtV9cqhxrw=
=AjSC
-----END PGP SIGNATURE-----

--n2Pv11Ogg/Ox8ay5--
