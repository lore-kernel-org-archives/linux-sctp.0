From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 02 Dec 2013 12:59:18 +0000
Subject: Re: [PATCH RESEND] lksctp: fix a problem when do test_1_to_1_sockopt
Message-Id: <529C8426.2080908@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <529C496C.10403@huawei.com>
In-Reply-To: <529C496C.10403@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/02/2013 09:48 AM, Wang Weidong wrote:
> From: Wang Weidong <wangweidong1@huawei.com>
>
> When I do the test_1_to_1_sockopt, I got a Segmentation fault:
> DUMP_CORE test_1_to_1_sockopt.c: 343.
> I used the kernel is 3.12.
> The problem is that the SOCK_MIN_SNDBUF is (TCP_SKB_MIN_TRUESIZE * 2)
> while TCP_SKB_MIN_TRUESIZE is 2048 + SKB_DATA_ALIGN(sizeof(struct sk_buff))
> The SKB_DATA_ALIGN I test is 256, so I make the sndbuf_val_set to 2304.
>
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Applied, thanks.
