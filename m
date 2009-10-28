From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 28 Oct 2009 13:48:16 +0000
Subject: Re: SCTP Association Restart
Message-Id: <4AE84BA0.2030507@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <90243C8A881F8D419D855264D9636F3A01EA5740@zcarhxm2.corp.nortel.com>
In-Reply-To: <90243C8A881F8D419D855264D9636F3A01EA5740@zcarhxm2.corp.nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Gregory Waines wrote:
> Vlad Yasevich wrote:
>> Gregory Waines wrote:
> < SNIP >
>>> - If I have a Linux process with an established SCTP connection/  
>>>   association, is there a socket option that prevents the kernel from
>>>   ABORTing the association if this Linux process fails unexpectedly ?
>>>
>> Nope.  When the socket is closed, the association is closed as well.
>> Depending on your settings, it will either be ABORTed or
>> closed with SHUTDOWN.
>>
> < SNIP >
> 
> ... a followup question on this ...
> 
> remember that 
>    - I am trying to build a 1:1 (active / standby) type application
>      which uses an SCTP connection.  
>    - And I am trying to take advantage of the ASSOCIATION RESTART 
>      behaviour (i.e. section 5.2.4.1) in order to allow the 
>      Standby Instance of the Application, when becomingActive, to take 
>      over the SCTP connection without the far-end of the SCTP connection
>      terminating or aborting the connection.
>    - typically the Standby Instance of the Application is on a different
>      card/processor,
>    - and for full Card/Processor failures, which result in the Kernel
> having
>      no chance to send an ABORT to the far-end,
>      I believe I have no issues with this approach.
> 
> ... but I would like to also support Application Process Failures, 
> in the same way.
> 
> This is why I was asking about the socket option above ...
> i.e. a socket option that, if the Linux Process dies,
>      the kernel would still clean up the SCTP Association locally,
>      BUT would NOT send an ABORT to the far-end of the Association.
> 
> 
> If I was going to implement this socket option myself,
> would you recommend:
>    - a new socket option  e.g. SO_NO_ABORT_ON_FAIL
>    or
>    - use an existing socket option e.g. SO_LINGER
> 

I think you should keep it as clean and simple as possible and make it its own
socket option.

One item of note.  When association restarts, any queued data, that's awaiting
reassembly or ordering is discarded.  The reason is that on restarted
associations, TSN and SSN sequences begin anew and there is no way to
re-assemble or re-order old data.

-vlad
> Any thoughts / recommendations ?
> 
> 
> thanks in advance,
> Greg.
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
