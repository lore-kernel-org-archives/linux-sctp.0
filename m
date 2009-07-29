From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 29 Jul 2009 15:19:08 +0000
Subject: Re: Do piggybacked ACKs work?
Message-Id: <4A70686C.2060207@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090725020953.GA17581@nortel.com>
In-Reply-To: <20090725020953.GA17581@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Michael T=FCxen wrote:
>=20
> On Jul 29, 2009, at 12:31 AM, Doug Graham wrote:
>=20
>> On Tue, Jul 28, 2009 at 11:18:05PM +0200, Michael T?xen wrote:
>>>> I don't think that's what the RFC says, but I guess only the
>>>> author(s) of
>>>> the RFC could tell us what they really meant.  Your interpretation
>>>> doesn't
>>>> make any sense to.
>>>
>>> Let us see the tracefile and I can tell you if that behaviour is the
>>> one the authors of the RFC intended...
>>
>> Heh.  I'm guessing that you're one of the authors then?  I see you given
>> credit in RFC 4960, but the only author listed at the top is R. Stewart.
> Randy is the editor of the document...
>>
>> I've attached linux and BSD capture files, and the client and server
>> test programs.  The client just sends a request to the server, and then
>> waits for a reply.  The client loops four times and sleeps 2 seconds
>> between iterations.  I ran the client on a Fedora 10 laptop in all cases
>> (kernel version 2.6.27.25) and did the wireshark capture on the same
>> laptop.  sctp_bsd72_server.cap is the capture when running the server
>> on a FreeBSD 7.2 machine.  sctp_linux_server.cap is the capture when
>> running the server on a Fedora 10 desktop machine.  A single iteration
>> with the BSD server looks like:
>>
>>  7 2.000205    10.0.0.15     10.0.0.11         SCTP     DATA
>>  8 2.000501    10.0.0.11     10.0.0.15         SCTP     SACK DATA
>>  9 2.200484    10.0.0.15     10.0.0.11         SCTP     SACK
> This is what I would expect.

Hmm... time to re-read 6.1 and 6.2...

>>
>> So one DATA packet from client to server, then the reply data packet
>> from server to client with a bundled SACK, then the SACK from client
>> to server to acknowledge the reply.  The last SACK does have to wait
>> for the SACK timer to expire; this is to be expected, since no more
>> data is sent until the next iteration in a couple seconds.
>>
>> A single iteration with the Linux server looks like:
>>
>>  7 2.000161    10.0.0.15     10.0.0.12         SCTP     DATA
>>  8 2.000495    10.0.0.12     10.0.0.15         SCTP     DATA
>>  9 2.199995    10.0.0.15     10.0.0.12         SCTP     SACK
>> 10 2.200170    10.0.0.12     10.0.0.15         SCTP     SACK
> This is what I would not expect.
> Vlad: Any reason not to bundle the SACK with the DATA chunk?

Since we received only 1 packet so far, the SACK is delayed.  The implement=
ers
have focused on section 6.2, but seemed to have ignored the following text
from 6.1:

   Before an endpoint transmits a DATA chunk, if any received DATA
   chunks have not been acknowledged (e.g., due to delayed ack), the
   sender should create a SACK and bundle it with the outbound DATA
   chunk, as long as the size of the final SCTP packet does not exceed
   the current MTU.  See Section 6.2.

Looks like BSD does this and linux doesn't appear to.  Linux has been doing=
 this
since the beginning...

Doug, can you regenerate you patch with proper commit comment and sign-off
(according to Documentations/SubmittingPatches).

Thanks
-vlad

>>
>>
>>>> In BSD's case, I *did* see it piggyback the SACK.
>>>
>>> I guess you did not specify SCTP_DATA_SACK_IMMEDIATELY in the send()
>>> call...
>>
>> No, I didn't.  If I had, I agree that no piggybacking would have been
>> possible.  That was what I was trying to say: from the trace, it did
>> not look as though BSD was using the immediate SACK feature.
> The I-bit is currently only set when the user requests it or you are
> in SHUTDOWN-PENDING...
>>
>> --Doug.
>> <client.c><server.c><sctp_bsd72_server.cap><sctp_linux_server.cap>
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

