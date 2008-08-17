From: David Miller <davem@davemloft.net>
Date: Sun, 17 Aug 2008 22:35:26 +0000
Subject: Re: [PATCH 2/2] netns: Add network namespace argument in
Message-Id: <20080817.153526.109132408.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <48A48722.3050509@hp.com>
	<48A758F0.60009@fr.ibm.com>
In-Reply-To: <48A758F0.60009@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dlezcano@fr.ibm.com
Cc: brian.haley@hp.com, containers@lists.osdl.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Lezcano <dlezcano@fr.ibm.com>
Date: Sun, 17 Aug 2008 00:47:12 +0200

> The approach looks correct except with the network namespace passed as 
> parameter, it must never be NULL.

You're reviewing the patches that Brian retracted, we added a different
version of these fixes in the end.
