From: Michael Tuexen <michael.tuexen@lurchi.franken.de>
Date: Sun, 16 Jun 2019 18:11:05 +0000
Subject: Re: sctp_sendmsg does not accept flags
Message-Id: <FEC710C5-2407-422E-AF8C-A85483646EDE@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <e863ee11-9e1f-71b9-1f61-b4b71d9f0945@elstel.org>
In-Reply-To: <e863ee11-9e1f-71b9-1f61-b4b71d9f0945@elstel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 16. Jun 2019, at 19:56, malc <mlashley@gmail.com> wrote:
> 
> I think you want 'man 3 sctp_sendmsg' [1] and one of the flags
> supported there... namely SCTP_UNORDERED. SCTP_ADDR_OVER, SCTP_ABORT,
> SCTP_EOF
> See also [2] which I'm guessing is relevant to what you're /trying/ to achieve.
Using MSG_NOSIGNAL is definitely not what should be usedin this context,
but the first question is:
If the user provides an invalid flag, does this result in sctp_sendmsg() to
return -1 and errno to be set to EINVAL?
The more relevant question is:
Assume sendmsg() returns -1. Shouldn't then no message be sent out?
This send call is atomic.
So I would expect
* either no error is indicated and the message is accepted by the kernel
* or an error is indicated and the message is not accepted by the kernel.
Do we agree on this? Does the linux implementation follows this rule?

Best regards
Michael
> 
> Cheers,
> malc.
> 
> [1] https://linux.die.net/man/3/sctp_sendmsg
> [2] https://sourceforge.net/p/lksctp/mailman/message/11557899/
> 
> 
> On Sun, Jun 16, 2019 at 2:40 PM Elmar Stellnberger <estellnb@elstel.org> wrote:
>> 
>>    While sctp_send works well at me, sctp_sendmsg gives me an EINVAL as
>> soon as I pass in some flags. Nonetheless it still sends the message in
>> spite of returning the EINVAL. That looks like an error to me. Please
>> investigate the issue.
>> 
>> while( len > 0 && ( ( ret = sctp_sendmsg( sid, bufp, len, NULL, 0, 0,
>> MSG_NOSIGNAL, (0), 1000, 0 ) ) >= 0 || ( ret=-1 && ( errno = EINTR ||
>> errno = ENOBUFS ) ) ) ) {  // returns EINVAL if flags are passed
>>     if( ret >= 0 ) { bufp += ret; len -= ret; } else if( errno =
>> ENOBUFS ) { struct timespec ts; ts.tv_sec=0; ts.tv_nsec000;
>> nanosleep(&ts,NULL); } }
>> if( ret = -1 ) perror ("error sending request to stream #(0)");
>> 
>>   If you should be interested I can send the whole sctp test client
>> program.
>> 
>> 
>> 
>> 
>> 
>> 
