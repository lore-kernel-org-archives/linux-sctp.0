From: David Miller <davem@davemloft.net>
Date: Sun, 18 Mar 2018 00:11:33 +0000
Subject: Re: [PATCH v2] sctp: use proc_remove_subtree()
Message-Id: <20180317.201133.834834488390553522.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180314204621.GY30522@ZenIV.linux.org.uk>
        <20180316233251.GJ30522@ZenIV.linux.org.uk>
In-Reply-To: <20180316233251.GJ30522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro@ZenIV.linux.org.uk
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 16 Mar 2018 23:32:51 +0000

> use proc_remove_subtree() for subtree removal, both on setup failure
> halfway through and on teardown.  No need to make simple things
> complex...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks Al.
