From: David Miller <davem@davemloft.net>
Date: Wed, 13 Mar 2013 14:11:00 +0000
Subject: Re: [PATCH] sctp: don't break the loop while meeting the active_path so as to find the matched trans
Message-Id: <20130313.101100.2171722464896294416.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1362728377-11025-1-git-send-email-xufeng.zhang@windriver.com>
	<514084B0.4050906@gmail.com>
In-Reply-To: <514084B0.4050906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: xufeng.zhang@windriver.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 13 Mar 2013 09:52:48 -0400

> On 03/08/2013 02:39 AM, Xufeng Zhang wrote:
>> sctp_assoc_lookup_tsn() function searchs which transport a certain TSN
>> was sent on, if not found in the active_path transport, then go search
>> all the other transports in the peer's transport_addr_list, however,
>> we
>> should continue to the next entry rather than break the loop when meet
>> the active_path transport.
>>
>> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
 ...
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
...
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks everyone.
