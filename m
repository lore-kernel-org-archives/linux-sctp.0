From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 20 Feb 2018 16:26:22 +0000
Subject: Re: net: hang in unregister_netdevice: waiting for lo to become free
Message-Id: <20180220162622.GA32068@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+ZyUxeUqEB7q1EHcs4j93mtk9UOBuYhJtcnnc8AfApoLw@mail.gmail.com>
 <CAM_iQpVo0iSXKSR=Qc+7syn77BnhE2R72M2u5YfJF=fBkJHjsw@mail.gmail.com>
 <7fd7e3b3-77b1-0936-b169-d08b946bedc7@iogearbox.net>
 <991243e2-e7c2-f2b2-72b9-d37b0d569b3b@gmail.com>
 <efa5811c-0a01-a4af-ade2-71ef5dbc4eaf@gmail.com>
 <CADvbK_dgEa5g0ynY4F8pX6LuuBwW4e42rK_TFuRhY1=2G5zinw@mail.gmail.com>
 <CADvbK_fKDbUnAkdLrgm6rgj895Gb06AK7HaT0s9VD=zdF+vf6Q@mail.gmail.com>
 <CACT4Y+aV_v6zNS6Ac1u1cB2GZ7QhjNxBeg0FNabUhrndt5CqZw@mail.gmail.com>
 <5973966e-fcd9-7ee5-a9c4-b79d22c1b9dd@nokia.com>
 <CACT4Y+beZ2+O=XdjKCpAkXOTBDgHYfn1JW8kn-TGRrph_RmV7Q@mail.gmail.com>
In-Reply-To: <CACT4Y+beZ2+O=XdjKCpAkXOTBDgHYfn1JW8kn-TGRrph_RmV7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Tommi Rantala <tommi.t.rantala@nokia.com>, Xin Long <lucien.xin@gmail.com>, David Ahern <dsahern@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, Cong Wang <xiyou.wangcong@gmail.com>, David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, syzkaller <syzkaller@googlegroups.com>, Dan Streetman <ddstreet@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Kodanev <alexey.kodanev@oracle.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org

