From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 10 Dec 2013 15:21:11 +0000
Subject: Re: [PATCH v6 2/3] sctp: add check rto_min and rto_max in sysctl
Message-Id: <52A73167.6000106@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1386643597-22156-1-git-send-email-wangweidong1@huawei.com> <1386643597-22156-3-git-send-email-wangweidong1@huawei.com> <52A72666.5010304@gmail.com> <52A730B9.7060909@gmail.com>
In-Reply-To: <52A730B9.7060909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <weidong1991.wang@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 12/10/2013 04:18 PM, Wang Weidong wrote:
...
>>> +static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
>>> +                                void __user*buffer, size_t *lenp,
>>                                           ^^^^
>> Please put a space before the '*'.
...
>>> +static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
>>> +                                void __user*buffer, size_t *lenp,
>>                                           ^^^^
>> Please put a space after the before the '*'.
>>
> Ok, I will fix them.
> What Daniel point out is that? I no need to line up them?

Yes, what Vlad pointed out to you is what I meant in my reply to
your cover letter ...
