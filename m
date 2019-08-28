From: David Miller <davem@davemloft.net>
Date: Wed, 28 Aug 2019 03:55:00 +0000
Subject: Re: [PATCH net-next 0/3] sctp: add SCTP_ECN_SUPPORTED sockopt
Message-Id: <20190827.205500.2094153294135948781.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566807985.git.lucien.xin@gmail.com>
        <20190826110221.GA7831@hmswarspite.think-freely.org>
In-Reply-To: <20190826110221.GA7831@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 26 Aug 2019 07:02:21 -0400

> On Mon, Aug 26, 2019 at 04:30:01PM +0800, Xin Long wrote:
>> This patchset is to make ecn flag per netns and endpoint and then
>> add SCTP_ECN_SUPPORTED sockopt, as does for other feature flags.
>> 
>> Xin Long (3):
>>   sctp: make ecn flag per netns and endpoint
>>   sctp: allow users to set netns ecn flag with sysctl
>>   sctp: allow users to set ep ecn flag by sockopt
 ...
> Series
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Series applied to net-next, thanks.
