From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 20 Dec 2013 14:44:06 +0000
Subject: Re: [PATCH net-next 2/5] sctp: fix checkpatch errors with foo
Message-Id: <20131220144406.GC6562@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387435922-24152-1-git-send-email-wangweidong1@huawei.com>
 <1387435922-24152-3-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1387435922-24152-3-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>
Cc: davem@davemloft.net, vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Thu, Dec 19, 2013 at 02:51:59PM +0800, Wang Weidong wrote:
> fix three foo type errors below:
> ERROR: "(foo*)" should be "(foo *)"
> ERROR: "foo * bar" should be "foo *bar"
> ERROR: "foo* bar" should be "foo *bar"
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
Could you come up with a more descriptive subject line please.  I understand the
meaning, but anyone not familiar with checkpatch won't have any idea what that
means.
Neil

