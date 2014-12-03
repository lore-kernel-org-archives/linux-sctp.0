From: "Boiteux Frederic" <fboiteux@prosodie.com>
Date: Wed, 03 Dec 2014 15:41:20 +0000
Subject: RE: wrong family for IP addresses given by sctp library
Message-Id: <B8F3375A902A0648BD5D9A5ADDE687B005721D15@cadine.france.prosodie.local>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

>> Isn't the returned address simply a IPv6-mapped IPv4 address (::ffff:1.2=
.3.4) ? You can test it with IN6_IS_ADDR_V4MAPPED.

> Yes, it is (I've verified with the provided macro) ! I'll use this macro =
to detect and update provided addresses, thanks !

Testing more carefully, no it actually seems NOT=A0to be IPv4-mapped addres=
ses !

I test it like this :

static struct sockaddr *fix_adr(struct sockaddr *addr)
{
    if (addr->sa_family !=3D AF_INET6) {
        log_info("not an IPv6 address, nothing to do\n");
        return addr;
    }

  struct sockaddr_in6 *addr6 =3D (struct sockaddr_in6 *) &addr;
    if (! IN6_IS_ADDR_V4MAPPED(&(addr6->sin6_addr))) {
        log_warn("@IP v6 '%s' is NOT an IPv4-mapped address !",
                   addr_ntoa(addr));
    }

  // convert it to ipv4 addr...
...
}

I get messages like :
@IP v6 '10.7.11.132' is NOT an IPv4-mapped address!

(the addr_ntoa() function uses getnameinfo(..., NI_NUMERICHOST) to retrieve=
 ascii notation from given sockaddr address).

  I'm not fluent with IPv6 addressing, so I don't know what to check...

	Fred.

