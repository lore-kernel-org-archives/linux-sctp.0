From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 21 Dec 2017 00:10:34 +0000
Subject: Re: [PATCH net-next v4 0/6] net: tcp: sctp: dccp: Replace jprobe usage with trace events
Message-Id: <20171221091034.0dddd1fa08070e812528a84b@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <151374325126.2497.6934744693865165386.stgit@devbox>
        <20171220.142040.593760128783699712.davem@davemloft.net>
        <20171220.142424.1214953044518214833.davem@davemloft.net>
In-Reply-To: <20171220.142424.1214953044518214833.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: mingo@kernel.org, ian.mcdonald@jandi.co.nz, vyasevich@gmail.com, stephen@networkplumber.org, rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com, gerrit@erg.abdn.ac.uk, nhorman@tuxdriver.com, dccp@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, sfr@canb.auug.org.au

On Wed, 20 Dec 2017 14:24:24 -0500 (EST)
David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Wed, 20 Dec 2017 14:20:40 -0500 (EST)
> 
> > From: Masami Hiramatsu <mhiramat@kernel.org>
> > Date: Wed, 20 Dec 2017 13:14:11 +0900
> > 
> >> This series is v4 of the replacement of jprobe usage with trace
> >> events. This version is rebased on net-next, fixes a build warning
> >> and moves a temporal variable definition in a block.
> >> 
> >> Previous version is here;
> >> https://lkml.org/lkml/2017/12/19/153
> >> 
> >> Changes from v3:
> >>   All: Rebased on net-next
> >>   [3/6]: fixes a build warning for i386 by casting pointer unsigned
> >>         long instead of __u64, and moves a temporal variable
> >>          definition in a block.
> > 
> > Looks good, series applied to net-next, thanks.
> 
> Actually, this doesn't even compile, so I've reverted:
> 
> [davem@dhcp-10-15-49-227 net-next]$ make -s -j16
> In file included from net/dccp/trace.h:105:0,
>                  from net/dccp/proto.c:42:
> ./include/trace/define_trace.h:89:42: fatal error: ./trace.h: No such file or directory
>  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>                                           ^
> compilation terminated.

Hmm, strange.
I could compile it on x86-64 and i386. Let me check what was wrong.

Thanks,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
