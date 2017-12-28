From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 28 Dec 2017 23:48:42 +0000
Subject: Re: [PATCH net-next v6 0/6] net: tcp: sctp: dccp: Replace jprobe usage with trace events
Message-Id: <20171229084842.1baf0902f7a432b52a43e279@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <151444140014.11331.17287122201510506083.stgit@devbox>
        <20171228.120613.1048334566479767343.davem@davemloft.net>
In-Reply-To: <20171228.120613.1048334566479767343.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: mingo@kernel.org, ian.mcdonald@jandi.co.nz, vyasevich@gmail.com, stephen@networkplumber.org, rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com, gerrit@erg.abdn.ac.uk, nhorman@tuxdriver.com, dccp@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, sfr@canb.auug.org.au

On Thu, 28 Dec 2017 12:06:13 -0500 (EST)
David Miller <davem@davemloft.net> wrote:

> From: Masami Hiramatsu <mhiramat@kernel.org>
> Date: Thu, 28 Dec 2017 15:10:00 +0900
> 
> > Changes from v5:
> >   [1/6]: Avoid preprocessor directives in tracepoint macro args
> 
> Patch #1 is not the only patch which has this problem, at a minimum
> patch #5 has it too.

Oops, sorry...

> Please audit the entire series for an issue when it is brought to your
> attention.

Thank you for your kindly advice.

> 
> Thank you.


-- 
Masami Hiramatsu <mhiramat@kernel.org>
