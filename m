From: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Date: Tue, 04 Dec 2018 18:51:54 +0000
Subject: Re: [PATCH net] sctp: always set frag_point on pmtu change
Message-Id: <d8d357e5-45e7-87ae-ad87-53e9dc6ce5c2@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181118204736.7178-1-jakub.audykowicz@gmail.com>
 <CADvbK_fj6iauj2COg7gASLMMzD85c9e4pzVMt4Tz4kmHxHMUWA@mail.gmail.com>
 <b4bddea8-6fc4-b235-3cf6-8d1f3e72e97e@gmail.com>
 <20181128020838.GJ3601@localhost.localdomain>
 <20181128112600.GK3601@localhost.localdomain>
 <20cbe95f-8858-c571-ed23-e90a18ca9d19@gmail.com>
 <20181204174539.GA10987@localhost.localdomain>
In-Reply-To: <20181204174539.GA10987@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>, network dev <netdev@vger.kernel.org>

On 2018-12-04 18:45, Marcelo Ricardo Leitner wrote:

> On Tue, Dec 04, 2018 at 06:00:51PM +0100, Jakub Audykowicz wrote:
> ...
>> OK, let's forget about that "if" :)
>> Coming back to the sanity check, I came up with something like below,
>> based on the code from sctp_setsockopt_maxseg, like you mentioned.
>> I may have overcomplicated things since I didn't know how to accomplish
>> the same thing without passing sctp_sock* to sctp_datamsg_from_user.
> Yep. More below.
>
>> I wanted to avoid calling sctp_min_frag_point unless absolutely
>> necessary, so I just check the frag_point against the zero that is
>> causing the eventual kernel panic.
> Makes sense.
>
>> =20
>> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
>> index ab9242e51d9e..7e67c0257b3f 100644
>> --- a/include/net/sctp/sctp.h
>> +++ b/include/net/sctp/sctp.h
>> @@ -620,4 +620,15 @@ static inline bool sctp_transport_pmtu_check(struct=
 sctp_transport *t)
