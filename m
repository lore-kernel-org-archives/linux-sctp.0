From: David Miller <davem@davemloft.net>
Date: Wed, 11 Dec 2013 03:54:55 +0000
Subject: Re: [PATCH v7 0/3] sctp: check the rto_min and rto_max
Message-Id: <20131210.225455.153484626789533860.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1386726640-9584-1-git-send-email-wangweidong1@huawei.com>
	<52A7D0E0.4080506@gmail.com>
In-Reply-To: <52A7D0E0.4080506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: wangweidong1@huawei.com, nhorman@tuxdriver.com, dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 10 Dec 2013 21:41:36 -0500

> On 12/10/2013 08:50 PM, Wang Weidong wrote:
>> v6 -> v7:
>>   -patch2: fix the whitespace issues which pointed out by Daniel
>> 
>> v5 -> v6:
>>   split the v5' first patch to patch1 and patch2, and remove the
>>   macro in constants.h
>> 
>>   -patch1: do rto_min/max socket option handling in its own patch, and
>>    fix the check of rto_min/max.
>>   -patch2: do rto_min/max sysctl handling in its own patch.
>>   -patch3: add Suggested-by Daniel.
>> 
>> v4 -> v5:
>>   - patch1: add marco in constants.h and fix up spacing as
>>     suggested by Daniel
>>   - patch2: add a patch for fix up do_hmac_alg for according
>>     to do_rto_min[max]
>> 
>> v3 -> v4:
>>   -patch1: fix use init_net directly which suggested by Vlad.
>> 
>> v2 -> v3:
>>   -patch1: add proc_handler for check rto_min and rto_max which suggested
>>    by Vlad
>> 
>> v1 -> v2:
>>   -patch1: fix the From Name which pointed out by David, and
>>    add the ACK by Neil
>> 
>> Wang Weidong (3):
>>   sctp: check the rto_min and rto_max in setsockopt
>>   sctp: add check rto_min and rto_max in sysctl
>>   sctp: fix up a spacing
> 
> Series
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Series applied, thanks.
