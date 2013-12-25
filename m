From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 25 Dec 2013 01:14:31 +0000
Subject: Re: [RFC PATCH 3/3] net: sctp: use sk_copy_sanitize for accept sockets
Message-Id: <52BA3177.5030503@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387891183-21169-4-git-send-email-dborkman@redhat.com>
In-Reply-To: <1387891183-21169-4-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/24/2013 02:19 PM, Daniel Borkmann wrote:
> Wang reported an issue that lksctp's test_getname_v6 seems to fail.
>
> The issue is that we do not copy sk_v6_rcv_saddr over to the new
> socket, although the comment above says so regarding rcv_saddr.
>
> Commit 914e1c8b6980 ("sctp: Inherit all socket options from parent
> correctly.") originally moved that over to sctp_copy_sock(), but
> after commit efe4208f47f9 ("ipv6: make lookups simpler and faster")
> this no longer holds and the actual value of sk_v6_rcv_saddr was
> no longer being migrated.
>
> The issue seems to be deeper than that though. We always used to
> do a partial copy of socket members in accept/peeloff case. This
> means that also newly added members to the kernel's socket
> representation weren't inherited to spawned sockets, for example,
> Eric points out that settings of SO_MAX_PACING_RATE would be broken
> on SCTP as well.
>
> So lets get rid of this restriction by using sk_copy_sanitize().
> With this patch, the lksctp test suite also passes again for IPv6.
>
> Fixes: efe4208f47f9 ("ipv6: make lookups simpler and faster")
> Reported-by: Wang Weidong <wangweidong1@huawei.com>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Not-yet-signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---

One more thing for the non-RFC later on:

>   out:
> +	if (newsk) {
> +		bh_unlock_sock(newsk);
> +		sock_put(newsk);

This also needs to be done in error path.

> +	}
>   	return newsk;
>   }
