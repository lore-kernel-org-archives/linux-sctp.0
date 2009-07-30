From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 06:55:44 +0000
Subject: Re: [PATCH] sctp: remove unused union (sctp_cmsg_data_t) definition
Message-Id: <4A7143F0.40401@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <ae5426fb0907292338v681057cct86408a8c7478d15e@mail.gmail.com>
In-Reply-To: <ae5426fb0907292338v681057cct86408a8c7478d15e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Rami Rosen wrote:
> Hi,
> This patch removes an unused union definition (sctp_cmsg_data_t)
> from include/net/sctp/user.h.
>
> Regards,
> Rami Rosen
>
>
> Signed-off-by: Rami Rosen <rosenrami@gmail.com>
>   

sctp_cmsg_data_t  is not used by kernel source code, but it still used
by lksctp-tools.



