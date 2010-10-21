From: Nicolas Kaiser <nikai@nikai.net>
Date: Thu, 21 Oct 2010 13:08:47 +0000
Subject: Re: [PATCH] sctp: remove redundant chunk length check
Message-Id: <20101021150847.3a5f3cb7@absol.kitzblitz>
List-Id: <linux-sctp.vger.kernel.org>
References: <20101021121409.6de7d429@absol.kitzblitz>
	<4CC02CDF.5040700@cn.fujitsu.com>
In-Reply-To: <4CC02CDF.5040700@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

* Shan Wei <shanwei@cn.fujitsu.com>:
> Nicolas Kaiser wrote, at 10/21/2010 06:14 PM:
> > Checking the chunk length at this point appears redundant, as
> > the rest of the packet gets discarded anyway.
 
> Yes, indeed.
> 
> How did you find this? By reviewing the source code?

Actually I'm tinkering with Coccinelle patches.

Here's a simple semantic patch, that will give a lot of false
positives, and a lot of "if (a) return b; return b;":

// <smpl>
@@
expression a;
statement S;
@@

- if (a)
- {
- S
- }
 S
// </smpl>

Best regards,
Nicolas Kaiser
