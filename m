Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49E3175A85;
	Sat,  5 Sep 2026 01:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788571089; cv=none; b=aTPvf+N59XeuyfvRnrN7cg3TcBnvx0hkJParW9rSbZ+m59enB5sJtamRdPxTw+cp1EzCy62dHSaDNQRhtSXEvEtZ7toHiArQ++TxNfdiXBzJbOai7kGLQl8Yr38UKJ9CdGB9y4XQvnGukeTTmSeeRzy1Egj37XIm3b/+fKYX/4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788571089; c=relaxed/simple;
	bh=Kmhs14Ex3KwBhqEPckVEtc+6ggmthw89SIE3YPmL8NE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qGVzNJun9PUiu8g9R+gOQo31d1bXtB8g/GrODUejPV8iwkdgpOWhKVZwM+h0PsppH7kyYkJF+YX/szyGbQc247NCWRv+mX092XHhVUigBgM9lauBx8pyQZVLEmA0DQ8i0QfVWJxHEQfz1GXA7nVYP6tPDec6jOdAlFtOpyPYNeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=OlAQ7gln; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="OlAQ7gln"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Owt6eES0/4DG5wsNzS+RJoogK/Xslxq9s8opMqLveN0=;
	b=OlAQ7glnke9CZfCZS6tQXzaon+hRNuawG54XwYsbeYSVfsYkn+XZTNdY9fHWhS9ugwtrKYC38
	rkqwXNtQ5IHwrf/0GZBWE/I4Qe61dGBJIz5ukvjt89DdpjwlVuCdDbjV3OOer9nTGthPrfcQrK/
	XcR9HJsYvCAVISYLWuXPF/c=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hcFXR4PLNz1T4Fq;
	Sat,  5 Sep 2026 09:06:31 +0800 (CST)
Received: from kwepemr100001.china.huawei.com (unknown [7.202.195.168])
	by mail.maildlp.com (Postfix) with ESMTPS id EC32B40575;
	Sat,  5 Sep 2026 09:17:56 +0800 (CST)
Received: from [10.136.112.147] (10.136.112.147) by
 kwepemr100001.china.huawei.com (7.202.195.168) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 5 Sep 2026 09:17:55 +0800
Message-ID: <b47907f0-8ba2-4a15-8ce5-8de9596efca4@h-partners.com>
Date: Sat, 5 Sep 2026 09:17:55 +0800
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [sctp?] WARNING: refcount bug in sctp_transport_put (6)
To: Xin Long <lucien.xin@gmail.com>
CC: David Laight <david.laight.linux@gmail.com>,
	<syzbot+80dfcb1a2235b3efc877@syzkaller.appspotmail.com>, "David S . Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Simon Horman
	<horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
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
 <057c057f-be11-4bf7-9403-f454bb2864c9@h-partners.com>
 <CADvbK_eBx0AicxxWXE1ZOqeNUJtU2YPgTynthBkhq3_1jks9iw@mail.gmail.com>
Content-Language: en-US
From: xietangxin <xietangxin@h-partners.com>
In-Reply-To: <CADvbK_eBx0AicxxWXE1ZOqeNUJtU2YPgTynthBkhq3_1jks9iw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100001.china.huawei.com (7.202.195.168)



