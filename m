From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 15 Oct 2014 03:06:32 +0000
Subject: Re: [PATCH net 0/3] SCTP fixes
Message-Id: <20141015030631.GA6778@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1412888133-833-1-git-send-email-dborkman@redhat.com>
 <20141014.124657.128658692728989163.davem@davemloft.net>
In-Reply-To: <20141014.124657.128658692728989163.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: dborkman@redhat.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Tue, Oct 14, 2014 at 12:46:57PM -0400, David Miller wrote:
> From: Daniel Borkmann <dborkman@redhat.com>
> Date: Thu,  9 Oct 2014 22:55:30 +0200
> 
> > Here are some SCTP fixes.
> > 
> > [ Note, immediate workaround would be to disable ASCONF (it
> >   is sysctl disabled by default). It is actually only used
> >   together with chunk authentication. ]
> 
> Series applied, thanks guys.
Why did you apply this Dave? There was ongoing discussion around it.
Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
