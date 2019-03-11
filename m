From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 11 Mar 2019 23:49:42 +0000
Subject: Re: [PATCH net] selinux: add the missing walk_size + len check in selinux_sctp_bind_connect
Message-Id: <20190311234942.GG13515@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1e5accb3a4a5575ada1dbdfc6e5d9e4358131f83.1552061254.git.lucien.xin@gmail.com>
 <20190308170838.GF13515@localhost.localdomain>
 <CAHC9VhSdkFORw88rusQ6Kzr3zFX9HB_GNkrbB2LViqOb1ozUzg@mail.gmail.com>
 <CAHC9VhSy0X1Pz+C8UqpiU32obSMZoBASzoP543qbLLWGSxYEOA@mail.gmail.com>
In-Reply-To: <CAHC9VhSy0X1Pz+C8UqpiU32obSMZoBASzoP543qbLLWGSxYEOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Moore <paul@paul-moore.com>
Cc: Xin Long <lucien.xin@gmail.com>, selinux@vger.kernel.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Richard Haines <richard_c_haines@btinternet.com>

On Mon, Mar 11, 2019 at 04:11:32PM -0400, Paul Moore wrote:
> On Fri, Mar 8, 2019 at 9:47 PM Paul Moore <paul@paul-moore.com> wrote:
> > On Fri, Mar 8, 2019 at 12:08 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > > On Sat, Mar 09, 2019 at 12:07:34AM +0800, Xin Long wrote:
> > > > As does in __sctp_connect(), when checking addrs in a while loop, after
> > > > get the addr len according to sa_family, it's necessary to do the check
> > > > walk_size + af->sockaddr_len > addrs_size to make sure it won't access
> > > > an out-of-bounds addr.
> > > >
> > > > The same thing is needed in selinux_sctp_bind_connect(), otherwise an
> > > > out-of-bounds issue can be triggered:
> > > >
> > > >   [14548.772313] BUG: KASAN: slab-out-of-bounds in selinux_sctp_bind_connect+0x1aa/0x1f0
> > > >   [14548.927083] Call Trace:
> > > >   [14548.938072]  dump_stack+0x9a/0xe9
> > > >   [14548.953015]  print_address_description+0x65/0x22e
> > > >   [14548.996524]  kasan_report.cold.6+0x92/0x1a6
> > > >   [14549.015335]  selinux_sctp_bind_connect+0x1aa/0x1f0
> > > >   [14549.036947]  security_sctp_bind_connect+0x58/0x90
> > > >   [14549.058142]  __sctp_setsockopt_connectx+0x5a/0x150 [sctp]
> > > >   [14549.081650]  sctp_setsockopt.part.24+0x1322/0x3ce0 [sctp]
> > > >
> > > > Fixes: d452930fd3b9 ("selinux: Add SCTP support")
> > > > Reported-by: Chunyu Hu <chuhu@redhat.com>
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > >
> > > Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> >
> > Thanks, this patch looks good to me.
> >
> > > Paul, how can we get this into -stable trees? SELinux process may be
> > > different from -net trees.
> >
> > For patches that warrant inclusion in -stable, I merge them into the
> > current selinux/stable-X.Y and send it up to Linus once it passes some
> > basic sanity tests.  Since we're still only half-way through the merge
> > window, and this is an obvious bug fix, I think this qualifies as
> > -stable material.
> >
> > I'm traveling at the moment with not-so-great connectivity, but I'll
> > get this merged and verified early next week.
> 
> FYI, I just merged this into selinux/stable-5.1.  Assuming it tests
> okay (and I can't imagine it would cause a regression), I'll send it
> to Linus tomorrow.

Thanks Paul.

  Marcelo
