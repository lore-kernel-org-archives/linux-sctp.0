From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Mar 2018 17:34:18 +0000
Subject: Re: [PATCH net-next] sctp: fix error return code in sctp_sendmsg_new_asoc()
Message-Id: <CADvbK_c2riQ4Tqne=q7v-n5kCcYqw5j+duppKWbuf9+TqZPFjQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1520856964-132516-1-git-send-email-weiyongjun1@huawei.com> <20180312.111903.1047457001442236332.davem@davemloft.net>
In-Reply-To: <20180312.111903.1047457001442236332.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Mon, Mar 12, 2018 at 11:19 PM, David Miller <davem@davemloft.net> wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> Date: Mon, 12 Mar 2018 12:16:04 +0000
>
>> Return error code -EINVAL in the address len check error handling
>> case since 'err' can be overwrite to 0 by 'err = sctp_verify_addr()'
>> in the for loop.
>>
>> Fixes: 2c0dbaa0c43d ("sctp: add support for SCTP_DSTADDRV4/6 Information for sendmsg")
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>
> Xin, I do not want to have a bug fix like this blocked because of that
> SCTP options merge nightmare which is of no fault of our own.
Okay, sorry, I was over worried recently, thank you.
