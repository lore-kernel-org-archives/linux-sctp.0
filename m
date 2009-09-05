From: "Doug Graham" <dgraham@nortel.com>
Date: Sat, 05 Sep 2009 04:41:07 +0000
Subject: Re: [PATCH 0/2] Re: Do piggybacked ACKs work
Message-Id: <4AA1EBE3.3050009@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Doug Graham wrote:
>   
>> Hi Vlad,
>>
>> I'm probably just being stupid, but I can't figure out which version of
>> output.c your patch
>> is supposed to be applied against.  Is it supposed to be applied on top
>> of any of the other
>> patches that Wei or I provided, or does it replace them all?
>>
>> The main reason I ask is that as far as I can tell, your patch doesn't
>> change the original
>> mysterious condition for bundling a SACK, which was "if (asoc->a_rwnd >
>> asoc->rwnd)".
>>     
>
>
> Well, I took your patch verbatum for that code.  These two would apply on
> top of that.
>
> You can see the final code here:
> 	http://git.kernel.org/?p=linux/kernel/git/vxy/lksctp-dev.git;a=shortlog;h=net-next
>
> You can fetch from it like this:
>
> # git fetch git://git.kernel.org/pub/scm/linux/kernel/git/vxy/lksctp-dev.git \
> refs/heads/net-next:refs/heads/<name that branch here>
>
> That will dump the net-next branch into a local branch that you named (can be
> any new name).
>   

Sorry, haven't had a lot of time to play with this until now.  The 
behaviour for
small unfragmented message looks fine, but if the message has to be 
fragmented,
things don't look so good.  I'm ping-ponging a 1500 byte message around: 
client
sends 1500 bytes, server reads that and replies with the same message, 
client
reads the reply then sleeps 2 seconds before doing it all over again.  I 
see no
piggybacking happening at all.  A typical cycle looks like:

 12 2.007226    10.0.0.248    10.0.0.249    SCTP     DATA (1452 bytes data)
 13 2.007268    10.0.0.248    10.0.0.249    SCTP     DATA (48 bytes data)
 14 2.007313    10.0.0.249    10.0.0.248    SCTP     SACK
 15 2.007390    10.0.0.249    10.0.0.248    SCTP     SACK
 16 2.007542    10.0.0.249    10.0.0.248    SCTP     DATA
 17 2.007567    10.0.0.249    10.0.0.248    SCTP     DATA
 18 2.007615    10.0.0.248    10.0.0.249    SCTP     SACK
 19 2.007661    10.0.0.248    10.0.0.249    SCTP     SACK

Those back-to-back SACKs look wasteful too.  One should have done the job,
although I suppose I can't be sure that SACKs aren't crossing DATA
on the wire.  But the real mystery is why the SACKs were
sent immediately after the DATA was received.  Looks like delayed SACKs
might be broken, although they are working for unfragmented messages.

--Doug

