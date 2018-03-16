From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 16 Mar 2018 19:05:59 +0000
Subject: Re: SCTP abort with T-bit set after handshake
Message-Id: <20180316190559.GA2405@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
In-Reply-To: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Mar 16, 2018 at 02:36:14PM -0300, Marcelo Ricardo Leitner wrote:
> On Fri, Mar 16, 2018 at 03:54:49PM +0000, David Neil wrote:
> > Marcelo,
> > Thanks for the quick response.
> > 
> > The output of uname -a is:
> > Linux li1074-63 4.15.7-x86_64-linode102 #1 SMP Wed Feb 28 16:39:31 UTC 2018 x86_64 GNU/Linux
> 
> Nice, a very updated one.
> 
> > 
> > This is a Linode pre-built Debian 9 kernel with CONFIG_DYNAMIC_DEBUG not set.
> 
> If it's off than that code isn't there, meaning we can't attach a perf
> probe or so. The function is also inlined, so we can't attach to its
> return point.
> 
We could write an system tap script to trace an inline function, no?  

Neil

