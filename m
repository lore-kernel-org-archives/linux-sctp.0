From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 07 Jun 2020 13:46:04 +0000
Subject: Re: EAGAIN
Message-Id: <5B9B0EF5-653B-4AFD-99B0-41D94D480956@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
In-Reply-To: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 7. Jun 2020, at 14:59, Andreas Fink <afink@list.fink.org> wrote:
> 
> 
> 
>> On 7 Jun 2020, at 14:47, Michael Tuexen <Michael.Tuexen@lurchi.franken.de> wrote:
>> 
>>> On 7. Jun 2020, at 14:18, Andreas Fink <afink@list.fink.org> wrote:
>>> 
>>> Hello folks,
>>> 
>>> I run into a strange issue with SCTP under Linux and I'm not sure whats the right approach to fix this.
>>> 
>>> I have a listener thread which listens on a port for multiple inbound connections
>>> I have a sender thread which sends packets to peers by using the same socket and doing a sctp_sendv call.
>>> Sockets are always in non blocking mode.
>> So a single SOCK_SEQPACKET socket for sending and receiving, right?
> 
> correct
> 
>>> 
>>> When the remote side gets stopped (process killed),  the sctp_sendv starts returning 0 and errno is set to EAGAIN and we constantly retry.
>> When it returns 0, you can't look at errno. errno is only set to a correct value, if -1 is returned.
> 
> 
> I actually check if return value is > 0. So probably -1 applies here. Returning 0 doesnt make any sense anyway.
> 
>> 
>> If you killed the peer, I would assume that there is an SCTP message containing an
>> ABORT chunk in the wire. Is that true?
> 
> I can not currently verify that. But we have seen this happening when the remote application (which uses the same mechanism) got killed or has crashed.
> So the operating system's sctp driver should have sent ABORT I believe. We noticed that when the remote application restarts, it can not reestablish the connection somehow, probably because the main application is still busy looping sending old data in the queue.
> 
> 
>> If that is true, you could subscribe to
>> SCTP_ASSOC_CHANGE notification, which should tell you.
> 
> 
> I am subscribed to SCTP_ASSOC_CHANGE but I didnt catch anything there.
> (or I catched it in the receiver thread and the sender thread is not checking the new status in its tight sending loop)
OK.
> 
> My question is, what is the exact meaning of EAGAIN here? Does it mean that the send buffer is full?
My answer is not specific to the Linux implementation, since I don't know it. But EAGAIN is signalled,
if a request can't be fulfilled right now, but might work at some later time. Just hammering
on it in a busy loop might not be the best idea.
If you would use SOCK_STREAM socket (1-to-1), I would suggest to use select/poll to check
for writability.

So I'm wondering if the following actually works, maybe you can test it:
1. Let an association be up. Use a one-to-many style socket.
2. Call continuously sctp_sendv().
3. Kill the peer and restart it.
4. Does the association gets killed?
5. Does a new association gets established triggered by the sctp_sendv() calls?

In addition: What happens if the association times out instead of being killed by an ABORT?

Best regards
Michael
> Why am I not getting a simple error because the specified assoc is down?
> 
> 
