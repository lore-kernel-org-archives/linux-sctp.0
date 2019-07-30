From: Qian Cai <cai@lca.pw>
Date: Tue, 30 Jul 2019 13:18:24 +0000
Subject: Re: [PATCH] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Message-Id: <1564492704.11067.28.camel@lca.pw>
List-Id: <linux-sctp.vger.kernel.org>
References: <1564431838-23051-1-git-send-email-cai@lca.pw>
         <91237fd501de4ab895305c4d5666d822@AcuMS.aculab.com>
In-Reply-To: <91237fd501de4ab895305c4d5666d822@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: David Laight <David.Laight@ACULAB.COM>, "davem@davemloft.net" <davem@davemloft.net>
Cc: "vyasevich@gmail.com" <vyasevich@gmail.com>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>, "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, 2019-07-30 at 09:01 +0000, David Laight wrote:
> From: Qian Cai
> > Sent: 29 July 2019 21:24
> 
> ..
> > To fix this, "struct sockaddr_storage" needs to be aligned to 4-byte as
> > it is only used in those packed sctp structure which is part of UAPI,
> > and "struct __kernel_sockaddr_storage" is used in some other
> > places of UAPI that need not to change alignments in order to not
> > breaking userspace.
> > 
> > One option is use typedef between "sockaddr_storage" and
> > "__kernel_sockaddr_storage" but it needs to change 35 or 370 lines of
> > codes. The other option is to duplicate this simple 2-field structure to
> > have a separate "struct sockaddr_storage" so it can use a different
> > alignment than "__kernel_sockaddr_storage". Also the structure seems
> > stable enough, so it will be low-maintenance to update two structures in
> > the future in case of changes.
> 
> Does it all work if the 8 byte alignment is implicit, not explicit?
> For instance if unnamed union and struct are used eg:
> 
> struct sockaddr_storage {
> 	union {
> 		void * __ptr;  /* Force alignment */
> 		struct {
> 			__kernel_sa_family_t	ss_family;		/*
> address family */
> 			/* Following field(s) are implementation specific */
> 			char	__data[_K_SS_MAXSIZE - sizeof(unsigned
> short)];
> 					/* space to achieve desired size, */
> 					/* _SS_MAXSIZE value minus size of
> ss_family */
> 		};
> 	};
> };
> 
> I suspect unnamed unions and structs have to be allowed by the compiler.

I believe this will suffer the same problem in that will break UAPI,

https://lore.kernel.org/lkml/20190726213045.GL6204@localhost.localdomain/
