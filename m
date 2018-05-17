From: Andreas Fink <afink@list.fink.org>
Date: Thu, 17 May 2018 19:14:00 +0000
Subject: Re: SCTP nailed down connections trouble
Message-Id: <35603085-5DCC-4F4F-AB6E-AECD2DA5E643@list.fink.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
In-Reply-To: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



> On 17 May 2018, at 18:58, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> From: Marcelo Ricardo Leitner
>> Sent: 16 May 2018 17:29
> ...
>> On the simultaenous open, when you connect to Cisco ITP or the others,
>> doesn't it send an Abort right after the INIT request reaches it? If
>> they don't, I find it odd.
> 

No they dont send abort because they are configured to establish a connection. This means they start handshaking with INIT_ACK and COOKIE etc. However they also send INIT to you all the time (couple of times per minute).

> I thought that simultaenous connect requests (colliding INIT)
> were expected to result in an actual connection.

this is true. I have seen this when I run my test program at the very same moment.

> 
> So two hosts can establish a connection by sending INIT (etc)
> with both the source and destination port numbers set to the
> same (well known) value.
> 
> 	David

The problem is not really on the network level but on the understanding of how the API was meant to be.
The mystery has been solved now. The Userspace API for SCTP is not as clear as it could be (at least to me).
From a network perspective (looking at wireshark traces etc), you simply see a connection being established between two nodes. Either side can be first to send INIT's and it doesnt matter. At the end both sides have a working pipe they can stuff data into. So it was expected to see this metapher in the userspace API as well but instead, we have client/server again there even though the underlying network protocol is true peer to peer.

So you do 

	sctp_connectx,()

to create an outbound connection. It will succeed if the other side is ready to listen. If not, you receive ABORT and youre dead. And if the other side starts up  half a second earlier, it doesn't matter, you are not listening hence the kernel doesnt care if you are having established that exact session. It only worked if the INIT's collide.

To listen for an inbound connection you simply call

	listen()

(followed by potential accept() etc)

When you do a peer to peer connection where it doesn't matter which side establishes first (a nailed down connection where source and destination port and IP's are predefined), one could expect you could do this with async listen() and sctp_connectx(). However this fails. sctp_connectx() complains that the socket is in use already. By calling listen() you say this is inbound only. On the other hand by calling sctp_connectx() you tell the system it is outbound *only*. This was my wrong assumption that this is all it takes. But because this responds incoming INITS from the other side with ABORT's instead of accepting, you basically kill the other side and vice versa.
Incoming INIT's will cause an abort instead of being accepted and handed to this peer to peer connection as it would make sense in my eyes.

This is what was puzzling me. Before I had hardware I can always connect to (sctp_connectx *always* succeded) or I was in passive mode (which means I only did listen and waited for someone to connect to me). Trying to do both at the same time as it should be, opened the pandoras box.

The solution is to use two sockets. One to listen, and another one for sctp_connectx. This sounds like pseudo peer to peer in a old TCP world again.
This way the listen eliminates the ABORT going back and the sctp_connectx makes sure there's INIT's going out. The liste one you never do anything with it. You only use it to tell the kernel that it should not send ABORTs for that part and voila things start magically working again. The SCTP API brings so many new options that they are confusing on how to be used.

The subtle differences between the Linux implementation and the FreeBSD or MacOS X implementation then added to further confusion. But finally my connections to other vendor equipment works again. And when I have finished restructuring my own stuff  a bit, true peer to peer should finally start working again.


Thanks for your hints. A few tipps where very useful


Andreas



