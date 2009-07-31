From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 31 Jul 2009 14:18:11 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <4A72FD23.9060303@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Michael T=FCxen wrote:
> On Jul 31, 2009, at 3:17 AM, Doug Graham wrote:
>=20
>> On Thu, Jul 30, 2009 at 07:40:47PM -0400, Doug Graham wrote:
>>> On Thu, Jul 30, 2009 at 05:24:09PM -0400, Vlad Yasevich wrote:
>>>> If you still have BSD setup, can you try increasing you message size
>>>> to say 1442 and see what happens.
>>>>
>>>> I'd expect bundles SACKs at 1440 bytes, but then probably a separate
>>>> SACK and DATA.
>>>
>>> The largest amount of data I can send and still have the BSD server
>>> bundle
>>> a SACK with the response is 1436 bytes.  The total ethernet frame size
>>> at that point is 1514 bytes, so this seems correct.  I've attached
>>> wireshark captures with data sizes of 1436 bytes and 1438 bytes.
>>> It's interesting to note that if BSD decides not to bundle a SACK,
>>> it instead sends a separate SACK packet immediately; it does not wait
>>> for the SACK timer to timeout.  It first sends the SACK, then the DATA
>>> immediately follows. I don't think Wei's patch would do this; I think
>>> that if his patch determined that bundling a SACK would cause the packet
>>> to exceed the MTU, then the behaviour will revert to what it was before
>>> my patch is applied: ie the SACK will not be sent for 200ms.
>>
>> I think it's about time that I sat down and carefully read the RFC all
>> the
>> way through before trying to do much more analysis of what's happening on
>> the wire, but I did just notice something surprising while try slightly
>> larger packets.  For one, I could've sworn that I saw a ethernet frame
>> of 1516 bytes at one point, but I didn't save the capture and don't
>> know whether it was Linux or BSD that sent the oversized frame, or just
>> my imagination.  But here's one that I did capture when sending and
>> receiving 1454 bytes of data.  1452 bytes is the most data that will fit
>> in a single 1514 byte ethernet frame, so 1454 bytes must be fragmented.
>> The capture is attached, but here's one iteration:
>>
>> 13 2.002632    10.0.0.15   10.0.0.11   DATA (1452 bytes data)
>> 14 2.203092    10.0.0.11   10.0.0.15   SACK
>> 15 2.203153    10.0.0.15   10.0.0.11   DATA (2 bytes data)
>> 16 2.203427    10.0.0.11   10.0.0.15   SACK
>> 17 2.203808    10.0.0.11   10.0.0.15   DATA (1452 bytes data)
>> 18 2.403524    10.0.0.15   10.0.0.11   SACK
>> 19 2.403686    10.0.0.11   10.0.0.15   DATA (2 bytes data)
>> 20 2.603285    10.0.0.15   10.0.0.11   SACK
>>
>> What bothers me about this is that Nagle seems to be introducing a delay
> This is the common bad interaction between Nagle and delayed SACKs.
>> here.  The first DATA packets in both directions are MTU-sized packets,
>> yet both the Linux client and the BSD server wait 200ms until they get
>> the SACK to the first fragment before sending the second fragment.
>> The server can't send its reply until it gets both fragments, and the
>> client can't reassemble the reply until it gets both fragments, so from
>> the application's point of view, the reply doesn't arrive until 400ms
>> after the request is sent.  This could probably be fixed by disabling
>> Nagle with SCTP_NODELAY, but that shouldn't be required.  Nagle is only
>> supposed to prevent multiple outstanding *small* packets.
> Yes, but Nagle operates at the level of chunks...
> This problem is one of the reasons why we have

Michael

That doesn't make sense.  Nagle was meant to prevent sending a bunch small
packets.  That doesn't apply if the user sends a large enough message that =
it
ends up being fragmenting into a full sized data chunk and a small-sized da=
ta
chunk.  It doesn't sound like Nagle should apply to the second fragment.

-vlad


> draft-tuexen-tsvwg-sctp-sack-immediately-02
> The kernel can set the I-Bit on the first chunk...
> Currently the only way around this is to disable Nagle at all...
>>
>> If you tell me I'm full of crap, I promise I'll shut up until I read
>> the whole RFC :-)
>>
>> --Doug.
>> <bsd72_server_1454.cap>
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

