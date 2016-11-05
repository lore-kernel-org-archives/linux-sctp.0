From: "Jonathan T. Leighton" <jtleight@udel.edu>
Date: Sat, 05 Nov 2016 15:15:15 +0000
Subject: Does getaddrinfo() need to be rebuilt for SCTP support?
Message-Id: <7f5c7f15-11c1-13b7-9dd7-76afd51f0c9f@udel.edu>
List-Id: <linux-sctp.vger.kernel.org>
References: <4fc71aa8-655a-de2d-bec2-93fa63f00a17@udel.edu>
In-Reply-To: <4fc71aa8-655a-de2d-bec2-93fa63f00a17@udel.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I've run into some behavior of getaddrinfo() that I think may be 
incorrect. When getaddrinfo() is called with a numeric service argument 
(as opposed to a name), it returns a list of addrinfo structures for 
each protocol that it knows about, without referencing the /etc/services 
database. After installing lksctp I expected this list to include 
IPPROTO_SCTP, but it doesn't. It looks to me like getaddrinfo() is 
actually only returning addrinfo structures for all the protocols that 
is knew about when it was built. Is this the correct behavior? Does 
glibc need to be rebuilt after installing lksctp? Thanks for any help.

- Jon

