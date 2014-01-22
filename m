From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 22 Jan 2014 14:52:14 +0000
Subject: Re: [PATCH] net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver's buffer
Message-Id: <52DFDB1E.7070701@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52D8D544.5050501@nsn.com> <063D6719AE5E284EB5DD2968C1650D6D463A0F@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D463A0F@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: David Laight <David.Laight@ACULAB.COM>, 'Matija Glavinic Pecotic' <matija.glavinic-pecotic.ext@nsn.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: Alexander Sverdlin <alexander.sverdlin@nsn.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On 01/22/2014 08:41 AM, David Laight wrote:
> From: Matija Glavinic Pecotic
>> Implementation of (a)rwnd calculation might lead to severe
performance issues
>> and associations completely stalling. These problems are described
and solution
>> is proposed which improves lksctp's robustness in congestion state.
>>
>> 1) Sudden drop of a_rwnd and incomplete window recovery afterwards
>>
>> Data accounted in sctp_assoc_rwnd_decrease takes only payload size
(sctp data),
>> but size of sk_buff, which is blamed against receiver buffer, is not
accounted
>> in rwnd. Theoretically, this should not be the problem as actual size
of buffer
>> is double the amount requested on the socket (SO_RECVBUF). Problem
here is
>> that this will have bad scaling for data which is less then sizeof
sk_buff.
>> E.g. in 4G (LTE) networks, link interfacing radio side will have a
large portion
>> of traffic of this size (less then 100B).
> ...
>>
>> Proposed solution:
>>
>> Both problems share the same root cause, and that is improper scaling
of socket
>> buffer with rwnd. Solution in which sizeof(sk_buff) is taken into
concern while
>> calculating rwnd is not possible due to fact that there is no linear
>> relationship between amount of data blamed in increase/decrease with
IP packet
>> in which payload arrived. Even in case such solution would be followed,
>> complexity of the code would increase. Due to nature of current rwnd
handling,
>> slow increase (in sctp_assoc_rwnd_increase) of rwnd after pressure
state is
>> entered is rationale, but it gives false representation to the sender
of current
>> buffer space. Furthermore, it implements additional congestion
control mechanism
>> which is defined on implementation, and not on standard basis.
>>
>> Proposed solution simplifies whole algorithm having on mind
definition from rfc:
>>
>> o  Receiver Window (rwnd): This gives the sender an indication of the
space
>>    available in the receiver's inbound buffer.
>>
>> Core of the proposed solution is given with these lines:
>>
>> sctp_assoc_rwnd_account:
>> 	if ((asoc->base.sk->sk_rcvbuf - rx_count) > 0)
>> 		asoc->rwnd = (asoc->base.sk->sk_rcvbuf - rx_count) >> 1;
>> 	else
>> 		asoc->rwnd = 0;
>>
>> We advertise to sender (half of) actual space we have. Half is in the
braces
>> depending whether you would like to observe size of socket buffer as
SO_RECVBUF
>> or twice the amount, i.e. size is the one visible from userspace,
that is,
>> from kernelspace.
>> In this way sender is given with good approximation of our buffer space,
>> regardless of the buffer policy - we always advertise what we have.
Proposed
>> solution fixes described problems and removes necessity for rwnd
restoration
>> algorithm. Finally, as proposed solution is simplification, some
lines of code,
>> along with some bytes in struct sctp_association are saved.
>
> IIRC the 'size' taken of the socket buffer is the skb's 'true size'
and that
> includes any padding before and after the actual rx data. For short
packets
> the driver may have copied the data into a smaller skb, for long
packets it
> is likely to be more than that of a full length ethernet packet.
> In either case it can be significantly more than sizeof(sk_buff)
(190?) plus
> the size of the actual data.

SCTP currently doesn't support GRO, so each packet is limited to
ethernet packet plus sk_buff overhead.  What throws a real monkey
wrench into this whole accounting business is SCTP bundling.  If you
bundle multiple messages into the single packet, accounting for it
is a mess.

>
> I'm also not sure that continuously removing 'credit' is a good idea.
> I've done a lot of comms protocol code, removing credit and 'window
> slamming' acks are not good ideas.

This patch doesn't continuously remove 'credit'.  It advertises the
closest approximation of the window that we support and computes it
the same way as we do for Initial Window (available sk_rcvbuff >> 1).
As the receiver drains the receive queue, available buffer will increase
and the available window will grow.

In fact, the current implementation does more 'windows slamming' then
this proposed patch.

>
> Perhaps the advertised window should be bounded by the configured socket
> buffer size, and only reduced if the actual space isn't likely to be large
> enough given the typical overhead of the received data.

Problem is there is no typical overhead due to the message oriented
nature of the SCTP, and the socket buffer limits entire buffer space
(overhead included).   What happens when the socket buffer buffer is
consumed faster then the window due to overhead being significantly
larger then the payload?  You have "window slamming" of the worst
kind.  The available window slowly decreases until it hits a point
receive buffer exhaustion and then it slams shut.

This patch is better is that it gradually reduces the window based
on available buffer space providing a more accurate depiction of what
is happening on the receiver.

>
> Similarly, as the window is opened after congestion it should be increased
> by the amount of data actually removed (not the number of free bytes).
> When there is a significant amount of space the window could be increased
> faster - allowing a smaller number of larger skb carrying more data be
queued.
>
> As a matter of interest, how does TCP handle this?

TCP also calculates it's available window based on available receive
buffer space.

-vlad
>
> 	David
>
>
N�����r��y���b�X��ǧv�^�)޺{.n�+����{���i�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+�����ݢj"��!tml>

