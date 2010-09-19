From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sun, 19 Sep 2010 18:56:22 +0000
Subject: Re: [PATCHv2 2/5] sctp: implement pluggable multistream scheduling
Message-Id: <AANLkTi=Aj1hNxjCiWaU8=FNWSdu2+0pf3FngjT8aP9p5@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTinaO5Fqn+QJxxkXSCsW0XWvhBc16jK6HGB_0YG0@mail.gmail.com>
	<4C8E2AE2.9050309@hp.com>
In-Reply-To: <4C8E2AE2.9050309@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
---
 net/sctp/protocol.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index d40c5cc..0121def 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1310,11 +1310,13 @@ SCTP_STATIC __init int sctp_init(void)
 	/* Add FCFS to sctp_sched_list */
 	status =3D sctp_register_sched(&sctp_fcfs);
 	if (status)
-		goto err_v6_add_protocol;
+		goto err_register_sched;

 	status =3D 0;
 out:
 	return status;
+err_register_sched:
+	sctp_v6_del_protocol();
 err_v6_add_protocol:
 	sctp_v4_del_protocol();
 err_add_protocol:
--=20
1.7.0.4



On Mon, Sep 13, 2010 at 9:45 AM, Vlad Yasevich
<vladislav.yasevich@hp.com> wrote:
> One small nit.
>
> On 09/11/2010 09:12 PM, Yaogong Wang wrote:
>> Implement the pluggable multistream scheduling framework.
>> Provide the default first-come-first-serve (FCFS) algorithm.
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
>> index 5027b83..d40c5cc 100644
>> --- a/net/sctp/protocol.c
>> +++ b/net/sctp/protocol.c
>> @@ -1157,6 +1157,9 @@ SCTP_STATIC __init int sctp_init(void)
>> =A0 =A0 =A0 sctp_max_instreams =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D SCTP_DEFAU=
LT_INSTREAMS;
>> =A0 =A0 =A0 sctp_max_outstreams =A0 =A0 =A0 =A0 =A0 =A0 =3D SCTP_DEFAULT=
_OUTSTREAMS;
>>
>> + =A0 =A0 /* Initialize default multistream scheduling algorithm to FCFS=
 */
>> + =A0 =A0 sctp_default_sched_ops =A0 =A0 =A0 =A0 =A0=3D &sctp_fcfs;
>> +
>> =A0 =A0 =A0 /* Initialize handle used for association ids. */
>> =A0 =A0 =A0 idr_init(&sctp_assocs_id);
>>
>> @@ -1304,6 +1307,11 @@ SCTP_STATIC __init int sctp_init(void)
>> =A0 =A0 =A0 if (status)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_v6_add_protocol;
>>
>> + =A0 =A0 /* Add FCFS to sctp_sched_list */
>> + =A0 =A0 status =3D sctp_register_sched(&sctp_fcfs);
>> + =A0 =A0 if (status)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto err_v6_add_protocol;
>> +
>
> This needs its own tag that will call sctp_v6_del_protocol().
>
> -vlad
>
>> =A0 =A0 =A0 status =3D 0;
>> =A0out:
>> =A0 =A0 =A0 return status;
