From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 11 Dec 2009 15:52:22 +0000
Subject: Re: [Lksctp-developers] [tsvwg] sctp multihoming query
Message-Id: <4B226AB6.5020903@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org



Padmalochan Moharana wrote:
> Hi Vlad,
>=20
> Thanks for this information .Can you please the kernel version in which t=
his
> issue has been fixed.

I think 2.6.30 had the HB stuff fixed up better.

-vlad

>=20
> Br,
> Padmalochan
>=20
>=20
> On Thu, Dec 10, 2009 at 8:57 PM, Vlad Yasevich <vladislav.yasevich@hp.com=
>wrote:
>=20
>>
>> Padmalochan Moharana wrote:
>>> Hi ,
>>>
>>> After testing I found that Kernel does not respond HB_ACK properly even
>>> if after setting rule for source based routing.
>>>
>>> Bellow is the kernel and lksctp version.
>>>
>>> OS : 2.6.9-55.EL
>>>
>>> Lksctp : lksctp-1.0.8
>>>
>>> Br,
>>>
>>> Padmalochan
>> For questions regarding linux implementation, please send your queries
>> to linux-sctp@vger.kernel.org.
>>
>> The problem you are seeing has been fixed, just not in the old version
>> you are using.
>>
>> -vlad
>>
>>>
>>> On Tue, Dec 8, 2009 at 7:43 PM, Randy Stewart <randall@lakerest.net
>>> <mailto:randall@lakerest.net>> wrote:
>>>
>>>     Zoltan:
>>>
>>>     I agree with your assessment but I don't think the IP layer would be
>>>     overwriting the
>>>     IP address... At least I know in the FreeBSD stack it would not..
>>>     But you WOULD see
>>>     that behavior. Basically the stack knows which is going to be the
>>>     egress interface
>>>     and will always try to set the IP address (if possible) to that
>>>     address. This
>>>     is needed to get around ingress filtering.
>>>
>>>     R
>>>
>>>
>>>     On Dec 4, 2009, at 11:06 AM, Kiss, Zoltan (NSN - HU/Budapest) wrote:
>>>
>>>         Hi,
>>>
>>>         This behaviour is probably because of IP layer routing config.
>>>         If Host B's routing table says (IP a) is reachable over (IP c)
>>>         (and over its corresponding interface), then it will send out
>>>         there, and probably it also overwrites the source IP provided by
>>>         SCTP layer. Source-based routing can avoid this problem, or if
>>>         both side is multihomed, simple static routing can also do the
>> job.
>>>         Regards,
>>>
>>>         Zolt=E1n
>>>
>>>         -----Original Message-----
>>>         From: tsvwg-bounces@ietf.org <mailto:tsvwg-bounces@ietf.org>
>>>         [mailto:tsvwg-bounces@ietf.org <mailto:tsvwg-bounces@ietf.org>]
>>>         On Behalf Of ext Lars Eggert
>>>         Sent: Friday, December 04, 2009 7:30 PM
>>>         To: Sudhanva Mudigere Narayana Gowda
>>>         Cc: ietf@ietf.org <mailto:ietf@ietf.org> Discussion; tsvwg
>>>         Subject: Re: [tsvwg] sctp multihoming query
>>>
>>>         Hi,
>>>
>>>         you really want to be asking this on the TSVWG list. CC and
>>>         Reply-To set accordingly.
>>>
>>>         Lars
>>>
>>>         On 2009-12-4, at 1:57, Sudhanva Mudigere Narayana Gowda wrote:
>>>
>>>             Hi,
>>>             I have a query regarding sctp multihoming behavior.
>>>
>>>             I have setup a multihomed association and this is my
>> observation
>>>             Host_A (IP a): Local single Homed endpoint
>>>
>>>             Host_B (IP b(Primary), IP c(secondary)): Remote multiHomed
>>>             endpoint
>>>
>>>             During Heartbeat I see that even though the Heart beat req
>>>             is to the secondary ip of Host_B, the Host_B uses its
>>>             primary ip as source when sending back the Heartbeat Ack.
>>>             Ie  Host_A (IP a) --------HEART_BEAT_REQ----------->
>>>             Host_B(IP c)
>>>               Host_A (IP a)<--------- HEART_BEAT_ACK---------- Host_B(IP
>> b)
>>>             also during data exchange I observed that even when the data
>>>             is sent to the secondary ip of Host_B, the SACK is being
>>>             sent back from the primary ip of Host_B.
>>>             Host_A (IP a) --------DATA_MSG-----------> Host_B(IP c)
>>>             Host_A (IP a)<--------- SACK------------------- Host_B(IP b)
>>>
>>>             Is this the expected behavior, shouldn't the node use the
>>>             same ip on which it received the data or Heart_beat_req on
>>>             while sending back the responses(Heart_beat_ack or SACK).
>>>             Due to this behavior if the primary ip of an endpoint fails
>>>             the association goes down as the node will not be able to
>>>             transmit any Heartbeat_Req or Heartbeat_Ack.
>>>
>>>             On Host_A I blocked the incoming packets which has Host_B(IP
>>>             b) as source and I expected Host_B to retry using its
>>>             secondary ip addr, but I observed that even the retries from
>>>             Host_B uses its primary ip .
>>>
>>>             Does this mean that an endpoint always uses its primary-ip
>>>             while sending packets, but might receive packets on primary
>>>             or secondary-ip?
>>>
>>>             Thanks
>>>             Sudhanva
>>>             <ATT00001..txt>
>>>
>>>
>>>
>>>     -----
>>>     Randall Stewart
>>>     randall@lakerest.net <mailto:randall@lakerest.net>
>>>
>>>
>>>
>>>
>>>
> -------------------------------------------------------------------------=
-----
> Return on Information:
> Google Enterprise Search pays you back
> Get the facts.
> http://p.sf.net/sfu/google-dev2dev
> _______________________________________________
> Lksctp-developers mailing list
> Lksctp-developers@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>=20
