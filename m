From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 01 Mar 2010 09:07:43 +0000
Subject: [BUG] sctp failed to load transform for hmac(md5)
Message-Id: <4B8B83DF.4090705@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi:

After I update the kernel to the 2.6.33, I got the following error,
Is there something change to the crypto API or some modules
is missing?

[root@RHEL ~]# sctp_test -H 127.0.0.1 -P 8000 -l
local:addr=127.0.0.1, port=3Dirdmi, family=3D2
seed =3D 1267480579

Starting tests...
	socket(SOCK_SEQPACKET, IPPROTO_SCTP)  ->  sk=3D3
	bind(sk=3D3, [a:127.0.0.1,p:irdmi])  --  attempt 1/10
	listen(sk=3D3,backlog=100)


		*** listen:  Function not implemented ***

[root@RHEL ~]# dmesg | tail
SCTP: Hash tables configured (established 2048 bind 2048)
sctp_init_sock(sk: ce63db68)
sctp_init_sock(sk: ceafb8a0)
sctp_setsockopt(sk: ceafb8a0... optname: 11)
sctp_bind(sk: ceafb8a0, addr: ceaa0ed4, addr_len: 16)
sctp_do_bind(sk: ceafb8a0, new addr: 127.0.0.1, port: 0, new port: 8000, le=
n: 16)
sctp_get_port() begins, snum=8000
SCTP: failed to load transform for hmac(md5): -2
sctp_close(sk: 0xceafb8a0, timeout:0)
sctp_destroy_sock(sk: ceafb8a0)


[root@RHEL ~]# cat /proc/crypto=20
name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : rng
seedsize     : 0

name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 2
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : md5
driver       : md5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16


The source code is this:

5576 SCTP_STATIC int sctp_listen_start(struct sock *sk, int backlog)
5577 {
5578         struct sctp_sock *sp =3D sctp_sk(sk);
5579         struct sctp_endpoint *ep =3D sp->ep;
5580         struct crypto_hash *tfm =3D NULL;
5581=20
5582         /* Allocate HMAC for generating cookie. */
5583         if (!sctp_sk(sk)->hmac && sctp_hmac_alg) {
5584                 tfm =3D crypto_alloc_hash(sctp_hmac_alg, 0, CRYPTO_ALG=
_ASYNC);
5585                 if (IS_ERR(tfm)) {
5586                         if (net_ratelimit()) {
5587                                 printk(KERN_INFO
5588                                        "SCTP: failed to load transform=
 for %s: %ld\n",
5589                                         sctp_hmac_alg, PTR_ERR(tfm));
5590                         }
5591                         return -ENOSYS;
5592                 }
5593                 sctp_sk(sk)->hmac =3D tfm;
5594         }


