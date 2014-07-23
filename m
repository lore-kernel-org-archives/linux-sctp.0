From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Wed, 23 Jul 2014 17:22:14 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140723172214.GA11270@obsidianresearch.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jul 21, 2014 at 07:15:45AM -0400, Neil Horman wrote:

> ok, I've looked at this over the weekend, and for the most part I think it looks
> ok.  Regarding your questions, I think sctp_id2transport is ok as it is, since
> that path is used for both ipv4 and ipv6, making unconditional promotion a bad
> idea.  Calling the addr_map method lets us choose the v4 mapping function
> (empty), or the v6 mapping function, which only does a map if a v4 address is
> passed in.

Well, v4mapped should only change the presentation of addresses being
returned by syscalls, it should never change the internal behavior of
SCTP.

Hrm.. So sctp_id2transport has this as a trailing call:

	sctp_get_pf_specific(sk->sk_family)->addr_v4map(sctp_sk(sk),
						(union sctp_addr
						*)addr);

Thus it does not alter the operation of sctp_id2transport in any way,
it just changes the presentation of the address for the caller.. So
that is good.

Going through the callers:

sctp_getsockopt_peer_addr_params -
sctp_getsockopt_peer_addr_info -
sctp_getsockopt_peer_addr_params -
sctp_getsockopt_paddr_thresholds
   The address is copied back to user space after the call
   completes

sctp_setsockopt_peer_addr_params -
sctp_setsockopt_primary_addr -
sctp_setsockopt_paddr_thresholds -
  The address is never used again

Basically, if you do a getsockopt with an address then the structure
return'd by the kernel will be passed through addr_v4map.

It is a bit odd that the kernel transforms an input argument when
copying to output, but that doesn't necessarily seem bad...

> And I don't think we need to do any demotion of addresses as sctp_v6_addr_v4map
> is only called if the socket is AF_INET6, and can handle v6 addresses
> transparently.  If the socket was created as AF_INET, we're safe, because that
> will reject AF_INET6 addresses anyway.

sctp_v6_addr_v4map appears to be called on every sockaddr before
returning it to user space. 

So the job of sctp_v6_addr_v4map is to enforce the v4mapped behavior:
 - If v4mapped is set all returns from the kernel should be AF_INET6
 - If v4mapped is unset, all IPv4 addresses should be AF_INET, a V6
   mapped should never be returned.

Right now it only promotes AF_INET to AF_INET6, it doesn't demote
AF_INET6 v4mapped back to AF_INET.

So the question is if v4mapped AF_INET6 addresses can exist inside the
kernel. If yes, we need to demote them in sctp_v6_addr_v4map for
correct presentation to userspace.

Unless you know the design is to keep v4 as AF_INET, then I'm thinking
for robustness it should just demote. Then we know the user API is
going to work properly no matter what changes are made to the
internals.

> If you're testing in the interviening week hasn't shown any further problems,
> I'd say officially post this with my signed off please.

I'll try to get a few mins to verify the above for sctp_v6_addr_v4map
and post the result.

Thanks,
Jason
