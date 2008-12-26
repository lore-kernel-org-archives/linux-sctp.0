From: David Miller <davem@davemloft.net>
Date: Fri, 26 Dec 2008 00:57:43 +0000
Subject: Re: [PATCH net-next 3/5] sctp: Implement socket option
Message-Id: <20081225.165743.227309090.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1229737672-28328-1-git-send-email-vladislav.yasevich@hp.com>
	<1229737672-28328-5-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1229737672-28328-5-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 19 Dec 2008 20:47:50 -0500

> From: Wei Yongjun <yjwei@cn.fujitsu.com>
> 
> Implement socket option SCTP_GET_ASSOC_NUMBER of the latest ietf socket
> extensions API draft.
> 
>   8.2.5.  Get the Current Number of Associations (SCTP_GET_ASSOC_NUMBER)
> 
>    This option gets the current number of associations that are attached
>    to a one-to-many style socket.  The option value is an uint32_t.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
