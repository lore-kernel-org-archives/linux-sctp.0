From: Michael Tuexen <tuexen@fh-muenster.de>
Date: Thu, 29 May 2008 15:34:49 +0000
Subject: Re: receiver window questions
Message-Id: <5D90B4E8-071A-4615-B967-D7CD956B3666@fh-muenster.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <483EC663.1070805@hp.com>
In-Reply-To: <483EC663.1070805@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On May 29, 2008, at 5:25 PM, Neil Horman wrote:

> On Thu, May 29, 2008 at 11:06:11AM -0400, Vlad Yasevich wrote:
>> Hi Michael
>>
>> Michael Tuexen wrote:
>>> Hi Vlad,
>>>
>>> we are currently testing the receive behaviour of Linux (and
>>> other systems).
>>>
>>> We are using Fedora 9, kernel 2.6.25-14.
>>>
>>> The receiver application just opens a 1-to-many style socket
>>> and sleeps forever, not reading any messages.
>>>
>>> The sender (on a different machine), sends a lot of messages of the
>>> same size, all on stream 0, ordered.
>>>
>>> When setting the receive buffer space (using the SO_RCVBUF socket  
>>> option)
>>> to 10000 we oberserve the following:
>>>
>>> - When sending messages of size 1000 bytes, the receiver SACK the  
>>> first,
>>> announces 9000 bytes windows, SACKs the second announces 8000 bytes
>>> and so on. Look fine. The a_rwnd goes down to 0 and discards  
>>> messages.
>>> Everything is fine.
>>>
>>> - When sending messages of size 100 bytes, the receiver SACKs the  
>>> first
>>> messages and reduces the a_rwnd accordingly. Then it looks like the
>>> receive buffer grows, because messages are accepted and the a_rwnd  
>>> does
>>> not shrink. Is this intended?
>>
>> No.  The a_rwnd should go down to 0 as before.
>>
>>> We also figured out that after about 670947 messages of size 100  
>>> bytes
>>> the association is aborted. Is this intended?
>>
>> This is also not intended.  We'll take a look.
>>
> That does sound odd, yes, a_rwnd should be reduced in response to  
> each received
> frame.  do you have tcpdumps of this test available?
> Thanks
> Neil
It looks like that you do not reduce the a_rwnd, because you discard  
the message.
The problem seems to be that you ack it by incrementing the  
cumtsn_ack...

Irene did the tests in the lab. We'll provide traces and a testprogram  
tomorrow.
>
>
>
> -- 
> /***************************************************
> *Neil Horman
> *nhorman@tuxdriver.com
> *gpg keyid: 1024D / 0x92A74FA1
> *http://pgp.mit.edu
> ***************************************************/
>

