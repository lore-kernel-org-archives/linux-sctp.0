From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 13 Feb 2019 08:27:56 +0000
Subject: Re: KASAN: use-after-free Read in sctp_outq_tail
Message-Id: <CACT4Y+ZLEPummCf==B30ucY8cdoOx8FWohnUn_UMoWmwwTL87g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000002015db0581b71858@google.com> <20190212191920.GI10665@localhost.localdomain>
In-Reply-To: <20190212191920.GI10665@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladislav Yasevich <vyasevich@gmail.com>

On Tue, Feb 12, 2019 at 8:19 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Feb 12, 2019 at 11:04:27AM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    d4104460aec1 Add linux-next specific files for 20190211
> > git tree:       linux-next
>
> I can't find this commit. How can I know for sure which commits are in?
> Recent patches are involved with this code, but not sure what was
> included on the test.

Hi Marcelo,

linux-next is weird. Not sure why a so recent commit is not in
linux-next, maybe one needs to fetch tags or something. Fetching
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next-history.git
helped me to get this commit:

$ git show d4104460aec1
commit d4104460aec152e23cf80ab1f950f414bf94f4ea (HEAD, tag: next-20190211)
Author: Stephen Rothwell
Date:   Mon Feb 11 18:37:26 2019 +1100
    Add linux-next specific files for 20190211
