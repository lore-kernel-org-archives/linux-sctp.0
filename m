From: David Miller <davem@davemloft.net>
Date: Fri, 18 Apr 2014 22:41:45 +0000
Subject: Re: [PATCH net] net: sctp: cache auth_enable per endpoint
Message-Id: <20140418.184145.990138802576449617.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1397748410-1983-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1397748410-1983-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: kumba@gentoo.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevic@redhat.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 17 Apr 2014 17:26:50 +0200

> From: Vlad Yasevich <vyasevic@redhat.com>
> 
> Currently, it is possible to create an SCTP socket, then switch
> auth_enable via sysctl setting to 1 and crash the system on connect:
 ...
> What happens while auth_enable=0 in that case is, that
> ep->auth_hmacs is initialized to NULL in sctp_auth_init_hmacs()
> when endpoint is being created.
> 
> After that point, if an admin switches over to auth_enable=1,
> the machine can crash due to NULL pointer dereference during
> reception of an INIT chunk. When we enter sctp_process_init()
> via sctp_sf_do_5_1B_init() in order to respond to an INIT chunk,
> the INIT verification succeeds and while we walk and process
> all INIT params via sctp_process_param() we find that
> net->sctp.auth_enable is set, therefore do not fall through,
> but invoke sctp_auth_asoc_set_default_hmac() instead, and thus,
> dereference what we have set to NULL during endpoint
> initialization phase.
> 
> The fix is to make auth_enable immutable by caching its value
> during endpoint initialization, so that its original value is
> being carried along until destruction. The bug seems to originate
> from the very first days.
> 
> Fix in joint work with Daniel Borkmann.
> 
> Reported-by: Joshua Kinard <kumba@gentoo.org>
> Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied and queued up for -stable, thanks everyone.
