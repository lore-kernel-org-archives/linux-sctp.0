From: Neil Horman <nhorman@tuxdriver.com>
Date: Sun, 12 Oct 2014 01:42:33 +0000
Subject: Re: [PATCH net 2/3] net: sctp: fix panic on duplicate ASCONF chunks
Message-Id: <20141012014233.GA16360@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1412888133-833-1-git-send-email-dborkman@redhat.com>
 <1412888133-833-3-git-send-email-dborkman@redhat.com>
 <20141010153954.GE19499@hmsreliant.think-freely.org>
 <54385777.7090907@redhat.com>
In-Reply-To: <54385777.7090907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>

On Sat, Oct 11, 2014 at 12:02:31AM +0200, Daniel Borkmann wrote:
> On 10/10/2014 05:39 PM, Neil Horman wrote:
> ...
> >Is it worth adding a WARN_ON, to indicate that two ASCONF chunks have been
> >received with duplicate serials?
> 
> Don't think so, as this would be triggerable from outside.
> 
WARN_ON_ONCE then, per serial number?
Neil

> Thanks,
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
