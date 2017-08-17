From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 17 Aug 2017 13:21:57 +0000
Subject: RE: Old linux versions...
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DD0059559@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6DD0056B5E@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD0056B5E@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> > How do we stop our customers insisting on using SCTP in RHEL 5.7 :-)
> >
> Release a kernel update with CONFIG_SCTP=n?

Go for it :-)

> Sorry, wish there was a better way, but people keep paying for it, so we keep
> providing it.

Yes, at least we've managed to lose all the people who wanted 2.4.x support.

In this case I actually suspect the problem is that our code now puts port=0
in bindx calls - which is only allowed after the fixes that went into 2.6.22 (ish).
But our support group are trying to get them to upgrade our software to
the 'supported' version - which won't make a blind bit of difference.
We're also trying to get them to upgrade to something later than RHEL 5.7
but that is probably even harder!

I wish I had a list of the very bad SCTP bugs and the kernel versions
that fix them.

We only use it for M3UA - so there are very few connections that are
established very infrequently.
I suspect the error paths don't get stressed.

I don't want to start testing SCTP - I might have to fix the bugs in
the copy we 'stole' from FreeBSD and hacked into the windows kernel.

	David

