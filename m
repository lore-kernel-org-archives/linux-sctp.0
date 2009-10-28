From: "Gregory Waines" <waines@nortel.com>
Date: Wed, 28 Oct 2009 12:00:36 +0000
Subject: RE: SCTP Association Restart
Message-Id: <90243C8A881F8D419D855264D9636F3A0212E93B@zcarhxm2.corp.nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <90243C8A881F8D419D855264D9636F3A01EA5740@zcarhxm2.corp.nortel.com>
In-Reply-To: <90243C8A881F8D419D855264D9636F3A01EA5740@zcarhxm2.corp.nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Gregory Waines wrote:
>> 
< SNIP >
>> 
>> - If I have a Linux process with an established SCTP connection/  
>>   association, is there a socket option that prevents the kernel from
>>   ABORTing the association if this Linux process fails unexpectedly ?
>> 
> 
> Nope.  When the socket is closed, the association is closed as well.
> Depending on your settings, it will either be ABORTed or
> closed with SHUTDOWN.
> 
< SNIP >

... a followup question on this ...

remember that 
   - I am trying to build a 1:1 (active / standby) type application
     which uses an SCTP connection.  
   - And I am trying to take advantage of the ASSOCIATION RESTART 
     behaviour (i.e. section 5.2.4.1) in order to allow the 
     Standby Instance of the Application, when becomingActive, to take 
     over the SCTP connection without the far-end of the SCTP connection
     terminating or aborting the connection.
   - typically the Standby Instance of the Application is on a different
     card/processor,
   - and for full Card/Processor failures, which result in the Kernel
having
     no chance to send an ABORT to the far-end,
     I believe I have no issues with this approach.

... but I would like to also support Application Process Failures, 
in the same way.

This is why I was asking about the socket option above ...
i.e. a socket option that, if the Linux Process dies,
     the kernel would still clean up the SCTP Association locally,
     BUT would NOT send an ABORT to the far-end of the Association.


If I was going to implement this socket option myself,
would you recommend:
   - a new socket option  e.g. SO_NO_ABORT_ON_FAIL
   or
   - use an existing socket option e.g. SO_LINGER

Any thoughts / recommendations ?


thanks in advance,
Greg.






