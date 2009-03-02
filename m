From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 02 Mar 2009 16:46:49 +0000
Subject: [PATCH 0/2] sctp: Crash fixes.
Message-Id: <1236012411-17841-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <>
In-Reply-To: <>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org


Hi David

There two patches fix crashes in the sctp module.  The module-unload
one is actually a regression from as far back as 2.6.25.

The second one could be classified as a potential security issue.

Thanks
-vlad
