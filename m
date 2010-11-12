From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 12 Nov 2010 16:33:15 +0000
Subject: Re: [PATCH 4/10] Fix leaking of kernel heap addresses in net/
Message-Id: <20101112083315.096dfaa3@nehalam>
List-Id: <linux-sctp.vger.kernel.org>
References: <2129857903-1289528127-cardhu_decombobulator_blackberry.rim.net-1506931048-@bda083.bisx.prod.on.blackberry>
	<20101111.182939.258124014.davem@davemloft.net>
	<1289529269.3090.207.camel@Dan>
	<1289546610.17691.1770.camel@edumazet-laptop>
In-Reply-To: <1289546610.17691.1770.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, David Miller <davem@davemloft.net>, socketcan@hartkopp.net, kuznet@ms2.inr.ac.ru, urs.thuermann@volkswagen.de, yoshfuji@linux-ipv6.org, kaber@trash.net, jmorris@namei.org, remi.denis-courmont@nokia.com, pekkas@netcore.fi, sri@us.ibm.com, vladislav.yasevich@hp.com, tj@kernel.org, lizf@cn.fujitsu.com, joe@perches.com, hadi@mojatatu.com, ebiederm@xmission.com, adobriyan@gmail.com, jpirko@redhat.com, johannes.berg@intel.com, daniel.lezcano@free.fr, xemul@openvz.org, socketcan-core@lists.berlios.de, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, torvalds@linux-foundation.org

On Fri, 12 Nov 2010 08:23:30 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 11 novembre 2010 =E0 21:34 -0500, Dan Rosenberg a =E9crit :
> > > I want whatever you replace it with to be equivalent for
> > > object tracking purposes.
> >=20
> > In nearly all of the cases I fixed, the socket inode is already
> > provided, which serves as a perfectly good unique identifier.  Would you
> > prefer I include that information twice?
>=20
> Oh well. Please read this answer carefuly.
>=20
> Some facts to feed your next patch. I am very pleased you changed your
> mind and that we keep useful information in kernel log.
>=20
> 1) Inode numbers are not guaranteed to be unique. Its a 32bit seq
> number, and we dont check another socket inode use the same inode number
> (after 2^32 allocations it can happens)
>=20
> 2) /proc/net/ files can deliver same "line" of information several
> times, because of their implementation.
>=20
> 3) Because of SLAB_DESTROY_BY_RCU, same 'kernel socket pointer' can be
> seen several times in /proc/net/tcp & /proc/net/udp, but really on
> different "sockets"
>=20
> 4) Some good applications use both the socket pointer and inode number
> (tuple) to filter out the [2] problem. Dont break them, please ?
> Anything that might break an application must be at the very least
> tunable.
>=20
> In my opinion, a good thing would be :
>=20
> - Use a special printf() format , aka "secure pointer", as Thomas
> suggested.
>=20
> - Make sure you print different opaque values for two different kernel
> pointers. This is mandatory.
>=20
> - Make sure the NULL pointer stay as a NULL pointer to not let the
> hostile user know your secret, and to ease debugging stuff.
>=20
> - Have security experts advice to chose a nice crypto function, maybe
> jenkin hash. Not too slow would be nice.
>=20
>=20
> static unsigned long securize_kpointers_rnd;
>=20
> At boot time, stick a random value in this variable.
> (Maybe make sure the 5 low order bits are 0)
>=20
> unsigned long opacify_kptr(unsigned long ptr)
> {
> 	if (ptr =3D 0)
> 		return ptr;
> 	if (capable(CAP_NET_ADMIN))
> 		return ptr;
>=20
> 	return some_crypto_hash(ptr, &securize_kpointers_rnd);
> }
>=20
> At least, use a central point, so that we can easily add/change the
> logic if needed.
>=20
> Please provide this patch in kernel/printk.c for initial review, then
> once everybody is OK, you can send one patch for net tree.
>=20
> No need to send 10 patches if we dont agree on the general principle.

Also, the whole idea needs to be under a config option, so only
the paranoid idiots turn it on.


--=20
