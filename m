From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 22 Oct 2008 02:08:43 +0000
Subject: [PATCH] sctp: rfc conformance fixes
Message-Id: <1224641327-11913-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Hi David

The following series is a set of conformance fixes from Wei Yongjun.
One of them addresses a small bug in pmtu process, and the other three
make the shutdown process conform to the latest spec.

Please apply.

Thanks
-vlad
