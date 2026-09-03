Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B741B4257;
	Thu,  3 Sep 2026 03:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405804; cv=none; b=rW3/I+Xuh5NRgWWzxOHSpkslaektsuANgmMnqzF2h/qPLTRZF4XG77tETrtzUI3GIXRVJp3e7CxEJ+GYYFawhLzkLIqXjy7VHd+p17Axin4eqlwABE+4b8rqlNTJm7jbKg2u6etR+TpB3/PoFuCLAFkEueLuZNSjLdeumo9T+sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405804; c=relaxed/simple;
	bh=NHFZ3UogosT1kUjOIAKuVqV3vo/9SD98uWkvA9/C7QQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=H37aBHe+1eK3yWmxVOhUkg6c7UCnjpoIhBMudstCnhrhde1O/MeGHkzOJnY1dchoZHdApxmS5/OW3vbyPuYKPvgIOUER0uRNZeeuEI+9UhxgnttaE9VVcSCebVOXPOQp869WnM8Y0jXS68XV63nKytzd+AjznHQ5KSHtoXmZVG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=qyeLOEMe; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="qyeLOEMe"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nAje4cnQe9N2vYMlKrTtzARCzVhEKJr7qJWMTqpKYUI=;
	b=qyeLOEMeT9pf3hawSG4WE9QQTrtDmXjTcLTSlEKT4KG+JaW+oTIwUyT6PRYsLdc0LBKDurEVw
	8rXCq43Anp1m66GoK/hDuU7mWa8v6/izgsuuCwX9kgsZOErFHUlWBKt7PnIbqR9WVLvr4YS5Plp
	geNtsoBEUsqU7FqTNVmTb9Y=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hb4Q66XTBz1prl2;
	Thu,  3 Sep 2026 11:11:58 +0800 (CST)
Received: from kwepemr100001.china.huawei.com (unknown [7.202.195.168])
	by mail.maildlp.com (Postfix) with ESMTPS id DDB12203B8;
	Thu,  3 Sep 2026 11:22:50 +0800 (CST)
Received: from [10.136.112.147] (10.136.112.147) by
 kwepemr100001.china.huawei.com (7.202.195.168) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 3 Sep 2026 11:22:49 +0800
Message-ID: <057c057f-be11-4bf7-9403-f454bb2864c9@h-partners.com>
Date: Thu, 3 Sep 2026 11:22:48 +0800
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [sctp?] WARNING: refcount bug in sctp_transport_put (6)
To: David Laight <david.laight.linux@gmail.com>, Xin Long
	<lucien.xin@gmail.com>
CC: <syzbot+80dfcb1a2235b3efc877@syzkaller.appspotmail.com>, "David S .
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Simon
 Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	<marcelo.leitner@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	<linux-kernel@vger.kernel.org>, <linux-sctp@vger.kernel.org>,
	<netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>, gaoxingwang
	<gaoxingwang1@huawei.com>, <huyizhen2@huawei.com>
References: <6a7d8773.c5ad36c8.12f49d.002e.GAE@google.com>
 <68cb4941-3668-44f1-a889-6b2f023b2a08@h-partners.com>
 <CADvbK_eY4S1HbdNHuNq9b=Va-TA_6rNFvnCvtOUZ0sF-AWN67A@mail.gmail.com>
 <20260901153524.3e92df3a@pumpkin>
 <CADvbK_esKpvPWK0xipKeiDr6KDiAL2_uPOhrREOMMVjJ_ndK7A@mail.gmail.com>
 <20260901224645.7c5bd2e6@pumpkin>
Content-Language: en-US
From: xietangxin <xietangxin@h-partners.com>
In-Reply-To: <20260901224645.7c5bd2e6@pumpkin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100001.china.huawei.com (7.202.195.168)



On 9/2/2026 5:46 AM, David Laight wrote:
> On Tue, 1 Sep 2026 11:06:31 -0400
> Xin Long <lucien.xin@gmail.com> wrote:
>=20
>> On Tue, Sep 1, 2026 at 10:35=E2=80=AFAM David Laight
>> <david.laight.linux@gmail.com> wrote:
>>>
>>> On Tue, 1 Sep 2026 09:45:42 -0400
>>> Xin Long <lucien.xin@gmail.com> wrote:
>>> =20
>>>> On Mon, Aug 31, 2026 at 11:47=E2=80=AFPM xietangxin <xietangxin@h-pa=
rtners.com> wrote: =20
>>>>>
>>>>> Hi,
>>>>>
>>>>> I have analyzed this issue and successfully reproduced locally.
>>>>> The race occurs between the timer callback (`sctp_generate_heartbea=
t_event`) and
>>>>> the transport cleanup path (`sctp_transport_free`):
>>>>>
>>>>> Task 1(Timer Softirq)               Task 2(sctp_transport_free)
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D              =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>> sctp_generate_heartbeat_event()
>>>>>   refcnt =3D 2
>>>>>
>>>>>   bh_lock_sock(sk)
>>>>>   sock_owned_by_user(sk)
>>>>>   mod_timer(&hb_timer) -> returns 0
>>>>>                                           sctp_transport_free()
>>>>>                                             transport->dead =3D 1
>>>>>                                             del_timer(&hb_timer) ->=
 returns 1!
>>>>>                                               sctp_transport_put() =
(2 -> 1)
>>>>>                                             sctp_transport_put() (1=
 -> 0)
>>>>>                                               sctp_transport_destro=
y()
>>>>>
>>>>>   sctp_transport_hold() =20
>>>>>     -> refcnt is 0, increment fails =20
>>>>
>>>> This should not be 0, as the transport must hold a refcnt to start t=
he
>>>> hb_timer. =20
>>>
>>> Isn't there one hold sctp_generate_heartbeat_event() and a second for=

>>> whatever 'task 2' is doing. =20
>> Right,
>>
>>> When hb_timer is started it is given another hold (does it actually n=
eed one??). =20
>> You mean mod_timer() in sctp_generate_heartbeat_event()?  Yes, as it w=
ill
>> release the last one in out_unlock, it must hold a new one.
>=20
> But can that ever be the last 'hold' that actually calls sctp_transport=
_destroy().
> It the timer is always deleted (as task 2 above) it doesn't need one it=
self.
> Might need to be del_timer_sync() so that it waits for the completion f=
unction
> to terminate.
>=20
>>
>>> So when hb_timer is deleted it's hold is removed.
>>> But the del_timer() is happening before the the extra hold is obtaine=
d.
>>> =20
>> Ahh, I can see the race now.
>>
>> I remember you mentioned holding it before mod_reduce() in a previous
>> patch, maybe it will work here, like:
>>
>>                 sctp_transport_hold(transport);
>>                 if (mod_timer(&transport->hb_timer, jiffies + (HZ/20))=
)
>>                         sctp_transport_put(transport);
>>
>> Does it make sense?
>=20
> That should close the timing window, but is probably inefficient.
> Rather depends on how often the 'put' ends up being done.
>=20
> David
>=20
>>
>> Thanks.
>>
>>> The RHS (task 2) would need to hold bh_lock_sock().
>>>
>>> Try giving sctp_generate_heartbeat_event() two holds.
>>>
>>> David
>>>
>>> =20
>>>>
>>>> Also, the delay below is under bh_lock_sock(), so it should not be t=
he
>>>> real cause of the issue.
>>>>
>>>> Could you share the PoC for this issue?
>>>>
>>>> Thanks.
>>>> =20
>>>>>   out_unlock:
>>>>>     sctp_transport_put() (0 -> -1) =20
>>>>>     -> refcount underflow warning! =20
>>>>>
>>>>>
>>>>>
>>>>> Adding a small delay  after `mod_timer()` increases the reproductio=
n rate:
>>>>>
>>>>> --- a/net/sctp/sm_sideeffect.c
>>>>> +++ b/net/sctp/sm_sideeffect.c
>>>>> @@ -373,8 +373,10 @@ void sctp_generate_heartbeat_event(struct time=
r_list *t)
>>>>>                 pr_debug("%s: sock is busy\n", __func__);
>>>>>
>>>>>                 /* Try again later.  */
>>>>> -               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/=
20)))
>>>>> +               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/=
20))) {
>>>>> +                       mdelay(1);
>>>>>                         sctp_transport_hold(transport);
>>>>> +               }
>>>>>                 goto out_unlock;
>>>>>         }
>>>>>
>>>>> Any feedback or guidance would be greatly appreciated.
>>>>>
>>>>> --
>>>>> Best regards,
>>>>> Tangxin Xie
>>>>> =20
>>>> =20
>>> =20
>>
>=20

Hi Xin, David,

I have a syzkaller execution log that can trigger this issue.
Please let me know if there is anything else I can do.

Syzkaller log :
last executing test programs:

28m43.2520997s ago: executing program 32 (id=3D50):
openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)=

perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x0, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0xa, 0x4=
, @perf_bp=3D{0x0}, 0x1, 0x8, 0x2, 0x1, 0xffffffff, 0xd1, 0xac6f, 0x0, 0x=
0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x5)
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f00000005c0)=3D{0xffffffffffffffff, 0x0, =
0x8b, 0xe, &(0x7f0000000140)=3D"4eab4278b7aaff458c136e03686185a80598ba85e=
4bb1049c9d5196fe9c1429a481badec3c60d7e1466fc02e709e4dc427fb91eff6bbb09c87=
0d03a4b546cf41183a4f98e58be1606a509c32faca2b2d3b8a6eeccf13f99fa3709786711=
6e85586732102ab457ae7a3e23bc105e8ab93310ffae64e206885a5abc5f2fbd03feb5c42=
859b32af1ded0c0de2", &(0x7f0000000200)=3D""/14, 0x0, 0x0, 0x0, 0x4e, &(0x=
7f0000000240), &(0x7f0000000540)=3D"88e1258e40111e8bf3875845b9afdff04872c=
ce0fe8bbca88fca3dddfec41d959c78fda43e6169c7d51c08923eb8e481dbd226035e126b=
1efb0ae6eeb603957abc809f2a7b278758dc45016a0644", 0x2, 0x0, 0x5d5}, 0x50)
close_range(0xffffffffffffffff, 0xffffffffffffffff, 0x2)
r0 =3D bpf$PROG_LOAD(0x5, &(0x7f00000003c0)=3D{0x3, 0x3, &(0x7f0000000480=
)=3D@framed, &(0x7f0000000500)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x0=
0', 0x0, @sched_cls, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x=
0, 0x0, 0x0}, 0x94)
r1 =3D syz_open_procfs(0xffffffffffffffff, &(0x7f0000000040)=3D'net/xfrm_=
stat\x00')
read$FUSE(r1, &(0x7f00000005c0)=3D{0x2020}, 0x2020)
open_by_handle_at(r0, &(0x7f0000000100)=3DANY=3D[@ANYBLOB=3D"1000000002c2=
781ad936381e9667d953fd82492098000000f9ffffff060000000400000002000000"], 0=
x268200)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0x9, 0x8, 0xe, 0x0, =
0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0, 0x2}, 0x2, 0x7, 0x2, 0x5, 0xffffffff, 0x9, 0x3, 0x0, 0=
x0, 0x0, 0x61}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
prctl$PR_SET_TAGGED_ADDR_CTRL(0x37, 0x1)
r2 =3D openat$zero(0xffffffffffffff9c, &(0x7f0000000040), 0x0, 0x0)
preadv2(r2, &(0x7f0000000880)=3D[{&(0x7f00000002c0)=3D""/254, 0xfe}], 0x1=
, 0x9, 0xef31, 0x12)
madvise(&(0x7f0000ffc000/0x2000)=3Dnil, 0x2000, 0x1)
r3 =3D socket$alg(0x26, 0x5, 0x0)
bind$alg(r3, &(0x7f0000000180)=3D{0x26, 'skcipher\x00', 0x0, 0x0, 'cbc-ae=
s-neonbs\x00'}, 0x58)
setsockopt$ALG_SET_KEY(r3, 0x117, 0x1, &(0x7f0000001700)=3D"998115bda7931=
e59edfe5ccb0b4856d1", 0x10)
r4 =3D accept4(r3, 0x0, 0x0, 0x80800)
sendmmsg$alg(r4, &(0x7f0000000040)=3D[{0x0, 0x0, &(0x7f00000002c0)=3D[{&(=
0x7f0000000000)=3D'-', 0x1}, {&(0x7f0000005300)=3D"abe9d89c7de5d36e1311b5=
f7e6a06be74a6780c98f88a1c556087e84c800575c2cfa6a0e03c23ba6fc47d8d6eb3d608=
991dd064f9d483a9775db5becda5547a0ad95af1341d9852484c6e858d8b16228462e005c=
f798302f105385d4cf67d3d16c55be9d195ed923e7beed54044b475d73b64f7f31b168b75=
1375f45059ea56a58ffe2750ad1939830e203b04e54afa96f9b3976807a980c29957ec836=
0ba5470bc82aa5032850e4ff9551bf17ed6fa9064fe9ffb59a72bc97b2671e59437e98a72=
dccc6f7865f43834a676a0383b42d2e815b5457fde98d4aaba9493d87a8887235c4cc655f=
8e5bf3ab63d38455bfb2a2487c482f990afb6697471bb670e54da63b7c822962d214e5dc7=
45b38032d7ec230ce1a3fbfefa48397276286a42b4b3d87d33ea55590ce38ebea840e6974=
41037b88c1a888267c74779830c3f1058a389fd382a7bc7e960dba702ba1808f6a3704af5=
9da81e22e59a1a6b8877df5a1331cbed83233210cda6b1ad681fd9b1147653865ebe8570d=
f30f45f5a8834115f094922298ef9bb9d532897831877184066c0c29549b55c9c18a2fe6e=
a720aee4b201233eacda524281e9c582d54146459888b2c0978c9cbbc1801e8ee1b97dc00=
d4a6daa55bed37246df3ed193d2bd449b6a5d0e60f46d012d141390ff475910ef4fd2c839=
7b2c6b4f5200c0b81b44088f7a93b43fcc145faa823b2d3a66d13f57f1ba40b7b2007cf94=
60d8481f9b7208cb2ebf0fd8d864ba833ddf360186fc1bce0bbce40a58fe1fef25f15a5c9=
4c43e160d034c549632ed70a3f854bb062c294b695ebd4ccc04fb21de433c833ac654570d=
d4ddb4e23cf005177c1e2e9f3b530fa02d3eadeff53f0e988c58f3654009b3e54d60d4f87=
81558f0e3d7d95ac80cb1733b28268e5455cbe53032080cd3f3f6e32f6bd3871094311f63=
ce78271f1ab67f4d02dac0da8faae308984c9a501c4b7d0acc1afdb677aef36cc0012680b=
91825a58ae29bb08aa96c063435780a924f53d78b0d123e6e84b3f98cbfa783d32b2bb0a1=
79a876b21582908ebe9ee52d476a7ea71ba4db5b33bd5717b0c9bf09b39dac6394e1c1db4=
c673a9f43507463df7ed13f7e38b7ba37b2ba1cc7b843a0d49126466f1b5baf21ed4163eb=
2eb47d772263b9cd97a2aac939637802e506fa03e27263dbaf8add5044274d146ea875a69=
399f8c848329b423d94b422d0e001d0d93737afc8c81965614f7f4cac626b2229e0ec2e52=
738c66711f30833ea2c7dcf28aa3f1a33164ffddfe4d4c1a5d4395721cc44fa303cbedfca=
92237924473c7798bece96994ca055dc0e45ee25e23c90f5acfe508197b35626b868deecd=
6cda23af3ded27d722928575695c126de6f17d108de2f08fc0cf9f1489764b699f2572ebc=
727c7e871f7fce480fd43aeefe055804bf7426901e2fb6c0299ade9053f7b554b4d3fccfa=
f78cebac2b15234894dfa6252d5f9dd9dd345655371f514909b9242c2cb55c25ae25ccf84=
79b01f945a578358c402d2df15bfc36d97d3da87ba4a6fa6b934c98cbd545e52d436efea3=
3e266e2420a933010318cebb276327914a9f1418cf18c7fc1b85b34f94d9ac308fe90f0f1=
4824b564498500548c83077de0dea442d7163b258cb7bc4487cb8d4df3fde392390a207f7=
31ba537943a8adf3306890539e25a931382c5dfee69b819c563fcf255a9ae2817bee84993=
66ec4f74e08bfda482713c2ba5eebcef7815228848436663c2f12755c4ec4241f1e592da5=
361c37455ba600d11d95493f608354ddbf4e375b1a905bcb5ca81c5d646f2d585a0cd1d21=
4e4ea93b89de9c934824a47704903b77bed644cecd2acce3b6d3a6a89c1dee94746e3698b=
ce41b2a19ce145323e6a23e0d8a7b18b9fcb6e2d25f547f1de03f242af81eabbd4beaa841=
3f94cc19e47ee7f5522ecf5aeed4d219c50a2ba4fe5fbf59a3ba25b1e308a42a662891d4c=
cf8a4f79b6374c6c9235ae3e56d6592b6bc4a43998a8837fbac54053da98db81e7d73a9d1=
5d1ce61cb427f9b47421a8dc401e1e62e454528fceee93c46ecf8b1c3efe0623ee55bfd3d=
ffb775b9d30608973fbffb3100c79be6055897a4e37d5a3267af9833f23e9c8d95d374dcc=
b762768ca3b0d11c2a9692267b59175f1f4d91f023357502209afdabc06d90e41c728e302=
60785040293f06402774c9fd3d63254d08774f7021a66b56a458328835972025490063cea=
8ff4092c0b87dc84d7a509eb8e65b6ddfd738e1d71388a86cf927dc1bddbc28aecf4eba4e=
82a5413f344704d43e1b848368bdc3ea00684499016b41e60b41ce180bd135e2004276cf1=
9edbfd82af191da7a707994fcca8eb6d2a9f5387446af7fe86e8c7a54b68c62995998b5ff=
36ce8101bc6240e4f9d5046fcd7fa210e2fbff11cfcae6bdc1b6673a37f702e4fefd006d8=
c237f34db5b04c8c98aebfce8f234f0d7ea30475fc9e21b8ae296049482061063177c37a5=
8e28aacc96190764aeb787184669b3b3bb0599b80ad1333fcb1622acca15a9c2de8148784=
4ac64907d7f0896763da2304d10ed837ee4e1f33fc5c37674041ec3d1bc17ab4d61ca31ad=
5bef9eeda8ccddb7bf9bd45037bf5cb192cd1f5feced5eb4e484bfab44b8b879032816986=
42cf147f7a354416c77a819d0cb2db32a7cdaff4d11065ce9bfd2d3216d32f2463447d98e=
9cb8e62f4b582ea1c5da0ca21c6bcc37ad033406bc937c601b2c11167542fccd20f689cee=
026d14f4a579bb1709ba86a658c9c4736eaf1a33fab41763931bb744b5e4dd5c5fcd8a9ec=
5ef066375f7b064c362d913d87591b30f8cfcae2bef9a8d4531804a233355ec7258528871=
db8f44ee02f1b2eac1701c1d5a46a57cf8010108206332fd9321083ca97e1b1f5cd48c99b=
9af1007885f4121196075c95bb8f443758a7ea49eb7abd084eecf7753755a72c427a15e2b=
bdaacc9cf0ca802402cee7e5ae694bc704ae9857161859853de2766105d4982061bb435d4=
f162df538e0486f30295dbc129dde51d71726db970daa6b5b9bdb8d259d60b5427f479176=
3735e0fd3382ff37a8dc3d64b79bd7d71aec202e69219012de2589bc520e4b846884cbb1a=
6229725498fd03259f1eaef6f4fd12668a08d5a09d05a61e57b2dbdcb26961da62ba6d5a6=
1039641de7ecabce08d4459179415e37b2241f1a9ad2f95f30c0f5782cf61d48caa8ccc95=
7074cc51c98c8d4a51b31dcc54a0dadf1380524de6952e51fd2d19bd231689632dd4efdd8=
f2417152ad943df4eb055a2675c0880c09d7eeffd78f2813691cae3b7998358cf23558fdc=
7edb52a738964bc05853e08ac2460e98e9cb3ec34506b1372aebf88498624a4374f7622fe=
e2415409ded973237439d159828c77f4a7db340619b0748335793125ac9c05423bfa1c07e=
a6f3588a97adfc7d96cf4b1073eac6362f0ec0bfd905e68be3187b6ca328307c1945fffac=
14344abce4d41448923d5c93c06339174d2db2c9b6a30612f17e715524a3669890fa4d8a0=
ce502f23f956ffece30f5320ac36dcda8c534acb89b70c6775c6bd90b14535dabe87c55d5=
c76e5dd982712ccebff2f7d009dc0010e923e95c2db976cb31ca0fd7468051075877ee5df=
e92ecb1943a06dc4ff9950ba1ea1204d2b65ea13edd4c5a2d0b4e8b51e6da93fad52db054=
919a9ea50007388dc606dd671d3c689c43b4500d8d0bfb304b4a6330fa6f0f32699aaa1e2=
2d9dd632473a6dffb8c83b7c53f7c1fa11a01ae3896788312337bc2209aa3a5e86a6126ed=
0a5d25ff01ea07e8d18d20e401a35d91525d235d2a07a69d7295f9e57b9752bf224ae68a7=
5396763075688addf13c7c0fa37f565c43434a5f60032132a6687664cdc3f936265094040=
a8088a1d49dd057eff900f02741e1fdafac2278239c11ba724bf2e28b50a0b16a9e639ec3=
880729bb2978ad50a9b2721833594ce54215bc6d29544274f55e54c77a04c36020bd88339=
2d541227588bd3e021b875cc25163314f40c49186869d01715b4078cf84db81ad92847c7e=
29d14fe7e4c25e96e4b360b54e04d5ab661da554771c95e4fda8b13762fe1d183ce20899a=
1b2afd33356028dc83ef8ee213f57ceb76b91caaa2225ca9216cdf215c03345724fb40777=
eb092726b0133435148be0cb29695eacf22975f6b57ffb1e5adfc00aa48cda8d2cf6b0957=
ce038633515eca5a409f09f17eba947cbf1970a6d93a457aff231da69a6d6b79af958dc73=
27df4d9fe6e7c9116b15f750c938ab5ec45ea44743941b764a4883979e24bf78ccfbbd956=
3ead241c8330bcce772dc84cae50b06c7f404206eba2339f1955580c05977e270bb0b51c3=
a0bac9154f22f9bff7dc33da47350fd36afc5e51c64e298b8e323e80b3c23d4740a26071c=
862612a55bb26c930dceb51486b2236c1b4048fd7ac411fd47bc24b88c81af0d4dae41e43=
15792b2722926b8dcfcfb23ab93957719fb12836521936ecbb94573c8f8e0356680826b06=
bca6f502f7c2abbc6da6303fa5b04d274212bb67902b55d4ddfffdbe13eb246be1ac89a48=
bd3e4436645bb790ca58908f345f0557866f06d20ed6f81a427a3b37da85ea610f076eea0=
22f8db5f7cad5bb41f1d8f9ee561b6286ad8566f3b154b76fe4cb0515f147c5c330d39fbe=
7c1daa4149801b241107fbe8d76b53760b8edcf7ef31da5f625da351ec54c2fc434303a8a=
0c417677d3bf4b583e18c1e4ae61fd815bcd7e119a9542c7a4799b0d0aa9e2409d35a23a0=
32c4fdd6ad0756db926e358939222eb11179cc008df47fafd1599715c9f6bbcce834cc37e=
82492833491e9eba0ca3c104e29a15e22067599e8af562440cef2443af7f73c72f8fc7479=
9a836976b04c1adeda91005f97e1d7aa8ced7702d5acfb538c16c247c559f1e986d5d779b=
b4ead1c7af23376f87722afee70512b9966d57a263ffefc6a3f9d8ce791c128444f749046=
29dd8e64ab0c255d5ca417012f021c2f1d48a2dd6afe41c1c46818880c228b30ed6778afd=
0525d46e0e4da80851010a2a5833b782c990a49a0f1defdfc5c753c10d57c0f5c66aaa6c8=
a136fcccf66ccb37f64404b52e1daca97e575f11c059af1c95d180720514f78bee0c0da01=
9c408188b1e8edd44eb21e96d8c6bf84760ab90f993436a40aed3366894050aa18d9543b2=
0b94bc73b4f1c8523803e8502169f425aeca944e8f86548aa669df8c3247e8993a56e0bcc=
ef883c0209f20b9926482866fb079b037b7e1c30bd721147d4004e6bb856112b396dd36e3=
250b6eaf571bed6f89e42d6dacd25e9f94ab238700993548ef239e45415afd21fb4ba08eb=
47db09eae9276f0a61d7d7cbc9b8b031f4a8046968a5c78efcdadd4942beac9f6932043fe=
e23c7362ec7be21a3e69706b2fc949b6611610770f7b2d97bec94774fd5d1405d0bc283ea=
9a549646d032f841309f0bf8a989e842bb20346033be06ffbc4ac3bce8be95e9e827846b5=
2d22e05ca2fcc532c6bd84db56f422fee8df8838ec2bdd0bfaee2c6a6a88b17d00424882f=
b4c094ef81da5c36843f3686844df82987407d7ff765c928d6aa0812445d6edd6b1cd157a=
6d679b1061888289e15ec22f33ea268b5bf301561a4340527d903a308dc5", 0xf8f}], 0=
x2, 0x0, 0x0, 0x50}], 0x1, 0x0)
r5 =3D socket$nl_crypto(0x10, 0x3, 0x15)
recvfrom(r5, &(0x7f0000000240)=3D""/24, 0x18, 0x121, &(0x7f0000000640)=3D=
@un=3D@file=3D{0x0, './file0\x00'}, 0x80)
recvmmsg(r4, &(0x7f0000000480)=3D[{{0x0, 0x0, &(0x7f0000000200)=3D[{&(0x7=
f0000000080)=3D""/207, 0x38010}], 0x1}, 0x6}], 0x1, 0x40000100, 0x0)
r6 =3D openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x=
2, 0x0)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r6, 0xeb08=
0000)
read$FUSE(0xffffffffffffffff, 0x0, 0x0)
socket$inet_icmp_raw(0x2, 0x3, 0x1)
r7 =3D syz_open_dev$sg(&(0x7f0000000040), 0x885, 0x82000)
ioctl$SG_SET_FORCE_PACK_ID(r7, 0x227b, &(0x7f0000000000)=3D0x1)

28m42.51815453s ago: executing program 33 (id=3D52):
ioctl$AUTOFS_DEV_IOCTL_FAIL(0xffffffffffffffff, 0xc0189377, &(0x7f0000000=
000)=3D{{0x1, 0x1, 0x18, <r0=3D>0xffffffffffffffff, {0x7f, 0xa0b}}, './fi=
le0\x00'})
mremap(&(0x7f0000fff000/0x1000)=3Dnil, 0x1000, 0x1000, 0x4, &(0x7f0000fff=
000/0x1000)=3Dnil)
ioctl$TIOCGSERIAL(r0, 0x541e, &(0x7f0000000080)=3D{0x0, 0x0, 0x0, 0x0, 0x=
0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, &(0x7f0000000040)=3D""/47=
})
r1 =3D socket$igmp(0x2, 0x3, 0x2)
ioctl$SIOCGETVIFCNT(r1, 0x89e0, &(0x7f0000000040)=3D{0xffffffffffffffff})=

r2 =3D socket$key(0xf, 0x3, 0x2)
eventfd2(0x2, 0x80000)
sendmsg$inet(r2, &(0x7f0000001480)=3D{0x0, 0x0, &(0x7f0000001380)=3D[{&(0=
x7f0000000040)=3D"cca93a309fb00d900b8fc7bad5958516", 0x10}], 0x1}, 0x840)=

r3 =3D socket$nl_generic(0x10, 0x3, 0x10)
ioctl$FS_IOC_FIEMAP(r3, 0xc020660b, 0x0)
r4 =3D socket$nl_route(0x10, 0x3, 0x0)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x7, 0x2, 0x0, 0x0, 0x0, =
0x6, 0x140c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0,=
 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, 0x=
1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x1, =
@perf_config_ext=3D{0x6, 0xffffffffffff64fb}, 0x100001, 0x0, 0xc000000, 0=
x1, 0xffffffff, 0xd1, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xffffffffffffffff=
, 0xffffffffffffffff, 0xb)
r5 =3D openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x=
2, 0x0)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r5, 0x3321=
000)
ioctl$ifreq_SIOCGIFINDEX_batadv_hard(r0, 0x8933, &(0x7f0000000100)=3D{'ba=
tadv_slave_0\x00', <r6=3D>0x0})
bind$xdp(r0, &(0x7f0000000140)=3D{0x2c, 0x18, r6, 0x1, r0}, 0x10)
mkdirat(0xffffffffffffff9c, &(0x7f0000000080)=3D'./file1\x00', 0x1c6)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
mount$overlay(0x0, &(0x7f0000000000)=3D'./file1\x00', &(0x7f0000000300), =
0x8040, &(0x7f00000000c0)=3D{[{@upperdir=3D{'upperdir', 0x3d, './file0'}}=
, {@lowerdir=3D{'lowerdir', 0x3d, './cgroup'}}, {@workdir=3D{'workdir', 0=
x3d, './file1'}}]})
bpf$PROG_LOAD(0x5, &(0x7f0000000440)=3D{0x15, 0x2, &(0x7f00000003c0)=3DAN=
Y=3D[@ANYBLOB=3D"7119530000000000950101ea29a187c6e799a1707e85164b1f15212d=
a0fefc612e847f92ca14de86d526c3dc80d55218ff912109c7a24224624f7f1ec71a63b50=
5702fd01ba0613072723ea4dd33ac2989fe0076a5dc00cd932c"], &(0x7f0000000300)=3D=
'syzkaller\x00', 0x2, 0x0, 0x0, 0x0, 0x3, '\x00', r6, @sk_reuseport=3D0x2=
8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7},=
 0x94)
chdir(&(0x7f0000000180)=3D'./file1\x00')
io_setup(0x5052, &(0x7f00000001c0)=3D<r7=3D>0x0)
mkdirat(0xffffffffffffff9c, &(0x7f0000002000)=3D'./file0\x00', 0x0)
r8 =3D syz_create_resource$binfmt(&(0x7f0000000380)=3D'./file0/file0\x00'=
)
r9 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r9, &(0x7f00000001c0)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000200)=3DANY=3D[@ANYBLOB=3D"50000000100011072cbd7000fcdbdf2500=
000000", @ANYRES32=3D0x0, @ANYBLOB=3D"a5d00600000807001c00128009000100626=
f6e6400008f18e4cee070004c190007000000140003"], 0x50}, 0x1, 0x0, 0x0, 0xfe=
05cad2d9aaa8cb}, 0x2004e840)
ioctl$EXT4_IOC_SWAP_BOOT(r5, 0x6611)
r10 =3D openat$binfmt(0xffffffffffffff9c, r8, 0x42, 0x1ff)
io_submit(r7, 0x1, &(0x7f0000000340)=3D[&(0x7f0000000240)=3D{0x0, 0x0, 0x=
0, 0x1, 0x8, r10, 0x0, 0x4e, 0x8, 0x0, 0x2}])
sendmsg$nl_route(r4, &(0x7f00000015c0)=3D{0x0, 0x0, &(0x7f0000000280)=3D{=
&(0x7f00000002c0)=3D@ipv6_getanyicast=3D{0x14, 0x3e, 0x10, 0x70bd2a, 0x25=
dfdbfd}, 0x14}, 0x1, 0x0, 0x0, 0x40055}, 0x0)

28m1.21028944s ago: executing program 34 (id=3D373):
mkdirat(0xffffffffffffff9c, &(0x7f0000000080)=3D'./file1\x00', 0x1c0)
chdir(&(0x7f0000000180)=3D'./file1\x00')
r0 =3D openat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file1\x00', 0x42=
, 0x1ff)
r1 =3D openat$vcsu(0xffffffffffffff9c, &(0x7f0000000440), 0x0, 0x0)
read$FUSE(r1, &(0x7f0000004780)=3D{0x2020, 0x0, 0x0, 0x0, 0x0, <r2=3D>0x0=
}, 0x2020)
getpeername$unix(r1, &(0x7f0000000200)=3D@abs, &(0x7f0000000280)=3D0x6e)
mmap$perf(&(0x7f0000b9e000/0x2000)=3Dnil, 0x2000, 0x2000000, 0x12, r0, 0x=
0)
r3 =3D syz_open_procfs(0x0, &(0x7f0000000100)=3D'net/udplite6\x00')
r4 =3D syz_open_procfs(r2, &(0x7f0000000300)=3D'net/udp6\x00')
r5 =3D openat$cgroup_root(0xffffffffffffff9c, &(0x7f0000000340)=3D'./cgro=
up.net/syz0\x00', 0x200002, 0x0)
ioctl$AUTOFS_DEV_IOCTL_PROTOVER(r3, 0xc0189372, &(0x7f0000000380)=3D{{0x1=
, 0x1, 0x18, r5, {0x4b61}}, './file1\x00'})
io_uring_register$IORING_REGISTER_CLONE_BUFFERS(r3, 0x1e, &(0x7f000000048=
0)=3D{r4}, 0x1)
read$FUSE(r3, &(0x7f0000008400)=3D{0x2020}, 0x2020)
r6 =3D syz_open_dev$tty1(0xc, 0x4, 0x1)
write(r6, &(0x7f00000018c0)=3D"d611da7a4c9d898eafddbd91c990e933d4f29cb9a4=
50fdf8caf4d8be4bf7e6fc254dcdfb9826cc05ce1951e92e09fab2f7e51da16c1dd657a96=
69f0e486720b1bebb575393218eda4ab1865fdc22633154bd176f6a4869f167d3eefb7e36=
9687c931cc08aeed5d5191462dd7e738eb33a164dbad0e9b9ecb1de5ba3098eccb3d17431=
4ca64e6fb862ef3d767ac64c91c18b57c6b742b723f0000a27236d5bfb18312fd49c581c8=
df26a1e1d46dad3d31c3fab9baf696a2c78619523f1892fd76f35f63c187ee61b6cb96046=
6fb97b72d583096a60cf22198f773d46e8305d211051fc919b7e571d826049493efe1d68b=
6eaa6f5f3af61133710d1bdc7856d155049342f1bd5339729946de2fffb7da8cf888f1c8f=
fea93b63c23d801d32f109518bbc9a6143751497de06244ce9e8024ae370ba380e8733704=
ebc6a032e9503bcc8bcb47f13c3109e7c1b5d6ee026ba2e9156416e90d55e94db84ae702a=
5ccc882bb1d30dbb3fb6d01a46d45ce4d84ce042e97cffb19f3f7f70ab9f7ac599f8ae794=
1750147b0aba6cd02329fdae8004d72a46350fa31766b2232c7c358c2d710e00000000000=
0521dfe095e9df648d86afb17e164f6ab6c4d7d2e3e831a803970e694bd6b2bad274e1362=
e63cd5316ad2b72aceaf1fb7a2c59434b21d3d31e5c5c6bdb9499b84465602ba43968527f=
40fd68bdadf098e69d2aecbe9e26e5ec3b4deb57b34e49cdeddcd6ffa5abd15185b2720fd=
d28014c2e1cbedd2eb0774a0e5bc5b022014ca41f3f43f20f5a5982420c24be43814d4f59=
62b19970cac77a333c1558ee52bf2d8793135e3fdbbb3192cb44db1127e7b7f1e6a242c53=
0b9542b3c390b1b3729b05c60b491378ecd8a0bb1e75c181d8acc561d963b93db54aa91cd=
12a2ff5c81fc21148f3e800a70b966f0535836dead2b3200bdf6b911d603ebf2e7ed9569e=
7d61173983099e99be81fc35db73a6f5b10e260cf98795337e11093704c6cfc2483cb27a5=
416766e4e229e4c93a3580af7cb0c0944fad3071249ade6828fb4aba6e6969dfce017e759=
499a413231e5bbda8446f974f0195636ab070c1f505ba8e9b40ab48239971f9f22be6e99a=
c11d7ab22f72f0c878c58340977bee9a8ec3437df58e531e96aa234ccd07c6368f542adc2=
b5c762c226c7b79d43eadb02c9a9ecfaf92bbe0978e337e54da3208f84f65f64e5950ead3=
acf11b7ac6ea60b044bf014c5fc9923e32e978ecba48b8f9b4728d8299e0d1c438981f05c=
84c489f8d3222aa6c31d3158bdd9f8e12775ab18680023add7e926d251e2d8223a4d27c09=
ef4b975d6e2cd6dfcc04954244467e7ac87cb1a622085ae6b61403c1966b627a162b2b393=
52c8d419028240a00600dfc3b93f466c72016f16f836b7b59ca81e62c4639b303241f3d92=
751bdd9eac07311279d737120c889dcee5b3360ff134212fcc6b33d22d50015288ed2b264=
331b4d", 0x416)
getsockopt$inet_sctp6_SCTP_INITMSG(r3, 0x84, 0x2, &(0x7f0000000000), &(0x=
7f00000000c0)=3D0x8)
rt_sigprocmask(0x0, &(0x7f0000000100)=3D{[0x100000000]}, &(0x7f0000000140=
), 0x8)
ioctl$FS_IOC_FSSETXATTR(r4, 0x401c5820, &(0x7f00000002c0)=3D{0x8000, 0x16=
c058a9, 0x1})
socket$nl_xfrm(0x10, 0x3, 0x6)
write$char_usb(r0, &(0x7f00000001c0)=3D"d0", 0x1)
perf_event_open(&(0x7f00000003c0)=3D{0x9, 0x80, 0xff, 0xf, 0x3, 0xfe, 0x0=
, 0x10000000000e0b5, 0x304, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, =
0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0=
, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0=
x0, 0x6, 0x0, @perf_bp=3D{&(0x7f0000000080)}, 0x400, 0x4, 0x100003, 0x5, =
0xfffffffffffffffa, 0x5, 0x8, 0x0, 0x80, 0x0, 0x46f}, 0x0, 0x0, 0xfffffff=
fffffffff, 0x3)
syz_clone(0x11, 0x0, 0x0, 0x0, 0x0, 0x0)
perf_event_open(&(0x7f00000003c0)=3D{0x9, 0x8c, 0xff, 0xf, 0x3, 0xfe, 0x0=
, 0x10000000000e0b5, 0x304, 0x3, 0x0, 0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, =
0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0=
, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0=
x0, 0x6, 0x0, @perf_bp=3D{&(0x7f0000000080)}, 0x1700, 0x4, 0x100003, 0x6,=
 0xfffffffffffffffa, 0xffffffff, 0x8, 0x0, 0x80, 0x0, 0x46f}, 0xfffffffff=
fffffff, 0x0, 0xffffffffffffffff, 0x3)

28m1.16690254s ago: executing program 35 (id=3D370):
connect$inet6(0xffffffffffffffff, 0x0, 0x0)
bpf$PROG_LOAD(0x5, 0x0, 0x0)
r0 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
close(0x3)
r1 =3D socket$inet6_tcp(0xa, 0x1, 0x0)
shutdown(r0, 0x1)
setsockopt$inet6_tcp_int(r1, 0x6, 0x22, &(0x7f0000000040)=3D0x1, 0x4)
bind$inet6(r0, &(0x7f0000000000)=3D{0xa, 0x4e23, 0x41, @loopback, 0x401},=
 0x1c)
r2 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
ioctl$sock_SIOCGIFCONF(r2, 0x8912, &(0x7f00000009c0)=3D@buf)
openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)=

r3 =3D openat$ptmx(0xffffffffffffff9c, &(0x7f0000000000), 0x1, 0x0)
ioctl$TIOCGPTPEER(r3, 0x5441, 0x8001)
socket$inet6(0xa, 0x4, 0x8)
close(0x3)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x0, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0xa, 0x4=
, @perf_bp=3D{0x0}, 0x1, 0x8, 0x2, 0x1, 0xffffffff, 0xd1, 0xac6f, 0x0, 0x=
0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x5)
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0x9, 0x8, 0xe, 0x0, =
0x7fe, 0x40000, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0, 0x2}, 0x2, 0x7, 0x2, 0x5, 0xffffffff, 0x9, 0x3, 0x0, 0=
x0, 0x0, 0x61}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
r4 =3D openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x=
2, 0x0)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r4, 0xeb08=
0000)
io_submit(0x0, 0x0, 0x0)
mount$cgroup(0x0, &(0x7f0000000180)=3D'./file0\x00', &(0x7f0000000140), 0=
x840, 0x0)
r5 =3D syz_open_dev$ttys(0xc, 0x2, 0x0)
ioctl$PIO_FONTRESET(r5, 0x4b6d, 0x0)
r6 =3D socket$key(0xf, 0x3, 0x2)
sendmsg$key(r6, &(0x7f0000002bc0)=3D{0x0, 0x0, &(0x7f0000002b80)=3D{&(0x7=
f00000006c0)=3DANY=3D[@ANYBLOB=3D"020409060400000027bd7000ffdbdf2502000b0=
00c0000000900000000000000050006002b2000000a004e220000004cfe80000000000000=
00000000000000aa0400010000000000050006003c4000000a004e1d00000002ff0200000=
000000000000000000000010200000000000000"], 0x70}}, 0x40004)
sendmmsg$inet6(r0, &(0x7f00000036c0)=3D[{{&(0x7f0000000580)=3D{0xa, 0x4e2=
3, 0xa, @loopback, 0x2}, 0x1c, &(0x7f00000000c0)=3D[{&(0x7f00000002c0)=3D=
"02", 0x1}], 0x1}}], 0x1, 0x20004810)

26m10.55122487s ago: executing program 36 (id=3D1552):
openat$ptmx(0xffffffffffffff9c, 0x0, 0x8281, 0x0)
r0 =3D socket$inet6_udplite(0xa, 0x2, 0x88)
mkdirat(0xffffffffffffff9c, &(0x7f0000002040)=3D'./file0\x00', 0x0)
r1 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0)
mount$fuse(0x0, &(0x7f00000020c0)=3D'./file0\x00', &(0x7f0000002100), 0x0=
, &(0x7f0000002140)=3D{{'fd', 0x3d, r1}, 0x2c, {'rootmode', 0x3d, 0x4000}=
})
r2 =3D mq_open(&(0x7f00000001c0)=3D'macsec0\x00', 0x40, 0x90, 0x0)
mq_notify(r2, &(0x7f00000002c0)=3D{0x0, 0x24})
r3 =3D mq_open(&(0x7f0000000180)=3D'macsec0\x00', 0x40, 0x10, 0x0)
mq_notify(r3, &(0x7f0000000240)=3D{0x0, 0x23, 0x1})
acct(&(0x7f0000000200)=3D'./file0/file0\x00')
read$FUSE(r1, &(0x7f00000043c0)=3D{0x2020, 0x0, <r4=3D>0x0, <r5=3D>0x0, <=
r6=3D>0x0}, 0x2020)
write$FUSE_INIT(r1, &(0x7f0000004300)=3D{0x50, 0x0, r4, {0x7, 0x2b, 0x0, =
0xffffffff95800414, 0x0, 0x0, 0x0, 0x8}}, 0x50)
syz_fuse_handle_req(r1,
&(0x7f00000021c0)=3D"80cc949a20a10570b22f57c72b14b6d5b9656d619411d3e0feb9=
96f638296baec90caf0305c18523d32f8aaf50d3b62deaa3a75c2e016f25efcddb2e4e5cf=
e7a2e24d813ff5e08182e8fbc9353537f68ae28a6548a83e5662b382002990c8b32a687cf=
b9922aa8e8cef4d8f1c1e9ea22d432b3ccdc80e9b39e792b7545ae90a0880cb7f49edb763=
13335f65ed0888cdf8a79f3a22028f6035b8a77343e12b2b48d61cd8dadd99ffe4ccaf144=
36357b8f5c4633a94b27d21367946bea971d2f2cc9c588402be7d1f4cc9c78732b4650438=
da4a781b23ea5cc672d28ce0d78fb13a532779cfe3689e62f673ff4d4edd72d396bc29607=
5a710424cfe4fd1d38ce799c319e58f5b5d76c995ca60bb98f1a027c5122554fb397420fd=
5095c0326ccf221f017dbfdde47ba8180ebb28573193aa67076f503ce05d7950d220bc8dd=
ab527f0117a30a9c9fa977e6eb12024bf97ac55e5044b688f8ece30cfd06acf52743837cc=
9b1ae37af0113cda07abf471828dad657fd8a2cccf307f16e21f938b3c3c03a29bccb9f1f=
4854067c7eb7664f505a7fa433eac2c3e3ba6fc5393e376aa0662d502e91931c8363fa08b=
006e35feee61403c93a78cd0722bce85f680ee04efba31f47f92f1e391e3d63507aa49d8f=
063707900f63faeeba28c3d53cd4dc95af6e916bca9896926775f990b7e528b15014be706=
414ca96c59bea21a312484d3d6434c8150752bccee265c64742549b9bf94d64a100ea1f61=
2de41a7a4f34afc0f47a23a08630e3f90da155f6b5c90dd9a6496e23e80cbe5dfd3527288=
3076961caf332f97dc3871384379b2d6ecafa30ceea5fba0d68ba64fe7d235046347a4759=
f870e5bbf9ab1c3ad3281b63cbe1a9f0de5dc38118aebaaac3d8a42bf5e13489da5dbf0f5=
0a02291a1bff4af669d66679658bd3ac40f153034cadab5e07d743392a491f3daf2737703=
198cbd9f18c90d82dbb276f948bb84fca2bd92160675b5ce96f4e3609bfbfaadaa495231b=
581af70fbc8e2e2bcb249b3a8ff0b45269cbe2ba66b86942d24b086945dc9b4660ea211b1=
93c19bf11cdea937a3699ab6131ea26c4903121760b6df20561fa2a593700d7ff0e71aba5=
139ccfde4776e1e60233a784c72f4b7bcdaa00f60cb93c25367752c624652981121dbafce=
f1c96f3f514347a5adcf3c269df2091400b041d52460fa8c6b81e857f88154d4fce7662bc=
f27df14917a01170b0a36b36b49b0cb69af47247cfe08812597d74fe755ecd1c1ccdb3b0a=
3c9a2ea65c494bbd669b51ab7fdd2bc5e7e5ad459d6a9c9f02e59f7e0aa1f45de43cf5014=
23616d430a6dbc577492c8adfbdfe707daf0fb401239592bf301361770d155cfebbe9d5ba=
f0dccdb358c2c0d7678d6a1ba6e2fc16f1f0aa6b3b9be72b37c22fc76b0e4e5b9fa540f11=
6682f694e9ceaeac5cbc8691a935fd1a244b044ffeb258fb01a035880cb17e7dde5170a35=
d44816482f376d9d48b3b807af0f2138f8b48a47a18207745568b349db4661aee07fafdde=
33d604230e4d340c4f9d9ba0d0ab29294f7a31983fec1a75c6f4394d710bf961b5d4deda5=
09ed7602df284fcabcbfc996299783607934c8e0feb1dc2efb258586e71a0aa5458d50ce5=
560f716227a8d8c19f42f931b2ff0c448c8999863cd85cc5327c76644de795bee4cfa6ae5=
e1cbd8679a32b489ddc4af5c18483b7325937d4a4e77ffd4365d042636fbf8d2999812da9=
6aa1373f082b22c0f32b7d934a3e7dfb7ef7ab62a72671361faf92f291056499a7d588602=
29765ff64168f7faa220eecbd0d238e483094322ddc59f0477836be13328153b83183ef80=
083e8c74d423009ce3699addbc045b3062f81f2609a60ecee4db9ae80e992ccd481ac5c89=
53e6a8a333810e1fcf7073865f67140da698a46fe5419667025febf699b74156fc2fadb73=
7266b0baa6f87a34bb73115b5be02e15eb389de5d1c9a798997baa4410547f8a69af2803b=
d4b66db6cf0a865119a96e721b71ef9621ed7219f1d2497e55883480d663d59d9385ef368=
a6de2867c94fcecc73f6be4ddd6a3f3eb39b5c7c0cdc501dc69f156295e2f5345a9d8fec7=
fb1ae0ae1c5bda022eb7218faae98068c7686ce04f2c8ceec63ed8142380614d7b099bfa9=
455374ef90e3f9799c6b0592f39fc6228f7865a9bec42ab2d10775094a7964a81110de801=
204d434f132c848e76c6e7464fe4904b0e5c82a4b122fd21e69beaf1709c97ad40714b28d=
55db151dc99b8f5496814ca8f0349176ad7ae864ee42497764f39bf10714a2cdfd50fb337=
cfb6e4db18475ed71b28675c5954b078ce1f035022b5a45bec61ff614d235b4b9416ba38e=
d7f55922d14df5b26487a9d605ae4cec69c8396ec66aceec3b15bda52455c36e970dbfb7c=
cc846740226f0c33427dbf45e0275dfff5218940d36a3a06d93d414b0d2ca160b2b5d0de5=
f432d3f36a449f007068d2b79cb2fc019d1a15f6efeeab03afa45da9c1c360275985a839c=
d0137455885ea2a69aefd48915e14e7973ef44844963f42062712d4a8be4c3da27d8549fa=
3d65f673faa5bc6c8947bcda7863743e4f9f2e7dc62eec22fa2e9b669f87bf4c303e89125=
8b91daec9c9cc65c5983fd91a7709b5c7f1ff72faa639ce26ba95f553286fdec3759a37f5=
986c9a7a0ba711685af75c1b04bb743db4d0a39fd191147e2bfe375aa8d6223e7127bfbc4=
95d5bcd4dddfc29ac13a12a8044297a4caba53d63e899e3242ceebad1e6e7ab43f3a23e2f=
d007352866721411ce9ac5e95d46674b2be228196eed9a7329e4d282ecc837215310bd647=
42b5c9ed8fb89b5ee586b6391b57f6d52658eac832b6e01ea774bc5c35ff1c496a8743bdd=
15e950b9eac1437ace59b8c8aa91831e6716ea6fa44bee90f89206c688501a88de558cc1b=
283d4e2dd62a32fb108dc02ccc7d01b2cef61c09403d7256e0a8439828818966fb06899cd=
05dcbb52a9b8238e2f6e742329b170b1286d80ce38796311c94a77c0cd13e09610cd84e31=
2c0d8c9369c6454b98ddb40d6388ee4a16a408dbb589bc9164c9ff89ed34d92d09c2935a1=
e8d651fa364639598a7af49bed103eb975c43162e1f06b51f4c1316ab61f98c00b9944956=
2055f476e1c91dcfd2b6e5c9edfe4a942d2ae04962399ff0f700c4c5a5f4ab819d1a1b7bd=
64767a7c635ee70ded32870d4149359faa38e49e0a8c7a61ab377b3cb19767d3e50c4b844=
ac007d7ca13e61230924c3cea444da8919074705e79a29e0bb1326bdfc97dc5bafa5b74ec=
e5744b40a99c9f4d7a38bdbe5cf3065f9bd89ef04fdb58975284fc36575bd840840f96fe8=
39005743f840174182d9bc84abd5a2a5d3d3d26310ae37534c574c6fa0d442b1fae60fede=
d31010a206019f1df00f2a07b8e576432f4063464e808691cab001c5f68295182c5e34b8e=
12f96eb5844ca66177af647c16bf2c8cd6125068083489ee2672944ce6852e5c6f95edeb8=
6c97c86d4177bbe7a484464355f0ec7d0530c8d4d196122a3997a57a03a0484fa09eeda2c=
00a515edfb31feded6edd66b6513c5a9def92e7923c1f984469ba7054f96af55930c4c928=
c774c92606d8ab63d694cb94c2afde226be603fb7a0843c61965cab2af0e661c336789d1b=
6b5b4de8033da91497a3c97ba9d8d483d2406c76c0e1e00ba9a0901a93812d15ebb0f6a44=
7fbd3dbe15ff1827a459365f8c49c2f6f05826ade87b51175d78e786998e2818840605e7b=
7c4194a9c2f251912d8ae4cbd2674f95ef96bfe662ed7c412e2e2ec8caad8967f1f320d3b=
2669ad65f39b5405ad1bf0af9c65e0ccd1779f4743e211c032c2dda00ff4fa223731845ec=
80134710c732561ce317a2c204eba2bf298f2a885e2348a7cb07dcad2a7baba7a58461701=
63c6378c7ab742fe05ccc684df993db0f062eafd881554f8b44f6913acefaab6c5927b8ff=
7c0f5955c85cc9c70c04b6fb68aab8ae8b19780527aac4aa0c31df2d8369fad0990c884d3=
e0234b16642e0bee5cae0de6288fb1e92c7edf967037e13f07b3f69ff6a19b6a7ac431581=
0919db8499f38039e2399be08d9f7b101bc43a24a09aa49d82f7c235a359e7a65432d427a=
fb910ce19bcdd751292799e94aefe5df558d7f03a6010c1a9d5e2957d94c63ef221ca7c8f=
16c8e639ca1e332c7d5422b2b7b5589690366edbd0cf21ee41b215b84a1108e0e6899c25c=
a16e4f5f0d58f3d8938539bf970e2b9192f310e2d20b520871ded3702dbf5caa3b1ca0ab9=
dfc3563daeff6bc4b5949757a8c2e3ca9a67bf295b123a86294f1250b4f35a0b8b7382446=
f050d2b62dcacfec5c4bd201e00a50d3d2dd97eef43b3e3934392d9ce77262400f2f04ed7=
14ee7a18b79a7ff98fa60d934af0acc351c2fc3e9f416ee164fab7dc0f6067d10b6932520=
c2cad5d0d1ff5622bf8ee5f524fb292ac315eace7d02c80f885749a096b43dde45cd41164=
2282c163fdc2af62b9dfbb7e02005dc40d107c4747b7d749d1607a7cdc3ec29600bfd480c=
80fe4e302164ca3765ea070de833c5efdbc2cb396306f652e00593682a3392f9d2af52f33=
77003f2771ab919c6d5c86df6f5ef335084b9e25564e510b7e1ee1158e4b011043fefa037=
67cb6a4b647044f247f1d24f9d27a95b84347b5495e81b1d25f8cf3d00ce81cb58aa46185=
8768e052001ec35072d1f687386673819411288144a7c92d120dd58453751c8825dff0dd6=
99202dc73beccf1fc161ef12bdca01bc982bc93ff7927b0bc5c076db8077ad0088fba10f5=
d17b50740f14d238315fecabc89ca4004db8990685c51e7272844db7bc1c16be97622cc75=
69f7eb799708b9c44cd15500fc48a577a5ef21bcdeb4b01b1966b46fe5fc1e527a5eb7205=
4265499e36cbc77efbef2f3ed56abe3e9a7fb79027179855bc52e23a635fbc1f97999db95=
312408a2a6824f9d02641bc275f5f98891b1e5571fb985b4aad3c7542bde57186aea7e04c=
23b344aae36e5842264ff5d7f3d97b8fcab46ed86f33d61a180bb9e8422cfef7e9dbf6fe6=
aa1f411e8413a5dc3f1fb2acfca42ee728d684f6aee25e8da3567c1cc1775efabd4300b99=
63fdc1f85f213af53a74fc3a765ce2ccd33435b4a77e78abb45254cdf197a155af61d9645=
6e344c2187b86637ff38ea31f1ae06f0450dc07c4f75483d7465dc1c858c66268bd6dd79a=
ab93034c4bf074916aa0af59517131a3ee7ba071a8e8489f8abfe5ccea8fbd19fd87f13c0=
b79ae9dc4aed40b876d4026dfdf81fbd26c1471b3d089d8f42b59fd4e333895b62cfad106=
43bac3c9b3693ab266e458429332a208fc31f79d5f3bcc467c918a3f7ed6c11978459a205=
5cfbfa66bc6f4842d1a06b6d1002b831f0fbab4037e6437682609510b24964fda2f3a93f1=
14cd309347cba2e957a85afe51205d9a379a3e1f071774b25e02196cd56066b04af86dd8a=
e5d232e34795abe101d22f40d8de9be579b7441bff26297b6acdf2a443ec68162e9f72e07=
2e3c36bbf3699bb24ea36a00e2a331e64d7398ce667a010ecc60458ec1e36b5240fad8146=
e3879e89400c7a1689185d96f3e42c14cb634b8e33c295a069447136d25426e48c2dfa77d=
11c3b2ca5b1ebe5ff49b4b1a216b40f9b6dc823e58d4a4a686d8e24f3ab217b35abe18dc0=
e57d1d6908e32dfc26da5aa1a04e3b7ee1d015226f57bc0da311e7dc8cd2f766f1e4c40bc=
27b7b62b38985f768a7f885884be43f9e13af66592decc37ea77b83d82997f27734f4d8f1=
ec2bcfeb61fb73169a37953a1bc699ef2ae3365c931001fb42ae1d2c2234bf184dbf4c19e=
7fa0a18fd0b374140430aa14edc03b2abd1fe3d2d515c67e7155c8066366cf0f0e4c72671=
a3b812d4b25844e5e1b59de8d1bd13a5a06262511b2f1d43da6608bab3a406723e1774262=
1155ed8f771bca33b4aabea0ba02c7ef8a5ee44e19a09a2a9f298ae4faaa347d3549f1aa1=
5c608fd8f3c48ee91e5d1f7c09c90d13f1e677313a4c074a1a3b6b3c7a184ea34875afc9c=
1ec7d8f4828e9dd9a4bd8a5d101c8770a371c08f446828de72c6b9f09b8e964e579d7652c=
35799693c7aa3c666116dba3555ea37cf7a40b43e1c75a4d8242843362d8f46b13a071ad5=
e68db0394c5b2a89c75a8eab80709d80c8b479e9f98726faeb2c6c2dbddc6fd0824bf0c79=
76b39fd50acc7400d8f69c7830e1a72985f9818e62af00943d4aa9c710971ed553174f1e4=
fd5934d5382659466a9acff619605796fe6a15b167df17991c8eaea0aa300528e2b504784=
66f4d296f7cc667a21fec9e693c4d4ca2c9c2a0e6fc4fc92757e2de37fb7813e5127e6c71=
38d8f7359ee0e97d479161e05c608e2f709729f1f4bd43772ac8a1c4615c4ede74a91e4a1=
6458b0de739721d2ec8b0514a79161ce0087008d3cd97fdd5538c518b24b28419f67ce0fe=
d106b4df122ba9f51af5952a956a0b9c95319f5c49e3f7b48a19dcc9d9f3b5ded21a95622=
07f162b805b628018dad3161f938942cded99e86f51296a815a9eeb1cdd60330a2573ce7d=
cdb07643fc3d5362a87db6a1ef0014bdf70edb584a9168eef7c4baa260e284a5f221b71dd=
72a23d2443a393c7a3d415b640e6ef68b6325cc8323c7441b036950efad4ac9fb10510cd1=
1b06d1c5cc8258dfa0c9e52f09b47828c337f3291d311a450844afbd52de50527d4cdeb06=
121270ce90a29b8f3fe79ea68ad18e2d34148e643a706fb24ff74dd8664abbea9894f2544=
c22f174a9e50d954b6359af53fff54598a7e686c84299c84721b57276c15adcac69ea92b0=
a9abc225bb9a1a6f2254f51aea3da768b324f3bfed0bd4170fd1784d17384fcf16e8cf23b=
ec1a23151cfe2c81894d95599586e136e70ab39d867df88147f0cf56a5bc6d2dff584baa0=
4f7c1ccdb41eae35345bcd2f9c4160e5d141c0714ba4e00abfc11ba3044b566252ab24331=
428160e22fac02d71704bba9cd3658e4ad1edb5dda5e0f20ca2b768db78f9835501a0fa53=
c21a390f894ed62d815a736f6683e0fe841eb881db6941ac4199e1a91f74ac207928bba02=
4490ca79dd212adaad5b2125fc1abde7214e775880daee271128d3b110c1f4837ca237624=
69b3e046539b0dcbc9efdc74d5729f9554aeb11cd4f169649a1e0a516bba7a2744529e7a5=
bad1cc654713015476353c04ada5d5a4a41e80cea1c72bd97ee95aee3298202208ec13ab9=
c8c002ed999ef0c4114ebafc49333ed4e8acb8ecc346615720c9635ceccb2b4aae738552c=
b3a25d00f14fc49ceda292c0ba51e3705c8910b849bc40bce90825cffea3b93003f23eb27=
22057e3324a585a9d28f8407f01f38b37e621537a7791cc81ed4385160c4e4e33b8c43e6e=
e71c2cfdb9b29bc7b62110f3d43b36ed066f2cc903c712bb134e58a37349cae68d9ee2da8=
831738c299f71e8abf9e64186c234eb9c87e983eb31fbf854fd809f5b5e3994fb287db385=
c67666524cddacf77955ddf8eccc91e4ad0f974f56720bcbe28e64ca4aa537cac33a7af5c=
64577d9ce3ccafed63000afe624037cc6f50c4f1843f774227b831e462e6699d31d8e862d=
e7839a6c21642d02f42ebc1f97e57277565a35897dfedeb13b595f89ff9ee7e923e87f0a8=
e218df193da791b5e6b5125cf010ea46ad97e69fba91d5a5f5910fe4c62614308bfae38b4=
93bf47730b2407f58c4013b74787c3b2366e11c56f24864575c03e153fac827dd8cc40b7d=
a5cae79d7348bc9020e8d953f030e69fbdc151b844864b7928983fc52ddb78f7ca9d969f0=
df112426d71b6213f274f4c6f847cf2690ef569e3e6cd1b4690cdb15ee899a4cef5831b7b=
94316a817305b5afe6b7e04bf72b634421dfcc78062f21ace9a094e71e54fa5a68ce305ff=
8d655a4cb76bab1a5f65695068ddcc713f894d0964893f0e8ea0aaded011feb0d7e81b096=
9d62b19c399d303f9355577c1a7ce9f48226aff3da483abc841f994f6d073a111751ea78d=
b37654289d4d26aea096e789cac8fe3bb23195d31a7b8033ec2ad09839d15585daa7de2b0=
ed14dc178df27b1c6783bdf2d63aee1d0d4b5c73386b6c193f6bb19ada653c9d89de533a5=
f95d731111048d727b541f8e130e9b0c698e0695b12d603e6c600f7fe5039ffc0c8e9dd06=
d67b8c040a341ccb89399a097a178d70caa10141665898d836ad6a63f1f53e5f71fd16f58=
92c9a4b8d6bd8653a7ba0a888f746e3e050777cf6d569e43772b6938b65a3a6d555310d00=
3b74ff88afb640c1584a163f3ff30564fc974f2f92f92f4dc8eeb8e09c25089c55781100f=
3d5025c6f8118bdcdac966fc3077447a43fdd25496771f9a7a5f88a1556e9e48f4251a56c=
cce8830bb60905006029c562f7540684cc47e398fa292146b2579652454c89e2f3b6118ba=
d6964176403b431490adf3d108f9ee0c91a7a56b4fff0c0e3461e45d445a65a3108df44ca=
da6fe0c1bc98039188b588f223726e5d18de2805c901c92aeff6ce7f9072e6c065d8f5e08=
a356983abdd55cb89d4062f90c0bdaff31b070786f7957d48c0006a4c59e9705172061579=
cda17c0fc953045cac664c8a63534101cda0fa271f88d97e30121923e1359777ccc9b477a=
ddd6517b5993afb19c6eedc4f052a6ee879233f9d1f3ec431e3aaa787e561223ca44906d3=
ac85523e3332c29fbda77ba95a16d6f99aa893f7df8b0cacff383e196578b76b0f847bd44=
0acbba3d9642dfea94703c39514397ffa671751513c15f1eb5614e54c1db8f9fcdb515e61=
75b13d19eb82edeee6362563ed91a3229b8876e299149a51a40a9718da40cf3236209694d=
3aef482e79349e88e1ef23a79ca484c4c04eb7732ac35733af6cb4f5dc49e5c67bb916ad4=
85bcccec344d387627a3b1b97d7f6c82f5e29313f19e8e42e065eb94120bdd1523a11ddd3=
26514a2c8a54338c5b86328dc031cd07ab66b2b4a52f3a29a33dd776cc33a7b0643b6922b=
00c05f726ea96d2bf9f52c5d88c4c814a1ad9e3df182900176a5daf9006bc0b3987282ad4=
72a9ff9653335110020bd97df97084afc01fbf75f5538bbef39f934d781cf5152aa43219b=
4ec36b5d247c2f037359b02a21931fe187f77210d4d6745963a8cfa379e5e581ba0096574=
466a112892a85a7de6b5b71e8b5cbed837a1216b52aec86c2f132a5b68cab5f4fb8fb4b8e=
66d0b8da3ec9440e8ad3e8652ac045ed7ec82e46e49d0006c1112ab8338ecab8660167e2d=
b4930f1bb2e9fb5687f0b40b40e0dd6b75e78a082fdbfea91da3f07b57dbec8776232f312=
b2d267a8bd372aeb94e2ff2323798553839c961d820d701da8a67a1fc0efa49595f3a88ea=
db8a01c80c239968925fe2a71c4c3571511d13638685f33a2957da0f9b3444e9c1ad13e6e=
eb9175bb188e2cd28e7db490b3f2cedc96c77c01ff7abcf2b27c2086eae3f3b4a1489c5f5=
aa067065ce96108bda1000f636bce346722c6902511ac1a0c688b0f49552cbce6c0543677=
3b43cefd7ca335ded24e17d92c61987bb87693555b8ffe222d30a99ea4ab557994ff136c2=
d9c24872f66e91220b339aa978dc250c435d1d04d460319e0ba2ead5c8329698ce1426d42=
705497671e127266ce256a20cd5b4d859bc5361c5319801576a598f6d391fcf41cecb2663=
226105b6308ccd81c5fcf52c30e7b1d43d1e518884f521ac9d017da826d1c079445be1660=
65ce5974f92fe92645342aab60d5417d1d0a206bbdfb96cf4346023267aa3aeafac6cb5ea=
594fb452635a97f4f87f634b477bee33a3bf0c526c8e5c091e7213659d3fcb8773fbfa38f=
2edff5636dedc6838a9d7e279228a56f89d5a6baccff0461d91d136ea8d097c83993804f5=
4fd264db79aa67c81e966a352b1b9549247fedc317019fa506edba35b0e3d61c93950562a=
6d968c001e24900ec7609a8f72c9d6953b7eeeceda50f237e59c106e16b68145aa746ff37=
35d279b1162cb0383c0ec9d124c94cc4337f21e980d6566d907d0be94b67539b8d10dbdfb=
d840acfa278d5ab3e35a64ee36b2934f019175d946be8723b8c529fe2c171d05e12c471fd=
8de3cd0d2f816fc679273ed18bf0df1953b1e346aecebfb226746ff493b263dc0886dbe2e=
7994a2e547f3c8fff2424c1529f28c390d7e0c6d8829585c41a730b37bdf5343d6396f244=
ebc1c695d37f4b343d9e1a56ef15f808323c465e91bfc8b7f23a71e306128b1cb5da4477b=
7e140426430f458bcdec732d45da8d33939389412ee609821e07a47f218f8447d246d8b2d=
f005ca0b1dc70db2e1800ffede9c04b3a1e1247c4ac6d7f4065ddcd73e08b8777953ae24a=
9d0ec824fe75c1220a20b2e9c0b9bdc5102043f7ef47da065742ce5930582b670a6b012e7=
030792ded6c5d3c4e92e8a27a626fb2594151e5ac1d93bae6e86a89cbd748e35678bc28f3=
aba772cd05990260014607c7348e78da39425b1e13403a9750fef9820f9b15cc16ff6beb9=
fb86277c06873aa18c9509cd3597f31502b6da18fa7ae25ff104db554e2021edc0860311a=
d8956d3a415a3f70058699235ba0cbcc304640622763985a81ad5eeac54827a4b4adcf254=
b3a8909959f9f5509d7207c07cd801bf1b6691edaf191b4ea870302b8d6b51a1539c857f0=
f012204572e32e6d64e2217b7918a0acbf87779c60555bafab138b6edda46d4ad8a835a47=
06a0bf754e7109abc885254949b03e3b2d265385ba54dcabe4857e85d804d3ba72bb38305=
a143ea21f523844e732ab89a42bdc61f6be1f9b28e3386cad2ca92f6c70a613722f3c0c4a=
f72b2cf39d5b734dace0f2e7f66d6c2ef74e141e73cf90c6f979c576a82380249b6c654a7=
b2ef8372896f96f6f766642dacd5841250c97143857e545beab5c3882a3e1d529bb519945=
412e6bfc774e99463dc15bad3f6069c5827ee76897151330dacd669814a58185e301d6f0f=
701908d378b6183bc6b06a8efba3e70a4b790b017743ce08e9bccc686fd0cd725e3ddb931=
1573aaf22f6e49b2c013306c145ed34275433e869a4a721da89de4f59602c5c7a9e54e678=
fbe0e88f64110c975b692390e1f6e896dd322559ab9c629eaec0be9553ea26c1c0360fab0=
2d8e8e16e378976ce57126b434baae51289e916210aa802849b23ec851b1ddbde105bdfe3=
72c96da4ed1a9f4f64464ad704e077b14036fa47fa1c20444392e30da43088e0f3926ea1f=
ba4f2193ca38f7baf44889f45081006acc319e9fe73b7efd7702543c08ae91426fb0333e3=
a347c795adc061d11bd524f5bd1570e0ed47796f6bf068953be6a91b43e66607e25fef130=
5025b9a7558caf9a9cbd1b91757c21cfa254c3ff83f5445c0ae3e70c2f295ccb05ae85c54=
70b893f9768b3c641695dfedc01382bd952023331f6401cd20993b7460f0b5f2cac0779f9=
92570d7682afbf5b2f1caae09c9791a3e9090a5864e895c372064fec3203700cfc75939f2=
e9b79e2907cd9ba03708c4bdd4d2fed6602cfe12b9b6388988fe9c955e71b90fc73405522=
ed1b7579a0c278431e0bac8ef597f398440bda215da819af94b6bab31f79f9cf00394cb95=
5beddef2b97bfe985b6efed138dbfffeff375c2ddcbfa930bf896",
0x2000, &(0x7f0000000c80)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, &(0x7f00000003c0)=3D{0x90, 0x0, 0x0, {0x4, 0x2, 0x0, 0x6, 0x5,=
 0x80000000, {0x6, 0x9a, 0x7, 0x0, 0x80000001, 0x3, 0x6, 0xde23, 0x4, 0xa=
000, 0x8, r5, r6, 0x4, 0x3}}}, 0x0, 0x0, 0x0, 0x0, 0x0})
openat$dir(0xffffffffffffff9c, &(0x7f0000000140)=3D'./file0/file0\x00', 0=
x0, 0x50)
read$FUSE(r1, 0x0, 0x0)
write$FUSE_INIT(r1, &(0x7f00000000c0)=3D{0x50, 0xfffffffffffffff5, 0x0, {=
0x7, 0x2b, 0x4, 0x12010081, 0xcc8a, 0xfff, 0x8, 0x802, 0x0, 0x0, 0x10, 0x=
7244}}, 0x50)
fallocate(r0, 0x50, 0x100000000, 0x80000000000003)
sendmsg$nl_route(0xffffffffffffffff, 0x0, 0x67730c5147ca9aa6)
bpf$PROG_LOAD(0x5, &(0x7f0000000240)=3D{0x4, 0x2, 0x0, 0x0, 0x4, 0x0, 0x0=
, 0x0, 0x0, '\x00', 0x0, @fallback=3D0x6, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0=
x0, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
capset(&(0x7f0000000040)=3D{0x20080522}, &(0x7f0000000080))
shmat(0x0, &(0x7f0000ffd000/0x3000)=3Dnil, 0x6000)
syz_emit_ethernet(0xe6, &(0x7f00000000c0)=3D{@local, @dev=3D{'\xaa\xaa\xa=
a\xaa\xaa', 0x3d}, @val=3D{@void, {0x8100, 0x0, 0x0, 0x4}}, {@ipv6=3D{0x8=
6dd, @udp=3D{0x8, 0x6, "6fc097", 0xac, 0x11, 0x0, @rand_addr=3D' \x01\x00=
', @local, {[@routing=3D{0x84, 0x8, 0x0, 0xb, 0x0, [@private2, @local, @r=
and_addr=3D' \x01\x00', @rand_addr=3D' \x01\x00']}], {0x4e20, 0x4e23, 0x6=
4, 0x0, @wg=3D@response=3D{0x2, 0x3, 0x4, "996c4d68534708d069c56f2901359d=
7c0bda8f2be08f23420b3bae28ddf16751", "0b081be8739a2a9c0b1ccb0865778f04", =
{"1f2358db7f3ed45a2a7e849fc8ce4873", "e8cb8224a8fbef6add0425371732ab21"}}=
}}}}}}, 0x0)

25m42.25050915s ago: executing program 37 (id=3D1687):
r0 =3D socket$nl_route(0x10, 0x3, 0x0)
r1 =3D socket$nl_generic(0x10, 0x3, 0x10)
ioctl$sock_SIOCGIFINDEX(r1, 0x8933, &(0x7f0000000280)=3D{'bond0\x00', <r2=
=3D>0x0})
r3 =3D socket$nl_generic(0x10, 0x3, 0x10)
r4 =3D syz_genetlink_get_family_id$ethtool(&(0x7f0000000440), 0xfffffffff=
fffffff)
sendmsg$ETHTOOL_MSG_STRSET_GET(r3, &(0x7f00000001c0)=3D{0x0, 0x0, &(0x7f0=
000000080)=3D{&(0x7f00000000c0)=3D{0x28, r4, 0x1, 0x70bd2b, 0x25dfdbff, {=
}, [@ETHTOOL_A_STRSET_HEADER=3D{0x4}, @ETHTOOL_A_STRSET_STRINGSETS=3D{0x1=
0, 0x2, 0x0, 0x1, [{0xc, 0x1, 0x0, 0x1, [@ETHTOOL_A_STRINGSET_ID=3D{0x8, =
0x1, 0x3}]}]}]}, 0x28}, 0x1, 0x0, 0x0, 0x20000020}, 0x8000)
sendmsg$ETHTOOL_MSG_COALESCE_SET(r1, &(0x7f00000001c0)=3D{&(0x7f000000008=
0)=3D{0x10, 0x0, 0x0, 0x40000}, 0xc, &(0x7f0000000180)=3D{&(0x7f00000000c=
0)=3D{0x2c, r4, 0x100, 0x70bd28, 0x25dfdbfd, {}, [@ETHTOOL_A_COALESCE_RX_=
USECS=3D{0x8, 0x2, 0xd6fb}, @ETHTOOL_A_COALESCE_PKT_RATE_HIGH=3D{0x8, 0x1=
2, 0x5789}, @ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH=3D{0x8, 0x16, 0x5}]}, =
0x2c}, 0x1, 0x0, 0x0, 0x28040801}, 0x48000)
r5 =3D openat$nullb(0xffffffffffffff9c, &(0x7f0000000000), 0xb0a02, 0x0)
write$P9_RREADDIR(r5, &(0x7f0000000440)=3D{0xb, 0x29, 0x2, {0x5}}, 0xffff=
ff9c)
sendmsg$nl_route(r0, &(0x7f0000000000)=3D{0x0, 0x0, &(0x7f0000000040)=3D{=
&(0x7f0000000100)=3D@newlink=3D{0x44, 0x10, 0x711, 0x70bf28, 0x25dfdbfc, =
{0x0, 0x0, 0x0, 0x0, 0x7091, 0x12160}, [@IFLA_LINKINFO=3D{0x1c, 0x12, 0x0=
, 0x1, @ipip=3D{{0x9}, {0xc, 0x2, 0x0, 0x1, [@IFLA_IPTUN_REMOTE=3D{0x8, 0=
x3, @rand_addr=3D0x64010100}]}}}, @IFLA_MASTER=3D{0x8, 0xa, r2}]}, 0x44},=
 0x1, 0x0, 0x0, 0x4004001}, 0x2004e840)

24m30.71457109s ago: executing program 38 (id=3D2291):
keyctl$set_reqkey_keyring(0xe, 0x3)
r0 =3D openat$iommufd(0xffffffffffffff9c, 0x0, 0x0, 0x0)
ioctl$PPPIOCSCOMPRESS(0xffffffffffffffff, 0x4010744d)
ioctl$IOMMU_IOAS_MAP(r0, 0x3b85, &(0x7f0000000440)=3D{0x28, 0x7, 0x0, 0x0=
, &(0x7f0000000540), 0x0, 0xfffffffffffffffe})
prctl$PR_SET_TAGGED_ADDR_CTRL(0x37, 0x1)
openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)=

openat$full(0xffffffffffffff9c, 0x0, 0x80, 0x0)
ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
0080)=3D{0x1, 0x1, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x0, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0}, 0x384, 0x7, 0x2, 0x1, 0xffffffff, 0xd1, 0xac6f, 0x0, =
0x0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x5)
sendmsg$IPCTNL_MSG_CT_GET(0xffffffffffffffff, 0x0, 0x8010)
bpf$MAP_CREATE(0x0, &(0x7f0000000100)=3DANY=3D[@ANYBLOB=3D"01000000090000=
0023d100000700010001000000", @ANYRES32=3D0x0, @ANYRES32, @ANYBLOB=3D"0400=
"], 0x50)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0x9, 0x8, 0xe, 0x0, =
0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0}, 0x2, 0x7, 0x2, 0x5, 0xffffffff, 0x400000a, 0x3, 0x0, =
0x0, 0x0, 0x61}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0x3)
r1 =3D openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x=
2, 0x0)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r1, 0xeb08=
0000)
writev(0xffffffffffffffff, 0x0, 0x0)
rt_sigtimedwait(0x0, 0x0, 0x0, 0x36)
ioctl$PPPIOCGMRU(0xffffffffffffffff, 0x80047453, 0x0)
r2 =3D syz_open_procfs(0x0, &(0x7f0000001040)=3D'mountstats\x00')
preadv(r2, &(0x7f0000001080)=3D[{&(0x7f0000000000)=3D""/4081, 0xff1}], 0x=
1, 0xec8f, 0xfffffffc)

24m30.7013278s ago: executing program 39 (id=3D2294):
r0 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
setsockopt$inet_sctp6_SCTP_SOCKOPT_CONNECTX(r0, 0x84, 0x6e, &(0x7f0000000=
000)=3D[@in=3D{0x2, 0x4e22, @broadcast}], 0x10)
getsockopt$inet_sctp6_SCTP_GET_ASSOC_ID_LIST(r0, 0x84, 0x1d, &(0x7f000000=
4fc0)=3D{0x1, [<r1=3D>0x0]}, &(0x7f0000005000)=3D0x8)
setsockopt$inet_sctp6_SCTP_STREAM_SCHEDULER_VALUE(r0, 0x84, 0x7c, &(0x7f0=
0000001c0)=3D{r1, 0x0, 0x3}, 0x8)
setrlimit(0x0, &(0x7f0000000100)=3D{0x80000000, 0x6})
ioctl$TIOCGSID(0xffffffffffffffff, 0x5429, &(0x7f0000000040)=3D<r2=3D>0x0=
)
ioctl$ifreq_SIOCGIFINDEX_batadv_hard(r0, 0x8933, &(0x7f0000001040)=3D{'ba=
tadv_slave_1\x00'})
ioctl$TIOCL_GETMOUSEREPORTING(0xffffffffffffffff, 0x541c, &(0x7f000000014=
0))
mprotect(&(0x7f0000001000/0x3000)=3Dnil, 0x3000, 0x0)
r3 =3D openat$urandom(0xffffffffffffff9c, &(0x7f0000000040), 0x100001, 0x=
0)
ioctl$RNDADDENTROPY(r3, 0x40085203, &(0x7f0000000080)=3DANY=3D[@ANYRESOCT=
])
r4 =3D socket$inet_sctp(0x2, 0x1, 0x84)
utimensat(0xffffffffffffff9c, &(0x7f00000002c0)=3D'./file0\x00', &(0x7f00=
00000300)=3D{{0x0, 0x2710}, {0x0, 0xea60}}, 0x100)
getsockopt$inet_sctp_SCTP_GET_LOCAL_ADDRS(r4, 0x84, 0x6d, &(0x7f000000034=
0)=3D{r1, 0xe5, "6ea062c33a28a8ec8c22e00c2b0a15033ee776090c2027db1dbd62f0=
5439e7ce94140521e0223ce635c8c36ad73fcee6798a9001a3bb7f1b17f001f7ebec95dea=
e840b054959a30b4044aaf8e8a2ee39b41cc3931fd4bd343c26a81f025aed964d13b839ad=
982ffac6435d54ad1007ba19e6b122b7f650c20fa7a4e171e9a35a5070d1f7fa11cc9cdd1=
78bde4ace6b4fcbadbaa9dc6c43664f591abf0877711e6ccc360740e1b5427a06b04c5600=
201449398ad4a815df818f6c256e93a1b2e6a1592c1fa66ba0998febe431cbcd0df59c96d=
93da7c4252b4d7984cdd732b20b48fb7f0a53"}, &(0x7f0000000440)=3D0xed)
getsockopt$inet_sctp_SCTP_I_WANT_MAPPED_V4_ADDR(0xffffffffffffffff, 0x84,=
 0xc, &(0x7f0000000000), &(0x7f0000000040)=3D0x4)
writev(0xffffffffffffffff, &(0x7f0000000040)=3D[{0x0}], 0x1)
getsockopt$inet_buf(0xffffffffffffffff, 0x0, 0x30, &(0x7f0000000040)=3D""=
/4096, 0x0)
bpf$PROG_LOAD(0x5, &(0x7f0000001180)=3D{0x1f, 0x1a, &(0x7f0000000600)=3DA=
NY=3D[], 0x0, 0x0, 0x0, 0x0, 0x0, 0x1f, '\x00', 0x0, @fallback=3D0x37, 0x=
0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x16f9}, 0=
x94)
perf_event_open(0x0, r2, 0xffffffffffffffff, 0xffffffffffffffff, 0xa3fe55=
84ab28859a)
umount2(&(0x7f0000000380)=3D'./file0/file0\x00', 0x0)
mkdirat(0xffffffffffffff9c, 0x0, 0x1c0)
r5 =3D openat$binfmt_format(0xffffffffffffff9c, &(0x7f0000000540)=3D'/pro=
c/sys/fs/binfmt_misc/syz0\x00', 0x2, 0x0)
readv(r5, &(0x7f00000006c0)=3D[{&(0x7f0000000580)=3D""/138, 0x8a}], 0x1)
r6 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
setsockopt$inet_sctp6_SCTP_PEER_ADDR_THLDS(r6, 0x84, 0x1f, &(0x7f00000001=
40)=3D{0x0, @in=3D{{0x2, 0x4e20, @empty}}, 0xf, 0xea1}, 0x90)
syz_clone(0x1400, 0x0, 0x0, &(0x7f00000002c0), 0x0, 0x0)
sendmsg$nl_route(0xffffffffffffffff, &(0x7f0000004e40)=3D{0x0, 0x0, 0x0, =
0x1, 0x0, 0x0, 0x850}, 0x20001004)
r7 =3D semget(0x2, 0x0, 0x210)
semctl$IPC_RMID(r7, 0x0, 0x0)
ioctl$EXT4_IOC_MOVE_EXT(r4, 0xc028660f, &(0x7f0000000280)=3D{0x0, r4, 0x8=
0000001, 0x6, 0x6, 0x3})

23m13.7688289s ago: executing program 40 (id=3D3197):
syz_emit_ethernet(0x42, &(0x7f0000000000)=3D{@local, @empty, @void, {@ipv=
4=3D{0x800, @tcp=3D{{0x5, 0x4, 0x3, 0x1e, 0x34, 0x68, 0x0, 0xce, 0x6, 0x0=
, @loopback, @empty}, {{0x4e20, 0x4e28, 0x41424344, 0x41424344, 0x1, 0x0,=
 0x8, 0x10, 0x8, 0x0, 0x40, {[@timestamp=3D{0x8, 0xa, 0xffffffff}]}}}}}}}=
, 0x0)

21m27.89737922s ago: executing program 41 (id=3D4194):
bpf$ENABLE_STATS(0x20, 0x0, 0x0)
r0 =3D bpf$PROG_LOAD(0x5, &(0x7f00000007c0)=3D{0x3, 0x4, &(0x7f0000000000=
)=3D@framed=3D{{0x18, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x878}, [@call=3D=
{0x85, 0x0, 0x0, 0x23}]}, &(0x7f0000000500)=3D'GPL\x00', 0x0, 0x0, 0x0, 0=
x40f00, 0x0, '\x00', 0x0, @fallback=3D0x10, 0xffffffffffffffff, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x3}, 0x94)
bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000200)=3D{r0, 0x0, 0xe, 0x0, &(0x7f=
0000000380)=3D"0f88888c7b1a103b58f5df25f641", 0x0, 0x0, 0x0, 0x0, 0x0, 0x=
0, 0x0}, 0x50)
r1 =3D openat$autofs(0xffffffffffffff9c, &(0x7f0000000000), 0x161900, 0x0=
)
ioctl$AUTOFS_DEV_IOCTL_TIMEOUT(r1, 0xc018937a, &(0x7f0000000040)=3D{{0x1,=
 0x1, 0x18, <r2=3D>0xffffffffffffffff, {0x7fffffff}}, './file0\x00'})
io_submit(0x0, 0x1, &(0x7f0000000480)=3D[&(0x7f0000000080)=3D{0x0, 0x0, 0=
x0, 0x0, 0xeea, 0xffffffffffffffff, 0x0, 0x0, 0x10}])
ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
0080)=3D{0x1, 0x2, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0xa, 0x8, 0xb8, 0x0,=
 0x8000000007fe, 0x2, 0x0, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0=
x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1,=
 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x=
9, 0x1, @perf_bp=3D{0x0, 0x4}, 0x300, 0x5, 0x2, 0x4, 0xffffffff, 0x9, 0x2=
, 0x0, 0x2, 0x0, 0x10000061}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff=
, 0x8)
syz_io_uring_setup(0xf00, 0x0, 0x0, 0x0)
r3 =3D bpf$PROG_LOAD(0x5, &(0x7f0000000100)=3D{0x16, 0x4, &(0x7f00000000c=
0)=3DANY=3D[@ANYBLOB=3D"1800000001000000000000000080000081125000000000009=
5"], &(0x7f00000002c0)=3D'syzkaller\x00', 0x0, 0x0, 0x0, 0x41100, 0x0, '\=
x00', 0x0, @fallback=3D0x1c, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0}, 0x94)
ioctl$AUTOFS_DEV_IOCTL_PROTOSUBVER(r1, 0xc0189373, &(0x7f00000001c0)=3D{{=
0x1, 0x1, 0x18, <r4=3D>r2, {0x5}}, './file0\x00'})
bind$pptp(r4, &(0x7f0000000280)=3D{0x18, 0x2, {0x2, @remote}}, 0x1e)
r5 =3D socket$nl_generic(0x10, 0x3, 0x10)
sendmsg$nl_generic(r5, &(0x7f00000024c0)=3D{0x0, 0x0, &(0x7f0000002480)=3D=
{&(0x7f0000000000)=3DANY=3D[@ANYBLOB=3D"140000001d00659725bd7000ffdbdb250=
1"], 0x14}, 0x1, 0x0, 0x0, 0x40}, 0x40800)
syz_genetlink_get_family_id$devlink(&(0x7f0000000140), r5)
ioctl$AUTOFS_DEV_IOCTL_ISMOUNTPOINT(r2, 0xc018937e, &(0x7f0000000080)=3D{=
{0x1, 0x1, 0x1e, r3}, './file0\x00'})

20m59.19566557s ago: executing program 42 (id=3D4420):
r0 =3D syz_init_net_socket$nl_generic(0x10, 0x3, 0x10)
r1 =3D syz_genetlink_get_family_id$netlbl_mgmt(&(0x7f00000002c0), r0)
getgroups(0x2, &(0x7f0000000540)=3D[<r2=3D>0xee00, <r3=3D>0xfffffffffffff=
fff])
setresgid(r3, r3, r2)
sendmsg$NLBL_MGMT_C_ADDDEF(r0, &(0x7f0000000100)=3D{0x0, 0x0, &(0x7f00000=
000c0)=3D{&(0x7f0000000000)=3DANY=3D[@ANYBLOB=3D"3c00000049d934dc68f22365=
38", @ANYRES16=3Dr1, @ANYBLOB=3D"a7be26bd7000fcdbdf250400000008000800e000=
0002080002000300000008000700ac1e00010800040003000000080001005b2c2f00"], 0=
x3c}, 0x1, 0x0, 0x0, 0x4840}, 0x40000000)

20m46.91244181s ago: executing program 43 (id=3D4532):
openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0, 0x0) =
(async)
r0 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0=
, 0x0)
close(0xffffffffffffffff)
openat$procfs(0xffffffffffffff9c, &(0x7f00000001c0)=3D'/proc/cpuinfo\x00'=
, 0x0, 0x0) (async)
r1 =3D openat$procfs(0xffffffffffffff9c, &(0x7f00000001c0)=3D'/proc/cpuin=
fo\x00', 0x0, 0x0)
io_submit(0x0, 0x1ffffca1, &(0x7f0000000b80)=3D[&(0x7f0000000080)=3D{0x0,=
 0x0, 0x0, 0x7, 0x72, r1, 0x0, 0x0, 0x0, 0x0, 0x1}])
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd) (async)
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
r2 =3D perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0x9, 0x8, 0xe=
, 0x0, 0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1=
, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0=
xfffffff9, 0x4, @perf_config_ext=3D{0x0, 0x79}, 0x2, 0x7, 0x2, 0x5, 0xfff=
fffff, 0x5, 0x3, 0x0, 0x8, 0x0, 0x61}, 0x0, 0xffffffffffffffff, 0xfffffff=
fffffffff, 0xb)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x3, 0x9, 0x8, 0x14, 0x0,=
 0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0=
x0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0,=
 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x=
4, @perf_config_ext=3D{0x4, 0xd72}, 0x2, 0x7, 0x3, 0x5, 0xffffffff, 0x800=
0, 0x3, 0x0, 0x0, 0x0, 0x61}, 0x0, 0xffffffffffffffff, r2, 0x8)
perf_event_open(&(0x7f0000000080)=3D{0x0, 0x80, 0x6, 0x2, 0x0, 0x0, 0x0, =
0x7ff, 0x140c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_config_ext=3D{0x6, 0xffffffffffff64f9}, 0x100001, 0x0, 0xc000000,=
 0x1, 0xffffffff, 0xd1, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xffffffffffffff=
ff, 0xffffffffffffffff, 0xb)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x3, 0x2, 0x0, 0x0, 0x0, =
0x7ff, 0x144c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_config_ext=3D{0x6, 0xffffffffffff64f9}, 0x113423, 0x0, 0xc000000,=
 0x1, 0xffffffff, 0x80000001, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xffffffff=
ffffffff, 0xffffffffffffffff, 0xb)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0x9, 0x8, 0xe, 0x0, =
0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0, 0x2}, 0x2, 0x7, 0x2, 0x5, 0xffffffff, 0x9, 0x3, 0x0, 0=
x0, 0x0, 0x61}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
perf_event_open(&(0x7f0000000100)=3D{0x3, 0x80, 0x4, 0x7, 0x0, 0x3, 0x0, =
0xda, 0x80, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0, 0x0, 0x0, 0=
x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x1, 0x1, 0x1, 0x0, 0x0, 0x0,=
 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0xd, 0x0, @p=
erf_config_ext=3D{0x7f, 0x3}, 0x202040, 0x10000, 0x4, 0x5, 0x7, 0x1, 0x2,=
 0x0, 0xfffffffe, 0x0, 0x6}, 0x0, 0xffffffffffffffff, r2, 0x8) (async)
perf_event_open(&(0x7f0000000100)=3D{0x3, 0x80, 0x4, 0x7, 0x0, 0x3, 0x0, =
0xda, 0x80, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0, 0x0, 0x0, 0=
x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x1, 0x1, 0x1, 0x0, 0x0, 0x0,=
 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0xd, 0x0, @p=
erf_config_ext=3D{0x7f, 0x3}, 0x202040, 0x10000, 0x4, 0x5, 0x7, 0x1, 0x2,=
 0x0, 0xfffffffe, 0x0, 0x6}, 0x0, 0xffffffffffffffff, r2, 0x8)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x6, 0x2, 0x0, 0x0, 0x0, =
0x7ff, 0x140c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_config_ext=3D{0x2, 0xffffffffffff64f9}, 0x100001, 0x8, 0xc000000,=
 0x1, 0xffffffff, 0xd1, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xffffffffffffff=
ff, 0xffffffffffffffff, 0xb)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x6, 0x2, 0x0, 0x0, 0x0, =
0x7ff, 0x140c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_config_ext=3D{0x6, 0xffffffffffff64f9}, 0x100001, 0x0, 0xc000000,=
 0x1, 0xffffffff, 0xd1, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xffffffffffffff=
ff, 0xffffffffffffffff, 0xb)
syz_clone(0x11, 0x0, 0x0, 0x0, 0x0, 0x0) (async)
syz_clone(0x11, 0x0, 0x0, 0x0, 0x0, 0x0)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x6, 0x2, 0x0, 0x0, 0x0, =
0x7ff, 0x140c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_config_ext=3D{0x6, 0xffffffffffff64f9}, 0x100001, 0x0, 0xc000000,=
 0x1, 0xffffffff, 0xd1, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xffffffffffffff=
ff, 0xffffffffffffffff, 0xb)
r3 =3D socket$inet6(0xa, 0x2, 0x0)
setsockopt$SO_TIMESTAMPING(r3, 0x1, 0x25, &(0x7f0000000000)=3D0x891, 0x4)=

sendto$inet6(r3, 0x0, 0x4, 0x4000800, &(0x7f0000000100)=3D{0xa, 0x4e21, 0=
x1000, @remote, 0x9}, 0x1c)
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
ioctl$FICLONE(r0, 0x40049409, r0) (async)
ioctl$FICLONE(r0, 0x40049409, r0)
name_to_handle_at(r0, &(0x7f0000000180)=3D'\x00', &(0x7f0000000000)=3DANY=
=3D[@ANYBLOB=3D"2800000002000000d0b8027b445e01eec1df34a4d482090500000056e=
285d701e843bbcf30ccf59b48f564020000005d4588734373fbf1dfaee972d41e7068a125=
0e6614c6c45df8"], 0x0, 0xa00) (async)
name_to_handle_at(r0, &(0x7f0000000180)=3D'\x00', &(0x7f0000000000)=3DANY=
=3D[@ANYBLOB=3D"2800000002000000d0b8027b445e01eec1df34a4d482090500000056e=
285d701e843bbcf30ccf59b48f564020000005d4588734373fbf1dfaee972d41e7068a125=
0e6614c6c45df8"], 0x0, 0xa00)

20m15.4389667s ago: executing program 44 (id=3D4867):
socket$nl_xfrm(0x10, 0x3, 0x6)
r0 =3D openat$uhid(0xffffffffffffff9c, &(0x7f0000000740), 0x2, 0x0)
write$UHID_CREATE2(r0, &(0x7f0000000400)=3DANY=3D[@ANYBLOB=3D"0b000000737=
97a3000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000073797a300000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000073797a300000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000008=
000300a2fdffffb713ffff0600000000000000938200595dae03646c7a561cdf4b0b02819=
791f32c4f45b2"], 0x120)
prctl$PR_SET_TAGGED_ADDR_CTRL(0x37, 0x1)
r1 =3D syz_io_uring_setup(0xf00, &(0x7f0000000080)=3D{0x0, 0x0, 0x4, 0x80=
000000, 0x147}, &(0x7f0000000100), &(0x7f0000000140))
splice(r0, &(0x7f0000000040), 0xffffffffffffffff, &(0x7f0000000180), 0x18=
00000000, 0x1)
io_uring_register$IORING_UNREGISTER_RING_FDS(r1, 0x15, &(0x7f0000000c80)=3D=
[{0x0, 0x0, 0x0, 0x0, 0x0}], 0x1)
write$UHID_DESTROY(r0, &(0x7f0000000780), 0x4)
r2 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
sendmsg$IPCTNL_MSG_TIMEOUT_GET(r2, &(0x7f00000002c0)=3D{0x0, 0x0, &(0x7f0=
000000280)=3D{&(0x7f0000000240)=3DANY=3D[@ANYBLOB=3D"20000000010803000000=
0000000000000a00000309000181149f0955bf007379"], 0x20}, 0x1, 0x0, 0x0, 0x8=
01}, 0x4040000)
r3 =3D openat$ipvs(0xffffffffffffff9c, &(0x7f0000002240)=3D'/proc/sys/net=
/ipv4/vs/sloppy_sctp\x00', 0x2, 0x0)
close(0x3)
r4 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
close(0x3)
socket$inet6_tcp(0xa, 0x1, 0x0)
bpf$BPF_BTF_LOAD(0x12, &(0x7f0000000000)=3D{&(0x7f0000000300)=3DANY=3D[@A=
NYBLOB=3D"9feb010018000000000000000000000000000000020000000000746f23181d9=
538a2459f11b16f64dad4d079dd03f8da82d4ac46e3240c4d3b9083a3ddfaf4a385ba50fb=
3ef7"], 0x0, 0x1a, 0x0, 0x1, 0x618}, 0x28)
bpf$BPF_PROG_RAW_TRACEPOINT_LOAD(0x5, 0x0, 0x0)
bind$inet6(r4, &(0x7f0000000000)=3D{0xa, 0x4e23, 0x41, @loopback, 0x401},=
 0x1c)
mkdirat(0xffffffffffffff9c, 0x0, 0x1c6)
mount$overlay(0x0, 0x0, 0x0, 0x8040, 0x0)
setsockopt$inet6_IPV6_HOPOPTS(r3, 0x29, 0x36, &(0x7f0000000680)=3DANY=3D[=
@ANYBLOB=3D"2b1d00000000000003e623d51d7398d0ce308bbdf910a253289a9ba3c4f15=
9ec9665ba7529142f7cbb4f727ddc8bdf52ca337eb8df95f0fe72aedda94d62cb3b6e51ac=
dd382b31e566b612cf9bb4355f06ff751440f2c58d391c5d1260a04c2887b71a694bfc9f1=
4489e172357341f426f01067e7994209a755df327af79ec74e40c746f0316595bf3196404=
cbb2b16ed166c1462cfde644106b6f0eb40e6186b28e32ed5f9b95cb89e0c92ed456c103a=
563c120163182d0ba608cb1e4e27e2ad4d8b2c8320b143c0eeda5adc48b0e2a21239c6b16=
89d9acdbdfd71c1b81599b30f98ed7917e360f13be1eadd0ab940c"], 0xf0)
sendmmsg$inet6(r4, &(0x7f00000036c0)=3D[{{&(0x7f0000000580)=3D{0xa, 0x4e2=
3, 0x389, @loopback, 0x2}, 0x1c, 0x0}}], 0x1, 0x20004810)
recvmmsg(r4, 0x0, 0x0, 0x60, 0x0)
mkdirat(0xffffffffffffff9c, &(0x7f0000000080)=3D'./file1\x00', 0x1c6)
mount$overlay(0x0, 0x0, 0x0, 0x8040, 0x0)
sendmsg$nl_xfrm(r3, &(0x7f0000000140)=3D{&(0x7f00000000c0)=3D{0x10, 0x0, =
0x0, 0x200000}, 0xc, &(0x7f0000000100)=3D{&(0x7f0000001940)=3DANY=3D[@ANY=
BLOB=3D"440100002300100028bd7000fbdbdf25000000001c0017000000000027bd70002=
6bd70002709000027bd7000fbffffff28001a00e000000200000000000000000000000000=
000000000000000000ffffe000000202000d270a001000010000000000000008001800020=
000002c001300fc020000000000000000000000000000ff02000000000000000000000000=
00010000000000000000280017000300000026bd70002bbd70002cbd700025bd700001000=
000ff7f000002000000ff0700008300020078747328616573290000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
00000000000000000d8010000db08bc1d5485de342261c312a8d83c91b9a5d5bb1fe18d35=
b825125a57e1b210f98ce7c95894aa7148ffd280d968f56565406b5e54a529c995745100"=
], 0x144}, 0x1, 0x0, 0x0, 0x4040001}, 0x0)
bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000200)=3D{0xffffffffffffffff, 0x0, =
0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2, 0x0, &(0x7f0000000100)=3D"e582", 0x0},=
 0x50)
setsockopt$inet_sctp6_SCTP_AUTH_KEY(0xffffffffffffffff, 0x84, 0x17, 0x0, =
0x0)
openat$sysfs(0xffffffffffffff9c, 0x0, 0x2, 0x0)

19m38.65499278s ago: executing program 45 (id=3D5140):
mkdirat(0xffffffffffffff9c, &(0x7f0000002000)=3D'./file0\x00', 0x0)
r0 =3D openat$nullb(0xffffffffffffff9c, &(0x7f0000000000), 0xb0a02, 0x0)
r1 =3D syz_open_dev$usbmon(&(0x7f0000000080), 0x3624984e, 0x42200)
mmap(&(0x7f0000001000/0x3000)=3Dnil, 0x3000, 0x5, 0x13, r1, 0xc19af000)
mount(&(0x7f00000000c0)=3D@nullb, &(0x7f0000000180)=3D'./file0\x00', &(0x=
7f0000000140)=3D'iso9660\x00', 0x401, 0x0)
pwritev2(r0, &(0x7f0000000300)=3D[{&(0x7f00000000c0)=3D"af9b000000", 0xff=
fffdc8}, {&(0x7f00000000c0)}], 0x2, 0x9, 0x9, 0x14)
r2 =3D socket$nl_generic(0x10, 0x3, 0x10)
r3 =3D socket$nl_generic(0x10, 0x3, 0x10)
r4 =3D syz_genetlink_get_family_id$ethtool(&(0x7f0000000240), r3)
sendmsg$ETHTOOL_MSG_LINKINFO_GET(r3, &(0x7f0000000780)=3D{0x0, 0x0, &(0x7=
f0000000740)=3D{&(0x7f0000000000)=3DANY=3D[@ANYBLOB=3D"18000000", @ANYRES=
16=3Dr4, @ANYBLOB=3D"010026db07250204000180a1ca"], 0x18}, 0x1, 0x0, 0x0, =
0x24000000}, 0x4000)
r5 =3D openat$vfio(0xffffffffffffff9c, &(0x7f0000000400), 0x143002, 0x0)
ioctl$VFIO_IOMMU_MAP_DMA(r5, 0x3b71, &(0x7f0000000500)=3D{0x20, 0x0, &(0x=
7f0000000440)=3D"e91119de2f779b8fb0e2f47b02e884e07c1a014c9561716e62240eae=
b15c0cdb07f65620b19a6f64451cac2a7901af096f89405f7e5425ecc0032de95229ba2e1=
27cb15bcdf25525ae75ede761f304f54a2b7414ae7a86bb5784636651644d9b7ad73775be=
935dbee8cd21f020a8d0a1051c094af0b38dbfa01e9ecf25e8f11777b1032bf16bbe1570a=
99e01a25fa2941e50611cdff329bb32fe030bc8c8894f27b20faa5842871f6094ad6aa299=
e7645356b3299af6431ba85a37", 0x1, 0x42})
r6 =3D syz_genetlink_get_family_id$nl80211(&(0x7f0000000100), 0xfffffffff=
fffffff)
ioctl$sock_SIOCGIFINDEX_80211(0xffffffffffffffff, 0x8933, &(0x7f00000001c=
0)=3D{'wlan0\x00'})
ioctl$sock_SIOCGIFINDEX_80211(r2, 0x8933, &(0x7f00000003c0)=3D{'wlan1\x00=
', <r7=3D>0x0})
sendmsg$NL80211_CMD_SET_STATION(r2, &(0x7f0000000380)=3D{&(0x7f0000000040=
)=3D{0x10, 0x0, 0x0, 0x800}, 0xc, &(0x7f0000000340)=3D{&(0x7f0000000200)=3D=
ANY=3D[@ANYBLOB=3D"fc000004", @ANYRES16=3Dr6, @ANYBLOB=3D"040025bd7000fbd=
bdf251200000008000300", @ANYRES32=3Dr7, @ANYBLOB=3D"dd00be001bc0d03ca778c=
29c63edd6179af93140473650c78c9080bb23eb2dcc4b611b2ec5c49f06a4ece8c6eb4cbb=
f2e6675157c1b598c4e7551a0cb1585ee1153c6a8afd2c62687e6c6d8cbf4ae22b21b0695=
1a2be420a92b8d9c6517bea1acf492ef7e3763a3acfdccff242012c554ab8f241246127cc=
faf9f675b2b82d7f0709b8141d8068d37c6601dde4efd53d1e0425be0ae7955d54b7d0e07=
213094366949b775972c1c07fc4a87de28d617a476573123a974a4638ff089feff21c9fa7=
b19977840e129f1289f0d7cd858c44289e7ba629df9b7129e02b3a05000000"], 0xfc}, =
0x1, 0x0, 0x0, 0x44}, 0x4)

16m34.51172646s ago: executing program 46 (id=3D6412):
openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)=

perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x0, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0xa, 0x4=
, @perf_bp=3D{0x0}, 0x1, 0x8, 0x2, 0x1, 0xffffffff, 0xd1, 0xac6f, 0x0, 0x=
0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x5)
ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
0080)=3D{0x1, 0x1, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0x9, 0x8, 0xe, 0x0, =
0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0, 0x2}, 0x2, 0x7, 0x2, 0x5, 0xffffffff, 0x9, 0x3, 0x0, 0=
x0, 0x0, 0x64}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
r0 =3D openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x=
2, 0x0)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r0, 0xeb08=
0000)
r1 =3D openat$fuse(0xffffffffffffff9c, 0x0, 0x2, 0x0)
r2 =3D syz_create_resource$binfmt(&(0x7f0000000040)=3D'./file0\x00')
socketpair$unix(0x1, 0x1, 0x0, &(0x7f0000000580)=3D{<r3=3D>0xffffffffffff=
ffff})
ioctl$sock_SIOCETHTOOL(r3, 0x8946, &(0x7f0000000040)=3D{'veth1_to_hsr\x00=
', &(0x7f0000000000)=3D@ethtool_cmd=3D{0x8, 0x8, 0x5, 0x4, 0x1, 0x1, 0x1,=
 0x0, 0x88, 0x2, 0x0, 0x3, 0x2, 0x5, 0xec, 0xd0, [0x0, 0x8]}})
openat$binfmt(0xffffffffffffff9c, r2, 0x41, 0x1ff)
r4 =3D bpf$MAP_CREATE_RINGBUF(0x0, &(0x7f0000000400)=3DANY=3D[@ANYBLOB=3D=
"1b0000000000000000000000000004"], 0x50)
ioctl$BTRFS_IOC_TREE_SEARCH(r4, 0xd0009411, &(0x7f0000000d80)=3D{{<r5=3D>=
0x0, 0x2, 0x6, 0x1, 0x0, 0x4a, 0x8000000000000000, 0x1, 0x1, 0x9, 0x4e6, =
0x1e5c5651, 0x400, 0x0, 0x7fff}})
ioctl$BTRFS_IOC_INO_LOOKUP(r1, 0xd0009412, &(0x7f0000001d80)=3D{r5, 0x4})=

r6 =3D bpf$PROG_LOAD(0x5, &(0x7f0000000340)=3D{0x2, 0xf, &(0x7f0000000d00=
)=3D@ringbuf=3D{{0x18, 0x0, 0x0, 0x0, 0x3, 0x0, 0x0, 0x0, 0x2000000}, {{0=
x18, 0x1, 0x1, 0x0, r4}}, {}, [], {{}, {}, {0x85, 0x0, 0x0, 0x84}}}, &(0x=
7f0000000300)=3D'syzkaller\x00', 0x0, 0x0, 0x0, 0x41100, 0x0, '\x00', 0x0=
, @fallback=3D0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0=
, 0x0, 0x0, 0x7}, 0x94)
bpf$BPF_LINK_CREATE(0x1c, &(0x7f0000000780)=3D{r6, 0xffffffffffffffff, 0x=
30, 0x0, @val=3D@uprobe_multi=3D{&(0x7f0000000000)=3D'./file0\x00', &(0x7=
f00000004c0), 0x0, 0x0, 0x51, 0x1}}, 0x40)

16m33.69929854s ago: executing program 47 (id=3D6421):
socket$unix(0x1, 0x1, 0x0)
getsockopt$inet6_tcp_int(0xffffffffffffffff, 0x6, 0x18, 0x0, &(0x7f000000=
0000))
unshare(0x8020000)
r0 =3D shmget$private(0x0, 0x4000, 0x20, &(0x7f0000ffa000/0x4000)=3Dnil)
pipe2(0x0, 0x90000) (async)
pipe2(0x0, 0x90000)
openat$full(0xffffffffffffff9c, &(0x7f0000000140), 0x80, 0x0) (async)
r1 =3D openat$full(0xffffffffffffff9c, &(0x7f0000000140), 0x80, 0x0)
r2 =3D bpf$PROG_LOAD(0x5, &(0x7f00000003c0)=3D{0x3, 0x3, &(0x7f0000000480=
)=3D@framed, &(0x7f0000000500)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x0=
0', 0x0, @sched_cls, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x=
0, 0x0, 0x0}, 0x94)
bpf$BPF_LINK_CREATE(0x1c, &(0x7f00000005c0)=3D{r2, r1, 0x2e}, 0x14)
r3 =3D epoll_create1(0x80000)
read$FUSE(0xffffffffffffffff, &(0x7f0000001280)=3D{0x2020}, 0xfffffffffff=
ffeeb)
bpf$PROG_LOAD(0x5, &(0x7f0000000240)=3D{0x4, 0x2, &(0x7f0000000000)=3DANY=
=3D[], &(0x7f0000000300)=3D'syzkaller\x00', 0x4, 0x0, 0x0, 0x0, 0x0, '\x0=
0', 0x0, @fallback=3D0x6, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xffffffffff=
ffffff, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94) (async)
bpf$PROG_LOAD(0x5, &(0x7f0000000240)=3D{0x4, 0x2, &(0x7f0000000000)=3DANY=
=3D[], &(0x7f0000000300)=3D'syzkaller\x00', 0x4, 0x0, 0x0, 0x0, 0x0, '\x0=
0', 0x0, @fallback=3D0x6, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xffffffffff=
ffffff, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
sendmsg$nl_route(0xffffffffffffffff, &(0x7f00000000c0)=3D{0x0, 0x0, &(0x7=
f0000001580)=3D{&(0x7f0000000040)=3DANY=3D[@ANYBLOB=3D"4c0000001000010029=
bd7000fbdbdf25000000", @ANYRES32=3D0x0, @ANYBLOB=3D"673004001742020014000=
3006272696460655f73300016801400018010000200f9ffffffd90400"], 0x4c}, 0x1, =
0x0, 0x0, 0x400d0}, 0x24008088)
ioctl$AUTOFS_DEV_IOCTL_FAIL(0xffffffffffffffff, 0xc0189377, &(0x7f0000000=
0c0)=3D{{0x1, 0x1, 0x18, r2, {0x3, 0x2ee7a12b}}, './file0\x00'})
ioctl$ifreq_SIOCGIFINDEX_batadv_hard(0xffffffffffffffff, 0x8933, &(0x7f00=
00001200)=3D{'batadv_slave_1\x00'}) (async)
ioctl$ifreq_SIOCGIFINDEX_batadv_hard(0xffffffffffffffff, 0x8933, &(0x7f00=
00001200)=3D{'batadv_slave_1\x00'})
r4 =3D openat$full(0xffffffffffffff9c, &(0x7f0000000080), 0x80, 0x0)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x0, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0xa, 0x4=
, @perf_bp=3D{0x0}, 0x1, 0x8, 0x2, 0x1, 0xffffffff, 0xd1, 0xac6f, 0x0, 0x=
0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x5) (async)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x0, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0xa, 0x4=
, @perf_bp=3D{0x0}, 0x1, 0x8, 0x2, 0x1, 0xffffffff, 0xd1, 0xac6f, 0x0, 0x=
0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x5)
socket$alg(0x26, 0x5, 0x0) (async)
r5 =3D socket$alg(0x26, 0x5, 0x0)
bind$alg(r5, &(0x7f00000000c0)=3D{0x26, 'rng\x00', 0x0, 0x0, 'drbg_nopr_h=
mac_sha1\x00'}, 0x58) (async)
bind$alg(r5, &(0x7f00000000c0)=3D{0x26, 'rng\x00', 0x0, 0x0, 'drbg_nopr_h=
mac_sha1\x00'}, 0x58)
ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
01c0)=3D{0x1, 0x2, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd) (async)
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0xa, 0x8, 0xb8, 0x0,=
 0x7fe, 0x2, 0x0, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1=
, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x1, @=
perf_bp=3D{0x0, 0x4}, 0x300, 0x5, 0x2, 0x4, 0xffffffff, 0x9, 0x2, 0x0, 0x=
0, 0x0, 0x10000061}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0x8)
setsockopt$ALG_SET_KEY(r5, 0x117, 0x1, 0x0, 0x0) (async)
setsockopt$ALG_SET_KEY(r5, 0x117, 0x1, 0x0, 0x0)
socket$inet6_udplite(0xa, 0x2, 0x88)
epoll_ctl$EPOLL_CTL_ADD(r4, 0x1, 0xffffffffffffffff, &(0x7f00000000c0)=3D=
{0xa0000002}) (async)
epoll_ctl$EPOLL_CTL_ADD(r4, 0x1, 0xffffffffffffffff, &(0x7f00000000c0)=3D=
{0xa0000002})
epoll_ctl$EPOLL_CTL_ADD(r3, 0x1, 0xffffffffffffffff, &(0x7f00000000c0)=3D=
{0x8000008})
write$FUSE_NOTIFY_INVAL_INODE(0xffffffffffffffff, &(0x7f0000000000)=3D{0x=
28, 0x2, 0x0, {0x5, 0x1, 0x9}}, 0xffffff22)
shmat(r0, &(0x7f0000ffd000/0x3000)=3Dnil, 0x6000)
madvise(&(0x7f0000fff000/0x1000)=3Dnil, 0x1000, 0x3)
r6 =3D socket$nl_generic(0x10, 0x3, 0x10)
fcntl$lock(r6, 0x6, &(0x7f00000027c0)=3D{0x1, 0x2, 0x5, 0x5})

15m41.58667781s ago: executing program 48 (id=3D7025):
socket$nl_route(0x10, 0x3, 0x0)
r0 =3D socket$nl_xfrm(0x10, 0x3, 0x6)
sendmsg$nl_xfrm(r0, &(0x7f0000000480)=3D{0x0, 0x0, &(0x7f0000000400)=3D{&=
(0x7f0000000000)=3DANY=3D[@ANYBLOB=3D"c40000001300010128bd7000fb000000000=
000000000001a00000000000000000000000000000000004e2000004e2200040200002010=
000000", @ANYRES32=3D0x0, @ANYRES32=3D0x0, @ANYBLOB=3D"4b000000000000009c=
1d00000000000009000000000000000900000000000000910000000000000000000000000=
0000009000000000000000000000000500000f2d200000000000008000000000000000600=
000000000000fd01000000000000090000000000000001010200000000000a00100001000=
00000000000"], 0xc4}, 0x1, 0x0, 0x0, 0x2000c851}, 0x4040000)

14m55.94133196s ago: executing program 49 (id=3D7209):
r0 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
sendmsg$IPSET_CMD_CREATE(r0, &(0x7f0000000340)=3D{0x0, 0x0, &(0x7f0000000=
300)=3D{&(0x7f0000000000)=3D{0x5c, 0x2, 0x6, 0x301, 0x0, 0x0, {0x7, 0x0, =
0xa}, [@IPSET_ATTR_PROTOCOL=3D{0x5}, @IPSET_ATTR_FAMILY=3D{0x5, 0x5, 0x2}=
, @IPSET_ATTR_TYPENAME=3D{0x15, 0x3, 'hash:ip,port,net\x00'}, @IPSET_ATTR=
_SETNAME=3D{0x9, 0x2, 'syz0\x00'}, @IPSET_ATTR_REVISION=3D{0x5}, @IPSET_A=
TTR_DATA=3D{0xc, 0x7, 0x0, 0x1, [@IPSET_ATTR_TIMEOUT=3D{0x8, 0x6, 0x1, 0x=
0, 0x9}]}]}, 0x5c}, 0x1, 0x0, 0x0, 0x4004000}, 0x20008000)
unshare(0x40000200)
r1 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r1, &(0x7f0000001540)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000080)=3D@newlink=3D{0x28, 0x10, 0x1, 0x70bd29, 0x25dfdbfa, {0=
x0, 0x0, 0x0, 0x0, 0x49061, 0x242f3}, [@IFLA_GROUP=3D{0x8}]}, 0x28}, 0x1,=
 0x0, 0x0, 0x400d4}, 0x240000c4)

14m30.11360088s ago: executing program 50 (id=3D7309):
getsockopt$inet_sctp_SCTP_PEER_AUTH_CHUNKS(0xffffffffffffffff, 0x84, 0x1a=
, &(0x7f0000000000)=3D{0x0, 0xa, "3a01fa3909b39dd70af9"}, 0x0)
unshare(0x40000200)
r0 =3D socket$nl_route(0x10, 0x3, 0x0)
r1 =3D dup(r0)
sendmsg$TCPDIAG_GETSOCK(r1, &(0x7f0000000200)=3D{0x0, 0x0, &(0x7f00000001=
c0)=3D{&(0x7f0000000000)=3DANY=3D[@ANYBLOB=3D"4c00000012003906"], 0x4c}, =
0x1, 0x0, 0x0, 0x80}, 0x800)
r2 =3D syz_clone(0x11, 0x0, 0x0, 0x0, 0x0, 0x0)
ptrace(0x10, r2)
ptrace$cont(0x18, r2, 0x8, 0x2)
io_uring_setup(0x155b, 0x0)
futex(&(0x7f0000000000)=3D0x1, 0xb, 0x1, 0x0, &(0x7f00000000c0)=3D0x1, 0x=
2)
futex(&(0x7f0000000000), 0xc, 0x1, 0x0, &(0x7f00000000c0), 0x0)
read$FUSE(r1, &(0x7f0000002280)=3D{0x2020, 0x0, 0x0, <r3=3D>0x0, <r4=3D>0=
x0}, 0x134e)
syz_mount_image$fuse(&(0x7f0000000040), &(0x7f0000000080)=3D'./file0\x00'=
, 0x100000, &(0x7f00000042c0)=3D{{'fd', 0x3d, r1}, 0x2c, {'rootmode', 0x3=
d, 0xa000}, 0x2c, {'user_id', 0x3d, r3}, 0x2c, {'group_id', 0x3d, r4}, 0x=
2c, {[{@default_permissions}, {@max_read=3D{'max_read', 0x3d, 0x1}}], [{@=
rootcontext=3D{'rootcontext', 0x3d, 'user_u'}}, {@fsuuid=3D{'fsuuid', 0x3=
d, {[0x4, 0x33, 0x65, 0x39, 0x37, 0x64, 0x31, 0x36], 0x2d, [0x39, 0x64, 0=
x9119240a7409d263, 0x31], 0x2d, [0x61, 0x37, 0x64, 0x34], 0x2d, [0x34, 0x=
36, 0x0, 0x4d], 0x2d, [0x37, 0x63, 0x37, 0x30, 0x37, 0x30, 0x31, 0x33]}}}=
, {@fowner_lt=3D{'fowner<', r3}}, {@appraise}, {@fsuuid=3D{'fsuuid', 0x3d=
, {[0x31, 0x66, 0x30, 0x64, 0x32, 0x37, 0x63, 0x65], 0x2d, [0x39, 0x65, 0=
x66, 0x66], 0x2d, [0x65, 0x31, 0x0, 0x66], 0x2d, [0x38, 0x32, 0x32, 0x64]=
, 0x2d, [0x34, 0x3c, 0x33, 0x30, 0x33, 0x33, 0x39, 0x37]}}}, {@hash}]}}, =
0x1, 0x0, &(0x7f0000000100)=3D"0071d7e8c85cdcd246ca4ea4df6df7474c3e3660b9=
4376f3ad787ff14c32e5850900d3da8a0e99c3456b762ad0f035adcf2bf8c8a7c5fc6b991=
3e5c1f8900be1b6747a9e85d0bb5b14039f1613ac90b0ec368e686210d160f9dbc30b2857=
7cf1720a6c898fd31d1ea918698eccdb67af68b959895cf3fb6953350ec83990ec4ec445b=
5d1bf4a625412ec7aa4f88afc4c83aa18fcedbb2c9997d84fb43be0b54018f8c0")
prlimit64(0x0, 0x7, &(0x7f00000012c0)=3D{0x9d, 0xffffffffffffffff}, 0x0)
syz_fuse_handle_req(r1,
&(0x7f0000000240)=3D"83030292b9853625d2f6e8276d436cad9ea4f5a02a284f043240=
5add883b4ad36c7dc70ac5113c7ac10146d65faee8e850c61c61092c024842a672a8c3ca8=
4abfb9082dedb526687d75f134350ab935ae908c7747d8a968be3ff5d11da3b934df32a3a=
85dee552d407bb00efd1ef197964156e56637cafef5151596515315153ffbfe61245bc716=
6a3f81b10d928c21e2d4664cd8f81afd66a596b030a6b0c7cab1f57af85badcdf8c5cf4d2=
4f3ea67e7c9564aeba8eae79963a96634535a58c7471d3a66073ed02af84ae336b537db93=
b97997e3ed598d9698d597a7838696650f3cfecbb008eba90dde283b7202bbdcee38d9e93=
b715bdf5ec203d4eb3302aa509b299fc3f7caaa7cb7343f6e67553c1b6f7515c7b4814386=
34cf6d43c0fcc5f6351b19a1a57df7a3aef843fd8c8e73cffbd2888f8b51e51f4a0965ac8=
63373097cac9c73c11cc8d6c738d625868faea74cb667c1a0e13c1dd56e740f1b7f126c8d=
ade311a2ccd8688a886180d19d4bf66b824135a8f1fbcc7bb1ee7bf11537930fdd031a67a=
8fab080049c382c005c5282d7c9edc401a7f3c137a9099cd5738f1935b36b1588b7f7883d=
c366a9874d801622c51eb1203352f25d554503000ac1e8ff84d8e0bcb9c8f0d432f293faf=
9ede943751d43261e27bc118cbfb801e124e80c10644e1701a67fae29cef020b598c7a0d2=
3c931df27ca45098aab631845a942d26f3e545ee574522d0ea2a6cc900228e0389c6070f9=
8302e05ab11381893dc542dc03c4df80f11fd4fc02ed0b3794e439f2e06689b0deff63a10=
b305e8c88c34b357405fef4def39ef8d92202705850b289bbcdcc3a9d295ba1d828ecfeec=
0785ebb240e009aa05c42aad9f56951c690507811e5e0de06630c262e1865186707d364fd=
55021029d1acccfa76119959106fc34eebc361db1c313482ebc96470608ce0564187a9280=
642523f4b65f006610e6cd3c3b8bdd895e18cab88b9e12864012a3bf1abf361ef7c46dc99=
4161a75f374fc7d5c1df6f42275817c3e6f85f1d9f3c23bd55afe8b9a418d1aad65771c0f=
43b61a4cc9856b054ea96cad2bb13c00c7ffa9be3c1c9c94473029e0aea957fc611db7eb9=
87cd79862b42f1a3e63a98854269f0ff4a8b76e33d76a4e1823bb041775dc2e6cd96c980c=
65683efe0680a03a819af6669362b783cdc8fe42192756034b32fbeb151b42512904c70c2=
2f24cf106657597ade01f42172ceaa2f63e640133c7784456a0d9003a7afeb9e6cd031f5e=
609999fd64a5088a491d850faff976eb6d2645c299f7e22f07d7f9e35f59420d007c28a9a=
b141c7c43193062ad8223dd1825f6d079c156dd151b7f3ade972b129bc2c33364a26c319e=
77f257379a9ba1c37be27b5406b6d5c143c513eaa699ef8b28651d3fb7a5358742669c018=
fb534ddba126d791c340ee5539ff9d253c09b4199c44d62a26fe71d44ae8ddd8debda03de=
ed61f1f0e47831d5fe3da2a48a6de9537aa6c007c2a264cef9d29afa5d8687828ab6c0826=
ab3f67d9d98e4c148f9e5f79667bc09880e70c1cb7914a4696b61c2c0ab9dec62e6e50ea8=
85ec969458a9186f3d422ae5f8f694ca34032be951765ff89a8d3ad05699b62768381a67c=
512476a642a9cdbee45b1939d20c0e486e71178986005b039e9d5a6495be56e7bea620539=
6091d1043277304995e81410da3b1a52054ded4468410538e7983563bd22d0fc95a46ef63=
4aa37e83fe5194a71a8a32a6326044db7f0fe63d56de970f1e57e7f9621d55d37dad8571a=
e7da88abc14617e153ffd3f11e896da5d0951a4c574d92d29f3f28c44553060ab821fcd6c=
c774dab7a6c2872bc5634cdef31abf5c2140c59b65eae0c47f0733016a107c9064a6ec835=
883ee1d353eaab8ebd995ce1801650011084615bf4baa828776245af7c016c0ab2f4bc9c7=
20879dca312299ddf5d40e51d8bc693b800814eb44c43429447d6a5df151234f874bd5851=
88616b07af08c1123ba5b1dae26c509044f37f21d6fc3602442c44b8133e5a417f7c4ea4d=
a4fe4d379382cefcd9f5e30a076d577217bb2bad6cc3e9a239587ef798572e9fa71486519=
2e0b38439ce9ccfcdc027970d696dee9f4ed9105ec5f4379e40aa508d06cb14e6b3dffad5=
c4b59579737a717777950dc3530bd37b05df4db05d46bf12bfdd042ec228036f0c9adae40=
4328c653297d5443437f329e36cabcbf9affdbf017ab0aa065148dcf6991f427d73d69120=
f8b1ff2d25bdb1aca062c2f2e2389266e6b10814870547a61c29a546e4ffa32850ff6d801=
55c70d68c3b9fc0afcdea3dcf1d0386a29509665b6a6f117ffd14e255d4e61c5d15aa50bb=
b9da0bde8544e984743e30c07936e1bdfd90bec21c732727508b9424abfa4b54a753b89e6=
dedf85457306f8bdccb8a7c6a2423dfa41c6b1cbb888e1b1dc6434b6dab9e613ba4b61aab=
06a97739e4e7fd965d97d0c7735419efed05673715e03aedf444666a30db284249a888bb2=
c5d0e52b8a5ca2060e80a69a2411865a93cbc743ba9c7008a9497e8354657a5320c46dcf1=
71f26713f18423884f25a68cf252d6bd1103fbd6bc21fb1ff7a2bbe18b7803c6463c56301=
f46563fa9fc9e9fbb8d983daa557d38ae86dc2facb2975c2f552b1ee764505dd25425d2e0=
ab51625107c0ff1a101229972add33b2b07607f2f659a867458a8591004648d8f9ff740c7=
10ac6905245887acd46a9652390271461284a3ea2cb18ad7d7281637f7b3212bb43bbb8c0=
272c843f7d664aefcf2e71c179025b88b52e99279010f790037a85bbaf040219b3b26e33d=
924c41e1322a1880f91d4d2dea5f2a76bde5630b30f6a0073ad1e02d1438487d43afaa38d=
fc1ee47a25e661c63da0ff6b168539cc90d0750627a2f36f2ebe1fadec714df26b8c36b3e=
1832bdecba631f4ac1ef8810da0f3ef241001a98b9a4327143bd36f7519c22096d4a80165=
34aab149e9080171e5b3165460a6c95cfb242d0a1fa4d2634541070ba81bdcf4cdbc5a2f3=
b703d9d2b7d0588659687102ad682e7faf41a5dfd2bebc521968544b16c6f117ba5ea6964=
aeb2535864f48c0051ba5caa11d6e60d1bc3883a66e366812ccc63cf22d53cc777342b3c7=
735220f6e75870878c7115e3c508a90a8634f7d839cfd8ba750a5babd6149a22962f2eda6=
3b26c38ca969c5f02ab0740f2e96083329e571e9c873ee5b520b706a27c82a66e59c9edf6=
7a4bd5791326f3a75f87ad503686fa69dd950c64832c4544fce82083fda926205471d3aa9=
2a07571fda3b69a83bf79f0435a6f9e24242cec084d64148ae2348dd78fb37517704d7750=
da58a202c7b72e95fb007b664fd4ee8dc8d76e469c2a4345e80387bcc1e9117a16754d67e=
22755e0f1fb97cb0c2b8a6618ca5e19086d0b239e3f86e877adcba78945e6ed21da1710cb=
0c3e90cc92d6d3176ac7c66b4379765d17865088fae9513c26691544938a1827395496ddd=
b7af91fd5d5c6916567ef481f2961b8f9cc517862531563269db18191f2b7aaab2d20a6a5=
ac74fbe01af439c0455c88f2caf03f333ff0420b2f0a5dad0b6bb12b997a9634eec8f0902=
00dce5169590ae3b82d535acf8591c0a117a60010349f286570a27e84b5e583ed51f9ac9c=
893bb8982d8e62219276aa5ec8af2cc3eab43bb097e1e049e7c4a1ab1a5bdb68bc7252164=
c33c421faedee65837797ee47f89d62b098579c52ad0097f08342a3dacc6c38c89dbf89d7=
9938f4504c386602ebf8dbfd5c1054157bc24e0da45d39b0fdca1844ca37151f09917de63=
3dd32c7e89145854bbcb629aa58d169aded16acda4da8291ec27e6656ec5b97d28f7ccd5b=
f48fb9047ff70a1091b9bf6c38aa0f189baac6d4e478c97e943f3aa61977b0ba206acffee=
191d3c4a4cb7d84404e45d0120078366d96c32f5986b03f25e57be2d73a8bf55ad909925f=
7990dc1ae68f122062018d62fa2aba1ee4ed8541931d207e35d8233ab3400c1d32b6fb6b0=
8ba3f265d5d48dc4e5c6f5a8e48fccfc037acd2e7c708f1148dcb4040fb28b1d8cb2ba624=
101b137fa0066029eaff10fb1fc215ce99f2a21eebe7e469b059f1aa143a9ffdea5de98e2=
24c17dd2cfce8c6d01f116821e820bc33feba8c6624f6ca06775df57fb3f794148e6b05a8=
7d42815edcead366a9dec2f85496690c99a9f5a21560e11fddedbe7de1d8edcc6a2853658=
0c8db71018d091a919a31439b594b3eb76d6fa52f52e6d9326572aabb0403b73aa201c391=
32fe813789b8dd7a2d01ee5e86c8f415e4ceb2aedcb5968ac2d01bd7a6e617e2fe330207a=
8cfe3c8c5756e75cb2977b15e701d9d1d78a1ca30b0c36b8c1981d762298b90220d2c0caf=
a24c16edd0ae3a764f1666aaceb348ed23b2656c460303f450493c894fc809422c492977c=
227fa48e25799fb4b9ea9341d89f7c421ba4509dc7031266ef73b696906037b4222f3c227=
afab88fc0fb06a25493da010a069e19e73a63a68d7d899720189b73ff6830ab332dd5d823=
c92e7e17e4128f5d660fcde58b63a856183e6fff4b1f336072acad9b0e7b91ae1a388f0ed=
4078107a777a406c7e78c9700f0e0220d2b99178308a65a35386ea7e7c015b3736926accb=
68367629c80731607f5b4018152e7cbfaa7510713b56fecbbacf4e980a30b13b0cb0e790a=
7f466283a06fab6880d004da61658aee623fa1724493d06305852df7a96981af56dde5d97=
440c95e1553ed65502ca720cf5db44584605d6d80bdce8fcc4914ba322753f49732f3c566=
e57c7199b87fa2c23a8eedeebd0e216402b882d45275b6128b27b88fc32faa5ac6ae1d403=
4978e1514f439cf878a853953655ca60233ccdd3ff77bb925656f9afe587cb73e0ece3482=
65a799d01ed3717e47e898987e731d58abee6bb30d25663910eadf9de5b8df2485717f06c=
109808c29a948b6c194506974d24e9c2b8d3e636e63059c8d845ba4c559d6df21313ada79=
99edbd645ddfec0e754707d3942c111ec34a98f5cda129f059895491ec55b890aabd9fa59=
d7cc20995b04f0a4962c3e9016f49ef51f74cb18ad706f07443f1d192e37bf62420a6dbfb=
be824a3ed3abb47fdd839be6220198e9dc2b7a6b60d8e52064d16331d8add7e14673bee33=
575d2b35d7ef7f16fc8b115c5b20a9aab7dc87ba49cbf2872a60254635d33da4adbb417f3=
f1ef922fb4555869532ebbc3db9d1146cbc4ba9c4221a4db1c9d7755e78edcacbd68de9b9=
188e49e6b8bd2b69e014dcd007a971dfc8ba7d3e2fa959698798fcbef317abebb02df0bf4=
abd147217e1ac650cf0b26d75fefdb86093c4ca280ebd0f7614a90601adef898dacb9ddec=
c4f027943c7ec337c5fcbd768d970315e844c209bc1e01c7ff656c649fb8902721aa2a34e=
2f5302add6587e0584235ce35b836d865fb85d6691869d90835adc3b6342dbc7681b685cb=
f8cf7d8a905bc225cf787cf7d0f9e22dc57f5b9dda89f6138e6401f1c5938098e9ddeadcd=
532bd38c716be419a1c56883d630f362ee49259dc2d6897737d14c5285701b8a6ab05729e=
12f8a2268131947e833c1385f77d25d8074a14570148dca9832b2440fb141ee3deeec9317=
5087a50439891e3424765a26c0779a05ee861f179130f1b7320f9a064da23dd2abe97a65e=
2045e984e1b4de140a64406e57491a33a9e0598f53ebe4f5ddfe4201a102f76660c4290b1=
fe27ee04c33f8988dbd4035d0774c9f65b838e1047774a51da162feaabd957b819f61ccb9=
3b81a8b0aeaa963ecb0359aed51b8875b2e54d9742ddc1a8885104d052b114402d7c92c2f=
b42eb22acee6c8404100cf5f220ce1c2329eae2912847f55101a5be4ae691d136ae42b89e=
5efc663acd0dc0dc0454a9293e32fca0286e3d5902c170961dbab5a18d3e07a5626d84a94=
e6b22881c4e85c245875e45f7c3c423ba5d853abc8430fd7c9327294e314f7b0e01c5ac34=
708fe69f6139e121df4d1a5bfa11fc541ee31ce18c31cbf9307d8d4d91eb1e763b7044bd2=
222bdc6e7faeb437c67514e3d4004cd898bd4e3a4d660e3fd1d3d6f85b3ddde4d2f662e03=
606858a13187b2641beeb4b14dd61291f8daae456e25ed1116d7a3f8f30bd13ca44298308=
a86473d5f9aef929804172d048e5e64e4652741c6b15df553533d1b3b5b3a287938205b4c=
950b3e657d4279139d623738f9337e30b284c087dc8adb21842ba43964c5689408e0a0787=
9a43e203a230b51dc4cbe8136a302e2612e861e1054f1f0c61c3f320ea11e8b3ed5f693e5=
9feb276c1be413ce1b66364d432613b8c70ae1a43ea21a8e91c311eea1c9f9939c2745562=
49eb1f66cc82101a34454cddf00039b4fc50979c47a3e0f13ef0804311a4bac18aa97107f=
f0c250b08b8a49aaa6395e9b9b00989bcedad968cc6a98fe3c2e8dd28fc1ce88099d11cc5=
0daae783e01643ea8525d60f961606142224447476a72fcbaee6c325d4321286a079b36b5=
cf0e84d5731840c7080e7f023654a7626457a105d505e90fd8718908d1d2a258d924c38e8=
ad0e507d5ace2810720411826cb39d15e33fb6bf28e78626b827dae6b2181b13b70e85547=
d47be0835a65202bae09e309f6f78b5e0df525dd9206ec46e3750d5d2bdce1cde5cadd5b3=
998dab4d603a3720fd059a6ec43a6495509e008a40eeeef66b93e0314b9d73a23b5cd0d12=
625ad5447984543a26971afb394a723be805d5604915668ffe097f21dbafec17ffe8ee37a=
cb11a667d51381ac5b1a05966ce5c144e879634be4534c8b4dd3e55ad215d462fea14d29d=
2ce024e67376db12038d3e51bf22eb531bcbd8b04dda45d4ce9ef1ce9aea833fae5c8e4e5=
943ce81dfd7dff864294c5195e7453d11d43549f51a303a6384def679fd79d10eb3b294f1=
1aa29f64d4bc265f69c5dfbf9638ba875c591e046e03b042f96fc1729fd93f45c012e5394=
21520613d19c7dbd45832a888df79db61291120232b8affb672eb697df9998f8f752af9a4=
2bf6eb416e253bbeab1120450af0f62895621202d52140388d4e35c6e9655733ab8c32d93=
c124f916437411a8defdb5b55d7ef31c27b0653b5e4e1fdf87846d14e069b16beea794c78=
632b8695061c19d413cc66084721f79f5637eff05d1146d7f5fd2dcc4d8a9c677a74d4e95=
ad1fe0bd396817d07c7afff0931d8b69c96b07c5c2bc9ab69c409ea0682b0d62fa7d9aae8=
c3d92a1aee48536bfcaa0e6247b29d988a055c6918f057c0cab4e9c7ebef91fb66706fd04=
a9da5ff153ced9b6102fbb5ff9c963256bf92bc2c86a11cf10de1f3e113c4e10ce4cd528f=
74cf45d29730a73bf58c942db1f270386a6a8f280c73cf86ea692db5c0c99681e9d03b477=
4da8def476788c07f66f97201188e0cdc4684c01004eca01c93a2f6dd279c081669ad88dd=
4ca68f7433e940c44f4bc0d9a159f7546aed4db089c97f15867e7335b085f39d3bb5750d4=
b4142efe31e55d8d83a4d7e9bcc37a5296a310141625155b2bed89269bbc931d7e8fd1433=
a6a66640b80e912cbb3ce145a58d998eb084f5a3c8d0b8f3c7dd0c19736d7bff5db791f9c=
6ce67b1a14f24530f6d12bedfaec9b54ad4dbd912f915e5048663175faa52884f48e36c1a=
b53d4edf66ff732f0cb4a47f39bc2d912d80bd9003e7da1a7b85e96f2ccaaea9bf951141e=
f17d9cce8c9ce2fde26f8937ffea3584d12b47da250d599eafa776c7bfdaa569974bc0066=
6d3995a3cc245e47f5fb3d1b60d05a28b155d941a1ec6893730edbde3e2777e7c2abf61b0=
8ca9c49093aa8110a8d7a8567e7ec4d520c9266a2697d2b65e4b088daa18d3e5f9703762d=
3a652a9826b6a19ec0a03c7688a5336e96dad0b81aecc281dfb37baba3d77ae2c659af3c0=
2478ae6b7c4b1adc3b9f446700dbfe6798ada41f273914ab36c4c911886c01b795a0beadd=
92faa323fa1b82f10b6155f4462ef59894ed8d422afdb7977e85f218daf982ed71b0dd12f=
b0a987c2cf486c038a68258756d1520e6b72cb7c3a4404a451d08884af0a6c3e5311c99ef=
68ca7470daf7d21538c83472a3a9aba402b547819693b281f90831d6dbc36aaff24b84fc2=
03ff95f9f3763905cc3be751b734ca7f00868a016139c7efbede5007a08fc315d14674575=
d7d44328262f3b528f4b1875c9c68d19efe9c771065bba1ce0505001c61f23d1d9f63a446=
91291d795e50ccd0caa2867977d5cc43fb3cc4f0ad36e3b7c1cbff7a3ff49249a6808ebe9=
3617c91906afc3809843e41e95bd26d6d81a6de49430920e54533e282fb0c20f224a648ba=
be9d7fc38012cc66a97ac5689ec8fcc60d1303658a8f766d433fb54744a2ef72fe6037949=
89c01711d88fd7547a20ac31b6141a88ec3cd2816931282d669ee74a671689c05dd7fcd23=
55d22f0df4ac0d158f3e47e90f15a8ff75b68182c12c4bea08cea7973a706a908c6b194f6=
5b5bee875dc21b3afcb0c7f10319ab3f5ea88f4232fb5218dd9b9315649e92495ca477926=
c33a4ca0fa97df8f8541377c746839400147193d849781e432c4c33e243f9a4b4127359c6=
145e98dcc15e02b0d75ffa2e59366227febfac0693a65b7a06925df49bf5b542cf7cdf2d1=
f54fc2f81555e51e40c82bc2366463703512dea650f21a88e1cd14d2eb6a6c7a4415d8245=
d0d192ae90baf597955b16b6cfbb250608da397f0fae2e672b853fd30d2b8b507cad47b8e=
b8c179e31a4fc064146cc0ebaab91b740b47c8670c114921eef60d860f363d7d47d22ace0=
414fbaa307b8816adba1d9f61cfef0839250c68d0cca1853dbfc17ee9a23e265f15d4fae3=
721ab59ac2dcf15673b3e853f0adf8c8e7938cd9f5470cd15c368edcc87c34241b1b72dec=
6763e20945855f4765bed3bf51d4ef78492028e5e69998d6c36cd4ee6fa95bbc5c4487254=
d73ed7ac38abde2c7a4c5e2acf5f95f2d30b450e451cd8e42ba36ef3181f98325e663db2f=
433ba653d2a6a861810ae1a337dff6d82950a21096c6cb36362724a8eb6eb8d5822bd6f7b=
0f2291192558de7a8e8c397180443139179b2bb88d8e51418397ce10bc38cb7cf3e7061b6=
cbc3edd2236a80034138a79800744136f200267f971d9e322e0a5fd2ae8e3c29fb34c3024=
39797ecac7cd3f5090301b83b02a5526db24071f51783547b42c7d9db12d359883fe8eab3=
1cd93af9841254b0d5f0f8165155d199dd3e41916d157758e58e5d1705066f49bd2abafee=
1a9ed5cf9f854d21ee4a539e138fc1e447627b1ca0617caac7a668e2e70333de36cb7b11a=
307690e44edb88e7a32e49d8a6d5b83e2be68cb43c6881093ea62c23b4b820e61ff531b77=
a8f911c36c20c69ea83aac72ec90bc869b19c884adb7502ec165b0a9b2120c84aeb9117f8=
942ad6dfa7c9ff6e10f9a1e511c61e1ae155b63b94ec2ba24631b594e52ac52a638b981be=
1fb00e3d3c4300097574d835a1d230c577c1e935aa15089d50f60b9fcf652585dc9be338c=
c5de20ff60187f6f04471c590b485389b91b4bd93a2ec2a4d6abb1a27320aa4abd8469102=
d1a1d9c3ea4b1d787f97a0edec802e6064e6d55d8414cfde0d864329d1267971855dbe8fd=
2314663bc57bff1e2b97254eaa859bae62c98e5a8fa6d89621d997bce27293d7c01e7c34b=
0ba99aa1b72f7735846d40f2a0b4b41e4fca667fe33ed12aa930cca77a7cc4cf36ca12597=
83c8e6fa420c3580a481ddf45efdb1b98abcc142d354be63dddc9ce05c7e0061874d60ee6=
d3a53be3304fc31a42407f4252fca00b14450771b66dd07735b9bcd3c93049db2e0d3f2ac=
24e4196c5697161762636d8f5152cd1a057520f757bee3834c3dbb2039f28eb417491f466=
3517979ea871ff770b82c887f7272a992459b605cc667c9718815e961e6e2e13c5d403350=
2c5dc03c5782349a978748d3b79e803c9ce4e94c1ca06b8dab65dbad796ecb442ebdd66dc=
a29784f0e07480b402b44959168388a67294d1fab0ed7bf96b608439212af9eaeb01af481=
0fe2148ae6a3deaf3046ede6afa9f98f180a42c992f636144c833058218ecc2142dd12f7c=
dcfcdca40fc2479efff00a1cb4083b62bf6dd7611b530edef7df17bc659310c966eb49e0a=
4ee1a9348b9f96a2f8172a8ad8056be1119b1db065f42f3ca8451846cfbe077d2f0b2cf75=
cd39508fe000fc825bd9c4333ef1488badd1af40eae1e01a5a88e9a3f8bbb4d50b4dca3e9=
f32028a51fd47896954ceea50f21d440772bac650af27fa4125797d4527ee08393343abd2=
67ae1591f27c3aad59d893922f1e2355e2546c15bc463742f9b7b6b0d13c835e77a203f06=
7f18f7d79c3ec08cfe0343cab4d8aadcc0228741fd31841de9711ab4ae00c73cd18382586=
7fe8880dae28f427264b7863a50528e153b4a9f98f3f6c0e8ccdc7592987721f2f916e90a=
dc790c7481926b71a52f6f9495757a256f54e823a639f9478e562ad61dca6eaf5d513587f=
bbd5393a76dd88122aeef62e63e1ba700ae16b1c7a0c040513c9222ad724b6db2b520c518=
fbb7d91bd310334c33e2689a89f982d4c399d701aa139793811cb7ee4f797fb90a88d179e=
1c05798ce76fb51feedef8919fda52911fa64a766160e31a2ea437ff3a130c5f8486b50cc=
2f1bb3c4049962feb169f23c2f6070cdb1b42dd22d11d3e89eef09dfd0490954a8bba4981=
418ee78f95082d329e0a70463a29a6a2195233040f6e29211f677eddadaac59530948a1f9=
b496d3d9a949cde11c77725f52bae5694b493ad5d10e32ab9032911f086efaea156e0ef23=
e292093b5d208e915fe261297cea68047d62097ba5aff6c84f9e43d66dca0c5a579f4e650=
6c20a11294adf139bddd6114a790f348378a5c13be9bfed8633739c606b4dd5bedfe84b65=
bb12fd84a94063528e39687e0e31d5243d52d0aa63edade0319fe3364cef3d971e5656517=
85604f8e60f72e6d1f3d68edba865f2aaafe66c65d6c713a4398227b28b0909d304c753cb=
cd1f72fdcb09aa96412dde91b008f3b0ed3ac3acef10be64693ba58024be7963e6a04f81c=
e6b5ccb10382fda7edd1eea1d342fb20535169a3459d4a85f34295c6e8dc392fa7103a325=
2153769cdbe5b82e04a8ecea0faed9b20da483a1804667038d26596aa130d8082e2747c2c=
c8065c57f2518e65828c9e8655806b12ca64109ac3e4d888021dd5c241584b94939b90d57=
05527bf9f1c3bd16efafa8a46c02ea2f727a8f22494fd05ffb23ea843a3fa13580fbdc4ac=
663cb12a12f2d02dbcd79daa2863812d2d8da428ff339ee2ae2558182a4c64b271b369b27=
020643a22eb4da47d5e16723f9cbb832f8634bda0b3f8f2dbc0b2e4d6b63bb8fe1a0dd494=
d1f47d1f40f55fc34b6901dd3f62f9f7781a84ac4091d996614d3eb0f94e5cb32d776e263=
441d5cf801d95547b99df68a2e64854718c9fc055827d64bdff86a065ad2531e91fec7b57=
487ebf34ea9ab8abc52a8f23632703db73280d7fc51e8a8a9ea41e935813e99ef5131667a=
a88d2283466a482a87e0b9c6f8cb244c5362caf180c8a75a7540b75ef1928aa5bc9dec7b3=
252e166dab425ecca4e36a420c71667b71c9b831083105f07842c",
0x2000, &(0x7f0000004f80)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0})

13m43.03078903s ago: executing program 51 (id=3D7693):
r0 =3D socket$inet_udp(0x2, 0x2, 0x0)
r1 =3D bpf$PROG_LOAD(0x5, &(0x7f0000000840)=3D{0x5, 0x4, &(0x7f0000000040=
)=3D@framed=3D{{0x18, 0x0, 0x0, 0x0, 0x9, 0x0, 0x0, 0x0, 0x41}, [@alu=3D{=
0x7, 0x1, 0x9, 0x4, 0x8, 0x1}]}, &(0x7f0000001080)=3D'GPL\x00', 0x8, 0x0,=
 0x0, 0x41100, 0x7, '\x00', 0x0, @fallback=3D0x35, 0xffffffffffffffff, 0x=
0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
bind$inet(r0, &(0x7f0000000080)=3D{0x2, 0x4e20, @local}, 0x10)
r2 =3D socket$alg(0x26, 0x5, 0x0)
bind$alg(r2, &(0x7f0000000000)=3D{0x26, 'hash\x00', 0x0, 0x0, 'xcbc-aes-n=
eon\x00'}, 0x58)
setsockopt$ALG_SET_KEY(r2, 0x117, 0x1, &(0x7f0000001700)=3D"998115bda7931=
e59edfe5ccb0b4856d1", 0x10)
r3 =3D accept4(r2, 0x0, 0x0, 0x800)
recvmmsg(r3, &(0x7f0000000480)=3D[{{0x0, 0x0, 0x0}, 0x6}], 0x1, 0x4000010=
0, 0x0)
syz_emit_ethernet(0x2a, &(0x7f0000000100)=3DANY=3D[@ANYBLOB=3D"0180c20000=
0300000000001708004500001c000000000011907800000000e000000100000e200b28907=
831a249519c129a42a2e7711347a00e9684a2e6675feab3f45bdcef7881c6668432d6558a=
a3d3ff38b6d44d84976eb8748adf2260902e9f4b71510c10fe287e10fbd3", @ANYRES16=3D=
r0, @ANYRES8, @ANYRES32=3Dr1, @ANYRES16, @ANYRES32=3Dr1], 0x0)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
mount(&(0x7f00000000c0)=3D@nullb, &(0x7f0000000180)=3D'./file0\x00', &(0x=
7f00000001c0)=3D'udf\x00', 0xc451, &(0x7f0000000200)=3D'\x00\x10\x00')
syz_clone(0x64000000, 0x0, 0x0, 0x0, 0x0, 0x0)

12m18.88069095s ago: executing program 52 (id=3D8341):
r0 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r0, &(0x7f0000000040)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000200)=3DANY=3D[@ANYBLOB=3D"540000001000110728bf7000fcdbdf2500=
000000", @ANYRES32=3D0x0, @ANYBLOB=3D"e5300400000002002000128008000100736=
974001400028008000100", @ANYRES32, @ANYBLOB=3D"0600000000000000140003"], =
0x54}, 0x1, 0x0, 0x0, 0x418d4}, 0x2004e800)
r1 =3D socket$nl_route(0x10, 0x3, 0x0)
r2 =3D socket$nl_sock_diag(0x10, 0x3, 0x4)
setsockopt$netlink_NETLINK_CAP_ACK(r2, 0x10e, 0xa, &(0x7f0000000040)=3D0x=
3, 0x4)
r3 =3D socket$nl_generic(0x10, 0x3, 0x10)
ioctl$sock_SIOCETHTOOL(r3, 0x8946, &(0x7f0000000500)=3D{'ipvlan1\x00', &(=
0x7f0000000040)=3D@ethtool_cmd=3D{0x7, 0x8560, 0x4000000d, 0xa, 0xf, 0xc9=
, 0xfb, 0x9, 0x32, 0x5, 0x9, 0x9, 0x9, 0x3, 0x2, 0x9, [0x5, 0x7ff]}})
r4 =3D openat$tun(0xffffffffffffff9c, &(0x7f0000000000), 0x0, 0x0)
ioctl$TUNSETIFF(r4, 0x400454ca, &(0x7f0000000080)=3D{'virt_wifi0\x00', 0x=
2})
r5 =3D bpf$PROG_LOAD(0x5, &(0x7f00000007c0)=3D{0x11, 0x3, &(0x7f000000048=
0)=3DANY=3D[@ANYBLOB=3D"1800000001010000000000000000000095"], &(0x7f00000=
00500)=3D'GPL\x00', 0x4, 0x0, 0x0, 0x41000, 0xa, '\x00', 0x0, @fallback=3D=
0x4a, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x=
0, 0x0, 0x0}, 0x94)
bpf$BPF_RAW_TRACEPOINT_OPEN(0x11, &(0x7f0000000200)=3D{&(0x7f00000000c0)=3D=
'percpu_free_percpu\x00', r5}, 0x18)
close(0x3)
ioctl$EXT4_IOC_MIGRATE(r1, 0x6609)
sched_setscheduler(0x0, 0x5, 0x0)
syz_genetlink_get_family_id$gtp(&(0x7f00000000c0), r2)
sendmsg$nl_route(r1, &(0x7f00000015c0)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000080)=3D@setlink=3D{0x38, 0x13, 0x1, 0x70bd29, 0x25dfdbfc, {0=
x0, 0x0, 0x0, 0x0, 0x41048}, [@IFLA_IFNAME=3D{0x14, 0x3, 'rose0\x00'}, @I=
FLA_VFINFO_LIST=3D{0x4}]}, 0x38}, 0x1, 0x0, 0x0, 0x400d1}, 0x240000c4)

12m5.79421921s ago: executing program 53 (id=3D8512):
syz_clone(0x11, 0x0, 0x0, 0x0, 0x0, 0x0) (async)
mknodat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x81c0, 0x=
0) (async)
r0 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002000), 0x2, 0x0)
mount$fuseblk(&(0x7f0000000000), &(0x7f0000000080)=3D'./file0\x00', &(0x7=
f00000000c0), 0x0, &(0x7f0000000340)=3D{{'fd', 0x3d, r0}, 0x2c, {'rootmod=
e', 0x3d, 0x2000}})
syz_mount_image$fuse(0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0) (async)
syz_mount_image$fuse(&(0x7f0000000180), &(0x7f0000002080)=3D'./file0\x00'=
, 0xa40c2d, &(0x7f0000000280)=3DANY=3D[], 0x0, 0x0, 0x0)
r1 =3D openat$ipvs(0xffffffffffffff9c, &(0x7f0000002240)=3D'/proc/sys/net=
/ipv4/vs/sloppy_sctp\x00', 0x2, 0x0)
r2 =3D openat$nullb(0xffffffffffffff9c, &(0x7f00000000c0), 0x30100, 0x0) =
(async)
close(0x3) (async)
r3 =3D syz_open_procfs(0x0, &(0x7f0000000140)=3D'net/ip6_flowlabel\x00')
read$FUSE(r3, &(0x7f0000003040)=3D{0x2020}, 0x2020) (async, rerun: 32)
read$usbmon(r3, &(0x7f0000002f40)=3D""/211, 0xd3) (rerun: 32)
openat$cgroup_pressure(r3, &(0x7f00000001c0)=3D'memory.pressure\x00', 0x2=
, 0x0) (async)
r4 =3D socket$inet6_sctp(0xa, 0x1, 0x84)
bind$inet6(r4, &(0x7f0000000280)=3D{0xa, 0x4e20, 0xfffffff5, @empty, 0x3}=
, 0x1c) (async)
getsockopt$inet_sctp6_SCTP_SOCKOPT_CONNECTX3(r4, 0x84, 0x6f, &(0x7f000000=
0200)=3D{<r5=3D>0x0, 0x10, &(0x7f0000000440)=3D[@in=3D{0x2, 0x4e20, @dev=3D=
{0xac, 0x14, 0x14, 0x1f}}]}, &(0x7f0000000240)=3D0x10)
setsockopt$inet_sctp6_SCTP_PEER_ADDR_PARAMS(r4, 0x84, 0x9, &(0x7f00000000=
c0)=3D{r5, @in6=3D{{0xa, 0x4e22, 0x1000003, @empty, 0x1ff}}, 0xe, 0x5e2c,=
 0x80000002, 0x8, 0xd1, 0xc}, 0x9c) (async)
sendfile(r1, r2, 0x0, 0x4000000040000008)

11m28.85707091s ago: executing program 54 (id=3D8788):
r0 =3D socket$inet6_icmp(0xa, 0x2, 0x3a)
getsockopt$inet_sctp_SCTP_GET_ASSOC_STATS(0xffffffffffffffff, 0x84, 0x70,=
 &(0x7f0000000280)=3D{0x0, @in=3D{{0x2, 0x4e24, @rand_addr=3D0x64010100}}=
, [0x4, 0x6, 0x10000, 0x1, 0x8, 0x5, 0xf066222, 0xd, 0x57, 0x800000000000=
0001, 0x3f80000, 0xffff, 0x8, 0x20c3, 0x5]}, 0x0)
r1 =3D syz_open_dev$evdev(&(0x7f0000000000), 0x0, 0x2)
pipe2(&(0x7f0000000000)=3D{0x0, 0x0}, 0x10800)
syz_open_dev$sg(&(0x7f0000000140), 0xfffffffffffffffb, 0x1)
socket$vsock_stream(0x28, 0x1, 0x0)
pselect6(0x40, &(0x7f0000000000)=3D{0x99, 0x2, 0x7, 0x3, 0x5016, 0x8c7, 0=
x0, 0x6cd}, 0x0, 0x0, 0x0, 0x0)
write$evdev(r1, &(0x7f0000000080)=3D[{{}, 0x1, 0x1, 0x8}, {{}, 0x12, 0xff=
ff, 0x5}, {{0x77359400}, 0x15, 0x8004, 0x1}], 0xffffffb5)
setsockopt$inet6_mreq(r0, 0x29, 0x1b, &(0x7f00000000c0)=3D{@empty}, 0x14)=

fchown(0xffffffffffffffff, 0xee00, 0x0)
setsockopt$inet_sctp_SCTP_MAXSEG(0xffffffffffffffff, 0x84, 0xd, 0x0, 0x0)=

sendmsg$nl_route(0xffffffffffffffff, 0x0, 0x2004e840)
sendfile(r0, 0xffffffffffffffff, &(0x7f0000000180)=3D0xd6, 0x3)
syz_emit_ethernet(0x104b, &(0x7f0000000100)=3DANY=3D[@ANYBLOB=3D"ffffffff=
ffff0180c200000186dd68"], 0x0)

8m15.17443496s ago: executing program 6 (id=3D10061):
r0 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
sendmsg$IPCTNL_MSG_EXP_GET(r0, &(0x7f0000001440)=3D{0x0, 0x0, &(0x7f00000=
01400)=3D{&(0x7f00000012c0)=3D{0x40, 0x1, 0x2, 0x201, 0x0, 0x0, {0x2, 0x0=
, 0x6}, [@CTA_EXPECT_ZONE=3D{0x6, 0x7, 0x1, 0x0, 0x4}, @CTA_EXPECT_MASTER=
=3D{0x24, 0x1, 0x0, 0x1, [@CTA_TUPLE_PROTO=3D{0xc, 0x2, 0x0, 0x1, {0x5, 0=
x1, 0xab}}, @CTA_TUPLE_IP=3D{0x14, 0x1, 0x0, 0x1, @ipv4=3D{{0x8, 0x1, @lo=
opback}, {0x8, 0x2, @broadcast}}}]}]}, 0x40}, 0x1, 0x0, 0x0, 0x4000}, 0x4=
000000)
r1 =3D openat$nullb(0xffffffffffffff9c, &(0x7f0000000000), 0x840, 0x0)
ioctl$BLKDISCARDZEROES(r1, 0x127c, &(0x7f0000000040))
r2 =3D socket$inet6_tcp(0xa, 0x1, 0x0)
r3 =3D syz_clone(0x11, 0x0, 0x0, 0x0, 0x0, 0x0)
r4 =3D accept(0xffffffffffffffff, &(0x7f0000000140)=3D@nfc, &(0x7f0000000=
1c0)=3D0x80)
r5 =3D syz_genetlink_get_family_id$nl80211(&(0x7f0000000240), 0xfffffffff=
fffffff)
sendmsg$NL80211_CMD_TDLS_CANCEL_CHANNEL_SWITCH(r4, &(0x7f0000000300)=3D{&=
(0x7f0000000200)=3D{0x10, 0x0, 0x0, 0x80004000}, 0xc, &(0x7f00000002c0)=3D=
{&(0x7f0000000280)=3D{0x38, r5, 0x10, 0x70bd2a, 0x25dfdbfc, {{}, {@void, =
@void}}, [@NL80211_ATTR_MAC=3D{0xa, 0x6, @device_b}, @NL80211_ATTR_MAC=3D=
{0xa, 0x6, @broadcast}, @NL80211_ATTR_MAC=3D{0xa, 0x6, @device_b}]}, 0x38=
}, 0x1, 0x0, 0x0, 0x8000}, 0x0)
fcntl$setown(r2, 0x8, r3)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x12, 0x8, 0x0, 0x0, 0x0,=
 0x46, 0x140c9, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x1=
, @perf_bp=3D{&(0x7f0000000100)}, 0x104001, 0x2, 0xc000000, 0x6, 0xffffff=
fd, 0xd1, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xffffffffffffffff, 0xffffffff=
ffffffff, 0xb)
mount(&(0x7f00000003c0)=3D@filename=3D'./file0\x00', &(0x7f0000000340)=3D=
'./file0\x00', &(0x7f00000000c0)=3D'xfs\x00', 0x22088f5, 0x0)

8m8.23364437s ago: executing program 6 (id=3D10069):
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
r0 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0)
r1 =3D syz_open_dev$sg(&(0x7f0000000140), 0xfffffffffffffffa, 0x1)
ioctl$FIBMAP(r1, 0x2284, &(0x7f0000000440)=3D0x1) (async)
mount$fuse(0x0, &(0x7f00000020c0)=3D'./file0\x00', &(0x7f0000002100), 0x0=
, &(0x7f0000000240)=3D{{'fd', 0x3d, r0}, 0x2c, {'rootmode', 0x3d, 0x4000}=
, 0x2c, {}, 0x2c, {}, 0x2c, {[{@allow_other}, {@allow_other}, {@max_read=3D=
{'max_read', 0x3d, 0x7fffffffffffffff}}]}})
read$FUSE(r0, &(0x7f00000021c0)=3D{0x2020, 0x0, <r2=3D>0x0, <r3=3D>0x0, <=
r4=3D>0x0}, 0x2020)
write$FUSE_INIT(r0, &(0x7f0000004300)=3D{0x50, 0x0, r2}, 0x50) (async)
syz_fuse_handle_req(r0,
&(0x7f0000004380)=3D"2e38a642041cfb9e35231e472db0d430982f679215dec44403fa=
a9392f32f8d9017e4d616cb0d9c4eac9c4c2721237e53dfa6f8f580e10a927a53dade8a75=
0f6332fd947c1b71d446dd03ab141f91eb6f30f63464d5b044e839395ad09dc753700dcb5=
adc8bb6171c5dc99a0968ee83015a071b19dc43e50fa1e7a87fed649522a082d354ac6866=
8c5d283bca0bbf68094d7d7cfeb75b1eb4ed6fa79bc37e7af66d7fbb11d628d59b8307a9e=
47f47302e9f9fe2eff8e02f2ff8993cae51a9840d8062951f2ff2518d47a0c682cacf7a8b=
00b15d5203ae0073b1d810a4a99857f087c66d6cc2d63edf609952e55b29e4454a3a47d84=
4b90ce1a306fdad1311602978a19718216bd56a3e34549585aad882a51787cbcb1675e22e=
2b705dc4956aed9a8c58d3d8b1f2b6a7f1bcd5c4d85072e2bf7920bb05fe8ff22f47b4b38=
f29ebe77865fe13b2a38368121735902a9725cb2c62be299f9791704b6cc5b93ea97ad535=
7203e712ad86bc7882ed0b7eea9e3a8a2b82c9d6d175cac32e94ff1fbf0736970a4a8efea=
f027c659eb268e7f316c8c9ecd43f7b7b34b350dba663701d9c53ef0153dc87134a47865d=
47f26f8750f364784f8928400762624878bb393a92b9a127f65593b8f0e8eccdfa8ec9b8b=
6120043cd3d5605340533097b14a029ffd3571c4c40de1e82a329df1975580b8af5042c49=
44dd999d7bcf0637c23fc2d47d7317da764c178bbbb011aca4ac1c500384c02bbf6e4792d=
4f1869d8cd3ecbd4e0a9de855f67b7baca9959b17e5242d91bb17dc0f6c5eae72b81ff7a0=
1e577591aeb1b0382cad6f4bbd6c0cfa55a1fd207bed896c9a261a54445eef323c9d7aa02=
f4ca48dd372e9d354ce37d2fc482c614e66dfe03b52ed21401b860c990ef2831090e68056=
157e1216ea5fc87d638eae3f8c9b2b8981195647342927785b26146d36085613c248386e6=
4eb384eef5e828853e704217f5c83a256fb0f55ef852c4e40f3f5a044add10c6bb1573e4a=
8499c4bb044a3a935ae8916cab5f13ec5948f564f035a3e2625c30fd053a8ca9777d4045d=
3a75f92fbe24ac5a287f05e790ab01602722a691c9515a3857f025e6274605300caa57c00=
14f86e735638a9acc29893f01e00fb9f439b74516cf76eed7eab6c9186666a3d43bd4e4f3=
37fe5abe40f17eaa23e3bcf47c59d6b218463a1afd9770679350e4076495a8f2e6a8f2a9e=
b7941ef54204544eb8d9d49a0acf329237fb17caf3c5a11553b292dd3dd9e2b8ba224f91e=
2f1fadeee25e05e6d0bf1b20c414bec8ee607ad59db9deee2594b07142da04ddf1ce93b7d=
8cc443be9e1652872b6f97eda5329395241e29d1b9c494049c4af9a1a83bd5168f6279e9e=
42a0f47d10adad7161f60ff916ac10635711ba40f39f2e94d1fb08743c593423ab52335d9=
946ba0d895b327d760854818fd568ea4225acaa9da724f82c8021f5141dd72ffaf2ac231c=
b7eed8e5ebeb9950803ac56a8a473a654fce2e2ed3d1eeebbbd0665d1562334f0c24d1698=
f186f732448ae7ad7f94e91d6712d6b3973f0aeab010586cb83bdba79e4e0d6f9ae468d11=
4b7b3fd5280c0b9f097f60f2b4aca82af6ee3438d3cd4d945d55656b876c80d4d2010510e=
466f724aaaeeda87f15b7b9dc09621abf08164a2eed5d5feb5d29d9063cc896899fe31c51=
966c5f380df89c6e4ad9a4a63e9713d8a6cbf00d1394e459f3ba9431ac7889761cd070a62=
0e1b02fae48c764c8ed98be09c9bfb88ec673a903e6160f05538265b5f69e82484e3b0a83=
f3ac384029356f4a07b3dee784f12593e2fa82df910f418031faf74a6ab85ba65a853da17=
3d8cd94a921df1947d901e76e54f7f6002d7ea9ed59d093e3edccea090e347ce8ef6598e3=
1f1197837b11206ab7538858131cf524115aafe64829a5e8f0d0290db683cc56eb3e5a805=
9ac612ca97215870cd31d38c71f956dd3167c87e92ce90d5a26f0b5c37c4e78d2b436f014=
478cc1874ba26b35e176436a8a9c1a6b77873a32f98ea224a6dad4f7ab5ab485fe7cfd93a=
4059f75a62578277177a35be66da648b1f98853072ab7e415b0392dc4ec8382a076ef6c9c=
003cb7630a6f69d08bbdcdc49f49a34e454c6d5353a866f68475db7a1c0faf8f78a9e738b=
ec1ae056f7f281f1e93e4c316f9c07ee487d09d07d3e10e3c8f439dbf4cad63db8c60d5d6=
08ca628262ce169393ab021f56f4a0c05fc441c3bb48c021ba3b5612941bc658ed1027945=
5febd28a59d2ebf8938a20578f164a2f21843bce9b6d8aa6624c5dde48b9193fe7993ea84=
4f326ccb949b6ed031afaf4d77e053785789a754d8cc8fcd75e4b90923617015a7998106c=
e249238db8954c486b268094939124c52489799e658b43283a4559b8b18047313ba085eac=
6065c816145485d5fd32263843b9f5e1737bff4ebc3436c3a2b04ccc67f20dafc712ec3cf=
fb055aed249e80dfb1180e1d806e277d81cd50fb8681b53d0c7b0687cb147c9b905fe2877=
b56e676e0ccfa4c9d77cfa0db852b02300544a4ee88cd0bf8c7ecbf2bbb3670a57882e0f3=
41aac87da2d9c5631a4a6a01e70bd0d4e5f7ee732f309eff844c2594ae6babd8d581dce0b=
8274d68795643e3d29a32019db52c51d32d7470b63b020216cc278cc3be83b6b56d0ffc8a=
e0e49baa5e90356ec250bc28df5c3fea2e0f68cf108360e469ec558d12c91272c7a3ff8fc=
4bcecdbc4b1ed212d9b7445de191a38f3b4a0d819e746c74d51d35e31a69a3c99fdba1aab=
6db7dc68c338b9dc53101f4443dc7bfe179b650067095ae313629db984dcac5c8feac431e=
e329084c40299a78b5754d33a07dd6698b788309e4c25e3099bc99cc83433bc4ee1b875fa=
bd2d492db0afaa9f61fd6eea38dfdaa832b3b6ce36b9f73aa684d231f85dfc327c65c3bb8=
f5303eca47df85f6a99fc81843854d1a92b7bb227746c99d93e807b10f874049cb1c241e3=
1d6424e3b66971501b0dd3f3369d23adebb11ec806ecd2200ec2e13a042fb705901f6ee40=
cbe195a8f209c94bad4a24cbaef3904c7512ead61b7bbf0c204ea86e91a48956a9a4ff4c8=
191c895d3886181a0914e4b63838cd314c2a3bcdee3e074d0cf015de28ba11bdb3241c3fe=
e5406684b79206ecbbc5d0c88e7cbf2c3b49daf65a76b8dacf31fd968fb20df86e91c62d3=
05ae9ec37d98a01a8281a3faa8208d0a48ef8d0a1ce47f7be0bed50d687640389d294c1bc=
1b3015a6c733a2f181b6c7df198aa79f641fe68e9b39b75a0ebe35eb432962fadca9637e2=
5d94d13efa9b60957564981747492c42dc5a5f850b683df364b5772120150805f9a748fc1=
05ef1fe672a2a170cc635808f93398d666fb8f474d64dd4d83691fe90ed732aab7d8c8ca3=
e3191cd764b3a169f700187ee24f3b2a2a8d6391ed6013ee4f835245167052434f215305a=
9328c91f8a08819c78809dcd1803eee6073e1e21b3a193e3f57718e3afa1c0b67734dc7e0=
ea400134c18db650d02ad0dde53ff7cab3a5196378480411535756bb9cbe469e537fed7cf=
b9581998d05b2205cc9ef9acbec662f2be5886632b2fd5d5d076e4665e7c94e187e9ecda6=
2455d8242cb8c8cc542fc3a20bfb5af2a60e5d0f14772ea7e6f4743fa6bb74fd9a1586323=
565a1b30115fc5a680f25b9924b842b149eba14cc032c89a3260a38aab0fed48397af8457=
527200e57b9553c357131ea3df867f8d3fdcadd3b6dd24d74445f3e6203a22ab7ac559e1d=
45f7e70989f04d8b8981829af7dbf84eaa02585829b2032f47dd3a4967741b9d526bc019b=
f6bf094f59f1aad6b1b05990d3ca325b89bdcf3e543a93a57dec7bc03652e049fc3467188=
f4ee804ef5e2f886b1d2a2ace58bd51f797ffd020a3a58a747a2ab9f17a79fadc6cf05008=
9c7d0f553000b90e779d705b88ea68f7c581002be981cddb3ce6271820d3f67f4410abb0a=
f0ff4398798c55c847d24d64e2e5cb787c7e2090c305ca72cc2bc7b4cd27ab7175fb28744=
db173ae335865a2bab2458680d637e816314fc8acf63e8f1f8f6d29342326606acb899524=
5490d75793030271d1a2cdf8368a5180aa78b0f2a31976716d4a18f81ee0eae8ae9bdde46=
7e20d366d5ad3fa771a5eb1e8ed9898c87f40d4916c071526d89d712b5101334f982c76cd=
ebeedfc8d43f2ef1cd47ab67f4c47dc16a40ca8b088561209c8b02783baeac6f8810a4d62=
67e1a0f35e7261420e1b2b26ebead5449ba9ea65917c02129187f48eee7fc2b4521016d22=
f6bcdd007d81c081a1558c97e2eb216d06aefcc20b835b9fb9b199620e392a1e101926290=
5ad7e231bd2ef161315f135df0c24b95dcba6777874f89bf9c95a1e653f48f2ce25895c74=
8f40b004c462634b340e3de1e7e1b5f359b696abac0b281ffbd34b16e2a2dc048710dd0d8=
f0fe9fde8a6f2985909f9f7d74f32e712b83617c0436d6647cf54e59985c24f947ce4996f=
a85344d6563e3c606b085e5930f195489bb7bcae8fd07d2955934a6f10ae93198b2318658=
cd41d5101c7255da3f4eb3493f222d785ba34275ac11ab45511dc9e65bc31faeff3557dc2=
f200585eea7ac6704a8922f0cec673a7795036c664d4046b0c08ea3ba2bb4936d6cb55968=
151656a248271a8fbf11643097f6a68e23d930f48c197402c72354a2cb28f573d729fbb38=
66303cf77cad97dd0b489108e5cd1d8b570a4c426a8c5ae3049364e718d793d58b00788b0=
24d94711af7cb6459bee78f9579c5a004143d07800ac5ec2b1c2a613ded78c82fcb5e6e25=
523c878130fd91e333bf55aa66f992eb4df7032a07a3b0e2989da173842c1879ba601d18f=
c8cbbe9e4675f17ea63f88e7b5b31b1c11b19c93fffca8bedd4193cb7bfd2ac488d223792=
e677e7af781d3f41aea0ce2286b5573c8bed3fe9da96ec7aed7a4b7e389563f37a53b26ab=
1ac41c42d060480b7db2d9f4407ec735dacdaaff33bcee1a97d81f67cc3c93e8d052a3924=
5ffd9c84ace0995743b8e122d447f7a697b4a1fd969b4f5d96dbbaeb82387138b08ea588d=
4c5830180f6fd3dd08dd32ce340ebdb6ae5d6b84c9b52d415f71b7e792efaedfe3e0a780a=
efbed51482aaec7ba73901ab54d4ee5f882e93b573881ac22136be641056fb66f690ac1ff=
3a277cb9a27df35e5998c3179c82e6da84f704da1a759033f6157db279a7c0ca8dd83d710=
4fc1017c890f15166b1f26e1d4d9c55d61ef5ae17341dcef589b68bcf1dea765bffefc00a=
af4f32342847fc648dfdecd7f93a304d96eeafff78d85ad4f2bab8874141f0e613682c48e=
1cc2a8a5b0053b8fec9edc32475fed372c0140bea8c776acd3fcb284dd8167577cbc050aa=
089836a99652c10c7faec1ed1d8743ae8b77889bf9d126d6e7594b9a94731ebeb91cc4893=
206d210991be357c05378e82144ef361baceb47657feb8f03e28ecbea6a9b036648cd5a57=
fc042cb254cbe80527e9a06f5e97aac33542694a069192c3ee0115d831cfdd0e076cb3712=
20dc6b5855307f80fb51826d9b41bd5eaf4adfea6b56604565229009de10a63ab63a57561=
abe33b10d8ba3c167827e81a00cc49baea3254d01f4151263aadd391dad38338444f085d4=
a71445f02c5f1c7282dd09c38f213ce9797223be82b1a9d102cf610ecb1176d6c42f1950f=
88978d3a45356b32b25f7b7ab03a907f1a6957c08c2c902c84ad68344925f4a512fbb7c9b=
ef5a8891c69c3bb24f696e3b70b974c4dd4dd2118cd0f81288aeaa653c111a23dab6dafe3=
e17da9d5bad5f6f4f95c11e66361004ddf713e774bcfb70e1beca6494879506cf8f5912bc=
62ca5c65caed1c288c88532eb75b09996ebe4e48f65e701d7eee0247e78f41bd651476fad=
b9710b0e1e0dea7f8d27994ab9b624e6f84588cf9fdde044403fdd1786bd9114a32db2d1f=
d546c0451c1e6e2c5cb2259d5534b4855007bd72bb8595927f3d96012b8d876cd5b04e7a2=
2ef539d40f66050c2376f5a6a43a800dbcf0d0ad69c4c52bee94d7831a2c407d676aaebec=
ecf05af84250710968ce50d82d9f57b3cd053155567b63a5742ca180c7c11915261788695=
6ce202af1222c49c52181b7e5b9ecac5b42551a878ec74630a573abf3ba360154a3abcc66=
b590aa66fd87a537ebe96145ce622bee1d4c781020203c7b31f83a7124a1c5fca3ba2a5b4=
762f42771217c722c0a3468038214369423b947196bd58ea5acf621b95bc82204868d8f26=
bd3047289607aea05955fdb7521fbebd2bc783a27c2973fe1519dc0b53e0176785fd066dd=
bec5e98d2f97954d0315b183937f082d7d00caa4d1bc19e2f6f27d7725bd686322057fda6=
ec68b9eab913de001a58cc687d32336b78f2cfca687709812c2d90c58ae9c3a4515e3da94=
b93fbfc9d9ed4b8cf91e82a29667f89fb9227a69450986a2f3c19dcdc7cee07d9324ea53d=
1af12a06cbc12e9595d925c4f2603535a28a52641a76f7d35d0b11ae16012c6e8a6406e43=
bc47840b95463f65c9c8c39d1b5b276dedd8c55d97f4e7f2fb0be8eb49c818e51e6d5f87b=
ba2711e311ae01fd3a266a10d326ffbcba91b324e3eebd6ccdb49cfa053e34639f025e290=
18d30b2db77bd83f1b16e50d1aeebc9a141e00bfe029445c57af6b0ab16c16f537f4a2dba=
b281076b12fd8e9906c3c2d531ea928e02e1bbeef1e5b5db1f2c972605555f7d0a2bfec30=
656b4305c7db71e36e379547535673f8de8a9cdcd60b3ef7510ca39ac46252b06e50d9d6a=
2cb6e78ddab9268da38f2ec6a123d7a8835cde2ed8cbbda9ff90d704499893db3c21307cd=
a49d6e972ecaed461720f6e4470337a33c586c6da5545e41de932191c2442226da5fcf495=
0d1b52c7e168e1aefb69bf16bc0396a9a9439aefeba44050e6b695ce8942be1a452fb5baf=
530331b856106140a1741f6bbf3679cba95cf4e296b7b05d01d64178c3d1ceb203e72766d=
118f4a00c1e73b2bc24c6fd9d74bf5196003e1d45da8dd73149b176bd876e6d6b20287af6=
e2af1b2923e8b17d0e891f3678ef06ecf7faf24c1956e44f08d2e35e452a4169cc26be43d=
022879d894674502fc94fb0b742be4598b285a3abdeca4754e7e0b0f5c23d6c0958b9ffce=
c8b1ddfb6f9b3476220453a45e3f0607e81933ce494479412eb3c62283ff5f408039b9616=
1e5aa38eb5a9ddf2c5e7c7020314938c53617cf6406f939a3d1a5cc88122704dd2ff2d04f=
90ec0bdd6edb39b9126a56f4ffd6a87dd59b26db0048bb475aaf7065eea75d22791d36c01=
6e759fd3778c4be567f472fb34210b31a9fc0965692a9e2006341e0db8e989fc76df59c1a=
e5ea11e8f23827f8e84117af732ed8978997f19ae06a522ffa40305c33dcda792a59ad597=
86d487baff697497b957a6969541b62331fc7bd7888ab9453fe2cba3a2698b2b943990824=
ac15228d5a3b21124a2be71cb39bd71237266c87c37be68d332af6f73c9f71d95c8dcf909=
25878de5555a7c0da4a1e950b74536b5be5bdf9d29e4b365c9698b5837d47cf7244157c52=
676234a76ceda2d47de1b1520a02aa1ec759b64ce8c79af33a6f64444b9214b7705a8d6b1=
5d80fd7b440ae8bc7b719881170bac74292514a6cb7457df5278b47f29768a0e160c1f539=
187ac0e1154d8cfd21c947462fe951c04944ab1c103f46794bb50665ea909837d41174079=
98e35e64a7cd0f73529c07722f90fc7e04d1cc461a83b88f9be14bf3e2d9e1e8f238af3c1=
d45af4f659a93eeaa048eb35e2774241755a119b770ba5ea5cbd4dc079caa4bce6427b86e=
3e25454f148d0b371ea739a890acc6ce9f36e2919b4c11c3a06ea2805806657fbd924b3d1=
372501f6bb4070d18513c0bb8ad33b470f0fc398f6c05c8a6fe563427dbce161f47b2c36d=
8e98b33315ed2b21c67cc50a255925a96a3d13e5b65b0cdc56c1b7b07c66a22635e8810f8=
fb2e605d88ee1b330e82f70c9821504fa881d15881b41f774da5a2891345f6eccb9646bf7=
972bf2d9738e5d48c7bd89764a78345f498590b0a9a76af72a75aa4a1e40f05b04cc964ec=
6558f47c810b291d6f244469eda099962eae5b65d91abc61e341073f426cb2122247421c9=
b1a261124108924f7e974e8cdff9969ab1f06c4122d29b026349d80640aa0ddc188a50d63=
bc2a2635aaf303e07a6bdb080ec72dfa2f73b9b25a8d63c6ad93c365c2a0f3b4adf192e15=
7f24c4aa43ba1da9257b060982c356890abb04f6b9404b8de19f0c3c742d45ec0c1686917=
b458f36c522d6dfbee1210ef9eaea542cf8b92dedc49838ed74ef5169bc367ec868dc084d=
a2277f7e421f3eee6ee439d5d5a55b4a06ad48aee1d298063abdcd84ca4690b9a6e3d8d55=
bbfd1ff535477840c449a28d758129c3f748e4f333139b5d36b1233575078c0127b5ea631=
da4b94e0928e4337c3ce7397524911507011cc95ef9ec20f12d36e89518696850bfb6cfdc=
20905d5ec33dadbe74c061e9ad6a49d9754bfb86d32959919fc8ca8a365afcbb22e26526b=
d73fd72f4c150bdcfba73ec92d7ee8fadfbe40e37b9b29c822650a647d9060c47ca96a6b2=
c2127da0e371f57ba15baaa1c96d3fc07f76717fc5a7fd8625975e1a19c716d5a17bd1a2b=
6add58a12ffb577cf6d3d310c1e81e233bc614f45e7d9114040430359c052209fb66a149d=
9b392376fcf058a9e7a7fd7ec6ae8340fb222e511ca8033b03e8e50eedce2bead871165f5=
e295438803744d3a8a93ec8e10da0bb4a472de18b116c1051cc078af160379d918047eb3a=
959dba3f3e751c88f632dce82c92bdb0cd300807c61a21ef61dc9a602780579f97fe0db4e=
aaf4984a2d275c89ca49fb71df338ca05d30d6bf39572b7107d92679adf71f6c5b20ca0a3=
1a291de1eaaac364f0e5cd9415c7944935c3344a3c59bdb606b426f4f7bbf55db3f265c1b=
ed14fd14aed9c39b1044ae94d5ef9d90364e434b4f2f00d1f91b27fbb3aee651935683471=
093f531c8cf9a97b33c9ed5b7331dfdc43947f6e2f20536191f5a2e824000f0c4e1ec4600=
663e1f8950a029d90bd870fb4632c2cb5915fe72519de584af6224c39209140eb016bba5a=
968538aeeb43448903a6ac35eb9c386933acfa1590f95ef93c9c0580f64ef99edd5b26bc9=
030643babf49ad3c474ef0eec86a6d3aea27214380fb34f4f00ee270eec0b89abf46a9d52=
6d8aca9cb3eccaa799b7f4037c704ab21de639a7c2302831b5bca9c4fe8643fd13b86082e=
d1d6969f00570d57b362cb8b7e8f781b82f2b50c3dc5db8781e4eeee6885933c1206f3858=
db4150bed2c01320d128bd12849c878e3b1721ff980ab9bcda0e530e16fb1d6ea9754e81a=
f0ecc75490b28959914cc8e2dd3cf9e8f7dc4624581b3a72d78b6bebebc20f18a50302747=
4cbece5f55a02d5c9ab092356ce466ad6612bbac9f3bbcc4a01e6e7a71b9eecd885043294=
454ea4dcecc65f7f436b6c6d8392b7581717c36a4809e09f26e9db9abfb535ba5a664a918=
a7732d0b6a7be1fd6a079f39d1e0b4e70eb0d01a95b092361ce7fbdc0f45308e7bac2148c=
2bb40ae716d620acf02170f6280f3486b7e48533bb3134ae40bc2382b584028e3e0e6d737=
588d7a6f5f9737cb311ee800049ea9c0ba8aaee9b1eb30167325756b2dc471edc4951747f=
3818d1af8702604f91867bb106b9096c8b07ae94ecc87bab27a65db8f984d393c1de23525=
2852109cba3601f880de1b8b0101001e0395c47e81f9ae42ceb6f6b738f138b0744d01ea2=
9d9dae96a51c2e3186c7227b5b14537d33c9a62b0b5175efe9c7bfb7fc1a6a56af85f500a=
a6684f21a8e4d3516a7ec9807ff81b8e17a96e2fa6033d6f37475333b081b46f3f7eccef6=
8846cd19e71ccbcd9ff5cf541488e98b917b3c13bdfca7245df529c993c6f81727e1e6543=
36c2763395f41d05ba579026b0c7d551da03a6521a2bc7f88ff7b10242b70a06ef17b433e=
f741c46e7de1163317a417cb4f971dd2620f76ad5960c27782f7ccadcaad8532ebfb96735=
908589e298976d751e7d1382cbeb93f3537d2d818595d2939fb3a52ba7eb033a4ebcb3e76=
9897ea5a0fc22380bb7ca02e5d5e2e0bb692575c8fd3d131f51eace110be68c464acc5dbd=
6603b1dd6e1f8ad304f16956ff63338a336dab0b58a2aa9e34691b44f7c8e21650905f2ef=
f48335276209c0406397e70b3ce06765b180511b4703a83d22defc7c4a91591205aa5d741=
ef4482bb33998cd4e757af3d15ee2d79105a1ebd01c5b9097ba85ea2957e9519594b4d10a=
5927d3094f18be1d856011f9fd0e8801f22044ad676bf4861f008265c8cb8cc0c0890ebdf=
7d8fbd3964b6ac31905cb978a4a8b3af874b19c2bb90e6c8d65e85bbe896e6dbe4b56ac94=
b8a7d1ad8584a128b6ee0e54b1a9bc8ac661f013613d16a28c5ccee80e4c6aa960a52dfbe=
84cdf150ebe2ff583ee2cf0efc86e80c37827d6f9c78337ac58627299a2da113ffa3793a0=
472cdf79dce4baca9511259b1bba5fa222f53c846e4b6030c602fe9e97d046c4bf1fe8e06=
9bef6b5b191db7d7dca28b6c8c3c1fe77c38745134ab45c46616d638a6b5c6874476a3161=
2c49e3e2996ac61c172fbd4482711dec87aafc8dfbd1dc366afd0c200fff90699fb380fcf=
f23998f5a3de6903c9f47d319554cb1ec74b0d658fe50c225a1777a9f46332530ee8a2744=
2f204d6e1d01fbe2999fbe0135f4c516d93dcbf2c06541f20ae61eb2b356182a30c7c9c62=
41445a0e7ca79a55866aecc63e814ea738dcfcfb294d9b80d4f19286e9582046103c8cdfc=
91b65bb6dcf27d71a48ed46a2570ca596c88bbd09051fd2637485daad205fb8625da44766=
d1799e6462206bbd35c195d090ca80240267917db0f4f3dc223343aaf11f30c46735b21fa=
3dad8097039e1a58fbc10941ff12d966909d63e281ef08741568243778ec437d7b17f1e5a=
342566aef9dbdfc365c9c518720287aefcaf0ae8fa87541265734069f3d30a16d031d1af2=
c1347512101ab2964bb9e2d6fa5302fc8b2189a3944d2dda1471c7a9dcd995b048d37fedb=
6bf64024377bdbe7e488456032c6bd5b99d4225f7cb9120ef2bc452f79a03423a91cc0e2a=
d497f64693f6b73a0e44edd2af1bf120af76a9d955b9d4d3cd2b6ffee42205994a8487cdd=
e3a96cbd852fd8193621ca204e4689098895277e5c59ae9556c772520d4e989cf25031206=
5bcb4971d7d37316b93e93616e8099cee5dbd5e53cf3b7bf63a40a9fe1aa345ff04f7b2bc=
0979a159fb2379577c5b37f68155b696e65e70e26c5fe86673711cfc871f495c893818c2c=
5002b2819bec61ecbbb0989cdfedb193c0b58251a2823e042915d6793641ebbe8b15650c6=
9ef4a973762dba251ff6df6a46ca1b5ea3986f494fbf084718d016a74b278d1cd2541ea4c=
6593c4f0625a85125e381ff61dac5eeb491f33ab6c75d9ea08622b1dc1c949820477e2c49=
615b819caecb8c024d3d06d3f46b1db0eba3d37aac790f6dbd49d9f2bb840589168828ffe=
2606a54984a4846e4ea748a711c524cd01036b845500962da1e1d13aa4ffc60230578a886=
baadb7327215f378a61c7f370eed8b6691e86fb113b9ef7885b59",
0x2000, &(0x7f00000011c0)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, &(0x7f0000000b40)=3D{0x90, 0x0, 0x200, {0x5, 0x1, 0x10001, 0x2=
, 0x20, 0x4, {0x0, 0x6e, 0x742e, 0x2, 0x7, 0x63d235b8, 0x400002, 0xa, 0x6=
, 0x6000, 0x9, 0x0, r4, 0x800, 0x2}}}, 0x0, 0x0, 0x0, 0x0, 0x0}) (async)
quotactl$Q_GETQUOTA(0xffffffff80000701, &(0x7f0000000040)=3D@filename=3D'=
=2E/file0/file0\x00', r3, 0x0) (async)
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd) (async)
r5 =3D syz_open_dev$ndb(&(0x7f0000000040), 0x0, 0x0)
ioctl$IOC_PR_RESERVE(r5, 0x401070c9, &(0x7f00000000c0)=3D{0x4, 0x2, 0x1})=


8m8.2328528s ago: executing program 6 (id=3D10070):
socket$nl_sock_diag(0x10, 0x3, 0x4)
socketpair$unix(0x1, 0x1, 0x0, &(0x7f0000000180)=3D{0xffffffffffffffff, <=
r0=3D>0xffffffffffffffff})
socket$nl_netfilter(0x10, 0x3, 0xc) (async)
r1 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
sendmsg$IPSET_CMD_CREATE(r1, &(0x7f0000000580)=3D{0x0, 0x0, &(0x7f0000000=
540)=3D{&(0x7f00000001c0)=3DANY=3D[@ANYBLOB=3D"58000000020601010000000000=
0000000300000605f104000a00000005000400fe41a5"], 0x58}, 0x1, 0x0, 0x0, 0xc=
0}, 0x48004) (async)
sendmsg$IPSET_CMD_CREATE(r1, &(0x7f0000000580)=3D{0x0, 0x0, &(0x7f0000000=
540)=3D{&(0x7f00000001c0)=3DANY=3D[@ANYBLOB=3D"58000000020601010000000000=
0000000300000605f104000a00000005000400fe41a5"], 0x58}, 0x1, 0x0, 0x0, 0xc=
0}, 0x48004)
accept(r0, 0x0, 0x0)
syz_genetlink_get_family_id$ipvs(0x0, 0xffffffffffffffff)
openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)=
 (async)
openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)=

ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
0080)=3D{0x1, 0x1, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
r2 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r2, &(0x7f0000000280)=3D{0x0, 0x0, &(0x7f0000000240)=3D{=
&(0x7f00000000c0)=3D@newneigh=3D{0x30, 0x1c, 0x103, 0x70bd29, 0x25dfdbfc,=
 {0x1c, 0x0, 0x0, 0x0, 0x1, 0x0, 0x2}, [@NDA_DST_MAC=3D{0xa}, @NDA_FLAGS_=
EXT=3D{0x8, 0xf, 0x1}]}, 0x30}, 0x1, 0x0, 0x0, 0x4000}, 0x800)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0x9, 0x8, 0xe, 0x0, =
0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0, 0x2}, 0x2, 0x7, 0x2, 0x5, 0xffffffff, 0x9, 0x3, 0x0, 0=
x0, 0x0, 0x61}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
perf_event_open(&(0x7f00000003c0)=3D{0x6, 0x80, 0xff, 0xd, 0x3, 0x0, 0x0,=
 0xe0b4, 0x100, 0x0, 0x0, 0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0x0, 0x7fffff=
ff, 0x1, @perf_config_ext=3D{0xf800000000000000, 0x7}, 0x89, 0x4, 0x3, 0x=
0, 0x5, 0xffffffff, 0x8, 0x0, 0x42405f51, 0x0, 0x30077dd4}, 0x0, 0x0, 0xf=
fffffffffffffff, 0x3)
r3 =3D openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x=
2, 0x0)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r3, 0xeb08=
0000) (async)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r3, 0xeb08=
0000)
r4 =3D bpf$BPF_BTF_LOAD(0x12, &(0x7f0000000000)=3D{&(0x7f0000000400)=3D{{=
0xeb9f, 0x1, 0x0, 0x18, 0x0, 0xc, 0xc, 0x5, [@enum=3D{0x3}]}, {0x0, [0x61=
, 0x5f, 0x2e]}}, 0x0, 0x29, 0x0, 0x1, 0x618}, 0x28)
bpf$BPF_PROG_RAW_TRACEPOINT_LOAD(0x5, &(0x7f00000002c0)=3D{0x18, 0xf, &(0=
x7f0000000080)=3D@ringbuf=3D{{0x18, 0x0, 0x0, 0x0, 0x400, 0x0, 0x0, 0x0, =
0x8}, {{0x18, 0x1, 0x1, 0x0, r4}}, {}, [], {{}, {}, {0x85, 0x0, 0x0, 0x85=
}}}, &(0x7f0000000440)=3D'syzkaller\x00', 0x9, 0x0, 0x0, 0x40f00, 0x8, '\=
x00', 0x0, 0x0, r4, 0x8, 0x0, 0x0, 0x10, &(0x7f0000000200)=3D{0x0, 0x2, 0=
x1, 0x9}, 0x1, 0x0, 0x0, 0xfffffecc, 0x0, 0x0, 0x10, 0x7}, 0x94)
socketpair$unix(0x1, 0x2, 0x0, &(0x7f0000001300)=3D{<r5=3D>0xffffffffffff=
ffff})
syz_open_dev$sg(&(0x7f0000000140), 0x1, 0x40742) (async)
r6 =3D syz_open_dev$sg(&(0x7f0000000140), 0x1, 0x40742)
ioctl$SCSI_IOCTL_DOORUNLOCK(r6, 0x5381) (async)
ioctl$SCSI_IOCTL_DOORUNLOCK(r6, 0x5381)
ioctl$sock_SIOCETHTOOL(r5, 0x8946, 0x0) (async)
ioctl$sock_SIOCETHTOOL(r5, 0x8946, 0x0)

8m7.87737117s ago: executing program 6 (id=3D10077):
r0 =3D userfaultfd(0x1)
mkdirat(0xffffffffffffff9c, &(0x7f0000002000)=3D'./file0\x00', 0x0)
mkdirat(0xffffffffffffff9c, &(0x7f0000000080)=3D'./file1\x00', 0x1c0)
mount$overlay(0x0, &(0x7f0000000000)=3D'./file1\x00', &(0x7f0000000300), =
0x8040, &(0x7f0000000bc0)=3D{[{@upperdir=3D{'upperdir', 0x3d, './file0'}}=
, {@lowerdir=3D{'lowerdir', 0x3d, './cgroup'}}, {@workdir=3D{'workdir', 0=
x3d, './file1'}}]})
chdir(&(0x7f0000000180)=3D'./file1\x00')
mkdirat(0xffffffffffffff9c, &(0x7f0000000080)=3D'./file1\x00', 0x1c0)
mknodat(0xffffffffffffff9c, &(0x7f00000000c0)=3D'./file1/file2\x00', 0x81=
c0, 0x40000001)
r1 =3D openat$dir(0xffffffffffffff9c, &(0x7f0000000100)=3D'./file0/file2\=
x00', 0x400, 0x41)
linkat(r1, &(0x7f0000000380)=3D'./file1/file2\x00', 0xffffffffffffff9c, &=
(0x7f00000003c0)=3D'./file0/file2\x00', 0x0)
openat$iommufd(0xffffffffffffff9c, &(0x7f0000000040), 0x1996519de836e3c8,=
 0x0)
madvise(&(0x7f0000ffd000/0x2000)=3Dnil, 0x2000, 0xc)
madvise(&(0x7f0000ffc000/0x4000)=3Dnil, 0x4000, 0xd)
unlinkat(0xffffffffffffff9c, &(0x7f0000000140)=3D'./file0/file2\x00', 0x0=
)
r2 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
unlinkat(r1, &(0x7f00000001c0)=3D'./file1\x00', 0x0)
sendmsg$IPSET_CMD_CREATE(r2, &(0x7f0000000340)=3D{0x0, 0x0, &(0x7f0000000=
300)=3D{&(0x7f0000000080)=3D{0x58, 0x2, 0x6, 0x301, 0x0, 0x0, {0x7, 0x0, =
0xa}, [@IPSET_ATTR_PROTOCOL=3D{0x5}, @IPSET_ATTR_FAMILY=3D{0x5, 0x5, 0x2}=
, @IPSET_ATTR_SETNAME=3D{0x9, 0x2, 'syz0\x00'}, @IPSET_ATTR_REVISION=3D{0=
x5}, @IPSET_ATTR_TYPENAME=3D{0x11, 0x3, 'hash:ip,port\x00'}, @IPSET_ATTR_=
DATA=3D{0xc, 0x7, 0x0, 0x1, [@IPSET_ATTR_NETMASK=3D{0x5, 0x14, 0x1}]}]}, =
0x58}, 0x1, 0x0, 0x0, 0x2000680c}, 0x20008000)
ioctl$UFFDIO_API(r0, 0xc018aa3f, &(0x7f0000000240)=3D{0xaa, 0x6a8})
ioctl$UFFDIO_MOVE(r0, 0xc028aa05, &(0x7f0000000200)=3D{&(0x7f0000ffe000/0=
x2000)=3Dnil, &(0x7f0000ffc000/0x4000)=3Dnil, 0x2000, 0x1})
ioctl$UFFDIO_REGISTER(r0, 0xc020aa00, &(0x7f0000000040)=3D{{&(0x7f0000ffc=
000/0x4000)=3Dnil, 0x4000}, 0x1})
ioctl$UFFDIO_POISON(r0, 0xc020aa08, &(0x7f0000000080)=3D{{&(0x7f0000ffd00=
0/0x3000)=3Dnil, 0x3000}, 0x1})
syz_clone(0x40000000, 0x0, 0x0, 0x0, 0x0, 0x0)

8m7.75044135s ago: executing program 6 (id=3D10078):
unshare(0x40000200)
r0 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r0, &(0x7f0000000180)=3D{0x0, 0x0, &(0x7f0000000140)=3D{=
&(0x7f0000000340)=3DANY=3D[@ANYBLOB=3D"240000001800010227bd70200900df2502=
0000040003fd06000e000008000f00ff7f"], 0x24}, 0x1, 0x0, 0x0, 0x4008840}, 0=
x0)
mkdirat(0xffffffffffffff9c, &(0x7f0000002000)=3D'./file0\x00', 0x0)
r1 =3D openat$dir(0xffffffffffffff9c, &(0x7f0000002180)=3D'./file0\x00', =
0x0, 0x0)
ioctl$FIDEDUPERANGE(r1, 0xc0189436, &(0x7f0000000500)=3D{0x9, 0x6})
setsockopt$IP_VS_SO_SET_STOPDAEMON(0xffffffffffffffff, 0x0, 0x48c, &(0x7f=
0000000000)=3D{0x2, 'vlan0\x00', 0x1}, 0x18)
r2 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r2, &(0x7f00000015c0)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000400)=3D@ipv4_newrule=3D{0x2c, 0x20, 0xb263fe1b0482adf, 0x70b=
d28, 0x25dfdbfb, {0x2, 0x20, 0x20, 0x0, 0x7, 0x0, 0x0, 0x0, 0x30343aa98c6=
4f1eb}, [@FRA_SRC=3D{0x8, 0x2, @empty}, @FRA_DST=3D{0x8, 0x1, @dev=3D{0xa=
c, 0x14, 0x14, 0x1c}}]}, 0x2c}, 0x1, 0x0, 0x0, 0x488d1}, 0x240000c4)
r3 =3D socket$nl_generic(0x10, 0x3, 0x10)
syz_genetlink_get_family_id$ethtool(&(0x7f0000000040), r3)
unshare(0x40000200) (async)
socket$nl_route(0x10, 0x3, 0x0) (async)
sendmsg$nl_route(r0, &(0x7f0000000180)=3D{0x0, 0x0, &(0x7f0000000140)=3D{=
&(0x7f0000000340)=3DANY=3D[@ANYBLOB=3D"240000001800010227bd70200900df2502=
0000040003fd06000e000008000f00ff7f"], 0x24}, 0x1, 0x0, 0x0, 0x4008840}, 0=
x0) (async)
mkdirat(0xffffffffffffff9c, &(0x7f0000002000)=3D'./file0\x00', 0x0) (asyn=
c)
openat$dir(0xffffffffffffff9c, &(0x7f0000002180)=3D'./file0\x00', 0x0, 0x=
0) (async)
ioctl$FIDEDUPERANGE(r1, 0xc0189436, &(0x7f0000000500)=3D{0x9, 0x6}) (asyn=
c)
setsockopt$IP_VS_SO_SET_STOPDAEMON(0xffffffffffffffff, 0x0, 0x48c, &(0x7f=
0000000000)=3D{0x2, 'vlan0\x00', 0x1}, 0x18) (async)
socket$nl_route(0x10, 0x3, 0x0) (async)
sendmsg$nl_route(r2, &(0x7f00000015c0)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000400)=3D@ipv4_newrule=3D{0x2c, 0x20, 0xb263fe1b0482adf, 0x70b=
d28, 0x25dfdbfb, {0x2, 0x20, 0x20, 0x0, 0x7, 0x0, 0x0, 0x0, 0x30343aa98c6=
4f1eb}, [@FRA_SRC=3D{0x8, 0x2, @empty}, @FRA_DST=3D{0x8, 0x1, @dev=3D{0xa=
c, 0x14, 0x14, 0x1c}}]}, 0x2c}, 0x1, 0x0, 0x0, 0x488d1}, 0x240000c4) (asy=
nc)
socket$nl_generic(0x10, 0x3, 0x10) (async)
syz_genetlink_get_family_id$ethtool(&(0x7f0000000040), r3) (async)

8m7.55426346s ago: executing program 6 (id=3D10079):
r0 =3D syz_open_procfs(0x0, &(0x7f0000004180)=3D'net/dev\x00')
read$FUSE(r0, &(0x7f0000000100)=3D{0x2020}, 0x2020)
r1 =3D bpf$MAP_CREATE_CONST_STR(0x0, &(0x7f0000000540)=3D{0x2, 0x4, 0x8, =
0x1, 0x80, 0x0, 0x0, '\x00', 0x0, 0x0}, 0x50)
bpf$PROG_LOAD(0x5, &(0x7f0000000000)=3D{0x5, 0x10, &(0x7f0000000780)=3DAN=
Y=3D[@ANYBLOB=3D"18000000000000000000000000000000b7080000000000007ba12000=
00000000b7080000341200007b8af0ff00000000bfa100000000000007010000f8ffffffb=
fa400000000000007040000f0ffffffb70200000800000018230000", @ANYRES32=3Dr1,=
 @ANYBLOB=3D"0000000000000000b70500000800000085000000a500000095"], &(0x7f=
0000000500)=3D'GPL\x00', 0x3, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @fallback=3D=
0x26, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0=
x94)
syz_open_procfs(0x0, &(0x7f0000004180)=3D'net/dev\x00') (async)
read$FUSE(r0, &(0x7f0000000100)=3D{0x2020}, 0x2020) (async)
bpf$MAP_CREATE_CONST_STR(0x0, &(0x7f0000000540)=3D{0x2, 0x4, 0x8, 0x1, 0x=
80, 0x0, 0x0, '\x00', 0x0, 0x0}, 0x50) (async)
bpf$PROG_LOAD(0x5, &(0x7f0000000000)=3D{0x5, 0x10, &(0x7f0000000780)=3DAN=
Y=3D[@ANYBLOB=3D"18000000000000000000000000000000b7080000000000007ba12000=
00000000b7080000341200007b8af0ff00000000bfa100000000000007010000f8ffffffb=
fa400000000000007040000f0ffffffb70200000800000018230000", @ANYRES32=3Dr1,=
 @ANYBLOB=3D"0000000000000000b70500000800000085000000a500000095"], &(0x7f=
0000000500)=3D'GPL\x00', 0x3, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @fallback=3D=
0x26, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0=
x94) (async)

8m7.55245534s ago: executing program 55 (id=3D10079):
r0 =3D syz_open_procfs(0x0, &(0x7f0000004180)=3D'net/dev\x00')
read$FUSE(r0, &(0x7f0000000100)=3D{0x2020}, 0x2020)
r1 =3D bpf$MAP_CREATE_CONST_STR(0x0, &(0x7f0000000540)=3D{0x2, 0x4, 0x8, =
0x1, 0x80, 0x0, 0x0, '\x00', 0x0, 0x0}, 0x50)
bpf$PROG_LOAD(0x5, &(0x7f0000000000)=3D{0x5, 0x10, &(0x7f0000000780)=3DAN=
Y=3D[@ANYBLOB=3D"18000000000000000000000000000000b7080000000000007ba12000=
00000000b7080000341200007b8af0ff00000000bfa100000000000007010000f8ffffffb=
fa400000000000007040000f0ffffffb70200000800000018230000", @ANYRES32=3Dr1,=
 @ANYBLOB=3D"0000000000000000b70500000800000085000000a500000095"], &(0x7f=
0000000500)=3D'GPL\x00', 0x3, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @fallback=3D=
0x26, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0=
x94)
syz_open_procfs(0x0, &(0x7f0000004180)=3D'net/dev\x00') (async)
read$FUSE(r0, &(0x7f0000000100)=3D{0x2020}, 0x2020) (async)
bpf$MAP_CREATE_CONST_STR(0x0, &(0x7f0000000540)=3D{0x2, 0x4, 0x8, 0x1, 0x=
80, 0x0, 0x0, '\x00', 0x0, 0x0}, 0x50) (async)
bpf$PROG_LOAD(0x5, &(0x7f0000000000)=3D{0x5, 0x10, &(0x7f0000000780)=3DAN=
Y=3D[@ANYBLOB=3D"18000000000000000000000000000000b7080000000000007ba12000=
00000000b7080000341200007b8af0ff00000000bfa100000000000007010000f8ffffffb=
fa400000000000007040000f0ffffffb70200000800000018230000", @ANYRES32=3Dr1,=
 @ANYBLOB=3D"0000000000000000b70500000800000085000000a500000095"], &(0x7f=
0000000500)=3D'GPL\x00', 0x3, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @fallback=3D=
0x26, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0=
x94) (async)

5m19.62629469s ago: executing program 9 (id=3D11020):
r0 =3D syz_open_procfs$userns(0x0, &(0x7f00000003c0))
r1 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
sendmsg$OSF_MSG_ADD(r1, &(0x7f0000001140)=3D{0x0, 0x0, &(0x7f0000001100)=3D=
{&(0x7f0000000880)=3DANY=3D[@ANYBLOB=3D"bc0400000005010300000000000000000=
500000a5402010001000000060000000a0bdbe606001d0073797a30000000000000000000=
0000000000000000000000000000000000000092b8db4092e46690a7e60a9231db3cbdbba=
37919b6e7a09c1de5f2a8a235d2448bd472aeae4c0a0c551b34462d11b12ced980c7f2909=
c1ef6f58ff394ff51def04000200010000000500000000000200020000000300000008000=
600020040000100000005000010020000000000010006003f8f0200000003000000660509=
0001000000020000001000e3ed0300000008000000ff00810000000000040000000001080=
001000000070000000100030000000000020000000300bc0000000000ffffff7f10000600=
0100000005000000800087e00100000005000000040000000000000009000000ff0fff000=
3000000020000000100593301000000250000000600050002000000090000000100080003=
00000002000000d000050004000000e10000000700082003000000d70d00000500d78e010=
0000008000000070009000300000002000000060000000000000008000000060008000300=
0000030000009ba70300030000007c00002894e5908f01000000020000003c09060001000=
000ffff000001040101030000000400000005000100030000000900000067000900000000=
000300000007000300030000007f00000000000e00000000000b00000001007f0f0300000=
0040000000000070002000000a31ce23c030009000000000000e600000400030001000000=
080000000400bdec0000000007000000f9ff0700010000000700000001000100010000000=
500000004000600000000002300000054020100000000000700000003f50a000300070073=
797a300000000000000000000000000000000000004000000000000000000017e962db7e1=
4b4bf72ac0e9c572c9aed01dc8bb3e69131539d93729caae4acad0a1aab89c9dfb1277550=
604d2fdbb020701b83593c93e2272c07314800c5c0670180030001000000ffffffffac75c=
70f0000000080000000ff010200010000000800000000080500010000000008000056a808=
00010000000e000000050069000100000009000000f1ff020000000000010000000600020=
00000000003000000ff0780000300000006000000ff07090002000000a157000006000300=
01000000050000003c000100020000002efcaf260400e8000000000003000000ab0900010=
30000000f00000001f80500030000000800000009000200010000000800000009005df300=
00000000100000bd830a0000000000790200000200ff0103000000010000000600c000030=
00000070000000004ff7f020000000800000004000400030000002000000052e904000200=
0000ff0f00009d0009000200000009000000060009000000000000000000140c010003000=
0007f0000000900060003000000fe0c000009006f09010000000000008000008000030000=
006ff9ffffa7ea00080000000008000000080000020300000001000000060000000200000=
003000000640d0700000000007af9ffff07004000020000000800000079f4050001000000=
0000000010000b000200000000020000ff7f090000000000300400000000ff0102000000f=
fffff7f000006000200000009000000feff010002000000060000001308e0649d96f24a2a=
10de618a1490ce90664c30aeeedc97d7c2af1625f939601cd812c60e30d1cb807a65db59a=
5f113352d28d5e97bf1bf809b7a68922d4e673b64f6419eb2edef7464679a4d6f7f631199=
df746a30cfab39b1b125c4ba98e144cf28626d7b16fe7e8eb870bb8d0ec5fd1f6beeb13eb=
5d22ee234a3c4e51ff323152efc6422e6374f9db46010db1e7d679745bffb01da61ff1034=
45b4d16a85ff225cc8aaff9822e12c462aac8acb93205222a9f0a6018cd9d6300854d55b2=
8defa218e"], 0x4bc}, 0x1, 0x0, 0x0, 0x4000000}, 0x20000004)
r2 =3D io_uring_setup(0x3e6b, &(0x7f0000000180)=3D{0x0, 0x1877, 0x100, 0x=
1, 0x33a})
syz_io_uring_setup(0x7b7c, &(0x7f0000000100)=3D{0x0, 0x9eec, 0x800, 0x1, =
0x148, 0x0, r2}, 0x0, 0x0)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
r3 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r3, &(0x7f00000000c0)=3D{0x0, 0x0, &(0x7f0000000080)=3D{=
&(0x7f0000000400)=3DANY=3D[@ANYBLOB=3D"4f45d0fa2ddbdf2507000000", @ANYRES=
32=3D0x0, @ANYBLOB=3D"0000000001000400"], 0x20}, 0x1, 0x0, 0x0, 0x8000}, =
0x8000)
r4 =3D seccomp$SECCOMP_SET_MODE_FILTER_LISTENER(0x1, 0xa, &(0x7f000000034=
0)=3D{0x1, &(0x7f0000000040)=3D[{0x6, 0x8, 0xd, 0xb40c}]})
futex(0x0, 0xb, 0x0, 0x0, 0x0, 0x2)
mkdirat(0xffffffffffffff9c, &(0x7f00000001c0)=3D'./file0/file0\x00', 0x1c=
0)
mount$nfs(0x0, &(0x7f00000002c0)=3D'./file0/file0\x00', &(0x7f0000000380)=
, 0x1, &(0x7f00000003c0)=3DANY=3D[@ANYRES32=3Dr4])
io_uring_setup(0x7f3, &(0x7f0000000100)=3D{0x0, 0x47e, 0x0, 0x1, 0x106})
ioctl$RNDADDENTROPY(r0, 0x40085203, &(0x7f0000000780)=3D{0x1, 0xd7, "be39=
b79aaa979710bdcbeef9fd1ee52bafa964ed53458fe0c4a129adc89ba823c3a3eb3a21c8b=
87a30c41762aa046be95b6705fffd64202e87b01c1e1ce8b3b53f721d221aaa7e4a802a1b=
2879ad3980e530753681814814c7be4c92539024d71fff3ba3bd0e7dee645c19f4ad93c6d=
c786af3d93e498217ffe955fb62b2a6300ada880b7f1f0e9c90b4a745dc5f183e49a42247=
e8aaba4f851660af73fa9bc8b62982a9be97f2ad6af4bba8bdb8d8d592d2912b4fecc23a2=
268cde987dbc69b4408f260f452c924a0be6ffb5f1d54e83e2179703d5911"})
r5 =3D socket$inet_icmp_raw(0x2, 0x3, 0x1)
ioctl$sock_inet_SIOCSIFADDR(r5, 0x8916, &(0x7f0000000040)=3D{'veth1_to_te=
am\x00', {0x2, 0x4e21, @rand_addr=3D0x64010102}})
openat$vhost_vsock(0xffffffffffffff9c, &(0x7f0000000200), 0x2, 0x0)
r6 =3D socket$unix(0x1, 0x1, 0x0)
bind$unix(r6, &(0x7f0000000000)=3D@file=3D{0x0, './file0\x00'}, 0x6e)
r7 =3D openat$rtc(0xffffffffffffff9c, &(0x7f0000000000), 0x101400, 0x0)
read(r7, &(0x7f0000000280)=3D""/200, 0xc8)
r8 =3D syz_create_resource$binfmt(&(0x7f00000000c0)=3D'./file0\x00')
r9 =3D openat$binfmt(0xffffffffffffff9c, r8, 0x42, 0x1ff)
write$binfmt_elf64(r9, &(0x7f00000000c0)=3DANY=3D[], 0xffffffa1)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
openat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file1\x00', 0x42, 0x1ff=
)
renameat2(0xffffffffffffff9c, &(0x7f0000000480)=3D'./file0\x00', 0xffffff=
ffffffff9c, &(0x7f0000000340)=3D'./file1\x00', 0x2)
close_range(r0, 0xffffffffffffffff, 0x0)
openat$fuse(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)
openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0, 0x0)

5m19.33478287s ago: executing program 9 (id=3D11026):
r0 =3D syz_open_procfs(0x0, &(0x7f00000010c0)=3D'numa_maps\x00')
readv(r0, &(0x7f0000002480)=3D[{&(0x7f0000004000)=3D""/4101, 0x1005}], 0x=
1)
r1 =3D openat(0xffffffffffffff9c, &(0x7f0000000240)=3D'./file0\x00', 0x42=
, 0x0)
close(r1)
r2 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
setsockopt$inet_sctp6_SCTP_SOCKOPT_CONNECTX(r2, 0x84, 0x6e, &(0x7f0000000=
000)=3D[@in6=3D{0xa, 0x4e24, 0x8, @rand_addr=3D' \x01\x00\x00\x00\x00\x00=
\x00\x00\x00\x00\x00\x00\x00\x00\x01', 0xff}], 0x1c)
getsockopt$inet_sctp6_SCTP_GET_ASSOC_ID_LIST(r2, 0x84, 0x1d, &(0x7f000000=
4fc0)=3D{0x1, [<r3=3D>0x0]}, &(0x7f0000005000)=3D0x8)
getsockopt$inet_sctp_SCTP_RECONFIG_SUPPORTED(r1, 0x84, 0x75, &(0x7f000000=
01c0)=3D{r3, 0x401}, &(0x7f0000000200)=3D0x8)
setsockopt$inet_sctp6_SCTP_RECONFIG_SUPPORTED(r0, 0x84, 0x75, &(0x7f00000=
00000)=3D{r3, 0x100}, 0x8)
prctl$PR_SET_TAGGED_ADDR_CTRL(0x37, 0x1)
r4 =3D socket$unix(0x1, 0x1, 0x0)
ioctl$AUTOFS_IOC_FAIL(r4, 0x5411, 0x1000000000000)
r5 =3D socket$packet(0x11, 0x3, 0x300)
r6 =3D accept4$packet(r5, &(0x7f0000000040)=3D{0x11, 0x0, 0x0, 0x1, 0x0, =
0x6, @dev}, &(0x7f0000000100)=3D0x14, 0x0)
setsockopt$packet_int(r6, 0x107, 0x12, &(0x7f0000000140)=3D0x374ee777, 0x=
fffffe7e)
setsockopt$IP6T_SO_SET_REPLACE(0xffffffffffffffff, 0x29, 0x40, &(0x7f0000=
0001c0)=3D@nat=3D{'nat\x00', 0x1b, 0x5, 0x5f0, 0x0, 0x0, 0xffffffff, 0xf0=
, 0x438, 0x438, 0x520, 0xffffffff, 0x520, 0x520, 0x5, 0x0, {[{{@uncond, 0=
x0, 0xa8, 0xf0}, @common=3D@unspec=3D@LED=3D{0x48, 'LED\x00', 0x0, {'syz0=
\x00', 0x1, 0x6b94, {0xffffffffffffffff}}}}, {{@uncond, 0x0, 0x1e8, 0x230=
, 0x0, {}, [@common=3D@inet=3D@recent0=3D{{0xf8}, {0x8001, 0x9, 0x8, 0x1,=
 'syz1\x00', 0x3}}, @common=3D@dst=3D{{0x48}, {0xfffffffa, 0x0, 0x1, [0x6=
, 0xfff2, 0x800, 0x5, 0x5, 0x7, 0x7, 0x1, 0x271d, 0x4, 0x4, 0x5, 0x4, 0x6=
, 0x2, 0x5962], 0x1}}]}, @REDIRECT=3D{0x48, 'REDIRECT\x00', 0x0, {0x1b, @=
ipv6=3D@initdev=3D{0xfe, 0x88, '\x00', 0x1, 0x0}, @ipv6=3D@private2=3D{0x=
fc, 0x2, '\x00', 0x1}, @gre_key=3D0x1, @icmp_id=3D0x68}}}, {{@uncond, 0x0=
, 0xd0, 0x118, 0x0, {}, [@common=3D@eui64=3D{{0x28}}]}, @REDIRECT=3D{0x48=
, 'REDIRECT\x00', 0x0, {0x1a, @ipv4=3D@multicast1, @ipv6=3D@local, @port=3D=
0x4e21, @gre_key=3D0x3}}}, {{@ipv6=3D{@private2=3D{0xfc, 0x2, '\x00', 0x1=
}, @mcast2, [0xffffff, 0xff000000, 0xffffff00], [0x0, 0xff, 0x0, 0xffffff=
ff], 'nr0\x00', '\x00', {}, {}, 0x89, 0x0, 0x1, 0x9}, 0x0, 0xa8, 0xe8}, @=
common=3D@inet=3D@TCPOPTSTRIP=3D{0x40, 'TCPOPTSTRIP\x00', 0x0, {[0xfffffc=
01, 0x81, 0x100, 0x4, 0x0, 0x8, 0x1, 0x6]}}}], {{'\x00', 0x0, 0xa8, 0xd0}=
, {0x28}}}}, 0x650)
r7 =3D socket$nl_sock_diag(0x10, 0x3, 0x4)
sendmsg$SOCK_DIAG_BY_FAMILY(r7, &(0x7f00000000c0)=3D{0x0, 0x0, &(0x7f0000=
000080)=3D{&(0x7f0000000600)=3DANY=3D[@ANYBLOB=3D"280000001400e5f329bd700=
0fc25289211"], 0x28}, 0x1, 0x0, 0x0, 0x20040845}, 0x20000000)

5m18.50139179s ago: executing program 9 (id=3D11050):
mmap(&(0x7f0000000000/0xa000)=3Dnil, 0xa000, 0x5, 0x32, 0xfffffffffffffff=
f, 0xc19ad000)
r0 =3D socket$inet_udp(0x2, 0x2, 0x0)
setsockopt$IP_VS_SO_SET_ZERO(r0, 0x0, 0x48f, &(0x7f0000000040)=3D{0x3b, @=
multicast2, 0x4e20, 0x3, 'none\x00', 0x14, 0x9, 0x27}, 0x2c)
r1 =3D socket$inet6(0xa, 0x2, 0x0)
r2 =3D socket$nl_route(0x10, 0x3, 0x0)
ioctl$sock_SIOCGIFINDEX(r1, 0x8933, &(0x7f00000000c0)=3D{'ip6gretap0\x00'=
, <r3=3D>0x0})
sendmsg$nl_route(r2, &(0x7f00000002c0)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000040)=3D@setlink=3D{0x20, 0x13, 0x90e, 0x70bd29, 0x21dfdbff, =
{0x0, 0x0, 0x0, r3, 0x41021, 0x36000}}, 0x20}, 0x1, 0x0, 0x0, 0x4011}, 0x=
1081)

5m18.44199811s ago: executing program 9 (id=3D11051):
r0 =3D socket$alg(0x26, 0x5, 0x0)
bind$alg(r0, &(0x7f00000000c0)=3D{0x26, 'skcipher\x00', 0x0, 0x0, 'pcbc(k=
hazad-generic)\x00'}, 0x58)
setsockopt$ALG_SET_KEY(r0, 0x117, 0x1, &(0x7f0000000040)=3D'\x00'/16, 0xf=
ffffd8a)
r1 =3D accept4(r0, 0x0, 0x0, 0x800)
sendmsg$NL80211_CMD_FRAME(r1, &(0x7f0000000280)=3D{0x0, 0x0, &(0x7f000000=
0240)=3D{&(0x7f00000004c0)=3DANY=3D[], 0xe0}, 0x1, 0x0, 0x0, 0x40}, 0x404=
0000) (async)
sendmsg$NL80211_CMD_FRAME(r1, &(0x7f0000000280)=3D{0x0, 0x0, &(0x7f000000=
0240)=3D{&(0x7f00000004c0)=3DANY=3D[], 0xe0}, 0x1, 0x0, 0x0, 0x40}, 0x404=
0000)
r2 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
setsockopt$inet6_group_source_req(r2, 0x29, 0x2e, &(0x7f0000000400)=3D{0x=
0, {{0xa, 0x4e20, 0x4009, @mcast1, 0x9}}, {{0xa, 0x4e23, 0xada1, @ipv4=3D=
{'\x00', '\xff\xff', @remote}, 0x7}}}, 0x108)
prctl$PR_SET_MM_MAP(0x23, 0xe, &(0x7f0000000000)=3D{&(0x7f0000ffc000/0x20=
00)=3Dnil, &(0x7f0000ffe000/0x1000)=3Dnil, &(0x7f0000ffc000/0x2000)=3Dnil=
, &(0x7f0000ffc000/0x4000)=3Dnil, &(0x7f0000ffb000/0x2000)=3Dnil, &(0x7f0=
000ffc000/0x2000)=3Dnil, &(0x7f0000ffd000/0x3000)=3Dnil, &(0x7f0000ffb000=
/0x4000)=3Dnil, &(0x7f0000ffb000/0x1000)=3Dnil, &(0x7f0000ffb000/0x3000)=3D=
nil, &(0x7f0000ffc000/0x2000)=3Dnil, 0x0}, 0x68) (async)
prctl$PR_SET_MM_MAP(0x23, 0xe, &(0x7f0000000000)=3D{&(0x7f0000ffc000/0x20=
00)=3Dnil, &(0x7f0000ffe000/0x1000)=3Dnil, &(0x7f0000ffc000/0x2000)=3Dnil=
, &(0x7f0000ffc000/0x4000)=3Dnil, &(0x7f0000ffb000/0x2000)=3Dnil, &(0x7f0=
000ffc000/0x2000)=3Dnil, &(0x7f0000ffd000/0x3000)=3Dnil, &(0x7f0000ffb000=
/0x4000)=3Dnil, &(0x7f0000ffb000/0x1000)=3Dnil, &(0x7f0000ffb000/0x3000)=3D=
nil, &(0x7f0000ffc000/0x2000)=3Dnil, 0x0}, 0x68)
brk(0x20ffb000)
r3 =3D socket$inet6_tcp(0xa, 0x1, 0x0)
syz_open_procfs(0x0, 0x0) (async)
r4 =3D syz_open_procfs(0x0, 0x0)
openat$zero(0xffffffffffffff9c, &(0x7f0000000040), 0x0, 0x0) (async)
r5 =3D openat$zero(0xffffffffffffff9c, &(0x7f0000000040), 0x0, 0x0)
read$FUSE(r5, &(0x7f0000006400)=3D{0x2020}, 0xfffffe1c) (async)
read$FUSE(r5, &(0x7f0000006400)=3D{0x2020}, 0xfffffe1c)
madvise(&(0x7f0000c00000/0x400000)=3Dnil, 0x400000, 0x19)
madvise(&(0x7f0000ffc000/0x4000)=3Dnil, 0x4000, 0x4) (async)
madvise(&(0x7f0000ffc000/0x4000)=3Dnil, 0x4000, 0x4)
ioctl$sock_ipv6_tunnel_SIOCDELPRL(r4, 0x89f6, 0x0) (async)
ioctl$sock_ipv6_tunnel_SIOCDELPRL(r4, 0x89f6, 0x0)
r6 =3D syz_open_dev$tty1(0xc, 0x4, 0x1)
ioctl$FIONREAD(r6, 0x541b, &(0x7f00000003c0))
mmap(&(0x7f0000ffb000/0x4000)=3Dnil, 0x4000, 0xb, 0x12, r3, 0x4865000)
ioctl$sock_inet_SIOCSIFPFLAGS(r2, 0x8934, &(0x7f0000000080)=3D{'dvmrp0\x0=
0', 0x7})
recvmmsg(r1, &(0x7f0000004a40)=3D[{{0x0, 0x0, &(0x7f0000000140)=3D[{&(0x7=
f0000000000)=3D""/61, 0x3d}, {&(0x7f00000006c0)=3D""/4096, 0x1000}], 0x2}=
, 0x13686f47}], 0x1, 0x10140, 0x0)
bpf$PROG_LOAD(0x5, &(0x7f0000000180)=3D{0x5, 0x4, &(0x7f0000000240)=3DANY=
=3D[@ANYBLOB=3D"1800000006000000000000007e3d0000de00ffff0000000095"], &(0=
x7f0000000ac0)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x1, '\x00', 0x0, @fallba=
ck=3D0x9, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0=
, 0x3ff}, 0x94)

5m18.28969539s ago: executing program 9 (id=3D11052):
mkdirat(0xffffffffffffff9c, &(0x7f0000002000)=3D'./file0\x00', 0x0) (asyn=
c)
mkdirat(0xffffffffffffff9c, &(0x7f0000002000)=3D'./file0\x00', 0x0)
openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0) (async)
r0 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0)
mount$fuse(0x0, &(0x7f00000020c0)=3D'./file0\x00', &(0x7f0000002100), 0x0=
, &(0x7f0000002140)=3D{{'fd', 0x3d, r0}, 0x2c, {'rootmode', 0x3d, 0x4000}=
})
read$FUSE(r0, &(0x7f00000021c0)=3D{0x2020, 0x0, <r1=3D>0x0, <r2=3D>0x0, <=
r3=3D>0x0}, 0x2020)
write$FUSE_INIT(r0, &(0x7f0000004300)=3D{0x50, 0x0, r1, {0x7, 0x2b, 0x0, =
0x0, 0x0, 0x0, 0x0, 0x8}}, 0x50)
r4 =3D syz_clone(0x4000, 0x0, 0x0, 0x0, 0x0, 0x0)
wait4(r4, &(0x7f0000000000), 0x40000000, 0x0) (async)
wait4(r4, &(0x7f0000000000), 0x40000000, 0x0)
syz_fuse_handle_req(r0,
&(0x7f0000006400)=3D"80cc949a20a10570b22f57c72b14b6d5b9656d619411d3e0feb9=
96f638296baec90caf0305c18523d32f8aaf50d3b62deaa3a75c2e016f25efcddb2e4e5cf=
e7a2e24d813ff5e08182e8fbc9353537f68ae28a6548a83e5662b382002990c8b32a687cf=
b9922aa8e8cef4d8f1c1e9ea22d432b3ccdc80e9b39e792b7545ae90a0880cb7f49edb763=
13335f65ed0888cdf8a79f3a22028f6035b8a77343e12b2b48d61cd8dadd99ffe4ccaf144=
36357b8f5c4633a94b27d21367946bea971d2f2cc9c588402be7d1f4cc9c78732b4650438=
da4a781b23ea5cc672d28ce0d78fb13a532779cfe3689e62f673ff4d4edd72d396bc29607=
5a710424cfe4fd1d38ce799c319e58f5b5d76c995ca60bb98f1a027c5122554fb397420fd=
5095c0326ccf221f017dbfdde47ba8180ebb28573193aa67076f503ce05d7950d220bc8dd=
ab527f0117a30a9c9fa977e6eb12024bf97ac55e5044b688f8ece30cfd06acf52743837cc=
9b1ae37af0113cda07abf471828dad657fd8a2cccf307f16e21f938b3c3c03a29bccb9f1f=
4854067c7eb7664f505a7fa433eac2c3e3ba6fc5393e376aa0662d502e91931c8363fa08b=
006e35feee61403c93a78cd0722bce85f680ee04efba31f47f92f1e391e3d63507aa49d8f=
063707900f63faeeba28c3d53cd4dc95af6e916bca9896926775f990b7e528b15014be706=
414ca96c59bea21a312484d3d6434c8150752bccee265c64742549b9bf94d64a100ea1f61=
2de41a7a4f34afc0f47a23a08630e3f90da155f6b5c90dd9a6496e23e80cbe5dfd3527288=
3076961caf332f97dc3871384379b2d6ecafa30ceea5fba0d68ba64fe7d235046347a4759=
f870e5bbf9ab1c3ad3281b63cbe1a9f0de5dc38118aebaaac3d8a42bf5e13489da5dbf0f5=
0a02291a1bff4af669d66679658bd3ac40f153034cadab5e07d743392a491f3daf2737703=
198cbd9f18c90d82dbb276f948bb84fca2bd92160675b5ce96f4e3609bfbfaadaa495231b=
581af70fbc8e2e2bcb249b3a8ff0b45269cbe2ba66b86942d24b086945dc9b4660ea211b1=
93c19bf11cdea937a3699ab6131ea26c4903121760b6df20561fa2a593700d7ff0e71aba5=
139ccfde4776e1e60233a784c72f4b7bcdaa00f60cb93c25367752c624652981121dbafce=
f1c96f3f514347a5adcf3c269df2091400b041d52460fa8c6b81e857f88154d4fce7662bc=
f27df14917a01170b0a36b36b49b0cb69af47247cfe08812597d74fe755ecd1c1ccdb3b0a=
3c9a2ea65c494bbd669b51ab7fdd2bc5e7e5ad459d6a9c9f02e59f7e0aa1f45de43cf5014=
23616d430a6dbc577492c8adfbdfe707daf0fb401239592bf301361770d155cfebbe9d5ba=
f0dccdb358c2c0d7678d6a1ba6e2fc16f1f0aa6b3b9be72b37c22fc76b0e4e5b9fa540f11=
6682f694e9ceaeac5cbc8691a935fd1a244b044ffeb258fb01a035880cb17e7dde5170a35=
d44816482f376d9d48b3b807af0f2138f8b48a47a18207745568b349db4661aee07fafdde=
33d604230e4d340c4f9d9ba0d0ab29294f7a31983fec1a75c6f4394d710bf961b5d4deda5=
09ed7602df284fcabcbfc996299783607934c8e0feb1dc2efb258586e71a0aa5458d50ce5=
560f716227a8d8c19f42f931b2ff0c448c8999863cd85cc5327c76644de795bee4cfa6ae5=
e1cbd8679a32b489ddc4af5c18483b7325937d4a4e77ffd4365d042636fbf8d2999812da9=
6aa1373f082b22c0f32b7d934a3e7dfb7ef7ab62a72671361faf92f291056499a7d588602=
29765ff64168f7faa220eecbd0d238e483094322ddc59f0477836be13328153b83183ef80=
083e8c74d423009ce3699addbc045b3062f81f2609a60ecee4db9ae80e992ccd481ac5c89=
53e6a8a333810e1fcf7073865f67140da698a46fe5419667025febf699b74156fc2fadb73=
7266b0baa6f87a34bb73115b5be02e15eb389de5d1c9a798997baa4410547f8a69af2803b=
d4b66db6cf0a865119a96e721b71ef9621ed7219f1d2497e55883480d663d59d9385ef368=
a6de2867c94fcecc73f6be4ddd6a3f3eb39b5c7c0cdc501dc69f156295e2f5345a9d8fec7=
fb1ae0ae1c5bda022eb7218faae98068c7686ce04f2c8ceec63ed8142380614d7b099bfa9=
455374ef90e3f9799c6b0592f39fc6228f7865a9bec42ab2d10775094a7964a81110de801=
204d434f132c848e76c6e7464fe4904b0e5c82a4b122fd21e69beaf1709c97ad40714b28d=
55db151dc99b8f5496814ca8f0349176ad7ae864ee42497764f39bf10714a2cdfd50fb337=
cfb6e4db18475ed71b28675c5954b078ce1f035022b5a45bec61ff614d235b4b9416ba38e=
d7f55922d14df5b26487a9d605ae4cec69c8396ec66aceec3b15bda52455c36e970dbfb7c=
cc846740226f0c33427dbf45e0275dfff5218940d36a3a06d93d414b0d2ca160b2b5d0de5=
f432d3f36a449f007068d2b79cb2fc019d1a15f6efeeab03afa45da9c1c360275985a839c=
d0137455885ea2a69aefd48915e14e7973ef44844963f42062712d4a8be4c3da27d8549fa=
3d65f673faa5bc6c8947bcda7863743e4f9f2e7dc62eec22fa2e9b669f87bf4c303e89125=
8b91daec9c9cc65c5983fd91a7709b5c7f1ff72faa639ce26ba95f553286fdec3759a37f5=
986c9a7a0ba711685af75c1b04bb743db4d0a39fd191147e2bfe375aa8d6223e7127bfbc4=
95d5bcd4dddfc29ac13a12a8044297a4caba53d63e899e3242ceebad1e6e7ab43f3a23e2f=
d007352866721411ce9ac5e95d46674b2be228196eed9a7329e4d282ecc837215310bd647=
42b5c9ed8fb89b5ee586b6391b57f6d52658eac832b6e01ea774bc5c35ff1c496a8743bdd=
15e950b9eac1437ace59b8c8aa91831e6716ea6fa44bee90f89206c688501a88de558cc1b=
283d4e2dd62a32fb108dc02ccc7d01b2cef61c09403d7256e0a8439828818966fb06899cd=
05dcbb52a9b8238e2f6e742329b170b1286d80ce38796311c94a77c0cd13e09610cd84e31=
2c0d8c9369c6454b98ddb40d6388ee4a16a408dbb589bc9164c9ff89ed34d92d09c2935a1=
e8d651fa364639598a7af49bed103eb975c43162e1f06b51f4c1316ab61f98c00b9944956=
2055f476e1c91dcfd2b6e5c9edfe4a942d2ae04962399ff0f700c4c5a5f4ab819d1a1b7bd=
64767a7c635ee70ded32870d4149359faa38e49e0a8c7a61ab377b3cb19767d3e50c4b844=
ac007d7ca13e61230924c3cea444da8919074705e79a29e0bb1326bdfc97dc5bafa5b74ec=
e5744b40a99c9f4d7a38bdbe5cf3065f9bd89ef04fdb58975284fc36575bd840840f96fe8=
39005743f840174182d9bc84abd5a2a5d3d3d26310ae37534c574c6fa0d442b1fae60fede=
d31010a206019f1df00f2a07b8e576432f4063464e808691cab001c5f68295182c5e34b8e=
12f96eb5844ca66177af647c16bf2c8cd6125068083489ee2672944ce6852e5c6f95edeb8=
6c97c86d4177bbe7a484464355f0ec7d0530c8d4d196122a3997a57a03a0484fa09eeda2c=
00a515edfb31feded6edd66b6513c5a9def92e7923c1f984469ba7054f96af55930c4c928=
c774c92606d8ab63d694cb94c2afde226be603fb7a0843c61965cab2af0e661c336789d1b=
6b5b4de8033da91497a3c97ba9d8d483d2406c76c0e1e00ba9a0901a93812d15ebb0f6a44=
7fbd3dbe15ff1827a459365f8c49c2f6f05826ade87b51175d78e786998e2818840605e7b=
7c4194a9c2f251912d8ae4cbd2674f95ef96bfe662ed7c412e2e2ec8caad8967f1f320d3b=
2669ad65f39b5405ad1bf0af9c65e0ccd1779f4743e211c032c2dda00ff4fa223731845ec=
80134710c732561ce317a2c204eba2bf298f2a885e2348a7cb07dcad2a7baba7a58461701=
63c6378c7ab742fe05ccc684df993db0f062eafd881554f8b44f6913acefaab6c5927b8ff=
7c0f5955c85cc9c70c04b6fb68aab8ae8b19780527aac4aa0c31df2d8369fad0990c884d3=
e0234b16642e0bee5cae0de6288fb1e92c7edf967037e13f07b3f69ff6a19b6a7ac431581=
0919db8499f38039e2399be08d9f7b101bc43a24a09aa49d82f7c235a359e7a65432d427a=
fb910ce19bcdd751292799e94aefe5df558d7f03a6010c1a9d5e2957d94c63ef221ca7c8f=
16c8e639ca1e332c7d5422b2b7b5589690366edbd0cf21ee41b215b84a1108e0e6899c25c=
a16e4f5f0d58f3d8938539bf970e2b9192f310e2d20b520871ded3702dbf5caa3b1ca0ab9=
dfc3563daeff6bc4b5949757a8c2e3ca9a67bf295b123a86294f1250b4f35a0b8b7382446=
f050d2b62dcacfec5c4bd201e00a50d3d2dd97eef43b3e3934392d9ce77262400f2f04ed7=
14ee7a18b79a7ff98fa60d934af0acc351c2fc3e9f416ee164fab7dc0f6067d10b6932520=
c2cad5d0d1ff5622bf8ee5f524fb292ac315eace7d02c80f885749a096b43dde45cd41164=
2282c163fdc2af62b9dfbb7e02005dc40d107c4747b7d749d1607a7cdc3ec29600bfd480c=
80fe4e302164ca3765ea070de833c5efdbc2cb396306f652e00593682a3392f9d2af52f33=
77003f2771ab919c6d5c86df6f5ef335084b9e25564e510b7e1ee1158e4b011043fefa037=
67cb6a4b647044f247f1d24f9d27a95b84347b5495e81b1d25f8cf3d00ce81cb58aa46185=
8768e052001ec35072d1f687386673819411288144a7c92d120dd58453751c8825dff0dd6=
99202dc73beccf1fc161ef12bdca01bc982bc93ff7927b0bc5c076db8077ad0088fba10f5=
d17b50740f14d238315fecabc89ca4004db8990685c51e7272844db7bc1c16be97622cc75=
69f7eb799708b9c44cd15500fc48a577a5ef21bcdeb4b01b1966b46fe5fc1e527a5eb7205=
4265499e36cbc77efbef2f3ed56abe3e9a7fb79027179855bc52e23a635fbc1f97999db95=
312408a2a6824f9d02641bc275f5f98891b1e5571fb985b4aad3c7542bde57186aea7e04c=
23b344aae36e5842264ff5d7f3d97b8fcab46ed86f33d61a180bb9e8422cfef7e9dbf6fe6=
aa1f411e8413a5dc3f1fb2acfca42ee728d684f6aee25e8da3567c1cc1775efabd4300b99=
63fdc1f85f213af53a74fc3a765ce2ccd33435b4a77e78abb45254cdf197a155af61d9645=
6e344c2187b86637ff38ea31f1ae06f0450dc07c4f75483d7465dc1c858c66268bd6dd79a=
ab93034c4bf074916aa0af59517131a3ee7ba071a8e8489f8abfe5ccea8fbd19fd87f13c0=
b79ae9dc4aed40b876d4026dfdf81fbd26c1471b3d089d8f42b59fd4e333895b62cfad106=
43bac3c9b3693ab266e458429332a208fc31f79d5f3bcc467c918a3f7ed6c11978459a205=
5cfbfa66bc6f4842d1a06b6d1002b831f0fbab4037e6437682609510b24964fda2f3a93f1=
14cd309347cba2e957a85afe51205d9a379a3e1f071774b25e02196cd56066b04af86dd8a=
e5d232e34795abe101d22f40d8de9be579b7441bff26297b6acdf2a443ec68162e9f72e07=
2e3c36bbf3699bb24ea36a00e2a331e64d7398ce667a010ecc60458ec1e36b5240fad8146=
e3879e89400c7a1689185d96f3e42c14cb634b8e33c295a069447136d25426e48c2dfa77d=
11c3b2ca5b1ebe5ff49b4b1a216b40f9b6dc823e58d4a4a686d8e24f3ab217b35abe18dc0=
e57d1d6908e32dfc26da5aa1a04e3b7ee1d015226f57bc0da311e7dc8cd2f766f1e4c40bc=
27b7b62b38985f768a7f885884be43f9e13af66592decc37ea77b83d82997f27734f4d8f1=
ec2bcfeb61fb73169a37953a1bc699ef2ae3365c931001fb42ae1d2c2234bf184dbf4c19e=
7fa0a18fd0b374140430aa14edc03b2abd1fe3d2d515c67e7155c8066366cf0f0e4c72671=
a3b812d4b25844e5e1b59de8d1bd13a5a06262511b2f1d43da6608bab3a406723e1774262=
1155ed8f771bca33b4aabea0ba02c7ef8a5ee44e19a09a2a9f298ae4faaa347d3549f1aa1=
5c608fd8f3c48ee91e5d1f7c09c90d13f1e677313a4c074a1a3b6b3c7a184ea34875afc9c=
1ec7d8f4828e9dd9a4bd8a5d101c8770a371c08f446828de72c6b9f09b8e964e579d7652c=
35799693c7aa3c666116dba3555ea37cf7a40b43e1c75a4d8242843362d8f46b13a071ad5=
e68db0394c5b2a89c75a8eab80709d80c8b479e9f98726faeb2c6c2dbddc6fd0824bf0c79=
76b39fd50acc7400d8f69c7830e1a72985f9818e62af00943d4aa9c710971ed553174f1e4=
fd5934d5382659466a9acff619605796fe6a15b167df17991c8eaea0aa300528e2b504784=
66f4d296f7cc667a21fec9e693c4d4ca2c9c2a0e6fc4fc92757e2de37fb7813e5127e6c71=
38d8f7359ee0e97d479161e05c608e2f709729f1f4bd43772ac8a1c4615c4ede74a91e4a1=
6458b0de739721d2ec8b0514a79161ce0087008d3cd97fdd5538c518b24b28419f67ce0fe=
d106b4df122ba9f51af5952a956a0b9c95319f5c49e3f7b48a19dcc9d9f3b5ded21a95622=
07f162b805b628018dad3161f938942cded99e86f51296a815a9eeb1cdd60330a2573ce7d=
cdb07643fc3d5362a87db6a1ef0014bdf70edb584a9168eef7c4baa260e284a5f221b71dd=
72a23d2443a393c7a3d415b640e6ef68b6325cc8323c7441b036950efad4ac9fb10510cd1=
1b06d1c5cc8258dfa0c9e52f09b47828c337f3291d311a450844afbd52de50527d4cdeb06=
121270ce90a29b8f3fe79ea68ad18e2d34148e643a706fb24ff74dd8664abbea9894f2544=
c22f174a9e50d954b6359af53fff54598a7e686c84299c84721b57276c15adcac69ea92b0=
a9abc225bb9a1a6f2254f51aea3da768b324f3bfed0bd4170fd1784d17384fcf16e8cf23b=
ec1a23151cfe2c81894d95599586e136e70ab39d867df88147f0cf56a5bc6d2dff584baa0=
4f7c1ccdb41eae35345bcd2f9c4160e5d141c0714ba4e00abfc11ba3044b566252ab24331=
428160e22fac02d71704bba9cd3658e4ad1edb5dda5e0f20ca2b768db78f9835501a0fa53=
c21a390f894ed62d815a736f6683e0fe841eb881db6941ac4199e1a91f74ac207928bba02=
4490ca79dd212adaad5b2125fc1abde7214e775880daee271128d3b110c1f4837ca237624=
69b3e046539b0dcbc9efdc74d5729f9554aeb11cd4f169649a1e0a516bba7a2744529e7a5=
bad1cc654713015476353c04ada5d5a4a41e80cea1c72bd97ee95aee3298202208ec13ab9=
c8c002ed999ef0c4114ebafc49333ed4e8acb8ecc346615720c9635ceccb2b4aae738552c=
b3a25d00f14fc49ceda292c0ba51e3705c8910b849bc40bce90825cffea3b93003f23eb27=
22057e3324a585a9d28f8407f01f38b37e621537a7791cc81ed4385160c4e4e33b8c43e6e=
e71c2cfdb9b29bc7b62110f3d43b36ed066f2cc903c712bb134e58a37349cae68d9ee2da8=
831738c299f71e8abf9e64186c234eb9c87e983eb31fbf854fd809f5b5e3994fb287db385=
c67666524cddacf77955ddf8eccc91e4ad0f974f56720bcbe28e64ca4aa537cac33a7af5c=
64577d9ce3ccafed63000afe624037cc6f50c4f1843f774227b831e462e6699d31d8e862d=
e7839a6c21642d02f42ebc1f97e57277565a35897dfedeb13b595f89ff9ee7e923e87f0a8=
e218df193da791b5e6b5125cf010ea46ad97e69fba91d5a5f5910fe4c62614308bfae38b4=
93bf47730b2407f58c4013b74787c3b2366e11c56f24864575c03e153fac827dd8cc40b7d=
a5cae79d7348bc9020e8d953f030e69fbdc151b844864b7928983fc52ddb78f7ca9d969f0=
df112426d71b6213f274f4c6f847cf2690ef569e3e6cd1b4690cdb15ee899a4cef5831b7b=
94316a817305b5afe6b7e04bf72b634421dfcc78062f21ace9a094e71e54fa5a68ce305ff=
8d655a4cb76bab1a5f65695068ddcc713f894d0964893f0e8ea0aaded011feb0d7e81b096=
9d62b19c399d303f9355577c1a7ce9f48226aff3da483abc841f994f6d073a111751ea78d=
b37654289d4d26aea096e789cac8fe3bb23195d31a7b8033ec2ad09839d15585daa7de2b0=
ed14dc178df27b1c6783bdf2d63aee1d0d4b5c73386b6c193f6bb19ada653c9d89de533a5=
f95d731111048d727b541f8e130e9b0c698e0695b12d603e6c600f7fe5039ffc0c8e9dd06=
d67b8c040a341ccb89399a097a178d70caa10141665898d836ad6a63f1f53e5f71fd16f58=
92c9a4b8d6bd8653a7ba0a888f746e3e050777cf6d569e43772b6938b65a3a6d555310d00=
3b74ff88afb640c1584a163f3ff30564fc974f2f92f92f4dc8eeb8e09c25089c55781100f=
3d5025c6f8118bdcdac966fc3077447a43fdd25496771f9a7a5f88a1556e9e48f4251a56c=
cce8830bb60905006029c562f7540684cc47e398fa292146b2579652454c89e2f3b6118ba=
d6964176403b431490adf3d108f9ee0c91a7a56b4fff0c0e3461e45d445a65a3108df44ca=
da6fe0c1bc98039188b588f223726e5d18de2805c901c92aeff6ce7f9072e6c065d8f5e08=
a356983abdd55cb89d4062f90c0bdaff31b070786f7957d48c0006a4c59e9705172061579=
cda17c0fc953045cac664c8a63534101cda0fa271f88d97e30121923e1359777ccc9b477a=
ddd6517b5993afb19c6eedc4f052a6ee879233f9d1f3ec431e3aaa787e561223ca44906d3=
ac85523e3332c29fbda77ba95a16d6f99aa893f7df8b0cacff383e196578b76b0f847bd44=
0acbba3d9642dfea94703c39514397ffa671751513c15f1eb5614e54c1db8f9fcdb515e61=
75b13d19eb82edeee6362563ed91a3229b8876e299149a51a40a9718da40cf3236209694d=
3aef482e79349e88e1ef23a79ca484c4c04eb7732ac35733af6cb4f5dc49e5c67bb916ad4=
85bcccec344d387627a3b1b97d7f6c82f5e29313f19e8e42e065eb94120bdd1523a11ddd3=
26514a2c8a54338c5b86328dc031cd07ab66b2b4a52f3a29a33dd776cc33a7b0643b6922b=
00c05f726ea96d2bf9f52c5d88c4c814a1ad9e3df182900176a5daf9006bc0b3987282ad4=
72a9ff9653335110020bd97df97084afc01fbf75f5538bbef39f934d781cf5152aa43219b=
4ec36b5d247c2f037359b02a21931fe187f77210d4d6745963a8cfa379e5e581ba0096574=
466a112892a85a7de6b5b71e8b5cbed837a1216b52aec86c2f132a5b68cab5f4fb8fb4b8e=
66d0b8da3ec9440e8ad3e8652ac045ed7ec82e46e49d0006c1112ab8338ecab8660167e2d=
b4930f1bb2e9fb5687f0b40b40e0dd6b75e78a082fdbfea91da3f07b57dbec8776232f312=
b2d267a8bd372aeb94e2ff2323798553839c961d820d701da8a67a1fc0efa49595f3a88ea=
db8a01c80c239968925fe2a71c4c3571511d13638685f33a2957da0f9b3444e9c1ad13e6e=
eb9175bb188e2cd28e7db490b3f2cedc96c77c01ff7abcf2b27c2086eae3f3b4a1489c5f5=
aa067065ce96108bda1000f636bce346722c6902511ac1a0c688b0f49552cbce6c0543677=
3b43cefd7ca335ded24e17d92c61987bb87693555b8ffe222d30a99ea4ab557994ff136c2=
d9c24872f66e91220b339aa978dc250c435d1d04d460319e0ba2ead5c8329698ce1426d42=
705497671e127266ce256a20cd5b4d859bc5361c5319801576a598f6d391fcf41cecb2663=
226105b6308ccd81c5fcf52c30e7b1d43d1e518884f521ac9d017da826d1c079445be1660=
65ce5974f92fe92645342aab60d5417d1d0a206bbdfb96cf4346023267aa3aeafac6cb5ea=
594fb452635a97f4f87f634b477bee33a3bf0c526c8e5c091e7213659d3fcb8773fbfa38f=
2edff5636dedc6838a9d7e279228a56f89d5a6baccff0461d91d136ea8d097c83993804f5=
4fd264db79aa67c81e966a352b1b9549247fedc317019fa506edba35b0e3d61c93950562a=
6d968c001e24900ec7609a8f72c9d6953b7eeeceda50f237e59c106e16b68145aa746ff37=
35d279b1162cb0383c0ec9d124c94cc4337f21e980d6566d907d0be94b67539b8d10dbdfb=
d840acfa278d5ab3e35a64ee36b2934f019175d946be8723b8c529fe2c171d05e12c471fd=
8de3cd0d2f816fc679273ed18bf0df1953b1e346aecebfb226746ff493b263dc0886dbe2e=
7994a2e547f3c8fff2424c1529f28c390d7e0c6d8829585c41a730b37bdf5343d6396f244=
ebc1c695d37f4b343d9e1a56ef15f808323c465e91bfc8b7f23a71e306128b1cb5da4477b=
7e140426430f458bcdec732d45da8d33939389412ee609821e07a47f218f8447d246d8b2d=
f005ca0b1dc70db2e1800ffede9c04b3a1e1247c4ac6d7f4065ddcd73e08b8777953ae24a=
9d0ec824fe75c1220a20b2e9c0b9bdc5102043f7ef47da065742ce5930582b670a6b012e7=
030792ded6c5d3c4e92e8a27a626fb2594151e5ac1d93bae6e86a89cbd748e35678bc28f3=
aba772cd05990260014607c7348e78da39425b1e13403a9750fef9820f9b15cc16ff6beb9=
fb86277c06873aa18c9509cd3597f31502b6da18fa7ae25ff104db554e2021edc0860311a=
d8956d3a415a3f70058699235ba0cbcc304640622763985a81ad5eeac54827a4b4adcf254=
b3a8909959f9f5509d7207c07cd801bf1b6691edaf191b4ea870302b8d6b51a1539c857f0=
f012204572e32e6d64e2217b7918a0acbf87779c60555bafab138b6edda46d4ad8a835a47=
06a0bf754e7109abc885254949b03e3b2d265385ba54dcabe4857e85d804d3ba72bb38305=
a143ea21f523844e732ab89a42bdc61f6be1f9b28e3386cad2ca92f6c70a613722f3c0c4a=
f72b2cf39d5b734dace0f2e7f66d6c2ef74e141e73cf90c6f979c576a82380249b6c654a7=
b2ef8372896f96f6f766642dacd5841250c97143857e545beab5c3882a3e1d529bb519945=
412e6bfc774e99463dc15bad3f6069c5827ee76897151330dacd669814a58185e301d6f0f=
701908d378b6183bc6b06a8efba3e70a4b790b017743ce08e9bccc686fd0cd725e3ddb931=
1573aaf22f6e49b2c013306c145ed34275433e869a4a721da89de4f59602c5c7a9e54e678=
fbe0e88f64110c975b692390e1f6e896dd322559ab9c629eaec0be9553ea26c1c0360fab0=
2d8e8e16e378976ce57126b434baae51289e916210aa802849b23ec851b1ddbde105bdfe3=
72c96da4ed1a9f4f64464ad704e077b14036fa47fa1c20444392e30da43088e0f3926ea1f=
ba4f2193ca38f7baf44889f45081006acc319e9fe73b7efd7702543c08ae91426fb0333e3=
a347c795adc061d11bd524f5bd1570e0ed47796f6bf068953be6a91b43e66607e25fef130=
5025b9a7558caf9a9cbd1b91757c21cfa254c3ff83f5445c0ae3e70c2f295ccb05ae85c54=
70b893f9768b3c641695dfedc01382bd952023331f6401cd20993b7460f0b5f2cac0779f9=
92570d7682afbf5b2f1caae09c9791a3e9090a5864e895c372064fec3203700cfc75939f2=
e9b79e2907cd9ba03708c4bdd4d2fed6602cfe12b9b6388988fe9c955e71b90fc73405522=
ed1b7579a0c278431e0bac8ef597f398440bda215da819af94b6bab31f79f9cf00394cb95=
5beddef2b97bfe985b6efed138dbfffeff375c2ddcbfa930bf896",
0x2000, &(0x7f00000004c0)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, &(0x7f00000003c0)=3D{0x90, 0x0, 0xb14, {0x4, 0x1, 0x7fb, 0x1, =
0x7fd, 0x80000000, {0x6, 0x9a, 0x0, 0x4000000000000, 0x80000001, 0x9, 0x6=
, 0xde23, 0x7, 0x2000, 0x8, r2, r3, 0x400, 0x3}}}, 0x0, 0x0, 0x0, 0x0, 0x=
0})
r5 =3D openat$zero(0xffffffffffffff9c, &(0x7f0000000040), 0x0, 0x0)
read$FUSE(r5, &(0x7f0000006400)=3D{0x2020}, 0xfffffe1c) (async)
read$FUSE(r5, &(0x7f0000006400)=3D{0x2020}, 0xfffffe1c)
write$P9_RSTATu(r5, &(0x7f0000000000)=3D{0x68, 0x7d, 0x1, {{0x0, 0x4b, 0x=
1, 0x21, {0x10, 0x1, 0x8}, 0xe0840000, 0x3ff, 0xea, 0x7787c845, 0x8, 'gro=
up_id', 0xa, '/dev/fuse\x00', 0x4, '#\xfd/[', 0x2, '+&'}, 0x8, 'group_id'=
, r2, r3, r2}}, 0x68)
openat$dir(0xffffffffffffff9c, &(0x7f0000000140)=3D'./file0/file0\x00', 0=
x0, 0x50)

5m18.16602449s ago: executing program 9 (id=3D11053):
r0 =3D openat$pidfd(0xffffffffffffff9c, &(0x7f0000000000), 0x200000, 0x0)=

unshare(0x40020280)
r1 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x1=
07000, 0x21)
r2 =3D openat$cgroup_ro(r1, &(0x7f0000000040)=3D'cgroup.kill\x00', 0x0, 0=
x0)
bpf$PROG_LOAD(0x5, &(0x7f0000000340)=3D{0x17, 0x2, &(0x7f0000000100)=3DAN=
Y=3D[@ANYBLOB=3D"791900000000000095"], &(0x7f0000000300)=3D'syzkaller\x00=
', 0x1, 0x0, 0x0, 0x41000, 0x43, '\x00', 0x0, @fallback=3D0x25, 0xfffffff=
fffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x=
7}, 0x94)
io_setup(0x6, &(0x7f0000000080)=3D<r3=3D>0x0)
io_submit(r3, 0x1, &(0x7f0000000440)=3D[&(0x7f00000001c0)=3D{0x0, 0x0, 0x=
0, 0x0, 0x50, r2, &(0x7f00000000c0)=3D"ea20eb9cc7", 0x5, 0xb, 0x0, 0x2}])=

r4 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0=
, 0x0)
close(r4)
ioctl$sock_ipv4_tunnel_SIOCADDTUNNEL(r4, 0x89f1, &(0x7f0000000480)=3D{'si=
t0\x00', &(0x7f00000002c0)=3D{'syztnl2\x00', 0x0, 0x7800, 0x10, 0x1, 0xff=
fffffc, {{0x5, 0x4, 0x0, 0x17, 0x14, 0x68, 0x0, 0x7, 0x4, 0x0, @multicast=
2, @rand_addr=3D0x64010101}}}})
ioctl$sock_ipv4_tunnel_SIOCDELTUNNEL(r4, 0x89f2, &(0x7f0000000300)=3D{'sy=
ztnl2\x00', &(0x7f0000000200)=3D{'gretap0\x00', 0x0, 0x1, 0x11, 0x0, 0xfa=
8, {{0x6, 0x4, 0x1, 0x1, 0x18, 0x67, 0x0, 0xc8, 0x2f, 0x0, @local, @empty=
, {[@generic=3D{0x86, 0x2}]}}}}})
io_submit(r3, 0x1, &(0x7f0000000200)=3D[&(0x7f00000001c0)=3D{0x0, 0x0, 0x=
0, 0x7, 0x70f7, r0, &(0x7f00000000c0)=3D"c749b828edb000a8d52e463591f53c64=
da591768d63deee7b2c2e5705ed5a4259f600faaa4b1395b67c8cd3cb0de58bdec65474df=
0b1fb590373cb9124f4f81eda2ef541d75e76512f3efcb2c4006dc51a67b9659b7d050bad=
6ac3f196b17ad40695e2f34abe1cd6ccc6e536a5b404ef33d652bc38d7968db2e626c4a37=
e75baabdf2dbad058b2ca161f2139aa7694d4f651949820ffe042d6371008c0cda2a4a516=
b8d84c2115412766c38079d2a561aa4306a99996dbb26f66c6b9f35fc5b5fb7559f33193d=
eb884c24b37e275382754c499d668aac21ea5f8898940", 0xdd, 0xffffffffffffffff,=
 0x0, 0x0, r4}])
io_setup(0x588c90a1, &(0x7f0000000000))
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
mount$bpf(0x0, &(0x7f0000000000)=3D'./file0/../file0\x00', &(0x7f00000000=
80), 0x300c45a, 0x0)
r5 =3D socket$inet_tcp(0x2, 0x1, 0x0)
sendmsg$DEVLINK_CMD_PORT_SET(r1, &(0x7f00000005c0)=3D{&(0x7f0000000240)=3D=
{0x10, 0x0, 0x0, 0x80000}, 0xc, &(0x7f0000000400)=3D{&(0x7f00000004c0)=3D=
{0xc4, 0x0, 0x8, 0x70bd27, 0x25dfdbfc, {}, [{{@pci=3D{{0x8}, {0x11}}, {0x=
8}}, {0x6}}, {{@pci=3D{{0x8}, {0x11}}, {0x8}}, {0x6}}, {{@pci=3D{{0x8}, {=
0x11}}, {0x8, 0x3, 0x2}}, {0x6}}, {{@pci=3D{{0x8}, {0x11}}, {0x8, 0x3, 0x=
2}}, {0x6, 0x4, 0x3}}]}, 0xc4}, 0x1, 0x0, 0x0, 0x8000}, 0x20000000)
setsockopt$inet_tcp_TCP_FASTOPEN_KEY(r5, 0x6, 0x21, &(0x7f0000000ec0)=3D"=
2bc3506282511df272983c50521ef43c", 0x20)
close(0x3)
r6 =3D openat$dir(0xffffffffffffff9c, &(0x7f0000004280)=3D'./file0\x00', =
0x0, 0x0)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x3, 0x2, 0x0, 0x0, 0x0, =
0x7ff, 0x140c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_config_ext=3D{0x6, 0xffffffffffff64f9}, 0x100001, 0x0, 0xc000000,=
 0x1, 0xffffffff, 0x5, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xfffffffffffffff=
f, 0xffffffffffffffff, 0xb)
bpf$MAP_CREATE(0x0, &(0x7f0000000100)=3DANY=3D[@ANYBLOB=3D"20000000090000=
00230100001c00000001000000", @ANYRES32, @ANYBLOB=3D"e56400"/20, @ANYRES32=
=3D0x0, @ANYRES32, @ANYBLOB=3D"040000000200"/28], 0x50)
r7 =3D socket$nl_generic(0x10, 0x3, 0x10)
r8 =3D syz_genetlink_get_family_id$devlink(&(0x7f0000000640), 0xfffffffff=
fffffff)
sendmsg$DEVLINK_CMD_SB_GET(r7, &(0x7f0000000700)=3D{0x0, 0x0, &(0x7f00000=
000c0)=3D{&(0x7f0000000340)=3DANY=3D[@ANYBLOB=3D"14000000", @ANYRES16=3Dr=
8, @ANYBLOB=3D"410700000000ffdb9b154e"], 0x14}, 0x1, 0x0, 0x0, 0x44000}, =
0x4044800)
getdents64(r6, 0x0, 0x0)
seccomp$SECCOMP_SET_MODE_FILTER_LISTENER(0x1, 0xc, &(0x7f00000007c0)=3D{0=
x1, &(0x7f0000000080)=3D[{0x16, 0x4, 0xcc, 0xffffff7f}]})
r9 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
setsockopt$inet6_int(r9, 0x29, 0x43, &(0x7f0000000000)=3D0x8, 0x4)
close_range(r0, 0xffffffffffffffff, 0x0)

5m3.11348257s ago: executing program 56 (id=3D11053):
r0 =3D openat$pidfd(0xffffffffffffff9c, &(0x7f0000000000), 0x200000, 0x0)=

unshare(0x40020280)
r1 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x1=
07000, 0x21)
r2 =3D openat$cgroup_ro(r1, &(0x7f0000000040)=3D'cgroup.kill\x00', 0x0, 0=
x0)
bpf$PROG_LOAD(0x5, &(0x7f0000000340)=3D{0x17, 0x2, &(0x7f0000000100)=3DAN=
Y=3D[@ANYBLOB=3D"791900000000000095"], &(0x7f0000000300)=3D'syzkaller\x00=
', 0x1, 0x0, 0x0, 0x41000, 0x43, '\x00', 0x0, @fallback=3D0x25, 0xfffffff=
fffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x=
7}, 0x94)
io_setup(0x6, &(0x7f0000000080)=3D<r3=3D>0x0)
io_submit(r3, 0x1, &(0x7f0000000440)=3D[&(0x7f00000001c0)=3D{0x0, 0x0, 0x=
0, 0x0, 0x50, r2, &(0x7f00000000c0)=3D"ea20eb9cc7", 0x5, 0xb, 0x0, 0x2}])=

r4 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0=
, 0x0)
close(r4)
ioctl$sock_ipv4_tunnel_SIOCADDTUNNEL(r4, 0x89f1, &(0x7f0000000480)=3D{'si=
t0\x00', &(0x7f00000002c0)=3D{'syztnl2\x00', 0x0, 0x7800, 0x10, 0x1, 0xff=
fffffc, {{0x5, 0x4, 0x0, 0x17, 0x14, 0x68, 0x0, 0x7, 0x4, 0x0, @multicast=
2, @rand_addr=3D0x64010101}}}})
ioctl$sock_ipv4_tunnel_SIOCDELTUNNEL(r4, 0x89f2, &(0x7f0000000300)=3D{'sy=
ztnl2\x00', &(0x7f0000000200)=3D{'gretap0\x00', 0x0, 0x1, 0x11, 0x0, 0xfa=
8, {{0x6, 0x4, 0x1, 0x1, 0x18, 0x67, 0x0, 0xc8, 0x2f, 0x0, @local, @empty=
, {[@generic=3D{0x86, 0x2}]}}}}})
io_submit(r3, 0x1, &(0x7f0000000200)=3D[&(0x7f00000001c0)=3D{0x0, 0x0, 0x=
0, 0x7, 0x70f7, r0, &(0x7f00000000c0)=3D"c749b828edb000a8d52e463591f53c64=
da591768d63deee7b2c2e5705ed5a4259f600faaa4b1395b67c8cd3cb0de58bdec65474df=
0b1fb590373cb9124f4f81eda2ef541d75e76512f3efcb2c4006dc51a67b9659b7d050bad=
6ac3f196b17ad40695e2f34abe1cd6ccc6e536a5b404ef33d652bc38d7968db2e626c4a37=
e75baabdf2dbad058b2ca161f2139aa7694d4f651949820ffe042d6371008c0cda2a4a516=
b8d84c2115412766c38079d2a561aa4306a99996dbb26f66c6b9f35fc5b5fb7559f33193d=
eb884c24b37e275382754c499d668aac21ea5f8898940", 0xdd, 0xffffffffffffffff,=
 0x0, 0x0, r4}])
io_setup(0x588c90a1, &(0x7f0000000000))
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
mount$bpf(0x0, &(0x7f0000000000)=3D'./file0/../file0\x00', &(0x7f00000000=
80), 0x300c45a, 0x0)
r5 =3D socket$inet_tcp(0x2, 0x1, 0x0)
sendmsg$DEVLINK_CMD_PORT_SET(r1, &(0x7f00000005c0)=3D{&(0x7f0000000240)=3D=
{0x10, 0x0, 0x0, 0x80000}, 0xc, &(0x7f0000000400)=3D{&(0x7f00000004c0)=3D=
{0xc4, 0x0, 0x8, 0x70bd27, 0x25dfdbfc, {}, [{{@pci=3D{{0x8}, {0x11}}, {0x=
8}}, {0x6}}, {{@pci=3D{{0x8}, {0x11}}, {0x8}}, {0x6}}, {{@pci=3D{{0x8}, {=
0x11}}, {0x8, 0x3, 0x2}}, {0x6}}, {{@pci=3D{{0x8}, {0x11}}, {0x8, 0x3, 0x=
2}}, {0x6, 0x4, 0x3}}]}, 0xc4}, 0x1, 0x0, 0x0, 0x8000}, 0x20000000)
setsockopt$inet_tcp_TCP_FASTOPEN_KEY(r5, 0x6, 0x21, &(0x7f0000000ec0)=3D"=
2bc3506282511df272983c50521ef43c", 0x20)
close(0x3)
r6 =3D openat$dir(0xffffffffffffff9c, &(0x7f0000004280)=3D'./file0\x00', =
0x0, 0x0)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x3, 0x2, 0x0, 0x0, 0x0, =
0x7ff, 0x140c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_config_ext=3D{0x6, 0xffffffffffff64f9}, 0x100001, 0x0, 0xc000000,=
 0x1, 0xffffffff, 0x5, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xfffffffffffffff=
f, 0xffffffffffffffff, 0xb)
bpf$MAP_CREATE(0x0, &(0x7f0000000100)=3DANY=3D[@ANYBLOB=3D"20000000090000=
00230100001c00000001000000", @ANYRES32, @ANYBLOB=3D"e56400"/20, @ANYRES32=
=3D0x0, @ANYRES32, @ANYBLOB=3D"040000000200"/28], 0x50)
r7 =3D socket$nl_generic(0x10, 0x3, 0x10)
r8 =3D syz_genetlink_get_family_id$devlink(&(0x7f0000000640), 0xfffffffff=
fffffff)
sendmsg$DEVLINK_CMD_SB_GET(r7, &(0x7f0000000700)=3D{0x0, 0x0, &(0x7f00000=
000c0)=3D{&(0x7f0000000340)=3DANY=3D[@ANYBLOB=3D"14000000", @ANYRES16=3Dr=
8, @ANYBLOB=3D"410700000000ffdb9b154e"], 0x14}, 0x1, 0x0, 0x0, 0x44000}, =
0x4044800)
getdents64(r6, 0x0, 0x0)
seccomp$SECCOMP_SET_MODE_FILTER_LISTENER(0x1, 0xc, &(0x7f00000007c0)=3D{0=
x1, &(0x7f0000000080)=3D[{0x16, 0x4, 0xcc, 0xffffff7f}]})
r9 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
setsockopt$inet6_int(r9, 0x29, 0x43, &(0x7f0000000000)=3D0x8, 0x4)
close_range(r0, 0xffffffffffffffff, 0x0)

4m34.50537784s ago: executing program 4 (id=3D11304):
r0 =3D bpf$MAP_CREATE_RINGBUF(0x0, &(0x7f00000007c0)=3D{0x1b, 0x0, 0x0, 0=
x40000, 0x0, 0x0, 0x0, '\x00', 0x0, 0x0}, 0x48)
r1 =3D socket$alg(0x26, 0x5, 0x0)
bind$alg(r1, &(0x7f00000001c0)=3D{0x26, 'rng\x00', 0x0, 0x0, 'drbg_nopr_c=
tr_aes192\x00'}, 0x58)
setsockopt$ALG_SET_KEY(r1, 0x117, 0x1, 0x0, 0x0)
setsockopt$ALG_SET_KEY(r1, 0x117, 0x1, 0x0, 0x0)
bpf$PROG_LOAD(0x5, &(0x7f0000000840)=3D{0x3, 0xf, &(0x7f0000000900)=3D@ri=
ngbuf=3D{{}, {{0x18, 0x1, 0x1, 0x0, r0}, {}, {}, {0x85, 0x0, 0x0, 0xc2}},=
 {}, [], {{}, {0x7, 0x0, 0xb, 0x2, 0x0, 0x0, 0x1}, {0x85, 0x0, 0x0, 0x84}=
}}, &(0x7f0000000980)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, =
@fallback=3D0x2d, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, =
0x0, 0x0}, 0x94)

4m34.19014378s ago: executing program 4 (id=3D11310):
r0 =3D openat$uhid(0xffffffffffffff9c, &(0x7f0000000040), 0x800, 0x0) (as=
ync)
close(0x3) (async, rerun: 32)
syz_open_dev$tty1(0xc, 0x4, 0x3) (async, rerun: 32)
getsockopt$sock_cred(0xffffffffffffffff, 0x1, 0x11, &(0x7f0000001080)=3D{=
<r1=3D>0x0}, &(0x7f00000010c0)=3D0xc) (async)
r2 =3D syz_open_procfs(0x0, &(0x7f0000000100)=3D'net/if_inet6\x00') (asyn=
c)
r3 =3D fanotify_init(0x2, 0x60000)
fanotify_mark(r3, 0x641, 0x4800002a, r2, 0x0)
syz_open_procfs(r1, &(0x7f0000001100)=3D'net/rt_cache\x00') (async)
writev(r0, &(0x7f0000000000)=3D[{&(0x7f0000000080)=3D"49e36ec03943c3826ff=
7c5242444362e505193f9a0e871ae947d6f66a54546c178f22fd85cc3221773d4a411bd0b=
9f09001aa2c9db97fcdbcd8d9998ac66e3cabc7805f36dac532726750f769097ef5cd6bf5=
533c0685df5c70f63191c061a2d34008760037bc9bcb6b39ca4d4bd5cef7636cdf53b924a=
5477ca98fd6b7f32f94bf1e3c7ed25af7818523f486527b9fce05b4d5b2742bda29bc4b83=
d3b10f92758869b98d565cf8a2af1c2cce68404f77779b212a3100947c5a32eff59c2fc9c=
877a87dd44abfca02abbeb10b5266a79080b55b04c3ac3251ad62ada2075a0c877e8b46f1=
049d6f7cce4d56208b418878aae12cbbd04ed24401685df006bfb6c180e9f32ede80cbd94=
f69fb4916aca6d33282633efea47a57498f587b83eb1b3c086285817c0b21908aaa67fece=
b6e64b31e9252ca94f0a7d7dde2aac51cfeedfd1d06b32fef37cd63798072ef48201ff8f1=
78ef90046d9480e1823cb63307007e400edd8b30efdb5018239960164f262fa3cb538bb3f=
21cdb5bf2ffab21319f4b388d0d0af0706b3bd76663c7a57fc183959a4234c028f38c8465=
2e184063b4c76d4f9480444b039fa76c8653cbf96bb5c8d4e8cef4cf3fb8ed7672cfba251=
672fff34867f241bccaa2828cbaff4755b0e67ec520e1a15509d63965756ecf6462284f2f=
039497bd3b4244ce20380e4305be24a3695519cb61a27fb3fb3acc1f0d8080c84e08eae6b=
eb8b626e1d1c6ef8c9b53fa4ff0cab17c0d40fa5611ce24f461a62b3ccd28b7b66972a16b=
5082ec94aa9e0c726e4c394b52b7b9383ac170068eb72a22facebe36df5dde910f72ae954=
bc6dbe3f4ebd481b21addb84cda690266b1b1325487dc8c4505a681ec6158511139aec5fd=
df8458bf7fc9dfa7d8c7185e7c2817aeca65f0806caf0b4a2a32baed0168a406cc3df9d56=
f13caab6f3b39898908ee87e74f689bfbf6c6079c3a731ca010fcdd3a131302c0898d6df8=
2d6b3c29d76397b086f254914b302ca99c4c40f42fdbb246b987639fee0cecf8934694ae6=
cebcf5ab9a7481f9f8c2f6bafbfb0847771c0373281f48080de195f67caa156fa0838e043=
bc236e6637ff324499bf9224d9574fb08aecb80fe9dd6e4d69147897a64c90f56c671df62=
0c08ad72f4a11f36500f3428ee04493160c18f9d54919af564966191d20b5c06d51c24c1f=
185a742f0f1f0ed5bbbe5d498c7b8abd357db3c4efb17fca2167ab4882b90e91299aa09b7=
af9fb7481cdbde532a022df7a6a516f7816e82fff3f6bb44d0b8be5abb046bd0756a243d3=
2b31cc0938284fc1a13158dcd32fb779475e5ceacb682cb179190c5c1c6730ebd8b129ce0=
71b7a81fa2c41ecb98a2b369c21a0dc9427d13790b58a55b38ce1e5543c6c61ccf4d5d94d=
ff1f4c1e8190edc766938bae7c29e0d7e32c13c2e63e0d7737dfefe3321d0e4405bbbdc4d=
6daee7bd44bd785152f9e8924eed878983033963e205d15a4448d08fa161b141a520c7972=
0f31331e34e8da997847a19acca5cc9364f024ed007f791487fcbd2f85d3ae65cb254f1eb=
8f9ec82056f14c8bb9dd4b0fa3a71cfcc9fe1a87d19f6ddc68be2a02f107c08261030cda4=
8ea02e8d0b1bbdbc17a7ae6f3854d66dc332af65e723390d681e35cd7e87ddbfbbb2623ae=
7b877a676be11199dd6d3408bc68c82a1b1bc413fb7ce73169d842544b055e2d156ffab36=
53cdcedd63ac6d9438a8ad3692599e8b27592cb430bf2a2070114aaa007bc878a4ac854d5=
fa76354bba40c4e955f87979487e2d742f105eb8a17570001911103c7e706b2e8c56a1462=
2b823a033e3e7c2a574fbd1e41e3f5d0d7d89b7708424305f0525875ecbb9f5e6aedc27ec=
66ac9f962e439bce3ac5cd49b7ef2fa865f07c479b2e355c668d30148e3eb4559c3d09fe3=
9d84f6ead5be2f3f2305538c7f2a8c1abf0ef4f5bbe5b3d1ec29030caf2d7e0a8e5fc3ba0=
0ccca80ca7f9bcb7e9d5de61d9fa7d71935840c95ab013c7d47efd7f8802bb9d76006c18f=
aa7a3a452662f47ee62edd2626d4d082efa725c868c2dd2a741105e260999c4741fefb49b=
dc97503f1c96174d7c47a764a7d9f826444e4f6697efe27668fad2a7bf3778c3eae06d396=
059f384109a0108916b4c9d4048a5836941dafb9f7ff7738806268bfc0e44883089bcdd91=
b41909e5e5d7bdc6bf4997fcbf522867c93165bec2c0c4597a4d949ea5f2e9c80fc0e75bc=
17e5d66bd627e20eff426f2c405041ffeb2836bece3c3138db30cade658945588d120d84e=
e5a89c681d92bb940555b222548a602bcf2e289b2a79995092d9ed99e640440bbb94833e3=
cd347ee40582682469c5d1c2979659d9d514e71d8c44f1aafdb1bb92cef838201fbbcf50b=
2623f662ca234ef567195b2b694908b943e10465f95441aee6b69334d3bee906d57a0a260=
3a378f7d0b1c8e1fd93d602829e12e0bc5c5f08534bf6ef015055286920739b62913b41d4=
b3fecc25916f5944db401e0ab737b845b73c55beaa34487c801bc2a87e51e272e09d5a976=
4579a029f4c1a11f8d34fae5082ddf7d2efe13e79e0a93cfaa3ad1fc2c39895a2f29c9a8b=
58ab8339fc459090914809fadcaa70ef085908a83f124878a7154fd14388fe6a08782bcbd=
a0a57e233dc7bae135658ad76a90d9f48ba0434f31963c563b7a599961a172fe527a10246=
da878716ea5a4a71be269f592142e35ef822c9f6ca68349d2ed6327b5fb537a0636aab065=
0f87ca50b2c22b6e7523bea0f32003b33cf8bb0236cb85d2744d5b6b71e5d3b390e7cb8f7=
1ebb00329e2602519000ddab9716350cfde44c6ee41c51c5be95907dfc4f55fcb69abe38f=
2d0bd8a374229bfd87ce8581a6000b354804174dc81aa6a00f88fa28429ff262b2399aeb2=
fbb26332eeeca24ed6510923933ec3543138dbb9f243d7e6a949125c4477c04a3f8a44890=
86216fd8b4a1a350fb53a0190859a4bd2041c9663a735a5ea942558a3fbe54bdc2b959941=
4db27b8a53a2b4cfd8b710f48094642a10623ad19f016e3fb72d4c4e85347fccd8d0b6c38=
71b812cf6c976686a5a73917d79c6470520928747fe361bc8cf14e401c74222e775eaf6ce=
faea66e7109ac3263e7342faad1140f3aaa6714dc5d37b085f83ca598ccad60590e5e1d04=
a9398878b4fe00030507ef01526a862f94b1a7694c5cc52d5998e5125d2295cd15a0a1dc5=
c481b9a314206e64bd16ef31187fb7adcc84e2a9372c5d5fd3deefa27b595577ccafbbaab=
dd54afe4b055e78f6c5d8d5dcbe686d6dabf287dd4d04e045c7ce31baec852c572a43bb79=
cce3002445b1ac5e43237910af67e374fca3d4b828cd1ece33cbdadb60e9ca759be00ec3c=
e2bfcece24042cf8cec6865579ed413eb23c09318e4eb171c69eb465d1e928d4769bec2bd=
bf86e44e10f5972ce7b22f2369f8a37a5c1cce73b99144cf03ed946fd70e1a678f1f2b7f3=
1b8ed3e64d16743f64a4ff94837572e8fbd54f2df12ec74cd8e20a71f765b34a75c581d2a=
5b652c250c9476d3bd522e9dab2a7c0bf77a78c0288d96ba87b767594a6fa8569998943bc=
97824b4859f8048c95a6f482313d569d30d74f5144e2a7156d162121b53cf6719e9b69414=
b972601cdb83f25c6ad870aa5d8366ca07f91e597b03fc6d23f708670bef10087e3b47999=
e1249f2d48226b24e0cb233b1e7a83ffadfc9a9aae28ea48d1bdd5acb4a5f30605d54be44=
c8dc119f1fa8986c85cafab2f53e7438b2f447107690f34e71f02f475209edaa74e45753d=
1dc391c4fe813ed9a24f54bd669c6033a8e09c67e929a0e0943d54d694d9f0858a45dbd54=
1e056358db9a513b958cf8ae8ce7b317548d8518d3fe12b50661d493ac0d073fe590b1d58=
7433cfcd7086fbfb88da60251e39add419a184e0cdbc01b9254ea58e8041384d67f98e7e2=
866f92c75d1f0f658f6628677b7daa6b8dfc6f9a9f7c6e8b3320417fe2f63a13ed15f8220=
66541d527d82f27f5965c2eeae443335efabf13460eabce85e4e253c08a5dc3b748f80e34=
f1de0d3777aa8bce236eb4a986cf5119b2eae3a40cf257fb3407bfd664204c6556ea00d21=
962804b296fb51487189a230f500fd017aa40a8c14aca566da77415f0116e253a0198d105=
88e3fe9f4109cd6c5c424fa578a6af33d8fe2363500b51d0c0aa594afd82c81926a3aea92=
e620796a1edfc0e1a880bc2c4338fcea72e839153579f687d28727f38f15c749f8fc9e523=
ecf7e94675997ab98eb319611b3bedc078149aa6bb99b61f46acdbb707f910829f70cd824=
6a0561c3860d8a3ea3cc327727adf7ff60cedfea1e2cc40b842cdcaf9decf63f4ab8734a6=
f1ce0c2bd025ff546c57b3b83484357e7d3b0c9e2d44f28a9d21bb58b361b800957d886a4=
dc20aa3390ea50ae16744e58b1e92327ddd486795dbb36403e2d7f45439df98bb790b1df7=
7966d56560291c0e00e5872dc7690554a1807c69f1bd846e96e73565b701ac6aa898449e2=
c3814c25f7c00ef19ec7e922c426894b015816229e6eaa7dfa64f16d1cc2af4abf61cb01b=
0b900631aa6a453bc9a20fd3e6817ee9086ed264eb6022c4da3c172b6b6c90059991d178c=
fc780526cc448f9003c3fce64bed71bef01976cdd9dc97b56f2ab02f174f8d612c5b3faf4=
6cbed444191d1b7e4105f25467dcea0b114f090a79f5b4e6a95d85aeb1c3b664fceeab7ad=
6650a20de4d5ba1c91c83c5d5c94f2331ae31a39cddb5ad4291593ebc17e44cb3148f9ce0=
390a969ca2db2e9728df041ceaee558c8dc2a87a3c20f13b6a842e91f48a8421a8a644c3d=
530373150738d6760c2b502b8fcf8ee04218d53eb5d922f714fd61d5f4cff6e9ba0c06b50=
ad351c7f2daa3d34117587814d0c58defbffef5dba6db0f2bd1723e64cb8008bf374cf183=
18b00ad82b34a5c1929b75efc6bdc70e06770e6f0328c83a7cc04db6f990b0897733b7e22=
64bb77cd05730d61e5c1da4779af81f2e6f50181fb3dc9d1ecfedb80d8221b235e2ea7000=
37cd1a2697a55fb1e5355c9706c00b17dbc75e587e2c24b7d85e7a7d05065f76206e4133c=
8a389cd37a4aa0ed4e2a40dee77c279cc75af489eab3614899b253096f5082dde64b0f4ce=
f7a9e3dc1dd3814d872273ae98ecb8785f0cb9a175a2521defd351764f58ed8925fa54513=
59ac16fe296936016e4542c6ff739023834924e2b8951a8f357cee9538b8515545c7e9b1d=
820dc0f6a7dee035251c78c8056f983dd18adca89f797f80f4ec4be963657fdb013d17b0d=
fffcdb9e4b24bd0f99a0cbf353e7c8f8e7ca3689a8a0bac3c2ee8f27881869dd666785385=
005872e0424360698f407a1ffcce8e27fcecf64000193af3586a821564858c97e61892143=
fa8fedef634f28c26b7001c1727500732b0828c7bf2985619b1484f023b5a7ca537d906c6=
6f6cbdaaa5feac317f315302389324f7fdc8fc22eb4e31a787d90870527e07c53dc95bfb3=
6106a262dff68fe0d2daa78578e94c8445b59d63f1bcd1a4c3acb64047f50d1c9d7855237=
6f1653660d7f7bf0d29dc282627fe6708c9cea90599943f9b1b8f138022913cbcb7491efe=
31ebd6c8b0e909bc5ad5fae2be8483f1a624e3e09ef76e170df8fe7a67befe2252d13598b=
8ef8415baa7c900df8771b271eea5d5f582119571e30f09fd46db013f80cb589bbdfa7333=
7296b4ec5116c9ecb9a789b9b373b6d", 0xfc8}], 0x1)

4m34.18295586s ago: executing program 4 (id=3D11313):
close(0x3)
socket$inet6_sctp(0xa, 0x1, 0x84)
r0 =3D syz_create_resource$binfmt(&(0x7f0000000ac0)=3D'./file0\x00')
r1 =3D openat$binfmt(0xffffffffffffff9c, r0, 0x41, 0x1ff)
r2 =3D openat$snapshot(0xffffffffffffff9c, 0x0, 0x401, 0x0)
write$snapshot(r2, &(0x7f0000000080), 0x0)
sendmsg$unix(0xffffffffffffffff, 0x0, 0x20000045)
read$FUSE(0xffffffffffffffff, 0x0, 0x0)
madvise(&(0x7f0000c00000/0x400000)=3Dnil, 0x400000, 0x19)
mprotect(&(0x7f0000400000/0xc00000)=3Dnil, 0xc00000, 0x5)
bpf$MAP_CREATE(0x0, 0x0, 0x50)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x0, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0, 0x3}, 0x23a4, 0x7, 0x2, 0x1, 0xffffffff, 0xd1, 0xac6f,=
 0x0, 0x0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x5)
r3 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0)
mount$fuse(0x0, &(0x7f00000020c0)=3D'./file0\x00', &(0x7f0000002100), 0x8=
00c16, &(0x7f0000002140)=3D{{'fd', 0x3d, r3}, 0x2c, {'rootmode', 0x3d, 0x=
4000}})
read$FUSE(r3, &(0x7f00000021c0)=3D{0x2020, 0x0, 0x0, <r4=3D>0x0}, 0x2020)=

quotactl$Q_GETQUOTA(0xffffffff80000701, &(0x7f0000000040)=3D@filename=3D'=
=2E/file0/file0\x00', r4, 0x0)
setfsuid(r4)
syz_genetlink_get_family_id$mptcp(&(0x7f0000000180), 0xffffffffffffffff)
sendmsg$MPTCP_PM_CMD_SUBFLOW_CREATE(0xffffffffffffffff, &(0x7f0000000240)=
=3D{&(0x7f0000000140)=3D{0x10, 0x0, 0x0, 0x80000}, 0xc, 0x0, 0x1, 0x0, 0x=
0, 0x40}, 0x42041)
bind$alg(0xffffffffffffffff, &(0x7f00000000c0)=3D{0x26, 'rng\x00', 0x0, 0=
x0, 'drbg_nopr_hmac_sha1\x00'}, 0x58)
ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
0080)=3D{0x1, 0x1, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0xa, 0x8, 0xb8, 0x0,=
 0x7fe, 0x2, 0x0, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1=
, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x6, 0x1, @=
perf_bp=3D{0x0, 0x4}, 0x280, 0x5, 0x2, 0x4, 0xffffffff, 0x9, 0x2, 0x0, 0x=
4, 0x0, 0x10000061}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0x8)
write$snapshot(r2, 0x0, 0x0)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x6, 0x2, 0x1, 0x0, 0x0, =
0x7ff, 0x140c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x1, 0x4=
, @perf_config_ext=3D{0x4006, 0xffffffffffff64f9}, 0x100081, 0x0, 0xc0000=
00, 0x1, 0xffffffff, 0xd1, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xfffffffffff=
fffff, 0xffffffffffffffff, 0xb)
setsockopt$IP6T_SO_SET_REPLACE(0xffffffffffffffff, 0x29, 0x40, 0x0, 0x0)
fcntl$setlease(r1, 0x400, 0x1)
unlinkat(0xffffffffffffff9c, &(0x7f00000003c0)=3D'./file0\x00', 0x0)
close(0x3)
close(0x3)

4m34.06997316s ago: executing program 7 (id=3D11317):
r0 =3D openat$procfs(0xffffffffffffff9c, &(0x7f0000000000)=3D'/proc/cpuin=
fo\x00', 0x0, 0x0)
r1 =3D inotify_init1(0x80800)
chdir(&(0x7f0000000040)=3D'./file0\x00')
inotify_add_watch(r1, 0x0, 0x110)
read$FUSE(r1, 0x0, 0x0)
io_setup(0x4, &(0x7f0000000100)=3D<r2=3D>0x0)
io_submit(r2, 0x1, &(0x7f00000001c0)=3D[&(0x7f0000000080)=3D{0x0, 0x0, 0x=
0, 0x3, 0x72, r0, 0x0, 0x0, 0x0, 0x0, 0x48513e785bbddea2}])
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
perf_event_open(&(0x7f0000000200)=3D{0x4, 0x80, 0x5, 0xa, 0x2, 0x1, 0x0, =
0x7fe, 0x200c0, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{&(0x7f0000000180), 0x8}, 0x118394, 0x7, 0x2, 0x5, 0xfffffff=
f, 0x9, 0xac6e, 0x0, 0x81, 0x0, 0x61}, 0x0, 0xffffffffffffffff, 0xfffffff=
fffffffff, 0x2)

4m23.7688792s ago: executing program 4 (id=3D11323):
r0 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
r1 =3D openat$tun(0xffffffffffffff9c, &(0x7f0000000040), 0x109142, 0x0)
r2 =3D openat$tun(0xffffffffffffff9c, &(0x7f0000000040), 0x109142, 0x0)
ioctl$TUNSETIFF(r2, 0x400454ca, &(0x7f0000000080)=3D{'virt_wifi0\x00', 0x=
1112})
ioctl$TUNSETIFF(r1, 0x400454ca, &(0x7f0000000080)=3D{'virt_wifi0\x00', 0x=
1112})
r3 =3D openat$fuse(0xffffffffffffff9c, 0x0, 0x2, 0x0)
ioctl$TUNSETDEBUG(r1, 0x400454c9, &(0x7f00000001c0)=3D0x3)
socket$nl_route(0x10, 0x3, 0x0)
read$FUSE(r3, &(0x7f00000015c0)=3D{0x2020, 0x0, <r4=3D>0x0}, 0x2020)
r5 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002000), 0x2, 0x0)
r6 =3D getuid()
r7 =3D getgid()
syz_mount_image$fuse(&(0x7f0000002040), &(0x7f0000002080)=3D'./file0\x00'=
, 0x0, &(0x7f00000020c0)=3DANY=3D[@ANYBLOB=3D'fd=3D', @ANYRESHEX=3Dr5, @A=
NYBLOB=3D',rootmode=3D00000000000000000040000,user_id=3D', @ANYRESDEC=3Dr=
6, @ANYBLOB=3D',group_id=3D', @ANYRESDEC=3Dr7], 0x0, 0x0, 0x0)
fstat(r0, &(0x7f0000000100)=3D{0x0, 0x0, 0x0, 0x0, 0x0, <r8=3D>0x0})
write$FUSE_ATTR(r3, &(0x7f0000000200)=3D{0x78, 0x0, r4, {0x3ff, 0x7, 0x0,=
 {0x0, 0x4fa2, 0x0, 0x5, 0xf, 0x8000000000000000, 0x2b80000, 0x6, 0x6, 0x=
1000, 0xff, r6, r8, 0x80, 0x7}}}, 0x78)
write$tun(r2, &(0x7f00000000c0)=3D{@val=3D{0x0, 0x6005}, @val=3D{0x0, 0x0=
, 0xffff, 0x8, 0x0, 0x8000}, @arp=3D@ether_ipv4=3D{0x1, 0x800, 0x6, 0x4, =
0x4, @empty, @empty, @remote, @rand_addr=3D0x64010102}}, 0x2a)
sendmsg$IPSET_CMD_CREATE(r0, &(0x7f0000000580)=3D{0x0, 0x0, &(0x7f0000000=
540)=3D{&(0x7f0000000000)=3D{0x58, 0x2, 0x6, 0x101, 0x0, 0x0, {0x3, 0x0, =
0x6}, [@IPSET_ATTR_FAMILY=3D{0x5, 0x5, 0xa}, @IPSET_ATTR_REVISION=3D{0x5}=
, @IPSET_ATTR_PROTOCOL=3D{0x5}, @IPSET_ATTR_SETNAME=3D{0x9, 0x2, 'syz0\x0=
0'}, @IPSET_ATTR_DATA=3D{0xc, 0x7, 0x0, 0x1, [@IPSET_ATTR_TIMEOUT=3D{0x8,=
 0x6, 0x1, 0x0, 0x8}]}, @IPSET_ATTR_TYPENAME=3D{0x11, 0x3, 'hash:ip,port\=
x00'}]}, 0x58}, 0x1, 0x0, 0x0, 0xc0}, 0x804)

4m23.76829832s ago: executing program 7 (id=3D11324):
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
r0 =3D socket$nl_route(0x10, 0x3, 0x0)
r1 =3D socket$inet_icmp(0x2, 0x2, 0x1)
mmap(&(0x7f0000fef000/0x10000)=3Dnil, 0x10000, 0x0, 0x13, r1, 0xa6b19000)=

r2 =3D socket$nl_route(0x10, 0x3, 0x0)
ioctl$sock_SIOCGIFINDEX(r2, 0x8933, &(0x7f0000000000)=3D{'bridge_slave_1\=
x00', <r3=3D>0x0})
sendmsg$nl_route(r2, &(0x7f0000001540)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000400)=3DANY=3D[@ANYBLOB=3D"580000001000010029bd7000fadbdf2500=
000000", @ANYRES32=3D0x0, @ANYBLOB=3D"67300100f34003001400030062726964676=
55f736c6176655f30000024001280110001006272696467655f736c617665000000000c00=
058008002200", @ANYRES32=3Dr3, @ANYBLOB=3D"795641b6ab96cb134c8c8862169b28=
c2c658a3b740f1254678948db28e9232a2f9d452567fa7007a0c6980dd2b7573f15483da6=
0886c33582679ee5c3fdcd3f1b9b0e5a792c4c449f457cd0079beba"], 0x58}, 0x1, 0x=
0, 0x0, 0x400d0}, 0x240008d4)
r4 =3D socket$inet_sctp(0x2, 0xa, 0x84)
sendmmsg$inet_sctp(r4, &(0x7f0000004800)=3D[{&(0x7f00000005c0)=3D@in=3D{0=
x2, 0x4e22, @remote}, 0x12, 0x0, 0x0, 0x0, 0x0, 0x4400}], 0x1, 0x40000)
prctl$PR_SET_MM_MAP(0x23, 0xe, &(0x7f0000000000)=3D{&(0x7f00004e1000/0x30=
00)=3Dnil, &(0x7f0000ffe000/0x1000)=3Dnil, &(0x7f00005b3000/0x2000)=3Dnil=
, &(0x7f0000ffc000/0x4000)=3Dnil, &(0x7f0000ff0000/0xd000)=3Dnil, &(0x7f0=
000ff9000/0x4000)=3Dnil, &(0x7f0000b04000/0x1000)=3Dnil, &(0x7f0000ffb000=
/0x4000)=3Dnil, &(0x7f0000ffb000/0x1000)=3Dnil, &(0x7f0000b03000/0x2000)=3D=
nil, &(0x7f0000ffc000/0x2000)=3Dnil, 0x0}, 0x68)
r5 =3D openat$vsock(0xffffffffffffff9c, &(0x7f0000000240), 0x10000, 0x0)
ioctl$F2FS_IOC_GARBAGE_COLLECT(r5, 0x4004f506, &(0x7f0000000300))
r6 =3D socket$inet6_sctp(0xa, 0x1, 0x84)
getsockopt$inet_sctp6_SCTP_SOCKOPT_CONNECTX3(r6, 0x84, 0x6f, 0x0, &(0x7f0=
000000100)=3D0xf00)
sendmsg$nl_route(r0, &(0x7f00000002c0)=3D{0x0, 0x0, &(0x7f0000000280)=3D{=
&(0x7f00000004c0)=3D@ipv4_delroute=3D{0x24, 0x19, 0x1, 0x70bd2d, 0x25dfdb=
ff, {0x2, 0x14, 0x80, 0xe, 0x0, 0x3, 0x0, 0x0, 0x1600}, [@RTA_DST=3D{0x8,=
 0x1, @broadcast}]}, 0x24}, 0x1, 0x0, 0x0, 0x2}, 0x200048c4)
mount$tmpfs(0x0, &(0x7f00000000c0)=3D'./file0\x00', &(0x7f0000000140), 0x=
200000, 0x0)
r7 =3D socket$nl_generic(0x10, 0x3, 0x10)
ioctl$sock_SIOCETHTOOL(r7, 0x8946, &(0x7f0000000040)=3D{'veth1_to_batadv\=
x00', &(0x7f0000000000)=3D@ethtool_rxfh=3D{0x47, 0x5, 0x8, 0x2, 0xd, "1cf=
d52", 0x7fff}})
mount$tmpfs(0x0, &(0x7f00000000c0)=3D'./file0\x00', 0x0, 0xa00002, &(0x7f=
00000003c0)=3DANY=3D[@ANYRESOCT=3Dr3])
r8 =3D syz_open_dev$tty1(0xc, 0x4, 0x3)
socket$inet6_udp(0xa, 0x2, 0x0)
r9 =3D bpf$PROG_LOAD(0x5, &(0x7f0000000600)=3D{0x6, 0xb, &(0x7f0000000800=
)=3DANY=3D[@ANYBLOB=3D"18000000010000000000000074ab0000180100002020702500=
000000002020207b1af8ff00000000bfa100000000000007010000f8ffffffb7020000080=
00000b703000006000000850000000600000095"], &(0x7f0000000ac0)=3D'GPL\x00',=
 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @fallback=3D0x9, 0x0, 0x0, 0x0, 0x=
0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x3ff}, 0x94)
r10 =3D socket$netlink(0x10, 0x3, 0xa)
ioctl$sock_SIOCGIFINDEX(r10, 0x8933, &(0x7f0000000180)=3D{'syz_tun\x00', =
<r11=3D>0x0})
bpf$BPF_LINK_CREATE_XDP(0x1c, &(0x7f0000000200)=3D{r9, r11, 0x25, 0x4, @v=
oid}, 0x10)
r12 =3D socket$nl_generic(0x10, 0x3, 0x10)
sendmsg$nl_generic(r12, &(0x7f0000000200)=3D{0x0, 0x0, &(0x7f00000001c0)=3D=
{&(0x7f0000000040)=3DANY=3D[@ANYBLOB=3D"1c0000002500230a2abd7000fcdbdf250=
700000008000880"], 0x1c}, 0x1, 0x0, 0x0, 0x40004}, 0x800)
ioctl$sock_ipv6_tunnel_SIOCADDTUNNEL(r5, 0x89f1, &(0x7f0000000080)=3D{'ip=
6_vti0\x00', &(0x7f0000000180)=3D{'syztnl0\x00', r11, 0x4, 0x6, 0x1, 0x1,=
 0x37, @remote, @dev=3D{0xfe, 0x80, '\x00', 0xd}, 0x80, 0x8, 0x9, 0x969}}=
)
ioctl$TIOCGLCKTRMIOS(r8, 0x5456, &(0x7f0000000500)=3D{0x10000, 0x2, 0xb84=
6, 0x8, 0x1a, "87d29bd4c03a824fa3c43df94f4659aae1c063"})
getsockopt$inet_sctp6_SCTP_FRAGMENT_INTERLEAVE(r5, 0x84, 0x12, &(0x7f0000=
000340), &(0x7f0000000380)=3D0x4)

3m58.37244239s ago: executing program 7 (id=3D11327):
socket$inet_sctp(0x2, 0x1, 0x84)
r0 =3D openat$zero(0xffffffffffffff9c, &(0x7f0000000040), 0x0, 0x0)
read$FUSE(r0, &(0x7f0000006400)=3D{0x2020}, 0xfffffe1c)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
r1 =3D openat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file1\x00', 0x42=
, 0x1ff)
renameat2(0xffffffffffffff9c, &(0x7f0000000480)=3D'./file0\x00', 0xffffff=
ffffffff9c, &(0x7f0000000340)=3D'./file1\x00', 0x2)
r2 =3D syz_create_resource$binfmt(&(0x7f0000001400)=3D'./file0\x00')
r3 =3D openat$binfmt(0xffffffffffffff9c, r2, 0x42, 0x1ff)
write$binfmt_elf64(r3, &(0x7f00000000c0)=3DANY=3D[], 0xffffffa1)
mmap$perf(&(0x7f0000400000/0xc00000)=3Dnil, 0xc00000, 0x1000005, 0x13, r1=
, 0x0)
ioctl$AUTOFS_DEV_IOCTL_OPENMOUNT(0xffffffffffffffff, 0xc0189374, &(0x7f00=
00000080)=3D{{0x1, 0x1, 0x18, 0xffffffffffffffff, {0xe1}}, './file0\x00'}=
)
close_range(0xffffffffffffffff, 0xffffffffffffffff, 0x2)
ppoll(&(0x7f0000000080), 0x2000000000000073, 0x0, 0x0, 0x0)
keyctl$link(0x8, 0x0, 0x0)
madvise(&(0x7f0000c00000/0x400000)=3Dnil, 0x400000, 0x19)
r4 =3D openat$ppp(0xffffffffffffff9c, &(0x7f0000000000), 0x200, 0x0)
r5 =3D openat$autofs(0xffffffffffffff9c, &(0x7f00000000c0), 0x8001, 0x0)
ioctl$AUTOFS_DEV_IOCTL_CLOSEMOUNT(r5, 0xc0189375, &(0x7f00000002c0)=3D{{0=
x1, 0x1, 0x18, r4}, './file0\x00'})

3m58.36363387s ago: executing program 7 (id=3D11333):
r0 =3D openat$procfs(0xffffffffffffff9c, &(0x7f0000000040)=3D'/proc/mdsta=
t\x00', 0x0, 0x0)
preadv(r0, &(0x7f0000000240)=3D[{&(0x7f0000000200)=3D""/1, 0x1}], 0x1, 0x=
1, 0x401)
ioctl$TIOCSISO7816(r0, 0xc0285443, &(0x7f0000000000)=3D{0x6b14, 0x3, 0x2,=
 0xfffffffd, 0x80000000})
read$FUSE(r0, &(0x7f0000000280)=3D{0x2020, 0x0, <r1=3D>0x0}, 0x2020)
write$FUSE_INIT(0xffffffffffffffff, &(0x7f0000000080)=3D{0x50, 0xffffffff=
ffffffda, r1, {0x7, 0x2b, 0x4, 0x48002010, 0x8001, 0x0, 0x8000, 0x10000, =
0x0, 0x0, 0x80, 0x6}}, 0x50)

3m58.3600685s ago: executing program 4 (id=3D11335):
capset(&(0x7f0000000000)=3D{0x20071026}, &(0x7f0000000080)=3D{0x0, 0x3, 0=
x2000000, 0xffffffff, 0xffffffff})
r0 =3D socket$alg(0x26, 0x5, 0x0)
bind$alg(r0, &(0x7f0000000240)=3D{0x26, 'aead\x00', 0x0, 0x0, 'ccm(sm4)\x=
00'}, 0x58)
setsockopt$ALG_SET_KEY(r0, 0x117, 0x1, &(0x7f0000001700)=3D"998115bda7931=
e59edfe5ccb0b4856d1", 0x10)
r1 =3D accept4(r0, 0x0, 0x0, 0x800)
sendmmsg$alg(r1, &(0x7f0000000040)=3D[{0x0, 0x0, 0x0, 0x0, &(0x7f00000001=
80)=3D[@op=3D{0x18, 0x117, 0x3, 0x1}], 0x18, 0x10}], 0x1, 0x0)
recvmmsg(r1, &(0x7f0000000c00)=3D[{{0x0, 0x0, &(0x7f00000001c0)=3D[{&(0x7=
f0000000080)=3D""/207, 0xcf}, {&(0x7f00000002c0)=3D""/91, 0x5b}], 0x2}, 0=
x6}, {{&(0x7f0000000340)=3D@nl=3D@proc, 0x80, &(0x7f0000000200)=3D[{&(0x7=
f00000003c0)=3D""/100, 0x64}, {&(0x7f0000000500)=3D""/108, 0x6c}, {&(0x7f=
0000001740)=3D""/4096, 0x1000}], 0x3, &(0x7f0000000580)=3D""/146, 0x92}, =
0x401}, {{&(0x7f0000000640)=3D@ax25=3D{{}, [@null, @default, @bcast, @rem=
ote, @null, @bcast, @null, @rose]}, 0x80, &(0x7f0000000ac0)=3D[{&(0x7f000=
0000440)=3D""/40, 0x28}, {&(0x7f00000006c0)=3D""/20, 0x14}, {&(0x7f000000=
0700)=3D""/141, 0x8d}, {&(0x7f00000009c0)=3D""/202, 0xca}], 0x4, &(0x7f00=
00000b00)=3D""/197, 0xc5}, 0x1}], 0x3, 0x40000100, 0x0)
r2 =3D bpf$MAP_CREATE_RINGBUF(0x0, &(0x7f00000007c0)=3D{0x1b, 0x0, 0x0, 0=
x40000, 0x0, 0x0, 0x0, '\x00', 0x0, 0x0}, 0x48)
r3 =3D bpf$PROG_LOAD(0x5, &(0x7f0000000840)=3D{0x5, 0xf, &(0x7f0000000900=
)=3D@ringbuf=3D{{}, {{0x18, 0x1, 0x1, 0x0, r2}}, {}, [], {{}, {0x7, 0x0, =
0xb, 0x2, 0x0, 0x0, 0x1}, {0x85, 0x0, 0x0, 0x24}}}, &(0x7f0000000980)=3D'=
GPL\x00', 0x8, 0x0, 0x0, 0x0, 0x7, '\x00', 0x0, @fallback=3D0x1f, 0x0, 0x=
0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
bpf$TOKEN_CREATE(0x24, &(0x7f0000000040)=3D{0x0, r3}, 0x8)
r4 =3D bpf$BPF_BTF_LOAD(0x12, &(0x7f0000000000)=3D{&(0x7f0000000980)=3DAN=
Y=3D[@ANYBLOB=3D"9feb010018000000000000000c0000000c0000000500000003000000=
000000060400000000615f2e"], 0x0, 0x29, 0x0, 0x1, 0x618}, 0x28)
r5 =3D bpf$MAP_CREATE_TAIL_CALL(0x0, &(0x7f00000000c0)=3D{0x3, 0x4, 0x4, =
0xa, 0x0, 0xffffffffffffffff, 0x80000000, '\x00', 0x0, r4, 0x1, 0x1}, 0x5=
0)
bpf$MAP_LOOKUP_ELEM(0x1, &(0x7f0000000340)=3D{r5, 0x0, 0x0, 0x4}, 0x20)
r6 =3D bpf$MAP_CREATE_RINGBUF(0x0, &(0x7f00000000c0)=3D{0x1b, 0x0, 0x0, 0=
x40000, 0x0, 0x0, 0x0, '\x00', 0x0, 0x0}, 0x50)
read$FUSE(0xffffffffffffffff, &(0x7f0000004640)=3D{0x2020, 0x0, 0x0, 0x0,=
 0x0, <r7=3D>0x0}, 0x2020)
perf_event_open(&(0x7f0000000d00)=3D{0x1, 0x80, 0xc9, 0xc, 0x5, 0xff, 0x0=
, 0x401, 0x10202, 0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, =
0x0, 0x1, 0x1, 0x1, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1=
, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x4, 0=
x1, @perf_bp=3D{&(0x7f0000000480), 0xf}, 0x7b01, 0xffffffffffffff9f, 0x28=
e, 0x1, 0x2, 0x4, 0xfca, 0x0, 0x5, 0x0, 0xffffffffffffff4b}, r7, 0xc, 0xf=
fffffffffffffff, 0xa)
r8 =3D socket$packet(0x11, 0x3, 0x300)
socket$nl_netfilter(0x10, 0x3, 0xc)
r9 =3D socket$nl_route(0x10, 0x3, 0x0)
read(r9, &(0x7f00000002c0)=3D""/233, 0xe9)
sendmsg$nl_route(r9, &(0x7f00000000c0)=3D{0x0, 0x0, &(0x7f0000000240)=3D{=
&(0x7f0000000400)=3D@ipv6_getmulticast=3D{0x14, 0x3a, 0x203, 0x70bd27, 0x=
25dfdbfc}, 0x14}, 0x1, 0x0, 0x0, 0x80}, 0x800)
r10 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
sendmsg$IPSET_CMD_CREATE(r10, &(0x7f0000000340)=3D{0x0, 0x0, &(0x7f000000=
0300)=3D{&(0x7f0000000080)=3D{0x4c, 0x2, 0x6, 0x905, 0x0, 0x0, {0x7, 0x0,=
 0xa}, [@IPSET_ATTR_PROTOCOL=3D{0x5}, @IPSET_ATTR_FAMILY=3D{0x5, 0x5, 0x2=
}, @IPSET_ATTR_SETNAME=3D{0x9, 0x2, 'syz0\x00'}, @IPSET_ATTR_TYPENAME=3D{=
0x12, 0x3, 'bitmap:ip,mac\x00'}, @IPSET_ATTR_REVISION=3D{0x5}]}, 0x4c}, 0=
x1, 0x0, 0x0, 0x4004000}, 0x20000000)
ioctl$ifreq_SIOCGIFINDEX_batadv_hard(r10, 0x8933, &(0x7f0000000cc0)=3D{'b=
atadv_slave_1\x00', <r11=3D>0x0})
sendto$packet(r8, &(0x7f0000000140)=3D"0004000000b082e276c66d000000", 0xe=
, 0x4040cc4, &(0x7f00000004c0)=3D{0x11, 0x3, r11, 0x1, 0xff, 0x6, @remote=
}, 0x14)
bpf$PROG_LOAD(0x5, &(0x7f0000004500)=3D{0x8, 0xf, &(0x7f00000045c0)=3DANY=
=3D[@ANYBLOB=3D"1800000004000000000000000000000018110000", @ANYRES32=3Dr6=
, @ANYBLOB=3D"0000000000000000b702000014000000b70300000000000085000000a00=
00000bf0900000000000075090100000000009500000000000000bf91000000000000b702=
0000000000008500000085000000b70000000000000095"], &(0x7f0000000080)=3D'GP=
L\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @cgroup_skb=3D0x1, 0xffffff=
ffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, =
0x94)

3m58.35780028s ago: executing program 7 (id=3D11337):
mknodat(0xffffffffffffff9c, &(0x7f0000000180)=3D'./file5\x00', 0x61c0, 0x=
700)
sendmmsg$inet6(0xffffffffffffffff, &(0x7f0000000540)=3D[{{0x0, 0x0, &(0x7=
f0000000240)=3D[{&(0x7f0000000080)=3D"c97921d56a843ce2f18f4eb2024c5fd6b13=
d91a39434793fe80023", 0x1b}], 0x1}}], 0x1, 0x15)
ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
0080)=3D{0x3, 0x1, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd) (async)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0xa, 0x8, 0xb8, 0x0,=
 0x7fe, 0x2, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1=
, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x3, 0x1, @=
perf_bp=3D{0x0, 0x4}, 0x300, 0x5, 0x2, 0x4, 0xffffffff, 0x9, 0x2, 0x0, 0x=
0, 0x0, 0x10000061}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0x8) (a=
sync)
r0 =3D openat$dir(0xffffffffffffff9c, &(0x7f0000000000)=3D'./file5\x00', =
0x201, 0x4)
prctl$PR_SET_TAGGED_ADDR_CTRL(0x37, 0x1) (async)
ioctl$FS_IOC_GET_ENCRYPTION_PWSALT(r0, 0x4c02, 0x0)
bpf$BPF_BTF_LOAD(0x12, &(0x7f0000000440)=3D{&(0x7f00000001c0)=3D{{0xeb9f,=
 0x1, 0x0, 0x18, 0x0, 0x18, 0x18, 0x5, [@union=3D{0x0, 0x1, 0x0, 0x5, 0x1=
, 0x6, [{0x3, 0x4, 0x1}]}]}, {0x0, [0x0, 0x30, 0x61]}}, 0x0, 0x35, 0x0, 0=
x1, 0xe8e3}, 0x28) (async)
r1 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002000), 0x2, 0x0)
r2 =3D syz_mount_image$fuse(&(0x7f0000002040), &(0x7f0000002080)=3D'./fil=
e0\x00', 0x0, &(0x7f00000020c0)=3D{{'fd', 0x3d, r1}, 0x2c, {'rootmode', 0=
x3d, 0x4000}}, 0x0, 0x0, 0x0)
syz_fuse_handle_req(r1, &(0x7f0000002180), 0x2000, &(0x7f0000004180)=3D{&=
(0x7f0000004240)=3D{0x50}, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0=
x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}) (async)
syz_fuse_handle_req(r1,
&(0x7f00000042c0)=3D"0000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
00000000000000000000000000000000000000000000000000000000000e6000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000008000",
0x2000, &(0x7f00000062c0)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 &(0x7f0000006380)=3D{0x20, 0xffffffffffffffda}, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0}) (async)
open_by_handle_at(r2, &(0x7f0000000000)=3D@fuse=3D{0xc, 0x81, {0x80000000=
, 0x8, 0xffffffff}}, 0x420400)
r3 =3D syz_open_procfs(0x0, &(0x7f0000000340)=3D'mountinfo\x00')
read$FUSE(r3, &(0x7f0000000480)=3D{0x2020}, 0x2020) (async)
getsockopt$inet_sctp6_SCTP_INITMSG(r3, 0x84, 0x2, &(0x7f0000000040), &(0x=
7f0000000080)=3D0x8)

3m58.30611894s ago: executing program 7 (id=3D11339):
bpf$PROG_LOAD(0x5, &(0x7f0000000c80)=3D{0x3, 0x3, &(0x7f00000003c0)=3D@fr=
amed, &(0x7f0000000500)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0=
, @fallback=3D0x2b, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0=
, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
r0 =3D bpf$MAP_CREATE_RINGBUF(0x0, &(0x7f00000007c0)=3D{0x1b, 0x0, 0x0, 0=
x40000, 0x0, 0x0, 0x0, '\x00', 0x0, 0x0}, 0x48)
r1 =3D syz_open_dev$tty20(0xc, 0x4, 0x1)
openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)=

perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x0, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0xa, 0x4=
, @perf_config_ext=3D{0x7f, 0x7}, 0x101001, 0x8, 0x2, 0x1, 0xffffffff, 0x=
d1, 0xac6f, 0x0, 0x0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x5)
ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
0080)=3D{0x1, 0x1, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
r2 =3D syz_open_dev$tty20(0xc, 0x4, 0x0)
ioctl$TCSETS2(r2, 0x402c542b, &(0x7f0000000040)=3D{0x0, 0xe2c, 0x2, 0x7ff=
, 0x2, "d4af9caca4430493400702b04a4e66a980ec02", 0x7fff, 0x2})
ioctl$TIOCSTI(r2, 0x5412, &(0x7f0000000000)=3D0x9)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x45, 0x9, 0x8, 0xe, 0x0,=
 0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0=
x0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0,=
 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x=
0, @perf_bp=3D{0x0, 0x2}, 0x0, 0x3, 0x2, 0x5, 0xfffffffc, 0x9, 0x3, 0x0, =
0x0, 0x0, 0x65}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
r3 =3D openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x=
2, 0x0)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r3, 0xeb08=
0000)
r4 =3D socket$nl_generic(0x10, 0x3, 0x10)
sendmsg$ETHTOOL_MSG_FEATURES_SET(r4, 0x0, 0x4040810)
ioctl$VT_GETMODE(r1, 0x5601, 0xffffffffffffffff)
fgetxattr(r0, &(0x7f00000000c0)=3D@known=3D'system.posix_acl_access\x00',=
 0x0, 0x0)
r5 =3D syz_open_procfs(0x0, &(0x7f0000000140)=3D'fdinfo/4\x00')
read$FUSE(r5, &(0x7f0000008400)=3D{0x2020}, 0x2020)

3m58.23446739s ago: executing program 4 (id=3D11343):
r0 =3D socket$packet(0x11, 0x2, 0x300)
setsockopt$packet_fanout(r0, 0x107, 0x12, &(0x7f0000000000)=3D{0x1, 0x3},=
 0x4)
perf_event_open(&(0x7f0000000100)=3D{0x2, 0x80, 0x18, 0x2, 0x0, 0x0, 0x0,=
 0x7fd, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0=
x0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0,=
 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x=
2, @perf_config_ext=3D{0x6, 0xffffffffffff64f8}, 0x23a4, 0x9, 0x2, 0x7, 0=
xe7, 0xd1, 0xac6f, 0x0, 0x0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x=
8)
r1 =3D syz_create_resource$binfmt(&(0x7f0000000040)=3D'./cgroup\x00')
r2 =3D socket$inet6(0xa, 0x2, 0x0)
getsockopt$inet6_buf(r2, 0x29, 0x30, 0x0, &(0x7f0000001140)=3D0x8f00)
r3 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0=
, 0x0)
r4 =3D inotify_init1(0x800)
inotify_add_watch(r4, &(0x7f0000000100)=3D'./cgroup\x00', 0x20)
r5 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0=
, 0x0)
fcntl$notify(r5, 0x402, 0x1)
r6 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0=
, 0x0)
getdents64(r6, 0x0, 0x0)
openat$cgroup_int(r3, &(0x7f0000000400)=3D'io.weight\x00', 0x2, 0x0)
openat2$dir(0xffffffffffffff9c, &(0x7f0000000000)=3D'./file1\x00', &(0x7f=
0000000080)=3D{0x240, 0x1cb, 0x2}, 0x18)
r7 =3D openat$binfmt(0xffffffffffffff9c, r1, 0x42, 0x1ff)
bpf$PROG_LOAD(0x5, &(0x7f0000000140)=3D{0x19, 0x2, &(0x7f0000000100)=3DAN=
Y=3D[@ANYBLOB=3D"711920000000000095"], &(0x7f0000000300)=3D'syzkaller\x00=
', 0x2, 0x0, 0x0, 0x0, 0x43, '\x00', 0x0, @cgroup_sockopt=3D0x15, 0x0, 0x=
0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xff}, 0x94)
close(r7)
madvise(&(0x7f0000ffb000/0x2000)=3Dnil, 0x2000, 0x12)
execveat$binfmt(0xffffffffffffff9c, r1, &(0x7f00000001c0)=3D{[], 0xffffc0=
000000}, 0x0, 0x0)

3m43.16424763s ago: executing program 57 (id=3D11343):
r0 =3D socket$packet(0x11, 0x2, 0x300)
setsockopt$packet_fanout(r0, 0x107, 0x12, &(0x7f0000000000)=3D{0x1, 0x3},=
 0x4)
perf_event_open(&(0x7f0000000100)=3D{0x2, 0x80, 0x18, 0x2, 0x0, 0x0, 0x0,=
 0x7fd, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0=
x0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0,=
 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x=
2, @perf_config_ext=3D{0x6, 0xffffffffffff64f8}, 0x23a4, 0x9, 0x2, 0x7, 0=
xe7, 0xd1, 0xac6f, 0x0, 0x0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x=
8)
r1 =3D syz_create_resource$binfmt(&(0x7f0000000040)=3D'./cgroup\x00')
r2 =3D socket$inet6(0xa, 0x2, 0x0)
getsockopt$inet6_buf(r2, 0x29, 0x30, 0x0, &(0x7f0000001140)=3D0x8f00)
r3 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0=
, 0x0)
r4 =3D inotify_init1(0x800)
inotify_add_watch(r4, &(0x7f0000000100)=3D'./cgroup\x00', 0x20)
r5 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0=
, 0x0)
fcntl$notify(r5, 0x402, 0x1)
r6 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0=
, 0x0)
getdents64(r6, 0x0, 0x0)
openat$cgroup_int(r3, &(0x7f0000000400)=3D'io.weight\x00', 0x2, 0x0)
openat2$dir(0xffffffffffffff9c, &(0x7f0000000000)=3D'./file1\x00', &(0x7f=
0000000080)=3D{0x240, 0x1cb, 0x2}, 0x18)
r7 =3D openat$binfmt(0xffffffffffffff9c, r1, 0x42, 0x1ff)
bpf$PROG_LOAD(0x5, &(0x7f0000000140)=3D{0x19, 0x2, &(0x7f0000000100)=3DAN=
Y=3D[@ANYBLOB=3D"711920000000000095"], &(0x7f0000000300)=3D'syzkaller\x00=
', 0x2, 0x0, 0x0, 0x0, 0x43, '\x00', 0x0, @cgroup_sockopt=3D0x15, 0x0, 0x=
0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xff}, 0x94)
close(r7)
madvise(&(0x7f0000ffb000/0x2000)=3Dnil, 0x2000, 0x12)
execveat$binfmt(0xffffffffffffff9c, r1, &(0x7f00000001c0)=3D{[], 0xffffc0=
000000}, 0x0, 0x0)

3m43.16408707s ago: executing program 58 (id=3D11339):
bpf$PROG_LOAD(0x5, &(0x7f0000000c80)=3D{0x3, 0x3, &(0x7f00000003c0)=3D@fr=
amed, &(0x7f0000000500)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0=
, @fallback=3D0x2b, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0=
, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
r0 =3D bpf$MAP_CREATE_RINGBUF(0x0, &(0x7f00000007c0)=3D{0x1b, 0x0, 0x0, 0=
x40000, 0x0, 0x0, 0x0, '\x00', 0x0, 0x0}, 0x48)
r1 =3D syz_open_dev$tty20(0xc, 0x4, 0x1)
openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)=

perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x0, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0xa, 0x4=
, @perf_config_ext=3D{0x7f, 0x7}, 0x101001, 0x8, 0x2, 0x1, 0xffffffff, 0x=
d1, 0xac6f, 0x0, 0x0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x5)
ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
0080)=3D{0x1, 0x1, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
r2 =3D syz_open_dev$tty20(0xc, 0x4, 0x0)
ioctl$TCSETS2(r2, 0x402c542b, &(0x7f0000000040)=3D{0x0, 0xe2c, 0x2, 0x7ff=
, 0x2, "d4af9caca4430493400702b04a4e66a980ec02", 0x7fff, 0x2})
ioctl$TIOCSTI(r2, 0x5412, &(0x7f0000000000)=3D0x9)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x45, 0x9, 0x8, 0xe, 0x0,=
 0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0=
x0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0,=
 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x=
0, @perf_bp=3D{0x0, 0x2}, 0x0, 0x3, 0x2, 0x5, 0xfffffffc, 0x9, 0x3, 0x0, =
0x0, 0x0, 0x65}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
r3 =3D openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x=
2, 0x0)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r3, 0xeb08=
0000)
r4 =3D socket$nl_generic(0x10, 0x3, 0x10)
sendmsg$ETHTOOL_MSG_FEATURES_SET(r4, 0x0, 0x4040810)
ioctl$VT_GETMODE(r1, 0x5601, 0xffffffffffffffff)
fgetxattr(r0, &(0x7f00000000c0)=3D@known=3D'system.posix_acl_access\x00',=
 0x0, 0x0)
r5 =3D syz_open_procfs(0x0, &(0x7f0000000140)=3D'fdinfo/4\x00')
read$FUSE(r5, &(0x7f0000008400)=3D{0x2020}, 0x2020)

34.99433463s ago: executing program 1 (id=3D13212):
syz_clone(0x11, 0x0, 0x0, 0x0, 0x0, 0x0) (async)
socketpair$unix(0x1, 0x1, 0x0, &(0x7f0000000040)=3D{<r0=3D>0xffffffffffff=
ffff, <r1=3D>0xffffffffffffffff}) (async)
r2 =3D socket$inet_udplite(0x2, 0x2, 0x88)
getsockopt$IPT_SO_GET_INFO(r2, 0x0, 0x40, &(0x7f0000000500)=3D{'mangle\x0=
0', 0x0, [0x6, 0x7, 0x1, 0x2, 0xfffffffb]}, &(0x7f0000000100)=3D0x54)
r3 =3D getpid()
fcntl$setownex(r1, 0xf, &(0x7f00000000c0)=3D{0x2, r3}) (async)
sendmsg$unix(r0, &(0x7f0000001100)=3D{0x0, 0x0, &(0x7f00000010c0)=3D[{&(0=
x7f0000001080)=3D"fa", 0x1}], 0x1, 0x0, 0x0, 0x200488e0}, 0x200000c6) (as=
ync)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0) (as=
ync)
sendmsg$OSF_MSG_ADD(0xffffffffffffffff, &(0x7f0000000240)=3D{0x0, 0x0, &(=
0x7f0000000080)=3D{&(0x7f00000003c0)=3DANY=3D[@ANYBLOB=3D"680200000005050=
00000000000000000050000055402010001000000010000000006050004000b0073797a30=
000000000000000000000000000000000000000000000000000000002d653347a232db479=
1cfb3f2314e96499697f42e24b1174d0eb6bd376e78c348f3056515d9e2b47358c8716a1a=
090c00d2735103e458d1eadcf124aa5b3e076a0200010002000000ff07000048040000000=
0000000800000070002000000000003000000fbfff7ff0200000006000000000400020100=
0000040000000001fb0f02000000a20e00000700010001000000800000000500000003000=
0000100000005000200030000000700e30802000000030000000500080002000000030000=
000200ff070200000027"], 0x268}, 0x1, 0x0, 0x0, 0x4bf836865890d53b}, 0x10)=

mkdirat(0xffffffffffffff9c, &(0x7f00000001c0)=3D'./file0/file0\x00', 0x1c=
0) (async, rerun: 32)
mount$nfs(&(0x7f0000000280)=3D'[\xf0c\x1d\x82\xe8Z\x19\xda\f\x02\xf5\xbf\=
xf0n\xed\x97\xc4\xd2\xc3\xaa|\xad\xdc)%\x03\xef\x91\b\x00\x00\x00\x00\x00=
\x00\x00(t\xb7\x10`\xfb4\xcd(\x88\xea%Pd\xa0\v2\xcc\xb6\x89)\xc6\xc2\xb1[=
\xbeW;|\x7f4\x15\xffU\xb5t\"N\xf1\xf5\xed/u\xb3\x84I\xf5d\xbc\xc6I\x18#\x=
f5\xbc\xad]:\xb9\x10\x7f\a\x9a\x93\xc0\xd1w\xc9\x1c\xecq\x8c{\vi\xbd%\x12=
\x8d\x87\xea\xea\x00'/132, &(0x7f0000000000)=3D'./file0/file0\x00', &(0x7=
f0000000380), 0x1, &(0x7f0000000480)=3DANY=3D[]) (async, rerun: 32)
syz_emit_ethernet(0x5e, &(0x7f0000000140)=3DANY=3D[@ANYBLOB=3D"aaaaaaaaaa=
aaaaaaaaaaaabb86dd612065f100280601fe880000000000000000000000000101fe80000=
00000000000000000000000aa4e224e33", @ANYRES32=3D0x41424344, @ANYRES32=3D0=
x41424344, @ANYBLOB=3D"a0e2000690bef508907808002aab2453b6582c188e00000000=
000000"], 0x0)

34.9939118s ago: executing program 1 (id=3D13213):
r0 =3D socket$vsock_stream(0x28, 0x1, 0x0)
setsockopt$sock_int(r0, 0x1, 0x12, &(0x7f0000000200)=3D0x9e, 0x4)
bpf$MAP_CREATE_RINGBUF(0x0, &(0x7f00000007c0)=3DANY=3D[@ANYBLOB=3D"1b0000=
000000000000000000000004000000", @ANYRES32=3D0x0, @ANYBLOB, @ANYRES32=3D0=
x0, @ANYRES32=3D0x0], 0x48) (async)
bpf$MAP_CREATE_RINGBUF(0x0, &(0x7f00000007c0)=3DANY=3D[@ANYBLOB=3D"1b0000=
000000000000000000000004000000", @ANYRES32=3D0x0, @ANYBLOB, @ANYRES32=3D0=
x0, @ANYRES32=3D0x0], 0x48)
r1 =3D bpf$PROG_LOAD(0x5, &(0x7f00000007c0)=3D{0x11, 0x3, &(0x7f000000048=
0)=3DANY=3D[@ANYBLOB=3D"1800000001010000000000000000000095"], &(0x7f00000=
000c0)=3D'syzkaller\x00', 0x4, 0x0, 0x0, 0x41000, 0xa, '\x00', 0x0, @fall=
back=3D0x30, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, =
0x0, 0x0, 0x0, 0x0}, 0x94)
socket$key(0xf, 0x3, 0x2) (async)
r2 =3D socket$key(0xf, 0x3, 0x2)
sendmsg$key(r2, 0x0, 0x40000)
bpf$BPF_RAW_TRACEPOINT_OPEN(0x11, &(0x7f0000000080)=3D{&(0x7f0000000040)=3D=
'block_plug\x00', r1}, 0x18)
ioctl$TUNSETIFF(0xffffffffffffffff, 0x400454ca, 0x0) (async)
ioctl$TUNSETIFF(0xffffffffffffffff, 0x400454ca, 0x0)
mlockall(0x1)
r3 =3D bpf$PROG_LOAD(0x5, &(0x7f00000007c0)=3D{0x3, 0xc, &(0x7f0000000000=
)=3D@framed=3D{{0x18, 0x0, 0x0, 0x0, 0x7f, 0x0, 0x0, 0x0, 0x400}, [@call=3D=
{0x85, 0x0, 0x0, 0x50}, @printk=3D{@x, {}, {}, {}, {}, {0x7, 0x0, 0xb, 0x=
3, 0x0, 0x0, 0xbfea}}]}, &(0x7f0000000180)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x=
0, 0x0, '\x00', 0x0, @sched_cls=3D0x36, 0xffffffffffffffff, 0x0, 0x0, 0x0=
, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000200)=3D{r3, 0x0, 0xe, 0x0, &(0x7f=
0000000380)=3D"0f88888c7b1a103b58f5df25f641", 0x0, 0x0, 0x0, 0x0, 0x0, 0x=
0, 0x0}, 0x50)

34.7063315s ago: executing program 1 (id=3D13217):
bpf$PROG_LOAD(0x5, &(0x7f0000000180)=3D{0x17, 0x4, &(0x7f0000000d00)=3DAN=
Y=3D[@ANYBLOB=3D"1800000006000000000000007e7d00002600ffff0000000095"], &(=
0x7f0000000ac0)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @fallb=
ack=3D0x22, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0=
x0, 0x2}, 0x94)
bpf$PROG_LOAD(0x5, &(0x7f0000000040)=3D{0x5, 0x4, &(0x7f0000000900)=3D@fr=
amed=3D{{0x18, 0x0, 0x0, 0x0, 0x9, 0x0, 0x0, 0x0, 0x41}, [@ldst=3D{0x0, 0=
x0, 0x2, 0x3, 0x9, 0xfffffffffffffffc, 0x4}]}, &(0x7f0000000000)=3D'GPL\x=
00', 0x6, 0x0, 0x0, 0x41000, 0x0, '\x00', 0x0, @fallback=3D0x13, 0x0, 0x0=
, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xf56f}, 0x94)

34.70571356s ago: executing program 1 (id=3D13218):
bpf$BPF_BTF_LOAD(0x12, &(0x7f0000000000)=3D{&(0x7f0000000100)=3D{{0xeb9f,=
 0x1, 0x0, 0x18, 0x0, 0xe4, 0xe4, 0x5, [@union=3D{0xd, 0x1, 0x0, 0x5, 0x0=
, 0xe, [{0xe, 0x2, 0x28ed}]}, @enum64=3D{0x9, 0x3, 0x0, 0x13, 0x1, 0x5, [=
{0xe, 0x80000001, 0x4}, {0xa, 0x5, 0xa}, {0x7, 0xe, 0x1}]}, @type_tag=3D{=
0xb, 0x0, 0x0, 0x12, 0x2}, @type_tag=3D{0x1, 0x0, 0x0, 0x12, 0x2}, @array=
=3D{0x0, 0x0, 0x0, 0x3, 0x0, {0x2, 0x4, 0x1}}, @enum=3D{0x0, 0x4, 0x0, 0x=
6, 0x4, [{0x7, 0x1bac}, {0xa, 0xfffffff4}, {0xb, 0x7ff}, {0x10, 0x12}]}, =
@func_proto=3D{0x0, 0x2, 0x0, 0xd, 0x0, [{0xb, 0x401}, {0xf, 0x4}]}, @vol=
atile=3D{0x9, 0x0, 0x0, 0x9, 0x4}, @restrict=3D{0x4}, @volatile=3D{0xa, 0=
x0, 0x0, 0x9, 0x1}]}, {0x0, [0x0, 0x61, 0x61]}}, &(0x7f0000000240)=3D""/4=
096, 0x101, 0x1000, 0x1}, 0x28)
r0 =3D add_key$fscrypt_v1(&(0x7f0000003400), &(0x7f0000003440)=3D{'fscryp=
t:', @desc4}, &(0x7f0000003480)=3D{0x0, "3264c18880dbc569ac872ac85793e61c=
84ee1dcd9d03285e84ca410c5d3b9ace94663b829ff8bb6a708ac20509000000022a31761=
be19fd9ffc39a967426bb3e", 0x3d}, 0x48, 0xfffffffffffffffd)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
mkdirat(0xffffffffffffff9c, &(0x7f00000001c0)=3D'./file0/file0\x00', 0x1c=
0)
mount$tmpfs(0x0, &(0x7f0000000000)=3D'./file0/file0\x00', &(0x7f00000000c=
0), 0x10000, 0x0)
mount$tmpfs(0x0, &(0x7f0000000300)=3D'./file0/file0\x00', &(0x7f000000034=
0), 0x1000000, 0x0)
mount$bind(&(0x7f0000000040)=3D'./file0\x00', &(0x7f0000000000)=3D'./file=
0/file0\x00', 0x0, 0x2150d1, 0x0)
r1 =3D socket$nl_generic(0x10, 0x3, 0x10)
r2 =3D syz_genetlink_get_family_id$ethtool(&(0x7f0000000040), r1)
sendmsg$ETHTOOL_MSG_STRSET_GET(r1, &(0x7f0000000000)=3D{0x0, 0x0, &(0x7f0=
000000c40)=3D{&(0x7f00000002c0)=3D{0x30, r2, 0x31d, 0x70bd25, 0x25dfdbfe,=
 {}, [@ETHTOOL_A_STRSET_STRINGSETS=3D{0x1c, 0x2, 0x0, 0x1, [{0xc, 0x1, 0x=
0, 0x1, [@ETHTOOL_A_STRINGSET_ID=3D{0x8, 0x1, 0x8}]}, {0xc, 0x1, 0x0, 0x1=
, [@ETHTOOL_A_STRINGSET_ID=3D{0x8, 0x1, 0xc74642dfecf9e0ef}]}]}]}, 0x30}}=
, 0x4040000)
keyctl$get_security(0x11, r0, &(0x7f0000000080)=3D""/104, 0x68)

34.70405153s ago: executing program 1 (id=3D13219):
openat$ipvs(0xffffffffffffff9c, &(0x7f0000002240)=3D'/proc/sys/net/ipv4/v=
s/sloppy_sctp\x00', 0x2, 0x0) (async)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0) (as=
ync)
mount$tmpfs(0x0, &(0x7f0000000080)=3D'./file0\x00', &(0x7f00000000c0), 0x=
0, 0x0)
mount$fuse(0x0, &(0x7f0000000000)=3D'./file0\x00', 0x0, 0x108000, 0x0) (a=
sync)
mount$tmpfs(0x0, 0x0, 0x0, 0x0, 0x0) (async)
mkdirat(0xffffffffffffff9c, &(0x7f0000000340)=3D'./file0/file0\x00', 0x11=
8) (async)
mount$bind(&(0x7f0000000040)=3D'./file0\x00', &(0x7f0000000000)=3D'./file=
0/file0\x00', 0x0, 0x2150d1, 0x0) (async)
syz_mount_image$fuse(&(0x7f0000000280), &(0x7f0000000380)=3D'./file0/file=
0\x00', 0x84000, &(0x7f0000000300)=3DANY=3D[@ANYBLOB=3D'fd=3D', @ANYRESHE=
X, @ANYBLOB=3D',rootmode=3D000000000000000v0040040,user_id=3D', @ANYRESDE=
C=3D0xee01, @ANYBLOB=3D',group_id=3D', @ANYRESDEC=3D0xee00, @ANYBLOB=3D',=
\x00'], 0x0, 0x0, 0x0)
mount$bind(&(0x7f0000000100)=3D'./file0\x00', &(0x7f00000001c0)=3D'./file=
0\x00', 0x0, 0x395002, 0x0) (async)
mount$bind(&(0x7f0000000180)=3D'./file0/file0\x00', &(0x7f00000001c0)=3D'=
=2E/file0/file0\x00', 0x0, 0x291002, 0x0) (async)
mount$tmpfs(0x0, &(0x7f0000000080)=3D'./file0\x00', &(0x7f00000000c0), 0x=
0, 0x0) (async)
r0 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
setsockopt$inet6_MCAST_MSFILTER(r0, 0x84, 0x30, &(0x7f0000000200)=3DANY=3D=
[], 0x90) (async)
openat$nullb(0xffffffffffffff9c, &(0x7f00000000c0), 0x3500, 0x0)
close(0x3)
r1 =3D socket$inet6_sctp(0xa, 0x1, 0x84) (async)
close(0x3)
socket$inet6_tcp(0xa, 0x1, 0x0) (async)
r2 =3D socket$inet_sctp(0x2, 0x5, 0x84)
setsockopt$inet_sctp_SCTP_AUTH_ACTIVE_KEY(r2, 0x84, 0x18, &(0x7f000000040=
0)=3D{0x0, 0x8}, 0x8) (async)
bind$inet6(r1, &(0x7f0000000000)=3D{0xa, 0x4e23, 0x41, @loopback, 0x401},=
 0x1c) (async)
read$FUSE(0xffffffffffffffff, 0x0, 0x0) (async)
r3 =3D add_key$keyring(&(0x7f0000000140), &(0x7f0000000180)=3D{'syz', 0x0=
}, 0x0, 0x0, 0xfffffffffffffffc)
keyctl$KEYCTL_RESTRICT_KEYRING(0x1d, r3, &(0x7f0000000000)=3D'asymmetric\=
x00', &(0x7f0000000080)=3D@secondary)
add_key$fscrypt_v1(&(0x7f0000000040), &(0x7f00000000c0)=3D{'fscrypt:', @a=
uto=3D[0x30, 0x66, 0x66, 0x36, 0x64, 0x33, 0x66, 0x62, 0x66, 0x36, 0x61, =
0x37, 0x65, 0x61, 0x33, 0x31]}, &(0x7f0000001200)=3D{0x0, "9fc1eb786eec90=
e55fd4b479e73508774fa5eae0544b4d8f9d34d2e920d305f57f10a07233be055d842285c=
42ba0877e9cc7fd9b681d0efea097bef73ad4dee1", 0x21}, 0x48, r3)
madvise(&(0x7f0000ffb000/0x3000)=3Dnil, 0x3000, 0x65)
setsockopt$SO_TIMESTAMPING(r1, 0x1, 0x41, &(0x7f0000000100)=3D0x1b27, 0x4=
) (async)
sendmmsg$inet6(r1, &(0x7f00000036c0)=3D[{{&(0x7f0000000580)=3D{0xa, 0x4e2=
3, 0x389, @loopback, 0x2}, 0x1c, 0x0}}], 0x1, 0x20004810) (async)
mmap(&(0x7f0000000000/0xa000)=3Dnil, 0xa000, 0x5, 0x32, 0xfffffffffffffff=
f, 0xc19ad000) (async)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0x9, 0x8, 0xe, 0x0, =
0x7fe, 0x90080, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x1=
, @perf_bp=3D{0x0, 0x2}, 0x2, 0x7, 0x6, 0x5, 0xffffffff, 0x9, 0x3, 0x0, 0=
x0, 0x0, 0x3}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)

34.63019346s ago: executing program 1 (id=3D13220):
syz_mount_image$fuse(0x0, &(0x7f0000002080)=3D'./file0\x00', 0x2000000, 0=
x0, 0x0, 0x0, 0x0)
syz_emit_ethernet(0x46, &(0x7f00000000c0)=3DANY=3D[@ANYBLOB=3D"aaaaaaffff=
ff7fbbbbbbbbbb0800471300380065000006019078ac1414aaac1e0101860600000003000=
0030b90e8f1f25e149078004300064528000900680003032e00007f00"], 0x0)
mount$tmpfs(0x0, &(0x7f0000000080)=3D'./file0\x00', &(0x7f00000000c0), 0x=
0, 0x0)
syz_mount_image$fuse(&(0x7f0000000140), &(0x7f0000000280)=3D'./file0\x00'=
, 0x100000, &(0x7f0000000440)=3DANY=3D[], 0x0, 0x0, 0x0)
mprotect(&(0x7f0000fec000/0x14000)=3Dnil, 0x14000, 0x1000000)
socket$nl_route(0x10, 0x3, 0x0)
mkdirat(0xffffffffffffff9c, &(0x7f0000000340)=3D'./file0/file0\x00', 0x11=
8)
mount$tmpfs(0x0, &(0x7f0000000200)=3D'./file0/file0\x00', &(0x7f000000024=
0), 0x0, 0x0)
mount$bind(&(0x7f0000000040)=3D'./file0\x00', &(0x7f0000000000)=3D'./file=
0/file0\x00', 0x0, 0x2150d1, 0x0)
umount2(&(0x7f0000000000)=3D'./file0\x00', 0x2)

34.62832678s ago: executing program 59 (id=3D13220):
syz_mount_image$fuse(0x0, &(0x7f0000002080)=3D'./file0\x00', 0x2000000, 0=
x0, 0x0, 0x0, 0x0)
syz_emit_ethernet(0x46, &(0x7f00000000c0)=3DANY=3D[@ANYBLOB=3D"aaaaaaffff=
ff7fbbbbbbbbbb0800471300380065000006019078ac1414aaac1e0101860600000003000=
0030b90e8f1f25e149078004300064528000900680003032e00007f00"], 0x0)
mount$tmpfs(0x0, &(0x7f0000000080)=3D'./file0\x00', &(0x7f00000000c0), 0x=
0, 0x0)
syz_mount_image$fuse(&(0x7f0000000140), &(0x7f0000000280)=3D'./file0\x00'=
, 0x100000, &(0x7f0000000440)=3DANY=3D[], 0x0, 0x0, 0x0)
mprotect(&(0x7f0000fec000/0x14000)=3Dnil, 0x14000, 0x1000000)
socket$nl_route(0x10, 0x3, 0x0)
mkdirat(0xffffffffffffff9c, &(0x7f0000000340)=3D'./file0/file0\x00', 0x11=
8)
mount$tmpfs(0x0, &(0x7f0000000200)=3D'./file0/file0\x00', &(0x7f000000024=
0), 0x0, 0x0)
mount$bind(&(0x7f0000000040)=3D'./file0\x00', &(0x7f0000000000)=3D'./file=
0/file0\x00', 0x0, 0x2150d1, 0x0)
umount2(&(0x7f0000000000)=3D'./file0\x00', 0x2)

14.98249662s ago: executing program 2 (id=3D13335):
mount$tmpfs(0x0, 0x0, 0x0, 0x0, 0x0)
socket$nl_generic(0x10, 0x3, 0x10)
io_uring_register$IORING_REGISTER_PBUF_RING(0xffffffffffffffff, 0x16, 0x0=
, 0x1)
statx(0xffffffffffffffff, 0x0, 0x0, 0x80, &(0x7f0000000380)=3D{0x0, 0x0, =
0x0, 0x0, <r0=3D>0x0})
sched_yield()
quotactl$Q_GETFMT(0xffffffff80000401, 0x0, r0, 0x0)
r1 =3D socket$nl_route(0x10, 0x3, 0x0)
r2 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
ioctl$ifreq_SIOCGIFINDEX_batadv_hard(r2, 0x8933, &(0x7f0000000000)=3D{'ba=
tadv_slave_0\x00', <r3=3D>0x0})
sendmsg$nl_route(r1, &(0x7f00000015c0)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000001740)=3D@dellinkprop=3D{0x38, 0x6d, 0xb6bd404dbbf02165, 0x70b=
d29, 0x25dfdbfd, {0x0, 0x0, 0x0, r3, 0x148, 0x628a7}, [@IFLA_PROP_LIST=3D=
{0x18, 0x34, 0x0, 0x1, [{0x14, 0x35, 'rose0\x00'}]}]}, 0x38}, 0x1, 0x0, 0=
x0, 0x400d1}, 0x240000c4)
r4 =3D syz_create_resource$binfmt(&(0x7f0000001400)=3D'./file0\x00')
r5 =3D openat$binfmt(0xffffffffffffff9c, r4, 0x42, 0x1ff)
write(r5, &(0x7f0000000000)=3D"618ee060", 0x4)
close(r5)
bpf$PROG_LOAD(0x5, &(0x7f0000000680)=3D{0x3, 0x2, &(0x7f00000000c0)=3DANY=
=3D[@ANYBLOB=3D"83b4ffff0800b26cdc9685e334e239e5a1bdd4fa2e4b000002"], &(0=
x7f0000000780)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @sched_=
cls, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x=
94)
execveat$binfmt(0xffffffffffffff9c, r4, 0x0, 0x0, 0x0)
r6 =3D bpf$MAP_CREATE(0x0, &(0x7f0000000000)=3DANY=3D[@ANYBLOB=3D"0100072=
25b7600003f6f10ab07"], 0x50)
bpf$MAP_UPDATE_BATCH(0x1a, &(0x7f0000000040)=3D{0x0, 0x0, &(0x7f000000020=
0), &(0x7f0000000440), 0x3ff, r6}, 0x38)
sendmsg$IPSET_CMD_CREATE(0xffffffffffffffff, &(0x7f0000000340)=3D{0x0, 0x=
0, &(0x7f0000000300)=3D{&(0x7f0000000100)=3D{0x48, 0x2, 0x6, 0x301, 0x0, =
0x0, {0x7, 0x0, 0xa}, [@IPSET_ATTR_SETNAME=3D{0x9, 0x2, 'syz0\x00'}, @IPS=
ET_ATTR_FAMILY=3D{0x5, 0x5, 0x3}, @IPSET_ATTR_TYPENAME=3D{0x11, 0x3, 'has=
h:ip,mark\x00'}, @IPSET_ATTR_SETNAME=3D{0x9, 0x2, 'syz0\x00'}]}, 0x48}}, =
0x20008000)
ioctl$sock_SIOCGIFINDEX(0xffffffffffffffff, 0x8933, 0x0)
r7 =3D openat$ptp0(0xffffffffffffff9c, &(0x7f00000022c0), 0x2000, 0x0)
mmap(&(0x7f0000000000/0xa000)=3Dnil, 0xa000, 0x5, 0x32, 0xfffffffffffffff=
f, 0xc19ad000)
ioctl$PTP_PEROUT_REQUEST2(r7, 0x40383d0c, &(0x7f0000002340)=3D{{0x6, 0x80=
0}, {0x2, 0x42d9}, 0x8})
bpf$BPF_LINK_CREATE_XDP(0x1c, 0x0, 0x0)
socket$inet6(0xa, 0x2, 0x0)
socket$nl_route(0x10, 0x3, 0x0)
socket$inet_icmp_raw(0x2, 0x3, 0x1)
r8 =3D bpf$MAP_CREATE_TAIL_CALL(0x0, &(0x7f0000000540)=3DANY=3D[@ANYBLOB=3D=
"1900000004000000040000000a00000000000000", @ANYRES32=3D0x0, @ANYBLOB=3D'=
\x00'/20, @ANYRES32=3D0x0, @ANYRES32=3D0x0, @ANYBLOB=3D'\x00'/28], 0x50)
r9 =3D openat(0xffffffffffffff9c, &(0x7f0000000280)=3D'./cgroup\x00', 0x0=
, 0x20)
bpf$MAP_UPDATE_ELEM_TAIL_CALL(0x2, &(0x7f0000000080)=3D{{r8}, &(0x7f00000=
00000), &(0x7f0000000040)=3Dr9}, 0x20)

14.92820053s ago: executing program 2 (id=3D13336):
r0 =3D socket$inet6_sctp(0xa, 0x1, 0x84)
bind$inet6(r0, &(0x7f0000000280)=3D{0xa, 0x4e20, 0xffbffff5, @empty, 0x2}=
, 0x1c)
getsockopt$inet_sctp6_SCTP_SOCKOPT_CONNECTX3(r0, 0x84, 0x6f, &(0x7f000000=
0200)=3D{<r1=3D>0x0, 0x10, &(0x7f0000000440)=3D[@in=3D{0x2, 0x4e20, @dev=3D=
{0xac, 0x14, 0x14, 0x1f}}]}, &(0x7f0000000240)=3D0x10)
setsockopt$inet_sctp6_SCTP_PEER_ADDR_PARAMS(r0, 0x84, 0x9, &(0x7f00000000=
c0)=3D{r1, @in6=3D{{0xa, 0x4e22, 0x3, @empty, 0x1ff}}, 0xe, 0x5e2c, 0xfff=
ffff9, 0x8, 0xd1, 0xf}, 0x9c)
sendmsg$NFT_MSG_GETOBJ(0xffffffffffffffff, &(0x7f0000000100)=3D{0x0, 0x0,=
 0x0}, 0x0)
r2 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
socket$nl_generic(0x10, 0x3, 0x10)
r3 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
getsockopt$IP6T_SO_GET_INFO(r3, 0x29, 0x40, 0x0, &(0x7f0000000c80)=3D0x54=
)
ioctl$ifreq_SIOCGIFINDEX_batadv_hard(r2, 0x8933, 0x0)
r4 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r4, &(0x7f0000000040)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000140)=3D@newlink=3D{0x38, 0x10, 0x711, 0x70bd29, 0x25dfdbfc, =
{0x0, 0x0, 0x0, 0x0, 0x778ad, 0x62a05}, [@IFLA_LINKINFO=3D{0x18, 0x12, 0x=
0, 0x1, @gre=3D{{0x8}, {0xc, 0x2, 0x0, 0x1, [@IFLA_GRE_REMOTE=3D{0x8, 0x7=
, @private=3D0xa010101}]}}}]}, 0x38}, 0x1, 0x0, 0x0, 0x24040040}, 0x4a800=
)
ioctl$NS_GET_OWNER_UID(0xffffffffffffffff, 0xb704, 0xffffffffffffffff)
bind$alg(0xffffffffffffffff, 0x0, 0x0)
epoll_create1(0x80000)
r5 =3D socket$alg(0x26, 0x5, 0x0)
bind$alg(r5, &(0x7f0000000100)=3D{0x26, 'hash\x00', 0x0, 0x0, 'sha224-ce\=
x00'}, 0x58)
r6 =3D accept4$alg(r5, 0x0, 0x0, 0x800)
sendmsg$alg(r6, &(0x7f0000000080)=3D{0x0, 0x0, &(0x7f0000000040)=3D[{&(0x=
7f00000000c0)=3D'\v#6d_', 0x5}, {&(0x7f0000000180)=3D"789beb9ad0895c1980c=
2831eb6654bd5ef", 0x11}, {&(0x7f0000000280)=3D"d532495662f6a3532f14979999=
16f8937d8e3850bb6015694b93edd04c2e88489af5999a90f8fa9ec77f74af859cccc838e=
37593f13300bb41d0e11c968091ee2b77a1248681a72958d5a87000580d9bfe2f9544787f=
e0817dd2cf37db41253644d1ecd0bd690bb4069b", 0x6a}], 0x3, 0x0, 0x0, 0x40000=
00}, 0x40001)
setsockopt$inet6_IPV6_HOPOPTS(0xffffffffffffffff, 0x29, 0x36, 0x0, 0x0)
accept4(0xffffffffffffffff, 0x0, 0x0, 0x80800)
writev(r0, &(0x7f0000002440)=3D[{&(0x7f0000004540)=3D'8', 0x1}], 0x1)

14.78035975s ago: executing program 2 (id=3D13337):
r0 =3D openat$ipvs(0xffffffffffffff9c, &(0x7f0000002240)=3D'/proc/sys/net=
/ipv4/vs/sloppy_sctp\x00', 0x2, 0x0)
r1 =3D openat$nullb(0xffffffffffffff9c, &(0x7f00000000c0), 0x40080, 0x0)
close(0x3)
socketpair$unix(0x1, 0x1, 0x0, &(0x7f0000000000))
setsockopt$sock_timeval(r0, 0x1, 0x43, &(0x7f0000000040)=3D{0x0, 0x2710},=
 0x10)
sendfile(r0, r1, 0x0, 0x4000000040000008)
r2 =3D open(&(0x7f00000001c0)=3D'./file0\x00', 0x800, 0x30)
read$eventfd(r2, &(0x7f0000000340), 0x8)
r3 =3D bpf$MAP_CREATE_RINGBUF(0x0, &(0x7f00000007c0)=3D{0x1b, 0x0, 0x0, 0=
x40000, 0x0, 0x0, 0x0, '\x00', 0x0, 0x0}, 0x48)
r4 =3D openat$snapshot(0xffffffffffffff9c, &(0x7f0000000000), 0x401, 0x0)=

write$snapshot(r4, 0x0, 0x1f)
r5 =3D bpf$BPF_BTF_GET_FD_BY_ID(0x13, &(0x7f0000000040), 0x4)
openat$ubi_ctrl(0xffffffffffffff9c, &(0x7f0000000180), 0x80802, 0x0)
r6 =3D bpf$PROG_LOAD(0x5, &(0x7f0000000280)=3D{0x6, 0x1d, &(0x7f000000008=
0)=3D@ringbuf=3D{{0x18, 0x0, 0x0, 0x0, 0x531, 0x0, 0x0, 0x0, 0x200}, {{0x=
18, 0x1, 0x1, 0x0, r3}}, {}, [@map_fd=3D{0x18, 0xb, 0x1, 0x0, r3}, @initr=
0=3D{0x18, 0x0, 0x0, 0x0, 0x8000, 0x0, 0x0, 0x0, 0x5}, @cb_func=3D{0x18, =
0x0, 0x4, 0x0, 0x4}, @initr0=3D{0x18, 0x0, 0x0, 0x0, 0x6, 0x0, 0x0, 0x0, =
0xfffffff7}, @initr0=3D{0x18, 0x0, 0x0, 0x0, 0x100, 0x0, 0x0, 0x0, 0x3}, =
@btf_id=3D{0x18, 0x1, 0x3, 0x0, 0x5}, @func=3D{0x85, 0x0, 0x1, 0x0, 0xfff=
fffffffffffff}, @ldst=3D{0x3, 0x2, 0x3, 0x4, 0x6, 0xfffffffffffffff8, 0x4=
}], {{}, {0x7, 0x0, 0xb, 0x2, 0x0, 0x0, 0x2}, {0x85, 0x0, 0x0, 0x84}}}, &=
(0x7f00000006c0)=3D'syzkaller\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0,=
 @fallback=3D0x25, r5, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, =
0x0, 0x0}, 0x94)
bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000200)=3D{r6, 0x0, 0xe, 0x0, &(0x7f=
0000000880)=3D"0f8888ef13dfd57e100049478301", 0x0, 0xf000, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x2}, 0x50)

14.77953926s ago: executing program 2 (id=3D13338):
ioctl$AUTOFS_DEV_IOCTL_ISMOUNTPOINT(0xffffffffffffffff, 0xc018937e, &(0x7=
f0000000200)=3D{{0x1, 0x1, 0x18, <r0=3D>0xffffffffffffffff, {0x1}}, './fi=
le0/file0\x00'})
mkdirat(r0, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
r1 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0)
mount$fuse(0x0, &(0x7f00000020c0)=3D'./file0\x00', &(0x7f0000002100), 0x0=
, &(0x7f0000000240)=3DANY=3D[@ANYBLOB=3D'fd=3D', @ANYRESHEX=3Dr1, @ANYBLO=
B=3D',rootmode=3D00000000000000000040000,user_id=3D', @ANYRESDEC=3D0x0, @=
ANYBLOB=3D',group_id=3D', @ANYRESDEC=3D0x0])
read$FUSE(r1, &(0x7f00000043c0)=3D{0x2020, 0x0, <r2=3D>0x0, <r3=3D>0x0, <=
r4=3D>0x0, <r5=3D>0x0}, 0x2020)
getsockopt$inet_IP_XFRM_POLICY(r0, 0x0, 0x11, &(0x7f0000000900)=3D{{{@in=3D=
@remote, @in6, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, <r6=3D>0x0}},=
 {{@in6=3D@initdev}, 0x0, @in6=3D@empty}}, &(0x7f0000000a00)=3D0xe8)
syz_fuse_handle_req(r0,
&(0x7f0000008400)=3D"d40489443aaa92784cdd421b049ed3ad2ccedc7969b8ef785fe4=
2dc37a7b66a5508acbba51d749e017e7706b1c24bcbf8e152fdadc383b7612f38a94fd21c=
3f4126f943cc2301d17efa83992559a15bd1458c00d7928ed7061a21b0b04c1ff8c8663af=
2513cf478e9d627fa19d8885baaf5f7b867c2c65ca4fdcc4e1dad3a88b437d84b731f9908=
39f6fbd2a08f16ab64eba7389eb6f2b1b6c2e42dbbc761c8106ecbd7c5a6e3f4615d5567e=
5c8f76c44e046ba0e20d0d5ae9c4dadc766fb84eadfe58a4f25f34d403371cf019adcf0a4=
b042be848212aed073e8721323479e9320ebbf0e636b21d0152a4955770a14abfd186865b=
0c729588360b655b0d56a465a474060fc1e487b10735e596830810b09fa964d5dd8341238=
6fec5e642c816e817af7f7490ae2086e7bbb219fd2e2ca104621c731d05fe2bac7515dd06=
94521165e26c3231a56e2ef1ce4adb1976b8600040293eae2b6c76b34ad1dcb95906bdcf4=
b4d685c05f782f64e9097dc9c8e28363f4103ba6752a1e76560f8e567d70b5b949698f359=
bfc6049f8ef43966828380e133d9add2107f00b79e3873d89df903bb2605a74f94e6a757d=
0bb63d1b3fdaffbe2d7b909acf219f1c05bb678b5f9cc8e161676f05d48ab1df41d316bb7=
e017ea2249bb9eb08d0f3004d9aee477edd696ca9e9a0a6cc385d6d22bcc381238975595a=
0190f826bab8cbc9936d0247bbb880edee1b58d8b268b191595d4a548d62334392b11bfa9=
202927fbc1ee926aae1046ce2866670a3a095523c8788e9d82e793b8e2b0f0b56dccfcf16=
479803bf50bbe57855c36ff3348cf89dac6625a572cab85a4975fde8a00256469f44abdea=
457bd4d127774ab8ce4f70af6685d59a49b50558d565dbafbac80cfd82ec19f3f090194d9=
a7f3912528284b4a5f6ed3a3671ced36a6cb350989db0b82d78f218bca464f7c5c1b8b992=
0c384d30edf6ba10344ff218b13601b35b91bbef5816acd50eb11e48a70e72bb8e49e0712=
81574530a437b403f390d8df8c7c6bdae3564ce1c1bda3f3e1f4b3938f644643331605f81=
3acab5779a05609249484d3ffef513af04df5f2458c129e94c10fb1e28e75c6b1ceb3b9f5=
166030189cee482a3a07b16936d0014f7c51042d4cacc3a9696965868f8156da6925b3c89=
9db2ab9c5973cdca6a00b1435902236d92ae3951c27c67caca1ae46c0b98a3dcdf7f2b06c=
e5e3c6d6a2b4866146f96a96c7aa5e9674e1a5857124afd487eb59239c54f9d841abe45b4=
785b4d9762d3c63a2923f17b1064ad1e4cc62bae272f881806b75ccfa668a27342985e819=
b73b626718e793342fb538f643c75028b6fc69154eebd4108789155e99aa885924a382d4a=
188f55edd9c91871e98e74d2b374b0b87c83a90aecfe9d3b0644d99c81312e49402e1798a=
8caeeeabf3ed7e971accfe15e36ec8765298a5e9b1ef1d51bf51bfb4beffad7eb680d8b52=
3e4982859fc5c5f4ebb6fe73e10c49844a6f5a2033f486c4998ec3c4d2311d8d2327caeaf=
1b941ba102d6135f37264d9f27d648709c2afea42f2ee13e7d9ed6b5ccf169c5a3db72af5=
d9d05b487f58a60bf725ae39b084c7022a0297677e29d5698f3b6b5898ffe553faad1d42b=
ebe1d84079da27e0bc763d28418d2a1f5a52ec91994543840ba6519fc3968e909544bf974=
7db00a4e7b610f897b2c0d39d220235ea7ffddaa702e79beae16cc7a06aef54451fc1f2c1=
7298807f60ed166bac54a624e9e48ba1a630b7fe606266498aafce0f656671aa7a5b7ba1a=
d8c06809ee57dc764c395fa73b58ebbcfc9f90afa379d1e421bfdcbcd8184721d657413b9=
59dd14d67d7e57312f7c4088809b0b59ac5f9d8cb6511edda683ec142ef214c8391d76822=
e6f0a3bb2967abdf9f126f3dd85d60c02e55ed721b70af9bffa8e9fede520faed05602aed=
f56a1f3f347fd452d86b862ad555ce0125244ed46841eaa0c0ef9ae7c1d3328687d409604=
6793219b79d2103525d2957bea531615582c65afe044273f30b663bc4552e23da2a6e887c=
b3c01e7e7790b279664043204eec15692185990897a822f6dc5e8973981393593f5516c57=
4f5a95c8d9076ddfc404f773f9e435e57cb4aea3c53bc24ac2075dac3614d972de0bdf1ce=
49325722ac45823107f6f6ed103755e23bc4c02016870f2502d72aaee206f9ae70f8b03cc=
25a50441aab214ca791920c0b22b41dce31a2f1c859521fe0268e59dd1a17b9a430f97ac4=
d7c1e8d7184732bc0df2a28905c2e589a502f31d2d2c11076cd89d1ae14c2ce0c8f10b423=
5fa3d6d8255e4408f0b46e05c9cba2f1a8b7410a017e9a3b8fb00b58287249489711c626f=
99008681a672f2ca203e2ccb72b4213c722f5b7496663c3c976e0e3c3dc1f468979311ee2=
14684deaef1af955ab5839bc2a0e03b89d68963e9e116fe5f8f1ad838aaafab97b40510a1=
4517cac32042d67c00feac970fe4ee96b3ca35443e51cc62cfc490b951577effc484e39c7=
75673168788b21f1006e5593d7f8081984ce9d79be2438d6d41bceebcfe08cf08a30f51f2=
225c618f22ed8e3d968de1db1b38991b1c169f70060d6ca3e5380102f9119e607274668cd=
6540af8409824eebc4363a25962406ee146723c3442c9e4ceb28e919806dd37a92faf76b8=
abd8ebdaf067d2d4b80f8e38de94be8cc6b80792d1a60f3e1da3e1c45eb3dde99b6b13f4b=
bab6195f35687c716a164db2865853b54846139a40828a151c46be0b34630ae125375fce1=
4a9269219b7e9fb5372771fef73781071f2c238a4ed9efa4ff79e4c81ba703c8a710015ec=
9b7f24c12ae53831a135b708b22abd6f3e3db9f9edc80895fae2aa649b813473bb01b78da=
75afa74f291ac2950bc55a7a55f04948baab309d850ff575ef2e755cf9fff8e6d1db6d28b=
3a15b6503064a5486dff4d52d92169775857b9bc695e85283e6f30b7251e934d95a93462d=
b3545537fedf6464cf1dbdcee64d47c7da7d71ebb642667e2113760fe7eba34865e833927=
39a24f5b98ed2a518972be01ed3de818da25a49e49b2d2a2d24fc1a296a2b3c502ed2b33a=
56ff7440d10f7c4b167e940477e5483e1c655f928f6e2b5f88ff788d226b11832e070d770=
c8981cda454e1891cd44d9d86bf7e67390e3b6b6a3cddb489e2a4b9d7d337b69c5e0f78c0=
446df47b191019fca1bf6ffec96ca298835e316358750dfc83a0a4f1e37decdc0510bf5e4=
3c01902a8ab22b11c85f4baa539fc494adeee374a61174c0919da745c29fb5b0edc566dd1=
7dc099dc0f43186673e85f8801aa0417d85f391f6a23b79f6c51a32527f40e2786122c8b8=
0a52c9c2cb93b316d3eb4b9096a13e49daca318ea1b8b46cad7d5953680f56d5ead23aaf1=
6c37daa35808af58436558f4f54495219b32a2d7f51b80f4f18a165ecd9d01751f7f8d658=
27da64930bca4f227961e00645121dbc4c8c761f8a76de5c0460ecf3c2966a18b91becec1=
e2fe5f71c1c533cb471729c411cf9f14543432b16d2b0d8d6208bf3e0559842666c74719f=
028c9a46c8185766fe711456a7e126e3c9e2df95f9f1ddbc55e47b2b676807343fd6e86a6=
f893d9926dbd54ad1a94dfb137e5d3f58ef1d26c88a59c6d4375b7802934ff3360cccdd57=
ecb7836683ca4194e3bdeead4e3946204d53667b9dd5e0cc058c00b0deb84b4277348ea6b=
bb41179b7afbe07fa5b153bc423c6be49ec7e0eca7a593a0e1148dedd3cc0f1fb9e827091=
9335435e1fb755aa53c06d48bd40a1daafa5309a61070bc50a3b8785f4f49cb6526705034=
ee9c8116708d40bc372020e8682af1df4ec74700dc76ea68468cde0cdfd8b5e0e97297adb=
f307f48534231b50192a787b501a1a6aa652b5437a55438ddf03cc0b8a6b6d83630345306=
8ffeb8afd7bbed4a6b2f76b91280f0b1353c78e8871fcbec75d427f254d6c938dcd09295e=
ea7dd3a3124f0d710d1c61972cc7a80e1c87bc1d09fd4c9de3ed8392492c102a8432c7891=
daefee9a98beefe46dddcee1d81a94a10d3557c635e0fce88732b6e80afee0362164d40fc=
46c65e16b01cc28800bd81864cc653c68488746284ac94fb088b869feeef348e1d9497d2a=
d8f0e0629f285efef51fc528fa2e3450f47432208c4fdce31b4f080627a43a8e060a7254b=
3ba38591b89c3129c16deb61d184b9854431612a3330c0de5e8d34cea13a988309407c0b1=
24b114971b6f66e98816a39dc68eb918931c8f2c6c0e439dfcec45ff806459e51bf36a209=
8ccd6ff7b70c821dc39abb8625c9ef1e007f50e283d3d4e5af0a460336e14a896cf35a0ca=
1a52e484a3e7ccdf504a971f379c0ccbfc90336ef8ffe6d3c5705397eeb697b1981b9c9d8=
17fb4290e00e045643220230b578121d2260156a5e1a2bf08ae123a50775e8a7bb2529fd5=
e8a42d8b0680924605d6b44e7dd42b5a9047a0634ff1a8b4bc599e35d5b9797fc14809bf3=
bfc40583192f5310f9b5c46ce996972a21a1c51ad2064971a673b8801cd036c702fef4925=
c4fe54a22982f8e5643474934e01085de967d1ab9205e57e63a3a259a20d87f159a80f585=
f0f17aac5d6c58af27dc48a9cbe71db9cc0447b0cbe2478aa4dce089f031133e51f77a853=
2689b93df1068266704cb50d9d8452a97a6431fd7fdba5b6be5d401c35a308d62210f06d2=
91a0c8c05a1f180e71dd65b3564dc05798ffb4c672c41970d4ea8ade940fcadaf63845535=
009faa5c0f19a7f8fc178487ee58c4335469b5f46d511770342ce1f7eef891ec5158df23d=
7a6a2e7eb7196995a1c53c45e93a4b7669f1170fe2dac6f3a133017d93f54f50d20b9ba7c=
ddc0d361307e3a3e1a9f97a8580a6cac803ea49384ba24d010ee35f4f5ae7dd740710be47=
c41c171cc623d6168fea59aaf2717fa3815fb1fc9863957655b45af765f66811435f1dcae=
00de6e3df5a9dbfd12e1ce10a9b3a6ee5ba7e0f0f432f1ae7be2e063a2ebbd76fb51e93e9=
9311f28ecec7e4a486bf63c72ed259f5c9db49fc3b045ba4c9ec9683ec0b020698830814a=
49182ff8dcd0f083284398f1a97efb1406b14aa083d6632641fba4f1caac5e542c1d1db1c=
b1034e4b38c7b04ac2ceef989e55314b99ef5ab9db63fb274cfeb92f55010350ddf0ccc02=
836f412f6532451f352d538290b18c4d38803d721d8c4ba0fc3ea107ac2b7304f20dbe591=
cfae9a90f6d822907c0131a6550b89871049f68eefdce0fa9f2439da8989d7eaecca349fc=
14a69c4ad1679417a7a4b72be97ac1733306bd83d45c4826058689bc1b417d1dc0fc5478f=
3e4d0c99f05be95912f0412eab27bc79627809fa647b4d5c84d7b235115dab3324a92668a=
6a66e50bbadd9010c83a0614a27353b64205b13f1836123348ad1e1fbf7bc289c3c130f29=
0cc1e2f222e4a6b6e244f13c40bd1d29ed23a61d7f835300f9ac3196fc7346178e8814e09=
126f63236abd0863163346ac1224bc20d2fef5545c5bef919e655adff01c5bd3516e9c933=
fe06fba26a6cd5b6e9b16de825dfb327f1b5981521fd26b6f2bb13305842198aa1393b592=
4e2305dbac3895cd494338b1adafe70f55ca9a5d3d54a292c8b22c22341d49a4bff58c7dc=
1b32112696fe6a0eeb008c19b80c492429e00f7e529f54f3aba8f9028c282d4ddc6f75551=
389bc2e7478674a7687a7b805dd8d593cde8e1f17359829c666480449114f096672dcfd89=
a12f435146cd0ffdd75e5eba1683f9814f831a76607af59d1e24a06785213ec525bdcb4e8=
57027e283e6866a45916d11ddf6347906921e05420fedc5b39dc6244cda008f4c45cf2d41=
57ee680d7e09bc74c5165b054594c3439b6895ac51ca95649723f20331a6c7d28171f71e2=
79eba88d462e291b25aa58ea9cc9ad6d535059e7eaa7f106738e93e3af82d11376080d02f=
04d33d91ca9cc451968ba63945f055e61e0925f22e96e03b6023df6b52cb25c03ee4f448f=
b0421e3198744fe261e682199042eaec9df6c0f01f35626a002fdf7e03d09ff9cf9610a1b=
961672dcf683c9d1c74637f037ecea380c43d8dc095a0a37f910189e91286e095a6e84e42=
ba1bca872bcf538e0290cee2da04d6587618c1b0e86e68f5a669c0c753358fd73ccc241b2=
2278ad2508f661e52b0782962dc17e7f65574d36a7cb75c4b7512a5e6dc650466a47c0c92=
cff884f3dbc982a9f9a368466fe7ae08aec8b121233e6af62e316d209de46a147e4fdb3bc=
e28c2fb5bfab15766455da51a4636ceedb503bf79ce48cef52954cc8734f827d1ac772455=
b9cd46c330d5568c18df827be69f77c43761c62c6a6ab2dea47c9c25209cb22b91b88cb47=
3df0a40f2ab668a42a4ce50b16ece3f60eb83a38cde2ba430422c1d38d6fbb185f36c892e=
eb51a48db39181ff406f4fbbbaf2aba4c3521b8ac184fa7ac022401fa7a94c17e6b985eb2=
db794f66e19fe3eee9ba54f92c1d91c5b8c6ecbb013a98116bf250a2ec98ae3866137a442=
857ab0f6f6ae5efabc92604a56ccf4e6adf6f541d9b5d09eaa2597bfbfe783706271e5c2b=
c400085353d7695ff6968cb68f6e91d2193566fb2b3b463959e3ec7d5276fc523fe9a7a19=
50bb436327d59774dff7c64c5e74b82d4faa7b1ed800d30859d46d9c0d70ea8fe5bed2d32=
2b15ea1f0d58d75cb538031f433e144c46ebe8193c614ead57299b77317addbd939e7b61f=
68aea46967ff31a8ce76d6346ab1eba720f0f72150649de075fb32148eea89f3e9b9c6206=
d3a3b8f048a3a06b529ed6f3019d71c0c000ed7bc9ac691df33297be987f00c045f36e66a=
901fe6eb1d1f45398dbb5f4e45dd7eb2ad89cb8345a2a9ae80fccd3db3e2a44b02eda60f1=
eaaf03787e7bf444f91339b1365df3b84e27f3a5717a857c061ea61d876f3e9695a1d0a74=
107d46a4dc37f63d5053672471fc6af8499ce5b76d837020a1c9f0949acc84fbbdf076306=
4891c2a7c675f17364e1d063ef4b5edaf9927f81f9742f7ceffa24855a27cd77895791d57=
36bff7387d2d4eea5369bc6fa28ba5af482728032e0d784d7e40476bfb76edeae83cb52e6=
941deb3b38693bce5ee0ddc1d366a75aa797d1ce43493cd6a6bc9d2d0e5b2282104c60b3d=
582f5242e43564f06d4ddfb348a6310b28951be80638eff3d40bfd1e3496a5effb9e8bf56=
7245efdf3955f93d69c569488a07467831cbba1af67c1931443ceae0aa4d0202380fe3b3a=
517503853224899b696822f66710167cfac020e3a401069a95f41ef72c95652faac4ae2a3=
cf2bc6ba9dbecabe6d2e1b40bb979c4b3b02864002ac765adc256b18112b0daf6ad993fa7=
9089eefc9f7d7a143e2bd33410b81f4fbb481f7d6220a9d491e73513b48def72801fe38ec=
5048de0feb4418c0e364126fd10552904daa722792e3fd98efad89ee9d6388b0f1813902e=
ec3b2f0ba3de02fb206f1c8c19b011dc8e3e75cd5e2daff478394135a1b4bb3a7d70c5db8=
1ac51e377e58a91d3a3ee0c0c9ea0d38c27d8051125c758264f0f4eb530ce71949b5a894f=
d94b0d5ea255afb3332f7c1889a3019393430d98e5b9a4c8328b05ce93ca4942de5951166=
38b1ee2841b651f129885462b55957d25b4456ecd5b6291c3d6e87cbd207dd5406a6a004a=
cab00d06a97da0a9bdbe74984916be262a49071ba290367ccbddbdfed340f2f770030e7e4=
17edd64ef79559c642ac141d7b3eb5d224bdb9ccca29e9c250475a3bae354f7a073466b75=
5cada58c53dc3e4cbc1c4e416ce1e85a72ae7de80e093851f954db2d6ee34db57c7bff292=
ed426897664a246126a06ea450facae6ca3d7e91f71e4328c175adb73db30e65ff9946d7a=
734bdd492c6058e888a973baecb5c678485914f75c853cb151daec6b394b88f43d48877a8=
0b6c51f8f5e423d4c2d7e3cc1dc0756003db4233a03c0cee191f6d2f2bc4698efa17f6033=
f36b542e455f6f3a626124a50cb12a36d89bbc13b89f58bd3e74eb797b904602caf5678e0=
50e568b26dfbefea5ad1441e14d88aea6e0aaab9b929ed4d508abb209f7ecfd5a8cbec1a7=
800a1353386d7d25c0766536b62e1da34e61a25e532aa3a71167aff366615f44b5454242b=
ce32f995c45f819a4c18dfaebcf6a7300da7c487a3a8e19310927b61a3e08d8cb3c36ba27=
51c2bcf88a6d5505e4c491101c2dfd11d9f9cac412a60c42c001569657cf13daca3fe7e8a=
13eb19f8a9b84ccfc2dbfd2cd850d58eb59f5cbed2cab255d667998380c68c40cc96f5625=
5c759a075884540aab02da73ccdc325db31bc5dd232f7d3e787b29221ac4d727b52cb9dde=
35be05efd675f4500a2a0bed230d71114ff3dd8d4e410d10b9c45d90a2f9e94de24d4985a=
b49c1b709533860130d3b6950209aa984c7692f1e5b02f8839a2fbc6a780f0bbce1309345=
ead263227d291816baeb02f78504b528be0d2e87ca44ed10834b2fa80abd540b638848cf7=
f3d04067ec70350b560825263d320262b0922389f36c90b2d9a1d837689c7918217572b56=
f2850a8523814da5650aac4b6793b1a0b1a4942cff6f8aed3d349b40a65a88217d32bd18e=
af7fd8582e5cce0924e3e418507dfacb4da8ef34e5e610d16aa1ba13bf0bd1c96539ab52b=
dd5772dd3db4e77a1605e6228d7e6ce397301e2060681a3282124793f2612fe9c649d50c5=
89d18c2106519a9b164d50ee829090951ec9abe9e35ad1d280ddebcd1f2b196fba98ba1a9=
e9b6c693a2093926e36e0e06fba800dd3d3b8d954081fc43cd6506314e74f55d81689387e=
f94bb05d4c6ced0f87667292a2a115b57ae78cc7a1981694fccfdcf57ee79aadb3b095df9=
9a6eb176cc4587b99d96913b591a2002d4df6ab45cf7a854361e12ef4e52bd7af87027361=
029203816d854d6ac64d6171c3e37f6aa25c72dd6723efa4e469a3e33233aefb8070510f6=
0ed9a37107631aceebe0cc9f9c7c68232ddf4252d9a6109b128ce403a107a12bc593884ae=
9f68f6fb5db31be4a1c84cdaf11b53e96b9690a3649e02904a6e58e8cf7dedcb92da831e1=
ff3286b9cf2e5472f4b68d2fff30af52fd964abcc08ff02c95cb5c7ec734f8cbe54e19730=
f73c463bc85ccb087844888fd952d0b673629825c88055e007f84e4964c3c52b10ae5785a=
58655c2dff2b373829215b7c0f148940d4620f0dd171a4048efd653d9e1e7b1b86629c9cd=
aec2bd15c2c594c1064ff336f39ccac57e2e850ffbf51f1d07a559fe573ba2e2d3e3d308b=
4f067b70bd653d6df147d658a9b4da9f461be60168a91d3ea80f8754413454f2e1ac1d4d3=
28c9bfd077dce65822133be3be8af0fce4a193d2bbad7e357d2f15f94a2ec32c8a6804315=
7200d119bd4a2b1accad343c48480a12127b79a6c6e131234354a1a84ffcb71a494204d19=
ee7ea91ce98d2e5fd16e51b10556e4e8c6921afb877e7194b707a3873fcdfc3fe903f1b51=
9b6d43cabb8919bbe0d54ba3e686890a312b0918fe72b1a907f962853ce51044114e58b70=
0c96c9c8f1fa0e54cb17ebe65f99ed7d98a412ca6030b83d451eb32c196b9c5ed15e34b39=
17dac3909e4c9c9bebbb4788f943348e4d70e8d45cfed54202d6f8a13ca85fb01a66e9e4f=
9009d8f2c5e109521e1b78793346f8ca580ac87e4044454d128f71b9c2779ac50066f4611=
12c401cbb7758aa0d5aa8320efb1030bc6dd68d606647668d33497ff04c2a14da55f86735=
84cbcabc3c2874e563df72251db95ce96d3edf84141f45b553a04c30c901ff56ee92997b7=
debc8b56eb712b13e6494afdb48776270b8e9ff197df8fe0bfa087ec7f2b23592f5909be2=
c209b15f98ec254de8497f14fe294e122f2c733d7530672104a4f8a26d4a5d0a58effdb1b=
cd3c086a131230ab6566e9b62a9fda4f95dc839945c100a017d26b4dedba6c938e67ba415=
c555509191e0dacc1b1c24e904a94aa7f31e3bf11aa125b10604f78cd54a9cab9d7d66d7e=
0168660b6c843380a79ba9de35fffc35204cb1a874a5b969fb7d0fb6b3cb6c98ad00fdbb9=
c6d4519b7e136c88d412b08aab6440e658c2d4a6468534f76cba707b0793cc1680afa4ca1=
a2b3bc595024345751f5931ca34544fa2d8679fae9f44dd654d2aeb4888e4887156c2c96a=
c1be03b763b3c6d6d29cfc705f53d6acb0bd19e377438a4b7aee350c7cc1a09975bcac987=
a1a6addafafccc42c46382f64a8feeacaa5fe941953ca43554b09e553b7afd608e562e107=
be16518ed89f1156b57f8e82547364ed7d2e7854b6ee4b11795f73582880f9cf135b1edd9=
07944d6ac1c78ae2350705dc0ec6dbb6201f53e6493570a919057b7ed7aa057480cbd5ca4=
69bb444871a784dea7efeb1c41b5c12528e467ab4632485fded442ac97e1a4badb4dfb2ab=
474b7e43ab272313c2369fbd84dfc19374615b5afc021a4da350d2ca54475130c9ac15278=
e99f6a1bf5f9f040585bc3e9860ac37f50053cd2243341d34f4e022f22d386626b1b51aae=
697699ce83dcb6b3f9dc60717e31095410596ce7aabd4d4f316ff5873c8f9613154f2cc15=
03b7fff821f85eab53e34ed3e2f5bce8c29ef4c0c606d5418fe7026457e98e52ba3cdb0c4=
d764d278224df2e04a97d038655163bf2f71504e418440cfd2f7aee45a505b1d9722d09c0=
dc196f03fb7878e141169ce3d79223118fc61c4a7737ff3ab7d4a00949f62a5604e116e36=
7a2a5762704dddcf844aba50c30af2a96f164142436236458af2e911c4f4c7c2793c44701=
98fb3ba6281878aebca1f321e1802cc6c17dad9e6feec847969cc50becb30a17256c3f2a5=
efa6814c3162627cddb058b180427a69d15952ce772ddda16c6c9129c3cce154d29fde88c=
d1f79556ae69d54c7ab9634e3356868e51a02239acb3e7823f8129342a847be4a80180422=
2cb922d97d7cd35ddb8c0661ba1c00a5fd11a38afacec0289d719885117287acc42045929=
1505a9bdb92f85a1b9255edb8da58553f0d5e7a3fa5b9f90ec0850d0b75d3bf8c8ff77646=
8cac504ba1712e221cfe080a01e8ea9db61659f1bb093e2835c1eb64ca09bbe6949bf3ac5=
395202a5295bfdf3d38d4b756ffa44de934dbb8ae9181c9bf349c384341d97649a2573c89=
79923a092d103d58f6750c5cbaaebecd7fb680e86c505a8f1e3934e0f9a9fb37d472f3e9a=
0c1b40ca3cd4f15852e744aa7eed49b9dab63274d21fba9fd312138732ace2df968831e6e=
2b8a806be7e720f44e49c9ce98fd695da218cd2e341c91e4a046ef415c07492a9f85d8860=
35b5fb3da7f530e955cf6ea0f1d4a6d4b745d83cfeea40a6c547d4c6601bf2285623caa04=
3731c4c17b6b93dcba2fa77c8ce61272cbf7760b51f64062d0b560d8c96e8d5132a07edda=
b48f9c9537aa830ca59c4052e82173406dc9fc2a07862c169a21c80278feb9d29d2a45589=
4c8996681782ce4bd11f21b957bbe0714539c0c3f8025a964310b1f60448dfefe4b96c410=
a1151b13a0f83debd8411ac6df886b18ce497295cdaca1dffeee7b5c3e449c3cf374df3f9=
0a9d6957f0e2e0a860ed547981d506934b4621031e1203c940dd91e59785bd59e657fc273=
23fcb6ac03f74649ba9705820e279471335ed03bcb05800afa808",
0x2000, &(0x7f0000000b80)=3D{&(0x7f00000002c0)=3D{0x50, 0x0, 0x5, {0x7, 0=
x2b, 0x7, 0x806021, 0x8, 0x9, 0x44, 0xaf8, 0x0, 0x0, 0x20, 0x8}}, &(0x7f0=
000000340)=3D{0x18, 0x0, 0x1, {0x8}}, &(0x7f0000000380)=3D{0x18, 0xffffff=
ffffffffda, 0xcc, {0x3ff}}, &(0x7f0000000480)=3D{0x18, 0x0, 0x5, {0x4}}, =
&(0x7f00000004c0)=3D{0x18, 0x0, 0x700000000, {0x2}}, &(0x7f0000000500)=3D=
{0x28, 0x0, 0x7fffffff, {{0x1, 0x2, 0x1, r5}}}, &(0x7f0000000540)=3D{0x60=
, 0x0, 0x1981, {{0x100000000, 0xc, 0x7, 0x10, 0xc, 0x0, 0x6c, 0xfffffffe}=
}}, &(0x7f00000005c0)=3D{0x18, 0x0, 0x4, {0xffff8001}}, &(0x7f0000000600)=
=3DANY=3D[@ANYBLOB=3D"150000400000000000002e0200000000000000f400"], &(0x7=
f0000000640)=3D{0x20, 0xfffffffffffffffe, 0x1000, {0x0, 0x10}}, &(0x7f000=
0000680)=3D{0x78, 0xffffffffffffffda, 0x78f06e53, {0xa, 0x9, 0x0, {0x2, 0=
x9, 0x6, 0x4, 0x1, 0x0, 0x1, 0x1, 0x9, 0x4000, 0x97d2, 0x0, r4, 0x4565, 0=
x1}}}, &(0x7f0000000700)=3D{0x90, 0x0, 0x3, {0x4, 0x0, 0x0, 0x9, 0x3, 0x6=
, {0x0, 0x5, 0x8, 0x8, 0x1c0000000, 0x3239e696, 0x7fff, 0x2, 0xffffffff, =
0x6000, 0xc, r3, r4, 0x5, 0x4}}}, &(0x7f00000007c0)=3DANY=3D[@ANYBLOB=3D"=
3000000000000000080000000000000005000000000000000500004000000000050000000=
80000006675736500000000"], 0xffffffffffffffff, &(0x7f0000000800)=3D{0xa0,=
 0x0, 0x7, {{0x6, 0x3, 0x9, 0x3fc, 0x8, 0x4, {0x2, 0xe, 0x4, 0x6d8314d8, =
0x44, 0xef, 0x3, 0x7, 0x7f, 0x1000, 0x0, 0xee00, r4, 0xbe3, 0x3}}, {0x0, =
0x9}}}, &(0x7f00000008c0)=3D{0x20, 0x0, 0x101, {0xfffffff9, 0x4, 0xc, 0x8=
4d}}, &(0x7f0000000a40)=3D{0x130, 0x0, 0x3, {0x27, 0xd6, 0x0, '\x00', {0x=
4, 0x50b4, 0x0, 0x44, r6, 0xee01, 0x8000, '\x00', 0x2, 0x5, 0x3, 0xa, {0x=
5, 0x5}, {0xffffffff, 0xfffffffc}, {0x9, 0xffffe322}, {0x1ee, 0x5}, 0x80,=
 0x2, 0x4264, 0x4}}}})
write$FUSE_INIT(r1, &(0x7f00000000c0)=3D{0x50, 0x0, r2, {0x7, 0x2b, 0x0, =
0xfffffffff7020808, 0xffff, 0x0, 0x6, 0x5, 0x0, 0x0, 0x8}}, 0x50)
syz_fuse_handle_req(r1,
&(0x7f000000c440)=3D"80cc949a20a10570b22f57c72b14b6d5b9656d619411d3e0feb9=
96f638296baec90caf0305c18523d32f8aaf50d3b62deaa3a75c2e016f25efcddb2e4e5cf=
e7a2e24d813ff5e08182e8fbc9353537f68ae28a6548a83e5662b382002990c8b32a687cf=
b9922aa8e8cef4d8f1c1e9ea22d432b3ccdc80e9b39e792b7545ae90a0880cb7f49edb763=
13335f65ed0888cdf8a79f3a22028f6035b8a77343e12b2b48d61cd8dadd99ffe4ccaf144=
36357b8f5c4633a94b27d21367946bea971d2f2cc9c588402be7d1f4cc9c78732b4650438=
da4a781b23ea5cc672d28ce0d78fb13a532779cfe3689e62f673ff4d4edd72d396bc29607=
5a710424cfe4fd1d38ce799c319e58f5b5d76c995ca60bb98f1a027c5122554fb397420fd=
5095c0326ccf221f017dbfdde47ba8180ebb28573193aa67076f503ce05d7950d220bc8dd=
ab527f0117a30a9c9fa977e6eb12024bf97ac55e5044b688f8ece30cfd06acf52743837cc=
9b1ae37af0113cda07abf471828dad657fd8a2cccf307f16e21f938b3c3c03a29bccb9f1f=
4854067c7eb7664f505a7fa433eac2c3e3ba6fc5393e376aa0662d502e91931c8363fa08b=
006e35feee61403c93a78cd0722bce85f680ee04efba31f47f92f1e391e3d63507aa49d8f=
063707900f63faeeba28c3d53cd4dc95af6e916bca9896926775f990b7e528b15014be706=
414ca96c59bea21a312484d3d6434c8150752bccee265c64742549b9bf94d64a100ea1f61=
2de41a7a4f34afc0f47a23a08630e3f90da155f6b5c90dd9a6496e23e80cbe5dfd3527288=
3076961caf332f97dc3871384379b2d6ecafa30ceea5fba0d68ba64fe7d235046347a4759=
f870e5bbf9ab1c3ad3281b63cbe1a9f0de5dc38118aebaaac3d8a42bf5e13489da5dbf0f5=
0a02291a1bff4af669d66679658bd3ac40f153034cadab5e07d743392a491f3daf2737703=
198cbd9f18c90d82dbb2bd92160675b5ce96f4e3609bfbfaadaa495231b581af70fbc8e2e=
29cbe2ba66b86942d24b086945dc9b4660ea211b193c19bf11cdea937a3699ab6131ea26c=
4903121760b6df20561fa2a593700d7ff0e71aba5139ccfde4776e1e60233a784c72f4b7b=
cdaa00f60cb93c25367752c624652981121dbafcef1c96f3f514347a5adcf3c269df20914=
00b041d52460fa8c6b81e857f88154d4fce7662bcf27df14917a01170b0a36b36b49b0cb6=
9af47247cfe08812597d74fe755ecd1c1ccdb3b0a3c9a2ea65c494bbd669b51ab7fdd2bc5=
e7e5ad459d6a9c9f02e59f7e0aa1f45de43cf501423616d430a6dbc577492c8adfbdfe707=
daf0fb401239592bf301361770d155cfebbe9d5baf0dccdb358c2c0d7678d6a1ba6e2fc16=
f1f0aa6b3b9be72b37c22fc76b0e4e5b9fa540f116682f694e9ceaeac5cbc8691a935fd1a=
244b044ffeb258fb01a035880cb17e7dde5170a35d44816482f376d9d48b3b807af0f2138=
f8b48a47a18207745568b349db4661aee07fafdde33d604230e4d340c4f9d9ba0d0ab2929=
4f7a31983fec1a75c6f4394d710bf961b5d4deda509ed7602df284fcabcbfc99629978360=
7934c8e0feb1dc2efb258586e71a0aa5458d50ce5560f716227a8d8c19f42f931b2ff0c44=
8c8999863cd85cc5327c76644de795bee4cfa6ae5e1cbd8679a32b489ddc4af5c18483b73=
25937d4a4e77ffd4365d042636fbf8d2999812da96aa1373f082b22c0f32b7d934a3e7dfb=
7ef7ab62a72671361faf92f291056499a7d58860229765ff64168f7faa220eecbd0d238e4=
83094322ddc59f0477836be13328153b83183ef80083e8c74d423009ce3699addbc045b30=
62f81f2609a60ecee4db9ae80e992ccd481ac5c8953e6a8a333810e1fcf7073865f67140d=
a698a46fe5419667025febf699b74156fc2fadb737266b0baa6f87a34bb73115b5be02e15=
eb389de5d1c9a798997baa4410547f8a69af2803bd4b66db6cf0a865119a96e721b71ef96=
21ed7219f1d2497e55883480d663d59d9385ef368a6de2867c94fcecc73f6be4ddd6a3f3e=
b39b5c7c0cdc501dc69f156295e2f5345a9d8fec7fb1ae0ae1c5bda022eb7218faae98068=
c7686ce04f2c8ceec63ed8142380614d7b099bfa9455374ef90e3f9799c6b0592f39fc622=
8f7865a9bec42ab2d10775094a7964a81110de801204d434f132c848e76c6e7464fe4904b=
0e5c82a4b122fd21e69beaf1709c97ad40714b28d55db151dc99b8f5496814ca8f0349176=
ad7ae864ee42497764f39bf10714a2cdfd50fb337cfb6e4db18475ed71b28675c5954b078=
ce1f035022b5a45bec61ff614d235b4b9416ba38ed7f55922d14df5b26487a9d605ae4cec=
69c8396ec66aceec3b15bda52455c36e970dbfb7ccc846740226f0c33427dbf45e0275dff=
f5218940d36a3a06d93d414b0d2ca160b2b5d0de5f432d3f36a449f007068d2b79cb2fc01=
9d1a15f6efeeab03afa45da9c1c360275985a839cd0137455885ea2a69aefd48915e14e79=
73ef44844963f42062712d4a8be4c3da27d8549fa3d65f673faa5bc6c8947bcda7863743e=
4f9f2e7dc62eec22fa2e9b669f87bf4c303e891258b91daec9c9cc65c5983fd91a77f1ff7=
2faa639ce26ba95f553286fdec3759a37f5986c9a7a0ba711685af75c1b04bb743db4d0a3=
9fd191147e2bfe375aa8d6223e7127bfbc495d5bcd4dddfc29ac13a12a8044297a4caba53=
d63e899e3242ceebad1e6e7ab43f3a23e2fd007352866721411ce9ac5e95d46674b2be228=
196eed9a7329e4d282ecc837215310bd64742b5c9ed8fb89b5ee586b6391b57f6d52658ea=
c832b6e01ea774bc5c35ff1c496a8743bdd15e950b9eac1437ace59b8c8aa91831e6716ea=
6fa44bee90f89206c688501a88de558cc1b283d4e2dd62a32fb108dc02ccc7d01b2cef61c=
09403d7256e0a8439828818966fb06899cd05dcbb52a9b8238e2f6e742329b170b1286d80=
ce38796311c94a77c0cd13e09610cd84e312c0d8c9369c6454b98ddb40d6388ee4a16a408=
dbb589bc9164c9ff89ed34d92d09c2935a1e8d651fa364639598a7af49bed103eb975c431=
62e1f06b51f4c1316ab61f98c00b99449562055f476e1c91dcfd2b6e5c9edfe4a942d2ae0=
4962399ff0f700c4c5a5f4ab819d1a1b7bd64767a7c635ee70ded32870d4149359faa38e4=
9e0a8c7a61ab377b3cb19767d3e50c4b844ac007d7ca13e61230924c3cea444da89190747=
05e79a29e0bb1326bdfc97dc5bafa5b74ece5744b40a99c9f4d7a38bdbe5cf3065f9bd89e=
f04fdb58975284fc36575bd840840f96fe839005743f840174182d9bc84abd5a2a5d3d3d2=
6310ae37534c574c6fa0d442b1fae60feded31010a206019f1df00f2a07b8e576432f4063=
464e808691cab001c5f68295182c5e34b8e12f96eb5844ca66177af647c16bf2c8cd61250=
68083489ee2672944ce6852e5c6f95edeb86c97c86d4177bbe7a484464355f0ec7d0530c8=
d4d196122a3997a57a03a0484fa09eeda2c00a515edfb31feded6edd66b6513c5a9def92e=
7923c1f984469ba7054f96af55930c4c928c774c92606d8ab63d694cb94c2afde226be603=
fb7a0843c61965cab2af0e661c336789d1b6b5b4de8033da91497a3c97ba9d8d483d2406c=
76c0e1e00ba9a0901a93812d15ebb0f6a447fbd3dbe15ff1827a459365f8c49c2f6f05826=
ade87b51175d78e786998e2818840605e7b7c4194a9c2f251912d8ae4cbd2674f95ef96bf=
e662ed7c412e2e2ec8caad8967f1f320d3b2669ad65f39b5405ad1bf0af9c65e0ccd1779f=
4743e211c032c2dda00ff4fa223731845ec80134710c732561ce317a2c204eba2bf298f2a=
885e2348a7cb07dcad2a7baba7a5846170163c6378c7ab742fe05ccc684df993db0f062ea=
fd881554f8b44f6913acefaab6c5927b8ff7c0f5955c85cc9c70c04b6fb68aab8ae8b1978=
0527aac4aa0c31df2d8369fad0990c884d3e0234b16642e0bee5cae0de6288fb1e92c7edf=
967037e13f07b3f69ff6a19b6a7ac4315810919db8499f38039e2399be08d9f7b101bc43a=
24a09aa49d82f7c235a359e7a65432d427afb910ce19bcdd751292799e94aefe5df558d7f=
03a6010c1a9d5e5957d94c63ef221ca7c8f16c8e639ca1e332c7d5422b2b7b5589690366e=
dbd0cf21ee41b215b84a1108e0e6899c25ca16e4f5f0d58f3d8938539bf970e2b9192f310=
e2d20b520871ded3702dbf5caa3b1ca0ab9dfc3563daeff6bc4b5949757a8c2e3ca9a67bf=
295b123a86294f1250b4f35a0b8b7382446f050d2b62dcacfec5c4bd201e00a50d3d2dd97=
eef43b3e3934392d9ce77262400f2f04ed714ee7a18b79a7ff98fa60d934af0acc351c2fc=
3e9f416ee164fab7dc0f6067d10b6932520c2cad5d0d1ff5622bf8ee5f524fb292ac315ea=
ce7d02c80f885749a096b43dde45cd411642282c163fdc2af62b9dfbb7e02005dc40d107c=
4747b7d749d1607a7cdc3ec29600bfd480c80fe4e302164ca3765ea070de833c5efdbc2cb=
396306f652e00593682a3392f9d2af52f3377003f2771ab919c6d5c86df6f5ef335084b9e=
25564e510b7e1ee1158e4b011043fefa03767cb6a4b647044f247f1d24f9d27a95b84347b=
5495e81b1d25f8cf3d00ce81cb58aa461858768e052001ec35072d1f68738667381941128=
8144a7c92d120dd58453751c8825dff0dd699202dc73beccf1fc161ef12bdca01bc982bc9=
3ff7927b0bc5c076db8077ad0088fba10f5d17b50740f14d238315fecabc89ca4004db899=
0685c51e7272844db7bc1c16be97622cc7569f7eb799708b9c44cd15500fc48a577a5ef21=
bcdeb4b01b1966b46fe5fc1e527a5eb72054265499e36cbc77efbef2f3ed56abe3e9a7fb7=
9027179855bc52e23a635fbc1f97999db95312408a2a6824f9d02641bc275f5f98891b1e5=
571fb985b4aad3c7542bde57186aea7e04c23b344aae36e5842264ff5d7f3d97b8fcab46e=
d86f33d61a180bb9e8422cfef7e9dbf6fe6aa1f411e8413a5dc3f1fb2acfca42ee728d684=
f6aee25e8da3567c1cc1775efabd4300b9963fdc1f85f213af53a74fc3a765ce2ccd33435=
b4a77e78abb45254cdf197a155af61d96456e344c2187b86637ff38ea31f1ae06f0450dc0=
7c4f75483d7465dc1c858c66268bd6dd79aab93034c4bf074916aa0af59517131a3ee7ba0=
71a8e8489f8abfe5ccea8fbd19fd87f13c0b79ae9dc4aed40b876d4026dfdf81fbd26c147=
1b3d089d8f42b59fd4e333895b62cfad10643bac3c9b3693ab266e458429332a208fc31f7=
9d5f3bcc467c918a3f7ed6c11978459a2055cfbfa66bc6f4842d1a06b6d1002b831f0fbab=
4037e6437682609510b24964fda2f3a93f114cd309347cba2e957a85afe51205d9a379a3e=
1f071774b25e02196cd56066b04af86dd8ae5d232e34795abe101d22f40d8de9be579b744=
1bff26297b6acdf2a443ec68162e9f72e072e3c36bbf3699bb24ea36a00e2a331e64d7398=
ce667a010ecc60458ec1e36b5240fad8146e3879e89400c7a1689185d96f3e42c14cb634b=
8e33c295a069447136d25426e48c2dfa77d11c3b2ca5b1ebe5ff49b4b1a216b40f9b6dc82=
3e58d4a4a686d8e24f3ab217b35abe18dc0e57d1d6908e32dfc26da5aa1a04e3b7ee1d015=
226f57bc0da311e7dc8cd2f766f1e4c40bc27b7b62b38985f768a7f885884be43f9e13af6=
6592decc37ea77b83d82997f27734f4d8f1ec2bcfeb61fb73169a37953a1bc699ef2ae336=
5c931001fb42ae1d2c2234bf184dbf4c19e7fa0a18fd0b374140430aa14edc03b2abd1fe3=
d2d515c67e7155c8066366cf0f0e4c72671a3b812d4b25844e5e1b59de8d1bd13a5a06262=
511b2f1d43da6608bab3a406723e17742621155ed8f771bca33b4aabea0ba02c7ef8a5ee4=
4e19a09a2a9f298ae4faaa347d3549f1aa15c608fd8f3c48ee91e5d1f7c09c90d13f1e677=
313a4c074a1a3b6b3c7a184ea34875afc9c1ec7d8f4828e9dd9a4bd8a5d101c8770a371c0=
8f446828de72c6b9f09b8e964e579d7652c35799693c7aa3c666116dba3555ea37cf7a40b=
43e1c75a4d8242843362d8f46b13a071ad5e68db0394c5b2a89c75a8eab80709d80c8b479=
e9f98726faeb2c6c2dbddc6fd0824bf0c7976b39fd50acc7400d8f69c7830e1a72985f981=
8e62af00943d4aa9c710971ed553174f1e4fd5934d5382659466a9acff619605796fe6a15=
b167df17991c8eaea0aa300528e2b50478466f4d296f7cc667a21fec9e693c4d4ca2c9c2a=
0e6fc4fc92757e2de37fb7813e5127e6c7138d8f7359ee0e97d479161e05c608e2f709729=
f1f4bd43772ac8a1c4615c4ede74a91e4a16458b0de739721d2ec8b0514a79161ce008700=
8d3cd97fdd5538c518b24b28419f67ce0fed106b4df122ba9f51af5952a956a0b9c95319f=
5c49e3f7b48a19dcc9d9f3b5ded21a9562207f162b805b628018dad3161f938942cded99e=
86f51296a815a9eeb1cdd60330a2573ce7dcdb07643fc3d5362a87db6a1ef0014bdf70edb=
584a9168eef7c4baa260e284a5f221b71dd72a23d2443a393c7a3d415b640e6ef68b6325c=
c8323c7441b036950efad4ac9fb10510cd11b06d1c5cc8258dfa0c9e52f09b47828c337f3=
291d311a450844afbd52de50527d4cdeb06121270ce90a29b8f3fe79ea68ad18e2d34148e=
643a706fb24ff74dd8664abbea9894f2544c22f174a9e50d954b6359af53fff54598a7e68=
6c84299c84721b57276c15adcac69ea92b0a9abc225bb9a1a6f2254f51aea3da768b324f3=
bfed0bd4170fd1784d17384fcf16e8cf23bec1a23151cfe2c81894d95599586e136e70ab3=
9d867df88147f0cf56a5bc6d2dff584baa04f7c1ccdb41eae35345bcd2f9c4160e5d141c0=
714ba4e00abfc11ba3044b566252ab24331428160e22fac02d71704bba9cd3658e4ad1edb=
5dda5e0f20ca2b768db78f9835501a0fa53c21a390f894ed62d815a736f6683e0fe841eb8=
81db6941ac4199e1a91f74ac207928bba024490ca79dd212adaad5b2125fc1abde7214e77=
5880daee271128d3b110c1f4837ca23762469b3e046539b0dcbc9efdc74d5729f9554aeb1=
1cd4f169649a1e0a516bba7a2744529e7a5bad1cc654713015476353c04ada5d5a4a41e80=
cea1c72bd97ee95aee3298202208ec13ab9c8c002ed999ef0c4114ebafc49333ed4e8acb8=
ecc346615720c9635ceccb2b4aae738552cb3a25d00f14fc49ceda292c0ba51e3705c8910=
b849bc40bce90825cffea3b93003f23eb2722057e3324a585a9d28f8407f01f38b37e6215=
37a7791cc81ed4385160c4e4e33b8c400000000000000009bc7b62110f3d43b36ed066f2c=
c903c712bb134e58a37349cae68d9ee2da8831738c299f71e8abf9e64186c234eb9c87e98=
3eb31fbf854fd809f5b5e3994fb287db385c67666524cddacf77955ddf8eccc91e4ad0f97=
4f56720bcbe28e64ca4aa537cac33a7af5c64577d9ce3ccafed63000afe624037cc6f50c4=
f1843f774227b831e462e6699d31d8e862de7839a6c21642d02f42ebc1f97e57277565a35=
897dfedeb13b595f89ff9ee7e923e87f0a8e218df193da791b5e6b5125cf010ea46ad97e6=
9fba91d5a5f5910fe4c62614308bfae38b493bf47730b2407f58c4013b74787c3b2366e11=
c56f24864575c03e153fac827dd8cc40b7da5cae79d7348bc9020e8d953f030e69fbdc151=
b844864b7928983fc52ddb78f7ca9d969f0df112426d71b6213f274f4c6f847cf2690ef56=
9e3e6cd1b4690cdb15ee899a4cef5831b7b94316a817305b5afe6b7e04bf72b634421dfcc=
78062f21ace9a094e71e54fa5a68ce305ff8d655a4cb76bab1a5f65695068ddcc713f894d=
0964893f0e8ea0aaded011feb0d7e81b0969d62b19c399d303f9355577c1a7ce9f48226af=
f3da483abc841f994f6d073a111751ea78db37654289d4d26aea096e789cac8fe3bb23195=
d31a7b8033ec2ad09839d15585daa7de2b0ed14dc178df27b1c6783bdf2d63aee1d0d4b5c=
73386b6c193f6bb19ada653c9d89de533a5f95d731111048d727b541f8e130e9b0c698e06=
95b12d603e6c600f7fe5039ffc0c8e9dd06d67b8c040a341ccb89399a097a178d70caa101=
41665898d836ad6a63f1f53e5f71fd16f5892c9a4b8d6bd8653a7ba0a888f746e3e050777=
cf6d569e43772b6938b65a3a6d555310d003b74ff88afb640c1584a163f3ff30564fc974f=
2f92f92f4dc8eeb8e09c25089c55781100f3d5025c6f8118bdcdac966fc3077447a43fdd2=
5496771f9a7a5f88a1556e9e48f4251a56ccce8830bb60905006029c562f7540684cc47e3=
98fa292146b2579652454c89e2f3b6118bad6964176403b431490adf3d108f9ee0c91a7a5=
6b4fff0c0e3461e45d445a65a3108df44cada6fe0c1bc98039188b588f223726e5d18de28=
05c901c92aeff6ce7f9072e6c065d8f5e08a356983abdd55cb89d4062f90c0bdaff31b070=
786f7957d48c0006a4c59e9705172061579cda17c0fc953045cac664c8a63534101cda0fa=
271f88d97e30121923e1359777ccc9b477addd6517b5993afb19c6eedc4f052a6ee879233=
f9d1f3ec431e3aaa787e561223ca44906d3ac85523e3332c29fbda77ba95a16d6f99aa893=
f7df8b0cacff383e196578b76b0f847bd440acbba3d9642dfea94703c39514397ffa67175=
1513c15f1eb5614e54c1db8f9fcdb515e6175b13d19eb82edeee6362563ed91a3229b8876=
e299149a51a40a9718da40cf3236209694d3aef482e79349e88e1ef23a79ca484c4c04eb7=
732ac35733af6cb4f5dc49e5c67bb916ad485bcccec344d387627a3b1b97d7f6c82f5e293=
13f19e8e42e065eb94120bdd1523a11ddd326514a2c8a54338c5b86328dc031cd07ab66b2=
b4a52f3a29a33dd776cc33a7b0643b6922b00c05f726ea96d2bf9f52c5d88c4c814a1ad9e=
3df182900176a5daf9006bc0b3987282ad472a9ff9653335110020bd97df97084afc01fbf=
75f5538bbef39f934d781cf5152aa43219b4ec36b5d247c2f037359b02a21931fe187f772=
10d4d6745963a8cfa379e5e581ba0096574466a112892a85a7de6b5b71e8b5cbed837a121=
6b52aec86c2f132a5b68cab5f4fb8fb4b8e66d0b8da3ec9440e8ad3e8652ac045ed7ec82e=
46e49d0006c1112ab8338ecab8660167e2db4930f1bb2e9fb5687f0b40b40e0dd6b75e78a=
082fdbfea91da3f07b57dbec8776232f312b2d267a8bd372aeb94e2ff2323798553839c96=
1d820d701da8a67a1fc0efa49595f3a88eadb8a01c80c239968925fe2a71c4c3571511d13=
638685f33a2957da0f9b3444e9c1ad13e6eeb9175bb188e2cd28e7db490b3f2cedc96c77c=
01ff7abcf2b27c2086eae3f3b4a1489c5f5aa067065ce96108bda1000f636bce346722c69=
02511ac1a0c688b0f49552cbce6c05436773b43cefd7ca335ded24e17d92c61987bb87693=
555b8ffe222d30a99ea4ab557994ff136c2d9c24872f66e91220b339aa978dc250c435d1d=
04d460319e0ba2ead5c8329698ce1426d42705497671e127266ce256a20cd5b4d859bc536=
1c5319801576a598f6d391fcf41cecb2663226105b6308ccd81c5fcf52c30e7b1d43d7392=
8884f521ac9d017da826d1c079445be166065ce5974f92fe92645342aab60d5417d1d0a20=
6bbdfb96cf4346023267aa3aeafac6cb5ea594fb452635a97f4f87f634b477bee33a3bf0c=
526c8e5c091e7213659d3fcb8773fbfa38f2edff5636dedc6838a9d7e279228a56f89d5a6=
baccff0461d91d136ea8d097c83993804f54fd264db79aa67c81e966a352b1b9549247fed=
c317019fa506edba35b0e3d61c93950562a6d968c001e24900ec7609a8f72c9d6953b7eee=
ceda50f237e59c106e16b68145aa746ff3735d279b1162cb0383c0ec9d124c94cc4337f21=
e980d6566d907d0be94b67539b8d10dbdfbd840acfa278d5ab3e35a64ee36b2934f019175=
d946be8723b8c529fe2c171d05e12c471fd8de3cd0d2f816fc679273ed18bf0df1953b1e3=
46aecebfb226746ff493b263dc0886dbe2e7994a2e547f3c8fff2424c1529f28c390d7e0c=
6d8829585c41a730b37bdf5343d6396f244ebc1c695d37f4b343d9e1a56ef15f808323c46=
5e91bfc8b7f23a71e306128b1cb5da4477b7e140426430f458bcdec732d45da8d33939389=
412ee609821e07a47f218f8447d246d8b2df005ca0b1dc70db2e1800ffede9c04b3a1e124=
7c4ac6d7f4065ddcd73e08b8777953ae24a9d0ec824fe75c1220a20b2e9c0b9bdc5102043=
f7ef47da065742ce5930582b670a6b012e7030792ded6c5d3c4e92e8a27a626fb2594151e=
5ac1d93bae6e86a89cbd748e35678bc28f3aba772cd05990260014607c7348e78da39425b=
1e13403a9750fef9820f9b15cc16ff6beb9fb86277c06873aa18c9509cd3597f31502b6da=
18fa7ae25ff104db554e2021edc0860311ad8956d3a415a3f70058699235ba0cbcc304640=
622763985a81ad5eeac54827a4b4adcf254b3a8909959f9f5509d7207c07cd801bf1b6691=
edaf191b4ea870302b8d6b51a1539c857f0f012204572e32e6d64e2217b7918a0acbf8777=
9c60555bafab138b6edda46d4ad8a835a4706a0bf754e7109abc885254949b03e3b2d2653=
85ba54dcabe4857e85d804d3ba72bb38305a143ea21f523844e732ab89a42bdc61f6be1f9=
b28e3386cad2ca92f6c70a613722f3c0c4af72b2cf39d5b734dace0f2e7f66d6c2ef74e14=
1e73cf90c6f979c576a82380249b6c654a7b2ef8372896f96f6f766642dacd5841250c971=
43857e545beab5c3882a3e1d529bb519945412e6bfc77ce99463dc15bad3f6069c5827ee7=
6897151330dacd669814a58185e301d6f0f701908d378b6183bc6b06a8efba3e70a4b790b=
017743ce08e9bccc686fd0cd725e3ddb9311573aaf22f6e49b2c013306c145ed34275433e=
869a4a721da89de4f59602c5c7a9e54e678fbe0e88f64110c975b692390e1f6e896dd3225=
59ab9c629eaec0be9553ea26c1c0360fab02d8e8e16e378976ce57126b434baae51289e91=
6210aa802849b23ec851b1ddbde105bdfe372c96da4ed1a9f4f64464ad704e077b14036fa=
47fa1c20444392e30da43088e0f3926ea1fba4f2193ca38f7baf44889f45081006acc319e=
9fe73b7efd7702543c08ae91426fb0333e3a347c795adc061d11bd524f5bd1570e0ed4779=
6f6bf068953be6a91b43e66607e25fef1305025b9a7558caf9a9cbd1b91757c21cfa254c3=
ff83f5445c0ae3e70c2f295ccb05ae85c5470b893f9768b3c641695dfedc01382bd952023=
331f6401cd20993b7460f0b5f2cac0779f992570d7682afbf5b2f1caae09c9791a3e9090a=
5864e895c372064fec3203700cfc75939f2e9b79e2907cd9ba03708c4bdd4d2fed6602cfe=
12b9b6388988fe9c955e71b90fc73405522ed1b7579a0c278431e0bac8ef597f398440bda=
215da819af94b6bab31f79f9cf00394cb955beddef2b97bfe985b6efed138dbfffeff375c=
2ddcbfa930bf89600",
0x2000, &(0x7f0000000000)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, &(0x7f00000003c0)=3D{0x90, 0x0, 0xffffffff, {0x0, 0x2, 0x0, 0x=
6, 0x5d49, 0x80000000, {0x6, 0x9d, 0x8, 0x8, 0x1, 0x3, 0x6, 0xde23, 0x0, =
0x6000, 0x8, r3, r4, 0x4, 0x2}}}, 0x0, 0x0, 0x0, 0x0, 0x0})
syz_fuse_handle_req(r1,
&(0x7f0000006400)=3D"d1847629b8b32311f0b3613f2ef7623b7e6c2f0db70d70defd2c=
87cb9eb54d5867b40ffdeb44e9ae36c7346eea76ad680d71ce9523a91485d2b97ca190944=
a023518ab9fd3055ef3a96893578d514a6e1843fd009cc02db44338089416f62c86dcee3a=
ba6aad1a8f33bcb5de95b3e39a6d3c1cf23b34c59650f9131ee357550deca14000d942917=
61d77a4be69d5fea5ecddb7d3bc24cc612200436dae9ab65002f6546a6ca09709fb58b2ac=
40bf14a7c66debc3872b9b50451192d62773640e1fc32c8d34da2b8de1903871d4a89d1c8=
33d058af658b1ed6d8396b1ae5b701eef35eaa1e26b5478a9aadcc7f8ff674a1b34b85c9a=
fe9f79e9a474541e1eda27b903af7b1605b8f0cb56ff8def50491d1a63bd3572d3d1f727f=
6a2777c52a47b2ea0785dd3b599e8b33be024ff7e530ff955152d12c8f2429713ebbfa415=
958d657078941782dff438d3c46ec7336527208e7d76e1cdace8b84e1704972c61ba6e73e=
e42abc5e126c25da7fdc366ccd34e4e25f54510f50d7411d104e20b999a238f62b5f58bd1=
6c6095c3ebff448f704b3f751b7bd8cb21d97900ef1693ddd2479df932ac5c27595c4fbe6=
3bf3dabf627ee763ac4b09425f7a1ce69aaa4e86d4fefbc9f011eb46464418c2f313ecf38=
d260038228f015675fcd1bbe1fd70e29a0a8cc39d9265536b47b148fd3afeff11e7a99e4d=
7a375c9589adef1a2d467d8c5958a435fe35228619d0ecf823014f397cb90bbba46748c8a=
ef37c4d78631749be4625417eb529cde5eb0067207b0831cbfdef67263f5e631392fae413=
ced5c9bbd6f0d69d2e08d69d00602038f2f8acf761e3595200586d54946a0b27e2837ac97=
b8352905df9d9b198d45fbf967e0279d81a6501ba3df534a2846b210be34875d4c10392eb=
f2cd4a880bb7b8f73a70bf225855f0911a426dd3753804947c489f7df4820dacb758a6cd0=
8d416102f515459e96f2d9106b9264e4d559ecc488e562a8e1e7df3fc7e2ad7f631c8e3e5=
5aa6be2f7d3c7b5055e775f6f86864bbcd91260dcc5b96733df038b84941e7dfb06577c88=
5da6887736f8e8c22989fff2e773e406856eac71220a471fb0b67b2e45b158126efb34973=
9f3733642e63f34b6c458c495e5d3551dc3600c6d75a3b4b1a06f59adc8d8bf1f74105f61=
e226a0b80660c061c7dc9e910e0027aea8870890541a090c094cca31dd252520ddb7e98d7=
ef2353a4d11d0dcd5d635f0fb9c429a69cc2a08fbfc07943d910a97a07495809ffa545ce9=
03571b336f27c5061fb88a9d8b5ed82c71573fbf6825d1101cd91883863c073efd4977eb4=
cfe87e6716753076dc016cdc383c3a17068baa21c71690488495bd400d3c93961a73b26bf=
12d60a57edf2dcedb3d9b3b2616fb62862e50c21d783a533159b21635fb316f797fc4e2dd=
cb591db40addff2a21872f1c499008929e58500e4c6f55ba800d58026e05eada9b61994a4=
12f174f2c39923cb1d02505a31235f98d8c523a574121e1194ba4781b5ab4d3223388180e=
37c9e435d7dda498002ff8d3b3404e40e51d4451a52eb3763d79134396fffa3fb15804d9d=
1b9779ed5e31ad6740ada75535d14fb41e39ac7caeda9bc01399aebc226f3727fdbee4165=
b98da6645430312482390545e966db851d035904ae2b064b262bb76f9abf531b9b9da2846=
c26bb4019aec5037b81c5d0dc4d393bd8bfe7daf1d1dfe0b3c96c6f56a5e9d50e66c61218=
2430feaabd865ffb4541ef28014b7fa5b4770231a911cb109c25c596e2df0e25d33550b92=
80e1944a5af2d374e4a8fada818edb964eb7800665ad7e6d33031b67070a37967b03f5f19=
249abcab594c45e6588893f9489f5e176529255918002efcd37fff92421e629bd103835aa=
2bc0cff824f4970c3b1dde2c36afbd169f6177a59ada0637f0087a358524f62d6e0d43bcb=
8ff5870a61048b33f808eb0597744c6fef62d057421f66ba1db77f08e946987140de3cf92=
4f04f75e211f06245fd621d897566cadef1ab84f76a4a5e638e8db97b51ff83494f061439=
1719058ebbbf30f9002b7ff7e83ebb84d6be3496cea286a426df3696fdea1a86af37cfa19=
f2b887cb364591c2fcfe9c2e5a7e0cd6b703e30a3f08c16956cf878d19461ad7b3e5e4fb8=
2f2bd8d094982c47f403e0dbb76b7dc489abfdedec1453fd1fbca1a622e88fb9cac1b7a04=
c9071ee627d6208dd10c9280f24f04c9baccab5206dc54d6346fe077317176a9ba2904f3c=
447a965090058d77cca55fbc5de7497e8c02257cc4652d04c9e165d8c0c2851d588902510=
a52403ebbdf0ed412ae1ccf603ee34241a66a80e8a3ab45ba5b47252497d4261c84f505e2=
9d4b9cf31c580eb03aca6fd425b8f987adf82272fe0a10383c2a3349fb2e0d76fac7c56ec=
535bb2f6bb7e022d83ed82cfc5c929d042346da6d939590ea70aef16302ceb2c65f5c1181=
abb9f47a4eee9a2430a9eb44119af9e695119b546b04ca02a9d6243df326cc62f660c617a=
77f759929ee6196a3d7ef87d9329de8ff1b3ab7768319044303341d9fa0bad70f8a5a783b=
1717fd03d4fabe7386139c49262a285d8a11aee8a484959649cbcb76be6f10458e7ac4dbf=
0a01379b4658897193e37b3806149831e4a7a5ddbae06cd9b81115afee98535840e39ba4e=
5a7dda088cda47c0b0a795c55f1f09830473c9f07e1ae8236ecf59761ba6153bdae59fb32=
046bb006edfa45f354384b7a61c27472455291ca07666fababd2a5caf2d968cab5590cb8d=
6edf74164fa683d0fa5ead0dfe9e1027ae280c9c03a77370186f49492187909aa5ff28ee5=
eaa0374f3cac7f100c9ccdc6a355835682a2cfac2a738039a63b69bfd4483d0f758a29b00=
cb25d3bbbe2edd9e88518a5af0bfec28172ac8c4af3e1788bfb966ab370a3b9e147f0312f=
63207ffc2779a02b01644e1a636114862459dc734c37689d9fbf2d6f0a24259f8474d0756=
c971e005c47a6fbbf2c5047d3e074c693dae1b41c8042da7c2f21ecc4bacb93d96ff2621c=
949628079897efd6f42d6a4f225b46c92ce1448abb02d16e8329f0a133757ec1a4c3c82ee=
f0baa694fe13efb73b59196c39d258b6ca8ae25da0ae0bf8d9cb90d25d2393f3fc7401770=
3e9f4f30ce039fec1cc32606e013e518e128c27fd28a0b0d621290a8c1cc2a0ce446d984b=
7f45f919daa957ece47731fbd1db23b0b284c6886a09bd553cadbce93478f5830fc80e42b=
3cc2ee60bbce6b4a61d8cb00b2a92adc91e32109b812ce40349a7bd323b23981b00442725=
674c424acf8a270a30d7f4ac3d05e215d1a8f8574bd40935bca48093c0405a51f25d99bf5=
22eaa1bab75505ddbcab4ec301c85402e233c6850dbec21ef319beee2eed4ab2448b5774d=
efb10338e28a6891d54fffbc71a48ec6ec9058eceaf1c486056c56bb9fa0a93a803f174a7=
2d41db738971b438ea8cd91b7d5b2eaf20f36491169ca149fcab51d7ee4c0fb96ee7e1b53=
a733cc566327974ed92abf15054772fafc397e033cb72e847cabc4bf3ab5d1eef923e7eb4=
6f6abb5249011a7257440317017ba894e50bb20dea98dc9ae97f4d601a0210067356a2ae2=
bfa12e028e594e33402f23b2bd5c772bd930678476c74a55841a23cc668f0b8cfc762c30b=
eaba8cb1c1fd5bb64b5ab4bf7544975aec5f1e23173ade8c10da5dbcf742e16abd2be132d=
af713c2362b77737dbd3dace189e5aee33231602ce46861b83af76630b0dbb0da1b87e2d1=
83cf3f34ca8064b2d0a6784548ae3fc71797dc5724bf570aa99c50277467454a51bde468f=
0e33541a23cca11a32298aa52d573fb98cdccc55043fedd4b57ebe921c1791b5bff68c744=
06dc2f7c2ab1c7d11ac8c83fda5aac9c80cd4cacb8c94f0e0a169944883f2b6c5d1a12ba3=
b79959fca8b54784ec419e048e03371f333300e7e1b78f1261cc093e556fdef5d257bce50=
32760585490f5a5841d98fadc0817c74e86b3ada213f55d3828433c13ecac1e335e399e78=
b2c8555ce1bc175c7d17652cb606f249036f79fd38a45b55015dcf85e55f412decd0b1c3b=
d5524506d97860fd58cd96ab468bbf28c2332810421a56b3356b1df87b4cd44686af33e40=
956c0fa45da43b078fff00f4b56efab940b057f43763cd6d876f55371e7b8514c47625bad=
b6451d72992f100e6708c210935bfae86e96035b1a3d32ecfc45dc4fff58b330a6e790ce8=
ea546e01112dcf9a7e3df6c351aee97b48fb821bbd39f8fc3e14e56f1e66478009b7b9466=
f5a538191399e44860d1a08231c9d30dc4ce2199903e3282b92938a252fd191efecd4eae6=
aaccb99e58aaed62f879ffa9aaefd6a1b5febe4ed67fe49cd940740c226356e0e20dabb8e=
5251ef186a63b7ff3427118ba081d74444aa1c17944ccf30df8224bf54e6d2c668944df91=
a7b1e2bc10223c7903befdd912c2d251e4bdcc69ca888a45b1039f57b4029c0c21bfd5ffd=
d7b5d8e9b9aeb38a6c20a415e9c3759bd4c226875c09e52e6b05b0b20da60c3a0648ca7ac=
4dad02935f69a0c8e4f74c92caa03599e8f20024953cc0908222a3fee8706d9b7251b778c=
40c820641e5c71c1b76110ed270d1841a93e7f6168f3e45fc9e718aaec99ccbe3e2dd501d=
0fa9bb727a039721648f00d1551c3f0fbac3ff6f5fd7c8ac77ea173dd4c436cf5a56e21f7=
0d8bd7ff4e7f7a7ba13049700ae7ef10278607ca01acceb4b35f03caab627f1732e49ec63=
f99047e171a40bf0a11344084a86462fbb9beae092b259e3194d3f19de019cf9b5d25f3fd=
4b05400361ee003f38450cef86fc79a3f609d944a78f52553d95c139edeb846fffaef89d4=
7181d700f95eb5a35d014ac44f5dd3b29bfbbebbc82a13ae00fc2efc0d65f8b4611268e86=
f781991c260ad83bf7c3f62216ffa71f6ed6b99e345131705fd4564e418da75b26343b678=
e087c8e3d30326d59443a3c44d51e96c461874fd0980366c882b1a7eb31d8851732b88ad5=
501488ef65482b8ee7c37142b3919fbcba2247e219834eefb734ba893c255f2af9bebcd35=
2efe6ea20cad9bcb00f393fb1d2f46e7aaa3d32be901c0d1fc181415c4c048fd3ef94bb21=
b898615e6cd41ad7693b25616589d5852ab79a9ffaac813564422a48d969f1c4349c3bef7=
7dd38ea6d522e6430d062d2f9d40077f1166a030e511059ac0ad12a969d5d2c0143f1a387=
4111abb2412282293737b918763f711fd3b6273d4acb243dac25e97f0ffbf411623b4a5c6=
c93c7e5e5fc26563b90073e0d6ad17a7459bde92e6a1f24545a2384f945de8fe30f4c68e5=
cc59707d4c2570fed7e6e9b8941bb07b904eca978b9c2e0a23312ef4eaf85f8bb76977711=
24533d729ee090eb0d160438bc8e4c631e28b1bd0badf0d065f8d79a846886d7462834ef1=
e57221dd0fba7d0e56462e815538ac44da2ba70c0698571a85d174589c2394accf8b98653=
fd6d1c54c9e23ea3440accd77eb9a8155ed76d68f336ea515722062c69ad79f1d7538ccec=
63eba72d755b3828c463306f66a7798832e4d3dd598f4a3bf007cfb151734fa1a73a8774e=
bfd6137e0b4d5d3d76552118b040d9c060758438f5108611c2db64fd35935498254133bcf=
a2adc6ddfb5b2f15a4ae2c89e554d82b753c2f250ad8f9725c7b93692d0eaa0ac0804844e=
5a70e162e2d9eca134b9b1c25a5483a54693b591f76ea6d891b47f57ea3ef51808f3d93bf=
74c6c6edc60eedb19524d86e4ea6294ed09d8c45feb874008f4aed864d6404dc892704a21=
a78da4ee3bffd444a9a4c1ef34580c5db99419856187648868ae4845fb4c391f17f16707d=
2b9c5cb8a1d4a10c5b03eb165e7676c93dc5ee047ed77474ffbc301115a27a8144c7302a6=
82eef28c75c5539e514898ed3d8ff75f24b8ee466ea49ad280eaf84fb49225888c17296a6=
d2c709f57822c660ce5f921123e897d4797ad151cb9bd58d6c38c3bfe6a5db76d72b68bec=
d64d63319b6cdb1fb548f9a8cad9ceca4c167e26219ebd20c4d8e1c7fb74984a98e483503=
2581ca10dc6089e57987bbb4dbeb17e6a211a85107d2b5dfdbbffedd3ea8ce80720e82b19=
89096bd23b05992c0a3e09b766a0e4c8fb486290238237b80787b09d495a5e1b9550fabf6=
17792ccdbe797857a572b85eff0d214a80aa5be99b4ca4ca9ebb189944644357abc451d5b=
407940797512270208dbfe6c320740168dcb654c53012e7e740322dd91f6c2647298050b7=
e8440857ff1a8deaf123a8da923d2f0cea871d21ab154e3aac07f1994851e755bc21cde31=
d132f23d9d01bb51d5364a72afd190eb93a7e96948ddd619d3294ac31340e1cd78046f1bd=
ec4cf1c30442c7f62d8bba4e973af102956c824b6be5a2309ca38205f5c5d66150d431cd8=
9dca51db7df2be7abcaf3398c78409aa852c7290497514b8746b1676f89afc27d38b39dad=
5ea4d8bc371f4e4fe59fc4fb37c1e2dce7e213ead05f80fb408780dcf6a57fb3fbbc3d6b7=
edb6398b7b09d85e2ce07015d4dbf3cbaa02139ad16025f1f65bba1e5fcc9216de59ccf01=
32d6a00e05f7da8e84b2ed5f9fa143f4c4068824442b119737e77b85f5b1d10926404b05f=
aef7ee385738531e54d20fc7134afcdb4bbc5ce305ba13506c4400668d8d787ca59097b63=
a270f1e77c455e0a1091d87139408082a7af05ae3a494d4652790c057ccc097512a450dc0=
d0b571b278c361283a6a90dd908925c94386d91b8f32eabf6e6555217a3d11f068c24405b=
4ae1d8eebe81096d4ea3eee410d5d07aefe26563904d86feaeb5bf6c5c53d90ef93b64eb1=
19c6bcac559987c0345171bfb40f7994289d57c0425f6ecb32519b97ac8e8bc366b816fc1=
87bd03416222ea9ac7c9b2cd41173cf4b50384f2e0ecb3c307acdee361e73238c37555fd2=
5c5fca471c8b7c2739bdba5e06bc3db77cfb348af90b6906b2542d69eb83162e6d5607cf2=
3391bac51d60e9b3a8703249853015e0aadca8d4f2306a9daa121bdf76e98c55406d19c5d=
b51a621df62aedc530da27643e2f34ddfa7f91bb53851f9659e17292994a9610e418d7225=
223bb229fda63e3c1863b349a73f7d70493452809b77431f578bfda82867f2837f3d1200c=
ee80019331408006765de7d27f8256d9242a09df9bca29e1c9c727cbe00c6f223df970d62=
7c9e06c07c454a4c4abef00ba2a66c99f92e73eb10b71684c9f4081b5dc3372524fdd76db=
6f6288b593571849e1df8855fb971773497e90ed8722facc63be58092f929c306e8ef8ffd=
327a95068a30b17535ac6f79ea2ae5dface84235580e7615674c5713c42fbaa87b3ccaeb0=
a916d9d737e1013351eb471e967b2562272e68c760288dec5174127e2e70a12e3e8ab3af6=
932fea0abee4bf32e2d609f210e153168ffdbe8bbeaf63e1b2f31ba76e1e717800cd0698b=
cf92d1600edc35c543a2be0498ac78223f62c61f27502a02dbafce827cfd924cb9146a587=
30692cfee526bc59495d6db7c485a5ebd756b25a22ae77aa70594c5ac3850235ff6ab4d9d=
d7a3e494d214bacc60b46186c2fe413d96cf1b1ab10595255a465e57c42b52a124206087c=
7e6c4c4ef25aadfb4a09ba1e7a77147a3ed6fcb4b09990bc65770cb7076927c01b227cfae=
4a8ed1f8e2b9f75ce18f7d878c5544be2d64074d06a75424de0ff72c812662e2af6c7e383=
2df151ffebe3507d09b1e2e0c134b693d3c7c8d81fe24097d138601693d4027920d43f28a=
4b2f73ee1490a221495aa12bfc2cc0d2129ccf36060bc09852e8747d1a9d354eef234dd29=
4f99263295fba3ac5eff8a96bad66bbfca1fdf02767ce0f6ee0eff4841323e70f25640b19=
10856ac7dd68eee19916c8336e670bd8e1385a99918aa010dff6b3cd065a0d8b38d4e9a94=
4e708e1fa38c0e85acbdeaa14d289348833f8980d7c0476ee7783544bfab6cfd778db599f=
02880a386a724005dbf620db610ea2e6f6e02eb8961f22995fc633cce267adf7a59bcfdf4=
da1d2cd35c0371c859a586c33297e17cc0d6ccccb79b8e1b14d5d8741dc2129e09d3e2e31=
b3d046f70c1cc0f2adf963022331225a7bb52164fd6589a46a5950a185246d3d48c592781=
4a9717d780df10d2463f9a3e5fa067385167b9df2d71463c9daa9b3443713701b990a2b61=
e453f68f1c864df5647be3aa14605f90ce4f81462fd80063419fc7209a6ce0b89733c0947=
b4cc9f52dc7b8502d120f855b11a3827bca4ec3e58b7cd211e049c2b67f61852939705968=
bed2e39fecb8b2aeb334753cccf35bcb806c6705b263c4907b3c2bdd864aa7dce74648813=
4759e43d9a496bab4660d826f95fb4857215f312ea2b2e556a89be47337269348cdd25c67=
12f4cca7f485686ea46d0eb38c7b37f82f7101d968736e0ec06a3f3a80edf5eedc3d942fb=
b1cb75fa0dc580e9cd6f17b603ef4f2498454f4676793d4b7c762e898bcf2f5c2e61d9cc8=
d64519770435a46a4a90eac4ae0436090a80bb23a537bc4b9c066cec6ddd46f7f3029e07e=
3479541d7d127b05aa85be18002c59b41d4c6f3630d54c91d1a747aa1ef1c30faaeec4b94=
9199154cdfcf21b55493e9f43e98ad0dd492eed7491041f38f910024160d32fcdd1cf63ae=
0a65d9f6ee1164fce7717c47d9da69ae69dfdb206edcf5dac41266dc4e6f7b94bb429c814=
6c6e50668e7b53839b85b998ccdbda5bb51b74c3a7e4cda7301f3ddafb4e87945f1f64bda=
82a7ba42db1323d7f1357f68a0c8ad8b664ae2da1919dca4f679657477464c5f3d6d995e4=
52ad0b92075867ab3ef7cc7d6230798ed67af4202afa7b6a96a71f6bfdb044c0f86a6fb60=
31a5e8ac4d67ff8f7cb4652bc06b30ff476cdeaa536d383463d07c6bafbca89d06166c3d4=
a1bcf3b9a858d1d6a54f8e84458a446a291d28327ff612db80a19f680e50f57384b4d6ea3=
48557d07e4e7f71d02b83869a5b50716001cee1dadf47e3db26c20bf7e54bcd00f77878d8=
ddbca5687f1d93d73889d70da690613d4e60b1f6a99a430a93c4f6344acb830b16da48122=
2667e8d9d2d875635d55a495902e4b434f52505943712f6a05d90a371411d08fc5b3a7686=
772a6097e603f4c947dd6067de11c5e42f3d43a5148719e10062b334bf4cab4e1d3ba17b1=
0fd5d2e26b67d58bb1c04eff22fa45fe09c2f8441ea889ced3972d171041ce4ef8c68ea8a=
1b73419cb9d7c5b21ee316ed6cecdd96dc96631c6d213d92edb4734ad81465576d032a4a5=
5ed3f03045816703a290a8af40f9bf7b1da8089215dd813fe8e04e06aec54272b6ba48d67=
27723fa7208508f6fbe318ccd66d4d93ed2a584dee0b1745b6e99287cc4eb5ab025ad66ce=
610e85274865a7733a420d7d36de3e6462fd5bfa7f67700db7c8a51a82556fb09993ff0b4=
cc34ec17c19727f38903e8ad8f817c272e53612d79e8c218ff4b122a087ac839581ee953a=
e3134e7899f24d9c3c3349c99fc7f4083c974078d8e20f4ab16e74c418e1de03cfbe3bae1=
5bbf7da7eec27990f41ce8ec747b008872da491157fecae9c71b82836b55a34fd59a24ec5=
01c363db8520d2ab64ebb5cf42d67643911bfd26101777fe02db300c82f9a5bf0eed3206f=
a745e7a2311b6604e8a263dcfdc45aaebf2be105dc9a3c691d45bb01e36baadaef8e47e2c=
9aadcbe9ee2ae2fead646eace3ac7924dabe86aaa06e688234586a7ef3cdf6508ea3fd65e=
f0ee0f8e13919ed96b4f94f2a2c915c2377ff159c9386afc24276dd920b5449925d4b41b3=
9fc60902e03aefa57cb00d79ca8f14e51ba3fc9a0febbcbad5b5982271cf161a7bab4fdcc=
7deb48d3e7d125f171ec55ff0b5416de9f7b323c6002780286792ba3ba3dd3b7da5ad71aa=
7eecb7f555d1d80d69488b1a533203e767456c647fff0e4d01f81aa1673cab0d5e2bc234b=
f61c23b00eccafb9a6520600d0891b6609690891683ee8745516d69150f8e6bf4199798df=
436e5a6bd33d2d787d210aabeb423826d1ae5531343ac2c636216d91a4a467f66a3af2e00=
ba3c8ac8989187a59a8048e45db0ff4bffae9a6927796cc9a33c7300b293fce6755499554=
787adb31e8651f3d91ccfcd297c3517fac4585b12b85df78c186e43ed0923033edcb273f0=
f5b0fa357cbd58bbb134a3c29e063f907f6117cc34ab6ad66c8762215ca59ffd216a77063=
6ee82a8e605a9478d3e62a84b4a42713c7218eda3aa54c736e9c450dc497287baff675ea0=
10465897d83621121abb1940323bf30c6192f854af5611d9b5c2ac5a58cd36b9325f11e65=
7c4272f48414d0b82d89cca0be80cb4ae142f6442a9527ad0ee8deba525aa5cdeaaa60305=
10b8b2a1e85c9464c255940d968deb07abd463e18a68252e86f58a0f7d284527af45f769d=
e13dc1f06ac736ec7e5340d9ae9370a83a3fa1214fd84f1a3dbc848aaf178774df75ca2b7=
c09ba28e79759d747832841aa9861cb8efa3788c863ef5f949b0bf00d88f811dba5e91461=
f7d571d236d2e4aee29723048f9ee95dfabc090788d5f7703887fc38670cde115e75a3f42=
93d6e916ced7316917e4c8d583d949b3e59bf77ce8cc549a359ccc7649ea23adb0c164cbb=
6b97c8c4728338d993735a6bf18d89803e4b97c3d4bf3701d72bad91cff3c83ce0d493f91=
45fdb7cc098f63ab06247a8212b4862ee7b97bd1e4460dbaf6dbac749b21e97ea0f4033ab=
85977f1f6131afdfe1d3830c5fa4e5030d8d8930d890304832031baf11b17647f906d79a7=
11c8ee99855d4d7a00620864b9495c7b248ef9bedb29e8797afb9532da3a92dd6c99b4ca9=
b20539e5abc7d30778365cd8e1498bd9b9e7fed4c080769c45a2effc7ed811deed99a522c=
a018ac00eeacc402ad04e2e3348378eb9c9ed40abc416dd88768f21ad1d09f792628902e5=
177c95f259de1a73cf34a612d88f81cc33f8a5c3da0142eb906caf35f3787a26683a2b573=
a1f0b728f290bf74d441663c1c04be7deeb9e8493ebb29294e836cb25417d499cca7b7478=
26cec62d1254eff8487c5a91b203e95d531431f12431fb6522dbf0a702b5a41b4919004b6=
1455728fd3e47f56c96268c34301d05cad4014776944b33b4446b51076e71c691b4a190ac=
f008574977b74e10102f4dd272beab646ddcb0b4dab6bb511a12faa59a1b4dc3507fe8ad1=
bb8fd80c98df3e3e95551b816b583eda74f80efe345db19df93a355e2a22896b033fac066=
b370fa34e383ba957ed1c181378d9178a71d7b7e208487ae7decc0b9f56935b5e1faa29cd=
31c6d511c2997def9fd3747b416ec38196c8b5c0bbc845b242ef71c3e6bb0d704f475a33d=
25a6903c2319351324530c15325848b44f4cfbb05ca48a02cdbe164d35a66e2d7e02ef2d2=
37d49ad4f9defbea01db1b5d19802e28056382d3cd0077e2c67dae84704c99468a9e06c6f=
86c06f55249aa97c6d4c59fee7117e9fee9c21643e4af9b38c345a990f6c09b079243ff3d=
5ff14897e4b0740103e7049f13f467184742de82bdd71ccadeb8defe5c8ac6f0dac16fedc=
fc3da536e8d7313f0576cbbb7e18c89bccb3a30cc1fd39797b6874b2e9c69465c12a5be09=
4c949e8a668c47be512ea5a99cbe20c71dcfb6a000c7ef5d72467",
0x2000, &(0x7f0000000f40)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, &(0x7f0000000c80)=3D{0xa0, 0x0, 0x5, {{0x3, 0x2=
, 0xffffffff, 0xfff, 0x10, 0xffff, {0x1, 0x4, 0x8, 0x1, 0x7, 0x4, 0xb, 0x=
101, 0x2, 0x8000, 0x7, r3, 0x0, 0x7, 0x1}}, {0x0, 0x2}}}, 0x0, 0x0})
r7 =3D syz_create_resource$binfmt(&(0x7f0000000080)=3D'./file0/file0\x00'=
)
ioctl$BSG_GET_RESERVED_SIZE(r0, 0x2272, &(0x7f0000000c40))
r8 =3D openat$binfmt(0xffffffffffffff9c, r7, 0x42, 0x1ff)
fallocate(r8, 0x10, 0x3, 0x1ff)
syz_create_resource$binfmt(&(0x7f0000000d80)=3D'./file0\x00')
read$FUSE(r1, &(0x7f0000002140)=3D{0x2020, 0x0, <r9=3D>0x0}, 0x2020)
write$FUSE_GETXATTR(r1, &(0x7f00000001c0)=3D{0x18, 0xfffffffffffffff5, r9=
, {0x8}}, 0x18)
setsockopt$inet_sctp_SCTP_PARTIAL_DELIVERY_POINT(0xffffffffffffffff, 0x84=
, 0x13, &(0x7f0000000d40), 0x4)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
mount$bpf(0x0, &(0x7f00000002c0)=3D'./file0\x00', &(0x7f0000000140), 0x14=
401, 0x0)
mmap(&(0x7f0000000000/0xa000)=3Dnil, 0xa000, 0x5, 0x32, 0xfffffffffffffff=
f, 0xc19ad000)
r10 =3D open_tree(0xffffffffffffff9c, &(0x7f0000000000)=3D'./file0\x00', =
0x89001)
move_mount(r10, &(0x7f0000000080)=3D'./file0\x00', 0xffffffffffffff9c, &(=
0x7f0000000100)=3D'./file0/file0\x00', 0x55)
r11 =3D open_tree(0xffffffffffffff9c, &(0x7f0000000000)=3D'./file0\x00', =
0x89001)
r12 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r12, &(0x7f0000000040)=3D{0x0, 0x0, &(0x7f0000001580)=3D=
{&(0x7f0000000080)=3DANY=3D[@ANYBLOB=3D"400000001000110729bf7000fcdbdf250=
0000000", @ANYRES32=3D0x0, @ANYBLOB=3D"e530040020000200200012800900010062=
6f6e6400000000100002800c00088008"], 0x40}, 0x1, 0x0, 0x0, 0x400d0}, 0x200=
4e840)
move_mount(r11, &(0x7f0000000080)=3D'./file0\x00', 0xffffffffffffff9c, &(=
0x7f0000000100)=3D'./file0/file0\x00', 0x55)
r13 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r13, &(0x7f00000015c0)=3D{0x0, 0x0, &(0x7f0000001580)=3D=
{&(0x7f0000001500)=3DANY=3D[@ANYBLOB=3D"1c000000200001"], 0x1c}, 0x1, 0x0=
, 0x0, 0x400d1}, 0x240000c4)
syz_fuse_handle_req(r1,
&(0x7f000000a440)=3D"0816d27427a1d7e1103e87a6e26e92ae3a487de6ec55d3c59411=
37869d93bc0ce0c9b21ca35a20e68e7b4687dc2615ca9b9dd592545fbaeb8429ebc0789f8=
d9b12ec6c3bc197a3f5dc1ad0c91848bc7226478194561a04bcc9babdfa0bea054b339321=
9c2a36e3c04377b47882d84d4ccc893a085ab3889a636c6771fcc7efcc2e5ca89c5997d7f=
495550d6719d77aabcd500f06a7be42079e56bf4099228cc1819b6724fef08d7f270e613d=
869a256bec17dfd0fda667ba8ca0443ca3f9f5da6a96903464cb51f7f6976bb9df4105fa8=
045b66c1cca4442e06a26b3b0aa8acefb9cf61ae276f3d7f43ac42d350ee3221cdb987b22=
82d8c9f663e06cc47a90c4229c30a5d8067e3d1ab90b597d91bae6b73204f7b0dc25086e1=
9de3c3c59dc5e473afcb52e39bd148fdf8e6061e8a8bc7d7814b7249f93c45cfdb636e671=
646d6ea2fbc8f1ef984bb8d01ee5f893bdf2c2c27bab41c156e63268a29ab7d4cd376aeac=
f6d022b05d0c1da73d1cd02fdac4bf7f300e1717eec3b028f5de93b8338591b2e4df80954=
d215902d3c84534eb9032af2f60291a62df427c0e6b355af092f6fc4460d5f66b99f73581=
1da13ee8ece4616f3cdbe982d3f3b9475fa6b58583f39bf19762068efecde8ce98eda48ac=
c64f6673158a440c0db88d1fe895491d48ffbb971e8065c78e1a1c5906cb9cc0fbd1248b3=
58e0e5854c6105f0f6970e354da9a7eb49ecb4f93632edb432605fcffd436d92cbf32c12a=
bf1c75340de3358878acf01660ddc5e28fccc82cd1c020956c26164607ee96e455322d353=
12290a1fc6f0fe4749fead1cd405e63c13a34e9b2da3c90a973924c247089aff45fc60894=
37a34c19a36624ba0f84094a83087fe7d1bcc2d5f19ae1f96111648a0ede76fd13975b015=
80d6881896c83ff051fd52eae82acb3f5d8fc0050a6dc12ee60a67065b48ea6868247c4f1=
d82e6fc7d550b0031b60111c2f735d6d63fbe05f2222efe3412ab07fdba4f4b4174d47b72=
5e1794219ccfebacb5c545088b07da776096eebbf0bec7fda621b20a6f76240166d570662=
566187031e4e5bb67b928d1e5c63f5237bc30e3667b50496fa35d45cfa33ab98251b5958e=
fd89fd2d539016f9390089ba57db729589678fbb63907637a3fe4c9ba5ba3bd2f09437c72=
b7a0bcbc8b87098d39dfe2d1a982683c18533f6b3a789291bc3d964eb23a04d9f4865cd11=
957b3420fe68d4c587eed1b6adb16f80d8be77f7222118003f64bdee6a9ca427c9dfff580=
ea81796f5ac2fa0d468c568ab53836eec5b50a1fb870dde76c73c1d0f7a07145ffaea91be=
5493a9a05b023211ba776e48db9ebe95fa9adfca732bf201e054765e1de0ae72e3b65f98d=
aa1915efc4b3a89dbade33519e52d17f114110c73a2221d1cf5c8a91d5dbff37aaa0fc65e=
e50b21973022301d4fca66c7085329d13c2bc1a2777766035c96a215b647257c2e114f04e=
72fc2bfe02538d1496b94d21b88d0b45377bc12dac1de6c7bffa031d25ea8ac4e2e6b6609=
1ff564f6336d70349202332d84b624a480f779b8de116bc989b9234a9e20892d1acfba819=
06b92c305d0bd0f97c8e7d2bdff1863108f3837275d0114c68cdb2fafe9f638fa5fda1475=
c3704a04ccc221d9e063e376993e307e417ced7ac9d8ff41d9de889c6999aacd5d997824b=
7d1c31171c55269b0c8849e4d84bd21aa4953d99610d455bc568c11a4bb273fa6e68f4310=
4271990dce0db39ffc3d86bf993c574d803a82dac4bc50bb5053b68a0d59e57f0553ff093=
74ed18f9cdd0ac306de7ca60dd1a06b1f395d7346138f4fb2f44c47cbd21894efe25dfec8=
e84e4da5c16288c444b47b3817360f0954227137946ba786f8ed8d31a2073596799870472=
ab5394ef35aab90f0aa4c4ecdf028cadc2d216c4a669992d64d02441803301ddddd52dd3f=
f8205927fa6d2fae9ad7903c7a609f6dbc49fde488ab6fba9984f63b72c4e841639a39801=
299e29a7c46484eb01611aa2736eb8fdeb1a660ee4c93edabd5ac3c9be73201de7c7e9785=
a14d9a7485c092202582b57e96c274abd4f5710b874ed6f7e4f4f97307224a45008bf0018=
b05a1bd14244dae32ccbb66a464c4e9dfc47a4b790d261c5ba7932322ef3a00c012e8d5e6=
5e33a8bc0c024f4d87dbc0acbb125379004b9ecc6a3e8b6f66b08ec7b84ff36ae27d82290=
204a989da92cebf63bdd3f8f956407bdf676b21f4056a3d3a65a3b0b662a101bcec993c66=
64ac5cbba805512f63bf143b5f12a5cdf71e2fe34ec9a980ac12418c70fe0d689542f429c=
f7447d5bea7ff79bb8e069cb47fe3192465644e7a770f545f614ab7c5655ba9fb028e6586=
c54d0ed776ac6fb819df40e7e1a57c8828bee810f5d25f6834151c4507a76b8d8201df2b2=
702e114e5159e7a4e07b0bbcb01b70cb81ece686a3f07610db2f898962ba65a4d93b7b360=
13ea5f66302c1c46742be8d710202bd9f7b3f0018728aa112e8cd18828d63eb55db33b038=
9a98b778949125cfc122103ef48bf427f911b91323430ba2100a94d960f24d32bfdae9913=
898bd8c4b33046afac0dfc49f6f4223d5041ab90091db301310ccba206ace64ca95616f46=
e4b52ea67cd30786d172e0165736696864be3a1b0baa13c9000e34be1362229844aad1c01=
93b9d8e2ee1f68550bb0b101b4dd0ec63264542a23ad60d7c7f933c7ff3d4437cd9f9d8b8=
479705376d0a8df136cec54877834306cbc5bb69747bdc724f158d29b83829626d4777ce8=
39c0be8c89a06f72eeaa7db88fc629d26b34e0be77c25586aa973fbb28faa041d4584b48c=
8f9acc3bafba77133f5d63fef33df2a8858655df99fb03eb6390ea83f2f6ed041fba1eb26=
fd07075bc78f7b1e2c167204618a5f22358b87f7e620ceb3aa9696a6d47178d4c5250fb25=
3b6d005bfa20c208c7d0709c82560a5cb5dce8c54c4c4bb4c41591210879536eef8b6f600=
64f2fd877b7c75d8d812f89ddfcc79062e7f1b65c34da39eac05d32a13b4b0fe6256f8aeb=
41423b1883ecd4d8a6c9588da1302555bf4fe9c567517216d0e959b53c06440cc9a3b5dba=
6a9f8cd832e9fd39323c77a9eb7e56003c96365cecb3370d7b70289469e8a7a7ef70e7bad=
94d15a4e554d4a79c45142eb86860e87af5a255f170b37fd3cab45915a80971b7e907e960=
9180e6baeaf901a6ba7d4a019c8c1da0a472e4af5210726cbe32cd5cec5efbe8f9d93046f=
36627d8ed9e49f48a9e8792f56e30b982927a99092af2a67dff30fb8792ebc866d2f15689=
aee2e8dd8202f0d5ae357f2bcd6dcb2b68bdf473bd7302201aebd33725d47bd4c1b434eea=
c809ebc7f4c42e04acaa8b3c3b080efcc4f2a40a0b28ef62f544fac41b03cc89b27325e54=
1515cd34aa3d38076acde5b197bfed07c387301150214256d9533158c920b2be63483ee59=
078a26773189e9eb916d1954d884c320aa0a738d2ff3758488c1c9434ea53db7d2e3e0ba9=
c3734982f11d20d3359678a88b3b622decf2d15052015668616537f24e20cd7ca93bf7572=
2f036f5d427f4d806867fc17aebb10726a4d94e8658767d8b171de41aba7baf7a9cf90a5c=
e3828d3ec874da150ab373ed41cc64b3c9999cfc406a7683b5391b014354e11f54005afa6=
f230d5deb6eadb8bded19866f968e1a4129e0b73128cadbea7271e07ac34e91b101a8ad38=
42e80b5a8568d562e7649aa4e379f3544d8cd28a6e6a733fe7421660433eceacf64e538bc=
b0fe4c481a74c35cd0063e75f21de06cfccf9eaf2346c90eee7608d87cdc83c5a0edd4f65=
71f5eca02565b7f61d746d04178568c68ad757ab2e69290391a69e5d11c3512454f33e870=
55bf555c753f1dfe1d8790fd1505851b05ac1e5907b9fd134f6e72ea765d8b5deb375dcf4=
62a76d4b670dbbad096f9dcc02448fc7cb73bcd12121e26f77935eb2bb7814e3339e5eb4b=
cec68a303c173fa9751c7e71fa32152e2f48b620e26734e272abf98d8c1e958b9d7f851f5=
6d38e56c361b3a8bc4b338abd3ad25f303d0dae665d4cf4f399498047f714d48879b3b8d4=
34ec96f5ecf21c400ed300cd47e5e84fc242bd1d49acc6c4b8ac04228fee7f481dbe07230=
cb17fd05aa805b4152f9acbdede1d5e6679366b7c5d820eb18b5ede5ea5ff78c3c4ef8c74=
8bd6fd54ee36b2df099ede3283d45f323d156c7a0d504123894d9f3a956f7c0236f4e9b08=
2c0e25682dd25750ec17f2a5640134eec3cde72c9825a816f5af1d234d1967c31fa61c599=
58d7353587518474ff9ccb219000c3efda7210aa57a5c9e245f70d2a66a910da6a960b145=
1d632c8316b0765dea13b0a0ffd7c34918985996e10f6b477dd0d4b904407666f96bad16a=
d60446041088b019a2f3a4acdf1ca3672c2d9e211639d4e2ab2ba876090bbb3ac72c55bc6=
976cfb7418882ae07afd0c54567bb5e5f8e2c96668592c05469e2bf871be83694870116da=
e494e9605d88710bcaf82ad2d9ced33d711ea6bfd60a4ef8e4eb0d51b6b96afb30ffe030d=
45d0295adbcfe706b0c63a79fe2cb9bc15ea6e717dec1bae060be4735c0d903d57be863a3=
19439519f1b2f386e1c96ef1249df91c9d6c90463bba9ad6735b09999f1a9de4552ab2d18=
fa9ee57510d091519fde085f23ad3dda21d1e78220a7da9a3d3ca9e217c10629b36aab389=
01e30e7658bfaaf4bdf6e22b434f67284a641c82fb19db5c2434feb04a2dfb9abb21879a9=
ef32cfc60953715048d5757d5e181312ef533ef7d61dfcfda8f76aa14889aed396108edc3=
6a13b58b1e793ebb9430023470b3580c3eb7aa099d2dd4507491df0ddd8510307bde0026c=
97cb4c2090b89c427bcfe5be18d148d35706f3268e67dde449921bb8b85818a1e71fcdbe0=
91353b8c0693526a9daaad0444b146d844a8e67b486591325d02015099bb23da6ec12cedc=
d002e83fd9e7d08f4fc8492afda9e7852236161542114bea405b22416f7d9b328b7684b6e=
639a21140ddfd7671cadcb2843348958d1076db346dd8195ec1652cebba51adc7c814fa14=
c823cbbbe104ed7ef62a099af3a713f2305041a026008426ad61379c050b85e28a775bb5d=
964a06183b96fd800bcb9c558c8d5658311a25275d262f90ec3ac3dfa8595680cdf916c4f=
04050b942eb3ace4fde6bdfe4478c6f97d3447d4b9733cb15ee5c616d3bd592f94748c7a7=
86d1be5dd50efff00391fdee3ec66e442e2feb4b7cda7560c86dc00ee391a6b680da1c4f4=
f0c4da90be3ba38f55f682db6c7e706e69cccfd68e1c2fdc93a55ec3586f3b9f5a90aee4d=
36a7c51f5ff46887e3590f8cbc2e4947d60394b5851379619ddd5ce21b20e568707cf53a2=
f275f86dd4ac4892e64efbe9e35081e04d95fcb20f43db43469b15b8826b4a095bc78a74f=
7ee29edf3bd42d309075867a9bc3b60f7b4f58b8a322b4671b857b914ba3c1530991f729b=
7fb7da6affb1d4f345a272cb9324114d5fa7ba030cb0d25a76f621ca95fa2a75339b60d5f=
fb3ac84cae645dce5d52fd2a4b6b1a93d453db8664f6743cb15d55c39f8e3b49667afe87c=
db3bf7d2f3171587b4898fac6f7f892f4a2218de0e570adf21dfff1932653cafc9c8505cd=
ccad096a93b7eb22edb36c362d2befa5e93c45afb2f9a6254baaea87a7f4837b36e9d13db=
0c0ee00b47344f31909d6684ad5b6e7735e6722a31f86bde43ba5621a158055064531e422=
ca1249e9d1cf46425ff9657f8a2c077bbcba46d082b92b56be69f1f551f0a0a6c9b1dda37=
c67cc825c1be4fac0195912a2970c1162725951600c29a12e5e147225f8a3b7b2940eff33=
561b74d7c87cd99da60a47c6062da8ef026b23340ffa6981ea556e340b90995ec2a023bed=
5b923de2d1422a9fa2bf48ebda50871b379d8b64a9b50b1e00a18100e78235b7d336e0316=
f7a4197a40cc60b5cce2f9125ddf3a4f402bdc67f3ea8e07a38161d490c478045e90f8ad1=
b363da1c717455c17c2b64005c07c2e5e244d7a028158a82b72a7f55870fb7acd10c8218d=
3b2290796ac9f682bb720971d797560c1342ba35497c1acac4d867ac764ac6b979704ca5e=
81164b4edd086223d907548c3c7531576c881932306201e52900905483ac22167e4ea710d=
b788a0c723bcd2d2b74ebadbfcb5e76397365d768c4b681aa18538b9060a1ef06b72ff157=
faa53ffa4c31499869e5940940f76292019be8cf0cd03ac01fc2ce8928b8f5b0ddec00959=
3d2dff43e0b5756372bfc5020f1d284a73754fdf57d564a18b980b3062ebd698e73af4737=
900abcc0138c3bc33c2e03ee0f9c5baa6d74aadab7269845b327291f430ac1395766ce50f=
a907bf898343b22ce1b66be7667a3a584fc2897758d5774097e00e65a5628ed9815b4f98e=
61d142cfb07f90cebccacadd823d368afc984880a78f296aa4239a13be230139fa50e09b2=
2edb70bdeb51b84c1c233de4b96a0473f9b30e003af29e53d046fa0900aee941c9e2ffaeb=
e12ab095b983fbcfeef5f0dcc526c91659133bf8999616d92c0b8032d1fefcef139ff8032=
2c74bec681c328583fc3ef5a95ce8d1495d5b0993189e5dfabd0872b10db52d623869849b=
8f849c06647cdafa1bde24ec5fed412faf9e4f7b0208432dd30f51ce0e609de42a38517e7=
ec6838d7fadcf9175a041935ac595fec1730b33fda016c19d7a79aa8bab9966bc4ee9e50d=
a53616cef7f67818b5eb1966904ab7876a807ca60ac41186c4fc0e480090f74654dde7f2f=
7fc989f1184d2aaab6564299f29169c8bb419a489bfe1ef1b00547ed7a38d8a04aa9dce16=
844c732c287aa2c8cc9ead39401799ece2a323a01b6986cee8abeeb55291682c62939b8ce=
7c6950c3a04a497b61a9da5ce9be3a70aa39e0bcd27c267bde8e69c9d6c3d427046f020b5=
6e0a574b04df6017f48e9b4a659e575cbf9e6ed2f1327ac3abcf3b0c0e1b80b1d8ade9877=
ed47ffae603ff38e4b2e2ee2e028cfd20bda5f2eaad75585384285050a98d08b60b4d5e1a=
c98831b683aa682674901ab647a5c8b2206dcd3abd6105ca36a5aa9dd4a45e0fe4558c5c3=
b5032185d8639867ac66bb9298ad8029e03660402cf9d9a5af8aa1924cdf671e373cab17e=
788f7b58dbb2f17b9e4ab9b0d707e416a0517b0c3e58cc72b5582577b5caec42ca8f92193=
0d55a4f63c5eb0ba57fe940b12dc9e0c8e7cda3e9fa89653344b536d16462d5b55391199b=
43b0fe82f780117c1cc69ad63d58fde1b5c56eaac12393166908ea4e255f5aa071d581103=
8f3b2cefff6799e1bb6d6d1661a5aae53b69804b82b9ff24ddf006d5065fa5029908dd9f5=
83407000000000000003488511893df47612e10e2ad0ffd06395589c6229c27be3119a6b2=
9a3c3de6b8f7cb1e67772a914364e2f4d17b89bd1ae96dd2f62610836f8dd39c4f126072a=
238eba63154048b32c229f1b0857168a1158c26a81d211c90b16ccd025f474f3e0c2efc5e=
143ef3d38aa63bc2167fbc9813541d9121c6ca9a3aa5a31b80f2bca5780788d845843ac40=
a23d1a3f8df955c59e875856cc651b4db2a781993948d39031cc3ed13729468fdbe24e5de=
ea171e3e5bfeab00af2fb27d1b3aba1ba929a15cc7aea881e04abd82fb8e7f45355ef5487=
c16daf57301d829a30046a5af4f0ad249dc3085d5cbe1d0dda9ee2ff4c08d3274cf0ffe81=
c521872a5717f1bc6e734d30c1855e07b5dbfab05919173997f322d5d39a94f58821bd17c=
f1c1dba36e7f52805ec9d7bb627fbf06986c240ade9c44eacc4dc27788844e32ade8521e2=
a290b466b8e45623aa1bc78f8f00d2422aad567584caccf1d332708a30a414bd97cff76c4=
f77f02cf6f0df16a558e58091c31238942fa09fa8a86b53d44532e7f63e95bc6693cc2a45=
f7c6c7a9f7549d92b6d4abf232ee62840aeb2117fcbea24b5f7a6d4de9042efd1b96bd11c=
713be6d6f645cefe7ec1844f39f5071c546094e5ae972e634f764bd6eac32f49ec7443712=
da0819ad99910ea30ec3bad5c88cd952f6414382ef9595e67e48f783045f0961d0dde7436=
274d86f4cb8e88dd78b14c17dc83c2645ae2077c13bf0cb2dcb56a2c632d8462a70633fcf=
3f3834738f819f340f050125832c03130d79243a1248eb856332dc9de24f09b75dd79d23e=
658ceffb82c105ee177ad22d431b38c8088a52abd44583d8aaacb7c104dbda23177b3ff6f=
0863112d20e3141e9a2eab4d1221961a08763521459da27a53e33f9d775de279b0bfc1e30=
38b9c3cce5e024dd163118ce276163bb7199316d90a69f6d67d5c05fff7be2124aefb9ba7=
886560b7d786228b6e0694df69e9991c581651ca9b6cc2712edbc0a2ea2f6167f081de1ca=
3777b93acff929f6211c7b3e65a6dbc3e9ab34e9ee85d9c3274b2bc9a6a24e6c1c77cad0a=
d3a370c05f98db8c103d632624bef15ad7ca7296943297d2a4f6c96fc029c8ec55f82b3bb=
27b5799f5cf281e506eb3b991e8f35ecd4f856d9269d7feb60e047803fdacd0045ab32973=
45e491c7b5e908a87eb22db2a68dcb5eb118cd9e0eb7add58068a20439c5ed21ffceb966a=
f1b4b0d18855a249527865596534d869903feec32eb38b2313c546592433a2782b7842d5d=
1d3606293c93912861c609a755d7374928e7b67ac2f041a5dd86cac970399ac1577fa9231=
6ac4c94a32cf2e0cfcce8915395392c40bb45fc2faf43d59a7b9bfc85bf808ef102d9a715=
ddd301f211cd83680d3d03a79ad8771db35fde0f60d7458a652abbbf0783ed2390e98de63=
d006d6787538cae7a3cb584602f1565b138d1bf077d705fee4a7dadc78214a5de721bbd11=
e705f7dddbf351b3e1a75ebf501367d86ea61a1ede2ce103276a1c4d4ba08b012188254df=
a6cbcce3ff991f30d99e42b18fbddb7897da7b56faff94b7c80edffe59a33655672729695=
db34fc5cf5f82adef405f3b978a194eb3ff546bc7058559a5dca9b16d636885c8b9b28811=
936fe452c567767ad7ec99d595f55667c67d593ddc6607ae9f7617e36b7b4b8aff64abbe7=
2d4e70c94a08430e22aec3448cd490f6e1b9ddc347a29cfb44e1fa087568b4d35aeb09581=
ec5ca4c4ccf9de1992739d372319f5105f75683c0b4f5d00f044a0c61aae7a9db2e3f4255=
269c8f5e1e7b03c529fd596b7f96e984a45e251c6323fb1514daf48d0a83ba846b46183aa=
8a09ac9754015181a8af342809e1506ec734ff679bcf896c82f75535e51ef75789f218d75=
8b9b6b7cb6750804abe7d200b3dd229072e02e834aec0365977e5943c3f387edf5eca3cc7=
46009d015ee1682317c6dd85b20e233bf5ec78af48830aaa6358efac2e296f2039ff8872e=
afcf25a420ca5d05eed4ec9661039e262ee93a59f855cabc4c3f457f866107d319a9197b2=
0a9251192b6957036e48c352151fb8481d54e4e3f83b1b75f592fc7499eb169b87c364f31=
10ce3ca0f93114e640279af028c07e4c93454882d1792dbb17a0507667035901170f9eab5=
bf8fe1db8c57e0cfca24fc430a5f8b07befe7f40f074192af11bda1865e6066b66d36b2ba=
558f63b75b100aa4d1e01d362068cbd7bb37929ca21d55f3ec1b7d040f04062244ef1ae9c=
ff0d9abf6a73fd62ba3dc55a0345e291162af2c55099cb30972126f268d62585f45f6415d=
99b09d3c365685d6b322e2d26ba2b326e0193e7cecd300fe88295a49cbacd4c4da1e1e179=
d5b609f51c0546d27a4e5bd5c1fec4427bab0f1adca6ec4c9c1bc14e6285411370b590136=
36afde476301aef478d2de87c1188fb4ae86009884284c70a43240812d4c30f089748ec7e=
fd46ef0ada515a01f9e390e3454930d85b96d5ad8c87b4a4ae58554f1678f6dfc16309ea7=
d737f69490ab7e17d6e1ed50629645556014a8f46873acac5b6c6c9acd73b31a5e3f3374c=
89ffd234b8dd505442359a547b176ab1b6f28ea4ec0b32ed06e1e2cedd30202f2118ea9c3=
3bf3224d4970dc31f9e0130a6d5051c4d078cc08ea38fc6572ba02fad1a3f987276bcd2ec=
23f8e41112e8e769221a2763353d301c5181e1ce35471fe26707c9822e883bc3e19239adc=
92f3bf734d7ea216416275043a2e7c700713d4ffc1df35e00892209c336523972cf9bb64c=
fd05ae0a4f7450600e98eec8f914e1df5be24a4cbeb30750efe49e7cd9e444a0c2287e121=
7ab8e8aa372f27c9b2d8f2657e8337705de2d70ee934d4c570444259d8915a81e27250ce5=
e76efaa33853e7ea9bb24dcac4295b700afaa50a0ae0bcc273ce874a3e5d2cc2ae19535fa=
efecf482fba9acef4c84d20d4a2588d22532587a599abee5d481c353d65b97b7d3b65f51a=
acd0d467418f0efa61b8f19a24387f6ad1d3d0b31ebf5cbd52f1798d9897a4cf41495a871=
019bb3ec4d66ca0a3b63530b45c8f22c8e29f5fb77c4e9e305f5d8fd873ef8a4e2e34e3e8=
4af2c2d36b80c1eb578db70d8bb1e339fe3b537af8d374d93f0ed581d431059204c5db308=
5eeaf1988f34e82a39e66f96aa9b1f48c7272fa0d7e655dfb79e25c54214670140d8908f4=
77e11108f4c7b36bacd9ccc74666b538ef63f9207c84fcd8229512ab3baecabdb56972cf6=
fa2d5b8f7661f20dc79d5b1b3df65878236faefa0435bc742d880288dd5a360d8ade366c6=
92f63ba5228d56d9cf05677ff6a63c3822ae0766910c299805e3d317822eb44260b3466ac=
0d662077522e598ccf20a67c3c27a7c7e117c9237713c0c8269cb01fc5205a5ed89a6e9fa=
1774155df7e24800c8536d6b961ae621c241cf9f21fc12f6a075eaee0e04b0d15853370a6=
7123df580cef4499b1b60e67c20fd1224087a13dbce07c4812d8c524e0b4ec1813b3ee228=
8015207c65ff9d89119a9821423462f5702e6125c66bef727b97af89d24202e41eb3e5b83=
73d9ab6dfdd3827a37413bd77dd8fb791203bc2b342a290d297a41e94b177dadb604fb79c=
0843857e05729130ae89bf43efcf24fa41a9259544adb30c367a842526144f641070ffe40=
49212b7a98d253eeb85369355671acd4b0b43b854134495025859b8da72633159b74905ef=
aa081207b576c27664ce85c8969640df8068e4892c8218ccf7c79532cbabbd062ebbdc40b=
b82f146f72773c5e2b914897474c3e54726ea123eb1578146d010731806650fbe7ef32671=
f7bf1e761c282b8499fc61f8ed9d909cc3e28f696b85d9912a7f72b2758b1b5ecb15a29e5=
c5b28d9a851d0ab11aab8a1c30ac8c779cd5f5669d6fd0fa734405f6e9de2d8292ab0d2cd=
b4f924d201db4f2bd870826241ae8c6997b17bb8ebb3b5831a76477f4e49c8e735482dc78=
4a67ca0cc26129cf2098aa6d9a0e213f891aa585b4946087fdfb812b2926262b3614b03df=
57493a258f2077f28a840fb9467cc5213a74a61030a2719d2ffc9e3b6b08c2c79707c28a1=
f095c3408fb78c64dd74a95d67c6274b4ba57bd83bbb4e6654c1db5ebd7c762caa5322cc3=
feb4044fb7e767d89e82ee85965739b1f42c6b9f3a6dfe16cc2e5e3706cb4e92eaaea6d0c=
86ae97a3f4e36a18f419e6ae381867555264a1fc1bc86f8f1e6917184de765a82a72ba651=
d3d7f3fb1dbca6e3ee820d8529dd11f4a3f238a280825bf81f36f",
0x2000, &(0x7f0000000e80)=3D{&(0x7f0000000140)=3D{0x50, 0x0, 0x80, {0x7, =
0x2b, 0x7, 0x10110022, 0x9, 0x5, 0x3dd, 0x8, 0x0, 0x0, 0x40, 0x6}}, 0x0, =
0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0=
})

14.77826718s ago: executing program 2 (id=3D13339):
r0 =3D syz_create_resource$binfmt(&(0x7f0000000040)=3D'./file0\x00')
r1 =3D openat$binfmt(0xffffffffffffff9c, r0, 0x42, 0x1ff)
close(r1) (async)
lsetxattr$security_ima(&(0x7f00000000c0)=3D'./file0\x00', &(0x7f000000008=
0), &(0x7f0000000280)=3DANY=3D[@ANYBLOB=3D"0405"], 0x2, 0x0)
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
r2 =3D syz_create_resource$binfmt(&(0x7f0000000040)=3D'./file1\x00')
r3 =3D openat$binfmt(0xffffffffffffff9c, r2, 0x42, 0x1ff)
close(r3) (async)
r4 =3D openat$binfmt(0xffffffffffffff9c, r2, 0x2, 0x0)
write(r4, &(0x7f0000000000)=3D'h', 0x1)
lsetxattr$security_ima(&(0x7f00000001c0)=3D'./file1\x00', &(0x7f000000020=
0), &(0x7f0000000240)=3D@ng=3D{0x4, 0x1, 'X\vo7g'}, 0x7, 0x2) (async)
r5 =3D socket$inet6_tcp(0xa, 0x1, 0x0)
getsockopt$inet6_tcp_buf(r5, 0x6, 0x1c, &(0x7f0000000100)=3D""/28, &(0x7f=
0000000140)=3D0x1c)
close(r4)
r6 =3D userfaultfd(0x1)
ioctl$UFFDIO_WRITEPROTECT(r6, 0xc018aa06, &(0x7f0000000180)=3D{{&(0x7f000=
0000000/0x2000)=3Dnil, 0x2000}, 0x1}) (async, rerun: 64)
openat$sysfs(0xffffffffffffff9c, &(0x7f0000000040)=3D'/sys/firmware/fdt',=
 0x82080, 0x1e4) (rerun: 64)
finit_module(r3, 0x0, 0x0)

14.77150724s ago: executing program 2 (id=3D13340):
r0 =3D syz_open_dev$tty20(0xc, 0x4, 0x1)
bpf$PROG_LOAD(0x5, &(0x7f00000000c0)=3D{0x12, 0x3, &(0x7f0000000000)=3DAN=
Y=3D[@ANYBLOB=3D"18000000c5481f72ff2dfe0000080000000000000000009500000100=
000000"], &(0x7f0000000280)=3D'syzkaller\x00', 0x7, 0x0, 0x0, 0x40f00, 0x=
0, '\x00', 0x0, @cgroup_sock_addr=3D0x1f, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0=
x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
ioctl$GIO_UNIMAP(r0, 0x4b66, &(0x7f0000000340)=3D{0x12f, 0x0})
syz_init_net_socket$nl_generic(0x10, 0x3, 0x10) (async)
syz_init_net_socket$nl_generic(0x10, 0x3, 0x10)

14.752054s ago: executing program 60 (id=3D13340):
r0 =3D syz_open_dev$tty20(0xc, 0x4, 0x1)
bpf$PROG_LOAD(0x5, &(0x7f00000000c0)=3D{0x12, 0x3, &(0x7f0000000000)=3DAN=
Y=3D[@ANYBLOB=3D"18000000c5481f72ff2dfe0000080000000000000000009500000100=
000000"], &(0x7f0000000280)=3D'syzkaller\x00', 0x7, 0x0, 0x0, 0x40f00, 0x=
0, '\x00', 0x0, @cgroup_sock_addr=3D0x1f, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0=
x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
ioctl$GIO_UNIMAP(r0, 0x4b66, &(0x7f0000000340)=3D{0x12f, 0x0})
syz_init_net_socket$nl_generic(0x10, 0x3, 0x10) (async)
syz_init_net_socket$nl_generic(0x10, 0x3, 0x10)

5.73820842s ago: executing program 5 (id=3D13511):
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x3, 0xb, 0x0, 0x0, 0x0, =
0x7ff, 0x140c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0, 0x5}, 0x100001, 0x0, 0xc000000, 0x5, 0x3, 0x5, 0x80, 0=
x0, 0x0, 0x0, 0x60}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
r0 =3D socket$nl_route(0x10, 0x3, 0x0)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0) (as=
ync)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
r1 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0)
mount$fuse(0x0, &(0x7f00000020c0)=3D'./file0\x00', &(0x7f00000002c0), 0x0=
, &(0x7f0000000240)=3D{{'fd', 0x3d, r1}, 0x2c, {'rootmode', 0x3d, 0x4000}=
})
read$FUSE(r1, &(0x7f000000a400)=3D{0x2020}, 0x2020) (async)
read$FUSE(r1, &(0x7f000000a400)=3D{0x2020, 0x0, <r2=3D>0x0, <r3=3D>0x0, <=
r4=3D>0x0}, 0x2020)
write$FUSE_INIT(r1, &(0x7f0000004300)=3D{0x50, 0x0, r2, {0x7, 0x2b, 0x400=
, 0xe00b08, 0x0, 0x0, 0x0, 0x8, 0x0, 0x0, 0x8}}, 0x50) (async)
write$FUSE_INIT(r1, &(0x7f0000004300)=3D{0x50, 0x0, r2, {0x7, 0x2b, 0x400=
, 0xe00b08, 0x0, 0x0, 0x0, 0x8, 0x0, 0x0, 0x8}}, 0x50)
syz_fuse_handle_req(r1,
&(0x7f00000021c0)=3D"80cc949a20a10570b22f57c72b14b6d5b9656d619411d3e0feb9=
96f638296baec90caf0305c18523d32f8aaf50d3b62deaa3a75c2e016f25efcddb2e4e5cf=
e7a2e24d813ff5e08182e8fbc9353537f68ae28a6548a83e5662b382002990c8b32a687cf=
b9922aa8e8cef4d8f1c1e9ea22d432b3ccdc80e9b39e792b7545ae90a0880cb7f49edb763=
13335f65ed0888cdf8a79f3a22028f6035b8a77343e12b2b48d61cd8dadd99ffe4ccaf144=
36357b8f5c4633a94b27d21367946bea971d2f2cc9c588402be7d1f4cc9c78732b4650438=
da4a781b23ea5cc672d28ce0d78fb13a532779cfe3689e62f673ff4d4edd72d396bc29607=
5a710424cfe4fd1d38ce799c319e58f5b5d76c995ca60bb98f1a027c5122554fb397420fd=
5095c0326ccf221f017dbfdde47ba8180ebb28573193aa67076f503ce05d7950d220bc8dd=
ab527f0117a30a9c9fa977e6eb12024bf97ac55e5044b688f8ece30cfd06acf52743837cc=
9b1ae37af0113cda07abf471828dad657fd8a2cccf307f16e21f938b3c3c03a29bccb9f1f=
4854067c7eb7664f505a7fa433eac2c3e3ba6fc5393e376aa0662d502e91931c8363fa08b=
006e35feee61403c93a78cd0722bce85f680ee04efba31f47f92f1e391e3d63507aa49d8f=
063707900f63faeeba28c3d53cd4dc95af6e916bca9896926775f990b7e528b15014be706=
414ca96c59bea21a312484d3d6434c8150752bccee265c64742549b9bf94d64a100ea1f61=
2de41a7a4f34afc0f47a23a08630e3f90da155f6b5c90dd9a6496e23e80cbe5dfd3527288=
3076961caf332f97dc3871384379b2d6ecafa30ceea5fba0d68ba64fe7d235046347a4759=
f870e5bbf9ab1c3ad3281b63cbe1a9f0de5dc38118aebaaac3d8a42bf5e13489da5dbf0f5=
0a02291a1bff4af669d66679658bd3ac40f153034cadab5e07d743392a491f3daf2737703=
198cbd9f18c90d82dbb276f948bb84fca2bd92160675b5ce96f4e3609bfbfaadaa495231b=
581af70fbc8e2e2bcb249b3a8ff0b45269cbe2ba66b86942d24b086945dc9b4660ea211b1=
93c19bf11cdea937a3699ab6131ea26c4903121760b6df20561fa2a593700d7ff0e71aba5=
139ccfde4776e1e60233a784c72f4b7bcdaa00f60cb93c25367752c624652981121dbafce=
f1c96f3f514347a5adcf3c269df2091400b041d52460fa8c6b81e857f88154d4fce7662bc=
f27df14917a01170b0a36b36b49b0cb69af47247cfe08812597d74fe755ecd1c1ccdb3b0a=
3c9a2ea65c494bbd669b51ab7fdd2bc5e7e5ad459d6a9c9f02e59f7e0aa1f45de43cf5014=
23616d430a6dbc577492c8adfbdfe707daf0fb401239592bf301361770d155cfebbe9d5ba=
f0dccdb358c2c0d7678d6a1ba6e2fc16f1f0aa6b3b9be72b37c22fc76b0e4e5b9fa540f11=
6682f694e9ceaeac5cbc8691a935fd1a244b044ffeb258fb01a035880cb17e7dde5170a35=
d44816482f376d9d48b3b807af0f2138f8b48a47a18207745568b349db4661aee07fafdde=
33d604230e4d340c4f9d9ba0d0ab29294f7a31983fec1a75c6f4394d710bf961b5d4deda5=
09ed7602df284fcabcbfc996299783607934c8e0feb1dc2efb258586e71a0aa5458d50ce5=
560f716227a8d8c19f42f931b2ff0c448c8999863cd85cc5327c76644de795bee4cfa6ae5=
e1cbd8679a32b489ddc4af5c18483b7325937d4a4e77ffd4365d042636fbf8d2999812da9=
6aa1373f082b22c0f32b7d934a3e7dfb7ef7ab62a72671361faf92f291056499a7d588602=
29765ff64168f7faa220eecbd0d238e483094322ddc59f0477836be13328153b83183ef80=
083e8c74d423009ce3699addbc045b3062f81f2609a60ecee4db9ae80e992ccd481ac5c89=
53e6a8a333810e1fcf7073865f67140da698a46fe5419667025febf699b74156fc2fadb73=
7266b0baa6f87a34bb73115b5be02e15eb389de5d1c9a798997baa4410547f8a69af2803b=
d4b66db6cf0a865119a96e721b71ef9621ed7219f1d2497e55883480d663d59d9385ef368=
a6de2867c94fcecc73f6be4ddd6a3f3eb39b5c7c0cdc501dc69f156295e2f5345a9d8fec7=
fb1ae0ae1c5bda022eb7218faae98068c7686ce04f2c8ceec63ed8142380614d7b099bfa9=
455374ef90e3f9799c6b0592f39fc6228f7865a9bec42ab2d10775094a7964a81110de801=
204d434f132c848e76c6e7464fe4904b0e5c82a4b122fd21e69beaf1709c97ad40714b28d=
55db151dc99b8f5496814ca8f0349176ad7ae864ee42497764f39bf10714a2cdfd50fb337=
cfb6e4db18475ed71b28675c5954b078ce1f035022b5a45bec61ff614d235b4b9416ba38e=
d7f55922d14df5b26487a9d605ae4cec69c8396ec66aceec3b15bda52455c36e970dbfb7c=
cc846740226f0c33427dbf45e0275dfff5218940d36a3a06d93d414b0d2ca160b2b5d0de5=
f432d3f36a449f007068d2b79cb2fc019d1a15f6efeeab03afa45da9c1c360275985a839c=
d0137455885ea2a69aefd48915e14e7973ef44844963f42062712d4a8be4c3da27d8549fa=
3d65f673faa5bc6c8947bcda7863743e4f9f2e7dc62eec22fa2e9b669f87bf4c303e89125=
8b91daec9c9cc65c5983fd91a7709b5c7f1ff72faa639ce26ba95f553286fdec3759a37f5=
986c9a7a0ba711685af75c1b04bb743db4d0a39fd191147e2bfe375aa8d6223e7127bfbc4=
95d5bcd4dddfc29ac13a12a8044297a4caba53d63e899e3242ceebad1e6e7ab43f3a23e2f=
d007352866721411ce9ac5e95d46674b2be228196eed9a7329e4d282ecc837215310bd647=
42b5c9ed8fb89b5ee586b6391b57f6d52658eac832b6e01ea774bc5c35ff1c496a8743bdd=
15e950b9eac1437ace59b8c8aa91831e6716ea6fa44bee90f89206c688501a88de558cc1b=
283d4e2dd62a32fb108dc02ccc7d01b2cef61c09403d7256e0a8439828818966fb06899cd=
05dcbb52a9b8238e2f6e742329b170b1286d80ce38796311c94a77c0cd13e09610cd84e31=
2c0d8c9369c6454b98ddb40d6388ee4a16a408dbb589bc9164c9ff89ed34d92d09c2935a1=
e8d651fa364639598a7af49bed103eb975c43162e1f06b51f4c1316ab61f98c00b9944956=
2055f476e1c91dcfd2b6e5c9edfe4a942d2ae04962399ff0f700c4c5a5f4ab819d1a1b7bd=
64767a7c635ee70ded32870d4149359faa38e49e0a8c7a61ab377b3cb19767d3e50c4b844=
ac007d7ca13e61230924c3cea444da8919074705e79a29e0bb1326bdfc97dc5bafa5b74ec=
e5744b40a99c9f4d7a38bdbe5cf3065f9bd89ef04fdb58975284fc36575bd840840f96fe8=
39005743f840174182d9bc84abd5a2a5d3d3d26310ae37534c574c6fa0d442b1fae60fede=
d31010a206019f1df00f2a07b8e576432f4063464e808691cab001c5f68295182c5e34b8e=
12f96eb5844ca66177af647c16bf2c8cd6125068083489ee2672944ce6852e5c6f95edeb8=
6c97c86d4177bbe7a484464355f0ec7d0530c8d4d196122a3997a57a03a0484fa09eeda2c=
00a515edfb31feded6edd66b6513c5a9def92e7923c1f984469ba7054f96af55930c4c928=
c774c92606d8ab63d694cb94c2afde226be603fb7a0843c61965cab2af0e661c336789d1b=
6b5b4de8033da91497a3c97ba9d8d483d2406c76c0e1e00ba9a0901a93812d15ebb0f6a44=
7fbd3dbe15ff1827a459365f8c49c2f6f05826ade87b51175d78e786998e2818840605e7b=
7c4194a9c2f251912d8ae4cbd2674f95ef96bfe662ed7c412e2e2ec8caad8967f1f320d3b=
2669ad65f39b5405ad1bf0af9c65e0ccd1779f4743e211c032c2dda00ff4fa223731845ec=
80134710c732561ce317a2c204eba2bf298f2a885e2348a7cb07dcad2a7baba7a58461701=
63c6378c7ab742fe05ccc684df993db0f062eafd881554f8b44f6913acefaab6c5927b8ff=
7c0f5955c85cc9c70c04b6fb68aab8ae8b19780527aac4aa0c31df2d8369fad0990c884d3=
e0234b16642e0bee5cae0de6288fb1e92c7edf967037e13f07b3f69ff6a19b6a7ac431581=
0919db8499f38039e2399be08d9f7b101bc43a24a09aa49d82f7c235a359e7a65432d427a=
fb910ce19bcdd751292799e94aefe5df558d7f03a6010c1a9d5e2957d94c63ef221ca7c8f=
16c8e639ca1e332c7d5422b2b7b5589690366edbd0cf21ee41b215b84a1108e0e6899c25c=
a16e4f5f0d58f3d8938539bf970e2b9192f310e2d20b520871ded3702dbf5caa3b1ca0ab9=
dfc3563daeff6bc4b5949757a8c2e3ca9a67bf295b123a86294f1250b4f35a0b8b7382446=
f050d2b62dcacfec5c4bd201e00a50d3d2dd97eef43b3e3934392d9ce77262400f2f04ed7=
14ee7a18b79a7ff98fa60d934af0acc351c2fc3e9f416ee164fab7dc0f6067d10b6932520=
c2cad5d0d1ff5622bf8ee5f524fb292ac315eace7d02c80f885749a096b43dde45cd41164=
2282c163fdc2af62b9dfbb7e02005dc40d107c4747b7d749d1607a7cdc3ec29600bfd480c=
80fe4e302164ca3765ea070de833c5efdbc2cb396306f652e00593682a3392f9d2af52f33=
77003f2771ab919c6d5c86df6f5ef335084b9e25564e510b7e1ee1158e4b011043fefa037=
67cb6a4b647044f247f1d24f9d27a95b84347b5495e81b1d25f8cf3d00ce81cb58aa46185=
8768e052001ec35072d1f687386673819411288144a7c92d120dd58453751c8825dff0dd6=
99202dc73beccf1fc161ef12bdca01bc982bc93ff7927b0bc5c076db8077ad0088fba10f5=
d17b50740f14d238315fecabc89ca4004db8990685c51e7272844db7bc1c16be97622cc75=
69f7eb799708b9c44cd15500fc48a577a5ef21bcdeb4b01b1966b46fe5fc1e527a5eb7205=
4265499e36cbc77efbef2f3ed56abe3e9a7fb79027179855bc52e23a635fbc1f97999db95=
312408a2a6824f9d02641bc275f5f98891b1e5571fb985b4aad3c7542bde57186aea7e04c=
23b344aae36e5842264ff5d7f3d97b8fcab46ed86f33d61a180bb9e8422cfef7e9dbf6fe6=
aa1f411e8413a5dc3f1fb2acfca42ee728d684f6aee25e8da3567c1cc1775efabd4300b99=
63fdc1f85f213af53a74fc3a765ce2ccd33435b4a77e78abb45254cdf197a155af61d9645=
6e344c2187b86637ff38ea31f1ae06f0450dc07c4f75483d7465dc1c858c66268bd6dd79a=
ab93034c4bf074916aa0af59517131a3ee7ba071a8e8489f8abfe5ccea8fbd19fd87f13c0=
b79ae9dc4aed40b876d4026dfdf81fbd26c1471b3d089d8f42b59fd4e333895b62cfad106=
43bac3c9b3693ab266e458429332a208fc31f79d5f3bcc467c918a3f7ed6c11978459a205=
5cfbfa66bc6f4842d1a06b6d1002b831f0fbab4037e6437682609510b24964fda2f3a93f1=
14cd309347cba2e957a85afe51205d9a379a3e1f071774b25e02196cd56066b04af86dd8a=
e5d232e34795abe101d22f40d8de9be579b7441bff26297b6acdf2a443ec68162e9f72e07=
2e3c36bbf3699bb24ea36a00e2a331e64d7398ce667a010ecc60458ec1e36b5240fad8146=
e3879e89400c7a1689185d96f3e42c14cb634b8e33c295a069447136d25426e48c2dfa77d=
11c3b2ca5b1ebe5ff49b4b1a216b40f9b6dc823e58d4a4a686d8e24f3ab217b35abe18dc0=
e57d1d6908e32dfc26da5aa1a04e3b7ee1d015226f57bc0da311e7dc8cd2f766f1e4c40bc=
27b7b62b38985f768a7f885884be43f9e13af66592decc37ea77b83d82997f27734f4d8f1=
ec2bcfeb61fb73169a37953a1bc699ef2ae3365c931001fb42ae1d2c2234bf184dbf4c19e=
7fa0a18fd0b374140430aa14edc03b2abd1fe3d2d515c67e7155c8066366cf0f0e4c72671=
a3b812d4b25844e5e1b59de8d1bd13a5a06262511b2f1d43da6608bab3a406723e1774262=
1155ed8f771bca33b4aabea0ba02c7ef8a5ee44e19a09a2a9f298ae4faaa347d3549f1aa1=
5c608fd8f3c48ee91e5d1f7c09c90d13f1e677313a4c074a1a3b6b3c7a184ea34875afc9c=
1ec7d8f4828e9dd9a4bd8a5d101c8770a371c08f446828de72c6b9f09b8e964e579d7652c=
35799693c7aa3c666116dba3555ea37cf7a40b43e1c75a4d8242843362d8f46b13a071ad5=
e68db0394c5b2a89c75a8eab80709d80c8b479e9f98726faeb2c6c2dbddc6fd0824bf0c79=
76b39fd50acc7400d8f69c7830e1a72985f9818e62af00943d4aa9c710971ed553174f1e4=
fd5934d5382659466a9acff619605796fe6a15b167df17991c8eaea0aa300528e2b504784=
66f4d296f7cc667a21fec9e693c4d4ca2c9c2a0e6fc4fc92757e2de37fb7813e5127e6c71=
38d8f7359ee0e97d479161e05c608e2f709729f1f4bd43772ac8a1c4615c4ede74a91e4a1=
6458b0de739721d2ec8b0514a79161ce0087008d3cd97fdd5538c518b24b28419f67ce0fe=
d106b4df122ba9f51af5952a956a0b9c95319f5c49e3f7b48a19dcc9d9f3b5ded21a95622=
07f162b805b628018dad3161f938942cded99e86f51296a815a9eeb1cdd60330a2573ce7d=
cdb07643fc3d5362a87db6a1ef0014bdf70edb584a9168eef7c4baa260e284a5f221b71dd=
72a23d2443a393c7a3d415b640e6ef68b6325cc8323c7441b036950efad4ac9fb10510cd1=
1b06d1c5cc8258dfa0c9e52f09b47828c337f3291d311a450844afbd52de50527d4cdeb06=
121270ce90a29b8f3fe79ea68ad18e2d34148e643a706fb24ff74dd8664abbea9894f2544=
c22f174a9e50d954b6359af53fff54598a7e686c84299c84721b57276c15adcac69ea92b0=
a9abc225bb9a1a6f2254f51aea3da768b324f3bfed0bd4170fd1784d17384fcf16e8cf23b=
ec1a23151cfe2c81894d95599586e136e70ab39d867df88147f0cf56a5bc6d2dff584baa0=
4f7c1ccdb41eae35345bcd2f9c4160e5d141c0714ba4e00abfc11ba3044b566252ab24331=
428160e22fac02d71704bba9cd3658e4ad1edb5dda5e0f20ca2b768db78f9835501a0fa53=
c21a390f894ed62d815a736f6683e0fe841eb881db6941ac4199e1a91f74ac207928bba02=
4490ca79dd212adaad5b2125fc1abde7214e775880daee271128d3b110c1f4837ca237624=
69b3e046539b0dcbc9efdc74d5729f9554aeb11cd4f169649a1e0a516bba7a2744529e7a5=
bad1cc654713015476353c04ada5d5a4a41e80cea1c72bd97ee95aee3298202208ec13ab9=
c8c002ed999ef0c4114ebafc49333ed4e8acb8ecc346615720c9635ceccb2b4aae738552c=
b3a25d00f14fc49ceda292c0ba51e3705c8910b849bc40bce90825cffea3b93003f23eb27=
22057e3324a585a9d28f8407f01f38b37e621537a7791cc81ed4385160c4e4e33b8c43e6e=
e71c2cfdb9b29bc7b62110f3d43b36ed066f2cc903c712bb134e58a37349cae68d9ee2da8=
831738c299f71e8abf9e64186c234eb9c87e983eb31fbf854fd809f5b5e3994fb287db385=
c67666524cddacf77955ddf8eccc91e4ad0f974f56720bcbe28e64ca4aa537cac33a7af5c=
64577d9ce3ccafed63000afe624037cc6f50c4f1843f774227b831e462e6699d31d8e862d=
e7839a6c21642d02f42ebc1f97e57277565a35897dfedeb13b595f89ff9ee7e923e87f0a8=
e218df193da791b5e6b5125cf010ea46ad97e69fba91d5a5f5910fe4c62614308bfae38b4=
93bf47730b2407f58c4013b74787c3b2366e11c56f24864575c03e153fac827dd8cc40b7d=
a5cae79d7348bc9020e8d953f030e69fbdc151b844864b7928983fc52ddb78f7ca9d969f0=
df112426d71b6213f274f4c6f847cf2690ef569e3e6cd1b4690cdb15ee899a4cef5831b7b=
94316a817305b5afe6b7e04bf72b634421dfcc78062f21ace9a094e71e54fa5a68ce305ff=
8d655a4cb76bab1a5f65695068ddcc713f894d0964893f0e8ea0aaded011feb0d7e81b096=
9d62b19c399d303f9355577c1a7ce9f48226aff3da483abc841f994f6d073a111751ea78d=
b37654289d4d26aea096e789cac8fe3bb23195d31a7b8033ec2ad09839d15585daa7de2b0=
ed14dc178df27b1c6783bdf2d63aee1d0d4b5c73386b6c193f6bb19ada653c9d89de533a5=
f95d731111048d727b541f8e130e9b0c698e0695b12d603e6c600f7fe5039ffc0c8e9dd06=
d67b8c040a341ccb89399a097a178d70caa10141665898d836ad6a63f1f53e5f71fd16f58=
92c9a4b8d6bd8653a7ba0a888f746e3e050777cf6d569e43772b6938b65a3a6d555310d00=
3b74ff88afb640c1584a163f3ff30564fc974f2f92f92f4dc8eeb8e09c25089c55781100f=
3d5025c6f8118bdcdac966fc3077447a43fdd25496771f9a7a5f88a1556e9e48f4251a56c=
cce8830bb60905006029c562f7540684cc47e398fa292146b2579652454c89e2f3b6118ba=
d6964176403b431490adf3d108f9ee0c91a7a56b4fff0c0e3461e45d445a65a3108df44ca=
da6fe0c1bc98039188b588f223726e5d18de2805c901c92aeff6ce7f9072e6c065d8f5e08=
a356983abdd55cb89d4062f90c0bdaff31b070786f7957d48c0006a4c59e9705172061579=
cda17c0fc953045cac664c8a63534101cda0fa271f88d97e30121923e1359777ccc9b477a=
ddd6517b5993afb19c6eedc4f052a6ee879233f9d1f3ec431e3aaa787e561223ca44906d3=
ac85523e3332c29fbda77ba95a16d6f99aa893f7df8b0cacff383e196578b76b0f847bd44=
0acbba3d9642dfea94703c39514397ffa671751513c15f1eb5614e54c1db8f9fcdb515e61=
75b13d19eb82edeee6362563ed91a3229b8876e299149a51a40a9718da40cf3236209694d=
3aef482e79349e88e1ef23a79ca484c4c04eb7732ac35733af6cb4f5dc49e5c67bb916ad4=
85bcccec344d387627a3b1b97d7f6c82f5e29313f19e8e42e065eb94120bdd1523a11ddd3=
26514a2c8a54338c5b86328dc031cd07ab66b2b4a52f3a29a33dd776cc33a7b0643b6922b=
00c05f726ea96d2bf9f52c5d88c4c814a1ad9e3df182900176a5daf9006bc0b3987282ad4=
72a9ff9653335110020bd97df97084afc01fbf75f5538bbef39f934d781cf5152aa43219b=
4ec36b5d247c2f037359b02a21931fe187f77210d4d6745963a8cfa379e5e581ba0096574=
466a112892a85a7de6b5b71e8b5cbed837a1216b52aec86c2f132a5b68cab5f4fb8fb4b8e=
66d0b8da3ec9440e8ad3e8652ac045ed7ec82e46e49d0006c1112ab8338ecab8660167e2d=
b4930f1bb2e9fb5687f0b40b40e0dd6b75e78a082fdbfea91da3f07b57dbec8776232f312=
b2d267a8bd372aeb94e2ff2323798553839c961d820d701da8a67a1fc0efa49595f3a88ea=
db8a01c80c239968925fe2a71c4c3571511d13638685f33a2957da0f9b3444e9c1ad13e6e=
eb9175bb188e2cd28e7db490b3f2cedc96c77c01ff7abcf2b27c2086eae3f3b4a1489c5f5=
aa067065ce96108bda1000f636bce346722c6902511ac1a0c688b0f49552cbce6c0543677=
3b43cefd7ca335ded24e17d92c61987bb87693555b8ffe222d30a99ea4ab557994ff136c2=
d9c24872f66e91220b339aa978dc250c435d1d04d460319e0ba2ead5c8329698ce1426d42=
705497671e127266ce256a20cd5b4d859bc5361c5319801576a598f6d391fcf41cecb2663=
226105b6308ccd81c5fcf52c30e7b1d43d1e518884f521ac9d017da826d1c079445be1660=
65ce5974f92fe92645342aab60d5417d1d0a206bbdfb96cf4346023267aa3aeafac6cb5ea=
594fb452635a97f4f87f634b477bee33a3bf0c526c8e5c091e7213659d3fcb8773fbfa38f=
2edff5636dedc6838a9d7e279228a56f89d5a6baccff0461d91d136ea8d097c83993804f5=
4fd264db79aa67c81e966a352b1b9549247fedc317019fa506edba35b0e3d61c93950562a=
6d968c001e24900ec7609a8f72c9d6953b7eeeceda50f237e59c106e16b68145aa746ff37=
35d279b1162cb0383c0ec9d124c94cc4337f21e980d6566d907d0be94b67539b8d10dbdfb=
d840acfa278d5ab3e35a64ee36b2934f019175d946be8723b8c529fe2c171d05e12c471fd=
8de3cd0d2f816fc679273ed18bf0df1953b1e346aecebfb226746ff493b263dc0886dbe2e=
7994a2e547f3c8fff2424c1529f28c390d7e0c6d8829585c41a730b37bdf5343d6396f244=
ebc1c695d37f4b343d9e1a56ef15f808323c465e91bfc8b7f23a71e306128b1cb5da4477b=
7e140426430f458bcdec732d45da8d33939389412ee609821e07a47f218f8447d246d8b2d=
f005ca0b1dc70db2e1800ffede9c04b3a1e1247c4ac6d7f4065ddcd73e08b8777953ae24a=
9d0ec824fe75c1220a20b2e9c0b9bdc5102043f7ef47da065742ce5930582b670a6b012e7=
030792ded6c5d3c4e92e8a27a626fb2594151e5ac1d93bae6e86a89cbd748e35678bc28f3=
aba772cd05990260014607c7348e78da39425b1e13403a9750fef9820f9b15cc16ff6beb9=
fb86277c06873aa18c9509cd3597f31502b6da18fa7ae25ff104db554e2021edc0860311a=
d8956d3a415a3f70058699235ba0cbcc304640622763985a81ad5eeac54827a4b4adcf254=
b3a8909959f9f5509d7207c07cd801bf1b6691edaf191b4ea870302b8d6b51a1539c857f0=
f012204572e32e6d64e2217b7918a0acbf87779c60555bafab138b6edda46d4ad8a835a47=
06a0bf754e7109abc885254949b03e3b2d265385ba54dcabe4857e85d804d3ba72bb38305=
a143ea21f523844e732ab89a42bdc61f6be1f9b28e3386cad2ca92f6c70a613722f3c0c4a=
f72b2cf39d5b734dace0f2e7f66d6c2ef74e141e73cf90c6f979c576a82380249b6c654a7=
b2ef8372896f96f6f766642dacd5841250c97143857e545beab5c3882a3e1d529bb519945=
412e6bfc774e99463dc15bad3f6069c5827ee76897151330dacd669814a58185e301d6f0f=
701908d378b6183bc6b06a8efba3e70a4b790b017743ce08e9bccc686fd0cd725e3ddb931=
1573aaf22f6e49b2c013306c145ed34275433e869a4a721da89de4f59602c5c7a9e54e678=
fbe0e88f64110c975b692390e1f6e896dd322559ab9c629eaec0be9553ea26c1c0360fab0=
2d8e8e16e378976ce57126b434baae51289e916210aa802849b23ec851b1ddbde105bdfe3=
72c96da4ed1a9f4f64464ad704e077b14036fa47fa1c20444392e30da43088e0f3926ea1f=
ba4f2193ca38f7baf44889f45081006acc319e9fe73b7efd7702543c08ae91426fb0333e3=
a347c795adc061d11bd524f5bd1570e0ed47796f6bf068953be6a91b43e66607e25fef130=
5025b9a7558caf9a9cbd1b91757c21cfa254c3ff83f5445c0ae3e70c2f295ccb05ae85c54=
70b893f9768b3c641695dfedc01382bd952023331f6401cd20993b7460f0b5f2cac0779f9=
92570d7682afbf5b2f1caae09c9791a3e9090a5864e895c372064fec3203700cfc75939f2=
e9b79e2907cd9ba03708c4bdd4d2fed6602cfe12b9b6388988fe9c955e71b90fc73405522=
ed1b7579a0c278431e0bac8ef597f398440bda215da819af94b6bab31f79f9cf00394cb95=
5beddef2b97bfe985b6efed138dbfffeff375c2ddcbfa930bf896",
0x2000, &(0x7f0000000000)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, &(0x7f00000003c0)=3D{0x90, 0x0, 0x0, {0x0, 0x2, 0x0, 0x6, 0x5,=
 0x80000000, {0x6, 0x9a, 0x8, 0x4, 0x1, 0x3, 0x6, 0xde23, 0x4, 0xa000, 0x=
8, r3, r4, 0x4, 0x3}}}, 0x0, 0x0, 0x0, 0x0, 0x0})
syz_fuse_handle_req(r1,
&(0x7f0000006400)=3D"d1847629b8b32311f0b3613f2ef7623b7e6c2f0db70d70defd2c=
87cb9eb54d5867b40ffdeb44e9ae36c7346eea76ad680d71ce9523a91485d2b97ca190944=
a023518ab9fd3055ef3a96893578d514a6e1843fd009cc02db44338089416f62c86dcee3a=
ba6aad1a8f33bcb5de95b3e39a6d3c1cf23b34c59650f9131ee357550deca14000d942917=
61d77a4be69d5fea5ecddb7d3bc24cc612200436dae9ab65002f6546a6ca09709fb58b2ac=
40bf14a7c66debc3872b9b50451192d62773640e1fc32c8d34da2b8de1903871d4a89d1c8=
33d058af658b1ed6d8396b1ae5b701eef35eaa1e26b5478a9aadcc7f8ff674a1b34b85c9a=
fe9f79e9a474541e1eda27b903af7b1605b8f0cb56ff8def50491d1a63bd3572d3d1f727f=
6a2777c52a47b2ea0785dd3b599e8b33be024ff7e530ff955152d12c8f2429713ebbfa415=
958d657078941782dff438d3c46ec7336527208e7d76e1cdace8b84e1704972c61ba6e73e=
e42abc5e126c25da7fdc366ccd34e4e25f54510f50d7411d104e20b999a238f62b5f58bd1=
6c6095c3ebff448f704b3f751b7bd8cb21d97900ef1693ddd2479df932ac5c27595c4fbe6=
3bf3dabf627ee763ac4b09425f7a1ce69aaa4e86d4fefbc9f011eb46464418c2f313ecf38=
d260038228f015675fcd1bbe1fd70e29a0a8cc39d9265536b47b148fd3afeff11e7a99e4d=
7a375c9589adef1a2d467d8c5958a435fe35228619d0ecf823014f397cb90bbba46748c8a=
ef37c4d78631749be4625417eb529cde5eb0067207b0831cbfdef67263f5e631392fae413=
ced5c9bbd6f0d69d2e08d69d00602038f2f8acf761e3595200586d54946a0b27e2837ac97=
b8352905df9d9b198d45fbf967e0279d81a6501ba3df534a2846b210be34875d4c10392eb=
f2cd4a880bb7b8f73a70bf225855f0911a426dd3753804947c489f7df4820dacb758a6cd0=
8d416102f515459e96f2d9106b9264e4d559ecc488e562a8e1e7df3fc7e2ad7f631c8e3e5=
5aa6be2f7d3c7b5055e775f6f86864bbcd91260dcc5b96733df038b84941e7dfb06577c88=
5da6887736f8e8c22989fff2e773e406856eac71220a471fb0b67b2e45b158126efb34973=
9f3733642e63f34b6c458c495e5d3551dc3600c6d75a3b4b1a06f59adc8d8bf1f74105f61=
e226a0b80660c061c7dc9e910e0027aea8870890541a090c094cca31dd252520ddb7e98d7=
ef2353a4d11d0dcd5d635f0fb9c429a69cc2a08fbfc07943d910a97a07495809ffa545ce9=
03571b336f27c5061fb88a9d8b5ed82c71573fbf6825d1101cd91883863c073efd4977eb4=
cfe87e6716753076dc016cdc383c3a17068baa21c71690488495bd400d3c93961a73b26bf=
12d60a57edf2dcedb3d9b3b2616fb62862e50c21d783a533159b21635fb316f797fc4e2dd=
cb591db40addff2a21872f1c499008929e58500e4c6f55ba800d58026e05eada9b61994a4=
12f174f2c39923cb1d02505a31235f98d8c523a574121e1194ba4781b5ab4d3223388180e=
37c9e435d7dda498002ff8d3b3404e40e51d4451a52eb3763d79134396fffa3fb15804d9d=
1b9779ed5e31ad6740ada75535d14fb41e39ac7caeda9bc01399aebc226f3727fdbee4165=
b98da6645430312482390545e966db851d035904ae2b064b262bb76f9abf531b9b9da2846=
c26bb4019aec5037b81c5d0dc4d393bd8bfe7daf1d1dfe0b3c96c6f56a5e9d50e66c61218=
2430feaabd865ffb4541ef28014b7fa5b4770231a911cb109c25c596e2df0e25d33550b92=
80e1944a5af2d374e4a8fada818edb964eb7800665ad7e6d33031b67070a37967b03f5f19=
249abcab594c45e6588893f9489f5e176529255918002efcd37fff92421e629bd103835aa=
2bc0cff824f4970c3b1dde2c36afbd169f6177a59ada0637f0087a358524f62d6e0d43bcb=
8ff5870a61048b33f808eb0597744c6fef62d057421f66ba1db77f08e946987140de3cf92=
4f04f75e211f06245fd621d897566cadef1ab84f76a4a5e638e8db97b51ff83494f061439=
1719058ebbbf30f9002b7ff7e83ebb84d6be3496cea286a426df3696fdea1a86af37cfa19=
f2b887cb364591c2fcfe9c2e5a7e0cd6b703e30a3f08c16956cf878d19461ad7b3e5e4fb8=
2f2bd8d094982c47f403e0dbb76b7dc489abfdedec1453fd1fbca1a622e88fb9cac1b7a04=
c9071ee627d6208dd10c9280f24f04c9baccab5206dc54d6346fe077317176a9ba2904f3c=
447a965d4da58d77cca55fbc5de7497e8c02257cc4652d04c9e165d8c0c2851d588902510=
a52403ebbdf0ed412ae1ccf603ee34241a66a80e8a3ab45ba5b47252497d4261c84f505e2=
9d4b9cf31c580eb03aca6fd425b8f987adf82272fe0a10383c2a3349fb2e0d76fac7c56ec=
535bb2f6bb7e022d83ed82cfc5c929d042346da6d939590ea70aef16302ceb2c65f5c1181=
abb9f47a4eee9a2430a9eb44119af9e695119b546b04ca02a9d6243df326cc62f660c617a=
77f759929ee6196a3d7ef87d9329de8ff1b3ab7768319044303341d9fa0bad70f8a5a783b=
1717fd03d4fabe7386139c49262a285d8a11aee8a484959649cbcb76be6f10458e7ac4dbf=
0a01379b4658897193e37b3806149831e4a7a5ddbae06cd9b81115afee98535840e39ba4e=
5a7dda088cda47c0b0a795c55f1f09830473c9f07e1ae8236ecf59761ba6153bdae59fb32=
046bb006edfa45f354384b7a61c27472455291ca07666fababd2a5caf2d968cab5590cb8d=
6edf74164fa683d0fa5ead0dfe9e1027ae280c9c03a77370186f49492187909aa5ff28ee5=
eaa0374f3cac7f100c9ccdc6a355835682a2cfac2a738039a63b69bfd4483d0f758a29b00=
cb25d3bbbe2edd9e88518a5af0bfec28172ac8c4af3e1788bfb966ab370a3b9e147f0312f=
63207ffc2779a02b01644e1a636114862459dc734c37689d9fbf2d6f0a24259f8474d0756=
c971e005c47a6fbbf2c5047d3e074c693dae1b41c8042da7c2f21ecc4bacb93d96ff2621c=
949628079897efd6f42d6a4f225b46c92ce1448abb02d16e8329f0a133757ec1a4c3c82ee=
f0baa694fe13efb73b59196c39d258b6ca8ae25da0ae0bf8d9cb90d25d2393f3fc7401770=
3e9f4f30ce039fec1cc32606e013e518e128c27fd28a0b0d621290a8c1cc2a0ce446d984b=
7f45f919daa957ece47731fbd1db23b0b284c6886a09bd553cadbce93478f5830fc80e42b=
3cc2ee60bbce6b4a61d8cb00b2a92adc91e32109b812ce40349a7bd323b23981b00442725=
674c424acf8a270a30d7f4ac3d05e215d1a8f8574bd40935bca48093c0405a51f25d99bf5=
22eaa1bab75505ddbcab4ec301c85402e233c6850dbec21ef319beee2eed4ab2448b5774d=
efb10338e28a6891d54fffbc71a48ec6ec9058eceaf1c486056c56bb9fa0a93a803f174a7=
2d41db738971b438ea8cd91b7d5b2eaf20f36491169ca149fcab51d7ee4c0fb96ee7e1b53=
a733cc566327974ed92abf15054772fafc397e033cb72e847cabc4bf3ab5d1eef923e7eb4=
6f6abb5249011a7257440317017ba894e50bb20dea98dc9ae97f4d601a0210067356a2ae2=
bfa12e028e594e33402f23b2bd5c772bd930678476c74a55841a23cc668f0b8cfc762c30b=
eaba8cb1c1fd5bb64b5ab4bf7544975aec5f1e23173ade8c10da5dbcf742e16abd2be132d=
af713c2362b77737dbd3dace189e5aee33231602ce46861b83af76630b0dbb0da1b87e2d1=
83cf3f34ca8064b2d0a6784548ae3fc71797dc5724bf570aa99c50277467454a51bde468f=
0e33541a23cca11a32298aa52d573fb98cdccc55043fedd4b57ebe921c1791b5bff68c744=
06dc2f7c2ab1c7d11ac8c83fda5aac9c80cd4cacb8c94f0e0a169944883f2b6c5d1a12ba3=
b79959fca8b54784ec419e048e03371f333300e7e1b78f1261cc093e556fdef5d257bce50=
32760585490f5a5841d98fadc0817c74e86b3ada213f55d3828433c13ecac1e335e399e78=
b2c8555ce1bc175c7d17652cb606f249036f79fd38a45b55015dcf85e55f412decd0b1c3b=
d5524506d97860fd58cd96ab468bbf28c2332810421a56b3356b1df87b4cd44686af33e40=
956c0fa45da43b078fff00f4b56efab940b057f43763cd6d876f55371e7b8514c47625bad=
b6451d72992f100e6708c210935bfae86e96035b1a3d32ecfc45dc4fff58b330a6e790ce8=
ea546e01112dcf9a7e3df6c351aee97b48fb821bbd39f8fc3e14e56f1e66478009b7b9466=
f5a538191399e44860d1a08231c9d30dc4ce2199903e3282b92938a252fd191efecd4eae6=
aaccb99e58aaed62f879ffa9aaefd6a1b5febe4ed67fe49cd940740c226356e0e20dabb8e=
5251ef186a63b7ff3427118ba081d74444aa1c17944ccf30df8224bf54e6d2c668944df91=
a7b1e2bc10223c7903befdd912c2d251e4bdcc69ca888a45b1039f57b4029c0c21bfd5ffd=
d7b5d8e9b9aeb38a6c20a415e9c3759bd4c226875c09e52e6b05b0b20da60c3a0648ca7ac=
4dad02935f69a0c8e4f74c92caa03599e8f20024953cc0908222a3fee8706d9b7251b778c=
40c820641e5c71c1b76110ed270d1841a93e7f6168f3e45fc9e718aaec99ccbe3e2dd501d=
0fa9bb727a039721648f00d1551c3f0fbac3ff6f5fd7c8ac77ea173dd4c436cf5a56e21f7=
0d8bd7ff4e7f7a7ba13049700ae7ef10278607ca01acceb4b35f03caab627f1732e49ec63=
f99047e171a40bf0a11344084a86462fbb9beae092b259e3194d3f19de019cf9b5d25f3fd=
4b05400361ee003f38450cef86fc79a3f609d944a78f52553d95c139edeb846fffaef89d4=
7181d700f95eb5a35d014ac44f5dd3b29bfbbebbc82a13ae00fc2efc0d65f8b4611268e86=
f781991c260ad83bf7c3f62216ffa71f6ed6b99e345131705fd4564e418da75b26343b678=
e087c8e3d30326d59443a3c44d51e96c461874fd0980366c882b1a7eb31d8851732b88ad5=
501488ef65482b8ee7c37142b3919fbcba2247e219834eefb734ba893c255f2af9bebcd35=
2efe6ea20cad9bcb00f393fb1d2f46e7aaa3d32be901c0d1fc181415c4c048fd3ef94bb21=
b898615e6cd41ad7693b25616589d5852ab79a9ffaac813564422a48d969f1c4349c3bef7=
7dd38ea6d522e6430d062d2f9d40077f1166a030e511059ac0ad12a969d5d2c0143f1a387=
4111abb2412282293737b918763f711fd3b6273d4acb243dac25e97f0ffbf411623b4a5c6=
c93c7e5e5fc26563b90073e0d6ad17a7459bde92e6a1f24545a2384f945de8fe30f4c68e5=
cc59707d4c2570fed7e6e9b8941bb07b904eca978b9c2e0a23312ef4eaf85f8bb76977711=
24533d729ee090eb0d160438bc8e4c631e28b1bd0badf0d065f10f868dcbf1fef31834ef1=
e57221dd0fba7d0e56462e815538ac44da2ba70c0698571a85d174589c2394accf8b98653=
fd6d1c54c9e23ea3440accd77eb9a8155ed76d68f336ea515722062c69ad79f1d7538ccec=
63eba72d755b3828c463306f66a7798832e4d3dd598f4a3bf007cfb151734fa1a73a8774e=
bfd6137e0b4d5d3d76552118b040d9c060758438f5108611c2db64fd35935498254133bcf=
a2adc6ddfb5b2f15a4ae2c89e554d82b753c2f250ad8f9725c7b93692d0eaa0ac0804844e=
5a70e162e2d9eca134b9b1c25a5483a54693b591f76ea6d891b47f57ea3ef51808f3d93bf=
74c6c6edc60eedb19524d86e4ea6294ed09d8c45feb874008f4aed864d6404dc892704a21=
a78da4ee3bffd444a9a4c1ef34580c5db99419856187648868ae4845fb4c391f17f16707d=
2b9c5cb8a1d4a10c5b03eb165e7676c93dc5ee047ed77474ffbc301115a27a8144c7302a6=
82eef28c75c5539e514898ed3d8ff75f24b8ee466ea49ad280eaf84fb49225888c17296a6=
d2c709f57822c660ce5f921123e897d4797ad151cb9bd58d6c38c3bfe6a5db76d72b68bec=
d64d63319b6cdb1fb548f9a8cad9ceca4c167e26219ebd20c4d8e1c7fb74984a98e483503=
2581ca10dc6089e57987bbb4dbeb17e6a211a85107d2b5dfdbbffedd3ea8ce80720e82b19=
89096bd23b05992c0a3e09b766a0e4c8fb486290238237b80787b09d495a5e1b9550fabf6=
17792ccdbe797857a572b85eff0d214a80aa5be99b4ca4ca9ebb189944644357abc451d5b=
407940797512270208dbfe6c320740168dcb654c53012e7e740322dd91f6c2647298050b7=
e8440857ff1a8deaf123a8da923d2f0cea871d21ab154e3aac07f1994851e755bc21cde31=
d132f23d9d01bb51d5364a72afd190eb93a7e96948ddd619d3294ac31340e1cd78046f1bd=
ec4cf1c30442c7f62d8bba4e973af102956c824b6be5a2309ca38205f5c5d66150d431cd8=
9dca11db7df2be7abcaf3398c78409aa852c7290497514b8746b1676f89afc27d38b39dad=
5ea4d8bc371f4e4fe59fc4fb37c1e2dce7e213ead05f80fb408780dcf6a57fb3fbbc3d6b7=
edb6398b7b09d85e2ce07015d4dbf3cbaa02139ad16025f1f65bba1e5fcc9216de59ccf01=
32d6a00e05f7da8e84b2ed5f9fa143f4c4068824442b119737e77b85f5b1d10926404b05f=
aef7ee385738531e54d20fc7134afcdb4bbc5ce305ba13506c4400668d8d787ca59097b63=
a270f1e77c455e0a1091d87139408082a7af05ae3a494d4652790c057ccc097512a450dc0=
d0b571b278c361283a6a90dd908925c94386d91b8f32eabf6e6555217a3d11f068c24405b=
4ae1d8eebe81096d4ea3eee410d5d07aefe26563904d86feaeb5bf6c5c53d90ef93b64eb1=
19c6bcac559987c0345171bfb40f7994289d57c0425f6ecb32519b97ac8e8bc366b816fc1=
87bd03416222ea9ac7c9b2cd41173cf4b50384f2e0ecb3c307acdee361e73238c37555fd2=
5c5fca471c8b7c2739bdba5e06bc3db77cfb348af90b6906b2542d69eb83162e6d5607cf2=
3391bac51d60e9b3a8703249853015e0aadca8d4f2306a9daa121bdf76e98c55406d19c5d=
b51a621df62aedc530da27643e2f34ddfa7f91bb53851f9659e17292994a9610e418d7225=
223bb229fda63e3c1863b349a73f7d70493452809b77431f578bfda82867f2837f3d1200c=
ee80019331408006765de7d27f8256d9242a09df9bca29e1c9c727cbe00c6f223df970d62=
7c9e06c07c454a4c4abef00ba2a66c99f92e73eb10b71684c9f4081b5dc3372524fdd76db=
6f6288b593571849e1df8855fb971773497e90ed8722facc63be58092f929c306e8ef8ffd=
327a95068a30b17535ac6f79ea2ae5dface84235580e7615674c5713c42fbaa87b3ccaeb0=
a916d9d737e1013351eb471e967b2562272e68c760288dec5174127e2e70a12e3e8ab3af6=
932fea0abee4bf32e2d609f210e153168ffdbe8bbeaf63e1b2f31ba76e1e717800cd0698b=
cf92d1600edc35c543a2be0498ac78223f62c61f27502a02dbafce827cfd924cb9146a587=
30692cfee526bc59495d6db7c485a5ebd756b25a22ae77aa70594c5ac3850235ff6ab4d9d=
d7a3e494d214bacc60b46186c2fe413d96cf1b1ab10595255a465e57c42b52a124206087c=
7e6c4c4ef25aadfb4a09ba1e7a77147a3ed6fcb4b09990bc65770cb7076927c01b227cfae=
4a8ed1f8e2b9f75ce18f7d878c5544be2d64074d06a75424de0ff72c812662e2af6c7e383=
2df151ffebe3507d09b1e2e0c134b693d3c7c8d81fe24097d138601693d4027920d43f28a=
4b2f73ee1490a221495aa12bfc2cc0d2129ccf36060bc09852e8747d1a9d354eef234dd29=
4f99263295fba3ac5eff8a96bad66bbfca1fdf02767ce0f6ee0eff4841323e70f25640b19=
10856ac7dd68eee19916c8336e670bd8e1385a99918aa010dff6b3cd065a0d8b38d4e9a94=
4e708e1fa38c0e85acbdeaa14d289348833f8980d7c0476ee7783544bfab6cfd778db599f=
02880a386a724005dbf620db610ea2e6f6e02eb8961f22995fc633cce267adf7a59bcfdf4=
da1d2cd35c0371c859a586c33297e17cc0d6ccccb79b8e1b14d5d8741dc2129e09d3e2e31=
b3d046f70c1cc0f2adf963022331225a7bb52164fd6589a46a5950a185246d3d48c592781=
4a9717d780df10d2463f9a3e5fa067385167b9df2d71463c9daa9b3443713701b990a2b61=
e453f68f1c864df5647be3aa14605f90ce4f81462fd80063419fc7209a6ce0b89733c0947=
b4cc9f52dc7b8502d120f855b11a3827bca4ec3e58b7cd211e049c2b67f61852939705968=
bed2e39fecb8b2aeb334753cccf35bcb806c6705b263c4907b3c2bdd864aa7dce74648813=
4759e43d9a496bab4660d826f95fb4857215f312ea2b2e556a89be47337269348cdd25c67=
12f4cca7f485686ea46d0eb38c7b37f82f7101d968736e0ec06a3f3a80edf5eedc3d942fb=
b1cb75fa0dc580e9cd6f17b603ef4f2498454f4676793d4b7c762e898bcf2f5c2e61d9cc8=
d64519770435a46a4a90eac4ae0436090a80bb23a537bc4b9c066cec6ddd46f7f3029e07e=
3479541d7d127b05aa85be18002c59b41d4c6f3630d54c91d1a747aa1ef1c30faaeec4b94=
9199154cdfcf21b55493e9f43e98ad0dd492eed7491041f38f910024160d32fcdd1cf63ae=
0a65d9f6ee1164fce7717c47d9da69ae69dfdb206edcf5dac41266dc4e6f7b94bb429c814=
6c6e50668e7b53839b85b998ccdbda5bb51b74c3a7e4cda7301f3ddafb4e87945f1f64bda=
82a7ba42db1323d7f1357f68a0c8ad8b664ae2da1919dca4f679657477464c5f3d6d995e4=
52ad0b92075867ab3ef7cc7d6230798ed67af4202afa7b6a96a71f6bfdb044c0f86a6fb60=
31a5e8ac4d67ff8f7cb4652bc06b30ff476cdeaa536d383463d07c6bafbca89d06166c3d4=
a1bcf3b9a858d1d6a54f8e84458a446a291d28327ff612db80a19f680e50f57384b4d6ea3=
48557d07e4e7f71d02b83869a5b50716001cee1dadf47e3db26c20bf7e54bcd00f77878d8=
ddbca5687f1d93d73889d70da690613d4e60b1f6a99a430a93c4f6344acb830b16da48122=
2667e8d9d2d875635d55a495902e4b434f52505943712f6a05d90a371411d08fc5b3a7686=
772a6097e603f4c947dd6067de11c5e42f3d43a5148719e10062b334bf4cab4e1d3ba17b1=
0fd5d2e26b67d58bb1c04eff22fa45fe09c2f8441ea889ced3972d171041ce4ef8c68ea8a=
1b73419cb9d7c5b21ee316ed6cecdd96dc96631c6d213d92edb4734ad81465576d032a4a5=
5ed3f03045816703a290a8af40f9bf7b1da8089215dd813fe8e04e06aec54272b6ba48d67=
27723fa7208508f6fbe318ccd66d4d93ed2a584dee0b1745b6e99287cc4eb5ab025ad66ce=
610e85274865a7733a420d7d36de3e6462fd5bfa7f67700db7c8a51a82556fb09993ff0b4=
cc34ec17c19727f38903e8ad8f817c272e53612d79e8c218ff4b122a087ac839581ee953a=
e3134e7899f24d9c3c3349c99fc7f4083c974078d8e20f4ab16e74c418e1de03cfbe3bae1=
5bbf7da7eec27990f41ce8ec747b008872da491157fecae9c71b82836b55a34fd59a24ec5=
01c363db8520d2ab64ebb5cf42d67643911bfd26101777fe02db300c82f9a5bf0eed3206f=
a745e7a2311b6604e8a263dcfdc45aaebf2be105dc9a3c691d45bb01e36baadaef8e47e2c=
9aadcbe9ee2ae2fead646eace3ac7924dabe86aaa06e688234586a7ef3cdf6508ea3fd65e=
f0ee0f8e13919ed96b4f94f2a2c915c2377ff159c9386afc24276dd920b5449925d4b41b3=
9fc60902e03aefa57cb00d79ca8f14e51ba3fc9a0febbcbad5b5982271cf161a7bab4fdcc=
7deb48d3e7d125f171ec55ff0b5416de9f7b323c6002780286792ba3ba3dd3b7da5ad71aa=
7eecb7f555d1d80d69488b1a533203e767456c647fff0e4d01f81aa1673cab0d5e2bc234b=
f61c23b00eccafb9a6520600d0891b6609690891683ee8745516d69150f8e6bf4199798df=
436e5a6bd33d2d787d210aabeb423826d1ae5531343ac2c636216d91a4a467f66a3af2e00=
ba3c8ac8989187a59a8048e45db0ff4bffae9a6927796cc9a33c7300b293fce6755499554=
787adb31e8651f3d91ccfcd297c3517fac4585b12b85df78c186e43ed0923033edcb273f0=
f5b0fa357cbd58bbb134a3c29e063f907f6117cc34ab6ad66c8762215ca59ffd216a77063=
6ee82a8e605a9478d3e62a84b4a42713c7218eda3aa54c736e9c450dc497287baff675ea0=
10465897d83621121abb1940323bf30c6192f854af5611d9b5c2ac5a58cd36b9325f11e65=
7c4272f48414d0b82d89cca0be80cb4ae142f6442a9527ad0ee8deba525aa5cdeaaa60305=
10b8b2a1e85c9464c255940d968deb07abd463e18a68252e86f58a0f7d284527af45f769d=
e13dc1f06ac736ec7e5340d9ae9370a83a3fa1214fd84f1a3dbc848aaf178774df75ca2b7=
c09ba28e79759d747832841aa9861cb8efa3788c863ef5f949b0bf00d88f811dba5e91461=
f7d571d236d2e4aee29723048f9ee95dfabc090788d5f7703887fc38670cde115e75a3f42=
93d6e916ced7316917e4c8d583d949b3e59bf77ce8cc549a359ccc7649ea23adb0c164cbb=
6b97c8c4728338d993735a6bf18d89803e4b97c3d4bf3701d72bad91cff3c83ce0d493f91=
45fdb7cc098f63ab06247a8212b4862ee7b97bd1e4460dbaf6dbac749b21e97ea0f4033ab=
85977f1f6131afdfe1d3830c5fa4e5030d8d8930d890304832031baf11b17647f906d79a7=
11c8ee99855d4d7a00620864b9495c7b248ef9bedb29e8797afb9532da3a92dd6c99b4ca9=
b20539e5abc7d30778365cd8e1498bd9b9e7fed4c080769c45a2effc7ed811deed99a522c=
a018ac00eeacc402ad04e2e3348378eb9c9ed40abc416dd88768f21ad1d09f792628902e5=
177c95f259de1a73cf34a612d88f81cc33f8a5c3da0142eb906caf35f3787a26683a2b573=
a1f0b728f290bf74d441663c1c04be7deeb9e8493ebb29294e836cb25417d499cca7b7478=
26cec62d1254eff8487c5a91b203e95d531431f12431fb6522dbf0a702b5a41b4919004b6=
1455728fd3e47f56c96268c34301d05cad4014776944b33b4446b51076e71c691b4a190ac=
f008574977b74e10102f4dd272beab646ddcb0b4dab6bb511a12faa59a1b4dc3507fe8ad1=
bb8fd80c98df3e3e95551b816b583eda74f80efe345db19df93a355e2a22896b033fac066=
b370fa34e383ba957ed1c181378d9178a71d7b7e208487ae7decc0b9f56935b5e1faa29cd=
31c6d511c2997def9fd3747b416ec38196c8b5c0bbc845b242ef71c3e6bb0d704f475a33d=
25a6903c2319351324530c15325848b44f4cfbb05ca48a02cdbe164d35a66e2d7e02ef2d2=
37d49ad4f9defbea01db1b5d19802e28056382d3cd0077e2c67dae84704c99468a9e06c6f=
86c06f55249aa97c6d4c59fee7117e9fee9c21643e4af9b38c345a990f6c09b079243ff3d=
5ff14897e4b0740103e7049f13f467184742de82bdd71ccadeb8defe5c8ac6f0dac16fedc=
fc3da536e8d7313f0576cbbb7e18c89bccb3a30cc1fd39797b6874b2e9c69465c12a5be09=
4c949e8a668c47be512ea5a99cbe20c71dcfb6a000c7ef5d72467",
0x2000, &(0x7f0000000f40)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, &(0x7f0000000c80)=3D{0xa0, 0x0, 0x2, {{0x3, 0x2=
, 0xffffffff, 0xfff, 0x10, 0xffff, {0x1, 0xf, 0x4, 0x1, 0x8001, 0x4, 0xb,=
 0x101, 0x2, 0x8000, 0x7, r3, 0x0, 0x7, 0x1}}, {0x0, 0x2}}}, 0x0, 0x0}) (=
async)
syz_fuse_handle_req(r1,
&(0x7f0000006400)=3D"d1847629b8b32311f0b3613f2ef7623b7e6c2f0db70d70defd2c=
87cb9eb54d5867b40ffdeb44e9ae36c7346eea76ad680d71ce9523a91485d2b97ca190944=
a023518ab9fd3055ef3a96893578d514a6e1843fd009cc02db44338089416f62c86dcee3a=
ba6aad1a8f33bcb5de95b3e39a6d3c1cf23b34c59650f9131ee357550deca14000d942917=
61d77a4be69d5fea5ecddb7d3bc24cc612200436dae9ab65002f6546a6ca09709fb58b2ac=
40bf14a7c66debc3872b9b50451192d62773640e1fc32c8d34da2b8de1903871d4a89d1c8=
33d058af658b1ed6d8396b1ae5b701eef35eaa1e26b5478a9aadcc7f8ff674a1b34b85c9a=
fe9f79e9a474541e1eda27b903af7b1605b8f0cb56ff8def50491d1a63bd3572d3d1f727f=
6a2777c52a47b2ea0785dd3b599e8b33be024ff7e530ff955152d12c8f2429713ebbfa415=
958d657078941782dff438d3c46ec7336527208e7d76e1cdace8b84e1704972c61ba6e73e=
e42abc5e126c25da7fdc366ccd34e4e25f54510f50d7411d104e20b999a238f62b5f58bd1=
6c6095c3ebff448f704b3f751b7bd8cb21d97900ef1693ddd2479df932ac5c27595c4fbe6=
3bf3dabf627ee763ac4b09425f7a1ce69aaa4e86d4fefbc9f011eb46464418c2f313ecf38=
d260038228f015675fcd1bbe1fd70e29a0a8cc39d9265536b47b148fd3afeff11e7a99e4d=
7a375c9589adef1a2d467d8c5958a435fe35228619d0ecf823014f397cb90bbba46748c8a=
ef37c4d78631749be4625417eb529cde5eb0067207b0831cbfdef67263f5e631392fae413=
ced5c9bbd6f0d69d2e08d69d00602038f2f8acf761e3595200586d54946a0b27e2837ac97=
b8352905df9d9b198d45fbf967e0279d81a6501ba3df534a2846b210be34875d4c10392eb=
f2cd4a880bb7b8f73a70bf225855f0911a426dd3753804947c489f7df4820dacb758a6cd0=
8d416102f515459e96f2d9106b9264e4d559ecc488e562a8e1e7df3fc7e2ad7f631c8e3e5=
5aa6be2f7d3c7b5055e775f6f86864bbcd91260dcc5b96733df038b84941e7dfb06577c88=
5da6887736f8e8c22989fff2e773e406856eac71220a471fb0b67b2e45b158126efb34973=
9f3733642e63f34b6c458c495e5d3551dc3600c6d75a3b4b1a06f59adc8d8bf1f74105f61=
e226a0b80660c061c7dc9e910e0027aea8870890541a090c094cca31dd252520ddb7e98d7=
ef2353a4d11d0dcd5d635f0fb9c429a69cc2a08fbfc07943d910a97a07495809ffa545ce9=
03571b336f27c5061fb88a9d8b5ed82c71573fbf6825d1101cd91883863c073efd4977eb4=
cfe87e6716753076dc016cdc383c3a17068baa21c71690488495bd400d3c93961a73b26bf=
12d60a57edf2dcedb3d9b3b2616fb62862e50c21d783a533159b21635fb316f797fc4e2dd=
cb591db40addff2a21872f1c499008929e58500e4c6f55ba800d58026e05eada9b61994a4=
12f174f2c39923cb1d02505a31235f98d8c523a574121e1194ba4781b5ab4d3223388180e=
37c9e435d7dda498002ff8d3b3404e40e51d4451a52eb3763d79134396fffa3fb15804d9d=
1b9779ed5e31ad6740ada75535d14fb41e39ac7caeda9bc01399aebc226f3727fdbee4165=
b98da6645430312482390545e966db851d035904ae2b064b262bb76f9abf531b9b9da2846=
c26bb4019aec5037b81c5d0dc4d393bd8bfe7daf1d1dfe0b3c96c6f56a5e9d50e66c61218=
2430feaabd865ffb4541ef28014b7fa5b4770231a911cb109c25c596e2df0e25d33550b92=
80e1944a5af2d374e4a8fada818edb964eb7800665ad7e6d33031b67070a37967b03f5f19=
249abcab594c45e6588893f9489f5e176529255918002efcd37fff92421e629bd103835aa=
2bc0cff824f4970c3b1dde2c36afbd169f6177a59ada0637f0087a358524f62d6e0d43bcb=
8ff5870a61048b33f808eb0597744c6fef62d057421f66ba1db77f08e946987140de3cf92=
4f04f75e211f06245fd621d897566cadef1ab84f76a4a5e638e8db97b51ff83494f061439=
1719058ebbbf30f9002b7ff7e83ebb84d6be3496cea286a426df3696fdea1a86af37cfa19=
f2b887cb364591c2fcfe9c2e5a7e0cd6b703e30a3f08c16956cf878d19461ad7b3e5e4fb8=
2f2bd8d094982c47f403e0dbb76b7dc489abfdedec1453fd1fbca1a622e88fb9cac1b7a04=
c9071ee627d6208dd10c9280f24f04c9baccab5206dc54d6346fe077317176a9ba2904f3c=
447a965d4da58d77cca55fbc5de7497e8c02257cc4652d04c9e165d8c0c2851d588902510=
a52403ebbdf0ed412ae1ccf603ee34241a66a80e8a3ab45ba5b47252497d4261c84f505e2=
9d4b9cf31c580eb03aca6fd425b8f987adf82272fe0a10383c2a3349fb2e0d76fac7c56ec=
535bb2f6bb7e022d83ed82cfc5c929d042346da6d939590ea70aef16302ceb2c65f5c1181=
abb9f47a4eee9a2430a9eb44119af9e695119b546b04ca02a9d6243df326cc62f660c617a=
77f759929ee6196a3d7ef87d9329de8ff1b3ab7768319044303341d9fa0bad70f8a5a783b=
1717fd03d4fabe7386139c49262a285d8a11aee8a484959649cbcb76be6f10458e7ac4dbf=
0a01379b4658897193e37b3806149831e4a7a5ddbae06cd9b81115afee98535840e39ba4e=
5a7dda088cda47c0b0a795c55f1f09830473c9f07e1ae8236ecf59761ba6153bdae59fb32=
046bb006edfa45f354384b7a61c27472455291ca07666fababd2a5caf2d968cab5590cb8d=
6edf74164fa683d0fa5ead0dfe9e1027ae280c9c03a77370186f49492187909aa5ff28ee5=
eaa0374f3cac7f100c9ccdc6a355835682a2cfac2a738039a63b69bfd4483d0f758a29b00=
cb25d3bbbe2edd9e88518a5af0bfec28172ac8c4af3e1788bfb966ab370a3b9e147f0312f=
63207ffc2779a02b01644e1a636114862459dc734c37689d9fbf2d6f0a24259f8474d0756=
c971e005c47a6fbbf2c5047d3e074c693dae1b41c8042da7c2f21ecc4bacb93d96ff2621c=
949628079897efd6f42d6a4f225b46c92ce1448abb02d16e8329f0a133757ec1a4c3c82ee=
f0baa694fe13efb73b59196c39d258b6ca8ae25da0ae0bf8d9cb90d25d2393f3fc7401770=
3e9f4f30ce039fec1cc32606e013e518e128c27fd28a0b0d621290a8c1cc2a0ce446d984b=
7f45f919daa957ece47731fbd1db23b0b284c6886a09bd553cadbce93478f5830fc80e42b=
3cc2ee60bbce6b4a61d8cb00b2a92adc91e32109b812ce40349a7bd323b23981b00442725=
674c424acf8a270a30d7f4ac3d05e215d1a8f8574bd40935bca48093c0405a51f25d99bf5=
22eaa1bab75505ddbcab4ec301c85402e233c6850dbec21ef319beee2eed4ab2448b5774d=
efb10338e28a6891d54fffbc71a48ec6ec9058eceaf1c486056c56bb9fa0a93a803f174a7=
2d41db738971b438ea8cd91b7d5b2eaf20f36491169ca149fcab51d7ee4c0fb96ee7e1b53=
a733cc566327974ed92abf15054772fafc397e033cb72e847cabc4bf3ab5d1eef923e7eb4=
6f6abb5249011a7257440317017ba894e50bb20dea98dc9ae97f4d601a0210067356a2ae2=
bfa12e028e594e33402f23b2bd5c772bd930678476c74a55841a23cc668f0b8cfc762c30b=
eaba8cb1c1fd5bb64b5ab4bf7544975aec5f1e23173ade8c10da5dbcf742e16abd2be132d=
af713c2362b77737dbd3dace189e5aee33231602ce46861b83af76630b0dbb0da1b87e2d1=
83cf3f34ca8064b2d0a6784548ae3fc71797dc5724bf570aa99c50277467454a51bde468f=
0e33541a23cca11a32298aa52d573fb98cdccc55043fedd4b57ebe921c1791b5bff68c744=
06dc2f7c2ab1c7d11ac8c83fda5aac9c80cd4cacb8c94f0e0a169944883f2b6c5d1a12ba3=
b79959fca8b54784ec419e048e03371f333300e7e1b78f1261cc093e556fdef5d257bce50=
32760585490f5a5841d98fadc0817c74e86b3ada213f55d3828433c13ecac1e335e399e78=
b2c8555ce1bc175c7d17652cb606f249036f79fd38a45b55015dcf85e55f412decd0b1c3b=
d5524506d97860fd58cd96ab468bbf28c2332810421a56b3356b1df87b4cd44686af33e40=
956c0fa45da43b078fff00f4b56efab940b057f43763cd6d876f55371e7b8514c47625bad=
b6451d72992f100e6708c210935bfae86e96035b1a3d32ecfc45dc4fff58b330a6e790ce8=
ea546e01112dcf9a7e3df6c351aee97b48fb821bbd39f8fc3e14e56f1e66478009b7b9466=
f5a538191399e44860d1a08231c9d30dc4ce2199903e3282b92938a252fd191efecd4eae6=
aaccb99e58aaed62f879ffa9aaefd6a1b5febe4ed67fe49cd940740c226356e0e20dabb8e=
5251ef186a63b7ff3427118ba081d74444aa1c17944ccf30df8224bf54e6d2c668944df91=
a7b1e2bc10223c7903befdd912c2d251e4bdcc69ca888a45b1039f57b4029c0c21bfd5ffd=
d7b5d8e9b9aeb38a6c20a415e9c3759bd4c226875c09e52e6b05b0b20da60c3a0648ca7ac=
4dad02935f69a0c8e4f74c92caa03599e8f20024953cc0908222a3fee8706d9b7251b778c=
40c820641e5c71c1b76110ed270d1841a93e7f6168f3e45fc9e718aaec99ccbe3e2dd501d=
0fa9bb727a039721648f00d1551c3f0fbac3ff6f5fd7c8ac77ea173dd4c436cf5a56e21f7=
0d8bd7ff4e7f7a7ba13049700ae7ef10278607ca01acceb4b35f03caab627f1732e49ec63=
f99047e171a40bf0a11344084a86462fbb9beae092b259e3194d3f19de019cf9b5d25f3fd=
4b05400361ee003f38450cef86fc79a3f609d944a78f52553d95c139edeb846fffaef89d4=
7181d700f95eb5a35d014ac44f5dd3b29bfbbebbc82a13ae00fc2efc0d65f8b4611268e86=
f781991c260ad83bf7c3f62216ffa71f6ed6b99e345131705fd4564e418da75b26343b678=
e087c8e3d30326d59443a3c44d51e96c461874fd0980366c882b1a7eb31d8851732b88ad5=
501488ef65482b8ee7c37142b3919fbcba2247e219834eefb734ba893c255f2af9bebcd35=
2efe6ea20cad9bcb00f393fb1d2f46e7aaa3d32be901c0d1fc181415c4c048fd3ef94bb21=
b898615e6cd41ad7693b25616589d5852ab79a9ffaac813564422a48d969f1c4349c3bef7=
7dd38ea6d522e6430d062d2f9d40077f1166a030e511059ac0ad12a969d5d2c0143f1a387=
4111abb2412282293737b918763f711fd3b6273d4acb243dac25e97f0ffbf411623b4a5c6=
c93c7e5e5fc26563b90073e0d6ad17a7459bde92e6a1f24545a2384f945de8fe30f4c68e5=
cc59707d4c2570fed7e6e9b8941bb07b904eca978b9c2e0a23312ef4eaf85f8bb76977711=
24533d729ee090eb0d160438bc8e4c631e28b1bd0badf0d065f10f868dcbf1fef31834ef1=
e57221dd0fba7d0e56462e815538ac44da2ba70c0698571a85d174589c2394accf8b98653=
fd6d1c54c9e23ea3440accd77eb9a8155ed76d68f336ea515722062c69ad79f1d7538ccec=
63eba72d755b3828c463306f66a7798832e4d3dd598f4a3bf007cfb151734fa1a73a8774e=
bfd6137e0b4d5d3d76552118b040d9c060758438f5108611c2db64fd35935498254133bcf=
a2adc6ddfb5b2f15a4ae2c89e554d82b753c2f250ad8f9725c7b93692d0eaa0ac0804844e=
5a70e162e2d9eca134b9b1c25a5483a54693b591f76ea6d891b47f57ea3ef51808f3d93bf=
74c6c6edc60eedb19524d86e4ea6294ed09d8c45feb874008f4aed864d6404dc892704a21=
a78da4ee3bffd444a9a4c1ef34580c5db99419856187648868ae4845fb4c391f17f16707d=
2b9c5cb8a1d4a10c5b03eb165e7676c93dc5ee047ed77474ffbc301115a27a8144c7302a6=
82eef28c75c5539e514898ed3d8ff75f24b8ee466ea49ad280eaf84fb49225888c17296a6=
d2c709f57822c660ce5f921123e897d4797ad151cb9bd58d6c38c3bfe6a5db76d72b68bec=
d64d63319b6cdb1fb548f9a8cad9ceca4c167e26219ebd20c4d8e1c7fb74984a98e483503=
2581ca10dc6089e57987bbb4dbeb17e6a211a85107d2b5dfdbbffedd3ea8ce80720e82b19=
89096bd23b05992c0a3e09b766a0e4c8fb486290238237b80787b09d495a5e1b9550fabf6=
17792ccdbe797857a572b85eff0d214a80aa5be99b4ca4ca9ebb189944644357abc451d5b=
407940797512270208dbfe6c320740168dcb654c53012e7e740322dd91f6c2647298050b7=
e8440857ff1a8deaf123a8da923d2f0cea871d21ab154e3aac07f1994851e755bc21cde31=
d132f23d9d01bb51d5364a72afd190eb93a7e96948ddd619d3294ac31340e1cd78046f1bd=
ec4cf1c30442c7f62d8bba4e973af102956c824b6be5a2309ca38205f5c5d66150d431cd8=
9dca11db7df2be7abcaf3398c78409aa852c7290497514b8746b1676f89afc27d38b39dad=
5ea4d8bc371f4e4fe59fc4fb37c1e2dce7e213ead05f80fb408780dcf6a57fb3fbbc3d6b7=
edb6398b7b09d85e2ce07015d4dbf3cbaa02139ad16025f1f65bba1e5fcc9216de59ccf01=
32d6a00e05f7da8e84b2ed5f9fa143f4c4068824442b119737e77b85f5b1d10926404b05f=
aef7ee385738531e54d20fc7134afcdb4bbc5ce305ba13506c4400668d8d787ca59097b63=
a270f1e77c455e0a1091d87139408082a7af05ae3a494d4652790c057ccc097512a450dc0=
d0b571b278c361283a6a90dd908925c94386d91b8f32eabf6e6555217a3d11f068c24405b=
4ae1d8eebe81096d4ea3eee410d5d07aefe26563904d86feaeb5bf6c5c53d90ef93b64eb1=
19c6bcac559987c0345171bfb40f7994289d57c0425f6ecb32519b97ac8e8bc366b816fc1=
87bd03416222ea9ac7c9b2cd41173cf4b50384f2e0ecb3c307acdee361e73238c37555fd2=
5c5fca471c8b7c2739bdba5e06bc3db77cfb348af90b6906b2542d69eb83162e6d5607cf2=
3391bac51d60e9b3a8703249853015e0aadca8d4f2306a9daa121bdf76e98c55406d19c5d=
b51a621df62aedc530da27643e2f34ddfa7f91bb53851f9659e17292994a9610e418d7225=
223bb229fda63e3c1863b349a73f7d70493452809b77431f578bfda82867f2837f3d1200c=
ee80019331408006765de7d27f8256d9242a09df9bca29e1c9c727cbe00c6f223df970d62=
7c9e06c07c454a4c4abef00ba2a66c99f92e73eb10b71684c9f4081b5dc3372524fdd76db=
6f6288b593571849e1df8855fb971773497e90ed8722facc63be58092f929c306e8ef8ffd=
327a95068a30b17535ac6f79ea2ae5dface84235580e7615674c5713c42fbaa87b3ccaeb0=
a916d9d737e1013351eb471e967b2562272e68c760288dec5174127e2e70a12e3e8ab3af6=
932fea0abee4bf32e2d609f210e153168ffdbe8bbeaf63e1b2f31ba76e1e717800cd0698b=
cf92d1600edc35c543a2be0498ac78223f62c61f27502a02dbafce827cfd924cb9146a587=
30692cfee526bc59495d6db7c485a5ebd756b25a22ae77aa70594c5ac3850235ff6ab4d9d=
d7a3e494d214bacc60b46186c2fe413d96cf1b1ab10595255a465e57c42b52a124206087c=
7e6c4c4ef25aadfb4a09ba1e7a77147a3ed6fcb4b09990bc65770cb7076927c01b227cfae=
4a8ed1f8e2b9f75ce18f7d878c5544be2d64074d06a75424de0ff72c812662e2af6c7e383=
2df151ffebe3507d09b1e2e0c134b693d3c7c8d81fe24097d138601693d4027920d43f28a=
4b2f73ee1490a221495aa12bfc2cc0d2129ccf36060bc09852e8747d1a9d354eef234dd29=
4f99263295fba3ac5eff8a96bad66bbfca1fdf02767ce0f6ee0eff4841323e70f25640b19=
10856ac7dd68eee19916c8336e670bd8e1385a99918aa010dff6b3cd065a0d8b38d4e9a94=
4e708e1fa38c0e85acbdeaa14d289348833f8980d7c0476ee7783544bfab6cfd778db599f=
02880a386a724005dbf620db610ea2e6f6e02eb8961f22995fc633cce267adf7a59bcfdf4=
da1d2cd35c0371c859a586c33297e17cc0d6ccccb79b8e1b14d5d8741dc2129e09d3e2e31=
b3d046f70c1cc0f2adf963022331225a7bb52164fd6589a46a5950a185246d3d48c592781=
4a9717d780df10d2463f9a3e5fa067385167b9df2d71463c9daa9b3443713701b990a2b61=
e453f68f1c864df5647be3aa14605f90ce4f81462fd80063419fc7209a6ce0b89733c0947=
b4cc9f52dc7b8502d120f855b11a3827bca4ec3e58b7cd211e049c2b67f61852939705968=
bed2e39fecb8b2aeb334753cccf35bcb806c6705b263c4907b3c2bdd864aa7dce74648813=
4759e43d9a496bab4660d826f95fb4857215f312ea2b2e556a89be47337269348cdd25c67=
12f4cca7f485686ea46d0eb38c7b37f82f7101d968736e0ec06a3f3a80edf5eedc3d942fb=
b1cb75fa0dc580e9cd6f17b603ef4f2498454f4676793d4b7c762e898bcf2f5c2e61d9cc8=
d64519770435a46a4a90eac4ae0436090a80bb23a537bc4b9c066cec6ddd46f7f3029e07e=
3479541d7d127b05aa85be18002c59b41d4c6f3630d54c91d1a747aa1ef1c30faaeec4b94=
9199154cdfcf21b55493e9f43e98ad0dd492eed7491041f38f910024160d32fcdd1cf63ae=
0a65d9f6ee1164fce7717c47d9da69ae69dfdb206edcf5dac41266dc4e6f7b94bb429c814=
6c6e50668e7b53839b85b998ccdbda5bb51b74c3a7e4cda7301f3ddafb4e87945f1f64bda=
82a7ba42db1323d7f1357f68a0c8ad8b664ae2da1919dca4f679657477464c5f3d6d995e4=
52ad0b92075867ab3ef7cc7d6230798ed67af4202afa7b6a96a71f6bfdb044c0f86a6fb60=
31a5e8ac4d67ff8f7cb4652bc06b30ff476cdeaa536d383463d07c6bafbca89d06166c3d4=
a1bcf3b9a858d1d6a54f8e84458a446a291d28327ff612db80a19f680e50f57384b4d6ea3=
48557d07e4e7f71d02b83869a5b50716001cee1dadf47e3db26c20bf7e54bcd00f77878d8=
ddbca5687f1d93d73889d70da690613d4e60b1f6a99a430a93c4f6344acb830b16da48122=
2667e8d9d2d875635d55a495902e4b434f52505943712f6a05d90a371411d08fc5b3a7686=
772a6097e603f4c947dd6067de11c5e42f3d43a5148719e10062b334bf4cab4e1d3ba17b1=
0fd5d2e26b67d58bb1c04eff22fa45fe09c2f8441ea889ced3972d171041ce4ef8c68ea8a=
1b73419cb9d7c5b21ee316ed6cecdd96dc96631c6d213d92edb4734ad81465576d032a4a5=
5ed3f03045816703a290a8af40f9bf7b1da8089215dd813fe8e04e06aec54272b6ba48d67=
27723fa7208508f6fbe318ccd66d4d93ed2a584dee0b1745b6e99287cc4eb5ab025ad66ce=
610e85274865a7733a420d7d36de3e6462fd5bfa7f67700db7c8a51a82556fb09993ff0b4=
cc34ec17c19727f38903e8ad8f817c272e53612d79e8c218ff4b122a087ac839581ee953a=
e3134e7899f24d9c3c3349c99fc7f4083c974078d8e20f4ab16e74c418e1de03cfbe3bae1=
5bbf7da7eec27990f41ce8ec747b008872da491157fecae9c71b82836b55a34fd59a24ec5=
01c363db8520d2ab64ebb5cf42d67643911bfd26101777fe02db300c82f9a5bf0eed3206f=
a745e7a2311b6604e8a263dcfdc45aaebf2be105dc9a3c691d45bb01e36baadaef8e47e2c=
9aadcbe9ee2ae2fead646eace3ac7924dabe86aaa06e688234586a7ef3cdf6508ea3fd65e=
f0ee0f8e13919ed96b4f94f2a2c915c2377ff159c9386afc24276dd920b5449925d4b41b3=
9fc60902e03aefa57cb00d79ca8f14e51ba3fc9a0febbcbad5b5982271cf161a7bab4fdcc=
7deb48d3e7d125f171ec55ff0b5416de9f7b323c6002780286792ba3ba3dd3b7da5ad71aa=
7eecb7f555d1d80d69488b1a533203e767456c647fff0e4d01f81aa1673cab0d5e2bc234b=
f61c23b00eccafb9a6520600d0891b6609690891683ee8745516d69150f8e6bf4199798df=
436e5a6bd33d2d787d210aabeb423826d1ae5531343ac2c636216d91a4a467f66a3af2e00=
ba3c8ac8989187a59a8048e45db0ff4bffae9a6927796cc9a33c7300b293fce6755499554=
787adb31e8651f3d91ccfcd297c3517fac4585b12b85df78c186e43ed0923033edcb273f0=
f5b0fa357cbd58bbb134a3c29e063f907f6117cc34ab6ad66c8762215ca59ffd216a77063=
6ee82a8e605a9478d3e62a84b4a42713c7218eda3aa54c736e9c450dc497287baff675ea0=
10465897d83621121abb1940323bf30c6192f854af5611d9b5c2ac5a58cd36b9325f11e65=
7c4272f48414d0b82d89cca0be80cb4ae142f6442a9527ad0ee8deba525aa5cdeaaa60305=
10b8b2a1e85c9464c255940d968deb07abd463e18a68252e86f58a0f7d284527af45f769d=
e13dc1f06ac736ec7e5340d9ae9370a83a3fa1214fd84f1a3dbc848aaf178774df75ca2b7=
c09ba28e79759d747832841aa9861cb8efa3788c863ef5f949b0bf00d88f811dba5e91461=
f7d571d236d2e4aee29723048f9ee95dfabc090788d5f7703887fc38670cde115e75a3f42=
93d6e916ced7316917e4c8d583d949b3e59bf77ce8cc549a359ccc7649ea23adb0c164cbb=
6b97c8c4728338d993735a6bf18d89803e4b97c3d4bf3701d72bad91cff3c83ce0d493f91=
45fdb7cc098f63ab06247a8212b4862ee7b97bd1e4460dbaf6dbac749b21e97ea0f4033ab=
85977f1f6131afdfe1d3830c5fa4e5030d8d8930d890304832031baf11b17647f906d79a7=
11c8ee99855d4d7a00620864b9495c7b248ef9bedb29e8797afb9532da3a92dd6c99b4ca9=
b20539e5abc7d30778365cd8e1498bd9b9e7fed4c080769c45a2effc7ed811deed99a522c=
a018ac00eeacc402ad04e2e3348378eb9c9ed40abc416dd88768f21ad1d09f792628902e5=
177c95f259de1a73cf34a612d88f81cc33f8a5c3da0142eb906caf35f3787a26683a2b573=
a1f0b728f290bf74d441663c1c04be7deeb9e8493ebb29294e836cb25417d499cca7b7478=
26cec62d1254eff8487c5a91b203e95d531431f12431fb6522dbf0a702b5a41b4919004b6=
1455728fd3e47f56c96268c34301d05cad4014776944b33b4446b51076e71c691b4a190ac=
f008574977b74e10102f4dd272beab646ddcb0b4dab6bb511a12faa59a1b4dc3507fe8ad1=
bb8fd80c98df3e3e95551b816b583eda74f80efe345db19df93a355e2a22896b033fac066=
b370fa34e383ba957ed1c181378d9178a71d7b7e208487ae7decc0b9f56935b5e1faa29cd=
31c6d511c2997def9fd3747b416ec38196c8b5c0bbc845b242ef71c3e6bb0d704f475a33d=
25a6903c2319351324530c15325848b44f4cfbb05ca48a02cdbe164d35a66e2d7e02ef2d2=
37d49ad4f9defbea01db1b5d19802e28056382d3cd0077e2c67dae84704c99468a9e06c6f=
86c06f55249aa97c6d4c59fee7117e9fee9c21643e4af9b38c345a990f6c09b079243ff3d=
5ff14897e4b0740103e7049f13f467184742de82bdd71ccadeb8defe5c8ac6f0dac16fedc=
fc3da536e8d7313f0576cbbb7e18c89bccb3a30cc1fd39797b6874b2e9c69465c12a5be09=
4c949e8a668c47be512ea5a99cbe20c71dcfb6a000c7ef5d72467",
0x2000, &(0x7f0000000f40)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, &(0x7f0000000c80)=3D{0xa0, 0x0, 0x2, {{0x3, 0x2=
, 0xffffffff, 0xfff, 0x10, 0xffff, {0x1, 0xf, 0x4, 0x1, 0x8001, 0x4, 0xb,=
 0x101, 0x2, 0x8000, 0x7, r3, 0x0, 0x7, 0x1}}, {0x0, 0x2}}}, 0x0, 0x0})
r5 =3D syz_create_resource$binfmt(&(0x7f0000000200)=3D'./file0/file0\x00'=
)
r6 =3D openat$binfmt(0xffffffffffffff9c, r5, 0x42, 0x1ff)
flock(r6, 0x5) (async)
flock(r6, 0x5)
close(0x3)
close(0x4)
sendmsg$nl_route(r0, &(0x7f0000000140)=3D{0x0, 0x0, &(0x7f0000000000)=3D{=
&(0x7f00000000c0)=3DANY=3D[@ANYBLOB=3D"20000000760025cc6a718c2df79d8c2507=
000000", @ANYRES32=3D0x0, @ANYBLOB=3D"08000100"], 0x20}}, 0x20000040)
bpf$PROG_LOAD(0x5, &(0x7f0000000180)=3D{0x13, 0x4, &(0x7f0000000480)=3DAN=
Y=3D[@ANYBLOB=3D"180000000600000000000000e30f0000937e24bc85679d00ffff0000=
000095000000000000002dc75549714e76fffca71b88752b0277b755f13d9c06ca4abf2bf=
59d8fe1ed649f1debbc4935cd3efac42b61413a2e11dc1cf14d67c6a47bdf7d47a623239d=
ae7b16e010567afe83852bea396a5d54bcfc82a7845a0e74f1b3cb73f89090a5b687333da=
e8f8afc42dc226a51b04867f69cd88c7b7bee892dfebfe35064bb24db341353de11de1c06=
e9cbd141bf97d8b317f1c1b5c58e8dcc9de205dd0d8b226db1b8f034c1545a1a99ad1ead9=
af0de4ff0fd625e5194a56444026c08395a7e893d40c9ec7b64b7429caddafcd6a9"], &(=
0x7f0000000000)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x2, '\x00', 0x0, @fallb=
ack=3D0x12, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0=
x0, 0x0, 0x0, 0x0, 0x3ff}, 0x94) (async)
bpf$PROG_LOAD(0x5, &(0x7f0000000180)=3D{0x13, 0x4, &(0x7f0000000480)=3DAN=
Y=3D[@ANYBLOB=3D"180000000600000000000000e30f0000937e24bc85679d00ffff0000=
000095000000000000002dc75549714e76fffca71b88752b0277b755f13d9c06ca4abf2bf=
59d8fe1ed649f1debbc4935cd3efac42b61413a2e11dc1cf14d67c6a47bdf7d47a623239d=
ae7b16e010567afe83852bea396a5d54bcfc82a7845a0e74f1b3cb73f89090a5b687333da=
e8f8afc42dc226a51b04867f69cd88c7b7bee892dfebfe35064bb24db341353de11de1c06=
e9cbd141bf97d8b317f1c1b5c58e8dcc9de205dd0d8b226db1b8f034c1545a1a99ad1ead9=
af0de4ff0fd625e5194a56444026c08395a7e893d40c9ec7b64b7429caddafcd6a9"], &(=
0x7f0000000000)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x2, '\x00', 0x0, @fallb=
ack=3D0x12, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0=
x0, 0x0, 0x0, 0x0, 0x3ff}, 0x94)
openat$rdma_cm(0xffffffffffffff9c, &(0x7f00000003c0), 0x2, 0x0) (async)
r7 =3D openat$rdma_cm(0xffffffffffffff9c, &(0x7f00000003c0), 0x2, 0x0)
write$RDMA_USER_CM_CMD_CREATE_ID(r7, &(0x7f00000027c0)=3D{0x0, 0x18, 0xfa=
00, {0x3, &(0x7f0000002780), 0x13f, 0x8}}, 0x20) (async)
write$RDMA_USER_CM_CMD_CREATE_ID(r7, &(0x7f00000027c0)=3D{0x0, 0x18, 0xfa=
00, {0x3, &(0x7f0000002780)=3D{<r8=3D>0xffffffffffffffff}, 0x13f, 0x8}}, =
0x20)
write$RDMA_USER_CM_CMD_BIND(r7, &(0x7f0000002a40)=3D{0x14, 0x88, 0xfa00, =
{r8, 0x10, 0x0, @in=3D{0x2, 0x4e21, @loopback}}}, 0x90)
r9 =3D socket$nl_generic(0x10, 0x3, 0x10)
bind$inet6(0xffffffffffffffff, &(0x7f0000000180)=3D{0xa, 0x4e21, 0x7, @ra=
nd_addr=3D' \x01\x00', 0xc}, 0x1c) (async)
bind$inet6(0xffffffffffffffff, &(0x7f0000000180)=3D{0xa, 0x4e21, 0x7, @ra=
nd_addr=3D' \x01\x00', 0xc}, 0x1c)
sendmmsg$alg(0xffffffffffffffff, &(0x7f0000000040)=3D[{0x0, 0x0, 0x0, 0x0=
, &(0x7f0000000180), 0x0, 0x10}], 0x1, 0x0)
sendmsg$IPSET_CMD_CREATE(0xffffffffffffffff, &(0x7f0000000140)=3D{0x0, 0x=
0, &(0x7f0000000100)=3D{&(0x7f0000000040)=3D{0x1c, 0x2, 0x6, 0x101, 0x0, =
0x0, {0x1, 0x0, 0x12}, [@IPSET_ATTR_FAMILY=3D{0x5, 0x5, 0xa}]}, 0x1c}, 0x=
1, 0x0, 0x0, 0x24000001}, 0x50)
mknodat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x21c0, 0x=
103)
mount$nfs4(0x0, &(0x7f00000000c0)=3D'./file0\x00', &(0x7f0000000100), 0x2=
800008, &(0x7f0000000000)=3DANY=3D[@ANYBLOB=3D"01"])
r10 =3D syz_genetlink_get_family_id$tipc(&(0x7f0000000100), 0xfffffffffff=
fffff)
sendmsg$TIPC_CMD_SET_LINK_WINDOW(r9, &(0x7f0000000300)=3D{&(0x7f000000004=
0)=3D{0x10, 0x0, 0x0, 0x20000000}, 0xc, &(0x7f00000002c0)=3D{&(0x7f000000=
0240)=3D{0x68, r10, 0x400, 0x70bd2c, 0x25dfdbfd, {{}, {}, {0x4c, 0x18, {0=
x81, @media=3D'eth\x00'}}}, [""]}, 0x68}, 0x1, 0x0, 0x0, 0xc000}, 0x40800=
)

3.35350611s ago: executing program 8 (id=3D13522):
r0 =3D openat$sysfs(0xffffffffffffff9c, &(0x7f0000000000)=3D'/sys/power/r=
eserved_size', 0x202, 0x130)
r1 =3D syz_create_resource$binfmt(&(0x7f0000000200)=3D'./file0\x00')
madvise(&(0x7f0000ffd000/0x3000)=3Dnil, 0x3000, 0x64)
move_pages(0x0, 0x1, &(0x7f0000000140)=3D[&(0x7f0000ffd000/0x3000)=3Dnil]=
, &(0x7f0000000180), &(0x7f0000000200), 0x0)
openat$binfmt(0xffffffffffffff9c, r1, 0x42, 0x1ff)
r2 =3D socket$nl_route(0x10, 0x3, 0x0)
r3 =3D socket$igmp(0x2, 0x3, 0x2)
ioctl$sock_SIOCGIFINDEX(r3, 0x8933, &(0x7f0000000440)=3D{'veth0_to_bridge=
\x00', <r4=3D>0x0})
sendmsg$nl_route(r2, &(0x7f0000000040)=3D{0x0, 0x0, &(0x7f00000000c0)=3D{=
&(0x7f00000001c0)=3D@newlink=3D{0x4c, 0x10, 0x711, 0x70bd26, 0x25dfdbfc, =
{0x0, 0x0, 0x0, 0x0, 0x750e5, 0x70200}, [@IFLA_LINKINFO=3D{0x24, 0x12, 0x=
0, 0x1, @macvlan=3D{{0xc}, {0x14, 0x2, 0x0, 0x1, [@IFLA_MACVLAN_MACADDR_M=
ODE=3D{0x8, 0x3, 0x2}, @IFLA_MACVLAN_FLAGS=3D{0x6, 0x2, 0x1}]}}}, @IFLA_L=
INK=3D{0x8, 0x5, r4}]}, 0x4c}, 0x1, 0x0, 0x0, 0xfe05cad2d9aaa8cb}, 0x2004=
e800)
mount$bind(&(0x7f0000000100)=3D'./file0\x00', &(0x7f0000000180)=3D'./file=
0\x00', 0x0, 0x2010d1, 0x0)
unlinkat(0xffffffffffffff9c, &(0x7f00000003c0)=3D'./file0\x00', 0x0)
read$FUSE(r0, &(0x7f00000000c0)=3D{0x2020}, 0x2020)
r5 =3D socket$inet6_icmp_raw(0xa, 0x3, 0x3a)
socket$inet6_tcp(0xa, 0x1, 0x0)
syz_open_procfs$pagemap(0xffffffffffffffff, &(0x7f00000000c0))
seccomp$SECCOMP_SET_MODE_FILTER_LISTENER(0x1, 0xa, &(0x7f0000000340)=3D{0=
x1, &(0x7f0000000040)=3D[{0x6, 0x8, 0xd, 0xb40c}]})
ioctl$TUNGETVNETBE(0xffffffffffffffff, 0x800454df, 0x0)
syz_open_procfs(0xffffffffffffffff, &(0x7f0000000000)=3D'fd/4\x00')
socket$inet6(0xa, 0x2, 0x0)
r6 =3D socket$inet6_icmp_raw(0xa, 0x3, 0x3a)
sendmsg$NFQNL_MSG_VERDICT(r0, &(0x7f0000002280)=3D{&(0x7f0000002100)=3D{0=
x10, 0x0, 0x0, 0x200}, 0xc, &(0x7f0000002240)=3D{&(0x7f00000022c0)=3D{0x2=
f8, 0x1, 0x3, 0x801, 0x0, 0x0, {0x1, 0x0, 0x8}, [@NFQA_PAYLOAD=3D{0x52, 0=
xa, "088fbfb3ac98a5866a232334441ffcf651bd65f162e06b287121cda68dbe00191c90=
9eb017f013a48cc91cef099b9011122c3964a79db7e931792864892c4aaec87a76a31228a=
e3fe4a889f9b1cb"}, @NFQA_EXP=3D{0x1d0, 0xf, 0x0, 0x1, [@CTA_EXPECT_TIMEOU=
T=3D{0x8, 0x4, 0x1, 0x0, 0x9}, @CTA_EXPECT_MASK=3D{0x54, 0x3, 0x0, 0x1, [=
@CTA_TUPLE_PROTO=3D{0xc, 0x2, 0x0, 0x1, {0x5, 0x1, 0x88}}, @CTA_TUPLE_PRO=
TO=3D{0xc, 0x2, 0x0, 0x1, {0x5, 0x1, 0x198713e513ee1046}}, @CTA_TUPLE_ZON=
E=3D{0x6, 0x3, 0x1, 0x0, 0x2}, @CTA_TUPLE_IP=3D{0x14, 0x1, 0x0, 0x1, @ipv=
4=3D{{0x8, 0x1, @broadcast}, {0x8, 0x2, @dev=3D{0xac, 0x14, 0x14, 0x1b}}}=
}, @CTA_TUPLE_PROTO=3D{0xc, 0x2, 0x0, 0x1, {0x5, 0x1, 0x21}}, @CTA_TUPLE_=
ZONE=3D{0x6}, @CTA_TUPLE_ZONE=3D{0x6}]}, @CTA_EXPECT_HELP_NAME=3D{0xe, 0x=
6, 'sip-20000\x00'}, @CTA_EXPECT_MASTER=3D{0x58, 0x1, 0x0, 0x1, [@CTA_TUP=
LE_IP=3D{0x14, 0x1, 0x0, 0x1, @ipv4=3D{{0x8, 0x1, @multicast1}, {0x8, 0x2=
, @dev=3D{0xac, 0x14, 0x14, 0x29}}}}, @CTA_TUPLE_IP=3D{0x14, 0x1, 0x0, 0x=
1, @ipv4=3D{{0x8, 0x1, @initdev=3D{0xac, 0x1e, 0x0, 0x0}}, {0x8, 0x2, @ra=
nd_addr=3D0x64010101}}}, @CTA_TUPLE_PROTO=3D{0xc, 0x2, 0x0, 0x1, {0x5, 0x=
1, 0x84}}, @CTA_TUPLE_ZONE=3D{0x6, 0x3, 0x1, 0x0, 0x1}, @CTA_TUPLE_PROTO=3D=
{0xc, 0x2, 0x0, 0x1, {0x5, 0x1, 0x84}}, @CTA_TUPLE_PROTO=3D{0xc, 0x2, 0x0=
, 0x1, {0x5, 0x1, 0x2f}}]}, @CTA_EXPECT_MASTER=3D{0x9c, 0x1, 0x0, 0x1, [@=
CTA_TUPLE_PROTO=3D{0xc, 0x2, 0x0, 0x1, {0x5, 0x1, 0x84}}, @CTA_TUPLE_PROT=
O=3D{0xc, 0x2, 0x0, 0x1, {0x5, 0x1, 0x2f}}, @CTA_TUPLE_IP=3D{0x14, 0x1, 0=
x0, 0x1, @ipv4=3D{{0x8, 0x1, @multicast1}, {0x8, 0x2, @rand_addr=3D0x6401=
0101}}}, @CTA_TUPLE_IP=3D{0x2c, 0x1, 0x0, 0x1, @ipv6=3D{{0x14, 0x3, @loop=
back}, {0x14, 0x4, @empty}}}, @CTA_TUPLE_IP=3D{0x2c, 0x1, 0x0, 0x1, @ipv6=
=3D{{0x14, 0x3, @private1}, {0x14, 0x4, @mcast2}}}, @CTA_TUPLE_PROTO=3D{0=
xc, 0x2, 0x0, 0x1, {0x5, 0x1, 0x1}}, @CTA_TUPLE_ZONE=3D{0x6, 0x3, 0x1, 0x=
0, 0x2}]}, @CTA_EXPECT_HELP_NAME=3D{0xf, 0x6, 'netbios-ns\x00'}, @CTA_EXP=
ECT_MASTER=3D{0x5c, 0x1, 0x0, 0x1, [@CTA_TUPLE_PROTO=3D{0xc, 0x2, 0x0, 0x=
1, {0x5, 0x1, 0x84}}, @CTA_TUPLE_IP=3D{0x14, 0x1, 0x0, 0x1, @ipv4=3D{{0x8=
, 0x1, @broadcast}, {0x8, 0x2, @remote}}}, @CTA_TUPLE_IP=3D{0x2c, 0x1, 0x=
0, 0x1, @ipv6=3D{{0x14, 0x3, @initdev=3D{0xfe, 0x88, '\x00', 0x1, 0x0}}, =
{0x14, 0x4, @mcast2}}}, @CTA_TUPLE_PROTO=3D{0xc, 0x2, 0x0, 0x1, {0x5, 0x1=
, 0x3a}}]}]}, @NFQA_VLAN=3D{0x24, 0x13, 0x0, 0x1, [@NFQA_VLAN_TCI=3D{0x6,=
 0x2, 0x1, 0x0, 0xa}, @NFQA_VLAN_TCI=3D{0x6, 0x2, 0x1, 0x0, 0x5cb}, @NFQA=
_VLAN_TCI=3D{0x6, 0x2, 0x1, 0x0, 0x9}, @NFQA_VLAN_PROTO=3D{0x6, 0x1, 0x1,=
 0x0, 0x88a8}]}, @NFQA_VERDICT_HDR=3D{0xc, 0x2, {0xfffffffffffffffb, 0x3}=
}, @NFQA_MARK=3D{0x8, 0x3, 0x1, 0x0, 0x1}, @NFQA_VLAN=3D{0x3c, 0x13, 0x0,=
 0x1, [@NFQA_VLAN_TCI=3D{0x6, 0x2, 0x1, 0x0, 0xffff}, @NFQA_VLAN_TCI=3D{0=
x6, 0x2, 0x1, 0x0, 0x5}, @NFQA_VLAN_TCI=3D{0x6, 0x2, 0x1, 0x0, 0x1}, @NFQ=
A_VLAN_PROTO=3D{0x6, 0x1, 0x1, 0x0, 0x8100}, @NFQA_VLAN_TCI=3D{0x6}, @NFQ=
A_VLAN_PROTO=3D{0x6, 0x1, 0x1, 0x0, 0x88a8}, @NFQA_VLAN_TCI=3D{0x6, 0x2, =
0x1, 0x0, 0x5}]}, @NFQA_CT=3D{0x4c, 0xb, 0x0, 0x1, [@CTA_NAT_SRC=3D{0x40,=
 0x6, 0x0, 0x1, [@CTA_NAT_PROTO=3D{0x3c, 0x3, 0x0, 0x1, [@CTA_PROTONAT_PO=
RT_MIN=3D{0x6, 0x1, 0x4e22}, @CTA_PROTONAT_PORT_MIN=3D{0x6, 0x1, 0x4e24},=
 @CTA_PROTONAT_PORT_MAX=3D{0x6, 0x2, 0x4e22}, @CTA_PROTONAT_PORT_MIN=3D{0=
x6, 0x1, 0x4e21}, @CTA_PROTONAT_PORT_MIN=3D{0x6, 0x1, 0x4e23}, @CTA_PROTO=
NAT_PORT_MIN=3D{0x6, 0x1, 0x4e22}, @CTA_PROTONAT_PORT_MIN=3D{0x6, 0x1, 0x=
4e20}]}]}, @CTA_STATUS_MASK=3D{0x8, 0x1a, 0x1, 0x0, 0xaae3}]}]}, 0x2f8}, =
0x1, 0x0, 0x0, 0x8000}, 0x4000000)
setsockopt$inet6_int(r6, 0x29, 0xc8, &(0x7f0000000fc0)=3D0xbbc4, 0x4)
ioctl$sock_SIOCGIFINDEX(0xffffffffffffffff, 0x8933, &(0x7f00000000c0)=3D{=
'veth1_to_batadv\x00', <r7=3D>0x0})
sendmsg$nl_route(0xffffffffffffffff, &(0x7f00000002c0)=3D{0x0, 0x0, &(0x7=
f0000001580)=3D{&(0x7f0000000280)=3D@setlink=3D{0x20, 0x13, 0x1, 0x70bd29=
, 0x25dfdbff, {0x0, 0x0, 0x0, r7, 0x41021}}, 0x20}, 0x1, 0x0, 0x0, 0x200c=
8191}, 0x240080c4)
r8 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
sendmsg$NFT_BATCH(r8, &(0x7f0000005380)=3D{0x0, 0x0, 0x0, 0x1, 0x0, 0x0, =
0x20000000}, 0x18)
sendmmsg$inet6(0xffffffffffffffff, &(0x7f00000033c0)=3D[{{0x0, 0x0, 0x0}}=
], 0x1, 0x10)
read(0xffffffffffffffff, &(0x7f0000000340)=3D""/174, 0xae)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0x2000005, 0x4c832, 0xff=
ffffffffffffff, 0x0)
recvfrom$inet6(r5, &(0x7f0000000080)=3D""/178, 0xb2, 0x40008062, &(0x7f00=
00000140)=3D{0xa, 0x4e23, 0x1, @rand_addr=3D' \x01\x00\x00\x00\x00\x00\x0=
0\x00\x00\x00\x00\x00\x00\x00\x02', 0x241294d1}, 0x1c)

3.30238383s ago: executing program 5 (id=3D13525):
r0 =3D socket$inet6_udp(0xa, 0x2, 0x0)
getsockopt$inet6_IPV6_FLOWLABEL_MGR(r0, 0x29, 0x20, &(0x7f0000000280)=3D{=
@private2, 0x7fffffff, 0x0, 0x1, 0xa, 0x5, 0x2}, &(0x7f00000002c0)=3D0x20=
)
socket$nl_route(0x10, 0x3, 0x0)
r1 =3D openat$procfs(0xffffffffffffff9c, &(0x7f00000009c0)=3D'/proc/asoun=
d/seq/clients\x00', 0x0, 0x0)
pipe2(&(0x7f0000001240)=3D{<r2=3D>0xffffffffffffffff}, 0x90000)
close_range(r1, r1, 0x2)
splice(r2, 0x0, r1, 0x0, 0x9, 0xf)
getpeername$packet(0xffffffffffffffff, &(0x7f0000000100)=3D{0x11, 0x0, 0x=
0, 0x1, 0x0, 0x6, @remote}, &(0x7f0000000140)=3D0x14)
bpf$BPF_BTF_LOAD(0x12, &(0x7f00000001c0)=3D{&(0x7f0000000200)=3DANY=3D[@A=
NYBLOB=3D"9feb01001800000000000000600000006000000006000000100000000000000=
a031a00000900000032000000020000000600000005000013048100000000000009000000=
e90000000200000007000100040000000a00000008000000080000000c000000050000000=
700000008000000303000"], &(0x7f0000000400)=3D""/84, 0xfffffe3c, 0x54, 0x1=
, 0x200}, 0x28)
bpf$BPF_BTF_GET_NEXT_ID(0x17, &(0x7f00000003c0)=3D{0x5, <r3=3D>0x0}, 0x8)=

bpf$PROG_LOAD(0x5, &(0x7f00000007c0)=3D{0x19, 0x3, &(0x7f0000000480)=3DAN=
Y=3D[@ANYBLOB=3D"1800"/24], &(0x7f0000000500)=3D'GPL\x00', 0x0, 0x0, 0x0,=
 0x0, 0x0, '\x00', 0x0, @cgroup_sockopt=3D0x16, 0xffffffffffffffff, 0x0, =
0x0, 0x0, 0x0, 0x0, 0x0, r3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1}, 0x94)
r4 =3D openat$ptmx(0xffffffffffffff9c, &(0x7f0000000000), 0x40082, 0x0)
r5 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000000240), 0x2, 0x0)
r6 =3D dup3(r4, r5, 0x80000)
r7 =3D syz_open_dev$sg(&(0x7f0000000140), 0xffffffffffffffff, 0x204c1)
mkdirat(0xffffffffffffff9c, &(0x7f0000002000)=3D'./file0\x00', 0x0)
r8 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0)
mount$fuse(0x0, &(0x7f00000020c0)=3D'./file0\x00', &(0x7f0000002100), 0x0=
, &(0x7f0000000240)=3DANY=3D[@ANYBLOB=3D'fd=3D', @ANYRESHEX=3Dr8, @ANYBLO=
B=3D',rootmode=3D00000000000000000040000,user_id=3D', @ANYRESDEC=3D0x0, @=
ANYBLOB=3D',group_id=3D', @ANYRESDEC=3D0x0])
read$FUSE(r8, &(0x7f00000043c0)=3D{0x2020, 0x0, <r9=3D>0x0, <r10=3D>0x0, =
<r11=3D>0x0}, 0x2020)
write$FUSE_INIT(r8, &(0x7f00000000c0)=3D{0x50, 0x0, r9, {0x7, 0x2b, 0x0, =
0xd3a9f265eb6bf05f, 0xffff, 0x0, 0x6, 0x9dd7, 0x0, 0x0, 0x8}}, 0x50)
syz_fuse_handle_req(r8,
&(0x7f00000021c0)=3D"80cc949a20a10570b22f57c72b14b6d5b9656d619411d3e0feb9=
96f638296baec90caf0305c18523d32f8aaf50d3b62deaa3a75c2e016f25efcddb2e4e5cf=
e7a2e24d813ff5e08182e8fbc9353537f68ae28a6548a83e5662b382002990c8b32a687cf=
b9922aa8e8cef4d8f1c1e9ea22d432b3ccdc80e9b39e792b7545ae90a0880cb7f49edb763=
13335f65ed0888cdf8a79f3a22028f6035b8a77343e12b2b48d61cd8dadd99ffe4ccaf144=
36357b8f5c4633a94b27d21367946bea971d2f2cc9c588402be7d1f4cc9c78732b4650438=
da4a781b23ea5cc672d28ce0d78fb13a532779cfe3689e62f673ff4d4edd72d396bc29607=
5a710424cfe4fd1d38ce799c319e58f5b5d76c995ca60bb98f1a027c5122554fb397420fd=
5095c0326ccf221f017dbfdde47ba8180ebb28573193aa67076f503ce05d7950d220bc8dd=
ab527f0117a30a9c9fa977e6eb12024bf97ac55e5044b688f8ece30cfd06acf52743837cc=
9b1ae37af0113cda07abf471828dad657fd8a2cccf307f16e21f938b3c3c03a29bccb9f1f=
4854067c7eb7664f505a7fa433eac2c3e3ba6fc5393e376aa0662d502e91931c8363fa08b=
006e35feee61403c93a78cd0722bce85f680ee04efba31f47f92f1e391e3d63507aa49d8f=
063707900f63faeeba28c3d53cd4dc95af6e916bca9896926775f990b7e528b15014be706=
414ca96c59bea21a312484d3d6434c8150752bccee265c64742549b9bf94d64a100ea1f61=
2de41a7a4f34afc0f47a23a08630e3f90da155f6b5c90dd9a6496e23e80cbe5dfd3527288=
3076961caf332f97dc3871384379b2d6ecafa30ceea5fba0d68ba64fe7d235046347a4759=
f870e5bbf9ab1c3ad3281b63cbe1a9f0de5dc38118aebaaac3d8a42bf5e13489da5dbf0f5=
0a02291a1bff4af669d66679658bd3ac40f153034cadab5e07d743392a491f3daf2737703=
198cbd9f18c90d82dbb276f948bb84fca2bd92160675b5ce96f4e3609bfbfaadaa495231b=
581af70fbc8e2e2bcb249b3a8ff0b45269cbe2ba66b86942d24b086945dc9b4660ea211b1=
93c19bf11cdea937a3699ab6131ea26c4903121760b6df20561fa2a593700d7ff0e71aba5=
139ccfde4776e1e60233a784c72f4b7bcdaa00f60cb93c25367752c624652981121dbafce=
f1c96f3f514347a5adcf3c269df2091400b041d52460fa8c6b81e857f88154d4fce7662bc=
f27df14917a01170b0a36b36b49b0cb69af47247cfe08812597d74fe755ecd1c1ccdb3b0a=
3c9a2ea65c494bbd669b51ab7fdd2bc5e7e5ad459d6a9c9f02e59f7e0aa1f45de43cf5014=
23616d430a6dbc577492c8adfbdfe707daf0fb401239592bf301361770d155cfebbe9d5ba=
f0dccdb358c2c0d7678d6a1ba6e2fc16f1f0aa6b3b9be72b37c22fc76b0e4e5b9fa540f11=
6682f694e9ceaeac5cbc8691a935fd1a244b044ffeb258fb01a035880cb17e7dde5170a35=
d44816482f376d9d48b3b807af0f2138f8b48a47a18207745568b349db4661aee07fafdde=
33d604230e4d340c4f9d9ba0d0ab29294f7a31983fec1a75c6f4394d710bf961b5d4deda5=
09ed7602df284fcabcbfc996299783607934c8e0feb1dc2efb258586e71a0aa5458d50ce5=
560f716227a8d8c19f42f931b2ff0c448c8999863cd85cc5327c76644de795bee4cfa6ae5=
e1cbd8679a32b489ddc4af5c18483b7325937d4a4e77ffd4365d042636fbf8d2999812da9=
6aa1373f082b22c0f32b7d934a3e7dfb7ef7ab62a72671361faf92f291056499a7d588602=
29765ff64168f7faa220eecbd0d238e483094322ddc59f0477836be13328153b83183ef80=
083e8c74d423009ce3699addbc045b3062f81f2609a60ecee4db9ae80e992ccd481ac5c89=
53e6a8a333810e1fcf7073865f67140da698a46fe5419667025febf699b74156fc2fadb73=
7266b0baa6f87a34bb73115b5be02e15eb389de5d1c9a798997baa4410547f8a69af2803b=
d4b66db6cf0a865119a96e721b71ef9621ed7219f1d2497e55883480d663d59d9385ef368=
a6de2867c94fcecc73f6be4ddd6a3f3eb39b5c7c0cdc501dc69f156295e2f5345a9d8fec7=
fb1ae0ae1c5bda022eb7218faae98068c7686ce04f2c8ceec63ed8142380614d7b099bfa9=
455374ef90e3f9799c6b0592f39fc6228f7865a9bec42ab2d10775094a7964a81110de801=
204d434f132c848e76c6e7464fe4904b0e5c82a4b122fd21e69beaf1709c97ad40714b28d=
55db151dc99b8f5496814ca8f0349176ad7ae864ee42497764f39bf10714a2cdfd50fb337=
cfb6e4db18475ed71b28675c5954b078ce1f035022b5a45bec61ff614d235b4b9416ba38e=
d7f55922d14df5b26487a9d605ae4cec69c8396ec66aceec3b15bda52455c36e970dbfb7c=
cc846740226f0c33427dbf45e0275dfff5218940d36a3a06d93d414b0d2ca160b2b5d0de5=
f432d3f36a449f007068d2b79cb2fc019d1a15f6efeeab03afa45da9c1c360275985a839c=
d0137455885ea2a69aefd48915e14e7973ef44844963f42062712d4a8be4c3da27d8549fa=
3d65f673faa5bc6c8947bcda7863743e4f9f2e7dc62eec22fa2e9b669f87bf4c303e89125=
8b91daec9c9cc65c5983fd91a7709b5c7f1ff72faa639ce26ba95f553286fdec3759a37f5=
986c9a7a0ba711685af75c1b04bb743db4d0a39fd191147e2bfe375aa8d6223e7127bfbc4=
95d5bcd4dddfc29ac13a12a8044297a4caba53d63e899e3242ceebad1e6e7ab43f3a23e2f=
d007352866721411ce9ac5e95d46674b2be228196eed9a7329e4d282ecc837215310bd647=
42b5c9ed8fb89b5ee586b6391b57f6d52658eac832b6e01ea774bc5c35ff1c496a8743bdd=
15e950b9eac1437ace59b8c8aa91831e6716ea6fa44bee90f89206c688501a88de558cc1b=
283d4e2dd62a32fb108dc02ccc7d01b2cef61c09403d7256e0a8439828818966fb06899cd=
05dcbb52a9b8238e2f6e742329b170b1286d80ce38796311c94a77c0cd13e09610cd84e31=
2c0d8c9369c6454b98ddb40d6388ee4a16a408dbb589bc9164c9ff89ed34d92d09c2935a1=
e8d651fa364639598a7af49bed103eb975c43162e1f06b51f4c1316ab61f98c00b9944956=
2055f476e1c91dcfd2b6e5c9edfe4a942d2ae04962399ff0f700c4c5a5f4ab819d1a1b7bd=
64767a7c635ee70ded32870d4149359faa38e49e0a8c7a61ab377b3cb19767d3e50c4b844=
ac007d7ca13e61230924c3cea444da8919074705e79a29e0bb1326bdfc97dc5bafa5b74ec=
e5744b40a99c9f4d7a38bdbe5cf3065f9bd89ef04fdb58975284fc36575bd840840f96fe8=
39005743f840174182d9bc84abd5a2a5d3d3d26310ae37534c574c6fa0d442b1fae60fede=
d31010a206019f1df00f2a07b8e576432f4063464e808691cab001c5f68295182c5e34b8e=
12f96eb5844ca66177af647c16bf2c8cd6125068083489ee2672944ce6852e5c6f95edeb8=
6c97c86d4177bbe7a484464355f0ec7d0530c8d4d196122a3997a57a03a0484fa09eeda2c=
00a515edfb31feded6edd66b6513c5a9def92e7923c1f984469ba7054f96af55930c4c928=
c774c92606d8ab63d694cb94c2afde226be603fb7a0843c61965cab2af0e661c336789d1b=
6b5b4de8033da91497a3c97ba9d8d483d2406c76c0e1e00ba9a0901a93812d15ebb0f6a44=
7fbd3dbe15ff1827a459365f8c49c2f6f05826ade87b51175d78e786998e2818840605e7b=
7c4194a9c2f251912d8ae4cbd2674f95ef96bfe662ed7c412e2e2ec8caad8967f1f320d3b=
2669ad65f39b5405ad1bf0af9c65e0ccd1779f4743e211c032c2dda00ff4fa223731845ec=
80134710c732561ce317a2c204eba2bf298f2a885e2348a7cb07dcad2a7baba7a58461701=
63c6378c7ab742fe05ccc684df993db0f062eafd881554f8b44f6913acefaab6c5927b8ff=
7c0f5955c85cc9c70c04b6fb68aab8ae8b19780527aac4aa0c31df2d8369fad0990c884d3=
e0234b16642e0bee5cae0de6288fb1e92c7edf967037e13f07b3f69ff6a19b6a7ac431581=
0919db8499f38039e2399be08d9f7b101bc43a24a09aa49d82f7c235a359e7a65432d427a=
fb910ce19bcdd751292799e94aefe5df558d7f03a6010c1a9d5e2957d94c63ef221ca7c8f=
16c8e639ca1e332c7d5422b2b7b5589690366edbd0cf21ee41b215b84a1108e0e6899c25c=
a16e4f5f0d58f3d8938539bf970e2b9192f310e2d20b520871ded3702dbf5caa3b1ca0ab9=
dfc3563daeff6bc4b5949757a8c2e3ca9a67bf295b123a86294f1250b4f35a0b8b7382446=
f050d2b62dcacfec5c4bd201e00a50d3d2dd97eef43b3e3934392d9ce77262400f2f04ed7=
14ee7a18b79a7ff98fa60d934af0acc351c2fc3e9f416ee164fab7dc0f6067d10b6932520=
c2cad5d0d1ff5622bf8ee5f524fb292ac315eace7d02c80f885749a096b43dde45cd41164=
2282c163fdc2af62b9dfbb7e02005dc40d107c4747b7d749d1607a7cdc3ec29600bfd480c=
80fe4e302164ca3765ea070de833c5efdbc2cb396306f652e00593682a3392f9d2af52f33=
77003f2771ab919c6d5c86df6f5ef335084b9e25564e510b7e1ee1158e4b011043fefa037=
67cb6a4b647044f247f1d24f9d27a95b84347b5495e81b1d25f8cf3d00ce81cb58aa46185=
8768e052001ec35072d1f687386673819411288144a7c92d120dd58453751c8825dff0dd6=
99202dc73beccf1fc161ef12bdca01bc982bc93ff7927b0bc5c076db8077ad0088fba10f5=
d17b50740f14d238315fecabc89ca4004db8990685c51e7272844db7bc1c16be97622cc75=
69f7eb799708b9c44cd15500fc48a577a5ef21bcdeb4b01b1966b46fe5fc1e527a5eb7205=
4265499e36cbc77efbef2f3ed56abe3e9a7fb79027179855bc52e23a635fbc1f97999db95=
312408a2a6824f9d02641bc275f5f98891b1e5571fb985b4aad3c7542bde57186aea7e04c=
23b344aae36e5842264ff5d7f3d97b8fcab46ed86f33d61a180bb9e8422cfef7e9dbf6fe6=
aa1f411e8413a5dc3f1fb2acfca42ee728d684f6aee25e8da3567c1cc1775efabd4300b99=
63fdc1f85f213af53a74fc3a765ce2ccd33435b4a77e78abb45254cdf197a155af61d9645=
6e344c2187b86637ff38ea31f1ae06f0450dc07c4f75483d7465dc1c858c66268bd6dd79a=
ab93034c4bf074916aa0af59517131a3ee7ba071a8e8489f8abfe5ccea8fbd19fd87f13c0=
b79ae9dc4aed40b876d4026dfdf81fbd26c1471b3d089d8f42b59fd4e333895b62cfad106=
43bac3c9b3693ab266e458429332a208fc31f79d5f3bcc467c918a3f7ed6c11978459a205=
5cfbfa66bc6f4842d1a06b6d1002b831f0fbab4037e6437682609510b24964fda2f3a93f1=
14cd309347cba2e957a85afe51205d9a379a3e1f071774b25e02196cd56066b04af86dd8a=
e5d232e34795abe101d22f40d8de9be579b7441bff26297b6acdf2a443ec68162e9f72e07=
2e3c36bbf3699bb24ea36a00e2a331e64d7398ce667a010ecc60458ec1e36b5240fad8146=
e3879e89400c7a1689185d96f3e42c14cb634b8e33c295a069447136d25426e48c2dfa77d=
11c3b2ca5b1ebe5ff49b4b1a216b40f9b6dc823e58d4a4a686d8e24f3ab217b35abe18dc0=
e57d1d6908e32dfc26da5aa1a04e3b7ee1d015226f57bc0da311e7dc8cd2f766f1e4c40bc=
27b7b62b38985f768a7f885884be43f9e13af66592decc37ea77b83d82997f27734f4d8f1=
ec2bcfeb61fb73169a37953a1bc699ef2ae3365c931001fb42ae1d2c2234bf184dbf4c19e=
7fa0a18fd0b374140430aa14edc03b2abd1fe3d2d515c67e7155c8066366cf0f0e4c72671=
a3b812d4b25844e5e1b59de8d1bd13a5a06262511b2f1d43da6608bab3a406723e1774262=
1155ed8f771bca33b4aabea0ba02c7ef8a5ee44e19a09a2a9f298ae4faaa347d3549f1aa1=
5c608fd8f3c48ee91e5d1f7c09c90d13f1e677313a4c074a1a3b6b3c7a184ea34875afc9c=
1ec7d8f4828e9dd9a4bd8a5d101c8770a371c08f446828de72c6b9f09b8e964e579d7652c=
35799693c7aa3c666116dba3555ea37cf7a40b43e1c75a4d8242843362d8f46b13a071ad5=
e68db0394c5b2a89c75a8eab80709d80c8b479e9f98726faeb2c6c2dbddc6fd0824bf0c79=
76b39fd50acc7400d8f69c7830e1a72985f9818e62af00943d4aa9c710971ed553174f1e4=
fd5934d5382659466a9acff619605796fe6a15b167df17991c8eaea0aa300528e2b504784=
66f4d296f7cc667a21fec9e693c4d4ca2c9c2a0e6fc4fc92757e2de37fb7813e5127e6c71=
38d8f7359ee0e97d479161e05c608e2f709729f1f4bd43772ac8a1c4615c4ede74a91e4a1=
6458b0de739721d2ec8b0514a79161ce0087008d3cd97fdd5538c518b24b28419f67ce0fe=
d106b4df122ba9f51af5952a956a0b9c95319f5c49e3f7b48a19dcc9d9f3b5ded21a95622=
07f162b805b628018dad3161f938942cded99e86f51296a815a9eeb1cdd60330a2573ce7d=
cdb07643fc3d5362a87db6a1ef0014bdf70edb584a9168eef7c4baa260e284a5f221b71dd=
72a23d2443a393c7a3d415b640e6ef68b6325cc8323c7441b036950efad4ac9fb10510cd1=
1b06d1c5cc8258dfa0c9e52f09b47828c337f3291d311a450844afbd52de50527d4cdeb06=
121270ce90a29b8f3fe79ea68ad18e2d34148e643a706fb24ff74dd8664abbea9894f2544=
c22f174a9e50d954b6359af53fff54598a7e686c84299c84721b57276c15adcac69ea92b0=
a9abc225bb9a1a6f2254f51aea3da768b324f3bfed0bd4170fd1784d17384fcf16e8cf23b=
ec1a23151cfe2c81894d95599586e136e70ab39d867df88147f0cf56a5bc6d2dff584baa0=
4f7c1ccdb41eae35345bcd2f9c4160e5d141c0714ba4e00abfc11ba3044b566252ab24331=
428160e22fac02d71704bba9cd3658e4ad1edb5dda5e0f20ca2b768db78f9835501a0fa53=
c21a390f894ed62d815a736f6683e0fe841eb881db6941ac4199e1a91f74ac207928bba02=
4490ca79dd212adaad5b2125fc1abde7214e775880daee271128d3b110c1f4837ca237624=
69b3e046539b0dcbc9efdc74d5729f9554aeb11cd4f169649a1e0a516bba7a2744529e7a5=
bad1cc654713015476353c04ada5d5a4a41e80cea1c72bd97ee95aee3298202208ec13ab9=
c8c002ed999ef0c4114ebafc49333ed4e8acb8ecc346615720c9635ceccb2b4aae738552c=
b3a25d00f14fc49ceda292c0ba51e3705c8910b849bc40bce90825cffea3b93003f23eb27=
22057e3324a585a9d28f8407f01f38b37e621537a7791cc81ed4385160c4e4e33b8c43e6e=
e71c2cfdb9b29bc7b62110f3d43b36ed066f2cc903c712bb134e58a37349cae68d9ee2da8=
831738c299f71e8abf9e64186c234eb9c87e983eb31fbf854fd809f5b5e3994fb287db385=
c67666524cddacf77955ddf8eccc91e4ad0f974f56720bcbe28e64ca4aa537cac33a7af5c=
64577d9ce3ccafed63000afe624037cc6f50c4f1843f774227b831e462e6699d31d8e862d=
e7839a6c21642d02f42ebc1f97e57277565a35897dfedeb13b595f89ff9ee7e923e87f0a8=
e218df193da791b5e6b5125cf010ea46ad97e69fba91d5a5f5910fe4c62614308bfae38b4=
93bf47730b2407f58c4013b74787c3b2366e11c56f24864575c03e153fac827dd8cc40b7d=
a5cae79d7348bc9020e8d953f030e69fbdc151b844864b7928983fc52ddb78f7ca9d969f0=
df112426d71b6213f274f4c6f847cf2690ef569e3e6cd1b4690cdb15ee899a4cef5831b7b=
94316a817305b5afe6b7e04bf72b634421dfcc78062f21ace9a094e71e54fa5a68ce305ff=
8d655a4cb76bab1a5f65695068ddcc713f894d0964893f0e8ea0aaded011feb0d7e81b096=
9d62b19c399d303f9355577c1a7ce9f48226aff3da483abc841f994f6d073a111751ea78d=
b37654289d4d26aea096e789cac8fe3bb23195d31a7b8033ec2ad09839d15585daa7de2b0=
ed14dc178df27b1c6783bdf2d63aee1d0d4b5c73386b6c193f6bb19ada653c9d89de533a5=
f95d731111048d727b541f8e130e9b0c698e0695b12d603e6c600f7fe5039ffc0c8e9dd06=
d67b8c040a341ccb89399a097a178d70caa10141665898d836ad6a63f1f53e5f71fd16f58=
92c9a4b8d6bd8653a7ba0a888f746e3e050777cf6d569e43772b6938b65a3a6d555310d00=
3b74ff88afb640c1584a163f3ff30564fc974f2f92f92f4dc8eeb8e09c25089c55781100f=
3d5025c6f8118bdcdac966fc3077447a43fdd25496771f9a7a5f88a1556e9e48f4251a56c=
cce8830bb60905006029c562f7540684cc47e398fa292146b2579652454c89e2f3b6118ba=
d6964176403b431490adf3d108f9ee0c91a7a56b4fff0c0e3461e45d445a65a3108df44ca=
da6fe0c1bc98039188b588f223726e5d18de2805c901c92aeff6ce7f9072e6c065d8f5e08=
a356983abdd55cb89d4062f90c0bdaff31b070786f7957d48c0006a4c59e9705172061579=
cda17c0fc953045cac664c8a63534101cda0fa271f88d97e30121923e1359777ccc9b477a=
ddd6517b5993afb19c6eedc4f052a6ee879233f9d1f3ec431e3aaa787e561223ca44906d3=
ac85523e3332c29fbda77ba95a16d6f99aa893f7df8b0cacff383e196578b76b0f847bd44=
0acbba3d9642dfea94703c39514397ffa671751513c15f1eb5614e54c1db8f9fcdb515e61=
75b13d19eb82edeee6362563ed91a3229b8876e299149a51a40a9718da40cf3236209694d=
3aef482e79349e88e1ef23a79ca484c4c04eb7732ac35733af6cb4f5dc49e5c67bb916ad4=
85bcccec344d387627a3b1b97d7f6c82f5e29313f19e8e42e065eb94120bdd1523a11ddd3=
26514a2c8a54338c5b86328dc031cd07ab66b2b4a52f3a29a33dd776cc33a7b0643b6922b=
00c05f726ea96d2bf9f52c5d88c4c814a1ad9e3df182900176a5daf9006bc0b3987282ad4=
72a9ff9653335110020bd97df97084afc01fbf75f5538bbef39f934d781cf5152aa43219b=
4ec36b5d247c2f037359b02a21931fe187f77210d4d6745963a8cfa379e5e581ba0096574=
466a112892a85a7de6b5b71e8b5cbed837a1216b52aec86c2f132a5b68cab5f4fb8fb4b8e=
66d0b8da3ec9440e8ad3e8652ac045ed7ec82e46e49d0006c1112ab8338ecab8660167e2d=
b4930f1bb2e9fb5687f0b40b40e0dd6b75e78a082fdbfea91da3f07b57dbec8776232f312=
b2d267a8bd372aeb94e2ff2323798553839c961d820d701da8a67a1fc0efa49595f3a88ea=
db8a01c80c239968925fe2a71c4c3571511d13638685f33a2957da0f9b3444e9c1ad13e6e=
eb9175bb188e2cd28e7db490b3f2cedc96c77c01ff7abcf2b27c2086eae3f3b4a1489c5f5=
aa067065ce96108bda1000f636bce346722c6902511ac1a0c688b0f49552cbce6c0543677=
3b43cefd7ca335ded24e17d92c61987bb87693555b8ffe222d30a99ea4ab557994ff136c2=
d9c24872f66e91220b339aa978dc250c435d1d04d460319e0ba2ead5c8329698ce1426d42=
705497671e127266ce256a20cd5b4d859bc5361c5319801576a598f6d391fcf41cecb2663=
226105b6308ccd81c5fcf52c30e7b1d43d1e518884f521ac9d017da826d1c079445be1660=
65ce5974f92fe92645342aab60d5417d1d0a206bbdfb96cf4346023267aa3aeafac6cb5ea=
594fb452635a97f4f87f634b477bee33a3bf0c526c8e5c091e7213659d3fcb8773fbfa38f=
2edff5636dedc6838a9d7e279228a56f89d5a6baccff0461d91d136ea8d097c83993804f5=
4fd264db79aa67c81e966a352b1b9549247fedc317019fa506edba35b0e3d61c93950562a=
6d968c001e24900ec7609a8f72c9d6953b7eeeceda50f237e59c106e16b68145aa746ff37=
35d279b1162cb0383c0ec9d124c94cc4337f21e980d6566d907d0be94b67539b8d10dbdfb=
d840acfa278d5ab3e35a64ee36b2934f019175d946be8723b8c529fe2c171d05e12c471fd=
8de3cd0d2f816fc679273ed18bf0df1953b1e346aecebfb226746ff493b263dc0886dbe2e=
7994a2e547f3c8fff2424c1529f28c390d7e0c6d8829585c41a730b37bdf5343d6396f244=
ebc1c695d37f4b343d9e1a56ef15f808323c465e91bfc8b7f23a71e306128b1cb5da4477b=
7e140426430f458bcdec732d45da8d33939389412ee609821e07a47f218f8447d246d8b2d=
f005ca0b1dc70db2e1800ffede9c04b3a1e1247c4ac6d7f4065ddcd73e08b8777953ae24a=
9d0ec824fe75c1220a20b2e9c0b9bdc5102043f7ef47da065742ce5930582b670a6b012e7=
030792ded6c5d3c4e92e8a27a626fb2594151e5ac1d93bae6e86a89cbd748e35678bc28f3=
aba772cd05990260014607c7348e78da39425b1e13403a9750fef9820f9b15cc16ff6beb9=
fb86277c06873aa18c9509cd3597f31502b6da18fa7ae25ff104db554e2021edc0860311a=
d8956d3a415a3f70058699235ba0cbcc304640622763985a81ad5eeac54827a4b4adcf254=
b3a8909959f9f5509d7207c07cd801bf1b6691edaf191b4ea870302b8d6b51a1539c857f0=
f012204572e32e6d64e2217b7918a0acbf87779c60555bafab138b6edda46d4ad8a835a47=
06a0bf754e7109abc885254949b03e3b2d265385ba54dcabe4857e85d804d3ba72bb38305=
a143ea21f523844e732ab89a42bdc61f6be1f9b28e3386cad2ca92f6c70a613722f3c0c4a=
f72b2cf39d5b734dace0f2e7f66d6c2ef74e141e73cf90c6f979c576a82380249b6c654a7=
b2ef8372896f96f6f766642dacd5841250c97143857e545beab5c3882a3e1d529bb519945=
412e6bfc774e99463dc15bad3f6069c5827ee76897151330dacd669814a58185e301d6f0f=
701908d378b6183bc6b06a8efba3e70a4b790b017743ce08e9bccc686fd0cd725e3ddb931=
1573aaf22f6e49b2c013306c145ed34275433e869a4a721da89de4f59602c5c7a9e54e678=
fbe0e88f64110c975b692390e1f6e896dd322559ab9c629eaec0be9553ea26c1c0360fab0=
2d8e8e16e378976ce57126b434baae51289e916210aa802849b23ec851b1ddbde105bdfe3=
72c96da4ed1a9f4f64464ad704e077b14036fa47fa1c20444392e30da43088e0f3926ea1f=
ba4f2193ca38f7baf44889f45081006acc319e9fe73b7efd7702543c08ae91426fb0333e3=
a347c795adc061d11bd524f5bd1570e0ed47796f6bf068953be6a91b43e66607e25fef130=
5025b9a7558caf9a9cbd1b91757c21cfa254c3ff83f5445c0ae3e70c2f295ccb05ae85c54=
70b893f9768b3c641695dfedc01382bd952023331f6401cd20993b7460f0b5f2cac0779f9=
92570d7682afbf5b2f1caae09c9791a3e9090a5864e895c372064fec3203700cfc75939f2=
e9b79e2907cd9ba03708c4bdd4d2fed6602cfe12b9b6388988fe9c955e71b90fc73405522=
ed1b7579a0c278431e0bac8ef597f398440bda215da819af94b6bab31f79f9cf00394cb95=
5beddef2b97bfe985b6efed138dbfffeff375c2ddcbfa930bf896",
0x2000, &(0x7f0000000000)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, &(0x7f0000000700)=3D{0x90, 0x0, 0xffffffff, {0x0, 0x2, 0x0, 0x=
6, 0x5, 0x7ffffffc, {0x6, 0x9a, 0x8, 0x4, 0x1, 0x3, 0x6, 0xde23, 0x0, 0xa=
000, 0x8, r10, r11, 0x4, 0x2}}}, 0x0, 0x0, 0x0, 0x0, 0x0})
syz_fuse_handle_req(r8,
&(0x7f0000008400)=3D"d1847629b8b32311f0b3613f2ef7623b7e6c2f0db70d70defd2c=
87cb9eb54d5867b40ffdeb44e9ae36c7346eea76ad680d71ce9523a91485d2b97ca190944=
a023518ab9fd3055ef3a96893578d514a6e1843fd009cc02db44338089416f62c86dcee3a=
ba6aad1a8f33bcb5de95b3e39a6d3c1cf23b34c59650f9131ee357550deca14000d942917=
61d77a4be69d5fea5ecddb7d3bc24cc612200436dae9ab65002f6546a6ca09709fb58b2ac=
40bf14a7c66debc3872b9b50451192d62773640e1fc32c8d34da2b8de1903871d4a89d1c8=
33d058af658b1ed6d8396b1ae5b701eef35eaa1e26b5478a9aadcc7f8ff674a1b34b85c9a=
fe9f79e9a474541e1eda27b903af7b1605b8f0cb56ff8def50491d1a63bd3572d3d1f727f=
6a2777c52a47b2ea0785dd3b599e8b33be024ff7e530ff955152d12c8f2429713ebbfa415=
958d657078941782dff438d3c46ec7336527208e7d76e1cdace8b84e1704972c61ba6e73e=
e42abc5e126c25da7fdc366ccd34e4e25f54510f50d7411d104e20b999a238f62b5f58bd1=
6c6095c3ebff448f704b3f751b7bd8cb21d97900ef1693ddd2479df932ac5c27595c4fbe6=
3bf3dabf627ee763ac4b09425f7a1ce69aaa4e86d4fefbc9f011eb46464418c2f313ecf38=
d260038228f015675fcd1bbe1fd70e29a0a8cc39d9265536b47b148fd3afeff11e7a99e4d=
7a375c9589adef1a2d467d8c5958a435fe35228619d0ecf823014f397cb90bbba46748c8a=
ef37c4d78631749be4625417eb529cde5eb0067207b0831cbfdef67263f5e631392fae413=
ced5c9bbd6f0d69d2e08d69d00602038f2f8acf761e3595200586d54946a0b27e2837ac97=
b8352905df9d9b198d45fbf967e0279d81a6501ba3df534a2846b210be34875d4c10392eb=
f2cd4a880bb7b8f73a70bf225855f0911a426dd3753804947c489f7df4820dacb758a6cd0=
8d416102f515459e96f2d9106b9264e4d559ecc488e562a8e1e7df3fc7e2ad7f631c8e3e5=
5aa6be2f7d3c7b5055e775f6f86864bbcd91260dcc5b96733df038b84941e7dfb06577c88=
5da6887736f8e8c22989fff2e773e406856eac71220a471fb0b67b2e45b158126efb34973=
9f3733642e63f34b6c458c495e5d3551dc3600c6d75a3b4b1a06f59adc8d8bf1f74105f61=
e226a0b80660c061c7dc9e910e0027aea8870890541a090c094cca31dd252520ddb7e98d7=
ef2353a4d11d0dcd5d635f0fb9c429a69cc2a08fbfc07943d910a97a07495809ffa545ce9=
03571b336f27c5061fb88a9d8b5ed82c71573fbf6825d1101cd91883863c073efd4977eb4=
cfe87e6716753076dc016cdc383c3a17068baa21c71690488495bd400d3c93961a73b26bf=
12d60a57edf2dcedb3d9b3b2616fb62862e50c21d783a533159b21635fb316f797fc4e2dd=
cb591db40addff2a21872f1c499008929e58500e4c6f55ba800d58026e05eada9b61994a4=
12f174f2c39923cb1d02505a31235f98d8c523a574121e1194ba4781b5ab4d3223388180e=
37c9e435d7dda498002ff8d3b3404e40e51d4451a52eb3763d79134396fffa3fb15804d9d=
1b9779ed5e31ad6740ada75535d14fb41e39ac7caeda9bc01399aebc226f3727fdbee4165=
b98da6645430312482390545e966db851d035904ae2b064b262bb76f9abf531b9b9da2846=
c26bb4019aec5037b81c5d0dc4d393bd8bfe7daf1d1dfe0b3c96c6f56a5e9d50e66c61218=
2430feaabd865ffb4541ef28014b7fa5b4770231a911cb109c25c596e2df0e25d33550b92=
80e1944a5af2d374e4a8fada818edb964eb7800665ad7e6d33031b67070a37967b03f5f19=
249abcab594c45e6588893f9489f5e176529255918002efcd37fff92421e629bd103835aa=
2bc0cff824f4970c3b1dde2c36afbd169f6177a59ada0637f0087a358524f62d6e0d43bcb=
8ff5870a61048b33f808eb0597744c6fef62d057421f66ba1db77f08e946987140de3cf92=
4f04f75e211f06245fd621d897566cadef1ab84f76a4a5e638e8db97b51ff83494f061439=
1719058ebbbf30f9002b7ff7e83ebb84d6be3496cea286a426df3696fdea1a86af37cfa19=
f2b887cb364591c2fcfe9c2e5a7e0cd6b703e30a3f08c16956cf878d19461ad7b3e5e4fb8=
2f2bd8d094982c47f403e0dbb76b7dc489abfdedec1453fd1fbca1a622e88fb9cac1b7a04=
c9071ee627d6208dd10c9280f24f04c9baccab5206dc54d6346fe077317176a9ba2904f3c=
447a965d4da58d77cca55fbc5de7497e8c02257cc4652d04c9e165d8c0c2851d588902510=
a52403ebbdf0ed412ae1ccf603ee34241a66a80e8a3ab45ba5b47252497d4261c84f505e2=
9d4b9cf31c580eb03aca6fd425b8f987adf82272fe0a10383c2a3349fb2e0d76fac7c56ec=
535bb2f6bb7e022d83ed82cfc5c929d042346da6d939590ea70aef16302ceb2c65f5c1181=
abb9f47a4eee9a2430a9eb44119af9e695119b546b04ca02a9d6243df326cc62f660c617a=
77f759929ee6196a3d7ef87d9329de8ff1b3ab7768319044303341d9fa0bad70f8a5a783b=
1717fd03d4fabe7386139c49262a285d8a11aee8a484959649cbcb76be6f10458e7ac4dbf=
0a01379b4658897193e37b3806149831e4a7a5ddbae06cd9b81115afee98535840e39ba4e=
5a7dda088cda47c0b0a795c55f1f09830473c9f07e1ae8236ecf59761ba6153bdae59fb32=
046bb006edfa45f354384b7a61c27472455291ca07666fababd2a5caf2d968cab5590cb8d=
6edf74164fa683d0fa5ead0dfe9e1027ae280c9c03a77370186f49492187909aa5ff28ee5=
eaa0374f3cac7f100c9ccdc6a355835682a2cfac2a738039a63b69bfd4483d0f758a29b00=
cb25d3bbbe2edd9e88518a5af0bfec28172ac8c4af3e1788bfb966ab370a3b9e147f0312f=
63207ffc2779a02b01644e1a636114862459dc734c37689d9fbf2d6f0a24259f8474d0756=
c971e005c47a6fbbf2c5047d3e074c693dae1b41c8042da7c2f21ecc4bacb93d96ff2621c=
949628079897efd6f42d6a4f225b46c92ce1448abb02d16e8329f0a133757ec1a4c3c82ee=
f0baa694fe13efb73b59196c39d258b6ca8ae25da0ae0bf8d9cb90d25d2393f3fc7401770=
3e9f4f30ce039fec1cc32606e013e518e128c27fd28a0b0d621290a8c1cc2a0ce446d984b=
7f45f919daa957ece47731fbd1db23b0b284c6886a09bd553cadbce93478f5830fc80e42b=
3cc2ee60bbce6b4a61d8cb00b2a92adc91e32109b812ce40349a7bd323b23981b00442725=
674c424acf8a270a30d7f4ac3d05e215d1a8f8574bd40935bca48093c0405a51f25d99bf5=
22eaa1bab75505ddbcab4ec301c85402e233c6850dbec21ef319beee2eed4ab2448b5774d=
efb10338e28a6891d54fffbc71a48ec6ec9058eceaf1c486056c56bb9fa0a93a803f174a7=
2d41db738971b438ea8cd91b7d5b2eaf20f36491169ca149fcab51d7ee4c0fb96ee7e1b53=
a733cc566327974ed92abf15054772fafc397e033cb72e847cabc4bf3ab5d1eef923e7eb4=
6f6abb5249011a7257440317017ba894e50bb20dea98dc9ae97f4d601a0210067356a2ae2=
bfa12e028e594e33402f23b2bd5c772bd930678476c74a55841a23cc668f0b8cfc762c30b=
eaba8cb1c1fd5bb64b5ab4bf7544975aec5f1e23173ade8c10da5dbcf742e16abd2be132d=
af713c2362b77737dbd3dace189e5aee33231602ce46861b83af76630b0dbb0da1b87e2d1=
83cf3f34ca8064b2d0a6784548ae3fc71797dc5724bf570aa99c50277467454a51bde468f=
0e33541a23cca11a32298aa52d573fb98cdccc55043fedd4b57ebe921c1791b5bff68c744=
06dc2f7c2ab1c7d11ac8c83fda5aac9c80cd4cacb8c94f0e0a169944883f2b6c5d1a12ba3=
b79959fca8b54784ec419e048e03371f333300e7e1b78f1261cc093e556fdef5d257bce50=
32760585490f5a5841d98fadc0817c74e86b3ada213f55d3828433c13ecac1e335e399e78=
b2c8555ce1bc175c7d17652cb606f249036f79fd38a45b55015dcf85e55f412decd0b1c3b=
d5524506d97860fd58cd96ab468bbf28c2332810421a56b3356b1df87b4cd44686af33e40=
956c0fa45da43b078fff00f4b56efab940b057f43763cd6d876f55371e7b8514c47625bad=
b6451d72992f100e6708c210935bfae86e96035b1a3d32ecfc45dc4fff58b330a6e790ce8=
ea546e01112dcf9a7e3df6c351aee97b48fb821bbd39f8fc3e14e56f1e66478009b7b9466=
f5a538191399e44860d1a08231c9d30dc4ce2199903e3282b92938a252fd191efecd4eae6=
aaccb99e58aaed62f879ffa9aaefd6a1b5febe4ed67fe49cd940740c226356e0e20dabb8e=
5251ef186a63b7ff3427118ba081d74444aa1c17944ccf30df8224bf54e6d2c668944df91=
a7b1e2bc10223c7903befdd912c2d251e4bdcc69ca888a45b1039f57b4029c0c21bfd5ffd=
d7b5d8e9b9aeb38a6c20a415e9c3759bd4c226875c09e52e6b05b0b20da60c3a0648ca7ac=
4dad02935f69a0c8e4f74c92caa03599e8f20024953cc0908222a3fee8706d9b7251b778c=
40c820641e5c71c1b76110ed270d1841a93e7f6168f3e45fc9e718aaec99ccbe3e2dd501d=
0fa9bb727a039721648f00d1551c3f0fbac3ff6f5fd7c8ac77ea173dd4c436cf5a56e21f7=
0d8bd7ff4e7f7a7ba13049700ae7ef10278607ca01acceb4b35f03caab627f1732e49ec63=
f99047e171a40bf0a11344084a86462fbb9beae092b259e3194d3f19de019cf9b5d25f3fd=
4b05400361ee003f38450cef86fc79a3f609d944a78f52553d95c139edeb846fffaef89d4=
7181d700f95eb5a35d014ac44f5dd3b29bfbbebbc82a13ae00fc2efc0d65f8b4611268e86=
f781991c260ad83bf7c3f62216ffa71f6ed6b99e345131705fd4564e418da75b26343b678=
e087c8e3d30326d59443a3c44d51e96c461874fd0980366c882b1a7eb31d8851732b88ad5=
501488ef65482b8ee7c37142b3919fbcba2247e219834eefb734ba893c255f2af9bebcd35=
2efe6ea20cad9bcb00f393fb1d2f46e7aaa3d32be901c0d1fc181415c4c048fd3ef94bb21=
b898615e6cd41ad7693b25616589d5852ab79a9ffaac813564422a48d969f1c4349c3bef7=
7dd38ea6d522e6430d062d2f9d40077f1166a030e511059ac0ad12a969d5d2c0143f1a387=
4111abb2412282293737b918763f711fd3b6273d4acb243dac25e97f0ffbf411623b4a5c6=
c93c7e5e5fc26563b90073e0d6ad17a7459bde92e6a1f24545a2384f945de8fe30f4c68e5=
cc59707d4c2570fed7e6e9b8941bb07b904eca978b9c2e0a23312ef4eaf85f8bb76977711=
24533d729ee090eb0d160438bc8e4c631e28b1bd0badf0d065f10f868dcbf1fef31834ef1=
e57221dd0fba7d0e56462e815538ac44da2ba70c0698571a85d174589c2394accf8b98653=
fd6d1c54c9e23ea3440accd77eb9a8155ed76d68f336ea515722062c69ad79f1d7538ccec=
63eba72d755b3828c463306f66a7798832e4d3dd598f4a3bf007cfb151734fa1a73a8774e=
bfd6137e0b4d5d3d76552118b040d9c060758438f5108611c2db64fd35935498254133bcf=
a2adc6ddfb5b2f15a4ae2c89e554d82b753c2f250ad8f9725c7b93692d0eaa0ac0804844e=
5a70e162e2d9eca134b9b1c25a5483a54693b591f76ea6d891b47f57ea3ef51808f3d93bf=
74c6c6edc60eedb19524d86e4ea6294ed09d8c45feb874008f4aed864d6404dc892704a21=
a78da4ee3bffd444a9a4c1ef34580c5db99419856187648868ae4845fb4c391f17f16707d=
2b9c5cb8a1d4a10c5b03eb165e7676c93dc5ee047ed77474ffbc301115a27a8144c7302a6=
82eef28c75c5539e514898ed3d8ff75f24b8ee466ea49ad280eaf84fb49225888c17296a6=
d2c709f57822c660ce5f921123e897d4797ad151cb9bd58d6c38c3bfe6a5db76d72b68bec=
d64d63319b6cdb1fb548f9a8cad9ceca4c167e26219ebd20c4d8e1c7fb74984a98e483503=
2581ca10dc6089e57987bbb4dbeb17e6a211a85107d2b5dfdbbffedd3ea8ce80720e82b19=
89096bd23b05992c0a3e09b766a0e4c8fb486290238237b80787b09d495a5e1b9550fabf6=
17792ccdbe797857a572b85eff0d214a80aa5be99b4ca4ca9ebb189944644357abc451d5b=
407940797512270208dbfe6c320740168dcb654c53012e7e740322dd91f6c2647298050b7=
e8440857ff1a8deaf123a8da923d2f0cea871d21ab154e3aac07f1994851e755bc21cde31=
d132f23d9d01bb51d5364a72afd190eb93a7e96948ddd619d3294ac31340e1cd78046f1bd=
ec4cf1c30442c7f62d8bba4e973af102956c824b6be5a2309ca38205f5c5d66150d431cd8=
9dca11db7df2be7abcaf3398c78409aa852c7290497514b8746b1676f89afc27d38b39dad=
5ea4d8bc371f4e4fe59fc4fb37c1e2dce7e213ead05f80fb408780dcf6a57fb3fbbc3d6b7=
edb6398b7b09d85e2ce07015d4dbf3cbaa02139ad16025f1f65bba1e5fcc9216de59ccf01=
32d6a00e05f7da8e84b2ed5f9fa143f4c4068824442b119737e77b85f5b1d10926404b05f=
aef7ee385738531e54d20fc7134afcdb4bbc5ce305ba13506c4400668d8d787ca59097b63=
a270f1e77c455e0a1091d87139408082a7af05ae3a494d4652790c057ccc097512a450dc0=
d0b571b278c361283a6a90dd908925c94386d91b8f32eabf6e6555217a3d11f068c24405b=
4ae1d8eebe81096d4ea3eee410d5d07aefe26563904d86feaeb5bf6c5c53d90ef93b64eb1=
19c6bcac559987c0345171bfb40f7994289d57c0425f6ecb32519b97ac8e8bc366b816fc1=
87bd03416222ea9ac7c9b2cd41173cf4b50384f2e0ecb3c307acdee361e73238c37555fd2=
5c5fca471c8b7c2739bdba5e06bc3db77cfb348af90b6906b2542d69eb83162e6d5607cf2=
3391bac51d60e9b3a8703249853015e0aadca8d4f2306a9daa121bdf76e98c55406d19c5d=
b51a621df62aedc530da27643e2f34ddfa7f91bb53851f9659e17292994a9610e418d7225=
223bb229fda63e3c1863b349a73f7d70493452809b77431f578bfda82867f2837f3d1200c=
ee80019331408006765de7d27f8256d9242a09df9bca29e1c9c727cbe00c6f223df970d62=
7c9e06c07c454a4c4abef00ba2a66c99f92e73eb10b71684c9f4081b5dc3372524fdd76db=
6f6288b593571849e1df8855fb971773497e90ed8722facc63be58092f929c306e8ef8ffd=
327a95068a30b17535ac6f79ea2ae5dface84235580e7615674c5713c42fbaa87b3ccaeb0=
a916d9d737e1013351eb471e967b2562272e68c760288dec5174127e2e70a12e3e8ab3af6=
932fea0abee4bf32e2d609f210e153168ffdbe8bbeaf63e1b2f31ba76e1e717800cd0698b=
cf92d1600edc35c543a2be0498ac78223f62c61f27502a02dbafce827cfd924cb9146a587=
30692cfee526bc59495d6db7c485a5ebd756b25a22ae77aa70594c5ac3850235ff6ab4d9d=
d7a3e494d214bacc60b46186c2fe413d96cf1b1ab10595255a465e57c42b52a124206087c=
7e6c4c4ef25aadfb4a09ba1e7a77147a3ed6fcb4b09990bc65770cb7076927c01b227cfae=
4a8ed1f8e2b9f75ce18f7d878c5544be2d64074d06a75424de0ff72c812662e2af6c7e383=
2df151ffebe3507d09b1e2e0c134b693d3c7c8d81fe24097d138601693d4027920d43f28a=
4b2f73ee1490a221495aa12bfc2cc0d2129ccf36060bc09852e8747d1a9d354eef234dd29=
4f99263295fba3ac5eff8a96bad66bbfca1fdf02767ce0f6ee0eff4841323e70f25640b19=
10856ac7dd68eee19916c8336e670bd8e1385a99918aa010dff6b3cd065a0d8b38d4e9a94=
4e708e1fa38c0e85acbdeaa14d289348833f8980d7c0476ee7783544bfab6cfd778db599f=
02880a386a724005dbf620db610ea2e6f6e02eb8961f22995fc633cce267adf7a59bcfdf4=
da1d2cd35c0371c859a586c33297e17cc0d6ccccb79b8e1b14d5d8741dc2129e09d3e2e31=
b3d046f70c1cc0f2adf963022331225a7bb52164fd6589a46a5950a185246d3d48c592781=
4a9717d780df10d2463f9a3e5fa067385167b9df2d71463c9daa9b3443713701b990a2b61=
e453f68f1c864df5647be3aa14605f90ce4f81462fd80063419fc7209a6ce0b89733c0947=
b4cc9f52dc7b8502d120f855b11a3827bca4ec3e58b7cd211e049c2b67f61852939705968=
bed2e39fecb8b2aeb334753cccf35bcb806c6705b263c4907b3c2bdd864aa7dce74648813=
4759e43d9a496bab4660d826f95fb4857215f312ea2b2e556a89be47337269348cdd25c67=
12f4cca7f485686ea46d0eb38c7b37f82f7101d968736e0ec06a3f3a80edf5eedc3d942fb=
b1cb75fa0dc580e9cd6f17b603ef4f2498454f4676793d4b7c762e898bcf2f5c2e61d9cc8=
d64519770435a46a4a90eac4ae0436090a80bb23a537bc4b9c066cec6ddd46f7f3029e07e=
3479541d7d127b05aa85be18002c59b41d4c6f3630d54c91d1a747aa1ef1c30faaeec4b94=
9199154cdfcf21b55493e9f43e98ad0dd492eed7491041f38f910024160d32fcdd1cf63ae=
0a65d9f6ee1164fce7717c47d9da69ae69dfdb206edcf5dac41266dc4e6f7b94bb429c814=
6c6e50668e7b53839b85b998ccdbda5bb51b74c3a7e4cda7301f3ddafb4e87945f1f64bda=
82a7ba42db1323d7f1357f68a0c8ad8b664ae2da1919dca4f679657477464c5f3d6d995e4=
52ad0b92075867ab3ef7cc7d6230798ed67af4202afa7b6a96a71f6bfdb044c0f86a6fb60=
31a5e8ac4d67ff8f7cb4652bc06b30ff476cdeaa536d383463d07c6bafbca89d06166c3d4=
a1bcf3b9a858d1d6a54f8e84458a446a291d28327ff612db80a19f680e50f57384b4d6ea3=
48557d07e4e7f71d02b83869a5b50716001cee1dadf47e3db26c20bf7e54bcd00f77878d8=
ddbca5687f1d93d73889d70da690613d4e60b1f6a99a430a93c4f6344acb830b16da48122=
2667e8d9d2d875635d55a495902e4b434f52505943712f6a05d90a371411d08fc5b3a7686=
772a6097e603f4c947dd6067de11c5e42f3d43a5148719e10062b334bf4cab4e1d3ba17b1=
0fd5d2e26b67d58bb1c04eff22fa45fe09c2f8441ea889ced3972d171041ce4ef8c68ea8a=
1b73419cb9d7c5b21ee316ed6cecdd96dc96631c6d213d92edb4734ad81465576d032a4a5=
5ed3f03045816703a290a8af40f9bf7b1da8089215dd813fe8e04e06aec54272b6ba48d67=
27723fa7208508f6fbe318ccd66d4d93ed2a584dee0b1745b6e99287cc4eb5ab025ad66ce=
610e85274865a7733a420d7d36de3e6462fd5bfa7f67700db7c8a51a82556fb09993ff0b4=
cc34ec17c19727f38903e8ad8f817c272e53612d79e8c218ff4b122a087ac839581ee953a=
e3134e7899f24d9c3c3349c99fc7f4083c974078d8e20f4ab16e74c418e1de03cfbe3bae1=
5bbf7da7eec27990f41ce8ec747b008872da491117fecae9c71b82836b55a34fd59a24ec5=
01c363db8520d2ab64ebb5cf42d67643911bfd26101777fe02db300c82f9a5bf0eed3206f=
a745e7a2311b6604e8a263dcfdc45aaebf2be105dc9a3c691d45bb01e36baadaef8e47e2c=
9aadcbe9ee2ae2fead646eace3ac7924dabe86aaa06e688234586a7ef3cdf6508ea3fd65e=
f0ee0f8e13919ed96b4f94f2a2c915c2377ff159c9386afc24276dd920b5449925d4b41b3=
9fc60902e03aefa57cb00d79ca8f14e51ba3fc9a0febbcbad5b5982271cf161a7bab4fdcc=
7deb48d3e7d125f171ec55ff0b5416de9f7b323c6002780286792ba3ba3dd3b7da5ad71aa=
7eecb7f555d1d80d69488b1a533203e767456c647fff0e4d01f81aa1673cab0d5e2bc234b=
f61c23b00eccafb9a6520600d0891b6609690891683ee8745516d69150f8e6bf4199798df=
436e5a6bd33d2d787d210aabeb423826d1ae5531343ac2c636216d91a4a467f66a3af2e00=
ba3c8ac8989187a59a8048e45db0ff4bffae9a6927796cc9a33c7300b293fce6755499554=
787adb31e8651f3d91ccfcd297c3517fac4585b12b85df78c186e43ed0923033edcb273f0=
f5b0fa357cbd58bbb134a3c29e063f907f6117cc34ab6ad66c8762215ca59ffd216a77063=
6ee82a8e605a9478d3e62a84b4a42713c7218eda3aa54c736e9c450dc497287baff675ea0=
10465897d83621121abb1940323bf30c6192f854af5611d9b5c2ac5a58cd36b9325f11e65=
7c4272f48414d0b82d89cca0be80cb4ae142f6442a9527ad0ee8deba525aa5cdeaaa60305=
10b8b2a1e85c9464c255940d968deb07abd463e18a68252e86f58a0f7d284527af45f769d=
e13dc1f06ac736ec7e5340d9ae9370a83a3fa1214fd84f1a3dbc848aaf178774df75ca2b7=
c09ba28e79759d747832841aa9861cb8efa3788c863ef5f949b0bf00d88f811dba5e91461=
f7d571d236d2e4aee29723048f9ee95dfabc090788d5f7703887fc38670cde115e75a3f42=
93d6e916ced7316917e4c8d583d949b3e59bf77ce8cc549a359ccc7649ea23adb0c164cbb=
6b97c8c4728338d993735a6bf18d89803e4b97c3d4bf3701d72bad91cff3c83ce0d493f91=
45fdb7cc098f63ab06247a8212b4862ee7b97bd1e4460dbaf6dbac749b21e97ea0f4033ab=
85977f1f6131afdfe1d3830c5fa4e5030d8d8930d890304832031baf11b17647f906d79a7=
11c8ee99855d4d7a00620864b9495c7b248ef9bedb29e8797afb9532da3a92dd6c99b4ca9=
b20539e5abc7d30778365cd8e1498bd9b9e7fed4c080769c45a2effc7ed811deed99a522c=
a018ac00eeacc402ad04e2e3348378eb9c9ed40abc416dd88768f21ad1d09f792628902e5=
177c95f259de1a73cf34a612d88f81cc33f8a5c3da0142eb906caf35f3787a26683a2b573=
a1f0b728f290bf74d441663c1c04be7deeb9e8493ebb29294e836cb25417d499cca7b7478=
26cec62d1254eff8487c5a91b203e95d531431f12431fb6522dbf0a702b5a41b4919004b6=
1455728fd3e47f56c96268c34301d05cad4014776944b33b4446b51076e71c691b4a190ac=
f008574977b74e10102f4dd272beab646ddcb0b4dab6bb511a12faa59a1b4dc3507fe8ad1=
bb8fd80c98df3e3e95551b816b583eda74f80efe345db19df93a355e2a22896b033fac066=
b370fa34e383ba957ed1c181378d9178a71d7b7e208487ae7decc0b9f56935b5e1faa29cd=
31c6d511c2997def9fd3747b416ec38196c8b5c0bbc845b242ef71c3e6bb0d704f475a33d=
25a6903c2319351324530c15325848b44f4cfbb05ca48a02cdbe164d35a66e2d7e02ef2d2=
37d49ad4f9defbea01db1b5d19802e28056382d3cd0077e2c67dae84704c99468a9e06c6f=
86c06f55249aa97c6d4c59fee7117e9fee9c21643e4af9b38c345a990f6c09b079243ff3d=
5ff14897e4b0740103e7049f13f467184742de82bdd71ccadeb8defe5c8ac6f0dac16fedc=
fc3da536e8d7313f0576cbbb7e18c89bccb3a30cc1fd39797b6874b2e9c69465c12a5be09=
4c949e8a668c47be512ea5a99cbe20c71dcfb6a000c7ef5d72467",
0x2000, &(0x7f0000000f40)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, &(0x7f0000000c80)=3D{0xa0, 0x0, 0x5, {{0x3, 0x2=
, 0xffffffff, 0xfff, 0x10, 0xffff, {0x1, 0x100000000, 0x2, 0xffffffffffff=
fffe, 0x7, 0x4, 0xb, 0x101, 0x80000001, 0x8000, 0x7, r10, 0x0, 0x7, 0x1}}=
, {0x0, 0x8}}}, 0x0, 0x0})
close(0x3)
r12 =3D syz_create_resource$binfmt(&(0x7f0000000080)=3D'./file0/file0\x00=
')
openat$binfmt(0xffffffffffffff9c, r12, 0x42, 0x1ff)
ioctl$FIBMAP(r7, 0x1, &(0x7f0000000000)=3D0x2)
ioctl$TIOCVHANGUP(r6, 0x5437, 0x0)
openat$incfs(0xffffffffffffffff, &(0x7f0000000580)=3D'.log\x00', 0x0, 0x1=
40)
bpf$MAP_CREATE_TAIL_CALL(0x0, &(0x7f00000005c0)=3DANY=3D[@ANYBLOB=3D"0300=
000004000000040000000a00000000000000", @ANYRES32=3D0x1, @ANYBLOB=3D'\x00'=
/20, @ANYRES32=3D0x0, @ANYRES32, @ANYBLOB=3D"f800000002000000020000001000=
00004000"/28], 0x50)
bpf$MAP_UPDATE_ELEM_TAIL_CALL(0x2, &(0x7f00000006c0)=3D{{}, &(0x7f0000000=
640), &(0x7f0000000680)}, 0x20)

2.43613145s ago: executing program 8 (id=3D13548):
r0 =3D syz_clone(0x20000011, 0x0, 0x0, 0x0, 0x0, 0x0)
process_vm_readv(r0, &(0x7f00000006c0)=3D[{&(0x7f0000001880)=3D""/4096, 0=
x1000}], 0x1, &(0x7f0000000080)=3D[{&(0x7f00000002c0)=3D""/199, 0x6f21caa=
82edcc3d6}], 0x1, 0x0) (async)
r1 =3D socket$inet_icmp_raw(0x2, 0x3, 0x1)
getsockopt$inet_buf(r1, 0x0, 0x9, 0x0, &(0x7f0000000100)) (async)
mkdirat(0xffffffffffffff9c, &(0x7f0000002000)=3D'./file0\x00', 0x0)
r2 =3D socket$pppoe(0x18, 0x1, 0x0)
connect$pppoe(r2, &(0x7f0000000000)=3D{0x18, 0x0, {0x4, @dev=3D{'\xaa\xaa=
\xaa\xaa\xaa', 0xa}, 'geneve0\x00'}}, 0x1e) (async)
sendmmsg$inet(r2, &(0x7f0000003d00)=3D[{{0x0, 0x0, &(0x7f00000005c0)=3D[{=
&(0x7f00000004c0)=3D"5784", 0x2}, {&(0x7f0000000500)=3D"cdd4876f0729ee645=
b02e0beb4b0909afcfb1d3e1cf71531edfe4e39560ab2f912ea5a79a5d2fa", 0x27}], 0=
x2}}], 0x1, 0x4000882) (async)
mount(0x0, &(0x7f00000000c0)=3D'./file0\x00', &(0x7f0000000100)=3D'ramfs\=
x00', 0x200000, 0x0) (async)
r3 =3D syz_create_resource$binfmt(&(0x7f0000000180)=3D'./file0/file0\x00'=
)
semtimedop(0x0, &(0x7f0000000040)=3D[{}, {0x1, 0x8}], 0x2, &(0x7f00000000=
80)) (async)
listxattr(&(0x7f0000000280)=3D'./file0/file0\x00', &(0x7f00000003c0)=3D""=
/152, 0x98) (async)
r4 =3D openat$binfmt(0xffffffffffffff9c, r3, 0x42, 0x1ff) (async)
r5 =3D userfaultfd(0x0)
ioctl$UFFDIO_REGISTER(r5, 0xc020aa00, &(0x7f0000000480)=3D{{&(0x7f0000ffd=
000/0x3000)=3Dnil, 0x3000}, 0x2})
write$binfmt_elf64(r4, &(0x7f0000000000)=3DANY=3D[], 0x1420) (async)
truncate(&(0x7f0000000000)=3D'./file0/file0\x00', 0x100)
socketpair$nbd(0x1, 0x1, 0x0, &(0x7f0000000240)=3D{<r6=3D>0xfffffffffffff=
fff, <r7=3D>0xffffffffffffffff})
preadv2(r7, &(0x7f0000000200)=3D[{&(0x7f0000000040)=3D""/54, 0x36}, {&(0x=
7f00000000c0)=3D""/168, 0xa8}, {&(0x7f0000000180)=3D""/49, 0x31}, {&(0x7f=
00000001c0)=3D""/48, 0x30}], 0x4, 0x40ef49ab, 0x4, 0x11)
mmap(&(0x7f0000fff000/0x1000)=3Dnil, 0x1000, 0x4000000, 0x40010, r6, 0x34=
7e4000)
r8 =3D syz_open_pts(0xffffffffffffffff, 0x84000)
ioctl$VT_ACTIVATE(r8, 0x5606, 0x80000000)

2.42565529s ago: executing program 8 (id=3D13549):
r0 =3D syz_init_net_socket$nl_generic(0x10, 0x3, 0x10)
r1 =3D syz_genetlink_get_family_id$netlbl_calipso(&(0x7f0000000100), r0)
sendmsg$NLBL_CALIPSO_C_ADD(r0, &(0x7f0000000200)=3D{0x0, 0x0, &(0x7f00000=
001c0)=3D{&(0x7f0000000140)=3DANY=3D[@ANYBLOB=3D'$\x00\x00\x00', @ANYRES1=
6=3Dr1, @ANYBLOB=3D"01002dbd7000fedbdf25010000000800020001fff20008000100"=
], 0x24}}, 0x0)
r2 =3D bpf$MAP_CREATE_CONST_STR(0x0, &(0x7f00000002c0)=3DANY=3D[@ANYBLOB=3D=
"0200000004000000080000000100000080000000", @ANYRES32=3D0x0, @ANYBLOB=3D"=
58f500000000000000000062a43c6dbe9639d5eb", @ANYRES32=3D0x0, @ANYRES32, @A=
NYBLOB=3D'\x00'/28], 0x50)
bpf$MAP_GET_NEXT_KEY(0x4, &(0x7f0000000140)=3D{r2, &(0x7f0000000000)=3D"a=
e4a30", &(0x7f0000000080)=3D""/140}, 0x20)
bpf$PROG_LOAD(0x5, &(0x7f0000000100)=3D{0x15, 0x2, &(0x7f0000000200)=3DAN=
Y=3D[@ANYBLOB=3D"711010000000000095", @ANYRES8=3Dr2, @ANYRESOCT=3Dr2, @AN=
YBLOB=3D"d95382eede2c4a2120761efe543551a1acc00b2fdd3c7be1218a2527c4ad48a3=
3e7630ca3b3f41bd14e6189834bcdc505b9f5c32c19f657be7a46110a14bf34cc0771c909=
4044e28f595b5e65055c12a203d01cc0b54ae35d015eb33839e1c066565e951c2a2"], &(=
0x7f0000000080)=3D'syzkaller\x00', 0x4, 0x0, 0x0, 0x41100, 0x4, '\x00', 0=
x0, @fallback=3D0x18, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0=
x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x40000007}, 0x94)
r3 =3D socket$nl_generic(0x10, 0x3, 0x10)
r4 =3D syz_genetlink_get_family_id$fou(&(0x7f0000002380), 0xfffffffffffff=
fff)
sendmsg$FOU_CMD_GET(r3, &(0x7f0000002440)=3D{&(0x7f00000001c0)=3D{0x10, 0=
x0, 0x0, 0x1000000}, 0xc, &(0x7f0000002400)=3D{&(0x7f00000023c0)=3D{0x30,=
 r4, 0xa04, 0x4, 0x25dfdbfc, {}, [@FOU_ATTR_TYPE=3D{0x5, 0x4, 0x3}, @FOU_=
ATTR_PORT=3D{0x6, 0x1, 0x4e21}, @FOU_ATTR_PORT=3D{0x6, 0x1, 0x4e20}, @FOU=
_ATTR_REMCSUM_NOPARTIAL=3D{0x4}]}, 0x30}, 0x1, 0x0, 0x0, 0x4000000}, 0x80=
810)
r5 =3D openat$cuse(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)
r6 =3D syz_open_dev$tty1(0xc, 0x4, 0x1)
write$UHID_INPUT(r6, &(0x7f0000000580)=3D{0x8, {"e125007f675931f1cb2f3230=
f25778178bd934fb8d5f3a33fd00004dcb5ef9d90216f96934dc4cdbfee1543dcdd964443=
9425fe7566333b4e3de1c4baaa508bba49deba5e7086dd530e71d1b69e6d1fb3711a9672c=
5dbf1f0a6f5f40429e4c865335b8355eeb2594936b637d044dda87e3cec554ecb0c294984=
aa57a51ce2935c33cebc2323fed8b6f45f33a48f9ed9afe23c229d47ec3e442cc85dcfb98=
664e7d4e64e17c1ce9948aa2702001eeb78ade897ada834b28df0c69c2606a7856a9675f9=
6b0fe1ee7758d43e0e1baa49533aacd3d68a5558b89fa68a25b3a514aa9acb77e33f04d77=
6e17898a3636e6f0561e370daa311af0b11d43ff4d19598395db304bb67439f9808375996=
826ed8369994091a1794018d02ef017e0043a7650e8080728be185b944f20fa8509cbf8e4=
e014601508366d8de6c7c3a0bff1e1125cf0016662e5bb275eb08885733e52b49e24dc8ff=
149cfb34517562b5cbf193a33c5723cfd32e27f5424d20fd849fb49cf3f873c6b5c4b2f07=
7651ec6b0e377dcddcdd937c7021206a897a45392c60d561074fb72c5c50c3bc18c178d9d=
d678c8ef4017f9462554797ab39afab4481dd689a36747b3992ebb3e4a0b5121ebeb23d36=
2484a6947fa59e0dbf6f73ec2ef623a55d8660128543dfe4b2fdb96bceeaad31fb1261951=
05af5a7df1c304a282a8bc6a9cc7613bce88b2c309aae9b9c6c9c60d73982863bffcc2ddc=
90bd58040c737bc8f383355d4cd9769704cb088b014ec222260d6fd446b73e7c31ebec419=
557fbb7da3707d4ff391ae016f1a1f48712f33da36d68ea7c1ea2470bec2d9e2d49e928f7=
f77871f9b3cd0d690aad0c34da9ea444e9233a9be278474883d4d6a51468c0009b3866df7=
f55729e6ed122fd5fc8a9bc19b7384a105cb31ec6cf5270c02cc433f6b02405ff87d525eb=
41e805724cad37c09a3180aada342b5eaad89e9d385c2edd53815fb6f6eb7c4df8cbd4122=
0d09560a1ce25561662a502eda5a180038a1134682917ef4488103d9c21f1320e6790c54e=
9df489d21ffbf7a706cc0e6f5acf90247a52277b84dab59699a579efa825e860a8468bfb4=
d318965257bf6173b5b84ab6548688f8d470914016c6b0a2bc6116aaaea8fba5751a9613c=
36ce8c2ac77c99f8cfae5a99b7823596ed4cd62fa728ae75ec88c35016fce1f712bf1f9d6=
fbd5d1a08bf1df061656fc3795d95a09d30f1f8f46f4d3634578d16a5746c401e8501f369=
8bfa594b82f924beae1b907f18f7cdb5ff7ada7c6967b60311c0ddb1f287451e11d3fd730=
fa7e2ae61c2932619b2d783b5870c49643df6862a4fdc9e80904d7798000590ea78e50c63=
0f745a61bfd3d5848805c3c649419a149a5d3cf1abd0d69ba703ceb33a6a727e5d9607825=
68893a16a89c13d9e7282f982c694ed15115a0d4a4bf9d85e3394c110efee31e66b11fe60=
2a301f36730140af64245f7a4b5b2b2bb05f4f481763b11b9be1ef0450035527fe0133380=
a2511c9908cd996ad89cf42b810bc774be967ca9e8b5d8df4ee768e76c902ab6021b4f5a2=
a6bbe4970018b85effb2994e9472975920f5f95ce6359baeaeb96a7c37f4268823d28d3dd=
26b0652023ce38f656797934e8d5948aba7082b4438c38e7bba65f6c786edf606d0df90cb=
1d5deec8f74f634b1add0363c159dfe9a1add42b978ab98b9f8bab8b51c3f016f67072d02=
4cf93c5c1ba2b30efe0488864c11df974240f0f92c79f532af6267495e946a063bd5777f4=
29f5e1324fc6c99d05ab2b9f42918cb8a65c881b768f740325a3e4cea6b9862f1f96bb344=
175a9a4b1fdd0cc1e3ecc42b3452207eadd7828ea0a86221144c5c52da0a2728ed0b34cf4=
e998673c2dd049181c4048de383b9e54293c33795955da778a375cef3dafb8c3445a58c19=
92fb0d7df1b6afb692c609b50da115c1b8b06632b22fc66eae865d81444acadf2ddcb5b42=
c575c3e2b8c2bbd6e74120ed998d7d78cd8dc257fc6378195ef1925e0fe88628f70540bfa=
d79cfb1db51e90d1f75fcd97eca20f68cad1570ade894bf21a835e5c281b2ba4559642732=
c03827ea7c977f1bd987f747a40d15e73c65ed18c6b424b72a482cca82897fcc1504a4280=
7607d9ecd057290db4bec5860416f4afe394807b530c2d57180b30ded3268aa3e902a120f=
27c0f3b2f9abce33ab4539177d962ebb3ad2602289be61e040789f8c1688caaa0daea3c16=
a851f21804e367196033c4a755c84eeb76768f6fd44af26d2acbdaad19f76da10d723bff9=
0d466becd29781a7e8150deb57066a47b0ca151ce8de7c942b8862d49c918976807a0652b=
f564eadc539307c3cc660488fe1e21b5e98ed74c415f0cce1e7b0d2acc6303b06480f45d3=
1473af618028901dbc9cdc759f857c0ac158daf165d0f48fc8030cfdf1372920a826fbaae=
34441b5b41b051b1b5e2f6074afd59c1c59485bfa78ba6aeb212c8a342a33727c7ecfb37b=
720f60cbbf568d648e110439310bcc2b15fd674d7e5dd090eec914e3a8c48c8a27029c0a6=
0951a648346ab4b97a7bd0736ea1c7bd6ff3db66425cad09dc77006f442ad860f04c33721=
40833285f0500b672b69b3c1d181438c080ae9dc79f7425f6778368b103ff9899ae206aa8=
78afd55835ac7343946a39b7df4a6c978803c6501a706d9f7518dc70abb2424a914f37d5b=
3ef0c8590d53736d5abfa3ce3b46a7a6f431e41e61122e1a15a3038d18d8fafe5ba77625b=
0626a190914610a27873ebb7263374cf48bd7b809b942c1bfce937cf7df9aefa86a5da9b4=
02c2eb7f962b2f2ffa57211185813a405691371f800f5dcb91de41e7223085bddd3c46e2e=
977f187f7ad7928edac4491630edddf9b019b06650c7f04063440ec56233e2a4127ee7c31=
6e75ea7ea65f77fc7867e635bf0dc51ebc1bda73c8aa786c83bf913a9fb606f503cd47e2c=
4790d06368bdf37bb18fad8cf3bce45c0a00c99372918576be5ca36b834625d8f79606b2a=
4cc3f67ba86e2d664ee5b0793da8d0381332c98d809569eef52df89d474c28510eb197b9f=
c306341ac577316856b9b649c48a1090626e9fd76fdcebdf98c7c3ff104adddabe33ea741=
a34fc995820ba1473c3faaa7bc0678169b8a73423dc80e6e5092731052f40b206202772fb=
e7301f38cd5ea7c5a7473c6780b3ffa3b3d79436685e8ea857da71d5b4202bd01a09f2018=
019c6ef6b806a256d7ee116d6dafe90d12247e39973c818e9c9c0dc4baf32c997c78763a8=
ce217415de125a6bd4bb3072e4e25e0b35b8f1d10795142bc3d2d1c013adb28234d1c9089=
4965c6d2b5dfb90af40aa127228d01721536f68cd6e90752461be3ba2e5ca05d57c5da3ea=
403542d54d232489489c45126a35c0830b6d6eaf818b2cfc380b269f625893f77f61a68b4=
aafc6b692cac911e6718eaefc115a5da67823f6704e378b49ab8f18cb4a7b0cc73bae7bb7=
fba89d7c8e269f53733641455e16f4fe63a2ceaac9c2c922c4592c2056ef140bfb9370868=
e807408eabb6941a172ceb5cad2a0c3253e21c16e60a31296c22ce8119ec789ab9df0cb58=
90d2cdd1c6a9c08308a5c1760042db7f91300f8156cdeb605c1f1f826ce77d7704bcd97e2=
71e3310d6654a5c7077bb3fb2df87056d57b8a829f06952868a9cb4a335e7e1f38d56c149=
e4bbaa8d4f35cae2c5f066d0664353fc10f0642031898c831fb7c024fa14a7baeb6a79a05=
69b58508ed4c81f0393363d49e431cfe7dcf457c1cd004a1bd7e076bb19ea0d47017eb95f=
8be366fea9df47b146f920dff0930ba1ebaa00039b10e700b2b6d4e76cff8d0bdd440517a=
354aa419c033f01ba40c139597a9721b1ddc490337340cb5b82eaf0d828348be3497b46a9=
27cd53fc5f5d212586e5de76db8577f54903915f22665b2c57d58d842d0c4b078ceb87f65=
b7f01057126999cb50d7e50516f9d0116266b9101cc3ab3f58fa20de22024c6af7a3babdf=
e8e837a4079032ec0343dc86ae35b208bed92463384951219c9fa0889e6a953e4c99bf396=
c19942d2a2ab0f51331de4fcc65631ae165c4d5a47f40c5e4b9a55be73a9bb0c2ed27c74f=
2ec25abedb034133ed02fe617bc7b628e320332fd7f28d963077b9044f9440167b284fe94=
a2fc845f30db8f80bcf35bde028c18267120e1848c7b273de0db4148ecb81324c4bfe2c28=
d3b2324a701b744387d223eeca18e6fae1a93a169f4fed8f370d260e6c8e03dfbe06f03ed=
5f4065c38ca327c7c05146c8719e8ddaf3d2f4cb5a2eaa7d0fc3d88a93ffd6be983e80fb2=
b9800cd3404e55cbcbb845f686a5a6d27168363ca3ecde8535527a0c86e0c30047676bc9a=
7f6baae66c42a6bc0bb52e91fcb9a828af3f4d3db249e1ec3501c3e87efefe734d77493f7=
040b7e9f535dfe012ba0f1575b24bb5e00e5b5321df57351d7d103a4e98cf86bb0a2ebc51=
88feed1f5f43b0c19c2aaf7dfe26f94aecc95d71788592a6f770de953abd8382de412e302=
a6dd5fe54ee891a97d922acaa33fcb75d13c1355acc457adb3a64c74f3bb1b8782cde2745=
b9cb3c364423de5ae0b5ea0ea1c60e830d09e9d9cc420721fabe860f8b6d91c8a211ef31e=
586f27ba839edee31ea6a9ebc024b20a18e34b07caf229ce5fe2f3ce4bdedb2fd6d01d1fd=
fc144c651d0ffd8999040a012ce7b450f3fc56d50d867f1aa660d445925885ff793aab1b0=
c3d5aebc49c585fd5d524c55fb383f93fe23da0419bd6d423914b7b24640f11178696ac05=
94319d72264bf3e94e30c47ccb26b91a0420b986a1759b96d12311227f0f7d9b8dc513714=
cf2f0ba9cd68d2dfdfad82780dbe951be9ef2f691d91d423f45176a28812de62d87b53341=
cd99107f383da3622a4dd64d7de6cb14da7d529f9a48844ab3d9acc458b9842fd5410f888=
b8b7a5cd62895acbc5b99fc53cdeb52d101c6f90fb2b915cb808ba29a43b405dfb2f320a5=
552fd039242cbc053864d199433256e975e6eea400a7ce8feab64a9b794c830814fd6c373=
c95d693bdc682bcb80bface8e3fb5ed891020d90c47df9d38adbeab0cb9701f317232e8f7=
637c349aae48cac8436b4cf6d1da2074fb4a393a5bc78ab7a03b98b169867b444b86abae3=
fcf76caa6175da6a9cee11ed5f0102aacdc52c9dbf321778bea1b65c86128e3749e638923=
e10e9cb11a34ee50f06762d3c22e8e827e7df6673158700d98a8e144692797f507ec30eea=
f3a02cc818d82c9b30a6d63e8f07033324040e788c978ade31a13430c2c5ef88524eff304=
ea4f2892a507fb8c1b8dd7013f0f90a8571147858a93791dabaa7bf940038f887c807ec41=
f08fda5df28f204282ce9ab75bd472ede29d70d126755572adb36b9bf225dc9300b229021=
a0b704e151201116e0f427be6ddc4ca7e8f50d0272e40c3c87f5413ff16c9a96a3741ec2a=
01bcbeca622868bed13da6bddb782be56892c1e4689e02d50bbbf1386e3bf0c0bde99073b=
867b6918ec50b748d3056b7973886a689bf1cce3cb781559bbf633ff2dd279a92eb6de7eb=
190431573e1bf28eb487cce4349e3f6e1a9e087d75d35402baadc2cff2b210463a643dcaa=
eb2a98534a39e97d1b3e4a2941821095fdc15289632e9316fa517c93aedbdabf64f6bc0c0=
d41e37dce9ca0b5b8a7c22f1c97466e028285ddeea61754ed7dd629ad8f6d0d8a807e9122=
6fdc521810a13c55168243d49fe7a9fff20636855a1369bf9e39ac22e91920727cb47754f=
3dd7c2fd47c7bd102446d11a3dccf7a4aa5d08d45f0d9ab9c913ccb4f541999a7", 0x100=
0}}, 0x1006)
read$FUSE(r5, &(0x7f0000000340)=3D{0x2020}, 0x2020)
setrlimit(0xc, &(0x7f0000000040)=3D{0x7, 0x73})

2.42331669s ago: executing program 5 (id=3D13550):
r0 =3D syz_open_dev$tty20(0xc, 0x4, 0x1)
keyctl$set_reqkey_keyring(0xe, 0x3)
prctl$PR_SET_TAGGED_ADDR_CTRL(0x37, 0x1)
openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)=

r1 =3D openat$iommufd(0xffffffffffffff9c, &(0x7f0000000080), 0x0, 0x0)
ioctl$IOMMU_IOAS_ALLOC(r1, 0x3b81, &(0x7f00000000c0)=3D{0xc, 0x0, <r2=3D>=
0x0})
ioctl$IOMMU_IOAS_MAP(r1, 0x3b85, &(0x7f0000000440)=3D{0x28, 0x7, r2, 0x0,=
 &(0x7f0000000480)=3D'L', 0x1, 0x2})
ioctl$IOMMU_IOAS_UNMAP(r1, 0x3b86, &(0x7f0000000340)=3D{0x18, r2, 0x0, 0x=
5})
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x4, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0xa, 0x4=
, @perf_bp=3D{0x0}, 0x1, 0x8, 0x2, 0x1, 0xffffffff, 0xd1, 0xac6f, 0x0, 0x=
0, 0x0, 0x60}, 0x0, 0x3, 0xffffffffffffffff, 0x5)
ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
0080)=3D{0x1, 0x1, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
r3 =3D syz_clone(0x11, 0x0, 0x0, 0x0, 0x0, 0x0)
ptrace(0x10, r3)
ptrace$PTRACE_SECCOMP_GET_FILTER(0x420c, r3, 0x81, 0x0)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0x9, 0x8, 0xe, 0x0, =
0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0, 0x2}, 0x2, 0x7, 0x2, 0x5, 0xffffffff, 0x9, 0x3, 0x0, 0=
x0, 0x0, 0x9}, r3, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
keyctl$set_reqkey_keyring(0xe, 0x1)
r4 =3D openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x=
2, 0x0)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r4, 0xeb08=
0000)
socket$nl_xfrm(0x10, 0x3, 0x6)
rt_sigtimedwait(0x0, 0x0, 0x0, 0x36)
socket$inet_udp(0x2, 0x2, 0x0)
ioctl$UFFDIO_API(0xffffffffffffffff, 0xc018aa3f, &(0x7f0000000240)=3D{0xa=
a, 0x6a8})
ioctl$UFFDIO_UNREGISTER(0xffffffffffffffff, 0x8010aa01, 0xfffffffffffffff=
f)
r5 =3D socket$igmp6(0xa, 0x3, 0x2)
r6 =3D openat$procfs(0xffffffffffffff9c, &(0x7f0000000140)=3D'/proc/keys\=
x00', 0x0, 0x0)
sendfile(r5, r6, 0x0, 0x100000001)
r7 =3D eventfd2(0x7, 0x801)
close_range(r0, r7, 0x0)
r8 =3D eventfd2(0x5, 0x0)
ppoll(&(0x7f0000000740)=3D[{r8, 0x80}], 0x37, 0x0, 0x0, 0xfffffeb0)

2.36856962s ago: executing program 8 (id=3D13556):
r0 =3D bpf$PROG_LOAD(0x5, &(0x7f00000007c0)=3D{0x4, 0x4, &(0x7f0000000000=
)=3DANY=3D[], &(0x7f0000000380)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x50, '\=
x00', 0x0, @fallback=3D0x22, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4}, 0x94)
timer_create(0x1373e483265b4247, &(0x7f00000002c0)=3D{0x0, 0x2000003, 0x2=
, @thr=3D{0x0, 0x0}}, 0x0) (async)
r1 =3D syz_open_dev$sg(&(0x7f0000000140), 0xfffffffffffffffb, 0x1)
ioctl$KDGKBSENT(0xffffffffffffffff, 0x4b48, 0x0)
setsockopt$inet_sctp6_SCTP_STREAM_SCHEDULER(0xffffffffffffffff, 0x84, 0x7=
b, &(0x7f0000000040)=3D{0x0, 0x2}, 0x8) (async)
r2 =3D socket$inet6_sctp(0xa, 0x5, 0x84)
setsockopt$inet6_mreq(r2, 0x29, 0x6a28c0e4593e8e5b, &(0x7f00000001c0)=3D{=
@ipv4=3D{'\x00', '\xff\xff', @local}}, 0x14) (async)
getsockopt$inet_sctp6_SCTP_SOCKOPT_PEELOFF(r1, 0x84, 0x66, &(0x7f00000000=
c0)=3D{<r3=3D>0x0, 0x6}, &(0x7f0000000100)=3D0x8)
getsockopt$inet_sctp6_SCTP_STREAM_SCHEDULER(r2, 0x84, 0x7b, &(0x7f0000000=
340)=3D{r3, 0x5}, &(0x7f0000000240)=3D0x8) (async)
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0x0) (async)
ioctl$SCSI_IOCTL_SEND_COMMAND(r1, 0x1, &(0x7f0000000040)=3DANY=3D[])
r4 =3D syz_open_dev$tty1(0xc, 0x4, 0x1)
fremovexattr(r4, &(0x7f0000000000)=3D@known=3D'system.posix_acl_access\x0=
0')
r5 =3D userfaultfd(0x1)
ioctl$UFFDIO_API(r5, 0xc018aa3f, &(0x7f0000000180)=3D{0xaa, 0x410}) (asyn=
c)
read(r5, 0x0, 0x0) (async)
bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000040)=3D{r0, 0x0, 0x36, 0x0, &(0x7=
f0000000200)=3D"0f88888c7b1a103b58f55f2588a88ed986dd50933951b5a31c7bcdd1b=
0932ce2bf21bc089a2d7a128b53200f55183f6c6ac8410152e5", 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0}, 0x50)
r6 =3D socket$nl_generic(0x10, 0x3, 0x10)
setsockopt$netlink_NETLINK_PKTINFO(r6, 0x10e, 0x3, &(0x7f0000000480)=3D0x=
8001, 0x4)
syz_genetlink_get_family_id$nl80211(&(0x7f0000000500), r6) (async)
r7 =3D syz_init_net_socket$nl_generic(0x10, 0x3, 0x10)
r8 =3D syz_genetlink_get_family_id$nbd(&(0x7f0000000000), r7)
sendmsg$NBD_CMD_CONNECT(r7, &(0x7f0000000bc0)=3D{0x0, 0x0, &(0x7f0000000b=
80)=3D{&(0x7f0000000280)=3DANY=3D[@ANYBLOB=3D"14000000", @ANYRES16=3Dr8, =
@ANYBLOB=3D"010071097f4e101ed659931c000031f11127de981a8ed013efaa350e0db74=
48bee343cf4446584"], 0x14}, 0x1, 0x0, 0x0, 0x4008000}, 0x4004010) (async)=

syz_genetlink_get_family_id$net_dm(&(0x7f0000000440), r7) (async)
r9 =3D syz_genetlink_get_family_id$netlbl_unlabel(&(0x7f0000000300), r7)
sendmsg$NLBL_UNLABEL_C_STATICADDDEF(r7, &(0x7f0000000400)=3D{0x0, 0x0, &(=
0x7f00000003c0)=3D{&(0x7f0000000540)=3DANY=3D[@ANYRES32=3Dr9, @ANYRES64=3D=
r5, @ANYBLOB=3D"6bb0b0164e136624703e9f984766aae176439578d3242fd91b437d7ad=
41b66d69a10b27872b1996d1d5a735c7841e73041f2d8b729e8fa7152b7b6f97daa7be6a8=
ee508e13227524fa2439c0e40ed8feb65828455fb1f8f1a88a61316951e2e2a4d71b9e788=
3de2bd3bc625d7ff4fdbca885fc13f4100606dbbf7636dcefe4e646d2063e1021c31760b2=
2a02774a0e998e82e678e3f59ec59e0a7f7f58981ec05fab07bea6babc13809c57346b5df=
73ec973095e01", @ANYRES32, @ANYRES64=3Dr4], 0x98}, 0x1, 0x0, 0x0, 0x2000c=
085}, 0x200040c0) (async)
r10 =3D socket$inet6_sctp(0xa, 0x1, 0x84)
setsockopt$inet_sctp6_SCTP_ADAPTATION_LAYER(r10, 0x84, 0x7, &(0x7f0000000=
400)=3D{0x25}, 0x4) (async)
bind$inet6(r10, &(0x7f0000000000)=3D{0xa, 0x4e23, 0x41, @loopback, 0x401}=
, 0x1c) (async)
openat$ptmx(0xffffffffffffff9c, &(0x7f0000000000), 0x0, 0x0)

2.36585995s ago: executing program 8 (id=3D13558):
r0 =3D socket$nl_xfrm(0x10, 0x3, 0x6)
r1 =3D syz_open_dev$tty1(0xc, 0x4, 0x1)
ioctl$KDSIGACCEPT(r1, 0x4b4e, 0x1c)
sendmsg$nl_xfrm(r0, &(0x7f00000001c0)=3D{0x0, 0x0, &(0x7f0000000140)=3D{&=
(0x7f00000007c0)=3D@getsa=3D{0x34, 0x12, 0x1, 0x70bd25, 0x25dfdbfb, {@in6=
=3D@private0=3D{0xfc, 0x0, '\x00', 0x1}, 0x4d6, 0x8, 0x33}, [@mark=3D{0xc=
, 0x15, {0x9, 0x8}}]}, 0x34}, 0x1, 0x0, 0x0, 0x800}, 0x804)
mount$overlay(0x0, &(0x7f0000000740)=3D'./cgroup/cgroup.procs\x00', &(0x7=
f0000000780), 0x10, &(0x7f0000000800)=3D{[{@lowerdir=3D{'lowerdir', 0x3d,=
 './cgroup/cgroup.procs'}}]})
r2 =3D accept4$inet6(0xffffffffffffffff, &(0x7f0000000000)=3D{0xa, 0x0, 0=
x0, @empty}, &(0x7f0000000040)=3D0x1c, 0x180800)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x20, 0x1, 0x0, 0x0, 0x0,=
 0x8, 0x80, 0x1c, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1=
, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4, @=
perf_config_ext=3D{0xffffffffffff7142, 0xffffffffffff64f9}, 0x1, 0x7, 0xd=
, 0x1, 0xffffffff, 0xd1, 0x80, 0x0, 0x0, 0x0, 0x60}, 0x0, 0xfffffffffffff=
fff, 0xffffffffffffffff, 0x1)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x141)
r3 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0)
mount$fuse(0x0, &(0x7f00000020c0)=3D'./file0\x00', &(0x7f0000002100), 0x0=
, &(0x7f0000000240)=3DANY=3D[@ANYBLOB=3D'fd=3D', @ANYRESHEX=3Dr3, @ANYBLO=
B=3D',rootmode=3D00000000000000000040000,user_id=3D', @ANYRESDEC=3D0x0, @=
ANYBLOB=3D',group_id=3D', @ANYRESDEC=3D0x0])
read$FUSE(r3, &(0x7f00000043c0)=3D{0x2020, 0x0, <r4=3D>0x0, <r5=3D>0x0, <=
r6=3D>0x0}, 0x2020)
write$FUSE_INIT(r3, &(0x7f00000000c0)=3D{0x50, 0x0, r4, {0x7, 0x2b, 0xfff=
f, 0xfffffffff7020808, 0xffff, 0xd368, 0x6, 0x5, 0x0, 0x0, 0x8, 0x5}}, 0x=
50)
syz_fuse_handle_req(r3,
&(0x7f00000021c0)=3D"80cc949a20a10570b22f57c72b14b6d5b9656d619411d3e0feb9=
96f638296baec90caf0305c18523d32f8aaf50d3b62deaa3a75c2e016f25efcddb2e4e5cf=
e7a2e24d813ff5e08182e8fbc9353537f68ae28a6548a83e5662b382002990c8b32a687cf=
b9922aa8e8cef4d8f1c1e9ea22d432b3ccdc80e9b39e792b7545ae90a0880cb7f49edb763=
13335f65ed0888cdf8a79f3a22028f6035b8a77343e12b2b48d61cd8dadd99ffe4ccaf144=
36357b8f5c4633a94b27d21367946bea971d2f2cc9c588402be7d1f4cc9c78732b4650438=
da4a781b23ea5cc672d28ce0d78fb13a532779cfe3689e62f673ff4d4edd72d396bc29607=
5a710424cfe4fd1d38ce799c319e58f5b5d76c995ca60bb98f1a027c5122554fb397420fd=
5095c0326ccf221f017dbfdde47ba8180ebb28573193aa67076f503ce05d7950d220bc8dd=
ab527f0117a30a9c9fa977e6eb12024bf97ac55e5044b688f8ece30cfd06acf52743837cc=
9b1ae37af0113cda07abf471828dad657fd8a2cccf307f16e21f938b3c3c03a29bccb9f1f=
4854067c7eb7664f505a7fa433eac2c3e3ba6fc5393e376aa0662d502e91931c8363fa08b=
006e35feee61403c93a78cd0722bce85f680ee04efba31f47f92f1e391e3d63507aa49d8f=
063707900f63faeeba28c3d53cd4dc95af6e916bca9896926775f990b7e528b15014be706=
414ca96c59bea21a312484d3d6434c8150752bccee265c64742549b9bf94d64a100ea1f61=
2de41a7a4f34afc0f47a23a08630e3f90da155f6b5c90dd9a6496e23e80cbe5dfd3527288=
3076961caf332f97dc3871384379b2d6ecafa30ceea5fba0d68ba64fe7d235046347a4759=
f870e5bbf9ab1c3ad3281b63cbe1a9f0de5dc38118aebaaac3d8a42bf5e13489da5dbf0f5=
0a02291a1bff4af669d66679658bd3ac40f153034cadab5e07d743392a491f3daf2737703=
198cbd9f18c90d82dbb276f948bb84fca2bd92160675b5ce96f4e3609bfbfaadaa495231b=
581af70fbc8e2e2bcb249b3a8ff0b45269cbe2ba66b86942d24b086945dc9b4660ea211b1=
93c19bf11cdea937a3699ab6131ea26c4903121760b6df20561fa2a593700d7ff0e71aba5=
139ccfde4776e1e60233a784c72f4b7bcdaa00f60cb93c25367752c624652981121dbafce=
f1c96f3f514347a5adcf3c269df2091400b041d52460fa8c6b81e857f88154d4fce7662bc=
f27df14917a01170b0a36b36b49b0cb69af47247cfe08812597d74fe755ecd1c1ccdb3b0a=
3c9a2ea65c494bbd669b51ab7fdd2bc5e7e5ad459d6a9c9f02e59f7e0aa1f45de43cf5014=
23616d430a6dbc577492c8adfbdfe707daf0fb401239592bf301361770d155cfebbe9d5ba=
f0dccdb358c2c0d7678d6a1ba6e2fc16f1f0aa6b3b9be72b37c22fc76b0e4e5b9fa540f11=
6682f694e9ceaeac5cbc8691a935fd1a244b044ffeb258fb01a035880cb17e7dde5170a35=
d44816482f376d9d48b3b807af0f2138f8b48a47a18207745568b349db4661aee07fafdde=
33d604230e4d340c4f9d9ba0d0ab29294f7a31983fec1a75c6f4394d710bf961b5d4deda5=
09ed7602df284fcabcbfc996299783607934c8e0feb1dc2efb258586e71a0aa5458d50ce5=
560f716227a8d8c19f42f931b2ff0c448c8999863cd85cc5327c76644de795bee4cfa6ae5=
e1cbd8679a32b489ddc4af5c18483b7325937d4a4e77ffd4365d042636fbf8d2999812da9=
6aa1373f082b22c0f32b7d934a3e7dfb7ef7ab62a72671361faf92f291056499a7d588602=
29765ff64168f7faa220eecbd0d238e483094322ddc59f0477836be13328153b83183ef80=
083e8c74d423009ce3699addbc045b3062f81f2609a60ecee4db9ae80e992ccd481ac5c89=
53e6a8a333810e1fcf7073865f67140da698a46fe5419667025febf699b74156fc2fadb73=
7266b0baa6f87a34bb73115b5be02e15eb389de5d1c9a798997baa4410547f8a69af2803b=
d4b66db6cf0a865119a96e721b71ef9621ed7219f1d2497e55883480d663d59d9385ef368=
a6de2867c94fcecc73f6be4ddd6a3f3eb39b5c7c0cdc501dc69f156295e2f5345a9d8fec7=
fb1ae0ae1c5bda022eb7218faae98068c7686ce04f2c8ceec63ed8142380614d7b099bfa9=
455374ef90e3f9799c6b0592f39fc6228f7865a9bec42ab2d10775094a7964a81110de801=
204d434f132c848e76c6e7464fe4904b0e5c82a4b122fd21e69beaf1709c97ad40714b28d=
55db151dc99b8f5496814ca8f0349176ad7ae864ee42497764f39bf10714a2cdfd50fb337=
cfb6e4db18475ed71b28675c5954b078ce1f035022b5a45bec61ff614d235b4b9416ba38e=
d7f55922d14df5b26487a9d605ae4cec69c8396ec66aceec3b15bda52455c36e970dbfb7c=
cc846740226f0c33427dbf45e0275dfff5218940d36a3a06d93d414b0d2ca160b2b5d0de5=
f432d3f36a449f007068d2b79cb2fc019d1a15f6efeeab03afa45da9c1c360275985a839c=
d0137455885ea2a69aefd48915e14e7973ef44844963f42062712d4a8be4c3da27d8549fa=
3d65f673faa5bc6c8947bcda7863743e4f9f2e7dc62eec22fa2e9b669f87bf4c303e89125=
8b91daec9c9cc65c5983fd91a7709b5c7f1ff72faa639ce26ba95f553286fdec3759a37f5=
986c9a7a0ba711685af75c1b04bb743db4d0a39fd191147e2bfe375aa8d6223e7127bfbc4=
95d5bcd4dddfc29ac13a12a8044297a4caba53d63e899e3242ceebad1e6e7ab43f3a23e2f=
d007352866721411ce9ac5e95d46674b2be228196eed9a7329e4d282ecc837215310bd647=
42b5c9ed8fb89b5ee586b6391b57f6d52658eac832b6e01ea774bc5c35ff1c496a8743bdd=
15e950b9eac1437ace59b8c8aa91831e6716ea6fa44bee90f89206c688501a88de558cc1b=
283d4e2dd62a32fb108dc02ccc7d01b2cef61c09403d7256e0a8439828818966fb06899cd=
05dcbb52a9b8238e2f6e742329b170b1286d80ce38796311c94a77c0cd13e09610cd84e31=
2c0d8c9369c6454b98ddb40d6388ee4a16a408dbb589bc9164c9ff89ed34d92d09c2935a1=
e8d651fa364639598a7af49bed103eb975c43162e1f06b51f4c1316ab61f98c00b9944956=
2055f476e1c91dcfd2b6e5c9edfe4a942d2ae04962399ff0f700c4c5a5f4ab819d1a1b7bd=
64767a7c635ee70ded32870d4149359faa38e49e0a8c7a61ab377b3cb19767d3e50c4b844=
ac007d7ca13e61230924c3cea444da8919074705e79a29e0bb1326bdfc97dc5bafa5b74ec=
e5744b40a99c9f4d7a38bdbe5cf3065f9bd89ef04fdb58975284fc36575bd840840f96fe8=
39005743f840174182d9bc84abd5a2a5d3d3d26310ae37534c574c6fa0d442b1fae60fede=
d31010a206019f1df00f2a07b8e576432f4063464e808691cab001c5f68295182c5e34b8e=
12f96eb5844ca66177af647c16bf2c8cd6125068083489ee2672944ce6852e5c6f95edeb8=
6c97c86d4177bbe7a484464355f0ec7d0530c8d4d196122a3997a57a03a0484fa09eeda2c=
00a515edfb31feded6edd66b6513c5a9def92e7923c1f984469ba7054f96af55930c4c928=
c774c92606d8ab63d694cb94c2afde226be603fb7a0843c61965cab2af0e661c336789d1b=
6b5b4de8033da91497a3c97ba9d8d483d2406c76c0e1e00ba9a0901a93812d15ebb0f6a44=
7fbd3dbe15ff1827a459365f8c49c2f6f05826ade87b51175d78e786998e2818840605e7b=
7c4194a9c2f251912d8ae4cbd2674f95ef96bfe662ed7c412e2e2ec8caad8967f1f320d3b=
2669ad65f39b5405ad1bf0af9c65e0ccd1779f4743e211c032c2dda00ff4fa223731845ec=
80134710c732561ce317a2c204eba2bf298f2a885e2348a7cb07dcad2a7baba7a58461701=
63c6378c7ab742fe05ccc684df993db0f062eafd881554f8b44f6913acefaab6c5927b8ff=
7c0f5955c85cc9c70c04b6fb68aab8ae8b19780527aac4aa0c31df2d8369fad0990c884d3=
e0234b16642e0bee5cae0de6288fb1e92c7edf967037e13f07b3f69ff6a19b6a7ac431581=
0919db8499f38039e2399be08d9f7b101bc43a24a09aa49d82f7c235a359e7a65432d427a=
fb910ce19bcdd751292799e94aefe5df558d7f03a6010c1a9d5e2957d94c63ef221ca7c8f=
16c8e639ca1e332c7d5422b2b7b5589690366edbd0cf21ee41b215b84a1108e0e6899c25c=
a16e4f5f0d58f3d8938539bf970e2b9192f310e2d20b520871ded3702dbf5caa3b1ca0ab9=
dfc3563daeff6bc4b5949757a8c2e3ca9a67bf295b123a86294f1250b4f35a0b8b7382446=
f050d2b62dcacfec5c4bd201e00a50d3d2dd97eef43b3e3934392d9ce77262400f2f04ed7=
14ee7a18b79a7ff98fa60d934af0acc351c2fc3e9f416ee164fab7dc0f6067d10b6932520=
c2cad5d0d1ff5622bf8ee5f524fb292ac315eace7d02c80f885749a096b43dde45cd41164=
2282c163fdc2af62b9dfbb7e02005dc40d107c4747b7d749d1607a7cdc3ec29600bfd480c=
80fe4e302164ca3765ea070de833c5efdbc2cb396306f652e00593682a3392f9d2af52f33=
77003f2771ab919c6d5c86df6f5ef335084b9e25564e510b7e1ee1158e4b011043fefa037=
67cb6a4b647044f247f1d24f9d27a95b84347b5495e81b1d25f8cf3d00ce81cb58aa46185=
8768e052001ec35072d1f687386673819411288144a7c92d120dd58453751c8825dff0dd6=
99202dc73beccf1fc161ef12bdca01bc982bc93ff7927b0bc5c076db8077ad0088fba10f5=
d17b50740f14d238315fecabc89ca4004db8990685c51e7272844db7bc1c16be97622cc75=
69f7eb799708b9c44cd15500fc48a577a5ef21bcdeb4b01b1966b46fe5fc1e527a5eb7205=
4265499e36cbc77efbef2f3ed56abe3e9a7fb79027179855bc52e23a635fbc1f97999db95=
312408a2a6824f9d02641bc275f5f98891b1e5571fb985b4aad3c7542bde57186aea7e04c=
23b344aae36e5842264ff5d7f3d97b8fcab46ed86f33d61a180bb9e8422cfef7e9dbf6fe6=
aa1f411e8413a5dc3f1fb2acfca42ee728d684f6aee25e8da3567c1cc1775efabd4300b99=
63fdc1f85f213af53a74fc3a765ce2ccd33435b4a77e78abb45254cdf197a155af61d9645=
6e344c2187b86637ff38ea31f1ae06f0450dc07c4f75483d7465dc1c858c66268bd6dd79a=
ab93034c4bf074916aa0af59517131a3ee7ba071a8e8489f8abfe5ccea8fbd19fd87f13c0=
b79ae9dc4aed40b876d4026dfdf81fbd26c1471b3d089d8f42b59fd4e333895b62cfad106=
43bac3c9b3693ab266e458429332a208fc31f79d5f3bcc467c918a3f7ed6c11978459a205=
5cfbfa66bc6f4842d1a06b6d1002b831f0fbab4037e6437682609510b24964fda2f3a93f1=
14cd309347cba2e957a85afe51205d9a379a3e1f071774b25e02196cd56066b04af86dd8a=
e5d232e34795abe101d22f40d8de9be579b7441bff26297b6acdf2a443ec68162e9f72e07=
2e3c36bbf3699bb24ea36a00e2a331e64d7398ce667a010ecc60458ec1e36b5240fad8146=
e3879e89400c7a1689185d96f3e42c14cb634b8e33c295a069447136d25426e48c2dfa77d=
11c3b2ca5b1ebe5ff49b4b1a216b40f9b6dc823e58d4a4a686d8e24f3ab217b35abe18dc0=
e57d1d6908e32dfc26da5aa1a04e3b7ee1d015226f57bc0da311e7dc8cd2f766f1e4c40bc=
27b7b62b38985f768a7f885884be43f9e13af66592decc37ea77b83d82997f27734f4d8f1=
ec2bcfeb61fb73169a37953a1bc699ef2ae3365c931001fb42ae1d2c2234bf184dbf4c19e=
7fa0a18fd0b374140430aa14edc03b2abd1fe3d2d515c67e7155c8066366cf0f0e4c72671=
a3b812d4b25844e5e1b59de8d1bd13a5a06262511b2f1d43da6608bab3a406723e1774262=
1155ed8f771bca33b4aabea0ba02c7ef8a5ee44e19a09a2a9f298ae4faaa347d3549f1aa1=
5c608fd8f3c48ee91e5d1f7c09c90d13f1e677313a4c074a1a3b6b3c7a184ea34875afc9c=
1ec7d8f4828e9dd9a4bd8a5d101c8770a371c08f446828de72c6b9f09b8e964e579d7652c=
35799693c7aa3c666116dba3555ea37cf7a40b43e1c75a4d8242843362d8f46b13a071ad5=
e68db0394c5b2a89c75a8eab80709d80c8b479e9f98726faeb2c6c2dbddc6fd0824bf0c79=
76b39fd50acc7400d8f69c7830e1a72985f9818e62af00943d4aa9c710971ed553174f1e4=
fd5934d5382659466a9acff619605796fe6a15b167df17991c8eaea0aa300528e2b504784=
66f4d296f7cc667a21fec9e693c4d4ca2c9c2a0e6fc4fc92757e2de37fb7813e5127e6c71=
38d8f7359ee0e97d479161e05c608e2f709729f1f4bd43772ac8a1c4615c4ede74a91e4a1=
6458b0de739721d2ec8b0514a79161ce0087008d3cd97fdd5538c518b24b28419f67ce0fe=
d106b4df122ba9f51af5952a956a0b9c95319f5c49e3f7b48a19dcc9d9f3b5ded21a95622=
07f162b805b628018dad3161f938942cded99e86f51296a815a9eeb1cdd60330a2573ce7d=
cdb07643fc3d5362a87db6a1ef0014bdf70edb584a9168eef7c4baa260e284a5f221b71dd=
72a23d2443a393c7a3d415b640e6ef68b6325cc8323c7441b036950efad4ac9fb10510cd1=
1b06d1c5cc8258dfa0c9e52f09b47828c337f3291d311a450844afbd52de50527d4cdeb06=
121270ce90a29b8f3fe79ea68ad18e2d34148e643a706fb24ff74dd8664abbea9894f2544=
c22f174a9e50d954b6359af53fff54598a7e686c84299c84721b57276c15adcac69ea92b0=
a9abc225bb9a1a6f2254f51aea3da768b324f3bfed0bd4170fd1784d17384fcf16e8cf23b=
ec1a23151cfe2c81894d95599586e136e70ab39d867df88147f0cf56a5bc6d2dff584baa0=
4f7c1ccdb41eae35345bcd2f9c4160e5d141c0714ba4e00abfc11ba3044b566252ab24331=
428160e22fac02d71704bba9cd3658e4ad1edb5dda5e0f20ca2b768db78f9835501a0fa53=
c21a390f894ed62d815a736f6683e0fe841eb881db6941ac4199e1a91f74ac207928bba02=
4490ca79dd212adaad5b2125fc1abde7214e775880daee271128d3b110c1f4837ca237624=
69b3e046539b0dcbc9efdc74d5729f9554aeb11cd4f169649a1e0a516bba7a2744529e7a5=
bad1cc654713015476353c04ada5d5a4a41e80cea1c72bd97ee95aee3298202208ec13ab9=
c8c002ed999ef0c4114ebafc49333ed4e8acb8ecc346615720c9635ceccb2b4aae738552c=
b3a25d00f14fc49ceda292c0ba51e3705c8910b849bc40bce90825cffea3b93003f23eb27=
22057e3324a585a9d28f8407f01f38b37e621537a7791cc81ed4385160c4e4e33b8c43e6e=
e71c2cfdb9b29bc7b62110f3d43b36ed066f2cc903c712bb134e58a37349cae68d9ee2da8=
831738c299f71e8abf9e64186c234eb9c87e983eb31fbf854fd809f5b5e3994fb287db385=
c67666524cddacf77955ddf8eccc91e4ad0f974f56720bcbe28e64ca4aa537cac33a7af5c=
64577d9ce3ccafed63000afe624037cc6f50c4f1843f774227b831e462e6699d31d8e862d=
e7839a6c21642d02f42ebc1f97e57277565a35897dfedeb13b595f89ff9ee7e923e87f0a8=
e218df193da791b5e6b5125cf010ea46ad97e69fba91d5a5f5910fe4c62614308bfae38b4=
93bf47730b2407f58c4013b74787c3b2366e11c56f24864575c03e153fac827dd8cc40b7d=
a5cae79d7348bc9020e8d953f030e69fbdc151b844864b7928983fc52ddb78f7ca9d969f0=
df112426d71b6213f274f4c6f847cf2690ef569e3e6cd1b4690cdb15ee899a4cef5831b7b=
94316a817305b5afe6b7e04bf72b634421dfcc78062f21ace9a094e71e54fa5a68ce305ff=
8d655a4cb76bab1a5f65695068ddcc713f894d0964893f0e8ea0aaded011feb0d7e81b096=
9d62b19c399d303f9355577c1a7ce9f48226aff3da483abc841f994f6d073a111751ea78d=
b37654289d4d26aea096e789cac8fe3bb23195d31a7b8033ec2ad09839d15585daa7de2b0=
ed14dc178df27b1c6783bdf2d63aee1d0d4b5c73386b6c193f6bb19ada653c9d89de533a5=
f95d731111048d727b541f8e130e9b0c698e0695b12d603e6c600f7fe5039ffc0c8e9dd06=
d67b8c040a341ccb89399a097a178d70caa10141665898d836ad6a63f1f53e5f71fd16f58=
92c9a4b8d6bd8653a7ba0a888f746e3e050777cf6d569e43772b6938b65a3a6d555310d00=
3b74ff88afb640c1584a163f3ff30564fc974f2f92f92f4dc8eeb8e09c25089c55781100f=
3d5025c6f8118bdcdac966fc3077447a43fdd25496771f9a7a5f88a1556e9e48f4251a56c=
cce8830bb60905006029c562f7540684cc47e398fa292146b2579652454c89e2f3b6118ba=
d6964176403b431490adf3d108f9ee0c91a7a56b4fff0c0e3461e45d445a65a3108df44ca=
da6fe0c1bc98039188b588f223726e5d18de2805c901c92aeff6ce7f9072e6c065d8f5e08=
a356983abdd55cb89d4062f90c0bdaff31b070786f7957d48c0006a4c59e9705172061579=
cda17c0fc953045cac664c8a63534101cda0fa271f88d97e30121923e1359777ccc9b477a=
ddd6517b5993afb19c6eedc4f052a6ee879233f9d1f3ec431e3aaa787e561223ca44906d3=
ac85523e3332c29fbda77ba95a16d6f99aa893f7df8b0cacff383e196578b76b0f847bd44=
0acbba3d9642dfea94703c39514397ffa671751513c15f1eb5614e54c1db8f9fcdb515e61=
75b13d19eb82edeee6362563ed91a3229b8876e299149a51a40a9718da40cf3236209694d=
3aef482e79349e88e1ef23a79ca484c4c04eb7732ac35733af6cb4f5dc49e5c67bb916ad4=
85bcccec344d387627a3b1b97d7f6c82f5e29313f19e8e42e065eb94120bdd1523a11ddd3=
26514a2c8a54338c5b86328dc031cd07ab66b2b4a52f3a29a33dd776cc33a7b0643b6922b=
00c05f726ea96d2bf9f52c5d88c4c814a1ad9e3df182900176a5daf9006bc0b3987282ad4=
72a9ff9653335110020bd97df97084afc01fbf75f5538bbef39f934d781cf5152aa43219b=
4ec36b5d247c2f037359b02a21931fe187f77210d4d6745963a8cfa379e5e581ba0096574=
466a112892a85a7de6b5b71e8b5cbed837a1216b52aec86c2f132a5b68cab5f4fb8fb4b8e=
66d0b8da3ec9440e8ad3e8652ac045ed7ec82e46e49d0006c1112ab8338ecab8660167e2d=
b4930f1bb2e9fb5687f0b40b40e0dd6b75e78a082fdbfea91da3f07b57dbec8776232f312=
b2d267a8bd372aeb94e2ff2323798553839c961d820d701da8a67a1fc0efa49595f3a88ea=
db8a01c80c239968925fe2a71c4c3571511d13638685f33a2957da0f9b3444e9c1ad13e6e=
eb9175bb188e2cd28e7db490b3f2cedc96c77c01ff7abcf2b27c2086eae3f3b4a1489c5f5=
aa067065ce96108bda1000f636bce346722c6902511ac1a0c688b0f49552cbce6c0543677=
3b43cefd7ca335ded24e17d92c61987bb87693555b8ffe222d30a99ea4ab557994ff136c2=
d9c24872f66e91220b339aa978dc250c435d1d04d460319e0ba2ead5c8329698ce1426d42=
705497671e127266ce256a20cd5b4d859bc5361c5319801576a598f6d391fcf41cecb2663=
226105b6308ccd81c5fcf52c30e7b1d43d1e518884f521ac9d017da826d1c079445be1660=
65ce5974f92fe92645342aab60d5417d1d0a206bbdfb96cf4346023267aa3aeafac6cb5ea=
594fb452635a97f4f87f634b477bee33a3bf0c526c8e5c091e7213659d3fcb8773fbfa38f=
2edff5636dedc6838a9d7e279228a56f89d5a6baccff0461d91d136ea8d097c83993804f5=
4fd264db79aa67c81e966a352b1b9549247fedc317019fa506edba35b0e3d61c93950562a=
6d968c001e24900ec7609a8f72c9d6953b7eeeceda50f237e59c106e16b68145aa746ff37=
35d279b1162cb0383c0ec9d124c94cc4337f21e980d6566d907d0be94b67539b8d10dbdfb=
d840acfa278d5ab3e35a64ee36b2934f019175d946be8723b8c529fe2c171d05e12c471fd=
8de3cd0d2f816fc679273ed18bf0df1953b1e346aecebfb226746ff493b263dc0886dbe2e=
7994a2e547f3c8fff2424c1529f28c390d7e0c6d8829585c41a730b37bdf5343d6396f244=
ebc1c695d37f4b343d9e1a56ef15f808323c465e91bfc8b7f23a71e306128b1cb5da4477b=
7e140426430f458bcdec732d45da8d33939389412ee609821e07a47f218f8447d246d8b2d=
f005ca0b1dc70db2e1800ffede9c04b3a1e1247c4ac6d7f4065ddcd73e08b8777953ae24a=
9d0ec824fe75c1220a20b2e9c0b9bdc5102043f7ef47da065742ce5930582b670a6b012e7=
030792ded6c5d3c4e92e8a27a626fb2594151e5ac1d93bae6e86a89cbd748e35678bc28f3=
aba772cd05990260014607c7348e78da39425b1e13403a9750fef9820f9b15cc16ff6beb9=
fb86277c06873aa18c9509cd3597f31502b6da18fa7ae25ff104db554e2021edc0860311a=
d8956d3a415a3f70058699235ba0cbcc304640622763985a81ad5eeac54827a4b4adcf254=
b3a8909959f9f5509d7207c07cd801bf1b6691edaf191b4ea870302b8d6b51a1539c857f0=
f012204572e32e6d64e2217b7918a0acbf87779c60555bafab138b6edda46d4ad8a835a47=
06a0bf754e7109abc885254949b03e3b2d265385ba54dcabe4857e85d804d3ba72bb38305=
a143ea21f523844e732ab89a42bdc61f6be1f9b28e3386cad2ca92f6c70a613722f3c0c4a=
f72b2cf39d5b734dace0f2e7f66d6c2ef74e141e73cf90c6f979c576a82380249b6c654a7=
b2ef8372896f96f6f766642dacd5841250c97143857e545beab5c3882a3e1d529bb519945=
412e6bfc774e99463dc15bad3f6069c5827ee76897151330dacd669814a58185e301d6f0f=
701908d378b6183bc6b06a8efba3e70a4b790b017743ce08e9bccc686fd0cd725e3ddb931=
1573aaf22f6e49b2c013306c145ed34275433e869a4a721da89de4f59602c5c7a9e54e678=
fbe0e88f64110c975b692390e1f6e896dd322559ab9c629eaec0be9553ea26c1c0360fab0=
2d8e8e16e378976ce57126b434baae51289e916210aa802849b23ec851b1ddbde105bdfe3=
72c96da4ed1a9f4f64464ad704e077b14036fa47fa1c20444392e30da43088e0f3926ea1f=
ba4f2193ca38f7baf44889f45081006acc319e9fe73b7efd7702543c08ae91426fb0333e3=
a347c795adc061d11bd524f5bd1570e0ed47796f6bf068953be6a91b43e66607e25fef130=
5025b9a7558caf9a9cbd1b91757c21cfa254c3ff83f5445c0ae3e70c2f295ccb05ae85c54=
70b893f9768b3c641695dfedc01382bd952023331f6401cd20993b7460f0b5f2cac0779f9=
92570d7682afbf5b2f1caae09c9791a3e9090a5864e895c372064fec3203700cfc75939f2=
e9b79e2907cd9ba03708c4bdd4d2fed6602cfe12b9b6388988fe9c955e71b90fc73405522=
ed1b7579a0c278431e0bac8ef597f398440bda215da819af94b6bab31f79f9cf00394cb95=
5beddef2b97bfe985b6efed138dbfffeff375c2ddcbfa930bf896",
0x2000, &(0x7f0000000000)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, &(0x7f00000003c0)=3D{0x90, 0x0, 0xffffffff, {0x0, 0x2, 0x0, 0x=
6, 0x5, 0x80000000, {0x6, 0x9a, 0x8, 0x4, 0x1, 0x3, 0x6, 0xde23, 0x0, 0x6=
000, 0x8, r5, r6, 0x4, 0x2}}}, 0x0, 0x0, 0x0, 0x0, 0x0})
syz_fuse_handle_req(r3,
&(0x7f0000006400)=3D"d1847629b8b32311f0b3613f2ef7623b7e6c2f0db70d70defd2c=
87cb9eb54d5867b40ffdeb44e9ae36c7346eea76ad680d71ce9523a91485d2b97ca190944=
a023518ab9fd3055ef3a96893578d514a6e1843fd009cc02db44338089416f62c86dcee3a=
ba6aad1a8f33bcb5de95b3e39a6d3c1cf23b34c59650f9131ee357550deca14000d942917=
61d77a4be69d5fea5ecddb7d3bc24cc612200436dae9ab65002f6546a6ca09709fb58b2ac=
40bf14a7c66debc3872b9b50451192d62773640e1fc32c8d34da2b8de1903871d4a89d1c8=
33d058af658b1ed6d8396b1ae5b701eef35eaa1e26b5478a9aadcc7f8ff674a1b34b85c9a=
fe9f79e9a474541e1eda27b903af7b1605b8f0cb56ff8def50491d1a63bd3572d3d1f727f=
6a2777c52a47b2ea0785dd3b599e8b33be024ff7e530ff955152d12c8f2429713ebbfa415=
958d657078941782dff438d3c46ec7336527208e7d76e1cdace8b84e1704972c61ba6e73e=
e42abc5e126c25da7fdc366ccd34e4e25f54510f50d7411d104e20b999a238f62b5f58bd1=
6c6095c3ebff448f704b3f751b7bd8cb21d97900ef1693ddd2479df932ac5c27595c4fbe6=
3bf3dabf627ee763ac4b09425f7a1ce69aaa4e86d4fefbc9f011eb46464418c2f313ecf38=
d260038228f015675fcd1bbe1fd70e29a0a8cc39d9265536b47b148fd3afeff11e7a99e4d=
7a375c9589adef1a2d467d8c5958a435fe35228619d0ecf823014f397cb90bbba46748c8a=
ef37c4d78631749be4625417eb529cde5eb0067207b0831cbfdef67263f5e631392fae413=
ced5c9bbd6f0d69d2e08d69d00602038f2f8acf761e3595200586d54946a0b27e2837ac97=
b8352905df9d9b198d45fbf967e0279d81a6501ba3df534a2846b210be34875d4c10392eb=
f2cd4a880bb7b8f73a70bf225855f0911a426dd3753804947c489f7df4820dacb758a6cd0=
8d416102f515459e96f2d9106b9264e4d559ecc488e562a8e1e7df3fc7e2ad7f631c8e3e5=
5aa6be2f7d3c7b5055e775f6f86864bbcd91260dcc5b96733df038b84941e7dfb06577c88=
5da6887736f8e8c22989fff2e773e406856eac71220a471fb0b67b2e45b158126efb34973=
9f3733642e63f34b6c458c495e5d3551dc3600c6d75a3b4b1a06f59adc8d8bf1f74105f61=
e226a0b80660c061c7dc9e910e0027aea8870890541a090c094cca31dd252520ddb7e98d7=
ef2353a4d11d0dcd5d635f0fb9c429a69cc2a08fbfc07943d910a97a07495809ffa545ce9=
03571b336f27c5061fb88a9d8b5ed82c71573fbf6825d1101cd91883863c073efd4977eb4=
cfe87e6716753076dc016cdc383c3a17068baa21c71690488495bd400d3c93961a73b26bf=
12d60a57edf2dcedb3d9b3b2616fb62862e50c21d783a533159b21635fb316f797fc4e2dd=
cb591db40addff2a21872f1c499008929e58500e4c6f55ba800d58026e05eada9b61994a4=
12f174f2c39923cb1d02505a31235f98d8c523a574121e1194ba4781b5ab4d3223388180e=
37c9e435d7dda498002ff8d3b3404e40e51d4451a52eb3763d79134396fffa3fb15804d9d=
1b9779ed5e31ad6740ada75535d14fb41e39ac7caeda9bc01399aebc226f3727fdbee4165=
b98da6645430312482390545e966db851d035904ae2b064b262bb76f9abf531b9b9da2846=
c26bb4019aec5037b81c5d0dc4d393bd8bfe7daf1d1dfe0b3c96c6f56a5e9d50e66c61218=
2430feaabd865ffb4541ef28014b7fa5b4770231a911cb109c25c596e2df0e25d33550b92=
80e1944a5af2d374e4a8fada818edb964eb7800665ad7e6d33031b67070a37967b03f5f19=
249abcab594c45e6588893f9489f5e176529255918002efcd37fff92421e629bd103835aa=
2bc0cff824f4970c3b1dde2c36afbd169f6177a59ada0637f0087a358524f62d6e0d43bcb=
8ff5870a61048b33f808eb0597744c6fef62d057421f66ba1db77f08e946987140de3cf92=
4f04f75e211f06245fd621d897566cadef1ab84f76a4a5e638e8db97b51ff83494f061439=
1719058ebbbf30f9002b7ff7e83ebb84d6be3496cea286a426df3696fdea1a86af37cfa19=
f2b887cb364591c2fcfe9c2e5a7e0cd6b703e30a3f08c16956cf878d19461ad7b3e5e4fb8=
2f2bd8d094982c47f403e0dbb76b7dc489abfdedec1453fd1fbca1a622e88fb9cac1b7a04=
c9071ee627d6208dd10c9280f24f04c9baccab5206dc54d6346fe077317176a9ba2904f3c=
447a965d4da58d77cca55fbc5de7497e8c02257cc4652d04c9e165d8c0c2851d588902510=
a52403ebbdf0ed412ae1ccf603ee34241a66a80e8a3ab45ba5b47252497d4261c84f505e2=
9d4b9cf31c580eb03aca6fd425b8f987adf82272fe0a10383c2a3349fb2e0d76fac7c56ec=
535bb2f6bb7e022d83ed82cfc5c929d042346da6d939590ea70aef16302ceb2c65f5c1181=
abb9f47a4eee9a2430a9eb44119af9e695119b546b04ca02a9d6243df326cc62f660c617a=
77f759929ee6196a3d7ef87d9329de8ff1b3ab7768319044303341d9fa0bad70f8a5a783b=
1717fd03d4fabe7386139c49262a285d8a11aee8a484959649cbcb76be6f10458e7ac4dbf=
0a01379b4658897193e37b3806149831e4a7a5ddbae06cd9b81115afee98535840e39ba4e=
5a7dda088cda47c0b0a795c55f1f09830473c9f07e1ae8236ecf59761ba6153bdae59fb32=
046bb006edfa45f354384b7a61c27472455291ca07666fababd2a5caf2d968cab5590cb8d=
6edf74164fa683d0fa5ead0dfe9e1027ae280c9c03a77370186f49492187909aa5ff28ee5=
eaa0374f3cac7f100c9ccdc6a355835682a2cfac2a738039a63b69bfd4483d0f758a29b00=
cb25d3bbbe2edd9e88518a5af0bfec28172ac8c4af3e1788bfb966ab370a3b9e147f0312f=
63207ffc2779a02b01644e1a636114862459dc734c37689d9fbf2d6f0a24259f8474d0756=
c971e005c47a6fbbf2c5047d3e074c693dae1b41c8042da7c2f21ecc4bacb93d96ff2621c=
949628079897efd6f42d6a4f225b46c92ce1448abb02d16e8329f0a133757ec1a4c3c82ee=
f0baa694fe13efb73b59196c39d258b6ca8ae25da0ae0bf8d9cb90d25d2393f3fc7401770=
3e9f4f30ce039fec1cc32606e013e518e128c27fd28a0b0d621290a8c1cc2a0ce446d984b=
7f45f919daa957ece47731fbd1db23b0b284c6886a09bd553cadbce93478f5830fc80e42b=
3cc2ee60bbce6b4a61d8cb00b2a92adc91e32109b812ce40349a7bd323b23981b00442725=
674c424acf8a270a30d7f4ac3d05e215d1a8f8574bd40935bca48093c0405a51f25d99bf5=
22eaa1bab75505ddbcab4ec301c85402e233c6850dbec21ef319beee2eed4ab2448b5774d=
efb10338e28a6891d54fffbc71a48ec6ec9058eceaf1c486056c56bb9fa0a93a803f174a7=
2d41db738971b438ea8cd91b7d5b2eaf20f36491169ca149fcab51d7ee4c0fb96ee7e1b53=
a733cc566327974ed92abf15054772fafc397e033cb72e847cabc4bf3ab5d1eef923e7eb4=
6f6abb5249011a7257440317017ba894e50bb20dea98dc9ae97f4d601a0210067356a2ae2=
bfa12e028e594e33402f23b2bd5c772bd930678476c74a55841a23cc668f0b8cfc762c30b=
eaba8cb1c1fd5bb64b5ab4bf7544975aec5f1e23173ade8c10da5dbcf742e16abd2be132d=
af713c2362b77737dbd3dace189e5aee33231602ce46861b83af76630b0dbb0da1b87e2d1=
83cf3f34ca8064b2d0a6784548ae3fc71797dc5724bf570aa99c50277467454a51bde468f=
0e33541a23cca11a32298aa52d573fb98cdccc55043fedd4b57ebe921c1791b5bff68c744=
06dc2f7c2ab1c7d11ac8c83fda5aac9c80cd4cacb8c94f0e0a169944883f2b6c5d1a12ba3=
b79959fca8b54784ec419e048e03371f333300e7e1b78f1261cc093e556fdef5d257bce50=
32760585490f5a5841d98fadc0817c74e86b3ada213f55d3828433c13ecac1e335e399e78=
b2c8555ce1bc175c7d17652cb606f249036f79fd38a45b55015dcf85e55f412decd0b1c3b=
d5524506d97860fd58cd96ab468bbf28c2332810421a56b3356b1df87b4cd44686af33e40=
956c0fa45da43b078fff00f4b56efab940b057f43763cd6d876f55371e7b8514c47625bad=
b6451d72992f100e6708c210935bfae86e96035b1a3d32ecfc45dc4fff58b330a6e790ce8=
ea546e01112dcf9a7e3df6c351aee97b48fb821bbd39f8fc3e14e56f1e66478009b7b9466=
f5a538191399e44860d1a08231c9d30dc4ce2199903e3282b92938a252fd191efecd4eae6=
aaccb99e58aaed62f879ffa9aaefd6a1b5febe4ed67fe49cd940740c226356e0e20dabb8e=
5251ef186a63b7ff3427118ba081d74444aa1c17944ccf30df8224bf54e6d2c668944df91=
a7b1e2bc10223c7903befdd912c2d251e4bdcc69ca888a45b1039f57b4029c0c21bfd5ffd=
d7b5d8e9b9aeb38a6c20a415e9c3759bd4c226875c09e52e6b05b0b20da60c3a0648ca7ac=
4dad02935f69a0c8e4f74c92caa03599e8f20024953cc0908222a3fee8706d9b7251b778c=
40c820641e5c71c1b76110ed270d1841a93e7f6168f3e45fc9e718aaec99ccbe3e2dd501d=
0fa9bb727a039721648f00d1551c3f0fbac3ff6f5fd7c8ac77ea173dd4c436cf5a56e21f7=
0d8bd7ff4e7f7a7ba13049700ae7ef10278607ca01acceb4b35f03caab627f1732e49ec63=
f99047e171a40bf0a11344084a86462fbb9beae092b259e3194d3f19de019cf9b5d25f3fd=
4b05400361ee003f38450cef86fc79a3f609d944a78f52553d95c139edeb846fffaef89d4=
7181d700f95eb5a35d014ac44f5dd3b29bfbbebbc82a13ae00fc2efc0d65f8b4611268e86=
f781991c260ad83bf7c3f62216ffa71f6ed6b99e345131705fd4564e418da75b26343b678=
e087c8e3d30326d59443a3c44d51e96c461874fd0980366c882b1a7eb31d8851732b88ad5=
501488ef65482b8ee7c37142b3919fbcba2247e219834eefb734ba893c255f2af9bebcd35=
2efe6ea20cad9bcb00f393fb1d2f46e7aaa3d32be901c0d1fc181415c4c048fd3ef94bb21=
b898615e6cd41ad7693b25616589d5852ab79a9ffaac813564422a48d969f1c4349c3bef7=
7dd38ea6d522e6430d062d2f9d40077f1166a030e511059ac0ad12a969d5d2c0143f1a387=
4111abb2412282293737b918763f711fd3b6273d4acb243dac25e97f0ffbf411623b4a5c6=
c93c7e5e5fc26563b90073e0d6ad17a7459bde92e6a1f24545a2384f945de8fe30f4c68e5=
cc59707d4c2570fed7e6e9b8941bb07b904eca978b9c2e0a23312ef4eaf85f8bb76977711=
24533d729ee090eb0d160438bc8e4c631e28b1bd0badf0d065f10f868dcbf1fef31834ef1=
e57221dd0fba7d0e56462e815538ac44da2ba70c0698571a85d174589c2394accf8b98653=
fd6d1c54c9e23ea3440accd77eb9a8155ed76d68f336ea515722062c69ad79f1d7538ccec=
63eba72d755b3828c463306f66a7798832e4d3dd598f4a3bf007cfb151734fa1a73a8774e=
bfd6137e0b4d5d3d76552118b040d9c060758438f5108611c2db64fd35935498254133bcf=
a2adc6ddfb5b2f15a4ae2c89e554d82b753c2f250ad8f9725c7b93692d0eaa0ac0804844e=
5a70e162e2d9eca134b9b1c25a5483a54693b591f76ea6d891b47f57ea3ef51808f3d93bf=
74c6c6edc60eedb19524d86e4ea6294ed09d8c45feb874008f4aed864d6404dc892704a21=
a78da4ee3bffd444a9a4c1ef34580c5db99419856187648868ae48c5fb4c391f17f16707d=
2b9c5cb8a1d4a10c5b03eb165e7676c93dc5ee047ed77474ffbc301115a27a8144c7302a6=
82eef28c75c5539e514898ed3d8ff75f24b8ee466ea49ad280eaf84fb49225888c17296a6=
d2c709f57822c660ce5f921123e897d4797ad151cb9bd58d6c38c3bfe6a5db76d72b68bec=
d64d63319b6cdb1fb548f9a8cad9ceca4c167e26219ebd20c4d8e1c7fb74984a98e483503=
2581ca10dc6089e57987bbb4dbeb17e6a211a85107d2b5dfdbbffedd3ea8ce80720e82b19=
89096bd23b05992c0a3e09b766a0e4c8fb486290238237b80787b09d495a5e1b9550fabf6=
17792ccdbe797857a572b85eff0d214a80aa5be99b4ca4ca9ebb189944644357abc451d5b=
407940797512270208dbfe6c320740168dcb654c53012e7e740322dd91f6c2647298050b7=
e8440857ff1a8deaf123a8da923d2f0cea871d21ab154e3aac07f1994851e755bc21cde31=
d132f23d9d01bb51d5364a72afd190eb93a7e96948ddd61993294ac31340e1cd78046f1bd=
ec4cf1c30442c7f62d8bba4e973af102956c824b6be5a2309ca38205f5c5d66150d431cd8=
9dca11db7df2be7abcaf3398c78409aa852c7290497514b8746b1676f89afc27d38b39dad=
5ea4d8bc371f4e4fe59fc4fb37c1e2dce7e213ead05f80fb408780dcf6a57fb3fbbc3d6b7=
edb6398b7b09d85e2ce07015d4dbf3cbaa02139ad16025f1f65bba1e5fcc9216de59ccf01=
32d6a00e05f7da8e84b2ed5f9fa143f4c4068824442b119737e77b85f5b1d10926404b05f=
aef7ee385738531e54d20fc7134afcdb4bbc5ce305ba13506c4400668d8d787ca59097b63=
a270f1e77c455e0a1091d87139408082a7af05ae3a494d4652790c057ccc097512a450dc0=
d0b571b278c361283a6a90dd908925c94386d91b8f32eabf6e6555217a3d11f068c24405b=
4ae1d8eebe81096d4ea3eee410d5d07aefe26563904d86feaeb5bf6c5c53d90ef93b64eb1=
19c6bcac559987c0345171bfb40f7994289d57c0425f6ecb32519b97ac8e8bc366b816fc1=
87bd03416222ea9ac7c9b2cd41173cf4b50384f2e0ecb3c307acdee361e73238c37555fd2=
5c5fca471c8b7c2739bdba5e06bc3db77cfb348af90b6906b2542d69eb83162e6d5607cf2=
3391bac51d60e9b3a8703249853015e0aadca8d4f2306a9daa121bdf76e98c55406d19c5d=
b51a621df62aedc530da27643e2f34ddfa7f91bb53851f9659e17292994a9610e418d7225=
223bb229fda63e3c1863b349a73f7d70493452809b77431f578bfda82867f2837f3d1200c=
ee80019331408006765de7d27f8256d9242a09df9bca29e1c9c727cbe00c6f223df970d62=
7c9e06c07c454a4c4abef00ba2a66c99f92e73eb10b71684c9f4081b5dc3372524fdd76db=
6f6288b593571849e1df8855fb971773497e90ed8722facc63be58092f929c306e8ef8ffd=
327a95068a30b17535ac6f79ea2ae5dface84235580e7615674c5713c42fbaa87b3ccaeb0=
a916d9d737e1013351eb471e967b2562272e68c760288dec5174127e2e70a12e3e8ab3af6=
932fea0abee4bf32e2d609f210e153168ffdbe8bbeaf63e1b2f31ba76e1e717800cd0698b=
cf92d1600edc35c543a2be0498ac78223f62c61f27502a02dbafce827cfd924cb9146a587=
30692cfee526bc59495d6db7c485a5ebd756b25a22ae77aa70594c5ac3850235ff6ab4d9d=
d7a3e494d214bacc60b46186c2fe413d96cf1b1ab10595255a465e57c42b52a124206087c=
7e6c4c4ef25aadfb4a09ba1e7a77147a3ed6fcb4b09990bc65770cb7076927c01b227cfae=
4a8ed1f8e2b9f75ce18f7d878c5544be2d64074d06a75424de0ff72c812662e2af6c7e383=
2df151ffebe3507d09b1e2e0c134b693d3c7c8d81fe24097d138601693d4027920d43f28a=
4b2f73ee1490a221495aa12bfc2cc0d2129ccf36060bc09852e8747d1a9d354eef234dd29=
4f99263295fba3ac5eff8a96bad66bbfca1fdf02767ce0f6ee0eff4841323e70f25640b19=
10856ac7dd68eee19916c8336e670bd8e1385a99918aa010dff6b3cd065a0d8b38d4e9a94=
4e708e1fa38c0e85acbdeaa14d289348833f8980d7c0476ee7783544bfab6cfd778db599f=
02880a386a724005dbf620db610ea2e6f6e02eb8961f22995fc633cce267adf7a59bcfdf4=
da1d2cd35c0371c859a586c33297e17cc0d6ccccb79b8e1b14d5d8741dc2129e09d3e2e31=
b3d046f70c1cc0f2adf963022331225a7bb52164fd6589a46a5950a185246d3d48c592781=
4a9717d780df10d2463f9a3e5fa067385167b9df2d71463c9daa9b3443713701b990a2b61=
e453f68f1c864df5647be3aa14605f90ce4f81462fd80063419fc7209a6ce0b89733c0947=
b4cc9f52dc7b8502d120f855b11a3827bca4ec3e58b7cd211e049c2b67f61852939705968=
bed2e39fecb8b2aeb334753cccf35bcb806c6705b263c4907b3c2bdd864aa7dce74648813=
4759e43d9a496bab4660d826f95fb4857215f312ea2b2e556a89be47337269348cdd25c67=
12f4cca7f485686ea46d0eb38c7b37f82f7101d968736e0ec06a3f3a80edf5eedc3d942fb=
b1cb75fa0dc580e9cd6f17b603ef4f2498454f4676793d4b7c762e898bcf2f5c2e61d9cc8=
d64519770435a46a4a90eac4ae0436090a80bb23a537bc4b9c066cec6ddd46f7f3029e07e=
3479541d7d127b05aa85be18002c59b41d4c6f3630d54c91d1a747aa1ef1c30faaeec4b94=
9199154cdfcf21b55493e9f43e98ad0dd492eed7491041f38f910024160d32fcdd1cf63ae=
0a65d9f6ee1164fce7717c47d9da69ae69dfdb206edcf5dac41266dc4e6f7b94bb429c814=
6c6e50668e7b53839b85b998ccdbda5bb51b74c3a7e4cda7301f3ddafb4e87945f1f64bda=
82a7ba42db1323d7f1357f68a0c8ad8b664ae2da1919dca4f679657477464c5f3d6d995e4=
52ad0b92075867ab3ef7cc7d6230798ed67af4202afa7b6a96a71f6bfdb044c0f86a6fb60=
31a5e8ac4d67ff8f7cb4652bc06b30ff476cdeaa536d383463d07c6bafbca89d06166c3d4=
a1bcf3b9a858d1d6a54f8e84458a446a291d28327ff612db80a19f680e50f57384b4d6ea3=
48557d07e4e7f71d02b83869a5b50716001cee1dadf47e3db26c20bf7e54bcd00f77878d8=
ddbca5687f1d93d73889d70da690613d4e60b1f6a99a430a93c4f6344acb830b16da48122=
2667e8d9d2d875635d55a495902e4b434f52505943712f6a05d90a371411d08fc5b3a7686=
772a6097e603f4c947dd6067de11c5e42f3d43a5148719e10062b334bf4cab4e1d3ba17b1=
0fd5d2e26b67d58bb1c04eff22fa45fe09c2f8441ea889ced3972d171041ce4ef8c68ea8a=
1b73419cb9d7c5b21ee316ed6cecdd96dc96631c6d213d92edb4734ad81465576d032a4a5=
5ed3f03045816703a290a8af40f9bf7b1da8089215dd813fe8e04e06aec54272b6ba48d67=
27723fa7208508f6fbe318ccd66d4d93ed2a584dee0b1745b6e99287cc4eb5ab025ad66ce=
610e85274865a7733a420d7d36de3e6462fd5bfa7f67700db7c8a51a82556fb09993ff0b4=
cc34ec17c19727f38903e8ad8f817c272e53612d79e8c218ff4b122a087ac839581ee953a=
e3134e7899f24d9c3c3349c99fc7f4083c974078d8e20f4ab16e74c418e1de03cfbe3bae1=
5bbf7da7eec27990f41ce8ec747b008872da491157fecae9c71b82836b55a34fd59a24ec5=
01c363db8520d2ab64ebb5cf42d67643911bfd26101777fe02db300c82f9a5bf0eed3206f=
a745e7a2311b6604e8a263dcfdc45aaebf2be105dc9a3c691d45bb01e36baadaef8e47e2c=
9aadcbe9ee2ae2fead646eace3ac7924dabe86aaa06e688234586a7ef3cdf6508ea3fd65e=
f0ee0f8e13919ed96b4f94f2a2c915c2377ff159c9386afc24276dd920b5449925d4b41b3=
9fc60902e03aefa57cb00d79ca8f14e51ba3fc9a0febbcbad5b5982271cf161a7bab4fdcc=
7deb48d3e7d125f171ec55ff0b5416de9f7b323c6002780286792ba3ba3dd3b7da5ad71aa=
7eecb7f555d1d80d69488b1a533203e767456c647fff0e4d01f81aa1673cab0d5e2bc234b=
f61c23b00eccafb9a6520600d0891b6609690891683ee8745516d69150f8e6bf4199798df=
436e5a6bd33d2d787d210aabeb423826d1ae5531343ac2c636216d91a4a467f66a3af2e00=
ba3c8ac8989187a59a8048e45db0ff4bffae9a6927796cc9a33c7300b293fce6755499554=
787adb31e8651f3d91ccfcd297c3517fac4585b12b85df78c186e43ed0923033edcb273f0=
f5b0fa357cbd58bbb134a3c29e063f907f6117cc34ab6ad66c8762215ca59ffd216a77063=
6ee82a8e605a9478d3e62a84b4a42713c7218eda3aa54c736e9c450dc497287baff675ea0=
10465897d83621121abb1940323bf30c6192f854af5611d9b5c2ac5a58cd36b9325f11e65=
7c4272f48414d0b82d89cca0be80cb4ae142f6442a9527ad0ee8deba525aa5cdeaaa60305=
10b8b2a1e85c9464c255940d968deb07abd463e18a68252e86f58a0f7d284527af45f769d=
e13dc1f06ac736ec7e5340d9ae9370a83a3fa1214fd84f1a3dbc848aaf178774df75ca2b7=
c09ba28e79759d747832841aa9861cb8efa3788c863ef5f949b0bf00d88f811dba5e91461=
f7d571d236d2e4aee29723048f9ee95dfabc090788d5f7703887fc38670cde115e75a3f42=
93d6e916ced7316917e4c8d583d949b3e59bf77ce8cc549a359ccc7649ea23adb0c164cbb=
6b97c8c4728338d993735a6bf18d89803e4b97c3d4bf3701d72bad91cff3c83ce0d493f91=
45fdb7cc098f63ab06247a8212b4862ee7b97bd1e4460dbaf6dbac749b21e97ea0f4033ab=
85977f1f6131afdfe1d3830c5fa4e5030d8d8930d890304832031baf11b17647f906d79a7=
11c8ee99855d4d7a00620864b9495c7b248ef9bedb29e8797afb9532da3a92dd6c99b4ca9=
b20539e5abc7d30778365cd8e1498bd9b9e7fed4c080769c45a2effc7ed811deed99a522c=
a018ac00eeacc402ad04e2e3348378eb9c9ed40abc416dd88768f21ad1d09f792628902e5=
177c95f259de1a73cf34a612d88f81cc33f8a5c3da0142eb906caf35f3787a26683a2b573=
a1f0b728f290bf74d441663c1c04be7deeb9e8493ebb29294e836cb25417d499cca7b7478=
26cec62d1254eff8487c5a91b203e95d531431f12431fb6522dbf0a702b5a41b4919004b6=
1455728fd3e47f56c96268c34301d05cad4014776944b33b4446b51076e71c691b4a190ac=
f008574977b74e10102f4dd272beab646ddcb0b4dab6bb511a12faa59a1b4dc3507fe8ad1=
bb8fd80c98df3e3e95551b816b583eda74f80efe345db19df93a355e2a22896b033fac066=
b370fa34e383ba957ed1c181378d9178a71d7b7e208487ae7decc0b9f56935b5e1faa29cd=
31c6d511c2997def9fd3747b416ec38196c8b5c0bbc845b242ef71c3e6bb0d704f475a33d=
25a6903c2319351324530c15325848b44f4cfbb05ca48a02cdbe164d35a66e2d7e02ef2d2=
37d49ad4f9defbea01db1b5d19802e28056382d3cd0077e2c67dae84704c99468a9e06c6f=
86c06f55249aa97c6d4c59fee7117e9fee9c21643e4af9b38c345a990f6c09b079243ff3d=
5ff14897e4b0740103e7049f13f467184742de82bdd71ccadeb8defe5c8ac6f0dac16fedc=
fc3da536e8d7313f0576cbbb7e18c89bccb3a30cc1fd39797b6874b2e9c69465c12a5be09=
4c949e8a668c47be512ea5a99cbe20c71dcfb6a000c7ef5d72467",
0x2000, &(0x7f0000000f40)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, &(0x7f0000000c80)=3D{0xa0, 0x0, 0x5, {{0x3, 0x2=
, 0xffffffff, 0xfff, 0x10, 0xfff7, {0x1, 0x100000001, 0x2, 0x1, 0x7, 0x4,=
 0xb, 0x101, 0x4, 0x8000, 0x7, r5, r6, 0x7, 0x1}}, {0x0, 0x6}}}, 0x0, 0x0=
})
r7 =3D syz_create_resource$binfmt(&(0x7f0000000080)=3D'./file0/file0\x00'=
)
r8 =3D openat$binfmt(0xffffffffffffff9c, r7, 0x42, 0x1ff)
newfstatat(0xffffffffffffff9c, &(0x7f0000000d40)=3D'./file0/file0\x00', 0=
x0, 0x2000)
syz_fuse_handle_req(r3,
&(0x7f0000008400)=3D"e74f080cffbe801ae5c799a00979897de1bd8a492f79529a622d=
7095540e51844f1fdf2e49b0ef63ce39e730396d50d0654f490c9c1dfda37aebf34290ec0=
a917abb3c6670bc64ad75b8bc7672b57c6198bbd4a55b9bdaae4fca1980ee5a93cb1969f0=
f522b829ebed393233c3326dca964301dcc2972be6cec1f159b23b67619f5cb0c619a7bdd=
09b273fcf9cdea8addc035df40227cb0e817c6d331419015d2c2d666565585b232ccd6949=
78f04e9c86429751ec580372d39eb72406ffa9987c88741a51c33b8074d7392cff80643ec=
5b25ee7a46f0df058919a2d465cd111b2bfe494be944396abdd1acb6dbb1e4a1965ae9c03=
e2e9f62b987737f53264483685354b0bc5bc55e31876023dc7e5a4bca5f45c56e509148a8=
d45a2a6934ec2b56cef8dce046672ef11dcca6b39b0435b83416ea20791d833f7de2c8f46=
88ea71acd9e5883f9db451bca4d3ef6dcff4c913c3c7311b3cc75f91ce89df176373d7e63=
8ff712c566e7565c1c3476788fa40e60aadb12052b32a64635fa26688dfa38c84ec594877=
43fd85699dad322f2575b54b4741fdc92f712cd66aaf2ee9de145d28101ae663cf162a32e=
55a1de45f89a9a8c58589562acd84ed25387f41edcfa129d2135b0a4fc92f7064fbad1517=
24b871b8c8cb25b56118991cf5b151c7ce712afb8883eedc1b313611b7dd584dc3b017832=
61bceda1194e21bc96472fb8d7f4ff6e5d1b0665e5faa39ca35de2568cdf8d3b40bdd5d57=
7bbcfdc9d114ad9ea66ece2ee58104c6083592cf0a6b6d5b36a269859f6af036e1d69b9ce=
223b6e14295410ff88358805478feb397867c476b99a791cae4604fb7c51b854e85b744d1=
20c385b236228ff931d80268954531622f6779c4c7b99be6fb16d299ebd7191f14535da08=
320ed12959cccf337ed2eec98210956ecf12ff1c8f989b8c4a9e1b21bbc03a5aa3fe82da3=
481f2c908299e90384abf495b29930ab2040ede9fdc8799fcb7eae75446400b7b158a64ad=
730d17dec693f42d911ba88229f630eb574d47f8b5f859cc1dca0e735fb9d5e2eca2c652c=
235491705989654b2ab93b857a29167ddb823ffaa87add5b0c1700f93d24d13c4fe843840=
41684b03974cd5aaddce84a96f08c523590a8bb7e2e10d95ffc8e123d3bd6d99661367bee=
a11c1e2d3fcb61fec93615cd50ac4457ba2c3d1c8fde9823f8efaff1f78c6d3117dfbd017=
db6a46d4e1fc879c6b903e36af3415c382e77a88ec6c1afd59cd86c512a4ab120f0fe6be0=
37b7ca78b1665083dd465a5b8eb75bef79b618cb3e24e355dda89a07d12160a70b3eaed4c=
4b76658ad8dbda4794dd8406d0ad0b7b78260839f6869d2e975b002620b185bf4f387c9e8=
29e3d22750ebd0629fa9c85f5a18e185ed63b5bdd735e0833f5f7a573555cf88836abf1bc=
08929b50deeb30a9664e57b738bf23c7f138623a89a8b6ec0690f18c42e23ef9c0632ad0c=
7f95a016db4d04d09a67f7e4985a380db3757a7f5d4f8bf1121f94b015bca5ed6acead9d6=
ccff5de4b8af816952c18f20bcd72ee5947eedfcf44c2f27ccca348aaaf6c76a8c9b6babd=
6b86c36ad45f4e0f9b3156a20f3c478bfa506bb04bab764335c383d4f81891e7ca065d5c2=
a938dcae5676ce3d7bf8681538a759ed5d06d98a1134e497339be88f09c9db0df48f90a90=
caf1bc6ad1241433af63eb44085af574f04a06ec0ff15fde68feff0f62fc03028fbaebf6c=
9d1cb9939633978bbfdf11371c78d73a00249f82685f16ef14fb23e652b4d4fcfb4d9fbd6=
c72e21d2b3302874e1ed19796a35857c1f6633689e3b91fc2ac2f567155c8f77e774a839b=
dd945acafae520ce13eceee6e4b7c76120c3647f9bc252535a118546124da3349c73c9719=
e36b04ffc691abf436b17e828e5104a83acafec00ab1b71c6b279c727b71189da794cc690=
9e6c19e74bbc74bc3880b788da9c3f4df8ea8d5acad586464934c6aca7069ea247344e75c=
3c9de007ebf142b1e4d2788e76dd449933042aee0061550dfff6ecc54cb4883ed4eb9dbd4=
5e56b0975b0554e6789c0969f8f39f196fefb099b27d3a2cad81cb10a0c8221af77d4b5f9=
2d6c298e55118dc5d012d1a0dafb0b16417af1bb97a44370308576a27ac14a6ab9fb5ed7b=
081756a240a1bf06348802af869bcab1c376f39608187f5e0db3a9aa6370eafd35560d43d=
3855f2145cae625ed0e7460428ead6b35118ce383378967cf0b3661ed93fad1b1fda6b905=
fda421289eb5fef8a42a71a93c41f71ede96bef6ebfe152341decbf6c3599e8688eb63e89=
b34731cba38ed036fdea3182acc059fb8df882c8d021c846e1639ee6c692795e5cd672402=
fe4bb0cd9de13a9b956617c0ab9245aa4012a07afb4885d12a7c21d03878c7370b12510f7=
61eeba9cfcdfc531883e3154e21c954d2abb8e34bf2f6ec1d42af394f6ee9ed522eda00b4=
5e3b2cdf23689675d8150b8e4324bccce8b153630ebb23b20539bf7390cbed3ca9cc2ce7b=
31357a13ddc82789f0c335832942ebfa756161bd642f9be5e11fb2524f0c9d6b0f087b779=
455f5783fe6c74a8b061577add264c3d1413be4acff5377332a6a20a93ea0a5d4a5648995=
c6a61998c5e9d9eb0f4831fdcd5e4097ddaea9f7ec84c1261dab145a4bbb38005f0663d52=
5f43c01b967868bfafe31c3aa5ef5cb9b192a2fa573dc4baa7caa99e0d4b9a298c97b67ce=
444734d57d285d5b0cebc71b76b137961b632e824871f8f615bd56280eb5ad5a0c2284b85=
9b35dc3281067cdcfbaa3f89a0c24a08110ff964f6866e8abf326b3ec1c2edf1d59a24938=
f8b40efc69a9d7a1ec5b5231218db8107530072612da92c5043e893ba927e32f9e46198b1=
37485e5404a429b598e1abdc9b7620f83046f0a66b09b0e0df4f939e6d977a975ba0c01f0=
f755c699e1ebbbda25f1d77687c01388fab5046c4cf5e0f5b6b5946b883a9834d5a2e116e=
0b81694f225e501c5ecafd12b4a48de4adf316015f69d9a5b607a6c3b19bec1881808a613=
b398a1f895570c95e2409b133bfaad9ae4d4c791628da5bee0ed128e720dbcc6b3e11e521=
97c272d6378b5dd127650aa55fee855a67c60670e410e88379d1e74b27a663b793e35f6f2=
a2ba5fe162052c160a61e9cb47cc8fb951411beb79669a1b15008547866b43228ab392ab5=
7a964f3e02ebbf7d5b4620f43bc3f69dbb15611e56faad9bb5cf8353045cb460f72f23ac0=
4a6c7e94f00ced3ec406398bf2bc49a01887e5370a5042a38a142b179c8fe8ea4eb458512=
6fcfec5ca9b29b968549a4cd4684f02ef8ecc77b43aed309e8df3e40dffef1d94d9b29a37=
b819c36b0aede5801dc45bebcfcddbeed4b382b356c0a1163740ff8d9a52d438a27f635aa=
300f112fbbc1ede9bd6ffa0e13b6a57b2b01ea7aa740deb618a5a8082db8586b4b05c8299=
f6255ee7f9c59912e1e940e730d38a5cf3bf51cc92ed0d7b842c0f16932feaf89dd7792ec=
54ed8eb36e1950bf974a084e78e9880b22ba3196545372a20530b1a5151d2c68eeb15ec7a=
e14501b34544a6f923d215c0cc24936765f9412d6f48fc003e098adf38a0184b54a3ccccc=
21c06c53ceadf41a7293be104669a00ef6ea579a118a866a09c882f49f3c08b04431022f2=
5baad252a22163947d853bdb1101a0757f061a576813d3216e775004f6ab093b5e41c0ee0=
46c4a6261a5b305bfa0c5f35b1e155bc11be7b70a8496005a050204a62d6b266a08927d39=
156643a58641a6b028a860c932db653cd24c75ac1efcac1533626fe08b9c1690498927a66=
7bdfd07a066f7a77562d03b3b481be4bd322bfa01c910a5512976db66cc3299770bc4eb9b=
147138edace54105b32d8a4a720a1392ed87d7f1f4ddf448a39b6d36dbf3237ac04e3fde1=
313df1cffe8e56da7f610b3b4a07a88f937a8f8e3d1985e222051368e75aa370ab80f4f40=
15c5ee7861a517cbedc1d8b66ac9564633fd9644fa33dc81fb060b9de6317ca461d93aec4=
531d2faa7bc870195e30ed58b898a978d367d3585e54e790cf87165699708d655d78f4ad6=
97d1ef85777f5dbfaecf676634937205b94b7cbd549b66fe723e34b500495cd962faa6da7=
35324af88403d0d54e8d1f63a961f2f0c2100b4f7fed868a2afee72fbf3ec44bad71f20de=
fb21eb3be2ab16a9cdbc3aa4832d9726958552d6b93b9dafc039cddb2821c939a9181dfbc=
7ddb7e458d4dccc9c07e36ada76995e3e704d13b751078842f7c529476951a6e9928d6813=
5c4c90a5674b46e243c755aed541d01a6499c78f788182db9205dd0a784eb35c713a1ed9c=
c6d2e8c1d74ede4239cf12e6419cea37e2a0d63c6f28f6b66a3d9f7ba4b75c3cbe7b8e424=
dc7ae60825156c50d51152cfb07c2a8bbf0cc0be10943669479797531a3283ae69a2f6495=
a194db3734e25e1ae669847dfdfb7c8ebeee2269351444179c5730c5145763a9b419b50e2=
57558bd5a3ebdf4d5e66eaf8629144999bfe5868c0aa3298b8263b73189e2a9db447fd12b=
69873586fbc065786cf145abb0adb15cce8377f2dfcd1b083f4301de05789ec38eb89e170=
eb15fcb89777435272297ccf3badbf4b67ee47c076d50df233dfad6aab8127c2079e3980e=
e1d8dd9d5b8a3e425f37f84085972180529ec951acc0db203df4b68bba67cb632ea9fd510=
ab5d3eb4068d07a61a1da0dcd24da0eb0b66e53a50090f02555b899e14a61f81d10975806=
dd9857df23e95ced5ae93195f381d94d748573b344704297f2ff1113ab51e23209c72c061=
38988d6e11407a68ec7954a300a0316cf3912305c3c38e3ba69cdff9edf7aaa589c4a44df=
0ea98783e100a6e402ec77140a6de82815efcb7640f9030111f580ea680632627a7718ae2=
f357376815edac21c291ab230e1ab1941b8cee4be8b9939e2876558cd919ca8ae5334e6c1=
3a0028bfbffb284b94756fb2a6ca1892acdc577f75f72eb977721b1bc0c4802a81c5d29de=
dfa5e12ff3e7d7ab421423d6b07a9a2c6c32d765f9f5979f06112f62301f0340d540cd70c=
3b1f3a33856b604a359563cef00c5c8f6d9e40757d20255e45efe7674b99fe9a8cf75405b=
d3af477f4f6913daa59de81647fa50ded114c2170a5b51f11a6554fa64a51b615b2cf72c7=
c046168c346bf6a92bd90b029fea6ea0f14940ac78cea0ce8977896c991e4c4cd5e22f53d=
d36741b8490962d289585e4e7f817ef0c3b3b580302334e7e92636ed87acf6b393d32eac3=
38e9b4f3dd1de68a2dde9abbebffb8cbc65a2c1da5f5f47c56e7604f949f0c8172c626ccd=
02b0a482814e09a7d11b928ffdf28594e24d3b43264ce10ad9441df9e70abafff015c6270=
83bf80eeaefe0e25ceea40128e49075c7087d5a292d059e701f9b83e0dd07006a41c7eee2=
410ec27fd6863f2b33e0a2f871f22125f9b0e9df2c19c6a21a9f11edb4335338f273a920b=
4161d69432c1e754c82abd2c9553921c28395b6e5b9d05831687f72a1ba2b20445e561c1c=
8a23617bdeaf7f210817a9faadc3e89da933374c0898576bc8d171973e30a4c108aff1665=
76777f673cdd1c9a0d893391f56fc379b5c55394b2dc9773b58064b9ce34d562d83dc13ee=
9ec4fa7c3e245b7df1b02c26a5a40ee3cb57af38c2fd3316012f4bfbeb3928e7051109a26=
20bcc53d9e9733ac887849664f7264f6478a83a6827ce3ef33f495aa29a6c32b35b548ee2=
22a8cd3f0690a82d8a171cda57febb478b2f63a07f74d2d3399357baeed5055207722c8c7=
4dac1202a5e6a833d747b3077bfcda108accbf4f5ce4399df2ebedca1aaf5ab697cf5db56=
80b6449468919671609fcaca59a42fb569b6bf39c66d0afd1b2eb29fbaa1017c36e559463=
180e53d8b09ce78683859323273c0863b1fcbf8a1494e733114ac4fffb1b16641f3e52338=
11d18f314fcf284399931402c07e24aa064110466bb429a478e758e2a33331a2d484729c3=
39c0c9b8bfe7010a6edd568bc817e41b909ff1f27746ba160df597373e61037cb747c80ad=
dfac0d47aa0bf6d7e6f821bf609cda9a8626d82a76cf2647a10940cea0c7c9afa7c2c727b=
ce61791f2a9bf797dd7815559ea48db3bd9d63ca16eb3c437c9d955eeb8c0a0993137ee22=
9c0b313776fb6eb71a369a73c80b6b757c3cf1ee82972c6d34e1f6fc7e80669ebc9a3cc9e=
67b6225e71b71e42882b4cff08675dce5117fa6595b909ad2696e8abaaa3b001e5a6adfa3=
c93c34137b7557dfa458112017b9c6364d32ea27047aec0f872ab830b8719ff366dd173ce=
bc26f48231bf3d869c653cb0653e19a568c4ac302da70843f6103d7402035cba756d80a65=
7f8d76ac392fcd11b2fb659a2146262cc854e06af1a81afa330769b4173ba286586204ace=
3101214d5982b620cca51d9083c0cbab152a0b5bc3911635e4fdc6bef90293cb32dc0462f=
26ad6b829cda556d97180321b5f25eab7512149a6e05985e3e7854bf7ab4673a8c68007be=
1af527e1be6019b5321cec2cfe42c23274a84114340185d79836d1084e703d3f3f913a1e9=
14d2fba5166e4a1dcbbd74a6e7173dd635192ebd7976fd948cf6c2bb6099b3fff302ebd7a=
515a21bca350aedff8c7e7594761559b4a81b43a73f07e931a1c583708b9bf73ab27da9a9=
f4a68298da7b2086735250cdb1437fc232962ceb3dfe72738fae5bbb5d9dc4413a2156a36=
8328fd93bfe9ac9444b1e51f959f693ac67fcc35c057f604df7f0866e689aae5f86fa8654=
2a77e43ac62ca9b2038b6db632a861b55e4a5106faf8d13c339cfba1a83180a64ec654613=
4e0e417a46f95481f1834a1240b10637961c881eff5390ef17a33a30192c6994c80ddcf95=
18afbea25d5da0c82b1b15469400dbe68c187ac7fa9c93e048606979cdc6bc121b4809e4a=
d1edb9f8452ade4dfaa2ea4dd33c8b368b2c37abe6c3e2a31345caf1e66619415578a7318=
0655b2d76ac998306e24d07cd949f1a49845aed353b858a6f930c4f471022d2f8f4f1ce44=
f13b48326238f481b9df9cfd830aefc290f93631dd5a4629be899396c3f966c01760187b2=
6119e483f33608b64bf86f2eb0c4dc01df6850ea431ba26305795e99c650399aebbd88137=
d223ccd92371ef4005a7821d917b7b3f8f41ddec25203176c214bae89aa0b1228092a50a5=
e7954f5d86f69fd6122d71e1a925077597ff873af0afd415d696c46ed1f11dc35fdefbeac=
816220263d2e4244c1c8cfaa1b635f50b379f0821a60a41b0da40f0ad71f60da6386521b7=
d3b54de581fe1ca28b30250cef87389a0dead1085fca81d4914a2dcb7e33a160cb6bd4796=
d1c18b43d45cfcbb5b6c49f0c691704288040e11ad7e5aa4783ed3fb77d759c12735a1593=
ff76e0a22a0a74040dcf7cb19d9fd303e72306ae96c70ca31a1643103e234e7aba9eb57b7=
a5bacd97ccaa613b069d32362c331622066600de66fcadb1e5867c2a4389dc3698055fdc6=
ff9ccf4a7f48209da1b082da606f2e13ae745cee4b3be0139b82f3529df99e2b0549c1cf2=
2411435ae980d89acfb1d9bc183c588ed6a29cf71b32a5fd166eb696f7c73695294e8f8e1=
30835b3b1299f2caed323f15b3e64d63847775a8fce9260f9c315753264a68388078eed2b=
1835c698b02e13be97eae29a9a2da0e53387a03133ae232fd86a3d494a238a750ceaf0edd=
18c343e29c133a22058d251b936f6d6640066998910cdbe87b745822fdac3243203dc7d5e=
1f6be72c3c24ae8db4a5ebefc7ced27db50129128ac0eb892e0ac53cf5e817f7e328c003a=
764a2fbf6794d5af4e695583d669bc1cdc0e700464efe3ad6862413decfaf4a086f1e23a5=
6d7146320cd2bbb7bfdde97f42d75c6fff42e2c1f676497335225d6a66aa88acc0d7e4d8d=
9d4865f0a6fea0c9f7ff9586c43fb501658e428b37354a6ea3917f11d1ca3911805c98d99=
44eb50ac721502f8411e078e3b02eaf491acb6f19c325171407bbc57734a8e6a7dba6508c=
60b0e21a2d7bf3a9563db68a842f0198dec3ab6594dba8c8d039db35204878ec3cc419232=
81ab0793284c1938469b70e3d153d8000fbdc2222de86dc504407f0f7ffb7bc89f33aa71f=
ce871713888395ff2c3e5d0d8311ea38cbee9cf6d7e57a1e9d2930dfbc181f7858015d021=
960461ba263e80b1d513213c9acfe0b34dbd6169a94e101f2c703a69a52a21f72e07b1bda=
1b691763ee4a7c18239642778ec6a860b0f3ea87bd36612b315b9f08a2683282967ca5cbc=
cf36a4cba3a00bb9db30dc3a10f1ebc71dc170203a62278fb75d17c5f2dd8ef1fd588f006=
bd9956b1cfb078efdcade891794301d07757b7355fc5e84fcb545c5fc1034ed05fccf52bd=
e47d7d48b71f60601574843699b2e434a2a8bb62bdcfc9d34be8ceb4e970ddcfdb679852e=
2a1cc912f2a0aa8f607f1aded8a5349696926d45612b66f216dfa5caa82fe02ab23f118f0=
86f420b53c5ed04da1e0e54ede14761f288060890015a34185b96c95feebefa69e7f5983e=
d1e638b298a03c6bc2ef15a61b2d96ff3ac0b115cab04101cf6033cf2704cf039859f6698=
508fb21085b6095b3753b1d93cb0279c80c5f89542ac32c73d6955905c276a1f3bf6eef67=
74e511b23ec3844c175afa122ee94b044d4b729dd9bb747706cc73755776bf6d25c65fee6=
cbfc2fe866b79356b42da4052601275ebfa5e204894090750033fceb6bd34befeaf0e4ce4=
ab26c5dc7df873c3c45937a0f535725fd46914e552d9ff944e6648ef4109642643dfb150f=
5e0de622b774ac3219905b06d7cc84b4f683c9d25aacc34f8446a473b2e072946760f751d=
73107581be86f869efbf43e7e677b64537ef161eb1a3524db4bc383ccfe08b9d9fa8128a3=
8929a39f8c3c12aa407b78f33441d15e1b7bd22fdccbcc9571b3b229a67afb1ffb748fdc6=
524bb03cddf18312560354140a8950f6214191ee5caf7b2e1ccb88c3a128ca2fb7251ae29=
a3f638e1b0fcd6d3e80e014ca249f2b0886ed3d130f40dce59333fc5efb3a069c3760151e=
9be4f0504d1c67075659688770cc61b2918b32a27aa246959e82a5c88acf78360b2e71ece=
6f1f5b9fa3a8bfd0417e8651a9eb8b1b5162dbc418249c4672e111372a1b1d2256d970b23=
040f4adbab516aef11ba04d9f7bf3ede28e5ffb3eb1c7d075d784ad461e56ca4f938fab5e=
0277b438baf7aca0c247dd37da3d6d0796b43704176ea644041c44bb5dded780e8d7b59b1=
4df5ee7dd96ae815386d1549298bf7aa97148f51b27ef2ec476d1aa92fded47d95fb9595c=
73163535cc5609d4e015ac690a581f12ca67dfef04d6dfaf25461561a010e636f05762e73=
35bda10435255c8a1ed64126c5808508a195a94b83b34e9e53773379b5078f611b1e2c086=
ba90e7b9c96a9fdada0fc0a67d0068719ee9e7d4947b7a26f027861c4e8057fd7edae1ffd=
a5f36a53f428d7d08bb7424fcc6534336388e4b428e9a200e216c927289eebcf0bb0295ca=
68d86970fd9cbeacfe618b79f98e3ef81e37134103a9abd2ab1104170532d2b80b9693760=
c6600877657dc0dede683570e3c7eeb7e99f262b52d89425f1d100fbcbf1669a2ab00c39a=
5b4d6bece54261724b4713cdf567dbc63157339cd2e2a60c8f39b998d94edac90b048820c=
19fecd5a28e493c47663d719e8dd37c49df078d963d1e2d4aec382184c890e71b0708e647=
6a693a5ea097213fa6d4fc31fa741460ffed35c4a17bf5dee2557ce04e8f0258dc030c9ed=
689994055c757400367f5fab9d3eb894b81ca9c5c3995dfb495edcdafbeae25d8b6e02a90=
69a3dd9e301f1d4114017224b60b15048c8d4ab906dd7c217341ad2511c39a4b414775309=
5354f128ed2029d96704847e02080e2497ac29bdf724f867cebf3766d407a03948ea6ae10=
072ec2b485c548ae3b6e8cbae2681f406d8fc6b37e95263b1d3986270fbe1cc06a04eb9c5=
e3048dab53ae1383458f5995ac3d22adea78da4355d9782b266f901d8d49468e7768ef6bf=
90b0d5345c8a786b60a9b4a25db84a96879bef70655dec4bb40baef8793b3ea5b41706e1b=
af344b4e181e04f902b1c94f35fb266c51eeb5212043bbc009e8ea292e07bd7ab32447fde=
741c157727e770a4df7d43893a76a5fa7c2e62f909af23ca5638adb240c3b8cbaef7ead4e=
47b4c60479474e2a47f6dd37bfe18804b86909434f12742791b3444c47a7eacf2689ef9a2=
c15767857c0809e86a0bb8c1be88d2d5a98b56f0f55f68bd3e7e2a11b2700b6ae21a114fa=
c47f3de6064c097e1e7677a3b1aaaf52e78049dada675afa7e4d09ddf386f70dab4928c9d=
16b1cb5eb9688c04c12fbc3e3d0c77758b0b30f3dd4af54a009dc9f3361960d09c5a11873=
26445b5b9c5b80cab84a74f79eb8d84298248cc6bc7d286de6be8201c8e5ba63119ee9a2b=
ff50cc764e26b0dc71bb9a5bc5c3d3c60824a5efc5b51c4b9cfc17f1e764d20dade8dce0c=
9edda6d03343b519538ed0b1154db1dcea94d2719ff58b91091a51fd1c276be0c27fdbcf0=
cc75e8f2d1e3cedad07e0e94f3c08ca365cb8653793ddbdf5beece0e6aad3dcf6547c89b1=
84962173fbeefe5b0ca5961027f58dd78b52a236a820aee8381ba518028fe8c4acba4352a=
dc8eaaea87cada63b79234a148bfb9dffdd220aace9b052a4bbf759799485bcef6a09cca9=
8b2aaf23cf29dd77b5b69d2c287d9b45027520312d3e9fdc143e3be8e40da92f7cdc2fb61=
84cf94701cac7d4c42bc865cd402c751f13608d45c67e5cf2b7e392d14c299b8f2b64d3b3=
48b084016a52f56c542c978efb740fe4838cfbad161da74f1154c70c53cfdf82ccba17f69=
c1e083c3c9312165896a1748f6bfb1a18522d540ec09f3cc126a6d499589c03bc7835b9ae=
f6485d044f0121a6dbe1e3ac9ab1066e83f622a0009c39eb21f856f90854350b7cffabee6=
15dff2eacaae00d24a16adcc4e07daa916fff4946bbf8d6401c63181487324285acc3e549=
a108c870cf67ab400a3f354b4e87df4f8d3983d92c55caf45b017d9c9163b64394dc15e1e=
c34ed68bbaefe476ceebc177033b65173945b5139126956f3ed2d0e5eacc6043b008f9108=
be5a993891844e91df70e090111df756b6cefb1ae816c58c540212ceb2d6be4aec97b6113=
7f41965dc3b92befa2c46a7e998095859aa565ccd2a332461890a172d16bcc122e0466fcb=
748e75570221929bbca870e95f6bed788da928cede5406395bb3f23dcf0f35b3648c49cb0=
ce70237614ded6351c2c582c13f7afd9f68595afcedf1c116b3a245c518a879222828b37f=
de3cfdbb357ff4b14bcc0d04ccfb1e223b8138ddbc7ab67eeacb729e1f7af9d1396220149=
7f897e26a128e020d9f183b5dd6a9e00db581ca484b9f74729f9a6d54883b35e7307789bf=
e1f78c27acc139117a4f58753074c2bfb4c82b41e5455f83dd8e61b7056e8fc3f60aa5834=
6c7eaf5a89624d62f0d95fe1fe1189221f18307547be432177b8d185d3eb859707a00e386=
168615a2ae5faefb7e047b7a4246104b97f4e4836ea9e51de9aa4f15d1c70fbe0ef7d77ed=
a696f369a81ba3756cdf2d1ff5dc92b7c74a40a5186b939de9504",
0x2000, &(0x7f0000001000)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, &(0x7f0000000680)=3D{0x78, 0x0, 0x6, {0x5, 0x1, 0x0, {0x5, 0xf03, 0=
xfff, 0x3, 0x9, 0xfffffffffffffff7, 0x8, 0x1b, 0xc, 0x4000, 0x7, 0x0, 0x0=
, 0x10001, 0x100}}}, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0})
mmap(&(0x7f0000ffa000/0x4000)=3Dnil, 0x4000, 0x7, 0x11, r8, 0x3e8f000)
mlock(&(0x7f0000ffc000/0x4000)=3Dnil, 0x4000)
ioctl$AUTOFS_DEV_IOCTL_REQUESTER(0xffffffffffffffff, 0xc018937b, &(0x7f00=
00000080)=3D{{0x1, 0x1, 0x18, r0, {<r9=3D>0xee00}}, './cgroup/cgroup.proc=
s\x00'})
setsockopt$inet6_IPV6_XFRM_POLICY(r2, 0x29, 0x23, &(0x7f0000000200)=3D{{{=
@in6=3D@empty, @in6=3D@mcast1, 0x4e21, 0xd, 0x4e23, 0x87a, 0x2, 0x80, 0x2=
0, 0x0, 0x0, r9}, {0x7, 0x3, 0x0, 0x9, 0x7, 0x9, 0xff}, {0x2, 0x10000, 0x=
41, 0x22f}, 0x1, 0x6e6bb0, 0x2, 0x1, 0x1, 0x3}, {{@in6=3D@initdev=3D{0xfe=
, 0x88, '\x00', 0x0, 0x0}, 0x4d3, 0x33}, 0x2, @in6=3D@loopback, 0x34ff, 0=
x0, 0x1, 0x4, 0x9, 0x6, 0x3}}, 0xe8)

1.54173308s ago: executing program 5 (id=3D13561):
r0 =3D syz_create_resource$binfmt(&(0x7f0000000040)=3D'./file1\x00')
r1 =3D openat$binfmt(0xffffffffffffff9c, r0, 0x42, 0x1ff)
close(r1)
close(0xffffffffffffffff)
execveat$binfmt(0xffffffffffffff9c, r0, &(0x7f00000004c0)=3D{[&(0x7f00000=
00480)=3D'*#^},$*]:&%-+:\x00']}, 0x0, 0x0)
r2 =3D openat$dir(0xffffffffffffff9c, &(0x7f0000000000)=3D'./file1\x00', =
0x100000, 0x0)
execveat$binfmt(r2, r0, &(0x7f0000000100)=3D{[&(0x7f0000000080)=3D'(\xcc!=
+\x00', &(0x7f00000000c0)=3D'@^-\\%%']}, &(0x7f0000000180)=3D{[&(0x7f0000=
000140)=3D'/\\*{.[\'$}\x00']}, 0x1000)
syz_create_resource$binfmt(&(0x7f0000000040)=3D'./file1\x00') (async)
openat$binfmt(0xffffffffffffff9c, r0, 0x42, 0x1ff) (async)
close(r1) (async)
close(0xffffffffffffffff) (async)
execveat$binfmt(0xffffffffffffff9c, r0, &(0x7f00000004c0)=3D{[&(0x7f00000=
00480)=3D'*#^},$*]:&%-+:\x00']}, 0x0, 0x0) (async)
openat$dir(0xffffffffffffff9c, &(0x7f0000000000)=3D'./file1\x00', 0x10000=
0, 0x0) (async)
execveat$binfmt(r2, r0, &(0x7f0000000100)=3D{[&(0x7f0000000080)=3D'(\xcc!=
+\x00', &(0x7f00000000c0)=3D'@^-\\%%']}, &(0x7f0000000180)=3D{[&(0x7f0000=
000140)=3D'/\\*{.[\'$}\x00']}, 0x1000) (async)

1.53202155s ago: executing program 5 (id=3D13562):
syz_clone(0x11, 0x0, 0x0, 0x0, 0x0, 0x0)
r0 =3D eventfd2(0x5, 0x1)
socketpair$unix(0x1, 0x2, 0x0, &(0x7f0000005000)=3D{<r1=3D>0xffffffffffff=
ffff, <r2=3D>0xffffffffffffffff})
recvmmsg$unix(r2, &(0x7f0000003f00), 0x400012f, 0x10002, 0x0)
writev(r1, &(0x7f0000000300)=3D[{&(0x7f0000000240)=3D'y', 0x1}], 0x1)
readv(r2, &(0x7f0000001400)=3D[{&(0x7f0000000040)=3D""/80, 0x50}], 0x1)
write$eventfd(r0, &(0x7f0000000000)=3D0xfffffffffffffffa, 0x8)
r3 =3D socket$inet6_icmp_raw(0xa, 0x3, 0x3a)
setsockopt$MRT6_FLUSH(r3, 0x29, 0xd4, &(0x7f0000000080)=3D0xa, 0x4)
prctl$PR_SET_TAGGED_ADDR_CTRL(0x37, 0x1)
r4 =3D openat$random(0xffffffffffffff9c, &(0x7f0000000000), 0x400, 0x0)
pread64(r4, 0x0, 0x0, 0x1)
r5 =3D socket$packet(0x11, 0x3, 0x300)
r6 =3D mq_open(&(0x7f0000000040)=3D'\xa8\xc4*\x00', 0xc41, 0x30, 0x0)
mq_notify(r6, &(0x7f00000001c0)=3D{0x0, 0x3f})
mq_timedsend(r6, 0x0, 0x0, 0x6, 0x0)
getsockopt$sock_cred(r5, 0x1, 0x11, 0x0, &(0x7f0000000000))
timer_create(0xfffffffffffffffd, 0x0, &(0x7f0000000100))
socketpair$unix(0x1, 0x1, 0x0, &(0x7f0000000040)=3D{<r7=3D>0xffffffffffff=
ffff, <r8=3D>0xffffffffffffffff})
sendmsg$unix(r7, &(0x7f0000001100)=3D{0x0, 0x0, &(0x7f00000010c0)=3D[{&(0=
x7f0000001080)=3D"fa", 0x1}], 0x1, 0x0, 0x0, 0x2004c8c1}, 0x20000045)
recvmmsg$unix(r8, &(0x7f0000000780)=3D[{{0x0, 0x0, 0x0}}], 0x1, 0x2011, 0=
x0)
writev(r7, &(0x7f0000000000)=3D[{&(0x7f00000001c0)=3D'{m', 0x2}], 0x1)
recvmsg$unix(r8, &(0x7f0000000340)=3D{0x0, 0x0, 0x0}, 0x40000022)
bpf$PROG_LOAD(0x5, &(0x7f0000000180)=3D{0x5, 0x4, &(0x7f0000000d00)=3DANY=
=3D[@ANYBLOB=3D"1800000006000000000000007e7d00006d00ffff00000000ad61429a5=
7e8c095"], &(0x7f0000000ac0)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x2, '\x00'=
, 0x0, @fallback=3D0x9, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x3ff}, 0x94)

1.53172309s ago: executing program 3 (id=3D13563):
r0 =3D socket$inet_sctp(0x2, 0x5, 0x84)
set_mempolicy(0x6003, 0x0, 0x0)
setsockopt$inet_int(r0, 0x0, 0x4, &(0x7f0000000000)=3D0x1, 0x4)
syz_emit_ethernet(0x46, &(0x7f00000000c0)=3D{@local, @multicast, @void, {=
@ipv4=3D{0x800, @icmp=3D{{0x7, 0x4, 0x3, 0x4, 0x38, 0x65, 0x0, 0x6, 0x1, =
0x0, @local, @initdev=3D{0xac, 0x1e, 0x1, 0x0}, {[@cipso=3D{0x86, 0x6, 0x=
3}]}}, @dest_unreach=3D{0x3, 0xb, 0x0, 0x0, 0x43, 0x6, {0x5, 0x4, 0x0, 0x=
a, 0x9, 0x68, 0x3, 0x3, 0x2e, 0x2, @loopback, @rand_addr=3D0x64010102}}}}=
}}, 0x0)
sendmmsg$inet_sctp(r0, &(0x7f0000004800)=3D[{&(0x7f00000005c0)=3D@in=3D{0=
x2, 0x4e22, @remote}, 0x10, &(0x7f0000000640)=3D[{&(0x7f0000000600)=3D"cd=
", 0x1}], 0x1, 0x0, 0x0, 0x4400}], 0x1, 0x40000)

1.43903531s ago: executing program 8 (id=3D13565):
openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)=

perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x1, 0x0, 0x0, 0x0, 0x0, =
0x7fe, 0x140c1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0xa, 0x4=
, @perf_config_ext=3D{0x1, 0x7}, 0x1, 0x5, 0x9, 0x1, 0xffffffff, 0xd1, 0x=
ac6f, 0x0, 0x0, 0x0, 0x60}, 0xffffffffffffffff, 0x3, 0xffffffffffffffff, =
0x0)
ioctl$BTRFS_IOC_SET_FEATURES(0xffffffffffffffff, 0x40309439, &(0x7f000000=
0080)=3D{0x1, 0x1, 0x14})
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
perf_event_open(&(0x7f0000000080)=3D{0x5, 0x80, 0x5, 0x9, 0x8, 0xe, 0x0, =
0x7fe, 0x90080, 0xc, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0, 0x2}, 0x2, 0x7, 0x2, 0x5, 0xffffffff, 0x9, 0x3, 0x0, 0=
x0, 0x0, 0x61}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
r0 =3D openat$yama_ptrace_scope(0xffffffffffffff9c, &(0x7f0000000000), 0x=
2, 0x0)
mprotect(&(0x7f0000ffc000/0x1000)=3Dnil, 0x1000, 0x4)
mmap(&(0x7f0000000000/0x400000)=3Dnil, 0x400000, 0xa, 0x4c832, r0, 0xeb08=
0000)
r1 =3D openat(0xffffffffffffff9c, &(0x7f0000000240)=3D'./cgroup.net/cgrou=
p.procs\x00', 0x2, 0x0)
close(0x3)
open_by_handle_at(r1, &(0x7f0000003100)=3D@ceph_nfs_fh=3D{0x67, 0x1, {0x5=
}}, 0x309040)
r2 =3D syz_open_procfs(0x0, &(0x7f0000000100)=3D'fd/3\x00')
read$FUSE(r2, &(0x7f00000010c0)=3D{0x2020}, 0x2020)

1.27222058s ago: executing program 0 (id=3D13568):
r0 =3D add_key$keyring(&(0x7f0000000000), &(0x7f00000000c0)=3D{'syz', 0x2=
}, 0x0, 0x0, 0xffffffffffffffff)
keyctl$restrict_keyring(0x1d, r0, 0xfffffffffffffffe, &(0x7f0000000100)=3D=
'\x00')
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
mkdirat(0xffffffffffffff9c, &(0x7f0000000080)=3D'./file1\x00', 0x1c0)
chdir(&(0x7f0000000180)=3D'./file1\x00')
r1 =3D openat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file1\x00', 0x42=
, 0x1ff)
mmap$perf(&(0x7f0000b9e000/0x2000)=3Dnil, 0x2000, 0x2000000, 0x12, r1, 0x=
0)
write$char_usb(r1, &(0x7f00000000c0)=3D"0fd72c08", 0x4)
perf_event_open(&(0x7f00000003c0)=3D{0x9, 0x80, 0xff, 0xf, 0x3, 0xfe, 0x8=
0000, 0x10000000000e0b5, 0x9224, 0x4, 0x0, 0x1, 0x0, 0x0, 0x1, 0x0, 0x1, =
0x1, 0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1=
, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x1, 0x1, 0x0, 0x1, 0=
x0, 0x0, 0x6, 0x0, @perf_config_ext=3D{0x1e, 0x9}, 0xc04, 0x4, 0x100003, =
0x5, 0xfffffffffffffffa, 0x6, 0x8, 0x0, 0x80, 0x0, 0x1}, 0x0, 0x0, 0xffff=
ffffffffffff, 0x3)
r2 =3D openat$autofs(0xffffffffffffff9c, &(0x7f0000000000), 0x100, 0x0)
ioctl$AUTOFS_DEV_IOCTL_REQUESTER(r2, 0xc018937b, 0xffffffffffffffff)
mount(&(0x7f00000001c0)=3D@loop=3D{'/dev/loop', 0x0}, &(0x7f0000000140)=3D=
'./file0/file0\x00', &(0x7f0000000000)=3D'udf\x00', 0x0, 0x0)

1.19492659s ago: executing program 0 (id=3D13569):
r0 =3D socket$nl_generic(0x10, 0x3, 0x10)
r1 =3D syz_genetlink_get_family_id$mptcp(&(0x7f0000000040), 0xfffffffffff=
fffff)
bpf$BPF_GET_MAP_INFO(0xf, &(0x7f0000000100)=3D{0x1, 0x58, &(0x7f000000008=
0)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, ""/16, <r2=3D>0x0}}, 0x10)
sendmsg$MPTCP_PM_CMD_FLUSH_ADDRS(r0, &(0x7f0000000200)=3D{&(0x7f000000000=
0)=3D{0x10, 0x0, 0x0, 0x400}, 0xc, &(0x7f00000001c0)=3D{&(0x7f0000000140)=
=3D{0x5c, r1, 0x0, 0x70bd2b, 0x25dfdbfb, {}, [@MPTCP_PM_ATTR_ADDR_REMOTE=3D=
{0xc, 0x6, 0x0, 0x1, [@MPTCP_PM_ADDR_ATTR_IF_IDX=3D{0x8, 0x7, r2}]}, @MPT=
CP_PM_ATTR_ADDR=3D{0x34, 0x1, 0x0, 0x1, [@MPTCP_PM_ADDR_ATTR_ADDR4=3D{0x8=
, 0x3, @multicast1}, @MPTCP_PM_ADDR_ATTR_FAMILY=3D{0x6, 0x1, 0x2}, @MPTCP=
_PM_ADDR_ATTR_PORT=3D{0x6, 0x5, 0x4e21}, @MPTCP_PM_ADDR_ATTR_FLAGS=3D{0x8=
, 0x6, 0x10}, @MPTCP_PM_ADDR_ATTR_PORT=3D{0x6, 0x5, 0x4e24}, @MPTCP_PM_AD=
DR_ATTR_ID=3D{0x5, 0x2, 0xb1}]}, @MPTCP_PM_ATTR_RCV_ADD_ADDRS=3D{0x8, 0x2=
, 0x7}]}, 0x5c}, 0x1, 0x0, 0x0, 0x8000}, 0x800)
sendmsg$NL80211_CMD_UPDATE_OWE_INFO(r0, &(0x7f0000000340)=3D{&(0x7f000000=
0240)=3D{0x10, 0x0, 0x0, 0x40000}, 0xc, &(0x7f0000000300)=3D{&(0x7f000000=
0280)=3D{0x70, 0x0, 0x1, 0x70bd27, 0x25dfdbfd, {{}, {@val=3D{0x8}, @void}=
}, [@NL80211_ATTR_MAC=3D{0xa, 0x6, @broadcast}, @NL80211_ATTR_STATUS_CODE=
=3D{0x6, 0x48, 0x4f}, @NL80211_ATTR_MAC=3D{0xa, 0x6, @broadcast}, @NL8021=
1_ATTR_STATUS_CODE=3D{0x6, 0x48, 0x29}, @NL80211_ATTR_MAC=3D{0xa, 0x6, @b=
roadcast}, @NL80211_ATTR_MAC=3D{0xa}, @NL80211_ATTR_STATUS_CODE=3D{0x6, 0=
x48, 0x36}, @NL80211_ATTR_MAC=3D{0xa}]}, 0x70}, 0x1, 0x0, 0x0, 0x20000090=
}, 0x1)
bpf$MAP_GET_NEXT_KEY(0x4, &(0x7f0000000480)=3D{0x1, &(0x7f0000000380)=3D"=
263fa726d1f557562d8a6c8a20f82e716d59a1fa0f4c1b62e763c4cf7a2ec78f435c516e4=
81609180ee2c37193e97fc80eaba2cf7fd240cca46e47978d96b0ee583d3d51be19", &(0=
x7f0000000400)=3D""/86}, 0x20)
r3 =3D syz_genetlink_get_family_id$nl80211(&(0x7f0000000500), r0)
sendmsg$NL80211_CMD_SET_TID_CONFIG(r0, &(0x7f00000015c0)=3D{&(0x7f0000000=
4c0)=3D{0x10, 0x0, 0x0, 0x1}, 0xc, &(0x7f0000001580)=3D{&(0x7f0000000540)=
=3D{0x1028, r3, 0x2, 0x70bd29, 0x25dfdbfd, {{}, {@void, @val=3D{0xc, 0x99=
, {0xffffffff, 0x7e}}}}, [@NL80211_ATTR_TID_CONFIG=3D{0x270, 0x11d, 0x0, =
0x1, [{0x1b4, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_ATTR_TX_RATE=3D{0x1b0, =
0xd, 0x0, 0x1, [@NL80211_BAND_6GHZ=3D{0x6c, 0x3, 0x0, 0x1, [@NL80211_TXRA=
TE_LEGACY=3D{0xc, 0x1, [0x24, 0x1b, 0xb, 0x6c, 0x16, 0x9, 0x5, 0x30]}, @N=
L80211_TXRATE_GI=3D{0x5, 0x4, 0x1}, @NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0=
x6, 0xd, 0x7f, 0x2, 0x1, 0x200, 0x7, 0x2]}}, @NL80211_TXRATE_HT=3D{0x3d, =
0x2, [{0x1, 0x7}, {0x4, 0xa}, {0x2, 0xa}, {0x0, 0x9}, {0x3, 0x2}, {0x7, 0=
x7}, {0x0, 0x9}, {0x6, 0x3}, {0x2, 0x9}, {0x7, 0x3}, {0x2, 0x2}, {0x0, 0x=
8}, {0x2, 0x8}, {0x3, 0x2}, {}, {0x2}, {0x5, 0x3}, {0x6, 0xa}, {0x1, 0x5}=
, {0x2, 0x1}, {0x3, 0x5}, {0x3, 0x9}, {0x5, 0x9}, {0x7, 0x2}, {0x7, 0x8},=
 {0x6, 0x8}, {0x1}, {0x1, 0xa}, {0x3, 0xa}, {0x3}, {0x0, 0x7}, {0x6, 0x3}=
, {0x1, 0x3}, {0x4}, {0x0, 0x2}, {0x6}, {0x5, 0x6}, {0x1, 0x8}, {0x2, 0x7=
}, {0x5, 0x1}, {0x0, 0x6}, {0x1, 0x6}, {0x6, 0x1}, {0x1, 0x9}, {0x7, 0x1}=
, {0x5, 0x3}, {0x5, 0x5}, {0x6, 0x5}, {0x3, 0xa}, {0x2, 0x2}, {0x2, 0x9},=
 {0x0, 0x6}, {0x3, 0x6}, {0x5, 0x8}, {0x4, 0x3}, {0x7, 0x6}, {0x7}]}]}, @=
NL80211_BAND_5GHZ=3D{0x48, 0x1, 0x0, 0x1, [@NL80211_TXRATE_HE=3D{0x14, 0x=
5, {[0x3, 0xf83, 0x7, 0x0, 0x1, 0x0, 0x3ff, 0x6]}}, @NL80211_TXRATE_VHT=3D=
{0x14, 0x3, {[0x9, 0x5, 0x6, 0x4, 0x4, 0x4, 0x7ff, 0x8]}}, @NL80211_TXRAT=
E_HE_LTF=3D{0x5, 0x7, 0x2}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x7f, 0x5,=
 0x0, 0x2, 0x3, 0x4, 0x9, 0xc]}}]}, @NL80211_BAND_5GHZ=3D{0x30, 0x1, 0x0,=
 0x1, [@NL80211_TXRATE_HE_LTF=3D{0x5, 0x7, 0x1}, @NL80211_TXRATE_GI=3D{0x=
5, 0x4, 0x1}, @NL80211_TXRATE_GI=3D{0x5, 0x4, 0x2}, @NL80211_TXRATE_VHT=3D=
{0x14, 0x3, {[0x3, 0x7, 0x291, 0x8, 0xd, 0x101, 0x1c5c, 0x5]}}]}, @NL8021=
1_BAND_60GHZ=3D{0x18, 0x2, 0x0, 0x1, [@NL80211_TXRATE_LEGACY=3D{0x11, 0x1=
, [0xe, 0x1b, 0x6, 0x48, 0x30, 0x36, 0x2, 0x5, 0x12, 0x1b, 0xb, 0x60, 0x2=
4]}]}, @NL80211_BAND_60GHZ=3D{0xa4, 0x2, 0x0, 0x1, [@NL80211_TXRATE_VHT=3D=
{0x14, 0x3, {[0x7, 0x0, 0x65fc, 0x869, 0x10, 0x80, 0x3, 0x4]}}, @NL80211_=
TXRATE_GI=3D{0x5}, @NL80211_TXRATE_HE_GI=3D{0x5, 0x6, 0x1}, @NL80211_TXRA=
TE_GI=3D{0x5, 0x4, 0x2}, @NL80211_TXRATE_HT=3D{0x1e, 0x2, [{0x3, 0x3}, {0=
x1}, {0x0, 0x5}, {0x7, 0x5}, {0x2, 0x8}, {0x6, 0x1}, {0x3}, {0x1, 0x1}, {=
0x5, 0x2}, {0x6, 0x9}, {0x4, 0x7}, {0x4, 0xa}, {0x1, 0x9}, {0x1, 0x6}, {0=
x1, 0x9}, {0x4}, {0x5, 0x9}, {0x0, 0x4}, {0x7, 0x6}, {}, {0x1, 0xa}, {0x3=
, 0x6}, {0x2, 0xa}, {0x3, 0x8}, {0x0, 0x4}, {0x4, 0x3}]}, @NL80211_TXRATE=
_LEGACY=3D{0x17, 0x1, [0x1, 0x30, 0xc, 0x5, 0x1b, 0x1, 0x3, 0x3, 0x1, 0x1=
b, 0x6c, 0x1b, 0x28, 0x36, 0x48, 0x36, 0x2, 0x6c, 0x2]}, @NL80211_TXRATE_=
GI=3D{0x5, 0x4, 0x2}, @NL80211_TXRATE_LEGACY=3D{0x1e, 0x1, [0xb, 0x3, 0x5=
, 0x18, 0x1, 0x18, 0x8, 0x5, 0x1b, 0x1b, 0x60, 0x1, 0x9, 0x30, 0x48, 0x36=
, 0x1b, 0x16, 0x0, 0x60, 0x4, 0x4, 0x24, 0x6c, 0x36, 0x60]}, @NL80211_TXR=
ATE_VHT=3D{0x14, 0x3, {[0xff33, 0x4, 0x7fff, 0x6, 0xfff7, 0x14e, 0xc523, =
0xa7ed]}}]}, @NL80211_BAND_6GHZ=3D{0xc, 0x3, 0x0, 0x1, [@NL80211_TXRATE_H=
E_GI=3D{0x5, 0x6, 0x2}]}]}]}, {0xb8, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_=
ATTR_TX_RATE=3D{0xac, 0xd, 0x0, 0x1, [@NL80211_BAND_6GHZ=3D{0x84, 0x3, 0x=
0, 0x1, [@NL80211_TXRATE_HT=3D{0x11, 0x2, [{0x0, 0x6}, {0x1}, {0x7, 0x8},=
 {0x6, 0x3}, {0x1, 0x3}, {0x5, 0x6}, {0x0, 0x9}, {0x0, 0x9}, {0x6}, {0x1,=
 0x8}, {0x0, 0x5}, {0x4, 0xa}, {0x4, 0xa}]}, @NL80211_TXRATE_HT=3D{0x4b, =
0x2, [{0x4, 0x6}, {}, {0x1, 0x4}, {0x3, 0x9}, {0x1, 0x7}, {0x4, 0xa}, {0x=
3, 0x1}, {0x3, 0x6}, {0x3, 0x2}, {0x4, 0x4}, {0x0, 0x1}, {0x2, 0x7}, {0x0=
, 0x3}, {}, {0x1, 0x8}, {0x1, 0x6}, {0x5, 0x8}, {0x0, 0x5}, {0x0, 0x8}, {=
0x6, 0xa}, {0x6, 0x8}, {0x1, 0x6}, {0x3, 0xa}, {0x1, 0x9}, {0x4, 0x3}, {0=
x6, 0xa}, {0x6, 0x4}, {0x3, 0xa}, {0x1}, {0x0, 0x1}, {0x1, 0x2}, {0x5, 0x=
7}, {0x3, 0x2}, {0x3, 0x1}, {}, {0x1, 0xa}, {0x0, 0x7}, {0x5, 0x3}, {0x3,=
 0x1}, {0x7, 0x9}, {0x4, 0x3}, {0x1, 0x4}, {0x1, 0x4}, {0x6, 0x6}, {0x0, =
0x7}, {0x7, 0x3}, {0x2, 0x5}, {0x5, 0x8}, {0x6, 0x1}, {0x6}, {0x7, 0x8}, =
{0x4, 0x7}, {0x2, 0x8}, {0x6, 0x7}, {0x0, 0x4}, {0x0, 0x7}, {0x5, 0x6}, {=
0x0, 0x2}, {0x6, 0x7}, {0x1, 0x2}, {0x6, 0x4}, {0x7, 0x1}, {0x0, 0x2}, {0=
x0, 0x7}, {0x2, 0x3}, {0x3, 0xa}, {0x3, 0x6}, {0x6, 0x2}, {0x7}, {0x5, 0x=
2}, {0x3, 0x6}]}, @NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0x7636, 0x1, 0x2, 0=
x6, 0xbba1, 0x0, 0x7]}}, @NL80211_TXRATE_HE_LTF=3D{0x5, 0x7, 0x2}, @NL802=
11_TXRATE_LEGACY=3D{0x4}]}, @NL80211_BAND_5GHZ=3D{0x24, 0x1, 0x0, 0x1, [@=
NL80211_TXRATE_LEGACY=3D{0x1e, 0x1, [0x2, 0x0, 0x6c, 0x4, 0x6, 0x3, 0x48,=
 0xc, 0x3, 0x1, 0x6, 0x22, 0x60, 0x36, 0x24, 0x6c, 0x12, 0x50, 0x16, 0x6,=
 0xc, 0x30, 0x28, 0x9, 0x2, 0x1]}]}]}, @NL80211_TID_CONFIG_ATTR_AMSDU_CTR=
L=3D{0x5, 0xb, 0x1}]}]}, @NL80211_ATTR_TID_CONFIG=3D{0x530, 0x11d, 0x0, 0=
x1, [{0x170, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_ATTR_AMSDU_CTRL=3D{0x5},=
 @NL80211_TID_CONFIG_ATTR_NOACK=3D{0x5}, @NL80211_TID_CONFIG_ATTR_TX_RATE=
=3D{0x5c, 0xd, 0x0, 0x1, [@NL80211_BAND_5GHZ=3D{0x58, 0x1, 0x0, 0x1, [@NL=
80211_TXRATE_VHT=3D{0x14, 0x3, {[0xff, 0x2, 0x401, 0x7f, 0x7, 0xfffc, 0x9=
, 0xfbff]}}, @NL80211_TXRATE_HT=3D{0x1f, 0x2, [{0x5, 0x2}, {0x7, 0x9}, {0=
x5, 0x7}, {0x1}, {0x1, 0x8}, {0x5, 0x4}, {0x2, 0x1}, {}, {0x0, 0x9}, {0x4=
, 0x2}, {0x6, 0xa}, {0x0, 0x7}, {0x7, 0xa}, {0x2, 0xa}, {0x7, 0x6}, {0x3,=
 0x2}, {0x0, 0x8}, {0x3, 0x2}, {0x0, 0x7}, {0x0, 0x6}, {0x4, 0x7}, {}, {0=
x4, 0x4}, {0x4, 0x2}, {0x6, 0x8}, {0x1, 0x5}, {0x5, 0x8}]}, @NL80211_TXRA=
TE_HE_LTF=3D{0x5, 0x7, 0x2}, @NL80211_TXRATE_GI=3D{0x5}, @NL80211_TXRATE_=
HE_GI=3D{0x5}, @NL80211_TXRATE_HE_GI=3D{0x5}]}]}, @NL80211_TID_CONFIG_ATT=
R_TX_RATE=3D{0xf4, 0xd, 0x0, 0x1, [@NL80211_BAND_6GHZ=3D{0x98, 0x3, 0x0, =
0x1, [@NL80211_TXRATE_GI=3D{0x5, 0x4, 0x1}, @NL80211_TXRATE_HE_GI=3D{0x5,=
 0x6, 0x2}, @NL80211_TXRATE_HT=3D{0x51, 0x2, [{0x0, 0xa}, {0x4, 0x3}, {0x=
2, 0x7}, {0x6, 0x7}, {0x5, 0xa}, {}, {0x2, 0xa}, {0x5, 0x9}, {0x4, 0x5}, =
{0x1}, {0x1, 0x1}, {0x2, 0xa}, {0x3, 0x8}, {0x1, 0x1}, {0x7, 0x6}, {0x5, =
0x2}, {0x7, 0x3}, {0x4, 0x3}, {0x7, 0x9}, {0x4, 0x3}, {0x4, 0x4}, {0x2, 0=
x4}, {0x0, 0x2}, {0x3, 0x8}, {0x2, 0x9}, {0x7, 0x4}, {0x4, 0x9}, {0x3, 0x=
2}, {0x4, 0xa}, {0x4, 0x6}, {0x0, 0x7}, {0x2, 0x10}, {0x4, 0x1}, {0x3, 0x=
6}, {0x4}, {0x1, 0x1}, {0x2}, {0x3, 0x2}, {0x2, 0x5}, {0x6, 0x3}, {0x1, 0=
x5}, {0x0, 0x2}, {0x3, 0x3}, {0x7, 0x9}, {0x1, 0x5}, {0x5, 0x1}, {}, {0x6=
, 0x5}, {0x5, 0x6}, {0x3, 0x2}, {0x2, 0x2}, {0x1, 0x6}, {0x7, 0x4}, {0x3,=
 0x2}, {0x6, 0xa}, {0x0, 0x5}, {0x4, 0x2}, {0x0, 0xa}, {0x2, 0x7}, {0x5, =
0x6}, {0x0, 0x1}, {0x1}, {}, {0x5, 0x6}, {0x3, 0x7}, {0x1, 0x4}, {0x4, 0x=
a}, {0x0, 0x2}, {0x6, 0x8}, {0x1, 0x5}, {0x6, 0x4}, {0x7, 0x4}, {0x0, 0x1=
}, {0x6, 0x9}, {0x6, 0x6}, {0x4, 0x6}, {0x1, 0x6}]}, @NL80211_TXRATE_HE_L=
TF=3D{0x5, 0x7, 0x1}, @NL80211_TXRATE_HE_LTF=3D{0x5, 0x7, 0x1}, @NL80211_=
TXRATE_LEGACY=3D{0xb, 0x1, [0xb, 0x18, 0x12, 0x6c, 0x9, 0x2, 0x9]}, @NL80=
211_TXRATE_HE=3D{0x14, 0x5, {[0x7, 0x6, 0x0, 0x0, 0x2, 0x1, 0x0, 0x1000]}=
}]}, @NL80211_BAND_2GHZ=3D{0x4c, 0x0, 0x0, 0x1, [@NL80211_TXRATE_HE_LTF=3D=
{0x5}, @NL80211_TXRATE_HE_LTF=3D{0x5, 0x7, 0x1}, @NL80211_TXRATE_VHT=3D{0=
x14, 0x3, {[0x1, 0x9, 0x5ae5, 0x4, 0x5b4d, 0x5, 0x1000, 0xcbc9]}}, @NL802=
11_TXRATE_HT=3D{0xd, 0x2, [{0x3, 0x9}, {0x6, 0x7}, {0x6, 0x3}, {0x0, 0x1}=
, {0x5, 0x5}, {0x6, 0x6}, {0x6, 0x2}, {0x0, 0xa}, {0x5, 0x7}]}, @NL80211_=
TXRATE_HE=3D{0x14, 0x5, {[0x401, 0xee, 0xcb9, 0x0, 0x9, 0x7fff, 0x9, 0x6]=
}}]}, @NL80211_BAND_5GHZ=3D{0xc, 0x1, 0x0, 0x1, [@NL80211_TXRATE_HE_GI=3D=
{0x5}]}]}, @NL80211_TID_CONFIG_ATTR_OVERRIDE=3D{0x4}, @NL80211_TID_CONFIG=
_ATTR_RETRY_LONG=3D{0x5, 0x8, 0x4}]}, {0x108, 0x0, 0x0, 0x1, [@NL80211_TI=
D_CONFIG_ATTR_TX_RATE=3D{0xe4, 0xd, 0x0, 0x1, [@NL80211_BAND_60GHZ=3D{0x3=
0, 0x2, 0x0, 0x1, [@NL80211_TXRATE_GI=3D{0x5, 0x4, 0x1}, @NL80211_TXRATE_=
HE_LTF=3D{0x5}, @NL80211_TXRATE_LEGACY=3D{0xc, 0x1, [0x60, 0x30, 0x48, 0x=
30, 0xb, 0x3, 0x6c, 0x5a]}, @NL80211_TXRATE_GI=3D{0x5}, @NL80211_TXRATE_G=
I=3D{0x5, 0x4, 0x2}]}, @NL80211_BAND_5GHZ=3D{0x3c, 0x1, 0x0, 0x1, [@NL802=
11_TXRATE_HE_LTF=3D{0x5, 0x7, 0x2}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x=
5, 0x8, 0xd, 0xbc8e, 0x4, 0x1, 0x2, 0x131a]}}, @NL80211_TXRATE_LEGACY=3D{=
0x1b, 0x1, [0x60, 0x60, 0x30, 0x60, 0x3, 0x18, 0x12, 0x1b, 0x3, 0x5, 0x1b=
, 0x16, 0x24, 0x6, 0x1, 0x4, 0x2, 0x6c, 0x3, 0x5, 0x4, 0x6c, 0x12]}]}, @N=
L80211_BAND_60GHZ=3D{0x18, 0x2, 0x0, 0x1, [@NL80211_TXRATE_HE=3D{0x14, 0x=
5, {[0x2, 0x2, 0x6, 0x4, 0x8, 0xfff7, 0xcaa, 0x1]}}]}, @NL80211_BAND_2GHZ=
=3D{0x44, 0x0, 0x0, 0x1, [@NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x3, 0x5e, 0=
x2, 0x5, 0x8, 0x0, 0x0, 0x3]}}, @NL80211_TXRATE_HT=3D{0x2a, 0x2, [{0x1, 0=
x2}, {0x2, 0x5}, {0x3, 0x9}, {0x2, 0x3}, {0x6, 0x1}, {0x3, 0x8}, {0x3, 0x=
9}, {0x0, 0x9}, {0x3, 0x8}, {0x1, 0x1}, {0x1, 0x4}, {0x2, 0x5}, {0x5, 0x5=
}, {0x7, 0x9}, {0x2, 0x6}, {0x4, 0x5}, {0x3, 0x3}, {0x3, 0xa}, {0x0, 0x8}=
, {0x7, 0x2}, {0x1, 0x9}, {0x5}, {0x4, 0x8}, {0x6, 0x1}, {0x6, 0x6}, {0x6=
, 0x9}, {0x5, 0xa}, {0x0, 0xa}, {0x6, 0x4}, {0x0, 0x9}, {0x6, 0x4}, {0x0,=
 0x8}, {0x7, 0x9}, {0x6, 0x9}, {0x6, 0x2}, {}, {0x0, 0x1}, {0x1, 0x9}]}]}=
, @NL80211_BAND_2GHZ=3D{0x18, 0x0, 0x0, 0x1, [@NL80211_TXRATE_HE=3D{0x14,=
 0x5, {[0x8, 0x9, 0xff, 0xe5, 0x9, 0x4, 0x5]}}]}]}, @NL80211_TID_CONFIG_A=
TTR_RETRY_SHORT=3D{0x5, 0x7, 0xef}, @NL80211_TID_CONFIG_ATTR_OVERRIDE=3D{=
0x4}, @NL80211_TID_CONFIG_ATTR_RETRY_SHORT=3D{0x5, 0x7, 0x4}, @NL80211_TI=
D_CONFIG_ATTR_OVERRIDE=3D{0x4}, @NL80211_TID_CONFIG_ATTR_RTSCTS_CTRL=3D{0=
x5, 0xa, 0x1}]}, {0x34, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_ATTR_OVERRIDE=
=3D{0x4}, @NL80211_TID_CONFIG_ATTR_AMSDU_CTRL=3D{0x5, 0xb, 0x1}, @NL80211=
_TID_CONFIG_ATTR_PEER_SUPP=3D{0xc, 0x3, 0x7f}, @NL80211_TID_CONFIG_ATTR_R=
ETRY_SHORT=3D{0x5, 0x7, 0xac}, @NL80211_TID_CONFIG_ATTR_AMPDU_CTRL=3D{0x5=
, 0x9, 0x1}, @NL80211_TID_CONFIG_ATTR_AMPDU_CTRL=3D{0x5}]}, {0x20, 0x0, 0=
x0, 0x1, [@NL80211_TID_CONFIG_ATTR_RETRY_SHORT=3D{0x5, 0x7, 0x56}, @NL802=
11_TID_CONFIG_ATTR_VIF_SUPP=3D{0xc}, @NL80211_TID_CONFIG_ATTR_AMPDU_CTRL=3D=
{0x5}]}, {0x260, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_ATTR_NOACK=3D{0x5, 0=
x6, 0x1}, @NL80211_TID_CONFIG_ATTR_NOACK=3D{0x5, 0x6, 0x1}, @NL80211_TID_=
CONFIG_ATTR_VIF_SUPP=3D{0xc, 0x2, 0x101}, @NL80211_TID_CONFIG_ATTR_TX_RAT=
E=3D{0x240, 0xd, 0x0, 0x1, [@NL80211_BAND_5GHZ=3D{0x80, 0x1, 0x0, 0x1, [@=
NL80211_TXRATE_LEGACY=3D{0x13, 0x1, [0x18, 0x2, 0x3, 0x1b, 0x20, 0x12,
0x18, 0x1, 0x1b, 0x1b, 0x6c, 0x5, 0xc, 0xb, 0x12]}, @NL80211_TXRATE_HE=3D=
{0x14, 0x5, {[0x5, 0x50e, 0xb9f9, 0x2, 0x35f, 0xc4a5, 0x4, 0xfff1]}}, @NL=
80211_TXRATE_HE=3D{0x14, 0x5, {[0x178a, 0x0, 0x3, 0xfff9, 0x0, 0x6, 0x9, =
0x2]}}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0xf0, 0x7ff, 0x4b, 0x5, 0x7, 0=
x1, 0x8, 0x4]}}, @NL80211_TXRATE_GI=3D{0x5}, @NL80211_TXRATE_LEGACY=3D{0x=
24, 0x1, [0x1c, 0x1, 0x1b, 0x60, 0x12, 0x36, 0x60, 0x24, 0x48, 0x3, 0x1, =
0x48, 0x48, 0x1b, 0x60, 0x3, 0x6c, 0x4, 0x60, 0x2, 0x4, 0x30, 0x1b, 0x2, =
0x18, 0x3, 0x16, 0x36, 0x1, 0x6c, 0x2, 0x48]}]}, @NL80211_BAND_60GHZ=3D{0=
x90, 0x2, 0x0, 0x1, [@NL80211_TXRATE_HE_GI=3D{0x5, 0x6, 0x2}, @NL80211_TX=
RATE_HE_LTF=3D{0x5, 0x7, 0x2}, @NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0x88ec=
, 0x9, 0x6, 0x7f, 0x3, 0xff, 0x3, 0xacc]}}, @NL80211_TXRATE_GI=3D{0x5, 0x=
4, 0x2}, @NL80211_TXRATE_LEGACY=3D{0x22, 0x1, [0x9, 0xb, 0x18, 0x1, 0x6c,=
 0x24, 0x16, 0x24, 0x0, 0x4, 0x12, 0x36, 0x6c, 0x4, 0x5, 0x0, 0x1b, 0x36,=
 0x4, 0x16, 0x9, 0x1, 0x5, 0x1b, 0x5, 0x6, 0x12, 0x9, 0x18, 0x24]}, @NL80=
211_TXRATE_GI=3D{0x5, 0x4, 0x2}, @NL80211_TXRATE_HT=3D{0x7, 0x2, [{0x3, 0=
x8}, {0x5, 0x4}, {0x5, 0x8}]}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x8, 0x=
5, 0x8, 0x8, 0x1, 0x401, 0x5, 0x3]}}, @NL80211_TXRATE_VHT=3D{0x14, 0x3, {=
[0x4, 0x6, 0x4, 0xd, 0x7, 0x5, 0x8, 0xa57f]}}, @NL80211_TXRATE_LEGACY=3D{=
0x4}]}, @NL80211_BAND_5GHZ=3D{0xe8, 0x1, 0x0, 0x1, [@NL80211_TXRATE_HE=3D=
{0x14, 0x5, {[0x5, 0x0, 0xf, 0x1, 0x9, 0x5, 0xe5e, 0x9]}}, @NL80211_TXRAT=
E_LEGACY=3D{0x11, 0x1, [0x60, 0x30, 0x16, 0x5, 0x6c, 0x16, 0x1, 0x36, 0xb=
, 0x9, 0x18, 0xd8f192fe046f999d, 0x12]}, @NL80211_TXRATE_VHT=3D{0x14, 0x3=
, {[0x64d, 0x3, 0x6651, 0x3, 0x57ba, 0x0, 0x4, 0x3]}}, @NL80211_TXRATE_VH=
T=3D{0x14, 0x3, {[0x1, 0x6, 0x7ff, 0xc4, 0x5, 0x8, 0x6c9f, 0x3]}}, @NL802=
11_TXRATE_GI=3D{0x5, 0x4, 0x2}, @NL80211_TXRATE_GI=3D{0x5, 0x4, 0x1}, @NL=
80211_TXRATE_HT=3D{0x4e, 0x2, [{0x0, 0x9}, {0x6, 0x9}, {0x1, 0x4}, {0x3, =
0x6}, {0x2, 0x2}, {0x2, 0x7}, {0x0, 0x7}, {0x0, 0x9}, {0x2, 0x7}, {0x7, 0=
x5}, {0x2, 0x7}, {0x0, 0x3}, {0x6, 0x6}, {0x0, 0x2}, {0x0, 0x8}, {0x7, 0x=
7}, {0x4}, {0x2, 0x6}, {0x3, 0x9}, {0x4, 0x8}, {0x6}, {0x4, 0x5}, {0x0, 0=
x6}, {0x6, 0x8}, {0x5, 0x6}, {0x5, 0xa}, {0x4, 0x8}, {0x0, 0x4}, {0x4, 0x=
1}, {0x3, 0x5}, {0x1, 0x8}, {0x7, 0x3}, {0x5, 0x2}, {0x3, 0xa}, {0x7, 0x4=
}, {0x6, 0x6}, {0x2, 0x2}, {0x0, 0x1}, {0x1, 0x5}, {0x2, 0x7}, {0x3, 0x1}=
, {0x5, 0x5}, {0x6, 0x2}, {0x6, 0x1}, {0x2, 0x1}, {0x6, 0x6}, {0x2, 0xa},=
 {0x4, 0x1}, {0x7, 0x9}, {0x1, 0x8}, {0x3, 0x8}, {0x0, 0x1}, {0x3, 0x2}, =
{0x3, 0x1}, {0x5, 0x5}, {0x1, 0x9}, {0x2, 0x1}, {0x7, 0x1}, {0x7, 0x9}, {=
0x0, 0x2}, {0x3, 0x3}, {0x7, 0x3}, {0x1, 0x5}, {0x0, 0x3}, {0x3, 0x6}, {0=
x0, 0xa}, {0x6, 0x4}, {0x0, 0x9}, {0x5, 0x1}, {0x1, 0xa}, {0x4, 0x8}, {0x=
3}, {0x1, 0x9}, {0x4, 0x3}]}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x3, 0x4=
, 0x0, 0x5, 0x2f, 0x80, 0x7f, 0xdd]}}, @NL80211_TXRATE_HT=3D{0x1d, 0x2, [=
{0x7, 0x9}, {0x0, 0x2}, {0x4, 0x7}, {0x0, 0x1}, {0x2, 0x7}, {0x6, 0x4}, {=
0x5, 0x8}, {0x6, 0x9}, {0x6, 0x6}, {0x1, 0x6}, {0x2, 0x1}, {0x3, 0x6}, {0=
x3, 0x4}, {0x5, 0x3}, {0x6, 0x9}, {0x2, 0x9}, {0x7}, {0x4, 0x7}, {0x7, 0x=
2}, {0x5, 0x5}, {0x1, 0x3}, {0x7, 0x2}, {0x7, 0x9}, {0x4, 0x4}, {0x0, 0xa=
}]}]}, @NL80211_BAND_5GHZ=3D{0xc, 0x1, 0x0, 0x1, [@NL80211_TXRATE_HE_GI=3D=
{0x5}]}, @NL80211_BAND_2GHZ=3D{0x20, 0x0, 0x0, 0x1, [@NL80211_TXRATE_GI=3D=
{0x5}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x82, 0x21e, 0x10, 0xf8f, 0x7, =
0x6, 0x9, 0x108a]}}]}, @NL80211_BAND_60GHZ=3D{0x18, 0x2, 0x0, 0x1, [@NL80=
211_TXRATE_HE=3D{0x14, 0x5, {[0x2, 0x1, 0x6, 0x7, 0x1000, 0x401, 0x8000, =
0xd12]}}]}]}]}]}, @NL80211_ATTR_TID_CONFIG=3D{0x39c, 0x11d, 0x0, 0x1, [{0=
x34, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_ATTR_RTSCTS_CTRL=3D{0x5}, @NL802=
11_TID_CONFIG_ATTR_RTSCTS_CTRL=3D{0x5, 0xa, 0x2}, @NL80211_TID_CONFIG_ATT=
R_AMPDU_CTRL=3D{0x5}, @NL80211_TID_CONFIG_ATTR_AMPDU_CTRL=3D{0x5, 0x9, 0x=
1}, @NL80211_TID_CONFIG_ATTR_AMSDU_CTRL=3D{0x5, 0xb, 0x1}, @NL80211_TID_C=
ONFIG_ATTR_NOACK=3D{0x5, 0x6, 0x1}]}, {0xc, 0x0, 0x0, 0x1, [@NL80211_TID_=
CONFIG_ATTR_RETRY_SHORT=3D{0x5, 0x7, 0x2d}]}, {0x334, 0x0, 0x0, 0x1, [@NL=
80211_TID_CONFIG_ATTR_RETRY_SHORT=3D{0x5, 0x7, 0x39}, @NL80211_TID_CONFIG=
_ATTR_NOACK=3D{0x5}, @NL80211_TID_CONFIG_ATTR_TX_RATE=3D{0x320, 0xd, 0x0,=
 0x1, [@NL80211_BAND_6GHZ=3D{0x70, 0x3, 0x0, 0x1, [@NL80211_TXRATE_GI=3D{=
0x5}, @NL80211_TXRATE_GI=3D{0x5, 0x4, 0x2}, @NL80211_TXRATE_HT=3D{0x19, 0=
x2, [{0x6, 0x6}, {0x7, 0x6}, {0x7, 0xa}, {0x5, 0x8}, {}, {0x3, 0xa}, {0x4=
, 0x5}, {0x4, 0x5}, {0x4, 0xa}, {0x7, 0x9}, {0x6, 0x2}, {0x5, 0x3}, {0x6,=
 0x7}, {0x5, 0x2}, {0x6}, {0x7, 0x7}, {0x1, 0x3}, {0x3, 0x4}, {0x5, 0x1},=
 {0x4, 0x2}, {0x7, 0x8}]}, @NL80211_TXRATE_GI=3D{0x5, 0x4, 0x1}, @NL80211=
_TXRATE_HE_LTF=3D{0x5, 0x7, 0x2}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x0,=
 0x8, 0x1, 0x1, 0xc47, 0x0, 0xfde, 0x8]}}, @NL80211_TXRATE_GI=3D{0x5, 0x4=
, 0x2}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x8, 0x7, 0x0, 0xfc01, 0xebf, =
0x1, 0x10, 0x6669]}}]}, @NL80211_BAND_60GHZ=3D{0x24, 0x2, 0x0, 0x1, [@NL8=
0211_TXRATE_HT=3D{0x1d, 0x2, [{0x1}, {}, {0x1, 0x7}, {0x0, 0x8}, {0x6, 0x=
3}, {0x1, 0x9}, {0x2, 0xa}, {0x7, 0x3}, {0x4, 0x3}, {0x6}, {0x0, 0x6}, {0=
x1}, {0x1, 0x8}, {0x6, 0x9}, {0x2, 0x4}, {0x0, 0x3}, {0x2, 0x1}, {0x4, 0x=
4}, {0x0, 0x9}, {0x0, 0x1}, {0x4, 0x2}, {0x4}, {0x1, 0x4}, {0x7, 0xa}, {0=
x2, 0x3}]}]}, @NL80211_BAND_60GHZ=3D{0xb0, 0x2, 0x0, 0x1, [@NL80211_TXRAT=
E_VHT=3D{0x14, 0x3, {[0x3, 0xb, 0x8000, 0x7, 0x6, 0x3, 0x1, 0x3ff]}}, @NL=
80211_TXRATE_HT=3D{0x19, 0x2, [{0x2, 0xa}, {0x6, 0x4}, {0x1, 0xa}, {0x4, =
0x7}, {0x6, 0x8}, {0x4, 0xa}, {0x2, 0x2}, {0x1, 0x1}, {0x4}, {0x2, 0x6}, =
{0x3, 0x3}, {}, {0x6}, {0x0, 0x2}, {0x7, 0x6}, {0x2, 0x2}, {0x6, 0x6}, {0=
x2, 0x6}, {0x7, 0x2}, {0x4, 0x3}, {0x2, 0x1}]}, @NL80211_TXRATE_HE_GI=3D{=
0x5, 0x6, 0x1}, @NL80211_TXRATE_GI=3D{0x5, 0x4, 0x2}, @NL80211_TXRATE_VHT=
=3D{0x14, 0x3, {[0x0, 0x8, 0x1, 0xfff7, 0x8, 0x7, 0x0, 0x9]}}, @NL80211_T=
XRATE_LEGACY=3D{0x20, 0x1, [0x6, 0xc, 0xc, 0x6c, 0x9, 0x12, 0x4, 0x4, 0x9=
, 0x6, 0x60, 0x48, 0x36, 0x1b, 0x1b, 0x5, 0x9, 0x12, 0xb, 0x1, 0x1, 0x9, =
0x30, 0x60, 0xb, 0x30, 0x3, 0x5]}, @NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0x=
0, 0xecd, 0xdbf, 0x3, 0x101, 0xa, 0x7, 0x7]}}, @NL80211_TXRATE_VHT=3D{0x1=
4, 0x3, {[0x67c2, 0x1, 0x6, 0x0, 0x0, 0x80, 0x100, 0x8]}}, @NL80211_TXRAT=
E_GI=3D{0x5}, @NL80211_TXRATE_HE_GI=3D{0x5, 0x6, 0x1}]}, @NL80211_BAND_6G=
HZ=3D{0xb0, 0x3, 0x0, 0x1, [@NL80211_TXRATE_HE_LTF=3D{0x5, 0x7, 0x1}, @NL=
80211_TXRATE_GI=3D{0x5, 0x4, 0x2}, @NL80211_TXRATE_LEGACY=3D{0x20, 0x1, [=
0x16, 0x24, 0x6c, 0xc, 0x36, 0x5, 0x60, 0x6, 0x60, 0x6, 0x60, 0x6, 0x24, =
0x4, 0xc, 0xc, 0x3, 0x60, 0x2, 0x6, 0x6c, 0x2, 0x18, 0x1, 0x4, 0x12, 0x30=
, 0x60]}, @NL80211_TXRATE_LEGACY=3D{0x1a, 0x1, [0x60, 0x3, 0x36, 0x1, 0x3=
0, 0x1, 0x4, 0x60, 0x3, 0x5, 0x18, 0x1b, 0x2, 0x6c, 0x1, 0x6, 0x30, 0x48,=
 0x6, 0x18, 0x9, 0x1b]}, @NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0x3, 0xcfda,=
 0x8, 0x9, 0xbed8, 0x9, 0x3, 0x6]}}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0=
xc31, 0xc902, 0x8, 0xff, 0xc, 0x6, 0x1ff, 0x9]}}, @NL80211_TXRATE_HE_GI=3D=
{0x5, 0x6, 0x2}, @NL80211_TXRATE_HT=3D{0x2e, 0x2, [{0x6, 0x7}, {0x4, 0x8}=
, {0x1, 0xa}, {}, {0x7, 0x1}, {0x4, 0x6}, {0x3, 0x1}, {0x2, 0x1}, {0x3, 0=
x3}, {0x1, 0x6}, {0x5, 0x8}, {0x4, 0x6}, {0x7, 0x7}, {0x1, 0xa}, {0x0, 0x=
4}, {0x5, 0x4}, {0x7, 0xa}, {0x3}, {0x7, 0x8}, {0x3, 0x6}, {0x1}, {0x1, 0=
x9}, {0x4, 0x3}, {0x6, 0x8}, {0x0, 0x8}, {0x1, 0x9}, {0x6, 0x4}, {0x7}, {=
0x2, 0x6}, {0x4, 0x7}, {0x7}, {0x4, 0xa}, {0x5}, {0x0, 0x6}, {0x2, 0xa}, =
{0x6}, {0x2, 0x1}, {0x6, 0x8}, {0x5, 0xa}, {0x7, 0x1}, {}, {0x6, 0x8}]}]}=
, @NL80211_BAND_5GHZ=3D{0x70, 0x1, 0x0, 0x1, [@NL80211_TXRATE_HE=3D{0x14,=
 0x5, {[0x1000, 0x0, 0x5, 0x1100, 0x3, 0x8, 0xf148, 0x67b2]}}, @NL80211_T=
XRATE_LEGACY=3D{0xf, 0x1, [0x0, 0x27, 0x9, 0x71, 0x4, 0x9, 0xb, 0x9, 0x1,=
 0x2, 0x60]}, @NL80211_TXRATE_HT=3D{0x13, 0x2, [{0x7, 0xa}, {0x1, 0x5}, {=
0x7, 0x9}, {0x4, 0x3}, {0x6, 0x7}, {0x4, 0xa}, {0x1, 0xa}, {0x4}, {}, {0x=
3, 0x7}, {0x0, 0x4}, {0x0, 0x5}, {0x0, 0x6}, {0x0, 0x5}, {0x6, 0x7}]}, @N=
L80211_TXRATE_GI=3D{0x5, 0x4, 0x1}, @NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0=
x7, 0x5, 0x9, 0x0, 0xe3af, 0x1, 0x5, 0x7]}}, @NL80211_TXRATE_HE_LTF=3D{0x=
5}, @NL80211_TXRATE_GI=3D{0x5}, @NL80211_TXRATE_HE_LTF=3D{0x5, 0x7, 0x2}]=
}, @NL80211_BAND_5GHZ=3D{0x14, 0x1, 0x0, 0x1, [@NL80211_TXRATE_HE_GI=3D{0=
x5, 0x6, 0x1}, @NL80211_TXRATE_HE_LTF=3D{0x5, 0x7, 0x2}]}, @NL80211_BAND_=
60GHZ=3D{0xa4, 0x2, 0x0, 0x1, [@NL80211_TXRATE_HT=3D{0xe, 0x2, [{0x4, 0x6=
}, {0x3, 0x7}, {0x1, 0x6}, {0x1, 0x8}, {0x4, 0x3}, {0x2, 0x1}, {0x0, 0x9}=
, {0x5, 0x3}, {0x4, 0x5}, {0x0, 0x4}]}, @NL80211_TXRATE_GI=3D{0x5}, @NL80=
211_TXRATE_HE=3D{0x14, 0x5, {[0xbe65, 0x2, 0xfffc, 0x3ff, 0x2, 0x570, 0x1=
]}}, @NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0x9, 0x0, 0x800, 0x80, 0x445, 0x=
f6, 0x3ff, 0x5]}}, @NL80211_TXRATE_HE_GI=3D{0x5}, @NL80211_TXRATE_LEGACY=3D=
{0x1c, 0x1, [0x7e12e0f92e9f1daa, 0x5, 0xc, 0x16, 0x6, 0xb, 0x1b, 0x60, 0x=
0, 0x18, 0x14, 0x1, 0x6c, 0x6c, 0xc, 0x6c, 0x71, 0xb, 0x6c, 0x18, 0x18, 0=
x1b, 0x9, 0x1b]}, @NL80211_TXRATE_HT=3D{0x3b, 0x2, [{0x2, 0x7}, {0x5}, {0=
x4, 0x4}, {0x7, 0x5}, {0x1, 0x2}, {0x3, 0x4}, {0x7, 0x9}, {0x4, 0x2}, {0x=
0, 0x3}, {0x4}, {0x3, 0x9}, {0x1, 0x6}, {0x0, 0x6}, {0x5, 0x5}, {}, {0x1,=
 0x4}, {0x0, 0x6}, {0x2, 0x1}, {0x1}, {0x2, 0x7}, {0x3, 0x2}, {0x7, 0x8},=
 {0x1, 0x9}, {0x4, 0x7}, {0x1, 0x8}, {0x6, 0x9}, {0x0, 0x1}, {0x3, 0xa}, =
{0x1}, {0x7, 0x6}, {0x2, 0x9}, {0x4, 0x9}, {0x2, 0x1}, {0x7, 0x1}, {0x0, =
0x1}, {0x7, 0x2}, {0x5, 0x1}, {0x1, 0x2}, {0x1, 0x4}, {0x4, 0x6}, {0x2, 0=
x3}, {0x0, 0x9}, {0x1, 0x3}, {0x5, 0x6}, {0x0, 0x1}, {0x3}, {0x5, 0xa}, {=
0x1, 0x9}, {0x1, 0x3}, {0x0, 0x7}, {0x4, 0x1}, {0x3, 0x9}, {0x1}, {0x5, 0=
x2}, {0x6, 0x6}]}]}]}]}, {0x18, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_ATTR_=
OVERRIDE=3D{0x4}, @NL80211_TID_CONFIG_ATTR_TIDS=3D{0x6, 0x5, 0xd8}, @NL80=
211_TID_CONFIG_ATTR_NOACK=3D{0x5, 0x6, 0x1}]}, {0xc, 0x0, 0x0, 0x1, [@NL8=
0211_TID_CONFIG_ATTR_AMSDU_CTRL=3D{0x5, 0xb, 0x1}]}]}, @NL80211_ATTR_TID_=
CONFIG=3D{0x494, 0x11d, 0x0, 0x1, [{0x45c, 0x0, 0x0, 0x1, [@NL80211_TID_C=
ONFIG_ATTR_TX_RATE=3D{0xf4, 0xd, 0x0, 0x1, [@NL80211_BAND_2GHZ=3D{0x2c, 0=
x0, 0x0, 0x1, [@NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0x800, 0x9, 0x40, 0x2,=
 0x6, 0x401, 0x40, 0x100]}}, @NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0x5, 0x4=
02a, 0xc000, 0x9, 0x9c5f, 0x100, 0x8, 0xa860]}}]}, @NL80211_BAND_60GHZ=3D=
{0x14, 0x2, 0x0, 0x1, [@NL80211_TXRATE_GI=3D{0x5, 0x4, 0x1}, @NL80211_TXR=
ATE_HE_LTF=3D{0x5, 0x7, 0x1}]}, @NL80211_BAND_6GHZ=3D{0x1c,
0x3, 0x0, 0x1, [@NL80211_TXRATE_GI=3D{0x5, 0x4, 0x2}, @NL80211_TXRATE_HE_=
GI=3D{0x5}, @NL80211_TXRATE_HE_LTF=3D{0x5, 0x7, 0x2}]}, @NL80211_BAND_6GH=
Z=3D{0x78, 0x3, 0x0, 0x1, [@NL80211_TXRATE_HT=3D{0x4a, 0x2, [{0x7, 0xa}, =
{0x2, 0x1}, {0x7, 0x8}, {0x2, 0x1}, {0x3, 0x7}, {0x1, 0x2}, {0x5, 0x9}, {=
0x6, 0x2}, {0x6, 0x6}, {0x4, 0x3}, {0x7, 0x1}, {0x0, 0x8}, {0x0, 0x4}, {0=
x2, 0x8}, {0x5, 0x7}, {0x0, 0x6}, {0x0, 0x3}, {0x1, 0xa}, {0x2, 0x1}, {0x=
4, 0x7}, {0x1}, {0x3, 0x5}, {0x4, 0x7}, {0x3, 0x7}, {0x2, 0x7}, {0x1, 0x6=
}, {0x7, 0x2}, {0x0, 0x5}, {0x1, 0x6}, {0x1, 0x7}, {0x7, 0x1}, {0x0, 0x8}=
, {0x6, 0x7}, {0x6, 0x9}, {0x7, 0x5}, {0x7, 0xa}, {0x7, 0x2}, {0x1, 0x9},=
 {0x3, 0x2}, {0x7, 0x7}, {0x7, 0x3}, {0x2, 0x1}, {0x7, 0x2}, {0x7, 0x5}, =
{0x6}, {0x5, 0x7}, {0x2, 0x1}, {0x1, 0x18}, {0x1, 0x1}, {0x0, 0x5}, {0x1,=
 0x7}, {0x1, 0x5}, {0x7, 0x4}, {0x5}, {0x5, 0x2}, {0x2, 0xa}, {0x4, 0x8},=
 {0x4, 0x2}, {0x5, 0x5}, {0x4, 0x4}, {0x7, 0x9}, {0x7, 0x9}, {0x1, 0x9}, =
{0x5, 0x4}, {0x7}, {0x7}, {0x6}, {0x6, 0x7}, {0x2, 0x6}, {0x4, 0x7}]}, @N=
L80211_TXRATE_HE=3D{0x14, 0x5, {[0x4, 0xfffc, 0x1, 0xa, 0x2, 0x5, 0xfffa,=
 0xc011]}}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x40, 0xff, 0xf, 0x0, 0x7f=
8, 0x5, 0x5115, 0x7]}}]}, @NL80211_BAND_5GHZ=3D{0x18, 0x1, 0x0, 0x1, [@NL=
80211_TXRATE_VHT=3D{0x14, 0x3, {[0x400, 0x2, 0x9, 0xe, 0x3063, 0x2, 0x7ff=
, 0x2]}}]}, @NL80211_BAND_60GHZ=3D{0x4}]}, @NL80211_TID_CONFIG_ATTR_TX_RA=
TE=3D{0x354, 0xd, 0x0, 0x1, [@NL80211_BAND_60GHZ=3D{0x80, 0x2, 0x0, 0x1, =
[@NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0x5, 0x7ff, 0x2, 0x8800, 0x101, 0x3,=
 0x3, 0x9]}}, @NL80211_TXRATE_GI=3D{0x5, 0x4, 0x1}, @NL80211_TXRATE_HE=3D=
{0x14, 0x5, {[0x1, 0x9, 0x7674, 0x1, 0x1, 0x8, 0x4, 0x7fff]}}, @NL80211_T=
XRATE_HE_LTF=3D{0x5, 0x7, 0x2}, @NL80211_TXRATE_HE_LTF=3D{0x5, 0x7, 0x2},=
 @NL80211_TXRATE_HE_GI=3D{0x5, 0x6, 0x2}, @NL80211_TXRATE_LEGACY=3D{0x15,=
 0x1, [0x1, 0x1b, 0x12, 0x4b, 0x30, 0x2, 0x18, 0x4, 0x30, 0x60, 0x0, 0x6c=
, 0x18, 0x9, 0x2, 0x12, 0x2]}, @NL80211_TXRATE_HE_GI=3D{0x5, 0x6, 0x1}, @=
NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0x80, 0x9, 0x1, 0xff, 0xe0f7, 0x4, 0xf=
e00, 0x101]}}]}, @NL80211_BAND_2GHZ=3D{0xc8, 0x0, 0x0, 0x1, [@NL80211_TXR=
ATE_LEGACY=3D{0x18, 0x1, [0x1b, 0xc, 0x3c, 0xc, 0x36, 0x3, 0x16, 0x48, 0x=
c, 0xe5, 0x18, 0xb, 0xc, 0x2, 0x1b, 0x36, 0x2, 0x48, 0x30, 0x36]}, @NL802=
11_TXRATE_HE_GI=3D{0x5, 0x6, 0x2}, @NL80211_TXRATE_GI=3D{0x5}, @NL80211_T=
XRATE_HT=3D{0x25, 0x2, [{0x1, 0x9}, {0x1, 0x5}, {0x0, 0x9}, {0x7, 0x6}, {=
0x7, 0x8}, {0x5, 0x3}, {0x2, 0x3}, {0x2, 0xa}, {0x6, 0x5}, {0x6, 0x4}, {0=
x7, 0xa}, {0x5, 0x2}, {0x3, 0x7}, {0x1, 0xa}, {0x3, 0x6}, {0x0, 0x6}, {0x=
5, 0x4}, {0x7, 0x9}, {0x5, 0x4}, {0x0, 0x8}, {0x2}, {0x7, 0x3}, {0x1, 0x4=
}, {0x6, 0x5}, {0x5, 0x5}, {0x3, 0xa}, {0x3, 0x2}, {0x6, 0x8}, {0x5, 0x2}=
, {0x6}, {0x1, 0x7}, {0x2, 0x2}, {0x3, 0x1}]}, @NL80211_TXRATE_HT=3D{0x3b=
, 0x2, [{0x6, 0x3}, {0x0, 0x1}, {0x5}, {0x0, 0x7}, {0x7, 0x9}, {0x1, 0x5}=
, {0x0, 0x5}, {0x3, 0x3}, {0x1, 0x4}, {0x0, 0x3}, {0x6, 0x1}, {0x0, 0x8},=
 {0x6, 0x6}, {0x7}, {0x1, 0x1}, {0x5, 0xa}, {0x4, 0x6}, {0x1, 0x7}, {0x0,=
 0xa}, {0x2}, {0x3, 0x6}, {0x4, 0x9}, {0x0, 0x2}, {0x2, 0xa}, {0x0, 0x2},=
 {0x5, 0x2}, {0x6, 0x7}, {0x0, 0x6}, {0x1, 0x1}, {0x7, 0x3}, {0x0, 0x2}, =
{0x6, 0x1}, {0x0, 0x3}, {0x1, 0x4}, {0x1}, {0x0, 0x3}, {0x4}, {0x0, 0x2},=
 {0x2, 0x8}, {0x2, 0x7}, {0x0, 0x2}, {0x0, 0x1b}, {0x1, 0x4}, {0x1, 0x8},=
 {0x6, 0x6}, {0x1, 0x6}, {0x7, 0x9}, {0x0, 0x4}, {0x0, 0x4}, {0x2, 0x5}, =
{0x7, 0x4}, {0x7, 0xa}, {0x2, 0x8}, {0x7, 0x8}, {0x1, 0x2}]}, @NL80211_TX=
RATE_HE=3D{0x14, 0x5, {[0x2, 0x8, 0xd2a, 0x0, 0xfff7, 0x8e, 0x8, 0x8]}}, =
@NL80211_TXRATE_GI=3D{0x5, 0x4, 0x1}, @NL80211_TXRATE_GI=3D{0x5}, @NL8021=
1_TXRATE_HE=3D{0x14, 0x5, {[0x72e, 0x1, 0x4, 0xfff, 0x7, 0x8, 0x80, 0x6]}=
}]}, @NL80211_BAND_60GHZ=3D{0x28, 0x2, 0x0, 0x1, [@NL80211_TXRATE_GI=3D{0=
x5}, @NL80211_TXRATE_HE_LTF=3D{0x5}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0=
xff, 0x800, 0xe, 0x7, 0x80, 0x4, 0x2bb7, 0xf088]}}]}, @NL80211_BAND_6GHZ=3D=
{0xd8, 0x3, 0x0, 0x1, [@NL80211_TXRATE_HE_GI=3D{0x5, 0x6, 0x1}, @NL80211_=
TXRATE_GI=3D{0x5, 0x4, 0x3}, @NL80211_TXRATE_HT=3D{0x11, 0x2, [{0x0, 0x7}=
, {0x1}, {0x0, 0xa}, {0x1, 0x7}, {0x7, 0x1}, {0x3, 0x3}, {0x5, 0x5}, {0x5=
}, {0x5, 0x6}, {0x0, 0x2}, {0x7, 0x2}, {0x2, 0x7}, {0x2, 0x5}]}, @NL80211=
_TXRATE_LEGACY=3D{0x19, 0x1, [0xb, 0xb, 0x1d, 0x17, 0x3, 0x12, 0xb, 0x6, =
0x12, 0x30, 0xb, 0x60, 0xc, 0x3, 0x2, 0x36, 0x0, 0x30, 0x1, 0xb, 0xb]}, @=
NL80211_TXRATE_HT=3D{0x34, 0x2, [{0x5, 0x2}, {0x5, 0x5}, {0x2, 0x1}, {0x6=
, 0x2}, {0x1, 0x6}, {0x6, 0x9}, {0x6, 0x7}, {0x1, 0x3}, {0x1, 0x7}, {0x3,=
 0x1}, {0x7, 0x4}, {0x6, 0x4}, {0x6, 0x9}, {0x5, 0x7}, {0x4, 0x3}, {0x6, =
0x2}, {0x0, 0x7}, {0x1, 0xa}, {0x2, 0x8}, {0x7, 0x9}, {0x1, 0xa}, {0x4, 0=
x9}, {0x1, 0x8}, {0x5, 0x3}, {0x5, 0x7}, {0x4}, {0x6, 0x9}, {0x0, 0x2}, {=
0x2, 0x1}, {0x5, 0xa}, {0x1, 0x6}, {0x1, 0xa}, {0x4, 0xa}, {0x7, 0x8}, {0=
x1, 0x3}, {0x4, 0x3}, {0x3, 0x2}, {0x5}, {0x6, 0x8}, {0x6}, {0x2, 0xa}, {=
0x5, 0x6}, {0x2, 0x9}, {0x6, 0x4}, {0x6, 0x7}, {0x0, 0x4}, {0x4, 0x2}, {0=
x7, 0x7}]}, @NL80211_TXRATE_HT=3D{0x20, 0x2, [{0x2, 0x4}, {0x2, 0x6}, {0x=
6, 0x5}, {0x3, 0x8}, {0x6, 0x1}, {0x4, 0xa}, {0x0, 0x9}, {0x1, 0x5}, {0x2=
, 0x7}, {0x5, 0x3}, {0x3, 0x7}, {0x6, 0x5}, {0x0, 0x7}, {0x0, 0x4}, {0x5}=
, {0x7, 0x4}, {0x1, 0x8}, {0x0, 0x7}, {0x3, 0x1}, {0x0, 0x9}, {0x0, 0x1},=
 {0x0, 0x1}, {0x6, 0xa}, {0x2, 0x8}, {0x2, 0x1}, {0x3, 0x6}, {0x6, 0x3}, =
{0x1, 0x1}]}, @NL80211_TXRATE_HT=3D{0x21, 0x2, [{0x0, 0x3}, {0x2, 0x5}, {=
0x1, 0x8}, {0x6, 0x1}, {0x2, 0x2}, {0x1, 0x6}, {0x7, 0x4}, {0x2, 0x2}, {0=
x7, 0xa}, {0x7, 0x9}, {0x3, 0x7}, {0x3, 0x3}, {0x0, 0xa}, {0x2}, {0x1, 0x=
1}, {0x4}, {0x1, 0x9}, {0x5, 0x4}, {0x0, 0x8}, {0x0, 0x2}, {0x5, 0x3}, {0=
x0, 0x8}, {0x2, 0x7}, {0x2, 0x2}, {0x2}, {0x6, 0xa}, {0x3, 0x2}, {0x4}, {=
0x7, 0x2}]}, @NL80211_TXRATE_HE_LTF=3D{0x5}, @NL80211_TXRATE_HE=3D{0x14, =
0x5, {[0xcb00, 0x5, 0x9, 0x200, 0x1, 0xfff, 0x2ee, 0x1]}}]}, @NL80211_BAN=
D_60GHZ=3D{0x6c, 0x2, 0x0, 0x1, [@NL80211_TXRATE_GI=3D{0x5, 0x4, 0x1}, @N=
L80211_TXRATE_VHT=3D{0x14, 0x3, {[0x0, 0x3, 0x2, 0x3, 0x401, 0x1000, 0x1f=
f, 0x4000]}}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x6, 0x2, 0x40, 0xa, 0x6=
, 0x1000, 0x5, 0x74]}}, @NL80211_TXRATE_LEGACY=3D{0x1d, 0x1, [0x18, 0x36,=
 0x12, 0x9, 0x24, 0x16, 0x9, 0x1b, 0x1, 0x6, 0x6, 0x60, 0x18, 0x3, 0x0, 0=
x24, 0x6, 0x30, 0x5, 0x18, 0x48, 0x1, 0x1e, 0x12, 0x5]}, @NL80211_TXRATE_=
LEGACY=3D{0x17, 0x1, [0x48, 0x1, 0x36, 0x1, 0x0, 0x30, 0x16, 0x9, 0x1, 0x=
48, 0xb, 0x9, 0x36, 0x2, 0x1b, 0x6, 0x16, 0x6, 0x6]}]}, @NL80211_BAND_6GH=
Z=3D{0x4}, @NL80211_BAND_6GHZ=3D{0x98, 0x3, 0x0, 0x1, [@NL80211_TXRATE_HE=
_GI=3D{0x5, 0x6, 0x1}, @NL80211_TXRATE_HE=3D{0x14, 0x5, {[0x2, 0x3, 0x7ff=
f, 0x4, 0x9, 0xffff, 0x38d3, 0x6]}}, @NL80211_TXRATE_HT=3D{0x36, 0x2, [{0=
x2, 0x1}, {0x2, 0x7}, {0x1, 0x8}, {0x0, 0x8}, {0x2, 0x2}, {0x1, 0xa}, {0x=
0, 0x9}, {0x0, 0x7}, {0x0, 0x1}, {0x3, 0x2}, {0x3, 0x8}, {0x0, 0x4}, {0x7=
, 0x1}, {0x1, 0x6}, {0x5, 0x7}, {0x7, 0x6}, {0x1, 0x9}, {0x4, 0x1}, {0x0,=
 0xa}, {0x7, 0x5}, {0x6, 0x6}, {0x0, 0x1}, {0x2}, {0x5, 0x2}, {0x7, 0x7},=
 {0x1}, {}, {0x5, 0x5}, {0x1}, {0x7, 0x5}, {0x4, 0x1}, {0x3}, {0x4, 0x5},=
 {0x2, 0x6}, {0x5, 0x9}, {0x0, 0x6}, {0x3, 0x9}, {0x7, 0x5}, {0x3, 0x1}, =
{0x7, 0x2}, {0x0, 0x4}, {0x6, 0x6}, {0x3, 0x7}, {0x7}, {0x1, 0x2}, {0x4},=
 {0x2, 0x9}, {0x3, 0x1}, {0x0, 0x5}, {0x7, 0x2}]}, @NL80211_TXRATE_HT=3D{=
0x2a, 0x2, [{0x2, 0x5}, {0x7, 0x7}, {0x7}, {0x5, 0x9}, {0x0, 0x3}, {0x5},=
 {0x3, 0x8}, {0x7}, {0x4, 0x2}, {0x2, 0x7}, {0x4, 0x6}, {0x0, 0x1}, {0x5,=
 0x3}, {0x1, 0x6}, {0x3}, {0x2, 0x4}, {0x0, 0x4}, {0x0, 0xa}, {0x6, 0x5},=
 {0x0, 0x2}, {0x6, 0x8}, {0x1, 0x2}, {0x5, 0x6}, {0x6, 0x6}, {0x4, 0x6}, =
{0x2, 0x1}, {0x0, 0x3}, {0x6, 0x4}, {0x7, 0x6}, {0x5, 0x5}, {0x7, 0x8}, {=
0x1, 0x9}, {0x5, 0x5}, {0x2, 0x3}, {0x7, 0x2}, {0x2, 0x1}, {0x2, 0x3}, {0=
x1, 0x2}]}, @NL80211_TXRATE_VHT=3D{0x14, 0x3, {[0x2, 0x400, 0x5, 0x7f, 0x=
0, 0x2, 0x80, 0x7]}}]}]}, @NL80211_TID_CONFIG_ATTR_TX_RATE=3D{0x10, 0xd, =
0x0, 0x1, [@NL80211_BAND_60GHZ=3D{0xc, 0x2, 0x0, 0x1, [@NL80211_TXRATE_HE=
_GI=3D{0x5, 0x6, 0x1}]}]}]}, {0xc, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_AT=
TR_TIDS=3D{0x6, 0x5, 0x9d}]}, {0xc, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_A=
TTR_TIDS=3D{0x6, 0x5, 0xad}]}, {0x1c, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG=
_ATTR_RETRY_LONG=3D{0x5, 0x8, 0xe1}, @NL80211_TID_CONFIG_ATTR_RETRY_SHORT=
=3D{0x5, 0x7, 0x45}, @NL80211_TID_CONFIG_ATTR_OVERRIDE=3D{0x4}, @NL80211_=
TID_CONFIG_ATTR_OVERRIDE=3D{0x4}]}]}, @NL80211_ATTR_TID_CONFIG=3D{0x38, 0=
x11d, 0x0, 0x1, [{0xc, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_ATTR_NOACK=3D{=
0x5, 0x6, 0x1}]}, {0x28, 0x0, 0x0, 0x1, [@NL80211_TID_CONFIG_ATTR_RETRY_S=
HORT=3D{0x5, 0x7, 0xfc}, @NL80211_TID_CONFIG_ATTR_NOACK=3D{0x5}, @NL80211=
_TID_CONFIG_ATTR_NOACK=3D{0x5}, @NL80211_TID_CONFIG_ATTR_PEER_SUPP=3D{0xc=
, 0x3, 0x5472}]}]}]}, 0x1028}, 0x1, 0x0, 0x0, 0x4000080}, 0x4004001)
socket$nl_generic(0x10, 0x3, 0x10)
openat$cgroup_pressure(0xffffffffffffffff, &(0x7f0000001600)=3D'cpu.press=
ure\x00', 0x2, 0x0)
r4 =3D syz_genetlink_get_family_id$smc(&(0x7f0000001680), r0)
sendmsg$SMC_PNETID_FLUSH(r0, &(0x7f0000001780)=3D{&(0x7f0000001640)=3D{0x=
10, 0x0, 0x0, 0x400}, 0xc, &(0x7f0000001740)=3D{&(0x7f00000016c0)=3D{0x50=
, r4, 0x10, 0x70bd27, 0x25dfdbfb, {}, [@SMC_PNETID_IBNAME=3D{0x9, 0x3, 's=
yz2\x00'}, @SMC_PNETID_IBPORT=3D{0x5, 0x4, 0x2}, @SMC_PNETID_IBPORT=3D{0x=
5, 0x4, 0x2}, @SMC_PNETID_IBNAME=3D{0x9, 0x3, 'syz0\x00'}, @SMC_PNETID_ET=
HNAME=3D{0x14, 0x2, 'veth0_to_bridge\x00'}]}, 0x50}, 0x1, 0x0, 0x0, 0x100=
08053}, 0x0)
r5 =3D socket$nl_generic(0x10, 0x3, 0x10)
r6 =3D syz_genetlink_get_family_id$batadv(&(0x7f0000001800), r0)
sendmsg$BATADV_CMD_SET_HARDIF(r5, &(0x7f00000018c0)=3D{&(0x7f00000017c0)=3D=
{0x10, 0x0, 0x0, 0x40}, 0xc, &(0x7f0000001880)=3D{&(0x7f0000001840)=3D{0x=
3c, r6, 0xe08, 0x70bd2d, 0x25dfdbfd, {}, [@BATADV_ATTR_ORIG_INTERVAL=3D{0=
x8, 0x39, 0x38}, @BATADV_ATTR_ISOLATION_MARK=3D{0x8, 0x2b, 0x10000}, @BAT=
ADV_ATTR_AGGREGATED_OGMS_ENABLED=3D{0x5, 0x29, 0x1}, @BATADV_ATTR_GW_BAND=
WIDTH_DOWN=3D{0x8, 0x31, 0xb}, @BATADV_ATTR_AGGREGATED_OGMS_ENABLED=3D{0x=
5, 0x29, 0x1}]}, 0x3c}, 0x1, 0x0, 0x0, 0x4040086}, 0x80)
sendmsg$NL80211_CMD_GET_SURVEY(r0, &(0x7f00000019c0)=3D{&(0x7f0000001900)=
=3D{0x10, 0x0, 0x0, 0x22080001}, 0xc, &(0x7f0000001980)=3D{&(0x7f00000019=
40)=3D{0x20, r3, 0x400, 0x70bd2c, 0x25dfdbfc, {{}, {@void, @val=3D{0xc, 0=
x99, {0x4, 0x74}}}}, [""]}, 0x20}, 0x1, 0x0, 0x0, 0x80}, 0x2400c000)
r7 =3D socket$nl_generic(0x10, 0x3, 0x10)
ioctl$sock_SIOCGIFINDEX_80211(r0, 0x8933, &(0x7f0000001a40)=3D{'wlan0\x00=
', <r8=3D>0x0})
sendmsg$NL80211_CMD_REGISTER_BEACONS(r7, &(0x7f0000001b00)=3D{&(0x7f00000=
01a00)=3D{0x10, 0x0, 0x0, 0x8000}, 0xc, &(0x7f0000001ac0)=3D{&(0x7f000000=
1a80)=3D{0x24, r3, 0x2, 0x70bd28, 0x25dfdbff, {{}, {@val=3D{0x8, 0x1, 0x3=
7}, @val=3D{0x8, 0x3, r8}, @void}}, ["", "", ""]}, 0x24}, 0x1, 0x0, 0x0, =
0xc0}, 0xc840)
socket$inet_icmp_raw(0x2, 0x3, 0x1)
r9 =3D syz_open_dev$vcsu(&(0x7f0000001b40), 0x8, 0xc0000)
sendmsg$NFT_MSG_GETFLOWTABLE(r9, &(0x7f0000001c40)=3D{&(0x7f0000001b80)=3D=
{0x10, 0x0, 0x0, 0x1000}, 0xc, &(0x7f0000001c00)=3D{&(0x7f0000001bc0)=3D{=
0x2c, 0x17, 0xa, 0x101, 0x0, 0x0, {0x7}, [@NFTA_FLOWTABLE_HANDLE=3D{0xc, =
0x5, 0x1, 0x0, 0x5}, @NFTA_FLOWTABLE_HANDLE=3D{0xc, 0x5, 0x1, 0x0, 0x1}]}=
, 0x2c}, 0x1, 0x0, 0x0, 0x800}, 0x800)
ioctl$TIOCMGET(r9, 0x5415, &(0x7f0000001c80))
r10 =3D syz_genetlink_get_family_id$ipvs(&(0x7f0000001d00), r9)
sendmsg$IPVS_CMD_SET_INFO(r5, &(0x7f0000001dc0)=3D{&(0x7f0000001cc0)=3D{0=
x10, 0x0, 0x0, 0x1000000}, 0xc, &(0x7f0000001d80)=3D{&(0x7f0000001d40)=3D=
{0x1c, r10, 0x4, 0x70bd2a, 0x25dfdbfd, {}, [@IPVS_CMD_ATTR_TIMEOUT_UDP=3D=
{0x8, 0x6, 0x7}]}, 0x1c}, 0x1, 0x0, 0x0, 0x8000}, 0x40000)
read$FUSE(r9, &(0x7f0000001e00)=3D{0x2020, 0x0, 0x0, 0x0, 0x0, <r11=3D>0x=
0}, 0x2020)
capget(&(0x7f0000003e40)=3D{0x20071026, r11}, &(0x7f0000003e80)=3D{0x13, =
0xfb, 0x4, 0x0, 0xfffffff7, 0x4})
r12 =3D socket$nl_route(0x10, 0x3, 0x0)
ioctl$sock_SIOCGIFINDEX_80211(r12, 0x8933, &(0x7f0000003f00)=3D{'wlan1\x0=
0', <r13=3D>0x0})
sendmsg$NL80211_CMD_SET_MPATH(r5, &(0x7f0000004000)=3D{&(0x7f0000003ec0)=3D=
{0x10, 0x0, 0x0, 0x200000}, 0xc, &(0x7f0000003fc0)=3D{&(0x7f0000003f40)=3D=
{0x4c, r3, 0x2, 0x70bd28, 0x25dfdbfc, {{}, {@val=3D{0x8, 0x3, r13}, @val=3D=
{0xc, 0x99, {0x7f61, 0x34}}}}, [@NL80211_ATTR_MAC=3D{0xa, 0x6, @broadcast=
}, @NL80211_ATTR_MPATH_NEXT_HOP=3D{0xa, 0x1a, @device_b}, @NL80211_ATTR_M=
PATH_NEXT_HOP=3D{0xa}]}, 0x4c}, 0x1, 0x0, 0x0, 0x44005}, 0x40040)

930.5007ms ago: executing program 0 (id=3D13570):
r0 =3D socket$nl_route(0x10, 0x3, 0x0)
r1 =3D syz_open_procfs(0x0, &(0x7f00000007c0)=3D'net/vlan/vlan0\x00')
read$FUSE(r1, &(0x7f0000002640)=3D{0x2020}, 0x2020)
sendmsg$nl_route(r0, &(0x7f0000000040)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000140)=3D@newlink=3D{0x40, 0x10, 0x711, 0x70bf28, 0x25dfdbfc, =
{0x0, 0x0, 0x0, 0x0, 0x430e5, 0x20000}, [@IFLA_LINKINFO=3D{0x20, 0x12, 0x=
0, 0x1, @gre=3D{{0x8}, {0x14, 0x2, 0x0, 0x1, [@IFLA_GRE_IFLAGS=3D{0x6, 0x=
2, 0x4}, @IFLA_GRE_IKEY=3D{0x8, 0x4, 0x9e8}]}}}]}, 0x40}, 0x1, 0x0, 0x0, =
0x4000000}, 0x2004e840)

928.54613ms ago: executing program 0 (id=3D13571):
r0 =3D bpf$MAP_CREATE_RINGBUF(0x0, &(0x7f00000007c0)=3DANY=3D[@ANYBLOB=3D=
"1b0000000000000000000000000004"], 0x48)
madvise(&(0x7f0000ffd000/0x1000)=3Dnil, 0x1000, 0x17)
madvise(&(0x7f0000ffd000/0x3000)=3Dnil, 0x3000, 0x15)
r1 =3D syz_open_procfs(0x0, &(0x7f00000000c0)=3D'pagemap\x00')
read$FUSE(r1, &(0x7f0000002080)=3D{0x2020}, 0xffffff37)
bpf$PROG_LOAD(0x5, &(0x7f00000009c0)=3D{0x18, 0xf, &(0x7f0000000d00)=3DAN=
Y=3D[@ANYBLOB=3D"1800000003000000000000000200000018110000", @ANYRES32=3Dr=
0, @ANYBLOB=3D"0000000000000000b702000014000000b7030000000000008500000083=
000000bf0900000000000055090100000000009500000000000000bf91000000000000b70=
20000000000008100000000000000b70000000000000095"], &(0x7f0000000ac0)=3D'G=
PL\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @fallback=3D0x9, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x3ff}, 0x94)
r2 =3D bpf$PROG_LOAD(0x5, &(0x7f00000007c0)=3D{0x20, 0x3, &(0x7f000000000=
0)=3DANY=3D[@ANYBLOB=3D"1800000000000000000000000000000095000000000000005=
a1ce89d73af427f7ac9cff9b235660ed9941097eea0d06079124bb58392cdecf582dddc26=
6758503e4a21a6f22c1e0ad258748bdf377c1041fb726cda914eb1ef7bb0fd0a6f0d6c345=
8b407e9d1b1a9958abf1bd73f29c6fb4b510fcf80440820d986933c02782da3ff9ca0256a=
b6b2d039a1ad7fac174a58cb03b291193ac090b6ff2b596590d9fa4ce37a27dcd50853b12=
5543b"], &(0x7f0000000500)=3D'GPL\x00', 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', =
0x0, @netfilter=3D0x2d, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000200)=3D{r2, 0x0, 0x14, 0x0, &(0x7=
f0000000340)=3D"0f8888ce33dfd57ef99e494786dd0978962e6f85", 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0}, 0x50)

655.82056ms ago: executing program 3 (id=3D13572):
r0 =3D socket$nl_generic(0x10, 0x3, 0x10)
r1 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
sendmsg$IPCTNL_MSG_CT_DELETE(r1, &(0x7f0000000300)=3D{0x0, 0x0, &(0x7f000=
0000080)=3D{&(0x7f0000000380)=3DANY=3D[@ANYBLOB=3D"2000000002010101000000=
000000000002000004040019800800084000000004074605dbb42130d2465f80605e4e9b6=
239a15c7441dbd11e8f21e7f65c4001875b4d5e20dfa6"], 0x20}, 0x1, 0x0, 0x0, 0x=
4048411}, 0x0)
r2 =3D syz_create_resource$binfmt(&(0x7f0000000040)=3D'./file1\x00')
r3 =3D openat$binfmt(0xffffffffffffff9c, r2, 0x42, 0x1ff)
unshare(0x40000200)
close(r3)
execveat$binfmt(0xffffffffffffff9c, r2, 0x0, 0x0, 0x0)
r4 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
perf_event_open(&(0x7f0000000080)=3D{0x2, 0x80, 0x3, 0xb, 0x0, 0x0, 0x0, =
0x7ff, 0x140c1, 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x=
0, 0x1, 0x0, 0x1, 0x1, 0x3, 0x1, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, =
0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x9, 0x4=
, @perf_bp=3D{0x0, 0x5}, 0x100001, 0x0, 0xc000000, 0x5, 0x3, 0x5, 0x80, 0=
x0, 0x0, 0x0, 0x60}, 0x0, 0xffffffffffffffff, 0xffffffffffffffff, 0xb)
r5 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r5, &(0x7f0000000000)=3D{0x0, 0x0, &(0x7f0000000440)=3D{=
&(0x7f0000000340)=3DANY=3D[@ANYBLOB=3D"24000000640001002abd7000fddbdf2500=
000000", @ANYRES32=3Dr5], 0x24}}, 0x20000000)
sendmsg$NFNL_MSG_CTHELPER_NEW(r4, &(0x7f0000001440)=3D{0x0, 0x0, &(0x7f00=
00001400)=3D{&(0x7f00000002c0)=3DANY=3D[@ANYBLOB=3D"280000008009010100000=
000000000000000000708000540000000060900010087ce4dad3355a03a"], 0x28}, 0x1=
, 0x0, 0x0, 0x60000004}, 0x8010)
fcntl$lock(r4, 0x6, &(0x7f0000000280)=3D{0x2, 0x2, 0x3, 0x8})
fcntl$lock(r0, 0x7, &(0x7f0000000100)=3D{0x2, 0x1, 0x0, 0xa00})
r6 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
r7 =3D socket$inet6_udplite(0xa, 0x2, 0x88)
mkdirat(0xffffffffffffff9c, &(0x7f0000000040)=3D'./file0\x00', 0x1c0)
socketpair$nbd(0x1, 0x1, 0x0, &(0x7f0000000f80)=3D{<r8=3D>0xfffffffffffff=
fff, <r9=3D>0xffffffffffffffff})
sendmsg$IPSET_CMD_RENAME(r9, &(0x7f0000000180)=3D{0x0, 0x0, &(0x7f0000000=
140)=3D{&(0x7f00000001c0)=3DANY=3D[], 0x14}, 0x1, 0x0, 0x0, 0x4}, 0x801)
readv(r8, &(0x7f0000000100)=3D[{&(0x7f00000000c0)=3D""/45, 0x2d}], 0x1)
mount$tmpfs(0x0, &(0x7f0000000080)=3D'./file0\x00', &(0x7f00000000c0), 0x=
10000, &(0x7f0000000200)=3DANY=3D[@ANYBLOB=3D"7569ab69dc0f2d409cc5df0755d=
efab100000000c7f96202cb9058489d939124840c12620636b5f7e286af0b29f98e3a0ae1=
8433780f8acc0635f989d3398b5e8e7e37b23635a77c4bee335f", @ANYRESHEX=3D0x0, =
@ANYBLOB=3D',\x00'])
sendmmsg$inet6(r7, &(0x7f00000041c0)=3D[{{&(0x7f00000001c0)=3D{0xa, 0x4e2=
4, 0x400, @mcast2, 0xb}, 0x1c, &(0x7f0000002880)=3D[{&(0x7f00000043c0)=3D=
"8a9d519a5cd623ac4c24a5d17e95e850fdbae0f9fa3d324b79d4302f44137d3373f645af=
bf9c9ffef6b70c4d7b494fa5924fa5b5d416b69786932bcbb6e2e422bb845d0ab780438bb=
847f5d74c8989e48c79ef9bf6fd1892f3b45c72069dfd0eca99da8e60b3ef4f7bd42a22fc=
9a422d79ced54d4f3cde3f55ad8561540db4a5e24303cc7cad29302c1ee99660fbf4679e0=
8390c6967bef594c0089d7e3cf2db785c75c322b30bc90e2fb57fdd9720cabbb50c3f6ce7=
3b4f7916599a2222e8646f25c86e4f5fc8a8b77fb38ff9175ffaa9b4b3fba9f404fa47fdb=
4f106b146244dafbaf47f97395a9c90cf19dec6de686588a7f54f5068a89653a1224fec38=
226f20e2a2b453f339afb324c497f7aee4c8e7ecb155a92a8847364c719cc59942ec8d669=
045630787d123103e5e6312ead36f9ddfc0a526a883552fd56d52e1a1b4deed9c93794714=
dbdde4673e73889486ed868357760f1dcdebf091d6ef1920aefd1296b295b3cd58300e35d=
8fa3065bcbc139a953e93d97ab718017aefede494f232c1bf3bd2555990ee24035814abb6=
fd027823da449a91dcbc7c5f97b0555ac70cc8fafc64b105348c3847de895155be933da92=
63113c7ae1e62118da30c06964d9dc7d3d4eb514ebd8f57be2673d86d48bf2dc8dd049f21=
141c6ca732f11a8e2754f58073739f624bfd72ed8e0cb18142bdf6d8d3f1943a530b5aa64=
fffc11b20a9a7a042a53b67b36f125199d434fcb037e7e938e23da9f892e67c2382f915c5=
3ea23fad07aedb37bd3e970cb32ed3a2e4d4bd4720dfae573b54aeacaf8cc6c0dce1333a4=
576fa6aa7dc10e218e95daf192c71ccee8d8a5c2a712d541231d788e3597a235c4173bd6e=
26be3f16da8ff70dd4e5e12ca2885f5349552da45c026cd236353d89918704934aca947f3=
439a706d775d358e8845ba507e77bcf301407baf96665fde187b30905e97c3dcf4a6203c6=
138f586562a792d545ec53eb2f4df4f09875ace7f1d01afc53ba1cdbdbe49ddaa6122998d=
7b0119c0c6309b6db39c56d57f80a2388b87417610fd0f9549b91bcb3750733a800c93a64=
c807692744657002a2e1204ab931a27a710bb4ce5b8d91e3f0bbbc9402d691fbb509fafc6=
aff97af92ef61f038f2aa4577cc36ac116f32a639f50462cc3e6e85bc5a63e8c7227c0e17=
e3b0afc735013217113734bb102d49dbd199181dba9415335138cb00646d20ab7ca1b14ef=
32120111df91e89dd8d83026a928de55933c0012ca4411f3c70db6cb350b2c7bdb65b3f00=
14fae12d775dddc0dec15d72e62c6c495d21d53b801f8aaf36cceb99188f7c01bdb7975e3=
0098433e8d11889f81f092a3ae2e1159979e1e78874977f8c06aba910fec9e3328372f064=
fff24b0ae9384e0f0d9ca3d8acfc6bb987fcb369b0b71a06b9545c9fb2f189e6df05170cc=
8b76a97061c968d21647b3cbfe048a8c3b61dc6fc64ee8ba215698f3faccabe458778a201=
6b236066ce410a79235994b86f8d7642bc98c875b43111750ca599dd37915b5e0106f0a61=
9d95750603e2bfd926ddba5a5befb4fffab1d04ba22dc5132d92d58de63b16fef17394c87=
300b2dea674de803e74da502e8259a44346f44a20a33bf5c2b1c3a8ab146ca4b23f140732=
fff4626f4f9b7fc4c61a7ee1b6c630accc7d5d7c260b2a254bb48683a82c84555a70d3b02=
ad4d0e173992f75dc66da2aed9469af1d95465c5a7a5403e483835e4ba32efb5fa7ba6837=
0e8c7e0d5baaa07ab7cd10018700d047768933d159f696c88b6147419ac05e4ef152c039b=
e480e82f0e734dc305afd3119ae80b01880586b4fa0ae2a91c79cadde452b58d9517a14c1=
3f05487004ffc5b605aa81e78626254869e46c973906619ba8bc066f8c12569b00729efc0=
7fd7bacaea2406a9ad31e5f6f0bdb965ae4d81571a9ba3f304fb95200b16c09d3120f6d73=
55d9d4e5ce6a788e56f47a12babab3b22182cc036e464b8e89a97df9563d95e8cef7ae711=
d9b7442e8fd1562f8f141208b9a9ad9ad617c769a202119bacfb29ddef4e8475420083e50=
50c3c833c6cd803fc4fb5197d21a771a82258c9afc98886187dd88b9bcc62232774dcbff7=
538cff73ff4a65d925d96e5f91672ff73637a57e3c15babe028da9495ef530ecc5d4da796=
a81e8c78e5ef29494a35b3bb1dbaf459318e63e9fc66da456473897a42924e02a0ab34068=
950fa35c8b04013e7563dfbb383e28a016f723d8f9f1b3fc4eab649256c7716ff12a77f2c=
5de4aed156ef5711d13c8dfbd0da7dbe04a66b6bfe2f7ecbd134537028c7dde1ee1eb0d61=
9fc25f5a11caf7f90e96b8d507c05fa2a2f3a324c6fee813ab46d615e33625cf95b7d09b4=
ead272150b00f4b11a7d9e60326ccb1796c37b84a1e36eb2f87df745133b73b1a767cbd85=
65f202bdb9b1b64cb940815da29adee79775fc53bd89f3080e2a3a1d6766248fbf4d2541e=
f4a0dbcf65d1fe2be5b298d4062ff8d05c29eb0f0b4727964204cce68178db3909f245312=
e146e18294d9500afc0149ec352e0e5d41afd68fd4c9609fe1a2bb95cda83876b235c6bf8=
43ab746f8bb0de03de5676c195fef6d72574b091f030e74e9065639996640eaa572170f93=
e6fe681b908cc003fcc3502883654324f7aace5f1a1809d9f20642d6520bd0ac8bb35b009=
ecae380f244c83f41e5369a58e8bfcf5f172d5776fc5edee84e959707d26320b94bc06c05=
861a85875975b9667cfcf0b08ffbaf92c1b85d2f4b3f718f22cb71c40a0ad079e35f62277=
60484e439b1dffa10f527bb36af9687d345032323b390e613e9079d68052a804e2e39a0a7=
fef8ac0c35cf611e821f4ebf269fe3891a4dd7fd36dd6ef89a028ab85f97928fa118ca585=
a9d4e49912c8aefd179b23aafba7c14a2965688e20579de5d46803db6c4382b5e135b2df8=
36467183f7ab52841d53c1b54e3dd19221a8612c22b7b3606d3c5967b77e391447e1b7dc7=
14efb45ab8f84924f532543774ebc7505c4d2c33df609f741ebc351ae1a18f9e77f325ca9=
0e5fac22c030a50943f66118e5225884247ff4ed3333ac5d4ee542c19f5a2634333ed2669=
69e9c75d50b278f88bbceb1cc1edd163477f60bafff4b3b98b06a115fa50119c35aa0756a=
d62620bcf5d88a53bcf7c8e4bf1b61efa5552366cf46127fbc6f4f39862ea9a51d8c1b0ae=
4825532dab60ece9b5118d6c725431cd7ccce8e63ddd01d0e45a370ffcf71b08a630051fe=
c9e856da30534ca9ee4ac61a6f1669fe0f95b8c4c54eb1efe1d4376beb6506355524f4f92=
3c1ec115359993dc6a9cd46559831c2931cc605bfa9389a9d92da4a1ed531fc2cbbafe8c4=
2cb0bd75ff1e2c0dda30e359611549ce6a25df9a69ffa266d830d6b91cc859b8774eb007f=
24c544ba7187b981b0eb9f99ca2150005e28512e1e87fb5dfc18aef1d26c5603dec919854=
dda1a504a9580446d013432d8b6cd739a780430f8de49f0d8df1d65f3e8c21d9d9849f797=
1f22343e56710842a697ff31f0530f2813b82b2d418f57755363ce90cacfe5d472540ae0b=
259fa629ac14e64c976417f83ab593ee6e053ca0f347bc95e920d8714c818bc018c77d5e8=
9136f92d56c74eeaf705e947bfb280a5bce42ccb53d57c9512dd38477f969265f26cbcc68=
5a4d22f7f205f7eafcd279f03df28cf924a4101b4af401983672b50315b7b7b4e2e2dceca=
4a33252e8748f10278dcdcbfeb6740e7f57bc52d5405778ca5b23c20fe350e7c380a5d599=
167ea239bd6113db33fb259f38b40475401daa67a7d410b2df8d92b0a5ee273354c697d35=
0b27ba15d41edada6d086329c975448178df1e886bb86ca524115bfd3b11dbb2b5eeaf892=
cb03e964e0512ecd6835ce0d9d2b32ba926bd9a37642101fe3d68b3f23c50e74e9e25468d=
52c9d1af64a246f1db90a4d4289e7df08325ad2e4fc13aa84e80d39221fca3d4ebc20d15a=
7e0a7b338bf4d0d8bd871a3c2a2a27225fa3d6c9324bd64b15d02d536d064fe40223b302e=
7172dfd1f7493a3ca8a782696af6051fb11ff6aae13fdea7a402fac2ffe0b8edd12fb6c35=
5f66cbce67c4", 0xb49}], 0x1}}], 0x1, 0x1)
sendmsg$IPSET_CMD_CREATE(r6, &(0x7f0000000340)=3D{0x0, 0x0, &(0x7f0000000=
100)=3D{&(0x7f0000000000)=3DANY=3D[@ANYBLOB=3D"58000000020601030000000000=
0000200700000a050001000700000305000500020000000900020073797a3000000000050=
004000000000014000300686173683a690300000072742c6970000c000780080012400010=
"], 0x58}, 0x1, 0x0, 0x0, 0x4004000}, 0x20008000)
syz_genetlink_get_family_id$devlink(&(0x7f0000000400), 0xffffffffffffffff=
)
preadv(r6, &(0x7f0000000180)=3D[{&(0x7f0000000140)=3D""/19, 0x13}], 0x1, =
0x7, 0x401)

632.92396ms ago: executing program 5 (id=3D13573):
socket$nl_netfilter(0x10, 0x3, 0xc)
setsockopt$inet_sctp6_SCTP_DEFAULT_PRINFO(0xffffffffffffffff, 0x84, 0x72,=
 0x0, 0x0)
write$RDMA_USER_CM_CMD_LISTEN(0xffffffffffffffff, 0x0, 0x0)
bind$alg(0xffffffffffffffff, 0x0, 0x0)
openat$pfkey(0xffffffffffffff9c, 0x0, 0x0, 0x0)
openat$pfkey(0xffffffffffffff9c, 0x0, 0x109000, 0x0)
ioctl$FIBMAP(0xffffffffffffffff, 0x1, 0x0)
perf_event_open(&(0x7f0000000140)=3D{0x0, 0x80, 0x4, 0x15, 0x4, 0x2, 0x0,=
 0x401, 0x20002, 0x5, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0=
x1, 0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0,=
 0x1, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x0, 0x0, 0xd70, =
0x4, @perf_bp=3D{0x0, 0x1}, 0x22388, 0x0, 0x65, 0x9, 0x9, 0x6, 0xfff, 0x0=
, 0x4000, 0x0, 0x6}, 0x0, 0xfffffffffffffffd, 0xffffffffffffffff, 0x9)
r0 =3D syz_open_dev$sg(&(0x7f0000000140), 0xfffffffffffffffb, 0x1)
ioctl$SCSI_IOCTL_SEND_COMMAND(r0, 0x1, &(0x7f0000000180)=3DANY=3D[])
syz_open_dev$sg(&(0x7f0000000140), 0x1, 0x81)
close(0x3)
r1 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0)
r2 =3D epoll_create1(0x80000)
close(r1)
openat$procfs(0xffffffffffffff9c, &(0x7f0000000040)=3D'/proc/mdstat\x00',=
 0x0, 0x0)
epoll_ctl$EPOLL_CTL_ADD(r2, 0x1, r1, &(0x7f0000000040))
r3 =3D openat$tun(0xffffffffffffff9c, &(0x7f0000000000), 0x8400, 0x0)
prctl$PR_SET_TAGGED_ADDR_CTRL(0x37, 0x1)
close_range(0xffffffffffffffff, 0xffffffffffffffff, 0x0)
r4 =3D socket$inet6_sctp(0xa, 0x1, 0x84)
bind$inet6(r4, &(0x7f0000000000)=3D{0xa, 0x4e23, 0x41, @empty, 0x401}, 0x=
1c)
socket$inet_sctp(0x2, 0x1, 0x84)
getsockopt$inet_sctp6_SCTP_STATUS(r4, 0x84, 0xe, &(0x7f0000000240)=3D{0x0=
, 0x9, 0x3, 0x3, 0x1ff, 0x3, 0x0, 0x9, {<r5=3D>0x0, @in=3D{{0x2, 0x4e21, =
@loopback}}, 0x400, 0x1000, 0x9, 0xe3, 0x3ff}}, &(0x7f0000000040)=3D0xb0)=

setsockopt$inet_sctp6_SCTP_RTOINFO(r4, 0x84, 0x0, &(0x7f00000000c0)=3D{r5=
, 0x6, 0x9, 0x3}, 0x10)
sendmmsg$inet6(r4, &(0x7f0000000b40)=3D[{{&(0x7f0000000180)=3D{0xa, 0x4e2=
3, 0x6, @loopback}, 0x1c, &(0x7f0000001000)=3D[{&(0x7f00000001c0)=3D"02",=
 0x1}, {0x0}, {0x0}], 0x3}}], 0x1, 0x20008814)
setsockopt$inet_sctp6_SCTP_PEER_ADDR_PARAMS(r4, 0x84, 0x9, &(0x7f00000004=
80)=3D{0x0, @in6=3D{{0xa, 0x5e22, 0x1800, @empty, 0x1ff}}, 0xe, 0x0, 0xff=
fffff9, 0xc, 0xfacd27d2a5220b05, 0xf, 0x79}, 0x9c)
prctl$PR_SET_TAGGED_ADDR_CTRL(0x37, 0x7fff8)
ioctl$TUNSETIFF(r3, 0x400454ca, &(0x7f0000000080)=3D{'virt_wifi0\x00', 0x=
1})
shmget(0x1, 0x4000, 0x800, &(0x7f0000ffb000/0x4000)=3Dnil)

466.30734ms ago: executing program 0 (id=3D13574):
personality(0x400000)
syz_io_uring_setup(0x69f6, &(0x7f0000000040)=3D{0x0, 0x400085ca, 0x2, 0x1=
, 0x1fd}, 0x0, 0x0)
r0 =3D openat$vnet(0xffffffffffffff9c, &(0x7f0000000000), 0x2, 0x0)
ioctl$VHOST_RESET_OWNER(r0, 0xaf02, 0x0)

421.95782ms ago: executing program 0 (id=3D13575):
syz_clone(0x0, &(0x7f0000000080)=3D"f84eeb27b33ed369cb71052a911137bf4ee36=
7ef8b11dc9d2a7ed0f59e41dbb4855263c49b4c7e54a6d93f249d43da4d0cd86055373872=
9974515d9ff45a37f1e9e88b205182fa71427b1803cbb7b05a716b87dfa1741ed1bf3dc81=
18090547b4fe56d8e7bd7598acda48f60bf963e4a836698647cfb2b3d", 0x78, &(0x7f0=
000000100), &(0x7f0000000140), &(0x7f0000000180)=3D"871b2128cb0e28286a7d2=
acb6abd0cabb4dc9353da7b1068e81b4ed06d74d81404bd069169893670982ac8b81ec8c8=
b2b9d767215106caa5074287c190f309e391a1b3782d9db271c129b1e646b22e083d9d671=
863bcb0c237cc332b08f41918530f792bcb3c9fd132fa1323120b36d832682dbd96b3e925=
ad5044a025e422d532d66da41efa65049e54e6575ae4d3598cbd97f2396aa98cf0e3cc52c=
7041f4c2f88f4d2de7f1558363a0b7af9e1336d853fe9eae111")
r0 =3D openat$ppp(0xffffffffffffff9c, &(0x7f0000000000), 0x200, 0x0)
mkdirat(0xffffffffffffff9c, &(0x7f0000002000)=3D'./file0\x00', 0x0)
r1 =3D openat$fuse(0xffffffffffffff9c, &(0x7f0000002080), 0x2, 0x0)
r2 =3D openat$sysfs(0xffffffffffffff9c, &(0x7f0000000000)=3D'/sys/power/p=
m_test', 0x28582, 0x10a)
write$binfmt_script(r2, &(0x7f0000000100)=3D{'#! ', './file0'}, 0xb)
mount$fuse(0x0, &(0x7f00000020c0)=3D'./file0\x00', &(0x7f0000002100), 0x0=
, &(0x7f0000000240)=3DANY=3D[@ANYBLOB=3D'fd=3D', @ANYRESHEX=3Dr1, @ANYBLO=
B=3D',rootmode=3D00000000000000000040000,user_id=3D', @ANYRESDEC=3D0x0, @=
ANYBLOB=3D',group_id=3D', @ANYRESDEC=3D0x0])
read$FUSE(r1, &(0x7f00000043c0)=3D{0x2020, 0x0, <r3=3D>0x0, <r4=3D>0x0, <=
r5=3D>0x0}, 0x2020)
write$FUSE_INIT(r1, &(0x7f00000000c0)=3D{0x50, 0x0, r3, {0x7, 0x2b, 0x0, =
0xfffffffff7020808, 0xffff, 0x0, 0x6, 0x10000005, 0x0, 0x0, 0x8, 0x9d4e}}=
, 0x50)
syz_fuse_handle_req(r1,
&(0x7f00000021c0)=3D"80cc949a20a10570b22f57c72b14b6d5b9656d619411d3e0feb9=
96f638296baec90caf0305c18523d32f8aaf50d3b62deaa3a75c2e016f25efcddb2e4e5cf=
e7a2e24d813ff5e08182e8fbc9353537f68ae28a6548a83e5662b382002990c8b32a687cf=
b9922aa8e8cef4d8f1c1e9ea22d432b3ccdc80e9b39e792b7545ae90a0880cb7f49edb763=
13335f65ed0888cdf8a79f3a22028f6035b8a77343e12b2b48d61cd8dadd99ffe4ccaf144=
36357b8f5c4633a94b27d21367946bea971d2f2cc9c588402be7d1f4cc9c78732b4650438=
da4a781b23ea5cc672d28ce0d78fb13a532779cfe3689e62f673ff4d4edd72d396bc29607=
5a710424cfe4fd1d38ce799c319e58f5b5d76c995ca60bb98f1a027c5122554fb397420fd=
5095c0326ccf221f017dbfdde47ba8180ebb28573193aa67076f503ce05d7950d220bc8dd=
ab527f0117a30a9c9fa977e6eb12024bf97ac55e5044b688f8ece30cfd06acf52743837cc=
9b1ae37af0113cda07abf471828dad657fd8a2cccf307f16e21f938b3c3c03a29bccb9f1f=
4854067c7eb7664f505a7fa433eac2c3e3ba6fc5393e376aa0662d502e91931c8363fa08b=
006e35feee61403c93a78cd0722bce85f680ee04efba31f47f92f1e391e3d63507aa49d8f=
063707900f63faeeba28c3d53cd4dc95af6e916bca9896926775f990b7e528b15014be706=
414ca96c59bea21a312484d3d6434c8150752bccee265c64742549b9bf94d64a100ea1f61=
2de41a7a4f34afc0f47a23a08630e3f90da155f6b5c90dd9a6496e23e80cbe5dfd3527288=
3076961caf332f97dc3871384379b2d6ecafa30ceea5fba0d68ba64fe7d235046347a4759=
f870e5bbf9ab1c3ad3281b63cbe1a9f0de5dc38118aebaaac3d8a42bf5e13489da5dbf0f5=
0a02291a1bff4af669d66679658bd3ac40f153034cadab5e07d743392a491f3daf2737703=
198cbd9f18c90d82dbb276f948bb84fca2bd92160675b5ce96f4e3609bfbfaadaa495231b=
581af70fbc8e2e2bcb249b3a8ff0b45269cbe2ba66b86942d24b086945dc9b4660ea211b1=
93c19bf11cdea937a3699ab6131ea26c4903121760b6df20561fa2a593700d7ff0e71aba5=
139ccfde4776e1e60233a784c72f4b7bcdaa00f60cb93c25367752c624652981121dbafce=
f1c96f3f514347a5adcf3c269df2091400b041d52460fa8c6b81e857f88154d4fce7662bc=
f27df14917a01170b0a36b36b49b0cb69af47247cfe08812597d74fe755ecd1c1ccdb3b0a=
3c9a2ea65c494bbd669b51ab7fdd2bc5e7e5ad459d6a9c9f02e59f7e0aa1f45de43cf5014=
23616d430a6dbc577492c8adfbdfe707daf0fb401239592bf301361770d155cfebbe9d5ba=
f0dccdb358c2c0d7678d6a1ba6e2fc16f1f0aa6b3b9be72b37c22fc76b0e4e5b9fa540f11=
6682f694e9ceaeac5cbc8691a935fd1a244b044ffeb258fb01a035880cb17e7dde5170a35=
d44816482f376d9d48b3b807af0f2138f8b48a47a18207745568b349db4661aee07fafdde=
33d604230e4d340c4f9d9ba0d0ab29294f7a31983fec1a75c6f4394d710bf961b5d4deda5=
09ed7602df284fcabcbfc996299783607934c8e0feb1dc2efb258586e71a0aa5458d50ce5=
560f716227a8d8c19f42f931b2ff0c448c8999863cd85cc5327c76644de795bee4cfa6ae5=
e1cbd8679a32b489ddc4af5c18483b7325937d4a4e77ffd4365d042636fbf8d2999812da9=
6aa1373f082b22c0f32b7d934a3e7dfb7ef7ab62a72671361faf92f291056499a7d588602=
29765ff64168f7faa220eecbd0d238e483094322ddc59f0477836be13328153b83183ef80=
083e8c74d423009ce3699addbc045b3062f81f2609a60ecee4db9ae80e992ccd481ac5c89=
53e6a8a333810e1fcf7073865f67140da698a46fe5419667025febf699b74156fc2fadb73=
7266b0baa6f87a34bb73115b5be02e15eb389de5d1c9a798997baa4410547f8a69af2803b=
d4b66db6cf0a865119a96e721b71ef9621ed7219f1d2497e55883480d663d59d9385ef368=
a6de2867c94fcecc73f6be4ddd6a3f3eb39b5c7c0cdc501dc69f156295e2f5345a9d8fec7=
fb1ae0ae1c5bda022eb7218faae98068c7686ce04f2c8ceec63ed8142380614d7b099bfa9=
455374ef90e3f9799c6b0592f39fc6228f7865a9bec42ab2d10775094a7964a81110de801=
204d434f132c848e76c6e7464fe4904b0e5c82a4b122fd21e69beaf1709c97ad40714b28d=
55db151dc99b8f5496814ca8f0349176ad7ae864ee42497764f39bf10714a2cdfd50fb337=
cfb6e4db18475ed71b28675c5954b078ce1f035022b5a45bec61ff614d235b4b9416ba38e=
d7f55922d14df5b26487a9d605ae4cec69c8396ec66aceec3b15bda52455c36e970dbfb7c=
cc846740226f0c33427dbf45e0275dfff5218940d36a3a06d93d414b0d2ca160b2b5d0de5=
f432d3f36a449f007068d2b79cb2fc019d1a15f6efeeab03afa45da9c1c360275985a839c=
d0137455885ea2a69aefd48915e14e7973ef44844963f42062712d4a8be4c3da27d8549fa=
3d65f673faa5bc6c8947bcda7863743e4f9f2e7dc62eec22fa2e9b669f87bf4c303e89125=
8b91daec9c9cc65c5983fd91a7709b5c7f1ff72faa639ce26ba95f553286fdec3759a37f5=
986c9a7a0ba711685af75c1b04bb743db4d0a39fd191147e2bfe375aa8d6223e7127bfbc4=
95d5bcd4dddfc29ac13a12a8044297a4caba53d63e899e3242ceebad1e6e7ab43f3a23e2f=
d007352866721411ce9ac5e95d46674b2be228196eed9a7329e4d282ecc837215310bd647=
42b5c9ed8fb89b5ee586b6391b57f6d52658eac832b6e01ea774bc5c35ff1c496a8743bdd=
15e950b9eac1437ace59b8c8aa91831e6716ea6fa44bee90f89206c688501a88de558cc1b=
283d4e2dd62a32fb108dc02ccc7d01b2cef61c09403d7256e0a8439828818966fb06899cd=
05dcbb52a9b8238e2f6e742329b170b1286d80ce38796311c94a77c0cd13e09610cd84e31=
2c0d8c9369c6454b98ddb40d6388ee4a16a408dbb589bc9164c9ff89ed34d92d09c2935a1=
e8d651fa364639598a7af49bed103eb975c43162e1f06b51f4c1316ab61f98c00b9944956=
2055f476e1c91dcfd2b6e5c9edfe4a942d2ae04962399ff0f700c4c5a5f4ab819d1a1b7bd=
64767a7c635ee70ded32870d4149359faa38e49e0a8c7a61ab377b3cb19767d3e50c4b844=
ac007d7ca13e61230924c3cea444da8919074705e79a29e0bb1326bdfc97dc5bafa5b74ec=
e5744b40a99c9f4d7a38bdbe5cf3065f9bd89ef04fdb58975284fc36575bd840840f96fe8=
39005743f840174182d9bc84abd5a2a5d3d3d26310ae37534c574c6fa0d442b1fae60fede=
d31010a206019f1df00f2a07b8e576432f4063464e808691cab001c5f68295182c5e34b8e=
12f96eb5844ca66177af647c16bf2c8cd6125068083489ee2672944ce6852e5c6f95edeb8=
6c97c86d4177bbe7a484464355f0ec7d0530c8d4d196122a3997a57a03a0484fa09eeda2c=
00a515edfb31feded6edd66b6513c5a9def92e7923c1f984469ba7054f96af55930c4c928=
c774c92606d8ab63d694cb94c2afde226be603fb7a0843c61965cab2af0e661c336789d1b=
6b5b4de8033da91497a3c97ba9d8d483d2406c76c0e1e00ba9a0901a93812d15ebb0f6a44=
7fbd3dbe15ff1827a459365f8c49c2f6f05826ade87b51175d78e786998e2818840605e7b=
7c4194a9c2f251912d8ae4cbd2674f95ef96bfe662ed7c412e2e2ec8caad8967f1f320d3b=
2669ad65f39b5405ad1bf0af9c65e0ccd1779f4743e211c032c2dda00ff4fa223731845ec=
80134710c732561ce317a2c204eba2bf298f2a885e2348a7cb07dcad2a7baba7a58461701=
63c6378c7ab742fe05ccc684df993db0f062eafd881554f8b44f6913acefaab6c5927b8ff=
7c0f5955c85cc9c70c04b6fb68aab8ae8b19780527aac4aa0c31df2d8369fad0990c884d3=
e0234b16642e0bee5cae0de6288fb1e92c7edf967037e13f07b3f69ff6a19b6a7ac431581=
0919db8499f38039e2399be08d9f7b101bc43a24a09aa49d82f7c235a359e7a65432d427a=
fb910ce19bcdd751292799e94aefe5df558d7f03a6010c1a9d5e2957d94c63ef221ca7c8f=
16c8e639ca1e332c7d5422b2b7b5589690366edbd0cf21ee41b215b84a1108e0e6899c25c=
a16e4f5f0d58f3d8938539bf970e2b9192f310e2d20b520871ded3702dbf5caa3b1ca0ab9=
dfc3563daeff6bc4b5949757a8c2e3ca9a67bf295b123a86294f1250b4f35a0b8b7382446=
f050d2b62dcacfec5c4bd201e00a50d3d2dd97eef43b3e3934392d9ce77262400f2f04ed7=
14ee7a18b79a7ff98fa60d934af0acc351c2fc3e9f416ee164fab7dc0f6067d10b6932520=
c2cad5d0d1ff5622bf8ee5f524fb292ac315eace7d02c80f885749a096b43dde45cd41164=
2282c163fdc2af62b9dfbb7e02005dc40d107c4747b7d749d1607a7cdc3ec29600bfd480c=
80fe4e302164ca3765ea070de833c5efdbc2cb396306f652e00593682a3392f9d2af52f33=
77003f2771ab919c6d5c86df6f5ef335084b9e25564e510b7e1ee1158e4b011043fefa037=
67cb6a4b647044f247f1d24f9d27a95b84347b5495e81b1d25f8cf3d00ce81cb58aa46185=
8768e052001ec35072d1f687386673819411288144a7c92d120dd58453751c8825dff0dd6=
99202dc73beccf1fc161ef12bdca01bc982bc93ff7927b0bc5c076db8077ad0088fba10f5=
d17b50740f14d238315fecabc89ca4004db8990685c51e7272844db7bc1c16be97622cc75=
69f7eb799708b9c44cd15500fc48a577a5ef21bcdeb4b01b1966b46fe5fc1e527a5eb7205=
4265499e36cbc77efbef2f3ed56abe3e9a7fb79027179855bc52e23a635fbc1f97999db95=
312408a2a6824f9d02641bc275f5f98891b1e5571fb985b4aad3c7542bde57186aea7e04c=
23b344aae36e5842264ff5d7f3d97b8fcab46ed86f33d61a180bb9e8422cfef7e9dbf6fe6=
aa1f411e8413a5dc3f1fb2acfca42ee728d684f6aee25e8da3567c1cc1775efabd4300b99=
63fdc1f85f213af53a74fc3a765ce2ccd33435b4a77e78abb45254cdf197a155af61d9645=
6e344c2187b86637ff38ea31f1ae06f0450dc07c4f75483d7465dc1c858c66268bd6dd79a=
ab93034c4bf074916aa0af59517131a3ee7ba071a8e8489f8abfe5ccea8fbd19fd87f13c0=
b79ae9dc4aed40b876d4026dfdf81fbd26c1471b3d089d8f42b59fd4e333895b62cfad106=
43bac3c9b3693ab266e458429332a208fc31f79d5f3bcc467c918a3f7ed6c11978459a205=
5cfbfa66bc6f4842d1a06b6d1002b831f0fbab4037e6437682609510b24964fda2f3a93f1=
14cd309347cba2e957a85afe51205d9a379a3e1f071774b25e02196cd56066b04af86dd8a=
e5d232e34795abe101d22f40d8de9be579b7441bff26297b6acdf2a443ec68162e9f72e07=
2e3c36bbf3699bb24ea36a00e2a331e64d7398ce667a010ecc60458ec1e36b5240fad8146=
e3879e89400c7a1689185d96f3e42c14cb634b8e33c295a069447136d25426e48c2dfa77d=
11c3b2ca5b1ebe5ff49b4b1a216b40f9b6dc823e58d4a4a686d8e24f3ab217b35abe18dc0=
e57d1d6908e32dfc26da5aa1a04e3b7ee1d015226f57bc0da311e7dc8cd2f766f1e4c40bc=
27b7b62b38985f768a7f885884be43f9e13af66592decc37ea77b83d82997f27734f4d8f1=
ec2bcfeb61fb73169a37953a1bc699ef2ae3365c931001fb42ae1d2c2234bf184dbf4c19e=
7fa0a18fd0b374140430aa14edc03b2abd1fe3d2d515c67e7155c8066366cf0f0e4c72671=
a3b812d4b25844e5e1b59de8d1bd13a5a06262511b2f1d43da6608bab3a406723e1774262=
1155ed8f771bca33b4aabea0ba02c7ef8a5ee44e19a09a2a9f298ae4faaa347d3549f1aa1=
5c608fd8f3c48ee91e5d1f7c09c90d13f1e677313a4c074a1a3b6b3c7a184ea34875afc9c=
1ec7d8f4828e9dd9a4bd8a5d101c8770a371c08f446828de72c6b9f09b8e964e579d7652c=
35799693c7aa3c666116dba3555ea37cf7a40b43e1c75a4d8242843362d8f46b13a071ad5=
e68db0394c5b2a89c75a8eab80709d80c8b479e9f98726faeb2c6c2dbddc6fd0824bf0c79=
76b39fd50acc7400d8f69c7830e1a72985f9818e62af00943d4aa9c710971ed553174f1e4=
fd5934d5382659466a9acff619605796fe6a15b167df17991c8eaea0aa300528e2b504784=
66f4d296f7cc667a21fec9e693c4d4ca2c9c2a0e6fc4fc92757e2de37fb7813e5127e6c71=
38d8f7359ee0e97d479161e05c608e2f709729f1f4bd43772ac8a1c4615c4ede74a91e4a1=
6458b0de739721d2ec8b0514a79161ce0087008d3cd97fdd5538c518b24b28419f67ce0fe=
d106b4df122ba9f51af5952a956a0b9c95319f5c49e3f7b48a19dcc9d9f3b5ded21a95622=
07f162b805b628018dad3161f938942cded99e86f51296a815a9eeb1cdd60330a2573ce7d=
cdb07643fc3d5362a87db6a1ef0014bdf70edb584a9168eef7c4baa260e284a5f221b71dd=
72a23d2443a393c7a3d415b640e6ef68b6325cc8323c7441b036950efad4ac9fb10510cd1=
1b06d1c5cc8258dfa0c9e52f09b47828c337f3291d311a450844afbd52de50527d4cdeb06=
121270ce90a29b8f3fe79ea68ad18e2d34148e643a706fb24ff74dd8664abbea9894f2544=
c22f174a9e50d954b6359af53fff54598a7e686c84299c84721b57276c15adcac69ea92b0=
a9abc225bb9a1a6f2254f51aea3da768b324f3bfed0bd4170fd1784d17384fcf16e8cf23b=
ec1a23151cfe2c81894d95599586e136e70ab39d867df88147f0cf56a5bc6d2dff584baa0=
4f7c1ccdb41eae35345bcd2f9c4160e5d141c0714ba4e00abfc11ba3044b566252ab24331=
428160e22fac02d71704bba9cd3658e4ad1edb5dda5e0f20ca2b768db78f9835501a0fa53=
c21a390f894ed62d815a736f6683e0fe841eb881db6941ac4199e1a91f74ac207928bba02=
4490ca79dd212adaad5b2125fc1abde7214e775880daee271128d3b110c1f4837ca237624=
69b3e046539b0dcbc9efdc74d5729f9554aeb11cd4f169649a1e0a516bba7a2744529e7a5=
bad1cc654713015476353c04ada5d5a4a41e80cea1c72bd97ee95aee3298202208ec13ab9=
c8c002ed999ef0c4114ebafc49333ed4e8acb8ecc346615720c9635ceccb2b4aae738552c=
b3a25d00f14fc49ceda292c0ba51e3705c8910b849bc40bce90825cffea3b93003f23eb27=
22057e3324a585a9d28f8407f01f38b37e621537a7791cc81ed4385160c4e4e33b8c43e6e=
e71c2cfdb9b29bc7b62110f3d43b36ed066f2cc903c712bb134e58a37349cae68d9ee2da8=
831738c299f71e8abf9e64186c234eb9c87e983eb31fbf854fd809f5b5e3994fb287db385=
c67666524cddacf77955ddf8eccc91e4ad0f974f56720bcbe28e64ca4aa537cac33a7af5c=
64577d9ce3ccafed63000afe624037cc6f50c4f1843f774227b831e462e6699d31d8e862d=
e7839a6c21642d02f42ebc1f97e57277565a35897dfedeb13b595f89ff9ee7e923e87f0a8=
e218df193da791b5e6b5125cf010ea46ad97e69fba91d5a5f5910fe4c62614308bfae38b4=
93bf47730b2407f58c4013b74787c3b2366e11c56f24864575c03e153fac827dd8cc40b7d=
a5cae79d7348bc9020e8d953f030e69fbdc151b844864b7928983fc52ddb78f7ca9d969f0=
df112426d71b6213f274f4c6f847cf2690ef569e3e6cd1b4690cdb15ee899a4cef5831b7b=
94316a817305b5afe6b7e04bf72b634421dfcc78062f21ace9a094e71e54fa5a68ce305ff=
8d655a4cb76bab1a5f65695068ddcc713f894d0964893f0e8ea0aaded011feb0d7e81b096=
9d62b19c399d303f9355577c1a7ce9f48226aff3da483abc841f994f6d073a111751ea78d=
b37654289d4d26aea096e789cac8fe3bb23195d31a7b8033ec2ad09839d15585daa7de2b0=
ed14dc178df27b1c6783bdf2d63aee1d0d4b5c73386b6c193f6bb19ada653c9d89de533a5=
f95d731111048d727b541f8e130e9b0c698e0695b12d603e6c600f7fe5039ffc0c8e9dd06=
d67b8c040a341ccb89399a097a178d70caa10141665898d836ad6a63f1f53e5f71fd16f58=
92c9a4b8d6bd8653a7ba0a888f746e3e050777cf6d569e43772b6938b65a3a6d555310d00=
3b74ff88afb640c1584a163f3ff30564fc974f2f92f92f4dc8eeb8e09c25089c55781100f=
3d5025c6f8118bdcdac966fc3077447a43fdd25496771f9a7a5f88a1556e9e48f4251a56c=
cce8830bb60905006029c562f7540684cc47e398fa292146b2579652454c89e2f3b6118ba=
d6964176403b431490adf3d108f9ee0c91a7a56b4fff0c0e3461e45d445a65a3108df44ca=
da6fe0c1bc98039188b588f223726e5d18de2805c901c92aeff6ce7f9072e6c065d8f5e08=
a356983abdd55cb89d4062f90c0bdaff31b070786f7957d48c0006a4c59e9705172061579=
cda17c0fc953045cac664c8a63534101cda0fa271f88d97e30121923e1359777ccc9b477a=
ddd6517b5993afb19c6eedc4f052a6ee879233f9d1f3ec431e3aaa787e561223ca44906d3=
ac85523e3332c29fbda77ba95a16d6f99aa893f7df8b0cacff383e196578b76b0f847bd44=
0acbba3d9642dfea94703c39514397ffa671751513c15f1eb5614e54c1db8f9fcdb515e61=
75b13d19eb82edeee6362563ed91a3229b8876e299149a51a40a9718da40cf3236209694d=
3aef482e79349e88e1ef23a79ca484c4c04eb7732ac35733af6cb4f5dc49e5c67bb916ad4=
85bcccec344d387627a3b1b97d7f6c82f5e29313f19e8e42e065eb94120bdd1523a11ddd3=
26514a2c8a54338c5b86328dc031cd07ab66b2b4a52f3a29a33dd776cc33a7b0643b6922b=
00c05f726ea96d2bf9f52c5d88c4c814a1ad9e3df182900176a5daf9006bc0b3987282ad4=
72a9ff9653335110020bd97df97084afc01fbf75f5538bbef39f934d781cf5152aa43219b=
4ec36b5d247c2f037359b02a21931fe187f77210d4d6745963a8cfa379e5e581ba0096574=
466a112892a85a7de6b5b71e8b5cbed837a1216b52aec86c2f132a5b68cab5f4fb8fb4b8e=
66d0b8da3ec9440e8ad3e8652ac045ed7ec82e46e49d0006c1112ab8338ecab8660167e2d=
b4930f1bb2e9fb5687f0b40b40e0dd6b75e78a082fdbfea91da3f07b57dbec8776232f312=
b2d267a8bd372aeb94e2ff2323798553839c961d820d701da8a67a1fc0efa49595f3a88ea=
db8a01c80c239968925fe2a71c4c3571511d13638685f33a2957da0f9b3444e9c1ad13e6e=
eb9175bb188e2cd28e7db490b3f2cedc96c77c01ff7abcf2b27c2086eae3f3b4a1489c5f5=
aa067065ce96108bda1000f636bce346722c6902511ac1a0c688b0f49552cbce6c0543677=
3b43cefd7ca335ded24e17d92c61987bb87693555b8ffe222d30a99ea4ab557994ff136c2=
d9c24872f66e91220b339aa978dc250c435d1d04d460319e0ba2ead5c8329698ce1426d42=
705497671e127266ce256a20cd5b4d859bc5361c5319801576a598f6d391fcf41cecb2663=
226105b6308ccd81c5fcf52c30e7b1d43d1e518884f521ac9d017da826d1c079445be1660=
65ce5974f92fe92645342aab60d5417d1d0a206bbdfb96cf4346023267aa3aeafac6cb5ea=
594fb452635a97f4f87f634b477bee33a3bf0c526c8e5c091e7213659d3fcb8773fbfa38f=
2edff5636dedc6838a9d7e279228a56f89d5a6baccff0461d91d136ea8d097c83993804f5=
4fd264db79aa67c81e966a352b1b9549247fedc317019fa506edba35b0e3d61c93950562a=
6d968c001e24900ec7609a8f72c9d6953b7eeeceda50f237e59c106e16b68145aa746ff37=
35d279b1162cb0383c0ec9d124c94cc4337f21e980d6566d907d0be94b67539b8d10dbdfb=
d840acfa278d5ab3e35a64ee36b2934f019175d946be8723b8c529fe2c171d05e12c471fd=
8de3cd0d2f816fc679273ed18bf0df1953b1e346aecebfb226746ff493b263dc0886dbe2e=
7994a2e547f3c8fff2424c1529f28c390d7e0c6d8829585c41a730b37bdf5343d6396f244=
ebc1c695d37f4b343d9e1a56ef15f808323c465e91bfc8b7f23a71e306128b1cb5da4477b=
7e140426430f458bcdec732d45da8d33939389412ee609821e07a47f218f8447d246d8b2d=
f005ca0b1dc70db2e1800ffede9c04b3a1e1247c4ac6d7f4065ddcd73e08b8777953ae24a=
9d0ec824fe75c1220a20b2e9c0b9bdc5102043f7ef47da065742ce5930582b670a6b012e7=
030792ded6c5d3c4e92e8a27a626fb2594151e5ac1d93bae6e86a89cbd748e35678bc28f3=
aba772cd05990260014607c7348e78da39425b1e13403a9750fef9820f9b15cc16ff6beb9=
fb86277c06873aa18c9509cd3597f31502b6da18fa7ae25ff104db554e2021edc0860311a=
d8956d3a415a3f70058699235ba0cbcc304640622763985a81ad5eeac54827a4b4adcf254=
b3a8909959f9f5509d7207c07cd801bf1b6691edaf191b4ea870302b8d6b51a1539c857f0=
f012204572e32e6d64e2217b7918a0acbf87779c60555bafab138b6edda46d4ad8a835a47=
06a0bf754e7109abc885254949b03e3b2d265385ba54dcabe4857e85d804d3ba72bb38305=
a143ea21f523844e732ab89a42bdc61f6be1f9b28e3386cad2ca92f6c70a613722f3c0c4a=
f72b2cf39d5b734dace0f2e7f66d6c2ef74e141e73cf90c6f979c576a82380249b6c654a7=
b2ef8372896f96f6f766642dacd5841250c97143857e545beab5c3882a3e1d529bb519945=
412e6bfc774e99463dc15bad3f6069c5827ee76897151330dacd669814a58185e301d6f0f=
701908d378b6183bc6b06a8efba3e70a4b790b017743ce08e9bccc686fd0cd725e3ddb931=
1573aaf22f6e49b2c013306c145ed34275433e869a4a721da89de4f59602c5c7a9e54e678=
fbe0e88f64110c975b692390e1f6e896dd322559ab9c629eaec0be9553ea26c1c0360fab0=
2d8e8e16e378976ce57126b434baae51289e916210aa802849b23ec851b1ddbde105bdfe3=
72c96da4ed1a9f4f64464ad704e077b14036fa47fa1c20444392e30da43088e0f3926ea1f=
ba4f2193ca38f7baf44889f45081006acc319e9fe73b7efd7702543c08ae91426fb0333e3=
a347c795adc061d11bd524f5bd1570e0ed47796f6bf068953be6a91b43e66607e25fef130=
5025b9a7558caf9a9cbd1b91757c21cfa254c3ff83f5445c0ae3e70c2f295ccb05ae85c54=
70b893f9768b3c641695dfedc01382bd952023331f6401cd20993b7460f0b5f2cac0779f9=
92570d7682afbf5b2f1caae09c9791a3e9090a5864e895c372064fec3203700cfc75939f2=
e9b79e2907cd9ba03708c4bdd4d2fed6602cfe12b9b6388988fe9c955e71b90fc73405522=
ed1b7579a0c278431e0bac8ef597f398440bda215da819af94b6bab31f79f9cf00394cb95=
5beddef2b97bfe985b6efed138dbfffeff375c2ddcbfa930bf896",
0x2000, &(0x7f0000000000)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, &(0x7f00000003c0)=3D{0x90, 0x0, 0x5, {0x0, 0x2, 0x0, 0x6, 0x5,=
 0x7fffffff, {0x6, 0x5, 0x8, 0x4, 0x1, 0xcf, 0x6, 0xde23, 0x5, 0x6000, 0x=
8, r4, r5, 0x4, 0x2}}}, 0x0, 0x0, 0x0, 0x0, 0x0})
syz_fuse_handle_req(r1,
&(0x7f0000006400)=3D"d1847629b8b32311f0b3613f2ef7623b7e6c2f0db70d70defd2c=
87cb9eb54d5867b40ffdeb44e9ae36c7346eea76ad680d71ce9523a91485d2b97ca190944=
a023518ab9fd3055ef3a96893578d514a6e1843fd009cc02db44338089416f62c86dcee3a=
ba6aad1a8f33bcb5de95b3e39a6d3c1cf23b34c59650f9131ee357550deca14000d942917=
61d77a4be69d5fea5ecddb7d3bc24cc612200436dae9ab65002f6546a6ca09709fb58b2ac=
40bf14a7c66debc3872b9b50451192d62773640e1fc32c8d34da2b8de1903871d4a89d1c8=
33d058af658b1ed6d8396b1ae5b701eef35eaa1e26b5478a9aadcc7f8ff674a1b34b85c9a=
fe9f79e9a474541e1eda27b903af7b1605b8f0cb56ff8def50491d1a63bd3572d3d1f727f=
6a2777c52a47b2ea0785dd3b599e8b33be024ff7e530ff955152d12c8f2429713ebbfa415=
958d657078941782dff438d3c46ec7336527208e7d76e1cdace8b84e1704972c61ba6e73e=
e42abc5e126c25da7fdc366ccd34e4e25f54510f50d7411d104e20b999a238f62b5f58bd1=
6c6095c3ebff448f704b3f751b7bd8cb21d97900ef1693ddd2479df932ac5c27595c4fbe6=
3bf3dabf627ee763ac4b09425f7a1ce69aaa4e86d4fefbc9f011eb46464418c2f313ecf38=
d260038228f015675fcd1bbe1fd70e29a0a8cc39d9265536b47b148fd3afeff11e7a99e4d=
7a375c9589adef1a2d467d8c5958a435fe35228619d0ecf823014f397cb90bbba46748c8a=
ef37c4d78631749be4625417eb529cde5eb0067207b0831cbfdef67263f5e631392fae413=
ced5c9bbd6f0d69d2e08d69d00602038f2f8acf761e3595200586d54946a0b27e2837ac97=
b8352905df9d9b198d45fbf967e0279d81a6501ba3df534a2846b210be34875d4c10392eb=
f2cd4a880bb7b8f73a70bf225855f0911a426dd3753804947c489f7df4820dacb758a6cd0=
8d416102f515459e96f2d9106b9264e4d559ecc488e562a8e1e7df3fc7e2ad7f631c8e3e5=
5aa6be2f7d3c7b5055e775f6f86864bbcd91260dcc5b96733df038b84941e7dfb06577c88=
5da6887736f8e8c22989fff2e773e406856eac71220a471fb0b67b2e45b158126efb34973=
9f3733642e63f34b6c458c495e5d3551dc3600c6d75a3b4b1a06f59adc8d8bf1f74105f61=
e226a0b80660c061c7dc9e910e0027aea8870890541a090c094cca31dd252520ddb7e98d7=
ef2353a4d11d0dcd5d635f0fb9c429a69cc2a08fbfc07943d910a97a07495809ffa545ce9=
03571b336f27c5061fb88a9d8b5ed82c71573fbf6825d1101cd91883863c073efd4977eb4=
cfe87e6716753076dc016cdc383c3a17068baa21c71690488495bd400d3c93961a73b26bf=
12d60a57edf2dcedb3d9b3b2616fb62862e50c21d783a533159b21635fb316f797fc4e2dd=
cb591db40addff2a21872f1c499008929e58500e4c6f55ba800d58026e05eada9b61994a4=
12f174f2c39923cb1d02505a31235f98d8c523a574121e1194ba4781b5ab4d3223388180e=
37c9e435d7dda498002ff8d3b3404e40e51d4451a52eb3763d79134396fffa3fb15804d9d=
1b9779ed5e31ad6740ada75535d14fb41e39ac7caeda9bc01399aebc226f3727fdbee4165=
b98da6645430312482390545e966db851d035904ae2b064b262bb76f9abf531b9b9da2846=
c26bb4019aec5037b81c5d0dc4d393bd8bfe7daf1d1dfe0b3c96c6f56a5e9d50e66c61218=
2430feaabd865ffb4541ef28014b7fa5b4770231a911cb109c25c596e2df0e25d33550b92=
80e1944a5af2d374e4a8fada818edb964eb7800665ad7e6d33031b67070a37967b03f5f19=
249abcab594c45e6588893f9489f5e176529255918002efcd37fff92421e629bd103835aa=
2bc0cff824f4970c3b1dde2c36afbd169f6177a59ada0637f0087a358524f62d6e0d43bcb=
8ff5870a61048b33f808eb0597744c6fef62d057421f66ba1db77f08e946987140de3cf92=
4f04f75e211f06245fd621d897566cadef1ab84f76a4a5e638e8db97b51ff83494f061439=
1719058ebbbf30f9002b7ff7e83ebb84d6be3496cea286a426df3696fdea1a86af37cfa19=
f2b887cb364591c2fcfe9c2e5a7e0cd6b703e30a3f08c16956cf878d19461ad7b3e5e4fb8=
2f2bd8d094982c47f403e0dbb76b7dc489abfdedec1453fd1fbca1a622e88fb9cac1b7a04=
c9071ee627d6208dd10c9280f24f04c9baccab5206dc54d6346fe077317176a9ba2904f3c=
447a965d4da58d77cca55fbc5de7497e8c02257cc4652d04c9e165d8c0c2851d588902510=
a52403ebbdf0ed412ae1ccf603ee34241a66a80e8a3ab45ba5b47252497d4261c84f505e2=
9d4b9cf31c580eb03aca6fd425b8f987adf82272fe0a10383c2a3349fb2e0d76fac7c56ec=
535bb2f6bb7e022d83ed82cfc5c929d042346da6d939590ea70aef16302ceb2c65f5c1181=
abb9f47a4eee9a2430a9eb44119af9e695119b546b04ca02a9d6243df326cc62f660c617a=
77f759929ee6196a3d7ef87d9329de8ff1b3ab7768319044303341d9fa0bad70f8a5a783b=
1717fd03d4fabe7386139c49262a285d8a11aee8a484959649cbcb76be6f10458e7ac4dbf=
0a01379b4658897193e37b3806149831e4a7a5ddbae06cd9b81115afee98535840e39ba4e=
5a7dda088cda47c0b0a795c55f1f09830473c9f07e1ae8236ecf59761ba6153bdae59fb32=
046bb006edfa45f354384b7a61c27472455291ca07666fababd2a5caf2d968cab5590cb8d=
6edf74164fa683d0fa5ead0dfe9e1027ae280c9c03a77370186f49492187909aa5ff28ee5=
eaa0374f3cac7f100c9ccdc6a355835682a2cfac2a738039a63b69bfd4483d0f758a29b00=
cb25d3bbbe2edd9e88518a5af0bfec28172ac8c4af3e1788bfb966ab370a3b9e147f0312f=
63207ffc2779a02b01644e1a636114862459dc734c37689d9fbf2d6f0a24259f8474d0756=
c971e005c47a6fbbf2c5047d3e074c693dae1b41c8042da7c2f21ecc4bacb93d96ff2621c=
949628079897efd6f42d6a4f225b46c92ce1448abb02d16e8329f0a133757ec1a4c3c82ee=
f0baa694fe13efb73b59196c39d258b6ca8ae25da0ae0bf8d9cb90d25d2393f3fc7401770=
3e9f4f30ce039fec1cc32606e013e518e128c27fd28a0b0d621290a8c1cc2a0ce446d984b=
7f45f919daa957ece47731fbd1db23b0b284c6886a09bd553cadbce93478f5830fc80e42b=
3cc2ee60bbce6b4a61d8cb00b2a92adc91e32109b812ce40349a7bd323b23981b00442725=
674c424acf8a270a30d7f4ac3d05e215d1a8f8574bd40935bca48093c0405a51f25d99bf5=
22eaa1bab75505ddbcab4ec301c85402e233c6850dbec21ef319beee2eed4ab2448b5774d=
efb10338e28a6891d54fffbc71a48ec6ec9058eceaf1c486056c56bb9fa0a93a803f174a7=
2d41db738971b438ea8cd91b7d5b2eaf20f36491169ca149fcab51d7ee4c0fb96ee7e1b53=
a733cc566327974ed92abf15054772fafc397e033cb72e847cabc4bf3ab5d1eef923e7eb4=
6f6abb5249011a7257440317017ba894e50bb20dea98dc9ae97f4d601a0210067356a2ae2=
bfa12e028e594e33402f23b2bd5c772bd930678476c74a55841a23cc668f0b8cfc762c30b=
eaba8cb1c1fd5bb64b5ab4bf7544975aec5f1e23173ade8c10da5dbcf742e16abd2be132d=
af713c2362b77737dbd3dace189e5aee33231602ce46861b83af76630b0dbb0da1b87e2d1=
83cf3f34ca8064b2d0a6784548ae3fc71797dc5724bf570aa99c50277467454a51bde468f=
0e33541a23cca11a32298aa52d573fb98cdccc55043fedd4b57ebe921c1791b5bff68c744=
06dc2f7c2ab1c7d11ac8c83fda5aac9c80cd4cacb8c94f0e0a169944883f2b6c5d1a12ba3=
b79959fca8b54784ec419e048e03371f333300e7e1b78f1261cc093e556fdef5d257bce50=
32760585490f5a5841d98fadc0817c74e86b3ada213f55d3828433c13ecac1e335e399e78=
b2c8555ce1bc175c7d17652cb606f249036f79fd38a45b55015dcf85e55f412decd0b1c3b=
d5524506d97860fd58cd96ab468bbf28c2332810421a56b3356b1df87b4cd44686af33e40=
956c0fa45da43b078fff00f4b56efab940b057f43763cd6d876f55371e7b8514c47625bad=
b6451d72992f100e6708c210935bfae86e96035b1a3d32ecfc45dc4fff58b330a6e790ce8=
ea546e01112dcf9a7e3df6c351aee97b48fb821bbd39f8fc3e14e56f1e66478009b7b9466=
f5a538191399e44860d1a08231c9d30dc4ce2199903e3282b92938a252fd191efecd4eae6=
aaccb99e58aaed62f879ffa9aaefd6a1b5febe4ed67fe49cd940740c226356e0e20dabb8e=
5251ef186a63b7ff3427118ba081d74444aa1c17944ccf30df8224bf54e6d2c668944df91=
a7b1e2bc10223c7903befdd912c2d251e4bdcc69ca888a45b1039f57b4029c0c21bfd5ffd=
d7b5d8e9b9aeb38a6c20a415e9c3759bd4c226875c09e52e6b05b0b20da60c3a0648ca7ac=
4dad02935f69a0c8e4f74c92caa03599e8f20024953cc0908222a3fee8706d9b7251b778c=
40c820641e5c71c1b76110ed270d1841a93e7f6168f3e45fc9e718aaec99ccbe3e2dd501d=
0fa9bb727a039721648f00d1551c3f0fbac3ff6f5fd7c8ac77ea173dd4c436cf5a56e21f7=
0d8bd7ff4e7f7a7ba13049700ae7ef10278607ca01acceb4b35f03caab627f1732e49ec63=
f99047e171a40bf0a11344084a86462fbb9beae092b259e3194d3f19de019cf9b5d25f3fd=
4b05400361ee003f38450cef86fc79a3f609d944a78f52553d95c139edeb846fffaef89d4=
7181d700f95eb5a35d014ac44f5dd3b29bfbbebbc82a13ae00fc2efc0d65f8b4611268e86=
f781991c260ad83bf7c3f62216ffa71f6ed6b99e345131705fd4564e418da75b26343b678=
e087c8e3d30326d59443a3c44d51e96c461874fd0980366c882b1a7eb31d8851732b88ad5=
501488ef65482b8ee7c37142b3919fbcba2247e219834eefb734ba893c255f2af9bebcd35=
2efe6ea20cad9bcb00f393fb1d2f46e7aaa3d32be901c0d1fc181415c4c048fd3ef94bb21=
b898615e6cd41ad7693b25616589d5852ab79a9ffaac813564422a48d969f1c4349c3bef7=
7dd38ea6d522e6430d062d2f9d40077f1166a030e511059ac0ad12a969d5d2c0143f1a387=
4111abb2412282293737b918763f711fd3b6273d4acb243dac25e97f0ffbf411623b4a5c6=
c93c7e5e5fc26563b90073e0d6ad17a7459bde92e6a1f24545a2384f945de8fe30f4c68e5=
cc59707d4c2570fed7e6e9b8941bb07b904eca978b9c2e0a23312ef4eaf85f8bb76977711=
24533d729ee090eb0d160438bc8e4c631e28b1bd0badf0d065f10f868dcbf1fef31834ef1=
e57221dd0fba7d0e56462e815538ac44da2ba70c0698571a85d174589c2394accf8b98653=
fd6d1c54c9e23ea3440accd77eb9a8155ed76d68f336ea515722062c69ad79f1d7538ccec=
63eba72d755b3828c463306f66a7798832e4d3dd598f4a3bf007cfb151734fa1a73a8774e=
bfd6137e0b4d5d3d76552118b040d9c060758438f5108611c2db64fd35935498254133bcf=
a2adc6ddfb5b2f15a4ae2c89e554d82b753c2f250ad8f9725c7b93692d0eaa0ac0804844e=
5a70e162e2d9eca134b9b1c25a5483a54693b591f76ea6d891b47f57ea3ef51808f3d93bf=
74c6c6edc60eedb19524d86e4ea6294ed09d8c45feb874008f4aed864d6404dc892704a21=
a78da4ee3bffd444a9a4c1ef34580c5db99419856187648868ae4845fb4c391f17f16707d=
2b9c5cb8a1d4a10c5b03eb165e7676c93dc5ee047ed77474ffbc301115a27a8144c7302a6=
82eef28c75c5539e514898ed3d8ff75f24b8ee466ea49ad280eaf84fb49225888c17296a6=
d2c709f57822c660ce5f921123e897d4797ad151cb9bd58d6c38c3bfe6a5db76d72b68bec=
d64d63319b6cdb1fb548f9a8cad9ceca4c167e26219ebd20c4d8e1c7fb74984a98e483503=
2581ca10dc6089e57987bbb4dbeb17e6a211a85107d2b5dfdbbffedd3ea8ce80720e82b19=
89096bd23b05992c0a3e09b766a0e4c8fb486290238237b80787b09d495a5e1b9550fabf6=
17792ccdbe797857a572b85eff0d214a80aa5be99b4ca4ca9ebb189944644357abc451d5b=
407940797512270208dbfe6c320740168dcb654c53012e7e740322dd91f6c2647298050b7=
e8440857ff1a8deaf123a8da923d2f0cea871d21ab154e3aac07f1994851e755bc21cde31=
d132f23d9d01bb51d5364a72afd190eb93a7e96948ddd619d3294ac31340e1cd78046f1bd=
ec4cf1c30442c7f62d8bba4e973af102956c824b6be5a2309ca38205f5c5d66150d431cd8=
9dca11db7df2be7abcaf3398c78409aa852c7290497514b8746b1676f89afc27d38b39dad=
5ea4d8bc371f4e4fe59fc4fb37c1e2dce7e213ead05f80fb408780dcf6a57fb3fbbc3d6b7=
edb6398b7b09d85e2ce07015d4dbf3cbaa02139ad16025f1f65bba1e5fcc9216de59ccf01=
32d6a00e05f7da8e84b2ed5f9fa143f4c4068824442b119737e77b85f5b1d10926404b05f=
aef7ee385738531e54d20fc7134afcdb4bbc5ce305ba13506c4400668d8d787ca59097b63=
a270f1e77c455e0a1091d87139408082a7af05ae3a494d4652790c057ccc097512a450dc0=
d0b571b278c361283a6a90dd908925c94386d91b8f32eabf6e6555217a3d11f068c24405b=
4ae1d8eebe81096d4ea3eee410d5d07aefe26563904d86feaeb5bf6c5c53d90ef93b64eb1=
19c6bcac559987c0345171bfb40f7994289d57c0425f6ecb32519b97ac8e8bc366b816fc1=
87bd03416222ea9ac7c9b2cd41173cf4b50384f2e0ecb3c307acdee361e73238c37555fd2=
5c5fca471c8b7c2739bdba5e06bc3db77cfb348af90b6906b2542d69eb83162e6d5607cf2=
3391bac51d60e9b3a8703249853015e0aadca8d4f2306a9daa121bdf76e98c55406d19c5d=
b51a621df62aedc530da27643e2f34ddfa7f91bb53851f9659e17292994a9610e418d7225=
223bb229fda63e3c1863b349a73f7d70493452809b77431f578bfda82867f2837f3d1200c=
ee80019331408006765de7d27f8256d9242a09df9bca29e1c9c727cbe00c6f223df970d62=
7c9e06c07c454a4c4abef00ba2a66c99f92e73eb10b71684c9f4081b5dc3372524fdd76db=
6f6288b593571849e1df8855fb971773497e90ed8722facc63be58092f929c306e8ef8ffd=
327a95068a30b17535ac6f79ea2ae5dface84235580e7615674c5713c42fbaa87b3ccaeb0=
a916d9d737e1013351eb471e967b2562272e68c760288dec5174127e2e70a12e3e8ab3af6=
932fea0abee4bf32e2d609f210e153168ffdbe8bbeaf63e1b2f31ba76e1e717800cd0698b=
cf92d1600edc35c543a2be0498ac78223f62c61f27502a02dbafce827cfd924cb9146a587=
30692cfee526bc59495d6db7c485a5ebd756b25a22ae77aa70594c5ac3850235ff6ab4d9d=
d7a3e494d214bacc60b46186c2fe413d96cf1b1ab10595255a465e57c42b52a124206087c=
7e6c4c4ef25aadfb4a09ba1e7a77147a3ed6fcb4b09990bc65770cb7076927c01b227cfae=
4a8ed1f8e2b9f75ce18f7d878c5544be2d64074d06a75424de0ff72c812662e2af6c7e383=
2df151ffebe3507d09b1e2e0c134b693d3c7c8d81fe24097d138601693d4027920d43f28a=
4b2f73ee1490a221495aa12bfc2cc0d2129ccf36060bc09852e8747d1a9d354eef234dd29=
4f99263295fba3ac5eff8a96bad66bbfca1fdf02767ce0f6ee0eff4841323e70f25640b19=
10856ac7dd68eee19916c8336e670bd8e1385a99918aa010dff6b3cd065a0d8b38d4e9a94=
4e708e1fa38c0e85acbdeaa14d289348833f8980d7c0476ee7783544bfab6cfd778db599f=
02880a386a724005dbf620db610ea2e6f6e02eb8961f22995fc633cce267adf7a59bcfdf4=
da1d2cd35c0371c859a586c33297e17cc0d6ccccb79b8e1b14d5d8741dc2129e09d3e2e31=
b3d046f70c1cc0f2adf963022331225a7bb52164fd6589a46a5950a185246d3d48c592781=
4a9717d780df10d2463f9a3e5fa067385167b9df2d71463c9daa9b3443713701b990a2b61=
e453f68f1c864df5647be3aa14605f90ce4f81462fd80063419fc7209a6ce0b89733c0947=
b4cc9f52dc7b8502d120f855b11a3827bca4ec3e58b7cd211e049c2b67f61852939705968=
bed2e39fecb8b2aeb334753cccf35bcb806c6705b263c4907b3c2bdd864aa7dce74648813=
4759e43d9a496bab4660d826f95fb4857215f312ea2b2e556a89be47337269348cdd25c67=
12f4cca7f485686ea46d0eb38c7b37f82f7101d968736e0ec06a3f3a80edf5eedc3d942fb=
b1cb75fa0dc580e9cd6f17b603ef4f2498454f4676793d4b7c762e898bcf2f5c2e61d9cc8=
d64519770435a46a4a90eac4ae0436090a80bb23a537bc4b9c066cec6ddd46f7f3029e07e=
3479541d7d127b05aa85be18002c59b41d4c6f3630d54c91d1a747aa1ef1c30faaeec4b94=
9199154cdfcf21b55493e9f43e98ad0dd492eed7491041f38f910024160d32fcdd1cf63ae=
0a65d9f6ee1164fce7717c47d9da69ae69dfdb206edcf5dac41266dc4e6f7b94bb429c814=
6c6e50668e7b53839b85b998ccdbda5bb51b74c3a7e4cda7301f3ddafb4e87945f1f64bda=
82a7ba42db1323d7f1357f68a0c8ad8b664ae2da1919dca4f679657477464c5f3d6d995e4=
52ad0b92075867ab3ef7cc7d6230798ed67af4202afa7b6a96a71f6bfdb044c0f86a6fb60=
31a5e8ac4d67ff8f7cb4652bc06b30ff476cdeaa536d383463d07c6bafbca89d06166c3d4=
a1bcf3b9a858d1d6a54f8e84458a446a291d28327ff612db80a19f680e50f57384b4d6ea3=
48557d07e4e7f71d02b83869a5b50716001cee1dadf47e3db26c20bf7e54bcd00f77878d8=
ddbca5687f1d93d73889d70da690613d4e60b1f6a99a430a93c4f6344acb830b16da48122=
2667e8d9d2d875635d55a495902e4b434f52505943712f6a05d90a371411d08fc5b3a7686=
772a6097e603f4c947dd6067de11c5e42f3d43a5148719e10062b334bf4cab4e1d3ba17b1=
0fd5d2e26b67d58bb1c04eff22fa45fe09c2f8441ea889ced3972d171041ce4ef8c68ea8a=
1b73419cb9d7c5b21ee316ed6cecdd96dc96631c6d213d92edb4734ad81465576d032a4a5=
5ed3f03045816703a290a8af40f9bf7b1da8089215dd813fe8e04e06aec54272b6ba48d67=
27723fa7208508f6fbe318ccd66d4d93ed2a584dee0b1745b6e99287cc4eb5ab025ad66ce=
610e85274865a7733a420d7d36de3e6462fd5bfa7f67700db7c8a51a82556fb09993ff0b4=
cc34ec17c19727f38903e8ad8f817c272e53612d79e8c218ff4b122a087ac839581ee953a=
e3134e7899f24d9c3c3349c99fc7f4083c974078d8e20f4ab16e74c418e1de03cfbe3bae1=
5bbf7da7eec27990f41ce8ec747b008872da491157fecae9c71b82836b55a34fd59a24ec5=
01c363db8520d2ab64ebb5cf42d67643911bfd26101777fe02db300c82f9a5bf0eed3206f=
a745e7a2311b6604e8a263dcfdc45aaebf2be105dc9a3c691d45bb01e36baadaef8e47e2c=
9aadcbe9ee2ae2fead646eace3ac7924dabe86aaa06e688234586a7ef3cdf6508ea3fd65e=
f0ee0f8e13919ed96b4f94f2a2c915c2377ff159c9386afc24276dd920b5449925d4b41b3=
9fc60902e03aefa57cb00d79ca8f14e51ba3fc9a0febbcbad5b5982271cf161a7bab4fdcc=
7deb48d3e7d125f171ec55ff0b5416de9f7b323c6002780286792ba3ba3dd3b7da5ad71aa=
7eecb7f555d1d80d69488b1a533203e767456c647fff0e4d01f81aa1673cab0d5e2bc234b=
f61c23b00eccafb9a6520600d0891b6609690891683ee8745516d69150f8e6bf4199798df=
436e5a6bd33d2d787d210aabeb423826d1ae5531343ac2c636216d91a4a467f66a3af2e00=
ba3c8ac8989187a59a8048e45db0ff4bffae9a6927796cc9a33c7300b293fce6755499554=
787adb31e8651f3d91ccfcd297c3517fac4585b12b85df78c186e43ed0923033edcb273f0=
f5b0fa357cbd58bbb134a3c29e063f907f6117cc34ab6ad66c8762215ca59ffd216a77063=
6ee82a8e605a9478d3e62a84b4a42713c7218eda3aa54c736e9c450dc497287baff675ea0=
10465897d83621121abb1940323bf30c6192f854af5611d9b5c2ac5a58cd36b9325f11e65=
7c4272f48414d0b82d89cca0be80cb4ae142f6442a9527ad0ee8deba525aa5cdeaaa60305=
10b8b2a1e85c9464c255940d968deb07abd463e18a68252e86f58a0f7d284527af45f769d=
e13dc1f06ac736ec7e5340d9ae9370a83a3fa1214fd84f1a3dbc848aaf178774df75ca2b7=
c09ba28e79759d747832841aa9861cb8efa3788c863ef5f949b0bf00d88f811dba5e91461=
f7d571d236d2e4aee29723048f9ee95dfabc090788d5f7703887fc38670cde115e75a3f42=
93d6e916ced7316917e4c8d583d949b3e59bf77ce8cc549a359ccc7649ea23adb0c164cbb=
6b97c8c4728338d993735a6bf18d89803e4b97c3d4bf3701d72bad91cff3c83ce0d493f91=
45fdb7cc098f63ab06247a8212b4862ee7b97bd1e4460dbaf6dbac749b21e97ea0f4033ab=
85977f1f6131afdfe1d3830c5fa4e5030d8d8930d890304832031baf11b17647f906d79a7=
11c8ee99855d4d7a00620864b9495c7b248ef9bedb29e8797afb9532da3a92dd6c99b4ca9=
b20539e5abc7d30778365cd8e1498bd9b9e7fed4c080769c45a2effc7ed811deed99a522c=
a018ac00eeacc402ad04e2e3348378eb9c9ed40abc416dd88768f21ad1d09f792628902e5=
177c95f259de1a73cf34a612d88f81cc33f8a5c3da0142eb906caf35f3787a26683a2b573=
a1f0b728f290bf74d441663c1c04be7deeb9e8493ebb29294e836cb25417d499cca7b7478=
26cec62d1254eff8487c5a91b203e95d531431f12431fb6522dbf0a702b5a41b4919004b6=
1455728fd3e47f56c96268c34301d05cad4014776944b33b4446b51076e71c691b4a190ac=
f008574977b74e10102f4dd272beab646ddcb0b4dab6bb511a12faa59a1b4dc3507fe8ad1=
bb8fd80c98df3e3e95551b816b583eda74f80efe345db19df93a355e2a22896b033fac066=
b370fa34e383ba957ed1c181378d9178a71d7b7e208487ae7decc0b9f56935b5e1faa29cd=
31c6d511c2997def9fd3747b416ec38196c8b5c0bbc845b242ef71c3e6bb0d704f475a33d=
25a6903c2319351324530c15325848b44f4cfbb05ca48a02cdbe164d35a66e2d7e02ef2d2=
37d49ad4f9defbea01db1b5d19802e28056382d3cd0077e2c67dae84704c99468a9e06c6f=
86c06f55249aa97c6d4c59fee7117e9fee9c21643e4af9b38c345a990f6c09b079243ff3d=
5ff14897e4b0740103e7049f13f467184742de82bdd71ccadeb8defe5c8ac6f0dac16fedc=
fc3da536e8d7313f0576cbbb7e18c89bccb3a30cc1fd39797b6874b2e9c69465c12a5be09=
4c949e8a668c47be512ea5a99cbe20c71dcfb6a000c7ef5d72467",
0x2000, &(0x7f0000000f40)=3D{0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, &(0x7f0000000c80)=3D{0xa0, 0x0, 0x5, {{0x3, 0x2=
, 0xffffffff, 0xfff, 0x10, 0xffff, {0x1, 0x100000001, 0x4, 0x1, 0x7, 0x4,=
 0xb, 0x101, 0x2, 0x8000, 0x7, r4, 0x0, 0x7, 0x1}}, {0x0, 0x2}}}, 0x0, 0x=
0})
r6 =3D syz_create_resource$binfmt(&(0x7f0000000080)=3D'./file0/file0\x00'=
)
sendmsg$nl_route(0xffffffffffffffff, &(0x7f0000000040)=3D{0x0, 0x0, &(0x7=
f00000000c0)=3D{&(0x7f0000000180)=3DANY=3D[@ANYBLOB=3D"4c0000001000110626=
bd7000fcdbdf2500000000", @ANYRES32=3D0x0, @ANYBLOB=3D"e550070040820700240=
012800b0001006d616373656300001400028005000c000000000005000600020000000800=
05"], 0x4c}, 0x1, 0x0, 0x0, 0xfe05cad2d9aaa8cb}, 0x20006800)
r7 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r7, &(0x7f0000000500)=3D{0x0, 0x0, &(0x7f00000004c0)=3D{=
&(0x7f0000000180)=3DANY=3D[@ANYBLOB=3D"340100001800010029bd7000fddbdf250a=
140000ff0400060000000005001400ef0000000400088008000300", @ANYRES32, @ANYB=
LOB=3D"ee000980ea"], 0x134}, 0x1, 0x0, 0x0, 0x44090}, 0x4c040)
ioctl$FUSE_DEV_IOC_BACKING_CLOSE(0xffffffffffffffff, 0x4004e502, 0x0)
r8 =3D openat$binfmt(0xffffffffffffff9c, r6, 0x42, 0x1ff)
fallocate(r8, 0x10, 0x400000000000003, 0x4)
ioctl$PPPIOCNEWUNIT(r0, 0xc004743e, &(0x7f0000000040)=3D0x2)
ioctl$PPPIOCSACTIVE(r0, 0x40107446, 0xffffffffffffffff)

80.61952ms ago: executing program 3 (id=3D13576):
bpf$PROG_LOAD(0x5, &(0x7f00000003c0)=3D{0x3, 0x4, &(0x7f0000002180)=3DANY=
=3D[@ANYBLOB=3D"180000", @ANYRESOCT=3D0x0], &(0x7f0000000500)=3D'GPL\x00'=
, 0x0, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @sched_cls=3D0x37, 0x0, 0x0, 0x0,=
 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
mprotect(&(0x7f0000000000/0x4000)=3Dnil, 0x4000, 0xd)
bpf$PROG_LOAD(0x5, &(0x7f00000003c0)=3D{0x3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0=
, 0x0, 0x6, '\x00', 0x0, @sched_cls, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0=
x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x94)
sendmsg$nl_route(0xffffffffffffffff, &(0x7f0000000040)=3D{0x0, 0x0, &(0x7=
f00000000c0)=3D{&(0x7f0000000100)=3DANY=3D[@ANYBLOB=3D"940000001000110726=
bd7000fcdbdf250000", @ANYRES32=3D0x0, @ANYBLOB=3D"e5500700000007006c00128=
009000100766c616e000000005c0002800600050088a80000100003800c00010205000000=
fbffffff0c0002000100000011000000100004800c00010003000000fe2a00001c00"], 0=
x94}, 0x1, 0x0, 0x0, 0xfe05cad2d9aaa8cb}, 0x2004e800)
socketpair$unix(0x1, 0x5, 0x0, &(0x7f0000000000)=3D{<r0=3D>0xffffffffffff=
ffff})
r1 =3D openat$vcsu(0xffffffffffffff9c, &(0x7f00000002c0), 0x100, 0x0)
read$FUSE(r1, &(0x7f0000000700)=3D{0x2020, 0x0, 0x0, <r2=3D>0x0}, 0x2020)=

setresuid(0x0, 0x0, r2)
sendmsg$unix(r0, &(0x7f0000002800)=3D{0x0, 0x0, 0x0, 0x0, &(0x7f00000001c=
0)=3D[@cred=3D{{0x1c, 0x1, 0x2, {0x0, r2}}}], 0x20, 0x2004a041}, 0x0)
r3 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r3, &(0x7f0000000040)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000140)=3DANY=3D[@ANYBLOB=3D"4c0000001a0001002abd7000ffdbdf250a=
148000f8000007020000000800170000004e2314"], 0x4c}, 0x1, 0x0, 0x0, 0x40010=
}, 0x4a800)
syz_emit_ethernet(0x2a, &(0x7f0000000100)=3D{@broadcast, @multicast, @voi=
d, {@ipv4=3D{0x800, @udp=3D{{0x5, 0x4, 0x0, 0x0, 0x1c, 0x0, 0x0, 0x0, 0x1=
1, 0x0, @initdev=3D{0xac, 0x1e, 0x1, 0x0}, @broadcast}, {0x0, 0x4e24, 0x8=
}}}}}, 0x0)

77.5699ms ago: executing program 3 (id=3D13577):
r0 =3D socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r0, &(0x7f0000000040)=3D{0x0, 0x0, &(0x7f0000001580)=3D{=
&(0x7f0000000140)=3D@newlink=3D{0x44, 0x10, 0x711, 0x70bf29, 0x25dfdbfc, =
{0x0, 0x0, 0x0, 0x0, 0x430e5, 0x20020}, [@IFLA_LINKINFO=3D{0x24, 0x12, 0x=
0, 0x1, @bond=3D{{0x9}, {0x14, 0x2, 0x0, 0x1, [@IFLA_BOND_PEER_NOTIF_DELA=
Y=3D{0x8, 0x1c, 0x7}, @IFLA_BOND_MIIMON=3D{0x8, 0x3, 0x7}]}}}]}, 0x44}, 0=
x1, 0x0, 0x0, 0x200400d0}, 0x2004e840)
openat$mice(0xffffffffffffff9c, &(0x7f0000000000), 0x301004)
bpf$PROG_LOAD(0x5, &(0x7f0000000040)=3D{0x16, 0x2, &(0x7f0000000100)=3DAN=
Y=3D[@ANYBLOB=3D"711907000000000095"], &(0x7f0000000300)=3D'syzkaller\x00=
', 0x2, 0x0, 0x0, 0x0, 0x40, '\x00', 0x0, @fallback=3D0x31, 0x0, 0x0, 0x0=
, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7}, 0x94)

618.14=C2=B5s ago: executing program 3 (id=3D13578):
r0 =3D socket$nl_route(0x10, 0x3, 0x0)
ioctl$sock_SIOCGIFINDEX(r0, 0x8933, &(0x7f0000000280)=3D{'bond0\x00'}) (a=
sync)
ioctl$sock_SIOCGIFINDEX(r0, 0x8933, &(0x7f0000000280)=3D{'bond0\x00', <r1=
=3D>0x0})
sendmsg$nl_route(r0, &(0x7f0000000000)=3D{0x0, 0x0, &(0x7f0000000040)=3D{=
&(0x7f0000000080)=3DANY=3D[@ANYBLOB=3D"3c0000001000110728bf7000fcdbdf2500=
000000", @ANYRES32=3D0x0, @ANYBLOB=3D"81500000602001001400acf175eb40855fe=
e20367148d6627dd51280097d0100626f6e64000000000400198008000a00afb7bebff873=
3e58c87d71af3bd17562a98edcd1df9ad478fa6135f5ebeaeff30c66fc2e9953b253b7511=
1a05664cfe53f7f4289da68337a319ef3739be19dc849c28ea208466f5624d1c431decc32=
46ef20c9731e23a9bf3348dc513c4618d75c99c4cbac23bf4ae3caf8be857338", @ANYRE=
S32=3Dr1, @ANYBLOB], 0x3c}, 0x1, 0x0, 0x0, 0x91}, 0x2004e840)

0s ago: executing program 3 (id=3D13579):
seccomp$SECCOMP_SET_MODE_FILTER_LISTENER(0x1, 0xa, &(0x7f0000000000)=3D{0=
x2, &(0x7f0000000040)=3D[{0x54, 0x8, 0xe, 0xff7effff}, {0x6, 0xa, 0xf, 0x=
200}]})
unshare(0x28060000)
r0 =3D syz_open_procfs$namespace(0x0, &(0x7f0000000000)=3D'ns/mnt\x00')
syz_clone(0x29000, 0x0, 0x0, &(0x7f00000000c0), 0x0, 0x0)
r1 =3D socket$inet6_sctp(0xa, 0x1, 0x84)
setsockopt$inet6_int(r1, 0x29, 0x1a, &(0x7f0000000000)=3D0x8, 0x4)
sendmmsg$inet6(r1, &(0x7f00000036c0)=3D[{{&(0x7f0000000580)=3D{0xa, 0x4e2=
3, 0x9, @loopback, 0x2}, 0x1c, &(0x7f0000001a40)=3D[{&(0x7f00000005c0)=3D=
"f456", 0x2}], 0x1}}], 0x1, 0x800)
setns(r0, 0x20000)
syz_clone(0x11042100, 0x0, 0xffffff1a, 0x0, 0x0, 0x0)
wait4(0x0, 0x0, 0x40000000, 0x0)
openat$pidfd(0xffffffffffffff9c, 0x0, 0x123400, 0x0)
ioctl$TUNATTACHFILTER(0xffffffffffffffff, 0x401054d5, &(0x7f00000000c0)=3D=
{0x8, &(0x7f0000000080)=3D[{0x2, 0x0, 0xb3, 0x51}, {0x6, 0x81, 0x8, 0xb},=
 {0x9, 0xf9, 0x2}, {0x80, 0x2, 0x4, 0x8}, {0x8, 0xe, 0x46, 0xffff}, {0x6,=
 0x8, 0x2, 0xfffffff7}, {0x3, 0x6, 0x8, 0x6}, {0x335, 0x2, 0x98, 0x2}]})



--=20
Best regards,
Tangxin Xie

