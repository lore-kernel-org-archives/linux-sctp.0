From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 09 Apr 2014 13:34:25 +0000
Subject: Re: [PATCH net v2] net: sctp: test if association is dead in sctp_wake_up_waiters
Message-Id: <53454C61.70007@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <de3e98e644dde7dcaea9a952de38eb32a2959eeb.1396999714.git.dborkman@redhat.com> <5345003B.8080601@redhat.com> <534521D0.7050707@redhat.com> <20140409105908.GC13412@hmsreliant.think-freely.org>
In-Reply-To: <20140409105908.GC13412@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevic@redhat.com>

On 04/09/2014 12:59 PM, Neil Horman wrote:
...
> Both to the patch, and the documentation, as its not at all clear what lock
> protects the reading and writing of the dead variable.

Agreed, I'll send a v3 with an improved commit message to
summarize everything for future reference. Thanks everyone.
