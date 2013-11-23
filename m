From: Chang <changxiangzhong@gmail.com>
Date: Sat, 23 Nov 2013 11:14:12 +0000
Subject: Re: [PATCH] net: sctp: set chunk->tsn_gap_acked at the end of cycle
Message-Id: <52908E04.40200@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1385106589-402-1-git-send-email-changxiangzhong@gmail.com> <528F69B7.7020902@gmail.com> <528FAF50.10100@gmail.com> <528FDF52.4030500@gmail.com>
In-Reply-To: <528FDF52.4030500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, nhorman@tuxdriver.com, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,
Could you please why a **reneged** newly acked TSN doesn't qualify the 
highest_new_tsn? What's the wrongs of doing that?

I've been thinking a few scenarios, but I couldn't figure out what's 
wrong with that.

