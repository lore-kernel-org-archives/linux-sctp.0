From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Wed, 18 Jan 2017 14:53:05 +0000
Subject: Re: Issue with Forward-TSN-Chunks containing high cum_tsn
Message-Id: <A27990AD-84BE-4BA7-83C4-3F5A88BD72F9@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117130752.GB6494@aomx-netbook>
In-Reply-To: <20170117130752.GB6494@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

> On 18 Jan 2017, at 07:01, Xin Long <lucien.xin@gmail.com> wrote:
>=20
> On Wed, Jan 18, 2017 at 12:38 AM, Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
>> On Tue, Jan 17, 2017 at 02:07:52PM +0100, Julian Cordes wrote:
>>> When a FORWARD-TSN-Chunk with a relative high cum-tsn-value is injected
>>> then the linux kernel ignores this valid FORWARD-TSN-Chunk.
>>> It should instead send an SACK-Chunk where the cum_tsn is equal to the
>>> cum_tsn specified in the FORWARD-TSN.
>>=20
>> You mean, with the cum_tsn specified on the *injected* FORWARD-TSN.
>> Is that so?
> from the test  script
> +0.0 < sctp: FORWARD_TSN[cum_tsn=99999, ids=3D[{1, 1}]]
> I think so.
>=20
> But 99999 is so high relative to the base_tsn of tsnmap,
> it overflowed tsnmap, such a big gap is disallowed in linux
> sctp. it has to drop this packet.
>=20
>        /* Verify that we can hold this TSN and that it will not
>         * overlfow our map
>         */
>        if (!TSN_lt(tsn, map->base_tsn + SCTP_TSN_MAP_SIZE))
>                return -1;
>=20
> Hi, Julian, maybe you can improve your script by using a lower
> value for linux.
but this would mean that Linux only supports the peer skipping some small n=
umber of TSN's.
Isn't this a limitation of the implementation?

Best regards
Michael
>=20
>>=20
>>>=20
>>> Testscript available at:
>>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/rece=
iver-side-implementation/receiver-side-implementation-11.pkt
>>=20
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

