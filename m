From: Thomas Graf <tgraf@infradead.org>
Date: Fri, 08 Jul 2011 14:29:40 +0000
Subject: Re: [PATCHv2] sctp: ABORT if receive queue is not empty while
Message-Id: <20110708142940.GA24249@canuck.infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110629135704.GB10085@canuck.infradead.org>
 <4E0B3491.1060603@hp.com>
 <20110629143649.GC10085@canuck.infradead.org>
 <4E0B3DA1.9060200@hp.com>
 <20110629154814.GD10085@canuck.infradead.org>
 <4E0B4F71.4020108@hp.com>
 <20110630133122.GB24074@canuck.infradead.org>
 <4E0C83FA.2090909@hp.com>
 <20110708105705.GA14583@canuck.infradead.org>
 <4E170B00.9080406@hp.com>
In-Reply-To: <4E170B00.9080406@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vladislav.yasevich@hp.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, Wei Yongjun <yjwei@cn.fujitsu.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org

On Fri, Jul 08, 2011 at 09:49:52AM -0400, Vladislav Yasevich wrote:
> On 07/08/2011 06:57 AM, Thomas Graf wrote:
> > Trigger user ABORT if application closes a socket which has data
> > queued on the socket receive queue as this would imply data being
> > lost which defeats the point of a graceful shutdown.
> > 
> > This behavior is already practiced in TCP.
> > 
> > We do not check the input queue because that would mean to parse
> > all chunks on it to look for unacknowledged data which seems too
> > much of an effort. Control chunks or duplicated chunks may also
> > be in the input queue and should not be stopping a graceful
> > shutdown.
> 
> I think you need to check the ulpq as well.
> 
> It is possible to have a condition where you only have data
> in the ulpq (imagine a few lost out of order packets or a few lost
> fragments from very large messages).  In those circumstances, either fragmentation
> or ordering queues may consume all of the window (especially if the buffer was
> set small) and you would never trigger the abort.

Good point. Updating the patch.
