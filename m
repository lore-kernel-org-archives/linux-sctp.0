From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Date: Thu, 06 Jun 2019 20:41:32 +0000
Subject: Re: [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)
Message-Id: <37cbb3d8-bec8-4dd7-ba1f-31a2919316ca@metux.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190605142428.84784-1-wangkefeng.wang@huawei.com>
 <20190605142428.84784-3-wangkefeng.wang@huawei.com>
 <20190605091319.000054e9@intel.com>
 <721a48ce-c09a-a35e-86ae-eac5eec26668@huawei.com>
In-Reply-To: <721a48ce-c09a-a35e-86ae-eac5eec26668@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kefeng Wang <wangkefeng.wang@huawei.com>, Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 06.06.19 03:39, Kefeng Wang wrote:

Hi folks,

> There is no different in assembly output (only check the x86/arm64), and
> the Enrico Weigelt have finished a cocci script to do this cleanup.

I haven't compared the assembly output, just logically deduced from the
macro. If I understand it correctly, the likely()/unlikely() macros
just add a hint to the compiler, which branch it should optimize harder.

No idea what the compiler's actually doing, but I believe its things
like optimized shortcut evaluation and avoiding jumps to likely
branches.

>> I'm not sure in the end that the change is worth it, so would like you
>> to prove it is, unless davem overrides me. :-)

Depends on what you count as worthy ;-)

This patch just makes a source a bit more compact / easier to read.
But shouldn't have any actual consequence on the generated binary.


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
