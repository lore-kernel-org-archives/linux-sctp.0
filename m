From: Davide Caratti <dcaratti@redhat.com>
Date: Tue, 21 Feb 2017 18:51:56 +0000
Subject: Re: Problem on SCTP
Message-Id: <1487703116.2621.69.camel@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+weUFodkkiY=kgHMX+t4fECQhB+PKg2dBKxCBeU7w7MA@mail.gmail.com>
In-Reply-To: <CAFXGft+weUFodkkiY=kgHMX+t4fECQhB+PKg2dBKxCBeU7w7MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Tue, 2017-02-21 at 12:26 +0800, Sun Paul wrote:
> Hi,
>=20
> sorry to get back late, the platform is running on KVM. and this
> problem is resolved by moving to VMware environment, however,  a new
> problem is coming out, we noticed that the HB REQ is being ABORT from
> client.

hello Sun,

I'm working on some issues with SCTP checksums: sometimes the kernel does
not compute CRC32c on forwarded SCTP packets (see
http://www.spinics.net/lists/linux-sctp/msg05666.html); but apparently this
is a scenario where the opposite occurs (i.e. the kernel computes CRC32c
even if when it is not necessary _ see below):

> On Fri, Jan 13, 2017 at 9:19 PM, Michael Tuexen
> <Michael.Tuexen@lurchi.franken.de> wrote:
> >=20
> > >=20
> > > On 13 Jan 2017, at 10:43, Michael Tuexen <Michael.Tuexen@lurchi.frank=
en.de> wrote:
> > >=20
> > > Your router does NOT change any field in the SCTP packet, but the
> > > SCTP checksum was modified from
> > >   Checksum: 0xbaea49e5 (not verified)
> > > to
> > >   Checksum: 0xa9a86d3f (not verified)
> > > At least one of these is wrong.

what Michael says is correct: in case SCTP NAT did not translate port
numbers, the packet CRC32c should not be recomputed, because SCTP checksum
has no pseudo-header. The (RFC) patch below modifies netfilter SCTP NAT to
avoid useless calls to sctp_compute_csum() when source / destination port
is not changed (*).
------ 8< ------------
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -33,6 +33,7 @@
 	       enum nf_nat_manip_type maniptype)
 {
 	sctp_sctphdr_t *hdr;
+	__be16 port_xlate =3D 0;
=20
 	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
@@ -41,14 +42,17 @@
=20
 	if (maniptype =3D NF_NAT_MANIP_SRC) {
 		/* Get rid of src port */
+		port_xlate |=3D hdr->source ^ tuple->src.u.sctp.port;
 		hdr->source =3D tuple->src.u.sctp.port;
 	} else {
 		/* Get rid of dst port */
+		port_xlate |=3D hdr->dest ^ tuple->dst.u.sctp.port;
 		hdr->dest =3D tuple->dst.u.sctp.port;
 	}
=20
 	if (skb->ip_summed !=3D CHECKSUM_PARTIAL) {
-		hdr->checksum =3D sctp_compute_cksum(skb, hdroff);
+		if (port_xlate)
+			hdr->checksum =3D sctp_compute_cksum(skb, hdroff);
 		skb->ip_summed =3D CHECKSUM_NONE;
 	}

------ >8 ------------
Please let me know if it can be useful in your setup.
Thank you in advance,
regards,
--
davide


Notes:
(*) how I tested this: on a two-namespace test setup, a
ncat server is running on namespace nat_test_b and listening for SCTP on=C2=
=A0
eth1 (192.168.111.18:2000). On namespace nat_test_a, ncat client binds to
dummy0 (10.0.0.13) and connects to server through eth0 (192.168.111.17),
where a SNAT rule is configured; eth0 and eth1 are connected through a
switch. The following command is done on the client:

# perf probe -m nf_nat --add sctp_csum_update
# perf probe -m nf_nat --add sctp_csum_combine
# ip netns exec nat_test_a \
  perf record -e '{probe:sctp_csum_combine,probe:sctp_csum_update}' -R -- \
  ncat --sctp -c uname -s 10.0.0.13 -w1 192.168.111.18 2000

9 packets are received by the server:

IP 192.168.111.17.33022 > 192.168.111.18.2000: sctp (1) [INIT]
IP 192.168.111.18.2000 > 192.168.111.17.33022: sctp (1) [INIT ACK]
IP 192.168.111.17.33022 > 192.168.111.18.2000: sctp (1) [COOKIE ECHO]=20
IP 192.168.111.18.2000 > 192.168.111.17.33022: sctp (1) [COOKIE ACK]=20
IP 192.168.111.17.33022 > 192.168.111.18.2000: sctp (1) [DATA]
IP 192.168.111.18.2000 > 192.168.111.17.33022: sctp (1) [SACK]
IP 192.168.111.17.33022 > 192.168.111.18.2000: sctp (1) [SHUTDOWN]=20
IP 192.168.111.18.2000 > 192.168.111.17.33022: sctp (1) [SHUTDOWN ACK]=20
IP 192.168.111.17.33022 > 192.168.111.18.2000: sctp (1) [SHUTDOWN COMPLETE]=
=20

Before applying the patch:

# perf script | wc -l
9

After applying the patch:

# perf script | wc -l
0