>>  	return false;
>>  }
>> =20
>> +static inline __u16 sctp_data_chunk_size(struct sctp_association *asoc)
>> +{
>> +    return asoc ? sctp_datachk_len(&asoc->stream) :
>> +                  sizeof(struct sctp_data_chunk);
> I don't think we need another layer on top of data chunk sizes here.
> We don't need this asoc check by the sendmsg callpath because it
> cannot be NULL by then. That said, I think we have avoid this helper,
> for now at least.
>
> One other way would be to include the check into sctp_datachk_len(),
> but we currently have 9 calls to that but only 1 requires the check.
>
> As asoc is initialized and considering the fix we just had in this
> area, stream->si will also be initialized so you should be good to
> just call sctp_datachk_len() directly.
>
>> +}
>> +
>> +static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 dat=
asize)
>> +{
>> +    return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
>> +}
> This is a good helper to have. Makes it clearer.
>
>> +
>>  #endif /* __net_sctp_h__ */
>> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
>> index a11f93790476..d09b5de73c92 100644
>> --- a/include/net/sctp/structs.h
>> +++ b/include/net/sctp/structs.h
>> @@ -543,7 +543,8 @@ struct sctp_datamsg {
>> =20
>>  struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *,
>>  					    struct sctp_sndrcvinfo *,
>> -					    struct iov_iter *);
>> +					    struct iov_iter *,
>> +					    struct sctp_sock *);
>>  void sctp_datamsg_free(struct sctp_datamsg *);
>>  void sctp_datamsg_put(struct sctp_datamsg *);
>>  void sctp_chunk_fail(struct sctp_chunk *, int error);
>> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
>> index ce8087846f05..753c2c123767 100644
>> --- a/net/sctp/chunk.c
>> +++ b/net/sctp/chunk.c
>> @@ -164,7 +164,8 @@ static void sctp_datamsg_assign(struct sctp_datamsg =
*msg, struct sctp_chunk *chu
>>   */
>>  struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *as=
oc,
>>  					    struct sctp_sndrcvinfo *sinfo,
>> -					    struct iov_iter *from)
>> +					    struct iov_iter *from,
>> +					    struct sctp_sock *sp)
>>  {
>>  	size_t len, first_len, max_data, remaining;
>>  	size_t msg_len =3D iov_iter_count(from);
>> @@ -173,6 +174,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct s=
ctp_association *asoc,
>>  	struct sctp_chunk *chunk;
>>  	struct sctp_datamsg *msg;
>>  	int err;
>> +	__u32 min_frag_point;
> Reverse christmass tree.. swap the last two lines:
> +	__u32 min_frag_point;
>  	int err;
> But I guess we don't need this var anymore:
>
>> =20
>>  	msg =3D sctp_datamsg_new(GFP_KERNEL);
>>  	if (!msg)
>> @@ -190,6 +192,12 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct =
sctp_association *asoc,
>>  	/* This is the biggest possible DATA chunk that can fit into
>>  	 * the packet
>>  	 */
>> +	if (unlikely(asoc->frag_point =3D 0)) {
>                      !asoc->frag_point   instead
>
> You can get to sctp_sock here with: sctp_sk(asoc->base.sk)
> 		struct sctp_sock *sp =3D sctp_sk(asoc->base.sk);
>
>> +		min_frag_point =3D sctp_min_frag_point(sp, sctp_data_chunk_size(asoc)=
);
>> +		pr_warn_ratelimited("%s: asoc:%p frag_point is too low (%d < %d), usi=
ng default minimum",
>> +			__func__, asoc, asoc->frag_point, min_frag_point);
>> +		asoc->frag_point =3D min_frag_point;
> No no. Lets not fix up things here. If we do this assignment, we may
> make the disparity even worse.
> With that, we can work only on max_data and avoid the need of min_frag_po=
int.
>   	max_data =3D asoc->frag_point;
> 	if (unlikely(!max_data)) {
> 		...
> 		max_data =3D ...
> 	}
>
>> +	}
>>  	max_data =3D asoc->frag_point;
>> =20
>>  	/* If the the peer requested that we authenticate DATA chunks
>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>> index bf618d1b41fd..28d711609ef1 100644
>> --- a/net/sctp/socket.c
>> +++ b/net/sctp/socket.c
>> @@ -1938,7 +1938,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_associ=
ation *asoc,
>>  		pr_debug("%s: we associated primitively\n", __func__);
>>  	}
>> =20
>> -	datamsg =3D sctp_datamsg_from_user(asoc, sinfo, &msg->msg_iter);
>> +	datamsg =3D sctp_datamsg_from_user(asoc, sinfo, &msg->msg_iter, sp);
>>  	if (IS_ERR(datamsg)) {
>>  		err =3D PTR_ERR(datamsg);
>>  		goto err;
>> @@ -3321,11 +3321,9 @@ static int sctp_setsockopt_maxseg(struct sock *sk=
, char __user *optval, unsigned
>> =20
>>  	if (val) {
>>  		int min_len, max_len;
>> -		__u16 datasize =3D asoc ? sctp_datachk_len(&asoc->stream) :
>> -				 sizeof(struct sctp_data_chunk);
>> +		__u16 datasize =3D sctp_data_chunk_size(asoc);
>> =20
>> -		min_len =3D sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT,
>> -					   datasize);
>> +		min_len =3D sctp_min_frag_point(sp, datasize);
>>  		max_len =3D SCTP_MAX_CHUNK_LEN - datasize;
>> =20
>>  		if (val < min_len || val > max_len)
>>
Thanks, I've taken your remarks into account and ended up with this=20
simple solution:

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index ab9242e51d9e..3487686f2cf5 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -620,4 +620,9 @@ static inline bool sctp_transport_pmtu_check(struct sct=
p_transport *t)
 	return false;
 }
=20
+static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasi=
ze)
+{
+    return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
+}
+
 #endif /* __net_sctp_h__ */
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index ce8087846f05..dc12c2ba487f 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -191,6 +191,12 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sct=
p_association *asoc,
 	 * the packet
 	 */
 	max_data =3D asoc->frag_point;
+	if (unlikely(!max_data)) {
+		pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to=
 default minimum",
+			__func__, asoc);
+		max_data =3D sctp_min_frag_point(
+			sctp_sk(asoc->base.sk), sctp_datachk_len(&asoc->stream));
+	}
=20
 	/* If the the peer requested that we authenticate DATA chunks
 	 * we need to account for bundling of the AUTH chunks along with
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bf618d1b41fd..b8cebd5a87e5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3324,8 +3324,7 @@ static int sctp_setsockopt_maxseg(struct sock *sk, ch=
ar __user *optval, unsigned
 		__u16 datasize =3D asoc ? sctp_datachk_len(&asoc->stream) :
 				 sizeof(struct sctp_data_chunk);
=20
-		min_len =3D sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT,
-					   datasize);
+		min_len =3D sctp_min_frag_point(sp, datasize);
 		max_len =3D SCTP_MAX_CHUNK_LEN - datasize;
=20
 		if (val < min_len || val > max_len)

=C2=A0
