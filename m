From: David Miller <davem@davemloft.net>
Date: Tue, 11 Jun 2013 09:49:45 +0000
Subject: Re: [PATCH net v2] net: sctp: fix NULL pointer dereference in socket destruction
Message-Id: <20130611.024945.708794798755946342.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1370526827-23882-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1370526827-23882-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu,  6 Jun 2013 15:53:47 +0200

> While stress testing sctp sockets, I hit the following panic:
 ...
> I did not hit this with the lksctp-tools functional tests, but with a
> small, multi-threaded test program, that heavily allocates, binds,
> listens and waits in accept on sctp sockets, and then randomly kills
> some of them (no need for an actual client in this case to hit this).
> Then, again, allocating, binding, etc, and then killing child processes.
> 
> This panic then only occurs when ``echo 1 > /proc/sys/net/sctp/auth_enable''
> is set. The cause for that is actually very simple: in sctp_endpoint_init()
> we enter the path of sctp_auth_init_hmacs(). There, we try to allocate
> our crypto transforms through crypto_alloc_hash(). In our scenario,
> it then can happen that crypto_alloc_hash() fails with -EINTR from
> crypto_larval_wait(), thus we bail out and release the socket via
> sk_common_release(), sctp_destroy_sock() and hit the NULL pointer
> dereference as soon as we try to access members in the endpoint during
> sctp_endpoint_free(), since endpoint at that time is still NULL. Now,
> if we have that case, we do not need to do any cleanup work and just
> leave the destruction handler.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied and queued up for -stable, thanks!
