From: Thomas Graf <tgraf@infradead.org>
Date: Thu, 30 Jun 2011 16:19:38 +0000
Subject: Re: [PATCH] sctp: ABORT if receive queue is not empty while closing
Message-Id: <20110630161938.GD24074@canuck.infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110629135704.GB10085@canuck.infradead.org>
 <4E0B3491.1060603@hp.com>
 <20110629143649.GC10085@canuck.infradead.org>
 <4E0B3DA1.9060200@hp.com>
 <20110629154814.GD10085@canuck.infradead.org>
 <4E0B4F71.4020108@hp.com>
 <20110630133122.GB24074@canuck.infradead.org>
 <4E0C83FA.2090909@hp.com>
In-Reply-To: <4E0C83FA.2090909@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vladislav.yasevich@hp.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, Wei Yongjun <yjwei@cn.fujitsu.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org

On Thu, Jun 30, 2011 at 10:11:06AM -0400, Vladislav Yasevich wrote:
> On 06/30/2011 09:31 AM, Thomas Graf wrote:
> > On Wed, Jun 29, 2011 at 12:14:41PM -0400, Vladislav Yasevich wrote:
> >> Right.  The lack of ABORT from the receive of data is a bug.  I was trying to point out
> >> that instead of modified the sender of data to send the ABORT, you modify the receiver
> >> to send the ABORT when it is being closed while having data queued.
> > 
> > Is this what you had in mind?
> 
> Almost.  It could really be a simple true/false condition about recvqueue or inqueue
> being non-empty.  If that's the case, trigger abort.

What would be the advantage of that?
