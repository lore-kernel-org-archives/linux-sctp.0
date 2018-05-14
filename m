From: Ye Xiaolong <xiaolong.ye@intel.com>
Date: Mon, 14 May 2018 07:40:53 +0000
Subject: Re: [kbuild-all] [PATCH net-next 2/2] sctp: add sctp_make_op_error_limited and reuse inner functions
Message-Id: <20180514074053.GA21079@yexl-desktop>
List-Id: <linux-sctp.vger.kernel.org>
References: <53909b1bd523d45a453431968fd1e03fd4be6196.1525017179.git.marcelo.leitner@gmail.com>
 <201804300849.DRgYHLmw%fengguang.wu@intel.com>
 <20180430023421.GA4977@localhost.localdomain>
In-Reply-To: <20180430023421.GA4977@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: kbuild test robot <lkp@intel.com>, Xin Long <lucien.xin@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, kbuild-all@01.org

Sorry for the late response.


On 04/29, Marcelo Ricardo Leitner wrote:
>On Mon, Apr 30, 2018 at 10:14:06AM +0800, kbuild test robot wrote:
>> Hi Marcelo,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on net-next/master]
>>
>> url:    https://github.com/0day-ci/linux/commits/Marcelo-Ricardo-Leitner/sctp-allow-sctp_init_cause-to-return-errors/20180430-073613
>
>This URL doesn't work, 404.

Our fault, 0day service failed to push related changes to github recently, we're
fixing it.

>
>> config: x86_64-randconfig-x006-201817 (attached as .config)
>> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
>> reproduce:
>>         # save the attached .config to linux build tree
>>         make ARCH=x86_64
>>
>> All errors (new ones prefixed by >>):
>>
>>    net//sctp/sm_make_chunk.c: In function 'sctp_make_op_error_limited':
>> >> net//sctp/sm_make_chunk.c:1260:9: error: implicit declaration of function 'sctp_mtu_payload'; did you mean 'sctp_do_peeloff'? [-Werror=implicit-function-declaration]
>>      size = sctp_mtu_payload(sp, size, sizeof(struct sctp_errhdr));
>>             ^~~~~~~~~~~~~~~~
>>             sctp_do_peeloff
>>    cc1: some warnings being treated as errors
>
>Seems the test didn't pick up the MTU refactor patchset yet.

Do you mean your patchset require MTU refactor patchset as prerequisites?

Thanks,
Xiaolong

>
>$ grep sctp/sctp -- net/sctp/sm_make_chunk.c
>#include <net/sctp/sctp.h>
>
>$ git grep sctp_mtu_payload -- include/
>include/net/sctp/sctp.h:static inline __u32 sctp_mtu_payload(const
>struct sctp_sock *sp,
>
>it should be reachable.
>
>  Marcelo
>_______________________________________________
>kbuild-all mailing list
>kbuild-all@lists.01.org
>https://lists.01.org/mailman/listinfo/kbuild-all
