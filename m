From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 12 Nov 2009 18:14:03 +0000
Subject: Re: [Lksctp-developers] [PATCH 1/3] sctp: fix autoclose timer race
Message-Id: <4AFC506B.4080904@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4AFC36CD.2020806@hp.com>
In-Reply-To: <4AFC36CD.2020806@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Vlad Yasevich wrote:
> 
> Andrei Pelinescu-Onciul wrote:
>> For very small autoclose timeouts (e.g. 0 or close to 0 due to
>> overflows) it's possible that the timer is executed immediately
>> after is set, before there is a chance to increase the association
>> reference counter. To avoid this race, always reference the
>> association before calling mod_timer() and dereference it back if
>> the timer was already active.
>>
> 
> Actually, I don't think this can happen.  At worst, you'd trigger
> a soft lock-up, since the code modifying the timer is already holding
> a socket lock.  But that would only happen if that code is pre-empted,
> which would mean that a user version of the lock is held, then the
> autoclose would get rescheduled anyway.
> 

Even if the timer ends up running on a different CPU, the socket lock
guarantees that only 1 instance of the state machine is running per
socket.  The timer handler will spin on the lock until it's released,
so there doesn't appear to be a race.

-vlad
