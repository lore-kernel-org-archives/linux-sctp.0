From: David Miller <davem@davemloft.net>
Date: Tue, 29 Sep 2015 04:03:57 +0000
Subject: Re: [PATCH net 0/2] sctp: Fix SCTP deadlock
Message-Id: <20150928.210357.1723865763239680947.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1443111307-16503-1-git-send-email-kheiss@gmail.com>
In-Reply-To: <1443111307-16503-1-git-send-email-kheiss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kheiss@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Karl Heiss <kheiss@gmail.com>
Date: Thu, 24 Sep 2015 12:15:05 -0400

> These patches fix a deadlock during accept() of an SCTP connection.
> 
> The first patch fixes whitespace issues.
> 
> The second patch actually fixes the deadlock race.

Seems reasonable, series applied, thanks.
