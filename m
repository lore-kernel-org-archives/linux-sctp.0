From: David Miller <davem@davemloft.net>
Date: Sat, 19 Oct 2013 22:52:01 +0000
Subject: Re: [PATCH v3] net: sctp: fix a cacc_saw_newack missetting issue
Message-Id: <20131019.185201.587650685333387175.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1381908131-24809-1-git-send-email-changxiangzhong@gmail.com>
In-Reply-To: <1381908131-24809-1-git-send-email-changxiangzhong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: changxiangzhong@gmail.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chang Xiangzhong <changxiangzhong@gmail.com>
Date: Wed, 16 Oct 2013 09:22:11 +0200

> For for each TSN t being newly acked (Not only cumulatively,
> but also SELECTIVELY) cacc_saw_newack should be set to 1.
> 
> Signed-off-by: Xiangzhong Chang <changxiangzhong@gmail.com>

SCTP folks, can you please review this patch?

Thanks.
