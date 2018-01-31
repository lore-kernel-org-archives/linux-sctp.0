From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 31 Jan 2018 07:23:30 +0000
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in sctp_stream_free
Message-Id: <20180130232334.GL4000@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a113fb1dcbf88120560cbbd81@google.com>
 <20171221131333.GO6122@localhost.localdomain>
 <CADvbK_cpsybMFLfjdQoNAwsJtaFprUYHX+2-eWXbUTKEjGh1-w@mail.gmail.com>
 <20180130230350.tcrrr4gqyja3edwo@gmail.com>
In-Reply-To: <20180130230350.tcrrr4gqyja3edwo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, syzbot <bot+5a73b85ba48546cea8ed105946d67a37b4495724@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Tue, Jan 30, 2018 at 03:03:50PM -0800, Eric Biggers wrote:
> On Fri, Dec 22, 2017 at 01:31:26PM +0800, Xin Long wrote:
> > On Thu, Dec 21, 2017 at 9:13 PM, Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > > On Wed, Dec 20, 2017 at 12:51:01PM -0800, syzbot wrote:
> > >
> > > from the log:
> > > [   89.451366] FAULT_INJECTION: forcing a failure.^M
> > > [   89.451366] name failslab, interval 1, probability 0, space 0,
> > > times 0^M
> > > [   89.451374] CPU: 0 PID: 17287 Comm: syz-executor2 Not tainted
> > > +4.15.0-rc3-next-20171214+ #67^M
> > > [   89.451377] Hardware name: Google Google Compute Engine/Google
> > > Compute Engine, BIOS
> > > +Google 01/01/2011^M
> > > [   89.451380] Call Trace:^M
> > > [   89.451395]  dump_stack+0xe9/0x14b^M
> > > [   89.451408]  should_fail+0x1e5/0x220^M
> > > [   89.451419]  should_failslab+0x73/0x90^M
> > > [   89.451428]  __kmalloc+0x63/0x730^M
> > > [   89.451439]  ? rcu_read_lock_sched_held+0x74/0x80^M
> > > [   89.451446]  ? __kmalloc+0x4ac/0x730^M
> > > [   89.451452]  ? sctp_stream_alloc_in+0x2f/0x100^M
> > > [   89.451464]  sctp_stream_alloc_in+0x2f/0x100^M
> > > [   89.451473]  sctp_stream_init+0xfa/0x140^M
> > > [   89.451485]  sctp_process_init+0x676/0xc50^M
> > >
> > > this is what caused the panic later, because in the error path we free
> > > out but don't zero outcnt. This patch should fix it. Can you please
> > > try it? Thanks
> > >
> > > ----8<---
> > >
> > > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > > index 06b644dd858c..50ab09029f00 100644
> > > --- a/net/sctp/stream.c
> > > +++ b/net/sctp/stream.c
> > > @@ -184,6 +184,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
> > >         sched->free(stream);
> > >         kfree(stream->out);
> > >         stream->out = NULL;
> > > +       stream->outcnt = 0;
> > >  out:
> > >         return ret;
> > >  }
> > 
> > In case it can't be verified due to no reproducer yet, I modified some
> > code in sctp_stream_init() to confirm Marcelo's deduction:
> > -       i = sctp_stream_alloc_in(stream, incnt, gfp);
> > +       i = 1;
> >         if (i) {
> >                 ret = -ENOMEM;
> >                 goto free;
> > 
> > And got the same call trace as the mail:
> > 
> > [  301.488065] BUG: unable to handle kernel NULL pointer dereference
> > at 0000000000000008
> > [  301.488618] IP: sctp_stream_free+0x2c/0x60 [sctp]
> > [  301.488928] PGD 59a3b067 P4D 59a3b067 PUD 5994e067 PMD 0
> > [  301.489372] Oops: 0000 [#1] SMP
> > [...]
> > [  301.497647] Call Trace:
> > [  301.497812]  <IRQ>
> > [  301.497955]  sctp_association_free+0xb8/0x210 [sctp]
> > [  301.498306]  sctp_sf_do_5_1B_init+0x1c4/0x360 [sctp]
> > [  301.498654]  sctp_do_sm+0x9a/0x2d0 [sctp]
> > [  301.498921]  ? sctp_has_association+0x130/0x130 [sctp]
> > [  301.499301]  ? kernel_text_address+0xba/0xe0
> > [  301.499615]  ? check_usage_backwards+0x88/0x150
> > [  301.499911]  ? __lock_acquire+0x280/0x1080
> > [  301.500200]  ? sctp_endpoint_lookup_assoc+0x95/0x140 [sctp]
> > [  301.500593]  sctp_endpoint_bh_rcv+0x11e/0x220 [sctp]
> > [  301.500923]  sctp_rcv+0x9f5/0xbe0 [sctp]
> > 
> > And Marcelo's patch could fix it.
> > 
> > Since the "free:" part only works for if (i), maybe the patch can also do:
> >         if (i) {
> >                 sched->free(stream);
> >                 kfree(stream->out);
> >                 stream->out = NULL;
> >                 stream->outcnt = 0;
> > 
> >                 ret = -ENOMEM;
> >                 goto out;
> >         }
> > 
> > and remove the "free:" path.
> 
> This crash seems to have stopped occurring now.  I presume it was fixed by the
> following commit, so let's tell syzbot to close the bug:

Yes, thanks Eric.

> 
> #syz fix: sctp: fix error path in sctp_stream_init
