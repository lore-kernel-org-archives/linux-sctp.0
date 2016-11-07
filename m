From: "Jonathan T. Leighton" <jtleight@udel.edu>
Date: Mon, 07 Nov 2016 16:04:11 +0000
Subject: Re: Does getaddrinfo() need to be rebuilt for SCTP support?
Message-Id: <5d034aa5-3a4a-1c4d-de18-1e604d0fdd37@udel.edu>
List-Id: <linux-sctp.vger.kernel.org>
References: <4fc71aa8-655a-de2d-bec2-93fa63f00a17@udel.edu>
In-Reply-To: <4fc71aa8-655a-de2d-bec2-93fa63f00a17@udel.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi David -

Thanks for the response.

On 11/7/16 5:11 AM, David Laight wrote:
> From: Jonathan T. Leighton
>> Sent: 05 November 2016 15:15
>> I've run into some behavior of getaddrinfo() that I think may be
>> incorrect. When getaddrinfo() is called with a numeric service argument
>> (as opposed to a name), it returns a list of addrinfo structures for
>> each protocol that it knows about, without referencing the /etc/services
>> database. After installing lksctp I expected this list to include
>> IPPROTO_SCTP, but it doesn't. It looks to me like getaddrinfo() is
>> actually only returning addrinfo structures for all the protocols that
>> is knew about when it was built. Is this the correct behavior? Does
>> glibc need to be rebuilt after installing lksctp? Thanks for any help.
> What you don't want is programs being given SCTP addresses when they
> don't really want them.

I'm not sure I agree with this. getaddrinfo() can return addrinfo 
structures with IPPROTO_UDP and IPPROTO_IP (in addition to IPPROTO_TCP) 
- assuming that every returned addrinfo structure uses IPPROTO_TCP is a 
problem. Code needs to be able to select among the returned addrinfo 
structures appropriately, and including IPPROTO_SCTP shouldn't break 
such code.

> I've seen problems in the past (not Linux) where programs have tried
> to use addresses on all available protocols when they really just meant
> TCP or UDP.

IMO this is just bad coding.

> I don't think any of the address lookup functions are service specific,
> AA and AAAA records probably aren't even protocol specific (below IP).
>
> So programs that want to use SCTP can lookup TCP and then substitute SCTP
> when they create the socket.

Sure, but this is a hack. On a system with SCTP installed, SCTP 
shouldn't be treated like a second class citizen.

Looking at the getaddrinfo() source shows that it's written to return 
addrinfo structures with IPPROTO_SCTP, but only if it is built on a 
system with SCTP installed. That suggests to me that installing lksctp 
should include replacing glibc with a version that was built with SCTP 
enabled.

- Jon

> 	David
>

