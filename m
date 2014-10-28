From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 28 Oct 2014 10:27:41 +0000
Subject: Re: [net 1/2] sctp: add transport state in /proc/net/sctp/remaddr
Message-Id: <20141028102741.GA18365@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1414093721-14921-1-git-send-email-michele@acksyn.org>
 <20141027.185545.551457974536550723.davem@davemloft.net>
In-Reply-To: <20141027.185545.551457974536550723.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: michele@acksyn.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, netdev@vger.kernel.org, dborkman@redhat.com

On Mon, Oct 27, 2014 at 06:55:45PM -0400, David Miller wrote:
> From: Michele Baldessari <michele@acksyn.org>
> Date: Thu, 23 Oct 2014 21:48:40 +0200
> 
> > It is often quite helpful to be able to know the state of a transport
> > outside of the application itself (for troubleshooting purposes or for
> > monitoring purposes). Add it under /proc/net/sctp/remaddr.
> > 
> > Signed-off-by: Michele Baldessari <michele@acksyn.org>
> 
> You can't change the layout of procfs files, applications parse
> these files and any modification can potentially break such tools.
> 
> Secondly, even if this change were acceptable, targetting this
> change at anything other than the net-next tree is not appropriate
> because it is a new feature.
> 

Agree on the net-next submission, though there is precident for extending this
procfile, as we've done it a few times in the past to this, and other files in
the sctp area (see commits f406c8b9693f2f71ef2caeb0b68521a7d22d00f0 and
58fbbed4fbc0094fc808a568fe99a915f85402ee)

Neil

