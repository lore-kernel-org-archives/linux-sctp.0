From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Wed, 27 Nov 2019 20:50:39 +0000
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191127001313.183170-1-zenczykowski@gmail.com> <20191127131407.GA377783@localhost.localdomain>
In-Reply-To: <20191127131407.GA377783@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, Linux NetDev <netdev@vger.kernel.org>, Sean Tranchetti <stranche@codeaurora.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

On Wed, Nov 27, 2019 at 5:14 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Nov 26, 2019 at 04:13:13PM -0800, Maciej Żenczykowski wrote:
> > From: Maciej Żenczykowski <maze@google.com>
> >
> > and associated inet_is_local_unbindable_port() helper function:
> > use it to make explicitly binding to an unbindable port return
> > -EPERM 'Operation not permitted'.
> >
> > Autobind doesn't honour this new sysctl since:
> >   (a) you can simply set both if that's the behaviour you desire
> >   (b) there could be a use for preventing explicit while allowing auto
> >   (c) it's faster in the relatively critical path of doing port selection
> >       during connect() to only check one bitmap instead of both
> ...
> > If we *know* that certain ports are simply unusable, then it's better
> > nothing even gets the opportunity to try to use them.  This way we at
> > least get a quick failure, instead of some sort of timeout (or possibly
> > even corruption of the data stream of the non-kernel based use case).
>
> This is doable with SELinux today, no?

Perhaps, but SELinux isn't used by many distros, including the servers
where I have nics that steal some ports.  It's also much much
more difficult, requiring a policy, compilers, etc... and it gets even
more complex if you need to dynamically modify the set of ports,
which requires extra tools and runtime permissions.
