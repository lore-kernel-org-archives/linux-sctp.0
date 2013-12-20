From: Wang Weidong <weidong1991.wang@gmail.com>
Date: Fri, 20 Dec 2013 15:58:38 +0000
Subject: Re: [PATCH net-next 4/5] sctp: fix checkpatch errors
Message-Id: <52B4692E.3060400@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387435922-24152-1-git-send-email-wangweidong1@huawei.com> <1387435922-24152-5-git-send-email-wangweidong1@huawei.com> <20131220145121.GE6562@hmsreliant.think-freely.org>
In-Reply-To: <20131220145121.GE6562@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: davem@davemloft.net, vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wang Weidong <wangweidong1@huawei.com>

On 2013/12/20 22:51, Neil Horman wrote:
> On Thu, Dec 19, 2013 at 02:52:01PM +0800, Wang Weidong wrote:
>> fix up checkpatch errors:
>> that open brace { should be on the previous line
>> open brace '{' following function declarations go on the next line
>> ERROR: trailing statements should be on next line
>>
>> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
> These are all checkpatch errors.  You could have just merged them into a big
> patch.  Since you didn't, please be a bit more articulate in describing what
> they do in the subject line.
>
> Neil
>
You are right. Sure, I will make it more articulate in v2.

Thanks.
Wang

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
