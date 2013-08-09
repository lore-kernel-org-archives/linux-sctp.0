From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 09 Aug 2013 10:33:07 +0000
Subject: Re: [PATCH net] net: sctp: sctp_transport_destroy{,_rcu}: fix potential pointer corruption
Message-Id: <5204C563.5030808@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1376042849-19732-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1376042849-19732-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 08/09/2013 12:07 PM, Daniel Borkmann wrote:
> Probably this one is quite unlikely to be triggered, but it's more safe
> to hold a pointer to asoc and packet (instead of dereferencing) and access
> both though this after we have called sctp_transport_destroy_rcu() where
> the transport is being kfree()'d. Introduced by commit 8c98653f ("sctp:
> sctp_close: fix release of bindings for deferred call_rcu's").
>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Please ignore this, will send an updated v2 in a moment.
