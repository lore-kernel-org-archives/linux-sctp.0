From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Tue, 11 Sep 2012 08:09:43 +0000
Subject: [PATCH net-next v3 0/4] Take care of xfrm policy when checking dst entries
Message-Id: <1347350987-8054-1-git-send-email-nicolas.dichtel@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <504DFF90.3010802@6wind.com>
In-Reply-To: <504DFF90.3010802@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, davem@davemloft.net, eric.dumazet@gmail.com, sds@tycho.nsa.gov, james.l.morris@oracle.com, eparis@parisplace.org
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

The goal of these patches is to fix the following problem: a session is
established (TCP, SCTP) and after a new policy is inserted. The current
code does not recalculate the route, thus the traffic is not encrypted.

The patch propose to check flow_cache_genid value when checking a dst
entry, which is incremented each time a policy is inserted or deleted.

v2: use net->ipv4.rt_genid instead of flow_cache_genid (and thus save a test
    in fast path). Also move it to net->rt_genid, to be able to use it for IPv6
    too. Note that IPv6 will have one more test in fast path.

v3: remove unrelated "#ifdef CONFIG_XFRM" in IPv6 part
    bump rt_genid in selinux code (same place than flow_cache_genid)

Patches are tested with TCP and SCTP, IPv4 and IPv6.

Comments are welcome.

Regards,
Nicolas

