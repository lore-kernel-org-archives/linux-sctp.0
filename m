From: David Miller <davem@davemloft.net>
Date: Tue, 03 Mar 2009 06:29:01 +0000
Subject: Re: [PATCH 1/2] sctp: fix crash during module unload
Message-Id: <20090302.222901.66420231.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1236012411-17841-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1236012411-17841-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon,  2 Mar 2009 11:46:50 -0500

> An extra list_del() during the module load failure and unload
> resulted in a crash with a list corruption.  Now sctp can
> be unloaded again.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
