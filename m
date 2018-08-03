From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 03 Aug 2018 23:36:26 +0000
Subject: Re: [PATCH v2 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <20180803233626.GI5482@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724173647.GA8881@localhost.localdomain>
 <20180803162102.19540-1-khorenko@virtuozzo.com>
In-Reply-To: <20180803162102.19540-1-khorenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: oleg.babin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On Fri, Aug 03, 2018 at 07:21:00PM +0300, Konstantin Khorenko wrote:
...
> Performance results:
> ==========
>   * Kernel: v4.18-rc6 - stock and with 2 patches from Oleg (earlier in this thread)
>   * Node: CPU (8 cores): Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
>           RAM: 32 Gb
> 
>   * netperf: taken from https://github.com/HewlettPackard/netperf.git,
> 	     compiled from sources with sctp support
>   * netperf server and client are run on the same node
>   * ip link set lo mtu 1500
> 
> The script used to run tests:
>  # cat run_tests.sh
>  #!/bin/bash
> 
> for test in SCTP_STREAM SCTP_STREAM_MANY SCTP_RR SCTP_RR_MANY; do
>   echo "TEST: $test";
>   for i in `seq 1 3`; do
>     echo "Iteration: $i";
>     set -x
>     netperf -t $test -H localhost -p 22222 -S 200000,200000 -s 200000,200000 \
>             -l 60 -- -m 1452;
>     set +x
>   done
> done
> ========================
> 
> Results (a bit reformatted to be more readable):
...

Nice, good numbers.

I'm missing some test that actually uses more than 1 stream. All tests
in netperf uses only 1 stream. They can use 1 or Many associations on
a socket, but not multiple streams. That means the numbers here show
that we shouldn't see any regression on the more traditional uses, per
Michael's reply on the other email, but it is not testing how it will
behave if we go crazy and use the 64k streams (worst case).

You'll need some other tool to test it. One idea is sctp_test, from
lksctp-tools. Something like:

Server side: 
	./sctp_test -H 172.0.0.1 -P 22222 -l -d 0
Client side: 
	time ./sctp_test -H 172.0.0.1 -P 22221 \
		-h 172.0.0.1 -p 22222 -s \
		-c 1 -M 65535 -T -t 1 -x 100000 -d 0

And then measure the difference on how long each test took. Can you
get these too?

Interesting that in my laptop just to start this test for the first
time can took some *seconds*. Seems kernel had a hard time
defragmenting the memory here. :)

Thanks,
Marcelo
