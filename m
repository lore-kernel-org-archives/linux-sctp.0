From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 27 Nov 2019 23:00:01 +0000
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <20191127230001.GO388551@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
 <20191127131407.GA377783@localhost.localdomain>
 <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
In-Reply-To: <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, Linux NetDev <netdev@vger.kernel.org>, Sean Tranchetti <stranche@codeaurora.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

On Wed, Nov 27, 2019 at 12:50:39PM -0800, Maciej Żenczykowski wrote:
> On Wed, Nov 27, 2019 at 5:14 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Tue, Nov 26, 2019 at 04:13:13PM -0800, Maciej Żenczykowski wrote:
> > > From: Maciej Żenczykowski <maze@google.com>
> > >
> > > and associated inet_is_local_unbindable_port() helper function:
> > > use it to make explicitly binding to an unbindable port return
> > > -EPERM 'Operation not permitted'.
> > >
> > > Autobind doesn't honour this new sysctl since:
> > >   (a) you can simply set both if that's the behaviour you desire
> > >   (b) there could be a use for preventing explicit while allowing auto
> > >   (c) it's faster in the relatively critical path of doing port selection
> > >       during connect() to only check one bitmap instead of both
> > ...
> > > If we *know* that certain ports are simply unusable, then it's better
> > > nothing even gets the opportunity to try to use them.  This way we at
> > > least get a quick failure, instead of some sort of timeout (or possibly
> > > even corruption of the data stream of the non-kernel based use case).
> >
> > This is doable with SELinux today, no?
> 
> Perhaps, but SELinux isn't used by many distros, including the servers
> where I have nics that steal some ports.  It's also much much
> more difficult, requiring a policy, compilers, etc... and it gets even
> more complex if you need to dynamically modify the set of ports,
> which requires extra tools and runtime permissions.

I'm no SELinux expert, but my /etc/ssh/sshd_config has this nice handy
comment:
# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER

The kernel has no specific knowledge of 'ssh_port_t' and all I need to
do to allow such port, is run the command above. No compiler, etc.
The distribution would have to have a policy, say,
'unbindable_ports_t', and it could work similarly, I suppose, but I
have no knowledge on this part.

As a reference only,
# semanage port -l
gives a great list of ports that daemons are supposed to be using, and
it supports ranges and so, like:
amqp_port_t                    tcp      15672, 5671-5672
gluster_port_t                 tcp      38465-38469, 24007-24027

On not having SELinux enabled, you got me there. I not really willing
to enter a "to do SELinux or not" discussion. :-)
