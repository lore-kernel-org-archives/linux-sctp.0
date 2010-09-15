From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 15 Sep 2010 13:02:56 +0000
Subject: Re: [PATCH] net: SCTP NULL-pointer dereference problem description
Message-Id: <4C90C400.7040405@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <201009151003.17407.dreibh@iem.uni-due.de> <4C908768.4040502@cn.fujitsu.com> <201009151453.14465.dreibh@iem.uni-due.de>
In-Reply-To: <201009151453.14465.dreibh@iem.uni-due.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Thomas Dreibholz <dreibh@iem.uni-due.de>
Cc: Shan Wei <shanwei@cn.fujitsu.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Martin Becke <martin.becke@uni-due.de>

On 09/15/2010 08:53 AM, Thomas Dreibholz wrote:
> On Mittwoch 15 September 2010, Shan Wei wrote:
>> Thomas Dreibholz wrote, at 09/15/2010 04:03 PM:
>>> sctp_assoc_update_retran_path() in net/sctp/associola.c may dereference=
 a
>>> NULL-pointer when compiled with SCTP_DEBUG option: t will be NULL if
>>> there is no usable path for retransmission. SCTP_DEBUG_PRINTK_IPADDR()
>>> makes an access to t->ipaddr.v4.sin_port, without checking t before.
>>> t=3DNULL =3D> oops.
>>>
>>> The patch below against 2.6.36-rc4 (git repository) simply ensures that=
 t
>>> is checked for not being set to NULL before calling
>>> SCTP_DEBUG_PRINTK_IPADDR().
>>
>> This bug has been reported by WeiYongjun and fixed by vlad for several
>> months. About the details see .
>> http://marc.info/?l=3Dlinux-sctp&m=127359276009851&w=3D2
>>
>> But this patch is still in vlad's net-next tree, not in main tree.
>> See the patch:
>> http://git.kernel.org/?p=3Dlinux/kernel/git/vxy/lksctp-dev.git;a=3Dcommi=
t;h=EB1
>> 639d206320e6a09168d6dd77306eaf5f02582
>=20
> This patch resolves the problem. I am using the main tree. The patch shou=
ld=20
> also be applied there.
>=20
>=20
> Best regards

Yes.  I know.  I've been just touch busy (and not with SCTP pieces) and bac=
klog
is starting to accumulate.
I'll try to push stuff out this week.

-vlad

