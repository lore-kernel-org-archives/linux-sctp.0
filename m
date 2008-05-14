From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Date: Wed, 14 May 2008 08:47:57 +0000
Subject: retrans path update problem
Message-Id: <482AA73D.5000507@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

hello everybody,
When updating retrans path(asoc->peer.retran_path), should 
we update the retran path to another transport even if only the 
original retrans path is active?
In the other words, i think, retrans path should always be 
changed if there are more than one transport in an association.

Am i right?
-- 
Regards
Gui Jianfeng

