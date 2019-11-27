From: David Miller <davem@davemloft.net>
Date: Wed, 27 Nov 2019 22:33:33 +0000
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <20191127.143333.1387731429786481895.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
        <20191127131407.GA377783@localhost.localdomain>
        <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
In-Reply-To: <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: zenczykowski@gmail.com
Cc: marcelo.leitner@gmail.com, netdev@vger.kernel.org, stranche@codeaurora.org, subashab@codeaurora.org, edumazet@google.com, linux-sctp@vger.kernel.org

From: Maciej =AFenczykowski <zenczykowski@gmail.com>
Date: Wed, 27 Nov 2019 12:50:39 -0800

> On Wed, Nov 27, 2019 at 5:14 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
>>
>> On Tue, Nov 26, 2019 at 04:13:13PM -0800, Maciej =AFenczykowski wrote:
>> > From: Maciej =AFenczykowski <maze@google.com>
>> >
>> > and associated inet_is_local_unbindable_port() helper function:
>> > use it to make explicitly binding to an unbindable port return
>> > -EPERM 'Operation not permitted'.
>> >
>> > Autobind doesn't honour this new sysctl since:
>> >   (a) you can simply set both if that's the behaviour you desire
>> >   (b) there could be a use for preventing explicit while allowing auto
>> >   (c) it's faster in the relatively critical path of doing port select=
ion
>> >       during connect() to only check one bitmap instead of both
>> ...
>> > If we *know* that certain ports are simply unusable, then it's better
>> > nothing even gets the opportunity to try to use them.  This way we at
>> > least get a quick failure, instead of some sort of timeout (or possibly
>> > even corruption of the data stream of the non-kernel based use case).
>>
>> This is doable with SELinux today, no?
>=20
> Perhaps, but SELinux isn't used by many distros, including the servers
> where I have nics that steal some ports.  It's also much much
> more difficult, requiring a policy, compilers, etc... and it gets even
> more complex if you need to dynamically modify the set of ports,
> which requires extra tools and runtime permissions.

I can see both sides of this argument, but anyways this is a new features a=
nd
thus net-next material.  It's nice to keep this discussion going, of course,
but if this trends in the positive you still need to resubmit this when
net-next opens back up.

Thanks.
