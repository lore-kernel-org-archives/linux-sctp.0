From: David Miller <davem@davemloft.net>
Date: Sat, 23 Nov 2013 22:46:57 +0000
Subject: Re: [PATCH] net: sctp: find the correct highest_new_tsn in sack
Message-Id: <20131123.144657.1317547893471212174.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1385070988-29554-1-git-send-email-changxiangzhong@gmail.com>
	<528E85A9.3000703@gmail.com>
In-Reply-To: <528E85A9.3000703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: changxiangzhong@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 21 Nov 2013 17:14:01 -0500

> On 11/21/2013 04:56 PM, Chang Xiangzhong wrote:
>> Function sctp_check_transmitted(transport t, ...) would iterate all of
>> transport->transmitted queue and looking for the highest __newly__ acked tsn.
>> The original algorithm would depend on the order of the assoc->transport_list
>> (in function sctp_outq_sack line 1215 - 1226). The result might not be the
>> expected due to the order of the tranport_list.
>> 
>> Solution: checking if the exising is smaller than the new one before assigning
>> 
>> Signed-off-by: Chang Xiangzhong <changxiangzhong@gmail.com>
> 
> Good find.  This has been around for since day 1.  It doesn't so much
> depend on the order of the transport list, but on the order the
> transports been used.  I agree it is a problem if chunks have been
> distributed across multiple transports and a singe SACK acking them all.
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks.
