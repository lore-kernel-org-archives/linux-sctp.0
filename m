From: David Miller <davem@davemloft.net>
Date: Sat, 09 Feb 2019 23:12:17 +0000
Subject: Re: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <20190209.151217.175627323493244750.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
        <20190206203754.GC13621@localhost.localdomain>
In-Reply-To: <20190206203754.GC13621@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: julien@arista.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, lucien.xin@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 6 Feb 2019 18:37:54 -0200

> On Wed, Feb 06, 2019 at 12:14:30PM -0800, Julien Gomes wrote:
>> Make sctp_setsockopt_events() able to accept sctp_event_subscribe
>> structures longer than the current definitions.
>> 
>> This should prevent unjustified setsockopt() failures due to struct
>> sctp_event_subscribe extensions (as in 4.11 and 4.12) when using
>> binaries that should be compatible, but were built with later kernel
>> uapi headers.
> 
> Not sure if we support backwards compatibility like this?

What a complete mess we have here.

Use new socket option numbers next time, do not change the size and/or
layout of existing socket options.

This whole thread, if you read it, is basically "if we compatability
this way, that breaks, and if we do compatability this other way oh
shit this other thing doesn't work."

I think we really need to specifically check for the difference sizes
that existed one by one, clear out the part not given by the user, and
backport this as far back as possible in a way that in the older kernels
we see if the user is actually trying to use the new features and if so
error out.

Which, btw, is terrible behavior.  Newly compiled apps should work on
older kernels if they don't try to use the new features, and if they
can the ones that want to try to use the new features should be able
to fall back when that feature isn't available in a non-ambiguous
and precisely defined way.

The fact that the use of the new feature is hidden in the new
structure elements is really rotten.

This patch, at best, needs some work and definitely a longer and more
detailed commit message.
