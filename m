From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 27 Oct 2009 15:07:03 +0000
Subject: Re: [tsvwg] SCTP Socket API modification proposal - update
Message-Id: <4AE70C97.6050507@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org



Florian Niederbacher wrote:
> Hi,
> thank you very much for the patch. Now it works like a charm! I need now
> only to change
> the MAX_BURST value otherwise after the connection goes into idle state
> the cwnd will be reduced to fast.
> (Default MAX_BURST  =3D 4 and MTU =3D 1500 ->  cwnd =3D 6000)
> I guess this is intended by the rule from RFC 4960 in section
>=20
>=20
>      6.1. Transmission of DATA Chunks
>=20
>=20
>      D) When the time comes for the sender to transmit new DATA chunks,
>      the protocol parameter Max.Burst SHOULD be used to limit the
>      number of packets sent.  The limit MAY be applied by adjusting
>      cwnd as follows:
>=20
>      if((flightsize + Max.Burst*MTU) < cwnd) cwnd =3D flightsize +
>      Max.Burst*MTU
>=20
>=20
> I am right?
>=20

I think this rule gets mis-applied in this situation.  The idea behind max =
burst
is to not burst out a lot of data in response to a SACK.

Can you try this patch and let me know what you see.

Thanks
-vlad

> Are there some rules or investigations about what value MAX_BURST should
> be set to?
> I guess a value of 4 is to restrictive, but its just my opinion.
>=20
>=20
> Regards
> Florian
>=20
>=20
> Vlad Yasevich schrieb:
>>
>> Florian Niederbacher wrote:
>>> Hi, can you tell me please what exactly do I need to modify that HB does
>>> update the last_used time stamp .
>>> I will fix it too and recompile to proceed with my measurements. Thanks
>>> for finding and fixing the bug!
>>>
>>
>> Actually, last_used time stamp is rather pointless so I have a patch to
>> remove it.  It also fixes a bug to make sure idle detection works when
>> HB are disabled.  I've attached it below.
>>
>> -vlad
>>
>>> Regards
>>> Florian
>>>
>>> Vlad Yasevich schrieb:
>>>> Hi Florian
>>>>
>>>>
>>>> Florian Niederbacher wrote:
>>>>> Vlad Yasevich schrieb:
>>>>>> Florian Niederbacher wrote:
>>>>>>> Vlad Yasevich schrieb:
>>>>>>>> Florian Niederbacher wrote:
>>>>>>>>> Sorry, here the update what i have seen.
>>>>>>>>>
>>>>>>>>> The rule what get used is to lower the cwnd over time if is
>>>>>>>>> inactive:
>>>>>>>>>
>>>>>>>>>
>>>>>>>> [... code snipped ...]
>>>>>>>>
>>>>>>>>> You don't think that a lower value each RTO is to restrictive?
>>>>>>>> The code you pointed to runs every HB interval.   The interval is
>>>>>>>> reset every time a new packet with DATA is sent.
>>>>>>>>
>>>>>>>> So, the cwnd is halved after the rto + jitter + hbinterval.
>>>>>>> Yes that's how should it work - lowering every HB interval.
>>>>>>> The HB interval is set to 30000 but the cwnd is decreased every RTO
>>>>>>> and not
>>>>>>> halved after the rto + jitter + hbinterval as it should (and as i
>>>>>>> also
>>>>>>> want ;-) )
>>>>>>>
>>>>>>> But it works with RTO and not with HB interval.!
>>>>>> Is that based on experience or based on code observation?
>>>>>>
>>>>> This is based on experience, because i log the cwnd during the
>>>>> transmission.
>>>>> Its done with polling in microseconds.
>>>>>
>>>>> I transfer first a file, then i stop the transmission and keep the
>>>>> connection with sleep for 10 sec -> should be then in INACTIVE state,
>>>>> and cwnd is reduced in RTO steps cwnd/2 until reaches 4*MTU.
>>>> I just conducted an experiment to try to reproduce this.  While I did
>>>> find a small bug in the code, it was NOT that cwnd gets reduced to
>>>> fast.
>>>>
>>>> Based on my output, I see the cwnd getting halved ever 30000+ ms.
>>>>
>>>> Here is the output:
>>>> CWND_INACTIVE: cwnd 23376, last_used 275768, current time 283418 (diff
>>>> 30600 ms)
>>>> CWND_INACTIVE: cwnd 11688, last_used 275768, current time 291250 (diff
>>>> 61928 ms)
>>>> CWND_INACTIVE: cnwd 6000, last_used 275768, current time 299118 (diff
>>>> 93400 ms)
>>>>
>>>>
>>>> The bug is that HB do not update last_used time stamp on the transport
>>>> so the
>>>> difference times above are off.  The diff above is really shown based
>>>> on the
>>>> last data packet sent, but the timer interval between congestion window
>>>> reductions comes out to be 31328 ms for the second and 31472 ms for
>>>> the last
>>>> reduction.
>>>>
>>>> As you can see the HB interval of 30000 ms is taken into account.
>>>> According to
>>>> the above, cwnd dropped to 6000 about 10 seconds after the transfer
>>>> stopped.
>>>>
>>>> The time stamps are shown in jiffies.  The difference was converted to
>>>> milliseconds.
>>>>
>>>> -vlad
>>>>
>>>> p.s Michael, if you want off the cc, let me know. :)
>>>>
>>>>> Regards
>>>>> Florian
>>>>>>>    case SCTP_LOWER_CWND_INACTIVE:
>>>>>>>        /* RFC 2960 Section 7.2.1, sctpimpguide
>>>>>>>         * When the endpoint does not transmit data on a given
>>>>>>>         * transport address, the cwnd of the transport address
>>>>>>>         * should be adjusted to max(cwnd/2, 4*MTU) per RTO.
>>>>>>>         * NOTE: Although the draft recommends that this check needs
>>>>>>>         * to be done every RTO interval, we do it every hearbeat
>>>>>>>         * interval.
>>>>>>>         */
>>>>>>> --> *    if (time_after(jiffies, transport->last_time_used +
>>>>>>>                    transport->rto))
>>>>>>>            transport->cwnd =3D max(transport->cwnd/2,
>>>>>>>                         4*transport->asoc->pathmtu);
>>>>>>>        break;
>>>>>>>    }
>>>>>>>
>>>>>>>    transport->partial_bytes_acked =3D 0;
>>>>>>>    SCTP_DEBUG_PRINTK("%s: transport: %p reason: %d cwnd: "
>>>>>>>              "%d ssthresh: %d\n", __func__,
>>>>>>>              transport, reason,
>>>>>>>              transport->cwnd, transport->ssthresh);
>>>>>>> }
>>>>>>>
>>>>>>>
>>>>>>> ---> For HB interval time shouldn't be exchanged here something?
>>>>>>>
>>>>>> This functionality is activated only through SCTP_CMD_TRANSPORT_IDLE
>>>>>> command which is only triggered by the timeout of the HB timer.
>>>>>> So regardless of what the check above does, the code will not run
>>>>>> more often the the HB timer allows it.
>>>>>>
>>>>>> -vlad
>>>>>>
>>>>>>> Regards
>>>>>>> Florian
>>>>>>>
>>>>>>>> That's sufficiently long to determine the idleness of the
>>>>>>>> transport.
>>>>>>>>
>>>>>>>>> TCP uses
>>>>>>>>> also version to save metrics about cwnd and ssthresh and
>>>>>>>>> doesn't set
>>>>>>>>> back so
>>>>>>>>> fast the cwnd. If you have more data transfers over the same
>>>>>>>>> association
>>>>>>>>> but only with some seconds of difference you loose a lot of
>>>>>>>>> performance.
>>>>>>>>> An example would be to work in SCTP as TCP does with "Keepalive".
>>>>>>>>> But in
>>>>>>>>> this case the cwnd value should not decreased so fast.
>>>>>>>>>
>>>>>>>>> I guess a slower way to reduce the cwnd if inactive would help to
>>>>>>>>> improve SCTP performance.
>>>>>>>>> What are your thoughts?
>>>>>>>> You can change the HB interval to wait longer.  The idea is to
>>>>>>>> detect
>>>>>>>> idle
>>>>>>>> connection.
>>>>>>>>
>>>>>>>> -vlad
>>>>>>>>
>>>>>>>>> Regards
>>>>>>>>> Florian
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Florian Niederbacher schrieb:
>>>>>>>>>> Vlad Yasevich schrieb:
>>>>>>>>>>> Florian Niederbacher wrote:
>>>>>>>>>>>> Michael T=FCxen schrieb:
>>>>>>>>>>>>> On Oct 20, 2009, at 10:12 PM, Vlad Yasevich wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>> Florian
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Adding anything to this option would break the ABI at this
>>>>>>>>>>>>>> point
>>>>>>>>>>>>>> especially considering multiple uses of sctp_paddrinfo.
>>>>>>>>>>>>>>
>>>>>>>>>>>> Ok, I thought that it wouldn't such a big effort to add an
>>>>>>>>>>>> additional
>>>>>>>>>>>> value to the structure therefore also the question.
>>>>>>>>>>>>
>>>>>>>>>>>>>> -vlad
>>>>>>>>>>>>> I second that. I do not want to change structures anymore...
>>>>>>>>>>>>> ... and I do not think that adding ssthresh helps much. When
>>>>>>>>>>>>> I'm interested in these values, I'm also interested in any
>>>>>>>>>>>>> change
>>>>>>>>>>>>> of them. So you need some kind of logging infrastructure.
>>>>>>>>>>>>> FreeBSD, for example, has such a infrastructure, but it is
>>>>>>>>>>>>> system specific. Other OSes might have similar things.
>>>>>>>>>>>> I agree to build a logging infrastructure for getting
>>>>>>>>>>>> changes in
>>>>>>>>>>>> userspace only polling is possible and is never such useful
>>>>>>>>>>>> as a
>>>>>>>>>>>> kernel
>>>>>>>>>>>> hook.
>>>>>>>>>>>> Thanks for your comments.
>>>>>>>>>>> If you want asynchronous notifications, that might be more
>>>>>>>>>>> useful.
>>>>>>>>>>> Something
>>>>>>>>>>> that notifies the user when congestion window changes or
>>>>>>>>>>> congestion
>>>>>>>>>>> events
>>>>>>>>>>> occur.
>>>>>>>>>>>
>>>>>>>>>>> It seem that there is a subset of applications that want to know
>>>>>>>>>>> congestion
>>>>>>>>>>> state.  I am not sure why (may be logging purposes).  Right now,
>>>>>>>>>>> these
>>>>>>>>>>> applications periodically poll with either SCTP_STATUS or
>>>>>>>>>>> PEER_ADDR_INFO.
>>>>>>>>>>>
>>>>>>>>>>> -vlad
>>>>>>>>>>>
>>>>>>>>>> Yes that's exactly what I am also doing to log the congestion
>>>>>>>>>> state.
>>>>>>>>>> (but the ssthresh in SCTP is missing)
>>>>>>>>>> In this way I have also noticed following:
>>>>>>>>>>
>>>>>>>>>> After a data transmission is stopped because of the end of file,
>>>>>>>>>> but
>>>>>>>>>> the connection is already up (no close or shutdown)
>>>>>>>>>> the cwnd value is immediately set back to 4*MTU (4*1500 =3D 6000)
>>>>>>>>>> also
>>>>>>>>>> if the cwnd was during the transmission at the maximum of
>>>>>>>>>> the receiver window.(e.g. 130000 - no loss). TCP holds the cwnd
>>>>>>>>>> value
>>>>>>>>>> over a defined time always at the old value (max. cwnd =3D 13000=
0).
>>>>>>>>>>
>>>>>>>>>> Is this value setting in SCTP intended? Maybee I interpret the
>>>>>>>>>> chapter
>>>>>>>>>> 7.2.3 of RFC 4960 wrong. But I guess the value should be set at
>>>>>>>>>> least
>>>>>>>>>> to cwnd/2
>>>>>>>>>> (130000/2 =3D 65000 and this is higher as the 4*MTU) after a
>>>>>>>>>> transmission stops. The benefit is if you continue after some
>>>>>>>>>> seconds
>>>>>>>>>> with another data transmission maybe on another stream but on the
>>>>>>>>>> same
>>>>>>>>>> connection you have a higher cwnd value and therefore a higher
>>>>>>>>>> throughput rate.
>>>>>>>>>>
>>>>>>>>>> cite from RFC 4960:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>        7.2.3. Congestion Control
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>   Upon detection of packet losses from SACK (see Section 7.2.4
>>>>>>>>>> <http://tools.ietf.org/html/rfc4960#section-7.2.4>), an
>>>>>>>>>>   endpoint should do the following:
>>>>>>>>>>
>>>>>>>>>>      ssthresh =3D max(cwnd/2, 4*MTU)
>>>>>>>>>>      cwnd =3D ssthresh
>>>>>>>>>>      partial_bytes_acked =3D 0
>>>>>>>>>>
>>>>>>>>>>   Basically, a packet loss causes cwnd to be cut in half.
>>>>>>>>>>
>>>>>>>>>>   When the T3-rtx timer expires on an address, SCTP should
>>>>>>>>>> perform
>>>>>>>>>> slow
>>>>>>>>>>   start by:
>>>>>>>>>>
>>>>>>>>>>      ssthresh =3D max(cwnd/2, 4*MTU)
>>>>>>>>>>      cwnd =3D 1*MTU
>>>>>>>>>>
>>>>>>>>>>   and ensure that no more than one SCTP packet will be in flight
>>>>>>>>>> for
>>>>>>>>>>   that address until the endpoint receives acknowledgement for
>>>>>>>>>>   successful delivery of data to that address.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Best regards
>>>>>>>>>> Florian
>>>>>>>>>>
>>>>>>>>>>>> Best regards
>>>>>>>>>>>> Florian
>>>>>>>>>>>>
>>>>>>>>>>>>> Best regards
>>>>>>>>>>>>> Michael
>>>>>>>>>>>>>> Florian Niederbacher wrote:
>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>> what thinks the community and the SCTP developers about an
>>>>>>>>>>>>>>> additional
>>>>>>>>>>>>>>> value in SCTP_GET_PEER_ADDR_INFO ?
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> TCP allows to retrieve values about the congestion control
>>>>>>>>>>>>>>> with
>>>>>>>>>>>>>>> TCP_INFO. The cwnd value can be retrieved from both(SCTP and
>>>>>>>>>>>>>>> TCP),
>>>>>>>>>>>>>>> but the
>>>>>>>>>>>>>>> ssthresh value in SCTP is missing. I guess it would make
>>>>>>>>>>>>>>> sense to
>>>>>>>>>>>>>>> add
>>>>>>>>>>>>>>> these value and return it with the SCTP_GET_PEER_ADDR_INFO
>>>>>>>>>>>>>>> socket
>>>>>>>>>>>>>>> option.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Regards
>>>>>>>>>>>>>>> Florian Niederbacher
>>>>>>>>>>>>>>>
>=20
