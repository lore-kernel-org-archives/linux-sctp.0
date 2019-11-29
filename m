From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Fri, 29 Nov 2019 20:00:19 +0000
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <CAHo-OowLw93a8P=RR=2jXQS92d118L3bNmBrUfPSBP4CDq_Ctg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
 <20191127131407.GA377783@localhost.localdomain> <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
 <20191127230001.GO388551@localhost.localdomain>
In-Reply-To: <20191127230001.GO388551@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, Linux NetDev <netdev@vger.kernel.org>, Sean Tranchetti <stranche@codeaurora.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

> > Perhaps, but SELinux isn't used by many distros, including the servers
> > where I have nics that steal some ports.  It's also much much
> > more difficult, requiring a policy, compilers, etc... and it gets even
> > more complex if you need to dynamically modify the set of ports,
> > which requires extra tools and runtime permissions.
>
> I'm no SELinux expert, but my /etc/ssh/sshd_config has this nice handy
> comment:
> # If you want to change the port on a SELinux system, you have to tell
> # SELinux about this change.
> # semanage port -a -t ssh_port_t -p tcp #PORTNUMBER

Right, so I'm also not at all an SELinux expert.

But: I run Fedora as my preferred distro of choice and it is of course
SELinux enabled (and has been for many many years now) and I'm aware
of that ssh port magic, precisely because I sometimes run ssh on a
port different than 22.

I'm also working full time on Android, where I bash my head against
SELinux quite regularly ;-)

> The kernel has no specific knowledge of 'ssh_port_t' and all I need to
> do to allow such port, is run the command above.

I don't think that's actually true.  I believe somewhere in the
SELinux policy there is a reference to a set named ssh_port_t, some
binary number assigned to it, and a default set of ports (ie. 22).

semanage, looks up 'ssh_port_t' maps it to some number X and tells the
kernel that port P needs to be added to set X, and it needs super
privileges to do so, because obviously managing the SELinux policy is
about as privileged as you can get.  And then it stores that P should
be in X somewhere on disk so it survives reboot.  I don't know if
along the way it reloaded the entire policy or just a subset.

strace'ing semanage seems to roughly confirm this (although there's
tons and tons of output...)

> No compiler, etc.

The compiler is present on fedora at least.  I don't know if semanage
invokes it or not, obviously at some point it was invoked.

> The distribution would have to have a policy, say,
> 'unbindable_ports_t', and it could work similarly, I suppose, but I
> have no knowledge on this part.

Yes, the OS image has to include 'semanage' and all the selinux
tooling, and has to ship a policy which has the unbindable_ports_t
already defined in it...

But here's I think the fundamental problem with an SELinux approach.
By default SELinux is deny all.  All you can do is grant extra privs.
I'm not aware of a way to actually say system wide disallow X.
'neverallow' is a compile time policy enforcement hack, and isn't
(afaik) translated into anything that's actually given to the kernel.

So really instead you'd need to create a port set for every app -
including a default , and then make sure that whatever port you want
to block is excluded from each of those sets.

ie.
[root@gaia ~]# semanage port -l | egrep '32768|65535'
ephemeral_port_t               tcp      32768-60999
ephemeral_port_t               udp      32768-60999
unreserved_port_t              sctp     1024-65535
unreserved_port_t              tcp      61001-65535, 1024-32767
unreserved_port_t              udp      61001-65535, 1024-32767

You need to iterate through all port sets, and remove port P from each
of them in turn.
(can port sets overlap? not sure... do ports need to be in some set?
perhaps also need to add the port to the unbindable set or something)

It's certainly doable, but it's a *lot* of work.
If you're on Fedora... then this isn't a huge problem, because someone
did most of the work for you already...  But, on any other distro?

And let's not even get started wrt. interactions with network namespaces.

I also don't know of a way to allow changes to selinux for NET_ADMIN
(correct me if I'm wrong),
I also don't immediately know how to do this with /proc settings, but
it seems like it should be achievable either via some additional
patches, or via some clever boot-time network namespace creation
hackery (on Android I imagine the answer would involve some sort of
selinux tagging of the appropriate sysctl file in order to allow netd
to change it).

> On not having SELinux enabled, you got me there. I not really willing
> to enter a "to do SELinux or not" discussion. :-)

:-)

I'm of the opinion that SELinux and other security policy modules
should be reserved for things related to system wide security policy.
Not for things that are more along the lines of 'functionality'.

Also selinux has 'permissive' mode which causes the system to ignore
all selinux access controls (in favour of just logging) and this is
what is commonly used during development (because it's such a pain to
work with).

This could also technically be probably done via bpf syscall filters,
or bpf cgroup hooks...
But those approaches have performance implications and require a huge
amount of machinery and complexity to manage.
