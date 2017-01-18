From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 18 Jan 2017 15:47:09 +0000
Subject: Re: Issue with Forward-TSN-Chunks containing high cum_tsn
Message-Id: <CADvbK_duwW3RS=MD7YP94KooTD3EhPY4mS9iFgRbOThy4OzV=g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117130752.GB6494@aomx-netbook>
In-Reply-To: <20170117130752.GB6494@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Wed, Jan 18, 2017 at 10:53 PM, Michael Tuexen
<Michael.Tuexen@lurchi.franken.de> wrote:
>> On 18 Jan 2017, at 07:01, Xin Long <lucien.xin@gmail.com> wrote:
>>
>> On Wed, Jan 18, 2017 at 12:38 AM, Marcelo Ricardo Leitner
>> <marcelo.leitner@gmail.com> wrote:
>>> On Tue, Jan 17, 2017 at 02:07:52PM +0100, Julian Cordes wrote:
>>>> When a FORWARD-TSN-Chunk with a relative high cum-tsn-value is injected
>>>> then the linux kernel ignores this valid FORWARD-TSN-Chunk.
>>>> It should instead send an SACK-Chunk where the cum_tsn is equal to the
>>>> cum_tsn specified in the FORWARD-TSN.
>>>
>>> You mean, with the cum_tsn specified on the *injected* FORWARD-TSN.
>>> Is that so?
>> from the test  script
>> +0.0 < sctp: FORWARD_TSN[cum_tsn=99999, ids=3D[{1, 1}]]
>> I think so.
>>
>> But 99999 is so high relative to the base_tsn of tsnmap,
>> it overflowed tsnmap, such a big gap is disallowed in linux
>> sctp. it has to drop this packet.
>>
>>        /* Verify that we can hold this TSN and that it will not
>>         * overlfow our map
>>         */
>>        if (!TSN_lt(tsn, map->base_tsn + SCTP_TSN_MAP_SIZE))
>>                return -1;
>>
>> Hi, Julian, maybe you can improve your script by using a lower
>> value for linux.
> but this would mean that Linux only supports the peer skipping some small=
 number of TSN's.
> Isn't this a limitation of the implementation?
not really, there is map->base_tsn, it will grow when the tsn has been sack=
ed.
like tsn=8000 and below 8000  have been sacked, map->base_tsn could be
8000, then the map range would be 8000 ~ 8000 + SCTP_TSN_MAP_SIZE.

But the test case sent tsn=3D1, then try to skip tsn=99999, that's really n=
ot
a normal case.

and to set SCTP_TSN_MAP_SIZE@96 for reasons:

/* Guess at how big to make the TSN mapping array.
 * We guarantee that we can handle at least this big a gap between the
 * cumulative ACK and the highest TSN.  In practice, we can often
 * handle up to twice this value.
 *
 * NEVER make this more than 32767 (2^15-1).  The Gap Ack Blocks in a
 * SACK (see  section 3.3.4) are only 16 bits, so 2*SCTP_TSN_MAP_SIZE
 * must be less than 65535 (2^16 - 1), or we will have overflow
 * problems creating SACK's.
 */
#define SCTP_TSN_MAP_INITIAL BITS_PER_LONG
#define SCTP_TSN_MAP_INCREMENT SCTP_TSN_MAP_INITIAL
#define SCTP_TSN_MAP_SIZE 4096

>
> Best regards
> Michael
>>
>>>
>>>>
>>>> Testscript available at:
>>>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/rec=
eiver-side-implementation/receiver-side-implementation-11.pkt
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
