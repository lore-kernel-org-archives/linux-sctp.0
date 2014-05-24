From: Daniel Borkmann <dborkman@redhat.com>
Date: Sat, 24 May 2014 21:47:11 +0000
Subject: Re: [PATCH] lksctp-tools: make bind_test can do while disable IPV6
Message-Id: <5381135F.50705@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <537EBD19.2030003@huawei.com>
In-Reply-To: <537EBD19.2030003@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 05/23/2014 05:14 AM, Wang Weidong wrote:
>  From e496cc0da4b43f4686e91aa9ffa73869e1f4c91d Mon Sep 17 00:00:00 2001
> From: Wang Weidong <wangweidong1@huawei.com>
> Date: Mon, 9 Jun 2014 23:32:39 +0800
> Subject: [PATCH] lksctp-tools: make bind_test can do while disable IPV6
>
> When disable IPv6, the bind_test can't work for IPv4. So add
> a variable 'domain' for support working for IPv4.
>
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Applied, thanks.
