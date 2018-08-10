From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Fri, 10 Aug 2018 17:03:51 +0000
Subject: Re: [PATCH v2 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <deb7cbdc-55b9-3ff5-8f13-cfa61e08eebe@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724173647.GA8881@localhost.localdomain>
 <20180803162102.19540-1-khorenko@virtuozzo.com>
 <20180803233626.GI5482@localhost.localdomain>
 <3356eb3e-323f-e28d-62b1-b3bd801bfe6e@virtuozzo.com>
In-Reply-To: <3356eb3e-323f-e28d-62b1-b3bd801bfe6e@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: oleg.babin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On 08/09/2018 11:43 AM, Konstantin Khorenko wrote:
> On 08/04/2018 02:36 AM, Marcelo Ricardo Leitner wrote:
>> On Fri, Aug 03, 2018 at 07:21:00PM +0300, Konstantin Khorenko wrote:
>> ...
>>> Performance results:
>>> ==========
>>>   * Kernel: v4.18-rc6 - stock and with 2 patches from Oleg (earlier in this thread)
>>>   * Node: CPU (8 cores): Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
>>>           RAM: 32 Gb
>>>
>>>   * netperf: taken from https://github.com/HewlettPackard/netperf.git,
>>> 	     compiled from sources with sctp support
>>>   * netperf server and client are run on the same node
>>>   * ip link set lo mtu 1500
>>>
>>> The script used to run tests:
>>>  # cat run_tests.sh
>>>  #!/bin/bash
>>>
>>> for test in SCTP_STREAM SCTP_STREAM_MANY SCTP_RR SCTP_RR_MANY; do
>>>   echo "TEST: $test";
>>>   for i in `seq 1 3`; do
>>>     echo "Iteration: $i";
>>>     set -x
>>>     netperf -t $test -H localhost -p 22222 -S 200000,200000 -s 200000,200000 \
>>>             -l 60 -- -m 1452;
>>>     set +x
>>>   done
>>> done
>>> ========================
>>>
>>> Results (a bit reformatted to be more readable):
>> ...
>>
>> Nice, good numbers.
>>
>> I'm missing some test that actually uses more than 1 stream. All tests
>> in netperf uses only 1 stream. They can use 1 or Many associations on
>> a socket, but not multiple streams. That means the numbers here show
>> that we shouldn't see any regression on the more traditional uses, per
>> Michael's reply on the other email, but it is not testing how it will
>> behave if we go crazy and use the 64k streams (worst case).
>>
>> You'll need some other tool to test it. One idea is sctp_test, from
>> lksctp-tools. Something like:
>>
>> Server side:
>> 	./sctp_test -H 172.0.0.1 -P 22222 -l -d 0
>> Client side:
>> 	time ./sctp_test -H 172.0.0.1 -P 22221 \
>> 		-h 172.0.0.1 -p 22222 -s \
>> 		-c 1 -M 65535 -T -t 1 -x 100000 -d 0
>>
>> And then measure the difference on how long each test took. Can you
>> get these too?
>>
>> Interesting that in my laptop just to start this test for the first
>> time can took some *seconds*. Seems kernel had a hard time
>> defragmenting the memory here. :)

Hi Marcelo,

got 3 of 4 results, please take a look, but i failed to measure running
the test on stock kernel when memory is fragmented, test fails with
         *** connect:  Cannot allocate memory ***


Performance results:
==========
   * Kernel: v4.18-rc8 - stock and with 2 patches v3
   * Node: CPU (8 cores): Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
           RAM: 32 Gb

   * sctp_test: https://github.com/sctp/lksctp-tools
   * both server and client are run on the same node
   * ip link set lo mtu 1500
   * sysctl -w vm.max_map_counte530000 (need it to make memory fragmented)

The script used to run tests:
==============# cat run_sctp_test.sh
#!/bin/bash

set -x

uname -r
ip link set lo mtu 1500
swapoff -a

free
cat /proc/buddyinfo

./src/apps/sctp_test -H 127.0.0.1 -P 22222 -l -d 0 &
sleep 3

time ./src/apps/sctp_test -H 127.0.0.1 -P 22221 -h 127.0.0.1 -p 22222 \
         -s -c 1 -M 65535 -T -t 1 -x 100000 -d 0 1>/dev/null

killall -9 lt-sctp_test
===============
Results (a bit reformatted to be more readable):

1) ms stock kernel v4.18-rc8, no memory fragmentation
Info about memory - more or less same to iterations:
# free
               total        used        free      shared  buff/cache   available
Mem:       32906008      213156    32178184         764      514668    32260968
Swap:             0           0           0

cat /proc/buddyinfo
Node 0, zone      DMA      0      1      1      0      2      1      1      0      1      1      3
Node 0, zone    DMA32      1      3      5      4      2      2      3      6      6      4    867
Node 0, zone   Normal    551    422    160    204    193     34     15      7     22     19   6956

	test 1		test 2		test 3
real    0m14.715s	0m14.593s	0m15.954s
user    0m0.954s	0m0.955s	0m0.854s
sys     0m13.388s	0m12.537s	0m13.749s

2) kernel with fixes, no memory fragmentation
'free' and 'buddyinfo' similar to 1)

	test 1		test 2		test 3
real    0m14.959s	0m14.693s	0m14.762s
user    0m0.948s	0m0.921s	0m0.929s
sys     0m13.538s	0m13.225s	0m13.217s

3) kernel with fixes, memory fragmented
(mmap() all available RAM, touch all pages, munmap() half of pages (each second page), do it again for RAM/2)
'free':
               total        used        free      shared  buff/cache   available
Mem:       32906008    30555200      302740         764     2048068      266452
Mem:       32906008    30379948      541436         764     1984624      442376
Mem:       32906008    30717312      262380         764     1926316      109908

/proc/buddyinfo:
Node 0, zone   Normal  40773     37     34     29      0      0      0      0      0      0      0
Node 0, zone   Normal 100332     68      8      4      2      1      1      0      0      0      0
Node 0, zone   Normal  31113      7      2      1      0      0      0      0      0      0      0

	test 1		test 2		test 3
real    0m14.159s	0m15.252s	0m15.826s
user    0m0.839s	0m1.004s	0m1.048s
sys     0m11.827s	0m14.240s	0m14.778s


--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team
