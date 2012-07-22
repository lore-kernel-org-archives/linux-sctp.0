From: "Neil Horman <nhorman@tuxdriver.com>" <nhorman@tuxdriver.com>
Date: Sun, 22 Jul 2012 19:18:15 +0000
Subject: Re: [PATCH v6] sctp: Implement quick failover draft from tsvwg
Message-Id: <da1c7d5d-5faf-495f-af02-5b56b13d7f98@email.android.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1342203998-24037-1-git-send-email-nhorman@tuxdriver.com> <1342893367-981-1-git-send-email-nhorman@tuxdriver.com> <2e6ee3f1-ea4f-4c13-b27b-1f2291fdb0c0@email.android.com> <20120722.121409.377271257112948379.davem@davemloft.net>
In-Reply-To: <20120722.121409.377271257112948379.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, vyasevich@gmail.com
Cc: netdev@vger.kernel.org, sri@us.ibm.com, linux-sctp@vger.kernel.org, joe@perches.com

Thanks all!

David Miller <davem@davemloft.net> wrote:

>From: Vlad Yasevich <vyasevich@gmail.com>
>Date: Sun, 22 Jul 2012 14:18:12 -0400
>
>> Neil Horman <nhorman@tuxdriver.com> wrote:
>> 
>>>I've seen several attempts recently made to do quick failover of sctp
>>>transports
>>>by reducing various retransmit timers and counters.  While its
>possible
>>>to
>>>implement a faster failover on multihomed sctp associations, its not
>>>particularly robust, in that it can lead to unneeded retransmits, as
>>>well as
>>>false connection failures due to intermittent latency on a network.
>>>
>>>Instead, lets implement the new ietf quick failover draft found here:
>>>http://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
>>>
>>>This will let the sctp stack identify transports that have had a
>small
>>>number of
>>>errors, and avoid using them quickly until their reliability can be
>>>re-established.  I've tested this out on two virt guests connected
>via
>>>multiple
>>>isolated virt networks and believe its in compliance with the above
>>>draft and
>>>works well.
>>>
>>>Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> ...
>> Acked-by: Vlad Yasevich <vyasevich@gmail.com>
>
>Applied, thanks everyone.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
