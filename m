From: Qiujun Huang <anenbupt@gmail.com>
Date: Mon, 16 Mar 2020 16:25:16 +0000
Subject: Re: WARNING: refcount bug in sctp_wfree
Message-Id: <CADG63jDcuBNOVRoRX7oi1YmwuN0g7jpvDB4yNdOxwc13hvoNxA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000088452f05a07621d2@google.com> <000000000000cc985b05a07ce36f@google.com>
 <202003100900.1E2E399@keescook> <20200316155119.GB13004@willie-the-truck>
In-Reply-To: <20200316155119.GB13004@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Will Deacon <will@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>, ardb@kernel.org, davem@davemloft.net, guohanjun@huawei.com, kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, mingo@kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Mon, Mar 16, 2020 at 11:52 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Mar 10, 2020 at 09:01:18AM -0700, Kees Cook wrote:
> > On Tue, Mar 10, 2020 at 02:39:01AM -0700, syzbot wrote:
> > > syzbot has bisected this bug to:
> > >
> > > commit fb041bb7c0a918b95c6889fc965cdc4a75b4c0ca
> > > Author: Will Deacon <will@kernel.org>
> > > Date:   Thu Nov 21 11:59:00 2019 +0000
> > >
> > >     locking/refcount: Consolidate implementations of refcount_t
> >
> > I suspect this is just bisecting to here because it made the refcount
> > checks more strict?
>
> Yes, this is the commit that enables full refcount checking for all
> architectures unconditionally, so it's the canary in the coalmine rather
> than the source of the problem.

Yes, I tracked it down. And sent out a fix:
https://lore.kernel.org/netdev/1584330804-18477-1-git-send-email-hqjagain@gmail.com

>
> Will