On 9/3/2026 10:00 PM, Xin Long wrote:
> On Wed, Sep 2, 2026 at 11:23 PM xietangxin <xietangxin@h-partners.com> wrote:
>>
>>
>>
>> On 9/2/2026 5:46 AM, David Laight wrote:
>>> On Tue, 1 Sep 2026 11:06:31 -0400
>>> Xin Long <lucien.xin@gmail.com> wrote:
>>>
>>>> On Tue, Sep 1, 2026 at 10:35 AM David Laight
>>>> <david.laight.linux@gmail.com> wrote:
>>>>>
>>>>> On Tue, 1 Sep 2026 09:45:42 -0400
>>>>> Xin Long <lucien.xin@gmail.com> wrote:
>>>>>
>>>>>> On Mon, Aug 31, 2026 at 11:47 PM xietangxin <xietangxin@h-partners.com> wrote:
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> I have analyzed this issue and successfully reproduced locally.
>>>>>>> The race occurs between the timer callback (`sctp_generate_heartbeat_event`) and
>>>>>>> the transport cleanup path (`sctp_transport_free`):
>>>>>>>
>>>>>>> Task 1(Timer Softirq)               Task 2(sctp_transport_free)
>>>>>>> ==========================              ===============================
>>>>>>> sctp_generate_heartbeat_event()
>>>>>>>   refcnt = 2
>>>>>>>
>>>>>>>   bh_lock_sock(sk)
>>>>>>>   sock_owned_by_user(sk)
>>>>>>>   mod_timer(&hb_timer) -> returns 0
>>>>>>>                                           sctp_transport_free()
>>>>>>>                                             transport->dead = 1
>>>>>>>                                             del_timer(&hb_timer) -> returns 1!
>>>>>>>                                               sctp_transport_put() (2 -> 1)
>>>>>>>                                             sctp_transport_put() (1 -> 0)
>>>>>>>                                               sctp_transport_destroy()
>>>>>>>
>>>>>>>   sctp_transport_hold()
>>>>>>>     -> refcnt is 0, increment fails
>>>>>>
>>>>>> This should not be 0, as the transport must hold a refcnt to start the
>>>>>> hb_timer.
>>>>>
>>>>> Isn't there one hold sctp_generate_heartbeat_event() and a second for
>>>>> whatever 'task 2' is doing.
>>>> Right,
>>>>
>>>>> When hb_timer is started it is given another hold (does it actually need one??).
>>>> You mean mod_timer() in sctp_generate_heartbeat_event()?  Yes, as it will
>>>> release the last one in out_unlock, it must hold a new one.
>>>
>>> But can that ever be the last 'hold' that actually calls sctp_transport_destroy().
> Sorry, by “release the last one” above, I meant releasing the previous
> “hold.”
> 
> If the hold succeeds after mod_timer(), it can never be the last/final hold
> that calls sctp_transport_destroy().
> 
> However, in the current code, there's a window between mod_timer() and
> sctp_transport_hold() at [1], sctp_transport_destroy() can be called
> to  delete the newly enqueued timer and release the previous hold.
> The hold at [2] for the newly enqueuing has not been taken yet.
> 
>   if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20))) {
>           mdelay(1);  /* [1] */
>           sctp_transport_hold(transport); /* [2] */
>   }
> 
>>> It the timer is always deleted (as task 2 above) it doesn't need one itself.
>>> Might need to be del_timer_sync() so that it waits for the completion function
>>> to terminate.
>>>
> Unfortunately, del_timer_sync() can only be used in sleepable contexts.
> 
>>>>
>>>>> So when hb_timer is deleted it's hold is removed.
>>>>> But the del_timer() is happening before the the extra hold is obtained.
>>>>>
>>>> Ahh, I can see the race now.
>>>>
>>>> I remember you mentioned holding it before mod_reduce() in a previous
>>>> patch, maybe it will work here, like:
>>>>
>>>>                 sctp_transport_hold(transport);
>>>>                 if (mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
>>>>                         sctp_transport_put(transport);
>>>>
>>>> Does it make sense?
>>>
>>> That should close the timing window, but is probably inefficient.
>>> Rather depends on how often the 'put' ends up being done.
>>>
> Each timer enqueue must have a corresponding hold. As long as we take the
> hold before enqueueing the timer, there is no race.
> 
>>> David
>>>
>>>>
>>>> Thanks.
>>>>
>>>>> The RHS (task 2) would need to hold bh_lock_sock().
>>>>>
>>>>> Try giving sctp_generate_heartbeat_event() two holds.
>>>>>
>>>>> David
>>>>>
>>>>>
>>>>>>
>>>>>> Also, the delay below is under bh_lock_sock(), so it should not be the
>>>>>> real cause of the issue.
>>>>>>
>>>>>> Could you share the PoC for this issue?
>>>>>>
>>>>>> Thanks.
>>>>>>
>>>>>>>   out_unlock:
>>>>>>>     sctp_transport_put() (0 -> -1)
>>>>>>>     -> refcount underflow warning!
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Adding a small delay  after `mod_timer()` increases the reproduction rate:
>>>>>>>
>>>>>>> --- a/net/sctp/sm_sideeffect.c
>>>>>>> +++ b/net/sctp/sm_sideeffect.c
>>>>>>> @@ -373,8 +373,10 @@ void sctp_generate_heartbeat_event(struct timer_list *t)
>>>>>>>                 pr_debug("%s: sock is busy\n", __func__);
>>>>>>>
>>>>>>>                 /* Try again later.  */
>>>>>>> -               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
>>>>>>> +               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20))) {
>>>>>>> +                       mdelay(1);
>>>>>>>                         sctp_transport_hold(transport);
>>>>>>> +               }
>>>>>>>                 goto out_unlock;
>>>>>>>         }
>>>>>>>
>>>>>>> Any feedback or guidance would be greatly appreciated.
>>>>>>>
>>>>>>> --
>>>>>>> Best regards,
>>>>>>> Tangxin Xie
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
>> Hi , David,
>>
>> I have a syzkaller execution log that can trigger this issue.
>> Please let me know if there is anything else I can do.
> 
> Hi, Tangxin,
> 
> Can you try if the change below will fix the race?
> (You may add mdelay() back for reproducing)
> 
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 94716406d602..c0fddd5e8097 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -378,8 +378,9 @@ void sctp_generate_heartbeat_event(struct timer_list *t)
>                 pr_debug("%s: sock is busy\n", __func__);
> 
>                 /* Try again later.  */
> -               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
> -                       sctp_transport_hold(transport);
> +               sctp_transport_hold(transport);
> +               if (mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
> +                       sctp_transport_put(transport);
>                 goto out_unlock;
>         }
> 
> Thanks.
Hi Xin,

Thanks for the patch.
I have tested this fix in my local environment.

Testing results:
- Without patch: The refcount underflow issue could be reproduced
within 10 minutes using the reproducer.
- With patch applied: Ran the same reproducer continuously for
over 16 hours without encountering any issues.

-- 
Best regards,
Tangxin Xie

