From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 19 Jun 2008 22:24:39 +0000
Subject: [PATCH net-next] sctp: new functionality
Message-Id: <12139142813418-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi David

The following 2 patch implement aspects of the SCTP spec that have been
missing.

The first one implements the recomendation of validating Verifiation
TAGs carried inside of ICMP messages.

The second implements a security recomendation that prevents some flooding
attacks by only respoding with a single packet.

Thanks
-vlad
