From: David Miller <davem@davemloft.net>
Date: Tue, 13 Aug 2013 05:12:52 +0000
Subject: Re: [PATCH net] net: sctp: sctp_assoc_control_transport: fix MTU size in SCTP_PF state
Message-Id: <20130812.221252.2248587650673854871.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1376053748-31783-1-git-send-email-dborkman@redhat.com>
	<5204F121.7080609@gmail.com>
In-Reply-To: <5204F121.7080609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: dborkman@redhat.com, kheiss@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 09 Aug 2013 09:39:45 -0400

> On 08/09/2013 09:09 AM, Daniel Borkmann wrote:
>> The SCTP Quick failover draft [1] section 5.1, point 5 says that the
>> cwnd
>> should be 1 MTU. So, instead of 1, set it to 1 MTU.
>>
>>    [1] https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
>>
>> Reported-by: Karl Heiss <kheiss@gmail.com>
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
 ...
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks.
