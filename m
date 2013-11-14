From: David Miller <davem@davemloft.net>
Date: Thu, 14 Nov 2013 21:36:06 +0000
Subject: Re: [PATCH] net: sctp: bug-fixing: retran_path not set properly after transports recovering (v3)
Message-Id: <20131114.163606.2234502533328622215.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1384387106-8105-1-git-send-email-changxiangzhong@gmail.com>
In-Reply-To: <1384387106-8105-1-git-send-email-changxiangzhong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: changxiangzhong@gmail.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Chang Xiangzhong <changxiangzhong@gmail.com>
Date: Thu, 14 Nov 2013 00:58:26 +0100

> When a transport recovers due to the new coming sack, SCTP should
> iterate all of its transport_list to locate the __two__ most recently used
> transport and set to active_path and retran_path respectively. The exising
> code does not find the two properly - In case of the following list:
> 
> [most-recent] -> [2nd-most-recent] -> ...
> 
> Both active_path and retran_path would be set to the 1st element.
> 
> The bug happens when:
> 1) multi-homing
> 2) failure/partial_failure transport recovers
> Both active_path and retran_path would be set to the same most-recent one, in
> other words, retran_path would not take its role - an end user might not even
> notice this issue.
> 
> Signed-off-by: Chang Xiangzhong <changxiangzhong@gmail.com>

Applied, thanks.
