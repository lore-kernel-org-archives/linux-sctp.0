From: Harald Welte <laforge@gnumonks.org>
Date: Fri, 01 May 2020 13:16:07 +0000
Subject: Re: ABI breakage in sctp_event_subscribe (was [PATCH net-next 0/4] sctp: add some missing events fro
Message-Id: <20200501131607.GU1294372@nataraja>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1570534014.git.lucien.xin@gmail.com>
 <20200419102536.GA4127396@nataraja>
In-Reply-To: <20200419102536.GA4127396@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org

Dear Linux SCTP developers,

On Sun, Apr 19, 2020 at 12:25:36PM +0200, Harald Welte wrote:
> this patchset (merged back in Q4/2019) has broken ABI compatibility, more
> or less exactly as it was discussed/predicted in Message-Id
> <20190206201430.18830-1-julien@arista.com>
> "[PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length"
> on this very list in February 2019.

does the lack of any follow-up so far seems to indicate nobody considers
this a problem?  Even without any feedback from the Linux kernel
developers, I would be curious to hear What do other SCTP users say.

So far I have a somewhat difficult time understanding that I would be
the only one worried about ABI breakage?  If that's the case, I guess
it would be best to get the word out that people using Linux SCTP should
better make sure to not use binary packages but always build on the
system they run it on, to ensure kernel headers are identical.

I don't mean this in any cynical way.  The point is either the ABI is
stable and people can move binaries between different OS/kernel
versions, or they cannot.  So far the general assumption on Linux is you
can, but with SCTP you can not, so this needs to be clarified.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
======================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
