From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 06 Nov 2013 14:35:40 +0000
Subject: Re: Problem gettting lksctp-tools 1.0.15 func_tests to work on CentOS 6.4
Message-Id: <527A53BC.8050207@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <023d1910869240e5be263d397c83042f@LWLEXCHMBX01.olympus.F5Net.com>
In-Reply-To: <023d1910869240e5be263d397c83042f@LWLEXCHMBX01.olympus.F5Net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 11/06/2013 03:16 PM, Jeff Carter wrote:
> I've installed lksctp-tools-1.0.15 on a CentOS 6.4 system with the following kernel:
>
> Linux version 2.6.32-358.6.1.el6.x86_64 (mockbuild@c6b9.bsys.dev.centos.org) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-3) (GCC) ) #1 SMP Tue Apr 23 19:29:00 UTC 2013
>
> When I attempt to build/run the v4test, I get failures in test_sockopt, test_tcp_style, test_1_to_1_send, and test_1_to_1_sendmsg.

Which errors concretely?

> Also, a "successful" run of the test suite results in the kernel logging these messages:
>
> Nov  6 05:49:16 kernel: SCTP: Use of int in maxseg socket option deprecated
> Nov  6 05:49:16 kernel: SCTP: Use struct sctp_assoc_value instead
>
> All the failing tests report "BROK : bind: Address already in use". With test_sockopt, it is at step 5. It appears that it is trying to set up a new set of client/server sockets immediately after closing the sockets from the previous test, but using the same IP/port.

Yep, there's an upstream fix that you are missing:

commit 8c98653f05534acd1cb07ea4929702a3659177d1
Author: Daniel Borkmann <dborkman@redhat.com>
Date:   Fri Feb 1 04:37:43 2013 +0000

     sctp: sctp_close: fix release of bindings for deferred call_rcu's

> Is the correct change more likely to be adding SO_REUSEADDR, or moving each test to its own set of ports?
>
> Jeff Carter
