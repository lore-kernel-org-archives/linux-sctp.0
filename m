From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 14 Dec 2015 09:50:36 +0000
Subject: RE: use-after-free in sctp_do_sm
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1CBEC96A@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5665EE26.3000706@gmail.com> <5665F17B.5030908@gmail.com>
 <CACT4Y+ad0YGve+KB8wiv6f1+eHt9Ci19FGM0SMWQvJFSez+Rcw@mail.gmail.com>
 <20151208174039.GB22987@mrl.redhat.com>
 <CACT4Y+b1OEE9NqN3J5574iN7t8NEi9jPc2Hxoj6AMHZKjCJ-mg@mail.gmail.com>
 <CACT4Y+YYbC53awV4eiDAwjJO=WHYGv3Og3XDh-gTFB1q_w0YXQ@mail.gmail.com>
 <20151209150356.GA3886@mrl.redhat.com>
 <20151209164108.GB3886@mrl.redhat.com>
 <CACT4Y+YPEqETP7NTOwJ6=4yYoAmM30qv6oRgw7apSS3+UwusAg@mail.gmail.com>
 <566AD4D9.90608@gmail.com> <20151211140333.GE3886@mrl.redhat.com>
 <566B1800.60100@gmail.com>
In-Reply-To: <566B1800.60100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Vlad Yasevich' <vyasevich@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Dmitry Vyukov <dvyukov@google.com>
Cc: netdev <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, syzkaller <syzkaller@googlegroups.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>

From: Vlad Yasevich
> Sent: 11 December 2015 18:38
...
> > Found a similar place in abort primitive handling like in this last
> > patch update, it's probably the issue you're still triggering.
> >
> > Also found another place that may lead to this use after free, in case
> > we receive a packet with a chunk that has no data.
> >
> > Oh my.. :)
> 
> Yes.  This is what I was worried about...  Anything that triggers
> a DELTE_TCB command has to return a code that we can trap.
> 
> The other way is to do what Dmitri suggested, but even there, we
> need to be very careful.

I'm always wary of anything that queues actions up for later processing.
It is far too easy (as found here) to end up processing actions
in invalid states, or to process actions in 'unusual' orders when
specific events happen close together.

I wonder how much fallout there'd be from getting the sctp code
to immediately action things, instead of queuing the actions for later.
It would certainly remove a lot of the unusual combinations of events.

	David


