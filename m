From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Tue, 05 Jul 2011 01:36:29 +0000
Subject: Re: [PATCH 2/2] Update documented default values for various TCP/UDP
Message-Id: <4E126A9D.3060507@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110704083616.43F2C8156C57@regina.usersys.redhat.com>
In-Reply-To: <20110704083616.43F2C8156C57@regina.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Max Matveev <makc@redhat.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Max Matveev wrote, at 06/22/2011 03:18 PM:
> tcp_rmem and tcp_wmem use 1 page as default value for the minimum
> amount of memory to be used, same as udp_wmem_min and udp_rmem_min.
> Pages are different size on different architectures - use the right
> units when describing the defaults.
> 
> Signed-off-by: Max Matveev <makc@redhat.com>

Reviewed-by: Shan Wei <shanwei@cn.fujitsu.com>


-- 
Best Regards
-----
Shan Wei
