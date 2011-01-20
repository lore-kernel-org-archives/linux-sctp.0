From: Randy Stewart <randall@lakerest.net>
Date: Thu, 20 Jan 2011 07:53:43 +0000
Subject: Re: Inconsistency in spinfo_state between Linux and FreeBSD sctp
Message-Id: <13CE110A-930A-4FB0-8A70-C6171DB7CA9A@lakerest.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110119232732.1605564zwkq5jj9w@webmail.tuwien.ac.at>
In-Reply-To: <20110119232732.1605564zwkq5jj9w@webmail.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

What FreeBSD currently gives (since we have not reved it to the
latest socket code and will NOT do so until Last Call is completed
on the draft) is the following...

1) SCTP_ADDR_REACHABLE
2) SCTP_ADDR_NOT_REACHABLE

and any of these two states can have the suffix
3) SCTP_ADDR_UNCONFIRMED

So you end up with two additional values 

3a) SCTP_ADDR_REACHABLE & SCTP_ADDR_UNCONFIRMED
or
3b) SCTP_ADDR_NOT_REACHABLE & SCTP_ADDR_UNCONFIRMED


These will all be changed when we move to a draft that has been
through last call... The SCTP_ADDR_REACHABLE will become SCTP_ACTIVE
the SCTP_ADDR_NOT_REACHABLE will become SCTP_INACTIVE
And we will show neither ACTIVE or INACTIVE if the UNCONFIRMED flag
shows up... you will only see SCTP_UNCONFIRMED

Don't expect these to be an enumerated type in FreeBSD though.. they will
be 

#define SCTP_ACTIVE      0x1
#define SCTP_INACTIVE    0x2
#define SCTP_UNCONFIRMED 0x200

Which is completely fine... and will meet the spec... you should not
(as Kacheong mentioned) depend on a numerical value but use the name.

R

On Jan 19, 2011, at 11:41 PM, Kacheong Poon wrote:

> On 01/20/11 06:27 AM, Schoch Christian wrote:
>> I could figure a problem with spinfo_state between Linux and FreeBSD
>> sctp stack.
>> 
>> While in linux stack the return value of spinfo_state is defined as enum
>> with four items, FreeBSD defines a lot more states. The problem is that
>> these values do not match with each other. For example if FreeBSD means
>> INACTIVE this value in linux results in UNCONFIRMED.
>> 
>> In sctp socket api these states are namely defined but not assoziated
>> with any value.
>> 
>> Is there any possibility to standardize these values ??
> 
> 
> In version 25 of the draft, there are 3 defined values for
> spinfo_state, which are
> 
>      SCTP_UNCONFIRMED:  The initial state of a peer address.
> 
>      SCTP_ACTIVE:  The state is entered the first time after path
>         verification.  It can also be entered if the state is
>         SCTP_INACTIVE and the path supervision detects that the peer
>         address is reachable again.
> 
>      SCTP_INACTIVE:  This state is entered whenever a path failure is
>         detected.
> 
> The above values should be used.  App should not use actual integer
> value in the code.
> 
> What is your reason that actual integer values are needed?
> 
> 
> -- 
> 
> 					K. Poon.
> 					ka-cheong.poon@oracle.com
> 

-----
Randall Stewart
randall@lakerest.net




