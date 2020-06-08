From: Andreas Fink <afink@list.fink.org>
Date: Mon, 08 Jun 2020 06:13:31 +0000
Subject: Re: EAGAIN
Message-Id: <B35C6E8E-7AB4-40FA-ADE9-FDD5B5C8D0FE@list.fink.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
In-Reply-To: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



> On 7 Jun 2020, at 19:31, Michael Tuexen <michael.tuexen@lurchi.franken.de> wrote:
> 
> 
> 
>> On 7. Jun 2020, at 19:05, David Laight <David.Laight@ACULAB.COM> wrote:
>> 
>> From: Michael Tuexen
>>> Sent: 07 June 2020 16:18
>>>> On 7. Jun 2020, at 16:04, David Laight <David.Laight@ACULAB.COM> wrote:
>>>> 
>>>> From: Michael Tuexen
>>>>> Sent: 07 June 2020 13:48
>>>> ...
>>>>> If you killed the peer, I would assume that there is an SCTP message containing an
>>>>> ABORT chunk in the wire. Is that true? If that is true, you could subscribe to
>>>>> SCTP_ASSOC_CHANGE notification, which should tell you.
>>>> 
>>>> Actually for TCP-style 1-1 connections you must subscribe to
>>>> SCTP_ASSOC_CHANGE.
>>> 
>>> I guess you are referring to UDP (1-to-many) style sockets.
>>> For 1-to-1 style sockets, the normal error handling should
>>> work, like it does for TCP (returning -1 in a system call
>>> and errno being ETIMEDOUT or ECONNRESET). At least this is
>>> the way intended by the specification and I think Linux
>>> does it that way.
>> 
>> Nope, if you take a program that will run over TCP or SCTP
>> then receipt of an INIT chunk (with matching ports etc)
>> goes through the connection handshake sequence and the
>> application isn't given any indication.
> Right. But once the association is established and you
> subscribed the SCTP_ASSOC_CHANGE on the listener, the listener
> should become readable, then you call accept() and the accepted
> socket should become readable, because you can read a SCTP_ASSOC_CHANGE.
>> 
>> You might expect the incoming INIT to cause a disconnect
>> indication on the old socket and a new 'listen' event. 
> No, I don't expect that.
>> But that isn't what happens.
> I'm not sure if you are talking about a restart event. That would
> actually be given (after the handshake) in an SCTP_ASSOC_CHANGE event.
> 
> But Andreas is using a 1-to-many style socket. Assume he is constantly sending
> to a peer. I would assume that an sctp_sendv() call triggers the sending
> of an INIT, an ABORT comes back, you clear all buffered data for that
> association and the next sctp_sendv() would trigger the sending of the next INIT.
> So he should observe a lot of sctp_sendv() failing, but some of them
> should succeed. Andreas are you seeing such a pattern? How does it look on the wire?

I have to reproduce this in my lab to get a trace.

As far as I remember we ended up having the server side trying to send old data while the client side tries to establish a new connection and gets association up while the old side has no trace of this new connection. I definitively catch all SCTP_ASSOC_CHANGE events but I did not process it until after the send loop sending one single packet.
The connections are nailed down ones. Meaning the sender uses the same source port to connect. I guess this might be important to know.

I currently worked around the issue by breaking my sendloop if we get assoc change (which is read in a different thread) or when EAGAIN is received more than 100 times in a row.
I will try to simulate this with a small test programm to see how it looks on the wire.
