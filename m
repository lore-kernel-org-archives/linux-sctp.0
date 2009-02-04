From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 04 Feb 2009 16:24:03 +0000
Subject: Re: lksctp question: Association  redundancy
Message-Id: <4989C123.9070504@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi Son

Please address your questions to the sctp list.

Son Le wrote:
> Hi all,
>  We have a situation where we have two nodes that have the same ip addres=
s and want to control sctp association redundancy. If the process that owns=
 an association on one node crashes we want to do the following:
>=20
> - We do not want to send the ABORT to the far-end by setting the SO_LINGE=
R option. So the far-end at this point still think that this association is=
 still active.
> - The stand by node (it learned some info such verification tag of the as=
sociation of the other node) will send INIT message using the verification =
tag (and some other info from previous association) to the same far-end. Th=
e far-end can uses these info to reestablish the association on the new nod=
e. I assume that the far-end when receive the INIT message from the new nod=
e with, is not consider new association but will reestablish the current as=
sociation
>=20

It sounds like you want to trigger an association restart on the remote nod=
e.
All you have to do is attempt to initiate the association with the same sou=
rce,
destination, and address parameters.

You do not need to know remotes verification tag.

> Do you think this strategy would work ? Or do we need to enhance the lksc=
tp stack to support this functionality ?
>=20

This strategy might work as long as the remote keeps it's association activ=
e.
That depends on how fast the remote detects path and association failures.

-vlad

> Thanks for your help.
>=20
> Best regards,
> Son
>=20
> -----Original Message-----
> From: Michael T=FCxen [mailto:Michael.Tuexen@lurchi.franken.de]=20
> Sent: Tuesday, December 02, 2008 11:39 AM
> To: Vlad Yasevich
> Cc: Le, Son (CAR:SI52)
> Subject: Re: lksctp question
>=20
> On Dec 2, 2008, at 5:25 PM, Vlad Yasevich wrote:
>=20
>> Michael T=FCxen wrote:
>>> Hi Vlad,
>>>
>>> on question inside...
>>>
>>> Best regards
>>> Michael
>>>
>>> On Dec 2, 2008, at 3:11 PM, Vlad Yasevich wrote:
>>>
>>>> Son Le wrote:
>>>>> Hi all, Can you help to awnser the below question ?
>>>>>
>>>>>
>>>>> 1.    If an application process owns an SCTP association crashes
>>>>> (traps, or gets
>>>>> killed by other management processes), will the lksctp in the=20
>>>>> kernel Shutdown the sctp link gracefully? Or will it just send an=20
>>>>> abort to the remote side?
>>>> Depends on the setting of SO_LINGER.  By default, this will cause a=20
>>>> graceful shutdown since a "crashed" process is no different from a=20
>>>> gracefully exiting process in term of how file descriptors are=20
>>>> closed.  If you set SO_LINGER, then any close() on the descriptor=20
>>>> will trigger an ABORT.
>>> What if messages are still in the recv buffer? FreeBSD would then=20
>>> ABORT the association no matter what SO_LINGER is set to....
>> So, if the application calls close() on the socket even if there is=20
>> data there, you will ABORT?
> If there is still data in the recv buffer and the application calls
> close()
> the kernel knows that the application will not get everything. So it send=
s an ABORT...
>>
>> -vlad
>>
>=20

