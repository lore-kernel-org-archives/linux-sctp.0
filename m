From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 10 Oct 2014 22:02:31 +0000
Subject: Re: [PATCH net 2/3] net: sctp: fix panic on duplicate ASCONF chunks
Message-Id: <54385777.7090907@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1412888133-833-1-git-send-email-dborkman@redhat.com> <1412888133-833-3-git-send-email-dborkman@redhat.com> <20141010153954.GE19499@hmsreliant.think-freely.org>
In-Reply-To: <20141010153954.GE19499@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>

On 10/10/2014 05:39 PM, Neil Horman wrote:
...
> Is it worth adding a WARN_ON, to indicate that two ASCONF chunks have been
> received with duplicate serials?

Don't think so, as this would be triggerable from outside.

Thanks,
Daniel
