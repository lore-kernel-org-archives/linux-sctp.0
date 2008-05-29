From: Michael Tuexen <tuexen@fh-muenster.de>
Date: Thu, 29 May 2008 16:12:18 +0000
Subject: Re: receiver window questions
Message-Id: <BECE7A1B-9D81-429C-9547-E4EC1B2C6987@fh-muenster.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <483EC663.1070805@hp.com>
In-Reply-To: <483EC663.1070805@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On May 29, 2008, at 5:50 PM, Vlad Yasevich wrote:

> Neil Horman wrote:
>> On Thu, May 29, 2008 at 11:06:11AM -0400, Vlad Yasevich wrote:
>>> Hi Michael
>>>
>>> Michael Tuexen wrote:
>>>> Hi Vlad,
>>>>
>>>> we are currently testing the receive behaviour of Linux (and
>>>> other systems).
>>>>
>>>> We are using Fedora 9, kernel 2.6.25-14.
>>>>
>>>> The receiver application just opens a 1-to-many style socket
>>>> and sleeps forever, not reading any messages.
>>>>
>>>> The sender (on a different machine), sends a lot of messages of the
>>>> same size, all on stream 0, ordered.
>>>>
>>>> When setting the receive buffer space (using the SO_RCVBUF socket  
>>>> option)
>>>> to 10000 we oberserve the following:
>>>>
>>>> - When sending messages of size 1000 bytes, the receiver SACK the  
>>>> first,
>>>> announces 9000 bytes windows, SACKs the second announces 8000 bytes
>>>> and so on. Look fine. The a_rwnd goes down to 0 and discards  
>>>> messages.
>>>> Everything is fine.
>>>>
>>>> - When sending messages of size 100 bytes, the receiver SACKs the  
>>>> first
>>>> messages and reduces the a_rwnd accordingly. Then it looks like the
>>>> receive buffer grows, because messages are accepted and the  
>>>> a_rwnd does
>>>> not shrink. Is this intended?
>>> No.  The a_rwnd should go down to 0 as before.
>>>
>>>> We also figured out that after about 670947 messages of size 100  
>>>> bytes
>>>> the association is aborted. Is this intended?
>>> This is also not intended.  We'll take a look.
>>>
>> That does sound odd, yes, a_rwnd should be reduced in response to  
>> each received
>> frame.  do you have tcpdumps of this test available?
>> Thanks
>> Neil
>
> I think this is hitting a condition where the receiver buffer is  
> exhausted prior
> to rwnd.  We generally mark the TSN as received prior to attempting  
> an internal allocation to carry the data.  Thus, if this allocation  
> fails, we'll continue
> reporting the tsn as received and move the cum-tsn if appropriate.
This would explain the behaviour completely.
>
>
> We've been trying to figure out what the correct way to solve this  
> condition is
> and so far haven't come up with a workable solution.
We are looking at the behavior of different implementations to look at  
interoperability
issues. That is how we came to test this...
>
>
> One approach is to reduce the a_rwnd to 1 when the receive buffer  
> reaches some
> consumption threshold.  This would allow 1 packet in flight to allow  
> receive buffer to drain.  Another piece of this puzzle is also SWS  
> avoidance.  We currently have somewhat poor algorithm that allows a  
> max of 1 MTU in transit.
BSD reduces the a_rwnd to 1 in case of small windows (less than 3000  
bytes) for SWS avoidance,
which you have to do anyway. And it makes sure that it does not report  
a message as received when it
is discarded.
>
>
> -vlad
>

