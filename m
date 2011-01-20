From: Kacheong Poon <ka-cheong.poon@oracle.com>
Date: Thu, 20 Jan 2011 04:41:11 +0000
Subject: Re: Inconsistency in spinfo_state between Linux and FreeBSD sctp
Message-Id: <4D37BCE7.7070806@oracle.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110119232732.1605564zwkq5jj9w@webmail.tuwien.ac.at>
In-Reply-To: <20110119232732.1605564zwkq5jj9w@webmail.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01/20/11 06:27 AM, Schoch Christian wrote:
> I could figure a problem with spinfo_state between Linux and FreeBSD
> sctp stack.
>
> While in linux stack the return value of spinfo_state is defined as enum
> with four items, FreeBSD defines a lot more states. The problem is that
> these values do not match with each other. For example if FreeBSD means
> INACTIVE this value in linux results in UNCONFIRMED.
>
> In sctp socket api these states are namely defined but not assoziated
> with any value.
>
> Is there any possibility to standardize these values ??


In version 25 of the draft, there are 3 defined values for
spinfo_state, which are

       SCTP_UNCONFIRMED:  The initial state of a peer address.

       SCTP_ACTIVE:  The state is entered the first time after path
          verification.  It can also be entered if the state is
          SCTP_INACTIVE and the path supervision detects that the peer
          address is reachable again.

       SCTP_INACTIVE:  This state is entered whenever a path failure is
          detected.

The above values should be used.  App should not use actual integer
value in the code.

What is your reason that actual integer values are needed?


-- 

					K. Poon.
					ka-cheong.poon@oracle.com
