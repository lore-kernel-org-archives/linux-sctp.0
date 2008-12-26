From: David Miller <davem@davemloft.net>
Date: Fri, 26 Dec 2008 00:56:25 +0000
Subject: Re: [PATCH net-next 1/5] sctp: Bring SCTP_MAXSEG socket option
Message-Id: <20081225.165625.248148862.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1229737672-28328-1-git-send-email-vladislav.yasevich@hp.com>
	<1229737672-28328-3-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1229737672-28328-3-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 19 Dec 2008 20:47:48 -0500

> From: Wei Yongjun <yjwei@cn.fujitsu.com>
> 
> Brings maxseg socket option set/get into line with the latest ietf socket
> extensions API draft, while maintaining backwards compatibility.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.  But I really dislike this scheme used by the compat code.
Half-way initializing a structure and then depending upon the logic in
the rest of the function to make sure the rest of the struct (the
uninitialized part) is never accessed?

Give me a break, programming, auditing, and bug fixing is hard enough
as it is without sloppy code like this.
