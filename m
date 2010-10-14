From: Yaogong Wang <ywang15@ncsu.edu>
Date: Thu, 14 Oct 2010 17:41:25 +0000
Subject: Re: [PATCHv2 3/5] sctp: extend socket API for sched configuration
Message-Id: <AANLkTim2XA1i+AbqV95u_4FWLViVuNXqJxEnaMqm-3yF@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTimEQkDpWorCF4HUq6N-xAnFz4xE89osAtcJY_Mn@mail.gmail.com>
	<4CB56E7F.3030908@cn.fujitsu.com>
In-Reply-To: <4CB56E7F.3030908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>, linux-kernel@vger.kernel.org

The reason is that SCTP supports one-to-many style socket where one
socket handles multiple associations (and hence multiple outqueues).
In that case, if we only store scheduling configurations in the
socket, it may cause several problems:
1. All associations handled by this socket must share the same
scheduling policy.
2. If you change the scheduling algorithm of the socket when some
associations are already established, we have to change the scheduling
of on-going associations, which may be complicated and error-prone.

If we only store scheduling configurations in the association, the
difficulty is: when should the application set these configurations?
In one-to-many style socket, associations are implicitly established.
There isn't a point where association is established but data transfer
hasn't started yet so that the user can configure the scheduling
algorithm. We again has to deal with the problem of changing
scheduling when data transfer is under way.

The current design is a compromise of the two approaches. Scheduling
configurations are set at the socket level and stored in sctp_sock.
When a new association is established, it inherits the scheduling
configurations from the socket. If the application changes the
scheduling configurations of the socket on the fly, only associations
established after the change are affected. That way, we are able to
have different scheduling algorithms for associations handled by one
socket and we eliminate the trouble to change scheduling policy on the
fly.

Thanks,
Yaogong

On Wed, Oct 13, 2010 at 4:31 AM, Shan Wei <shanwei@cn.fujitsu.com> wrote:
> Yaogong Wang wrote, at 09/12/2010 09:13 AM:
>> Augment SCTP socket API with a new socket option SCTP_SCHED
>> to choose and configure multistream scheduling algorithm.
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>> =A0include/net/sctp/structs.h | =A0 =A04 ++
>> =A0include/net/sctp/user.h =A0 =A0| =A0 19 ++++++++++
>> =A0net/sctp/outqueue.c =A0 =A0 =A0 =A0| =A0 =A04 ++
>> =A0net/sctp/sm_sideeffect.c =A0 | =A0 45 +++++++++++++++++++++++--
>> =A0net/sctp/socket.c =A0 =A0 =A0 =A0 =A0| =A0 80 +++++++++++++++++++++++=
+++++++++++++++++++++
>> =A05 files changed, 149 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
>> index 52af764..1a76417 100644
>> --- a/include/net/sctp/structs.h
>> +++ b/include/net/sctp/structs.h
>> @@ -333,6 +333,8 @@ struct sctp_sock {
>>
>> =A0 =A0 =A0 /* Multistream scheduling */
>> =A0 =A0 =A0 const struct sctp_sched_ops *sched_ops;
>> + =A0 =A0 __u16 sched_config_len;
>> + =A0 =A0 void *sched_config;
>>
>> =A0 =A0 =A0 struct sctp_initmsg initmsg;
>> =A0 =A0 =A0 struct sctp_rtoinfo rtoinfo;
>> @@ -1173,6 +1175,8 @@ struct sctp_outq {
>>
>> =A0 =A0 =A0 /* Multistream scheduling */
>> =A0 =A0 =A0 const struct sctp_sched_ops *sched_ops;
>> + =A0 =A0 __u16 sched_config_len;
>> + =A0 =A0 void *sched_config;
>
> Why did you take these two fields into sctp_sock and sctp_outq?
> These two fields between sctp_sock and sctp_outq has same role,
> we can only defined in one place.
> How about using sctp_sk(sctp_outq->asoc->base.sk) to access these two
> fields?
>
>
> --
> Best Regards
> -----
> Shan Wei
>



--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
