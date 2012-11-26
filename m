From: David Miller <davem@davemloft.net>
Date: Mon, 26 Nov 2012 22:34:29 +0000
Subject: Re: [PATCH] sctp: fix memory leak in sctp_datamsg_from_user() when copy from user space fails
Message-Id: <20121126.173429.323283427379416132.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1353590491-12166-1-git-send-email-tt.rantala@gmail.com>
	<50B38235.6070908@gmail.com>
In-Reply-To: <50B38235.6070908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: tt.rantala@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, sri@us.ibm.com, davej@redhat.com

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 26 Nov 2012 09:52:37 -0500

> Should be using sctp_chunk_free().  Good find.

Tommi, please respin your patch to use sctp_chunk_free() as
Vlad has asked.

Thanks.
