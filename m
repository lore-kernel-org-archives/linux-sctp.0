From: David Miller <davem@davemloft.net>
Date: Mon, 28 Mar 2011 01:16:03 +0000
Subject: Re: [PATCH] sctp: Make some local functions static
Message-Id: <20110327.181603.246526652.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D89CFE7.4050907@freyther.de>
In-Reply-To: <4D89CFE7.4050907@freyther.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: holger@freyther.de
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Holger Hans Peter Freyther <holger@freyther.de>
Date: Wed, 23 Mar 2011 11:48:07 +0100

> @@ -132,8 +132,8 @@ void  sctp_init_cause(struct sctp_chunk *chunk, __be16
> cause_code,

Your patches are corrupted by your email client, in particular it has
chopped up long lines.

Please fix your email setup, test it out by emailing both of your SCTP
patches to yourself, then try to apply the patches in the emails you
receive.

Then you can freshly resubmit them here.

Thank you.
