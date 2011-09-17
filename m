From: David Miller <davem@davemloft.net>
Date: Sat, 17 Sep 2011 05:02:08 +0000
Subject: Re: [PATCH] sctp: deal with multiple COOKIE_ECHO chunks
Message-Id: <20110917.010208.1774449645459771823.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110830072010.94AE98132707@regina.usersys.redhat.com>
	<20110916.171747.406895441960738806.davem@davemloft.net>
	<20084.9283.714998.398630@regina.usersys.redhat.com>
In-Reply-To: <20084.9283.714998.398630@regina.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: makc@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vladislav.yasevich@hp.com

From: Max Matveev <makc@redhat.com>
Date: Sat, 17 Sep 2011 14:38:27 +1000

> Sorry about it - I did check it with checkpatch.pl and it was happy:

checkpatch doesn't look thoroughly for these things, use
something like "git apply --check --whitespace=error-all"
for validation instead.
