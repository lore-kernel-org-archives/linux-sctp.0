From: David Miller <davem@davemloft.net>
Date: Fri, 08 Feb 2013 04:45:14 +0000
Subject: Re: [PATCH net 2/2] net: sctp: sctp_auth_key_put: use kzfree instead of kfree
Message-Id: <20130207.234514.1920724559157438386.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360231701.git.dborkman@redhat.com>
	<cover.1360231701.git.dborkman@redhat.com>
	<8c764d916f21d56402a5b9a915ea31d927898da0.1360231701.git.dborkman@redhat.com>
In-Reply-To: <8c764d916f21d56402a5b9a915ea31d927898da0.1360231701.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu,  7 Feb 2013 11:55:37 +0100

> For sensitive data like keying material, it is common practice to zero
> out keys before returning the memory back to the allocator. Thus, use
> kzfree instead of kfree.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied and queued up for -stable.
