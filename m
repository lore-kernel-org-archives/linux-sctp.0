From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Tue, 05 Jul 2011 02:01:55 +0000
Subject: Re: [PATCH v2 1/2] Update description of net.sctp.sctp_rmem and net.sctp.sctp_wmem
Message-Id: <4E127093.8030504@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110705015723.8B226815DBB1@regina.usersys.redhat.com>
In-Reply-To: <20110705015723.8B226815DBB1@regina.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Max Matveev <makc@redhat.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Max Matveev wrote, at 06/20/2011 04:08 PM:
> sctp does not use second and third ("default" and "max") values
> of sctp_rmem tunable. The format is the same as tcp_rmem
> but the meaning is different so make the documentation explicit to
> avoid confusion.
> 
> sctp_wmem is not used at all.
> 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Max Matveev <makc@redhat.com>

Reviewed-by: Shan Wei <shanwei@cn.fujitsu.com>


-- 
Best Regards
-----
Shan Wei
