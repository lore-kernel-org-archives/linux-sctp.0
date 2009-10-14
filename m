From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 14 Oct 2009 15:09:41 +0000
Subject: Re: SCTP Association Restart
Message-Id: <4AD5E9B5.3020401@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <90243C8A881F8D419D855264D9636F3A01EA5740@zcarhxm2.corp.nortel.com>
In-Reply-To: <90243C8A881F8D419D855264D9636F3A01EA5740@zcarhxm2.corp.nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Gregory Waines wrote:
> thanks vlad.
> 
> ok ... I now understand 'original intent' of the association restart.
> 
> You're correct that I am trying to use the 'association restart'
> behaviour for a different purpose.
> 
> i.e. I have a 1:1 Active / Standby implementation of 
> an Application which uses SCTP connections.
> - Active process on node A ... SCTP server with ESTABLISHED SCTP
> associations
> - Standby process on node B ... hot-standby waiting to take service if
> Active fails
>      * with a variety of data being journalled from node A to node B
>      * mostly application/ULP-specific
>      * but includes far-end SCTP IP Address & port of ESTABLISHED SCTP
> associations
> - if node A fails ... e.g. say hardware failure / reset.
> - Standby process on node B becomes Active
> - node B takes over IP Address ... details left out
> - node B recovers SCTP Associations using journalled SCTP data ( far-end
> IP Address & ports )
>   ... which would rely on the 'association restart' behaviour at far-end
> to send a 
>       RESTART (rather than an ABORT) to the far-end ULP/Application, and
>       reset far-end sequence numbers, etc. such that communication can
> restart
>       on this SCTP Association.
> 

Yes, in the case of a hardware failure or operating system crash there
typically will not be any termination sequence from the SCTP layer.  When
the standby takes over, it will trigger a restart procedure at the remote.

However, in cases of application failure, system maintenance reboot, or similar
events where the application or system is terminated semi-gracefully, the
association would be torn down, unless application has a hand-over functionality
 to transition to the stand-by.

> 
> Are you aware of any implementations similar to the above description ?

Yes.  I am familiar with multiple deployments of the above functionality.
Non of them explicitly try to trigger a restart, but they depend on the
ability to be there when needed.

-vlad

> 
> The 3GPP TS 36.412 version 8.5.0 Release 8 standard (LTE wireless
> standard), 
> Section 7 Transport Layer, describes this "SCTP endpoint redundancy", 
> for the SCTP connections between the eNodeB and the MME devices, and 
> actually refers to the behaviour described in RFC4960 section 5.2 .
> So ... I'm assuming that this has been or can be done (?).
> 
> Comments ?
> 
> Greg.
> 
> 
> 
> Vlad Yasevich wrote:
>> Gregory Waines wrote:
>>> - ok, so I am using Linux 2.6.14 .
>>>   can someone confirm that association restart should work
>>>   for the SCTP implementation in Linux 2.6.14 .
>>>   i.e. specifically for the side of the association that stays
>>>        up and receives the unexpected INIT and COOKIE_ECHO while
>>>        in the ESTABLISHED state.
>>>        This end should accept the new INIT request as a restart
>>>        (provided ip address and port match), report RESTART to the
>>>        ULP, and reset sequence numbers to zero.
>>>   This all works in 2.6.14 ?
>> Yes.  There is a bug there, however, that if you have any
>> data awaiting re-assembly or ordering, it will stay there (as
>> stale), and will cause issues.  That was fixed in 2.6.21.
>> You will want these 2 commit to fix
>> it:
>> 	0b58a811461ccf3cf848aba4cc192538fd3b0516
>> 	749bf9215ed1a8b6edb4bb03693c2b62c6b9c2a4
>>>
>>> - If I have a Linux process with an established SCTP connection/  
>>>   association, is there a socket option that prevents the kernel from
>>>   ABORTing the association if this Linux process fails unexpectedly ?
>>>
>> Nope.  When the socket is closed, the association is closed as well.
>> Depending on your settings, it will either be ABORTed or
>> closed with SHUTDOWN.
>>
>>> - I have the following question related to using the one-to-one
>>>   style socket interface when trying to do an Association Restart:
>>>      * if my node is typically the server side of the SCTP
>>> connections 
>>>      * then on a restart of this node,
>>>      * I assume that I could NOT setup my server's listening socket
>>>                     first, (i.e. socket(), bind(), listen(),
>>>        accept()...)        and, then try to re-establish old
>>>             associations by socket(),bind(),connect() ... because
>>>             the bind() would probably fail due to the listening
>>>      socket already being bound to the same SCTP IP Address and
>>> Port.      * * is this correct ? 
>> No.  If you system restarts, you will start with a completely
>> fresh state and you would need to start your service with a
>> normal procedure.
>>
>>>      * i.e. if using the one-to-one style interface, and
>>>                you are the server, and
>>>                you restart, and
>>>                you are trying to recover SCTP Associations,         
>>>                then the only way you can get around the bind()
>>> conflict is to 
>>>
>>>                recover the SCTP associations first, and then
>>>                re-setup your listening socket.
>>>
>> I think you mis-understand when association restart is
>> typically triggered.  The trigger is when one association
>> failed to notify the other that it went down.
>> When everything is operating normally, this almost never
>> happens.  It is usually triggered due to a network outage
>> where one side lost reachability and terminated the
>> association.  The application attempts to restart by either
>> connecting again, or attempting to transmit data (using
>> implicit connect).  If the network is restored, you will get
>> a restart.
>>
>> A restart _might_ get triggered on a system restart if you
>> have a service that tries to establish associations as part
>> of it's start-up procedure and you had a network
>> overflow/failure that lost the ABORT/SHUTDOWN packets.
>> Again, this is not something that's always guaranteed to happen.
>>
>> -vlad
>>
>>> thanks in advance for any help,
>>> Greg Waines
>>> Nortel
>>> waines@nortel.com
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp"
>>> in the body of a message to majordomo@vger.kernel.org More majordomo
>>> info at  http://vger.kernel.org/majordomo-info.html
> 
