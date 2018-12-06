From: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Date: Thu, 06 Dec 2018 08:04:51 +0000
Subject: Re: [PATCH net] sctp: fix pr_warn max_data argument type mismatch
Message-Id: <c102fbd3-e8f0-1e83-db63-d9b11b632951@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181206075837.13336-1-jakub.audykowicz@gmail.com>
 <20181206.000347.363769635369199993.davem@davemloft.net>
In-Reply-To: <20181206.000347.363769635369199993.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org

On 2018-12-06 09:03, David Miller wrote:

> From: Jakub Audykowicz <jakub.audykowicz@gmail.com>
> Date: Thu,  6 Dec 2018 08:58:37 +0100
>
>> My previous patch introduced a compilation warning regarding a type
>> mismatch (int vs size_t). This is a one-letter fix for good housekeeping.
>>
>> Signed-off-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
> Still wrong and I fixed it when I applied your patch.
>
> You need to use the 'Z' prefix for size_t, so %Zu in this case.

Right, I just realized that as well, thanks!
