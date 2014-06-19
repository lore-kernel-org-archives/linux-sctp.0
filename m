From: 'Tejun Heo' <tj@kernel.org>
Date: Thu, 19 Jun 2014 13:46:56 +0000
Subject: Re: [PATCH net-next 5/5] net: sctp: fix incorrect type in gfp initializer
Message-Id: <20140619134656.GJ11042@htj.dyndns.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1402497297-27100-1-git-send-email-dborkman@redhat.com>
 <1402497297-27100-6-git-send-email-dborkman@redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D1725AF78@AcuExch.aculab.com>
 <5398712C.3000801@redhat.com>
 <CAADnVQLyNCUU0+onEHbygVE-M3WK59uB=NoKWi1V4Rh+6AZkVA@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1725B905@AcuExch.aculab.com>
 <20140618183058.GC11042@htj.dyndns.org>
 <063D6719AE5E284EB5DD2968C1650D6D1725EF63@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1725EF63@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Alexei Starovoitov' <alexei.starovoitov@gmail.com>, Daniel Borkmann <dborkman@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

On Thu, Jun 19, 2014 at 08:13:48AM +0000, David Laight wrote:
> Apart from the fact that it is badly optimised.
> 
> If z() were an empty #define rather than an empty inline function
> then you'd end up with the:
> 	if (preload)
> 		z();
> being completely optimised away.

This isn't that hot a path and I don't wanna change it to work around
compiler behavior at this level.  If you care about it, please report
it to the compiler people.

Thanks.

-- 
tejun
