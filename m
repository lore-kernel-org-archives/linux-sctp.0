From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 07 Jun 2020 10:49:39 +0000
Subject: packed structures used in socket options
Message-Id: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Dear all,

since gcc uses -Werror=ADdress-of-packed-member, I get warnings for my vari=
ant
of packetdrill, which supports SCTP.

Here is why:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/inc=
lude/uapi/linux/sctp.h?h=3Dv5.7
contains:

struct sctp_paddrparams {
	sctp_assoc_t		spp_assoc_id;
	struct sockaddr_storage	spp_address;
	__u32			spp_hbinterval;
	__u16			spp_pathmaxrxt;
	__u32			spp_pathmtu;
	__u32			spp_sackdelay;
	__u32			spp_flags;
	__u32			spp_ipv6_flowlabel;
	__u8			spp_dscp;
} __attribute__((packed, aligned(4)));

This structure is only used in the IPPROTO_SCTP level socket option SCTP_PE=
ER_ADDR_PARAMS.
Why is it packed?

Accessing spp_address, spp_pathmtu, spp_sackdelay, spp_flags, and spp_ipv6_=
flowlabel
results in warnings related to -Werror=ADdress-of-packed-member.

Am I supposed to access these fields via memcpy only?

Please note that a similar problem exists also with other structures in tha=
t file, I
used struct sctp_paddrparams as an example.

Best regards
Michael
