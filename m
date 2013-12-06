From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 06 Dec 2013 10:36:45 +0000
Subject: Re: [PATCH v4] sctp: check the rto_min and rto_max
Message-Id: <52A1A8BD.6040502@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <529FE2AD.5020700@huawei.com> <20131205133217.GA20349@hmsreliant.think-freely.org> <52A18F6D.9010606@huawei.com> <52A19DF6.1080808@redhat.com>
In-Reply-To: <52A19DF6.1080808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 2013/12/6 17:50, Daniel Borkmann wrote:
> On 12/06/2013 09:48 AM, Wang Weidong wrote:
> 
>> Should I define it in net/sctp/sctp.h, so sysctl.c can use it as well.
>> Or I just define it in the socket.c same as the definition in sysctl.c?
> 
> Preferably in include/net/sctp/constants.h where we already have most
> other constants anyway.
> 
> 
Hi Daniel,

in sysctl.c it will use a point to the value while the socket.c use the value.
So if I define macros SCTP_ONE or SCTP_TIMER_MAX in include/net/sctp/constants.h
which only used by socket.c. Is it OK?

Regards.
Wang

