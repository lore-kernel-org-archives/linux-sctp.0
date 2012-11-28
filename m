From: David Miller <davem@davemloft.net>
Date: Wed, 28 Nov 2012 16:12:14 +0000
Subject: Re: [PATCH] sctp: fix -ENOMEM result with invalid user space pointer in sendto() syscall
Message-Id: <20121128.111214.940932171814395302.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1353590596-12216-1-git-send-email-tt.rantala@gmail.com>
In-Reply-To: <1353590596-12216-1-git-send-email-tt.rantala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: tt.rantala@gmail.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, sri@us.ibm.com, davej@redhat.com

From: Tommi Rantala <tt.rantala@gmail.com>
Date: Thu, 22 Nov 2012 15:23:16 +0200

> Consider the following program, that sets the second argument to the
> sendto() syscall incorrectly:
 ...
> We get -ENOMEM:
>=20
>  $ strace -e sendto ./demo
>  sendto(3, NULL, 1, 0, {sa_family=AF_INET, sin_port=3Dhtons(11111), sin_a=
ddr=3Dinet_addr("127.0.0.1")}, 16) =3D -1 ENOMEM (Cannot allocate memory)
>=20
> Propagate the error code from sctp_user_addto_chunk(), so that we will
> tell user space what actually went wrong:
>=20
>  $ strace -e sendto ./demo
>  sendto(3, NULL, 1, 0, {sa_family=AF_INET, sin_port=3Dhtons(11111), sin_a=
ddr=3Dinet_addr("127.0.0.1")}, 16) =3D -1 EFAULT (Bad address)
>=20
> Noticed while running Trinity (the syscall fuzzer).
>=20
> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>

Applied.
