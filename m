From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 14 Oct 2009 13:07:59 +0000
Subject: Re: SCTP Association Restart
Message-Id: <4AD5CD2F.3000709@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <90243C8A881F8D419D855264D9636F3A01EA5740@zcarhxm2.corp.nortel.com>
In-Reply-To: <90243C8A881F8D419D855264D9636F3A01EA5740@zcarhxm2.corp.nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Gregory Waines wrote:
> 
> - ok, so I am using Linux 2.6.14 .
>   can someone confirm that association restart should work
>   for the SCTP implementation in Linux 2.6.14 .
>   i.e. specifically for the side of the association that stays
>        up and receives the unexpected INIT and COOKIE_ECHO while
>        in the ESTABLISHED state.
>        This end should accept the new INIT request as a restart
>        (provided ip address and port match), report RESTART to the
>        ULP, and reset sequence numbers to zero.
>   This all works in 2.6.14 ?

Yes.  There is a bug there, however, that if you have any data awaiting
re-assembly or ordering, it will stay there (as stale), and will cause
issues.  That was fixed in 2.6.21.  You will want these 2 commit to fix
it:
	0b58a811461ccf3cf848aba4cc192538fd3b0516
	749bf9215ed1a8b6edb4bb03693c2b62c6b9c2a4
> 
> 
> - If I have a Linux process with an established SCTP connection/
>   association,
>   is there a socket option that prevents the kernel from 
>   ABORTing the association if this Linux process fails unexpectedly ?
> 

Nope.  When the socket is closed, the association is closed as well.
Depending on your settings, it will either be ABORTed or closed with SHUTDOWN.

> 
> - I have the following question related to using the one-to-one style
> socket 
>   interface when trying to do an Association Restart:
>      * if my node is typically the server side of the SCTP connections
>      * then on a restart of this node,
>      * I assume that I could NOT setup my server's listening socket
> first,
>                     (i.e. socket(), bind(), listen(), accept()...)
>        and,
>        then try to re-establish old associations by
> socket(),bind(),connect() ...
>             because the bind() would probably fail due to the listening
> socket
>             already being bound to the same SCTP IP Address and Port.
>      *
>      * is this correct ?

No.  If you system restarts, you will start with a completely fresh state
and you would need to start your service with a normal procedure.

>      * i.e. if using the one-to-one style interface, and 
>                you are the server, and
>                you restart, and
>                you are trying to recover SCTP Associations,
>             then
>                the only way you can get around the bind() conflict is to
> 
>                recover the SCTP associations first, and then 
>                re-setup your listening socket.
> 

I think you mis-understand when association restart is typically triggered.  The
trigger is when one association failed to notify the other that it went down.
When everything is operating normally, this almost never happens.  It is usually
triggered due to a network outage where one side lost reachability and
terminated the association.  The application attempts to restart by either
connecting again, or attempting to transmit data (using implicit connect).  If
the network is restored, you will get a restart.

A restart _might_ get triggered on a system restart if you have a service that
tries to establish associations as part of it's start-up procedure and you had
a network overflow/failure that lost the ABORT/SHUTDOWN packets.  Again, this is
not something that's always guaranteed to happen.

-vlad

> 
> thanks in advance for any help,
> Greg Waines
> Nortel
> waines@nortel.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