On Tue, Feb 20, 2018 at 09:14:41AM +0100, Dmitry Vyukov wrote:
> On Tue, Feb 20, 2018 at 8:56 AM, Tommi Rantala
> <tommi.t.rantala@nokia.com> wrote:
> > On 19.02.2018 20:59, Dmitry Vyukov wrote:
> >>
> >> On Sat, Feb 3, 2018 at 1:15 PM, Xin Long <lucien.xin@gmail.com> wrote:
> >>>>>
> >>>>> On 1/30/18 1:57 PM, David Ahern wrote:
> >>>>>>
> >>>>>> On 1/30/18 1:08 PM, Daniel Borkmann wrote:
> >>>>>>>
> >>>>>>> On 01/30/2018 07:32 PM, Cong Wang wrote:
> >>>>>>>>
> >>>>>>>> On Tue, Jan 30, 2018 at 4:09 AM, Dmitry Vyukov <dvyukov@google.com>
> >>>>>>>> wrote:
> >>>>>>>>>
> >>>>>>>>> Hello,
> >>>>>>>>>
> >>>>>>>>> The following program creates a hang in unregister_netdevice.
> >>>>>>>>> cleanup_net work hangs there forever periodically printing
> >>>>>>>>> "unregister_netdevice: waiting for lo to become free. Usage count > >>>>>>>>> 3"
> >>>>>>>>> and creation of any new network namespaces hangs forever.
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> Interestingly, this is not reproducible on net-next.
> >>>>>>>
> >>>>>>>
> >>>>>>> The most recent change on netns refcnt was 4ee806d51176 ("net: tcp:
> >>>>>>> close
> >>>>>>> sock if net namespace is exiting") in net/net-next from 5 days ago,
> >>>>>>> maybe
> >>>>>>> fixed due to that?
> >>>>>>>
> >>>>>>
> >>>>>> This appears to be the commit introducing the refcnt leak:
> >>>>>>
> >>>>>> $ git bisect bad
> >>>>>> dbc2b5e9a09e9a6664679a667ff81cff6e5f2641 is the first bad commit
> >>>>>> commit dbc2b5e9a09e9a6664679a667ff81cff6e5f2641
> >>>>>> Author: Xin Long <lucien.xin@gmail.com>
> >>>>>> Date:   Fri May 12 14:39:52 2017 +0800
> >>>>>>
> >>>>>>      sctp: fix src address selection if using secondary addresses for
> >>>>>> ipv6
> >>>>>>
> >>>>>>
> >>>>>> v4.14 is bad. Running bisect in the background while doing other
> >>>>>> things....
> >>>>>>
> >>>>>
> >>>>> Interesting. The commit that avoids the refcnt leak is
> >>>>>
> >>>>> commit 955ec4cb3b54c7c389a9f830be7d3ae2056b9212
> >>>>> Author: David Ahern <dsahern@gmail.com>
> >>>>> Date:   Wed Jan 24 19:45:29 2018 -0800
> >>>>>
> >>>>>      net/ipv6: Do not allow route add with a device that is down
> >>>>>
> >>>>> That commit does not intentionally address the problem so it is just
> >>>>> masking the problematic code introduced by the commit above.
> >>>>
> >>>> Thanks, David A.
> >>>>
> >>>> I'm still on a trip. will look into this asap.
> >>>
> >>>
> >>> Alexey and Tommi already had the patches for this issue on
> >>> both SCTP v4 and v6 dst_get, Thanks.
> >>
> >>
> >>
> >>
> >> Is this meant to be fixed already? I am still seeing this on the
> >> latest upstream tree.
> >>
> >
> > These two commits are in v4.16-rc1:
> >
> > commit 4a31a6b19f9ddf498c81f5c9b089742b7472a6f8
> > Author: Tommi Rantala <tommi.t.rantala@nokia.com>
> > Date:   Mon Feb 5 21:48:14 2018 +0200
> >
> >     sctp: fix dst refcnt leak in sctp_v4_get_dst
> > ...
> >     Fixes: 410f03831 ("sctp: add routing output fallback")
> >     Fixes: 0ca50d12f ("sctp: fix src address selection if using secondary
> > addresses")
> >
> >
> > commit 957d761cf91cdbb175ad7d8f5472336a4d54dbf2
> > Author: Alexey Kodanev <alexey.kodanev@oracle.com>
> > Date:   Mon Feb 5 15:10:35 2018 +0300
> >
> >     sctp: fix dst refcnt leak in sctp_v6_get_dst()
> > ...
> >     Fixes: dbc2b5e9a09e ("sctp: fix src address selection if using secondary
> > addresses for ipv6")
> >
> >
> > I guess we missed something if it's still reproducible.
> >
> > I can check it later this week, unless someone else beat me to it.
> 
> Hi Tommi,
> 
> Hmmm, I can't claim that it's exactly the same bug. Perhaps it's
> another one then. But I am still seeing these:
> 
> [   58.799130] unregister_netdevice: waiting for lo to become free.
> Usage count = 4
> [   60.847138] unregister_netdevice: waiting for lo to become free.
> Usage count = 4
> [   62.895093] unregister_netdevice: waiting for lo to become free.
> Usage count = 4
> [   64.943103] unregister_netdevice: waiting for lo to become free.
> Usage count = 4
> 
> on upstream tree pulled ~12 hours ago.
> 
Can you write a systemtap script to probe dev_hold, and dev_put, printing out a
backtrace if the device name matches "lo".  That should tell us definitively if
the problem is in the same location or not

Neil

> Kernel does not detect this as any kind of BUG/WARNING, so
> syzkaller/syzbot do not catch it as bug and do not try to reproduce,
> localize and report.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
