From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 23 Jul 2008 00:21:50 +0000
Subject: Re: [2.6 patch] remove sctp_assoc_proc_exit()
Message-Id: <4886799E.70505@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080722172057.GU14846@cs181140183.pp.htv.fi>
In-Reply-To: <20080722172057.GU14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Adrian Bunk wrote:
> Commit 20c2c1fd6c842caf70dcb1d94b9d58861949fd3d
> (sctp: add sctp/remaddr table to complete RFC remote address table OID)
> added an unused sctp_assoc_proc_exit() function that seems to have been 
> unintentionally created when copying the assocs code.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
>


Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Thanks Adrian
-vlad
