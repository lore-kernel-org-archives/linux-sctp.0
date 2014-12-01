From: "Boiteux Frederic" <fboiteux@prosodie.com>
Date: Mon, 01 Dec 2014 15:49:17 +0000
Subject: sctp with multi-homing : PEER_ADDR_CHANGE event for each address ?
Message-Id: <B8F3375A902A0648BD5D9A5ADDE687B00555F41F@cadine.france.prosodie.local>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

    Hello,

  I'm trying to do SCTP messages between two hosts which have each a networ=
k interface on two different subnets :
     --- net 192.168.1.0/24--=20
    /                                             \
Host1                                 Host2
    \                                            /
      --- net 10.0.0.0/24 ----

And I=A0try to use multi-homing and follow availability of each network acc=
ess.

When Host 1 and Host2 send messages using one network (for example 192.168.=
1.0/24), on both hosts I receive notification of kind PEER_ADDR_CHANGE (wit=
h spc_state value SCTP_ADDR_CONFIRMED) only for the other host's address *o=
n the other network* (in this case :=A010.0.0.0/24), but not for the networ=
k address on which the SCTP=A0message has been sent or received :=A0is it t=
he correct behaviour ? Is the SCTP_COMM_UP state event replace the SCTP_ADD=
R_CONFIRMED for the address actually used for message sending/receiving ?

  Thanks for sharing your knowledge,
    Fred.

