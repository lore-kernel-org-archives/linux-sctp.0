From: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Date: Tue, 04 Dec 2018 19:30:22 +0000
Subject: Re: [PATCH net] sctp: always set frag_point on pmtu change
Message-Id: <84d5c4e6-0e3b-a323-48c1-0bde73a89453@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181118204736.7178-1-jakub.audykowicz@gmail.com>
 <CADvbK_fj6iauj2COg7gASLMMzD85c9e4pzVMt4Tz4kmHxHMUWA@mail.gmail.com>
 <b4bddea8-6fc4-b235-3cf6-8d1f3e72e97e@gmail.com>
 <20181128020838.GJ3601@localhost.localdomain>
 <20181128112600.GK3601@localhost.localdomain>
 <20cbe95f-8858-c571-ed23-e90a18ca9d19@gmail.com>
 <20181204174539.GA10987@localhost.localdomain>
 <d8d357e5-45e7-87ae-ad87-53e9dc6ce5c2@gmail.com>
 <20181204185832.GB10987@localhost.localdomain>
In-Reply-To: <20181204185832.GB10987@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>, network dev <netdev@vger.kernel.org>

On 2018-12-04 19:58, Marcelo Ricardo Leitner wrote:

> On Tue, Dec 04, 2018 at 07:51:54PM +0100, Jakub Audykowicz wrote:
> ...
>> Thanks, I've taken your remarks into account and ended up with this=20
>> simple solution:
> LGTM! Thanks
>
>> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
>> index ab9242e51d9e..3487686f2cf5 100644
>> --- a/include/net/sctp/sctp.h
>> +++ b/include/net/sctp/sctp.h
>> @@ -620,4 +620,9 @@ static inline bool sctp_transport_pmtu_check(struct =
sctp_transport *t)
>>  	return false;
>>  }
>> =20
>> +static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 dat=
asize)
>> +{
>> +    return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
> Not sure how final the patch is but be sure to run checkpatch.pl on
> it before submitting it officially. It flagged some issues like the
> above indentation using spaces, for example.

Should be fine now. I have checkpatch as a post-commit hook but I was
not committing when creating these quick diffs :).

>
>> +}
>> +
>>  #endif /* __net_sctp_h__ */
>> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
>> index ce8087846f05..dc12c2ba487f 100644
>> --- a/net/sctp/chunk.c
>> +++ b/net/sctp/chunk.c
>> @@ -191,6 +191,12 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct =
sctp_association *asoc,
>>  	 * the packet
>>  	 */
>>  	max_data =3D asoc->frag_point;
>> +	if (unlikely(!max_data)) {
>> +		pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data=
 to default minimum",
>> +			__func__, asoc);
>> +		max_data =3D sctp_min_frag_point(
>> +			sctp_sk(asoc->base.sk), sctp_datachk_len(&asoc->stream));
>> +	}
>> =20
>>  	/* If the the peer requested that we authenticate DATA chunks
>>  	 * we need to account for bundling of the AUTH chunks along with
>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>> index bf618d1b41fd..b8cebd5a87e5 100644
>> --- a/net/sctp/socket.c
>> +++ b/net/sctp/socket.c
>> @@ -3324,8 +3324,7 @@ static int sctp_setsockopt_maxseg(struct sock *sk,=
 char __user *optval, unsigned
>>  		__u16 datasize =3D asoc ? sctp_datachk_len(&asoc->stream) :
>>  				 sizeof(struct sctp_data_chunk);
>> =20
>> -		min_len =3D sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT,
>> -					   datasize);
>> +		min_len =3D sctp_min_frag_point(sp, datasize);
>>  		max_len =3D SCTP_MAX_CHUNK_LEN - datasize;
>> =20
>>  		if (val < min_len || val > max_len)
>>
>> =C2=A0
>>
>>
