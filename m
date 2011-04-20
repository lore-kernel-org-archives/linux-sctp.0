From: "Kiss, Zoltan (NSN - HU/Budapest)" <zoltan.kiss@nsn.com>
Date: Wed, 20 Apr 2011 12:29:42 +0000
Subject: Lksctp and receiving ancilliary data from IP
Message-Id: <79C4240C13B4C84B910850B96B1B4312026FFF28@DEMUEXC035.nsn-intra.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi,

Recently I wanted to write an application which receives DSCP value from ke=
rnel through recvmsg's ancilliary control data feature, but I had to realiz=
e that despite I've used setsockopt with IP_RECVTOS parameter to achieve th=
is, the buffer contained only SCTP level control data. When I looked into t=
he code, I found that in net/sctp/socket.c::sctp_recvmsg() the necessary li=
nes are commented out:

	if (sp->subscribe.sctp_data_io_event)
		sctp_ulpevent_read_sndrcvinfo(event, msg);
#if 0
	/* FIXME: we should be calling IP/IPv6 layers.  */
	if (sk->sk_protinfo.af_inet.cmsg_flags)
		ip_cmsg_recv(msg, skb);
#endif

I've tried to search about the reasons, but I couldn't find any answers abo=
ut why is this left like this. Is there any special reason? At first look t=
his code snippet looks working, but I suppose it's not an accident why it i=
s not included in the official code.

Thank you for your help,

Kiss Zolt=E1n
