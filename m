From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 09 Apr 2014 08:09:31 +0000
Subject: Re: [PATCH net v2] net: sctp: test if association is dead in sctp_wake_up_waiters
Message-Id: <5345003B.8080601@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <de3e98e644dde7dcaea9a952de38eb32a2959eeb.1396999714.git.dborkman@redhat.com>
In-Reply-To: <de3e98e644dde7dcaea9a952de38eb32a2959eeb.1396999714.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevic@redhat.com>

On 04/09/2014 01:10 AM, Vlad Yasevich wrote:
 > On 04/08/2014 06:23 PM, Daniel Borkmann wrote:
 >> In function sctp_wake_up_waiters() we need to involve a test
 >> if the association is declared dead. If so, we don't have any
 >> reference to a possible sibling association anymore and need
 >> to invoke sctp_write_space() instead and normally walk the
 >> socket's associations and notify them of new wmem space. The
 >> reason for special casing is that, otherwise, we could run
 >> into the following issue:
 >>
 >> sctp_association_free()
 >> `-> list_del(&asoc->asocs)         <-- poisons list pointer
 >>      asoc->base.dead = true
 >>      sctp_outq_free(&asoc->outqueue)
 >>      `-> __sctp_outq_teardown()
 >>       `-> sctp_chunk_free()
 >>        `-> consume_skb()
 >>         `-> sctp_wfree()
 >>          `-> sctp_wake_up_waiters() <-- dereferences poisoned pointers
 >>                                         if asoc->ep->sndbuf_policy=0
 >>
 >> Therefore, only walk the list in an 'optimized' way if we find
 >> that the current association is still active. It's also more
 >> clean in that context to just use list_del_init() when we call
 >> sctp_association_free(). Stress-testing seems fine now.
 >
 > One of the reasons that we don't use list_del_init() here is that
 > we want to be able to trap on uninitialized/corrupt list manipulation,
 > just like you did.  If it wasn't there, the bug would have been hidden.
 >
 > Please keep it there.  The rest of the patch is fine.

Test run over night and I've seen no issues.

But I'd still question the usage of asoc->base.dead though, I think
this approach of testing for asoc->base.dead is a bit racy (perhaps
general usage of it, imho) - at least here there's a tiny window where
we poison pointers before we actually declare the associaton dead.

Also, I think even if we would have deleted ourselves from the list
after declaring the association dead, a different CPU accessing this
association via sctp_wfree() might already have gotten past the
asoc->base.dead test while we declare it dead in the meantime.

Imho, this still needs to be resolved differently. I'll look further ...
