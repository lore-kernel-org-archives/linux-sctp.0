From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 06 Dec 2013 01:23:51 +0000
Subject: Re: [PATCH v4] sctp: check the rto_min and rto_max
Message-Id: <52A12727.1060308@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <529FE2AD.5020700@huawei.com> <20131205133217.GA20349@hmsreliant.think-freely.org> <52A088A9.9090200@gmail.com> <52A0A8ED.70903@redhat.com>
In-Reply-To: <52A0A8ED.70903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>, Wang Weidong <weidong1991.wang@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 2013/12/6 0:25, Daniel Borkmann wrote:
> On 12/05/2013 03:07 PM, Wang Weidong wrote:
>> From: Wang Weidong <wangweidong1@huawei.com>
>> On 2013/12/5 21:32, Neil Horman wrote:
>>> On Thu, Dec 05, 2013 at 10:19:25AM +0800, Wang Weidong wrote:
>>>> rto_min should be smaller than rto_max while rto_max should be larger
>>>> than rto_min. Add two proc_handler for the checking. Add the check in
>>>> sctp_setsockopt_rtoinfo.
>>>> delete a blank line in proc_sctp_do_hmac_alg() declaration.
>>>>
>>>> Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
>>>> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
>>>> ---
>>>>   net/sctp/socket.c |  5 ++++
>>>>   net/sctp/sysctl.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>>>>   2 files changed, 74 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>>>> index 72046b9..2e1af1b 100644
>>>> --- a/net/sctp/socket.c
>>>> +++ b/net/sctp/socket.c
>>>> @@ -2818,6 +2818,11 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
>>>>       if (copy_from_user(&rtoinfo, optval, optlen))
>>>>           return -EFAULT;
>>>>
>>>> +    if (rtoinfo.srto_min < 1 ||
>>>> +        rtoinfo.srto_max > 86400000 ||
>>> These should be defiend to some descriptive value.
>>>
>> Thanks for your suggestion. I will fix it in v5.
> 
> While you're on v5 anyway, please also fix up spacing in your
> commit from ...
> 
> static int proc_sctp_do_rto_min(struct ctl_table *ctl,
>                 int write,
>                 void __user*buffer, size_t *lenp,
>                 loff_t *ppos)
> 
> ... to something like ...
> 
> static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
>                 void __user *buffer, size_t *lenp,
>                 loff_t *ppos)
> 
> Thanks !

Hm, I do it for according to the proc_sctp_do_hmac_alg which is in the same file.
If I fix this, I think it is better to fix the proc_sctp_do_hmac_alg as well. 
Should I do it a patch or another patch?

Thanks!

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


