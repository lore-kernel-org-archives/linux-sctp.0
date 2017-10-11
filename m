From: Joe Perches <joe@perches.com>
Date: Wed, 11 Oct 2017 10:44:50 +0000
Subject: Re: [PATCH][next] sctp: make array sctp_sched_ops static
Message-Id: <1507718690.3552.50.camel@perches.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171011101757.18825-1-colin.king@canonical.com>
In-Reply-To: <20171011101757.18825-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Colin King <colin.king@canonical.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2017-10-11 at 11:17 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> The array sctp_sched_ops  is local to the source and
> does not need to be in global scope, so make it static.
>=20
> Cleans up sparse warning:
> symbol 'sctp_sched_ops' was not declared. Should it be static?
>=20
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/sctp/stream_sched.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
> index 03513a9fa110..0b83ec51e43b 100644
> --- a/net/sctp/stream_sched.c
> +++ b/net/sctp/stream_sched.c
> @@ -124,7 +124,7 @@ static struct sctp_sched_ops sctp_sched_fcfs =3D {
>  extern struct sctp_sched_ops sctp_sched_prio;
>  extern struct sctp_sched_ops sctp_sched_rr;
> =20
> -struct sctp_sched_ops *sctp_sched_ops[] =3D {
> +static struct sctp_sched_ops *sctp_sched_ops[] =3D {
>  	&sctp_sched_fcfs,
>  	&sctp_sched_prio,
>  	&sctp_sched_rr,

Perhaps these should also be const to move more data to text
---
=A0include/net/sctp/stream_sched.h |=A0=A03 ++-
=A0include/net/sctp/structs.h=A0=A0=A0=A0=A0=A0|=A0=A02 +-
=A0net/sctp/stream.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=A06 +=
++---
=A0net/sctp/stream_sched.c=A0=A0=A0=A0=A0=A0=A0=A0=A0| 17 +++++++++--------
=A04 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sche=
d.h
index c676550a4c7d..431235c7587a 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -67,6 +67,7 @@ void sctp_sched_dequeue_done(struct sctp_outq *q, struct =
sctp_chunk *ch);
=A0
=A0void sctp_sched_dequeue_common(struct sctp_outq *q, struct sctp_chunk *c=
h);
=A0int sctp_sched_init_sid(struct sctp_stream *stream, __u16 sid, gfp_t gfp=
);
-struct sctp_sched_ops *sctp_sched_ops_from_stream(struct sctp_stream *stre=
am);
+const struct sctp_sched_ops *
+sctp_sched_ops_from_stream(struct sctp_stream *stream);
=A0
=A0#endif /* __sctp_stream_sched_h__ */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 6168e3449131..032ec5618e8a 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1028,7 +1028,7 @@ struct sctp_outq {
=A0	struct list_head out_chunk_list;
=A0
=A0	/* Stream scheduler being used */
-	struct sctp_sched_ops *sched;
+	const struct sctp_sched_ops *sched;
=A0
=A0	unsigned int out_qlen;	/* Total length of queued data chunks. */
=A0
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 5ea33a2c453b..62678c2229e4 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -140,7 +140,7 @@ static int sctp_stream_alloc_in(struct sctp_stream *str=
eam, __u16 incnt,
=A0int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 inc=
nt,
=A0		=A0=A0=A0=A0=A0gfp_t gfp)
=A0{
-	struct sctp_sched_ops *sched =3D sctp_sched_ops_from_stream(stream);
+	const struct sctp_sched_ops *sched =3D sctp_sched_ops_from_stream(stream);
=A0	int i, ret =3D 0;
=A0
=A0	gfp |=3D __GFP_NOWARN;
@@ -201,7 +201,7 @@ int sctp_stream_init_ext(struct sctp_stream *stream, __=
u16 sid)
=A0
=A0void sctp_stream_free(struct sctp_stream *stream)
=A0{
-	struct sctp_sched_ops *sched =3D sctp_sched_ops_from_stream(stream);
+	const struct sctp_sched_ops *sched =3D sctp_sched_ops_from_stream(stream);
=A0	int i;
=A0
=A0	sched->free(stream);
@@ -224,7 +224,7 @@ void sctp_stream_clear(struct sctp_stream *stream)
=A0
=A0void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *=
new)
=A0{
-	struct sctp_sched_ops *sched =3D sctp_sched_ops_from_stream(stream);
+	const struct sctp_sched_ops *sched =3D sctp_sched_ops_from_stream(stream);
=A0
=A0	sched->unsched_all(stream);
=A0	sctp_stream_outq_migrate(stream, new, new->outcnt);
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 03513a9fa110..642542be57ec 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -106,7 +106,7 @@ static void sctp_sched_fcfs_unsched_all(struct sctp_str=
eam *stream)
=A0{
=A0}
=A0
-static struct sctp_sched_ops sctp_sched_fcfs =3D {
+static const struct sctp_sched_ops sctp_sched_fcfs =3D {
=A0	.set =3D sctp_sched_fcfs_set,
=A0	.get =3D sctp_sched_fcfs_get,
=A0	.init =3D sctp_sched_fcfs_init,
@@ -121,10 +121,10 @@ static struct sctp_sched_ops sctp_sched_fcfs =3D {
=A0
=A0/* API to other parts of the stack */
=A0
-extern struct sctp_sched_ops sctp_sched_prio;
-extern struct sctp_sched_ops sctp_sched_rr;
+extern const struct sctp_sched_ops sctp_sched_prio;
+extern const struct sctp_sched_ops sctp_sched_rr;
=A0
-struct sctp_sched_ops *sctp_sched_ops[] =3D {
+static const struct sctp_sched_ops *sctp_sched_ops[] =3D {
=A0	&sctp_sched_fcfs,
=A0	&sctp_sched_prio,
=A0	&sctp_sched_rr,
@@ -133,8 +133,8 @@ struct sctp_sched_ops *sctp_sched_ops[] =3D {
=A0int sctp_sched_set_sched(struct sctp_association *asoc,
=A0			=A0enum sctp_sched_type sched)
=A0{
-	struct sctp_sched_ops *n =3D sctp_sched_ops[sched];
-	struct sctp_sched_ops *old =3D asoc->outqueue.sched;
+	const struct sctp_sched_ops *n =3D sctp_sched_ops[sched];
+	const struct sctp_sched_ops *old =3D asoc->outqueue.sched;
=A0	struct sctp_datamsg *msg =3D NULL;
=A0	struct sctp_chunk *ch;
=A0	int i, ret =3D 0;
@@ -259,13 +259,14 @@ void sctp_sched_dequeue_common(struct sctp_outq *q, s=
truct sctp_chunk *ch)
=A0
=A0int sctp_sched_init_sid(struct sctp_stream *stream, __u16 sid, gfp_t gfp)
=A0{
-	struct sctp_sched_ops *sched =3D sctp_sched_ops_from_stream(stream);
+	const struct sctp_sched_ops *sched =3D sctp_sched_ops_from_stream(stream);
=A0
=A0	INIT_LIST_HEAD(&stream->out[sid].ext->outq);
=A0	return sched->init_sid(stream, sid, gfp);
=A0}
=A0
-struct sctp_sched_ops *sctp_sched_ops_from_stream(struct sctp_stream *stre=
am)
+const struct sctp_sched_ops *
+sctp_sched_ops_from_stream(struct sctp_stream *stream)
=A0{
=A0	struct sctp_association *asoc;
=A0
