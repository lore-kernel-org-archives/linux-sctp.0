From: David Miller <davem@davemloft.net>
Date: Tue, 10 Dec 2019 04:14:19 +0000
Subject: Re: [PATCHv2 net] sctp: get netns from asoc and ep base
Message-Id: <20191209.201419.1322197127670226216.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <76df0e4ae335e3869475d133ce201cc93361ce0c.1575870318.git.lucien.xin@gmail.com>
        <20191209.101403.781347318798443818.davem@davemloft.net>
        <CADvbK_cVw49RXCnR3ztKC_RzZf=ipoH2a8ZabaAytmPy+0j4jQ@mail.gmail.com>
In-Reply-To: <CADvbK_cVw49RXCnR3ztKC_RzZf=ipoH2a8ZabaAytmPy+0j4jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Dec 2019 12:03:17 +0800

> On Tue, Dec 10, 2019 at 2:14 AM David Miller <davem@davemloft.net> wrote:
>>
>> From: Xin Long <lucien.xin@gmail.com>
>> Date: Mon,  9 Dec 2019 13:45:18 +0800
>>
>> > Commit 312434617cb1 ("sctp: cache netns in sctp_ep_common") set netns
>> > in asoc and ep base since they're created, and it will never change.
>> > It's a better way to get netns from asoc and ep base, comparing to
>> > calling sock_net().
>> >
>> > This patch is to replace them.
>> >
>> > v1->v2:
>> >   - no change.
>> >
>> > Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
>>
>> This looks like a cleanup rather than a bug fix, so net-next right?
> Yes, a cleanup, and net-next should be better.

Great, applied to net-next.
