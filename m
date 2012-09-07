From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Fri, 07 Sep 2012 13:55:56 +0000
Subject: [PATCH RFC net-next 0/2] Take care of xfrm policy when checking dst entries
Message-Id: <1347033467-3757-1-git-send-email-nicolas.dichtel@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5049FAE3.2050403@6wind.com>
In-Reply-To: <5049FAE3.2050403@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, davem@davemloft.net
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

The goal of these patches is to fix the following problem: a session is
established (TCP, SCTP) and after a new policy is inserted. The current
code does not recalculate the route, thus the traffic is not encrypted.

The patch propose to check flow_cache_genid value when checking a dst
entry, which is incremented each time a policy is inserted or deleted.

Patches are tested with TCP and SCTP.

Comments are welcome.

Regards,
Nicolas
