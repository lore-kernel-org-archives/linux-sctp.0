From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sat, 20 Dec 2008 01:47:46 +0000
Subject: [PATCH net-next 0/5]: SCTP updates
Message-Id: <1229737672-28328-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org

Hi David

The following series is set of updates for net-next.  It is primarily
new API and cleanups.  However patch 04/05 (Avoid memory overflow while
FWD-TSN chunk is received with bad stream ID) probably needs to be pushed
to stable.

Please apply.  If you want me to respin 04/05 against net-2.6, let me know.

Thanks
-vlad
