From: "Boiteux Frederic" <fboiteux@prosodie.com>
Date: Wed, 03 Dec 2014 16:57:18 +0000
Subject: RE: Problem with a host having an UNREACHABLE address ?
Message-Id: <B8F3375A902A0648BD5D9A5ADDE687B005721F53@cadine.france.prosodie.local>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B005721E0A@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B005721E0A@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

	Hi Vlad,

>> When I start SCTP messages exchanges, the hosts are using the first=20
>> address, which is working, and messages are correctly transmitted. On=20
>> the peer of the failing-IP host, I get notifications that this IP=20
>> address is UNREACHABLE, it's correct. In fact, I get one notification=20
>> each 100ms, but this can probably be setup.

>No, this was an issue that was recently addressed.  See >https://git.kerne=
l.org/cgit/linux/kernel/git/davem/net.git/commit/?id=061079ac0b9be7a578dcd0=
9f7865c2c0d6ac894a

Right. But it's not a big problem to ignore them...

>> The problem is that after some time of message exchanges, about 20=20
>> seconds, the hosts get a LOST notification for the association and no=20
>> message can't be sent anymore until a new association is built.

>Which host gets the LOST notification?

It's the host receiving UNREACHABLE=A0notifications (not the host having a =
failed IP, but its peer). It's why I wondered if association breakage and t=
hese notifications was related.

...

>> is the LOST related to these UNREACHABLE notifications, or should I=20
>> look for other cause ?

>It might be, or it might be related to some transport selection code that =
has seen some good fixes.
> It would be good if you could try this on a recent kernel to see if you s=
till see the issue.

I tested my application on virtual systems having the same kernel/system, a=
nd tried to do the same configuration, but didn't reproduce the problem.

As it's difficult/impossible to upgrade the kernel (without modifying the s=
ystem, and I can't do that), do you think backporting sctp kernel module is=
 a way to test this ?

Anyway, given the 'UNREACHABLE' notifications is a wrong suspect, I'll try =
to do some network packets' capture to try to understand what is going on...

  Many thanks,
             Fred.

