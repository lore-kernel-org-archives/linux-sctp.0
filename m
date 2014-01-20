From: Wang Weidong <wangweidong1@huawei.com>
Date: Mon, 20 Jan 2014 12:06:15 +0000
Subject: Re: [PATCH net-next 0/2] sctp: some small clean ups
Message-Id: <52DD1137.8040502@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1390217247-9408-1-git-send-email-wangweidong1@huawei.com> <52DD0A62.9050807@redhat.com>
In-Reply-To: <52DD0A62.9050807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net, vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 2014/1/20 19:37, Daniel Borkmann wrote:
> On 01/20/2014 12:27 PM, Wang Weidong wrote:
>> We have the macros in sctp.h, so use them for coding accordance
>> in sctp.
> 
> Thanks for doing this Wang.
> 
> I am actually wondering why we have these macro locking wrappers

Here, I didn't found any description about it. In v2.6.12-rc2, the sctp
use these macros.

> and not use these functions directly? Hm, any reasons? Maybe we
> should rather go in the other direction with this?
> 

Yeah. 
Should I do the other direction for clean ups now?

Regards,
Wang

>> Wang Weidong (2):
>>    sctp: use sctp_local_bh_{disable|enable} instead
>>      local_bh_{disable|enable}
>>    sctp: use sctp_read_[un]lock instead of read_[un]lock
>>
>>   net/sctp/endpointola.c   |  4 ++--
>>   net/sctp/input.c         | 10 +++++-----
>>   net/sctp/proc.c          | 12 ++++++------
>>   net/sctp/sm_make_chunk.c |  8 ++++----
>>   net/sctp/socket.c        |  8 ++++----
>>   5 files changed, 21 insertions(+), 21 deletions(-)
>>
> 
> 


