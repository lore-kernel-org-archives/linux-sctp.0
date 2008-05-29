From: Michael Tuexen <tuexen@fh-muenster.de>
Date: Thu, 29 May 2008 15:18:54 +0000
Subject: Re: receiver window questions
Message-Id: <C2D2CA62-3DD0-48D1-801D-412B19362386@fh-muenster.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <483EC663.1070805@hp.com>
In-Reply-To: <483EC663.1070805@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad,

Irene has done some more testing.

The ABORT was due to the fact that the testtool was not responding to
HEARTBEATs. She fixed that.

She is still investigating, but the conjecture is that for small  
messages
the receiver accepts floor(2*s/(178+msgsize)) messages, where s is the
receive space set by a socket option. Small means smaller than 180, but
178 could be the real number. Irene will check this tomorrow.
In that case the a_rwnd goes down, and when the above limit is reached,
a_rwnd is not decremented anymore, the messages are not put into the
receive buffer anymore (checked if they are delivered to the  
application),
but the cumtsn is still incremented. So the sender thinks, the  
messages are
successfully transmitted, but the receiver just drops them.

Irene will provide definite test case to reproduce the problem tomorrow.

Best regards
Michael

On May 29, 2008, at 5:06 PM, Vlad Yasevich wrote:

> Hi Michael
>
> Michael Tuexen wrote:
>> Hi Vlad,
>> we are currently testing the receive behaviour of Linux (and
>> other systems).
>> We are using Fedora 9, kernel 2.6.25-14.
>> The receiver application just opens a 1-to-many style socket
>> and sleeps forever, not reading any messages.
>> The sender (on a different machine), sends a lot of messages of the
>> same size, all on stream 0, ordered.
>> When setting the receive buffer space (using the SO_RCVBUF socket  
>> option)
>> to 10000 we oberserve the following:
>> - When sending messages of size 1000 bytes, the receiver SACK the  
>> first,
>>  announces 9000 bytes windows, SACKs the second announces 8000 bytes
>>  and so on. Look fine. The a_rwnd goes down to 0 and discards  
>> messages.
>>  Everything is fine.
>> - When sending messages of size 100 bytes, the receiver SACKs the  
>> first
>>  messages and reduces the a_rwnd accordingly. Then it looks like the
>>  receive buffer grows, because messages are accepted and the a_rwnd  
>> does
>>  not shrink. Is this intended?
>
> No.  The a_rwnd should go down to 0 as before.
>
>>  We also figured out that after about 670947 messages of size 100  
>> bytes
>>  the association is aborted. Is this intended?
>
> This is also not intended.  We'll take a look.
>
> Thanks
> -vlad
>
>> - Sending messages of size 10 bytes is similar to 100 byes.
>> Best regards
>> Michael
>
>

