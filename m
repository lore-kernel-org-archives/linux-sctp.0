From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Tue, 07 Sep 2010 08:46:58 +0000
Subject: Re: [patch] sctp: fix test for end of loop
Message-Id: <4C85FC02.3040804@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100906122344.GA2764@bicker>
In-Reply-To: <20100906122344.GA2764@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <error27@gmail.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, Wei Yongjun <yjwei@cn.fujitsu.com>, Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

Dan Carpenter wrote, at 09/06/2010 08:26 PM:
> +	    &new_addr->transports != &new_asoc->peer.transport_addr_list) {

why did you add this check?


-- 
Best Regards
-----
Shan Wei
