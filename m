From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Mon, 14 Apr 2014 17:10:24 +0000
Subject: RE: Is SCTP throughput really this low compared to TCP?
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E31D8BD@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This particular branch of the email thread(s) is now defunct: as per Daniel Borkmann the offending code was narrowed down to the following patch:

git revert ef2820a735f74ea60335f8ba3801b844f0cb184d

With this patch reverted, 3.14.0 SCTP+IPv4 performance is back to normal and working properly.

See other branch of this thread for details.



-----Original Message-----
From: Butler, Peter 
Sent: April-14-14 11:50 AM
To: Vlad Yasevich; Daniel Borkmann
Cc: linux-sctp@vger.kernel.org
Subject: RE: Is SCTP throughput really this low compared to TCP?

Here are some perf numbers.  Note that these were obtained with operf/opreport.  Only the top 20 or so lines are shown here.

Identical load test performed on 3.4.2 and 3.14.

3.4.2:

CPU: Intel Core/i7, speed 2.134e+06 MHz (estimated) Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  cumulative samples  %        cumulative %     linenr info                 image name               symbol name
130002   130002         4.9435   4.9435    copy_user_64.S:240          vmlinux                  copy_user_generic_string
125955   255957         4.7896   9.7330    memcpy_64.S:59              vmlinux                  memcpy
71026    326983         2.7008  12.4339    spinlock.c:136              vmlinux                  _raw_spin_lock
57138    384121         2.1727  14.6066    slub.c:409                  vmlinux                  cmpxchg_double_slab
56559    440680         2.1507  16.7573    slub.c:2208                 vmlinux                  __slab_alloc
53058    493738         2.0176  18.7749    ixgbe_main.c:2952           ixgbe.ko                 ixgbe_poll
51541    545279         1.9599  20.7348    slub.c:2439                 vmlinux                  __slab_free
49916    595195         1.8981  22.6329    ip_tables.c:294             vmlinux                  ipt_do_table
42406    637601         1.6125  24.2455    ixgbe_main.c:7824           ixgbe.ko                 ixgbe_xmit_frame_ring
40929    678530         1.5564  25.8018    slub.c:3463                 vmlinux                  kfree
40349    718879         1.5343  27.3361    core.c:132                  vmlinux                  nf_iterate
35521    754400         1.3507  28.6869    output.c:347                sctp.ko                  sctp_packet_transmit
34071    788471         1.2956  29.9825    outqueue.c:1342             sctp.ko                  sctp_check_transmitted
33962    822433         1.2914  31.2739    slub.c:2601                 vmlinux                  kmem_cache_free
33450    855883         1.2720  32.5459    outqueue.c:735              sctp.ko                  sctp_outq_flush
33005    888888         1.2551  33.8009    skbuff.c:172                vmlinux                  __alloc_skb
29231    918119         1.1115  34.9125    socket.c:1565               sctp.ko                  sctp_sendmsg
27950    946069         1.0628  35.9753    (no location information)   libc-2.14.90.so          __memmove_ssse3_back
26718    972787         1.0160  36.9913    (no location information)   nf_conntrack.ko          nf_conntrack_in
26589    999376         1.0111  38.0023    slub.c:4049                 vmlinux                  __kmalloc_node_track_caller
26449    1025825        1.0058  39.0081    slub.c:2375                 vmlinux                  kmem_cache_alloc
26211    1052036        0.9967  40.0048    sm_sideeffect.c:1074        sctp.ko                  sctp_do_sm
25527    1077563        0.9707  40.9755    slub.c:2404                 vmlinux                  kmem_cache_alloc_node
23970    1101533        0.9115  41.8870    (no location information)   libc-2.14.90.so          _int_free
23266    1124799        0.8847  42.7717    memset_64.S:62              vmlinux                  memset
22976    1147775        0.8737  43.6454    (no location information)   nf_conntrack.ko          hash_conntrack_raw
21855    1169630        0.8311  44.4764    chunk.c:175                 sctp.ko                  sctp_datamsg_from_user
21730    1191360        0.8263  45.3027    list_debug.c:24             vmlinux                  __list_add
21252    1212612        0.8081  46.1109    dev.c:3151                  vmlinux                  __netif_receive_skb
20742    1233354        0.7887  46.8996    (no location information)   libc-2.14.90.so          _int_malloc
19955    1253309        0.7588  47.6584    input.c:130                 sctp.ko                  sctp_rcv



3.14:

CPU: Intel Core/i7, speed 2.134e+06 MHz (estimated) Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  cumulative samples  %        cumulative %     linenr info                 image name               symbol name
168021   168021         6.1446   6.1446    copy_user_64.S:183          vmlinux-3.14.0           copy_user_generic_string
85199    253220         3.1158   9.2604    memcpy_64.S:59              vmlinux-3.14.0           memcpy
80133    333353         2.9305  12.1909    spinlock.c:174              vmlinux-3.14.0           _raw_spin_lock_bh
74086    407439         2.7094  14.9003    spinlock.c:150              vmlinux-3.14.0           _raw_spin_lock
51878    459317         1.8972  16.7975    ixgbe_main.c:6930           ixgbe.ko                 ixgbe_xmit_frame_ring
49354    508671         1.8049  18.6024    slub.c:2538                 vmlinux-3.14.0           __slab_free
39103    547774         1.4300  20.0324    outqueue.c:706              sctp.ko                  sctp_outq_flush
37775    585549         1.3815  21.4139    outqueue.c:1304             sctp.ko                  sctp_check_transmitted
37514    623063         1.3719  22.7858    output.c:380                sctp.ko                  sctp_packet_transmit
37320    660383         1.3648  24.1506    slub.c:2700                 vmlinux-3.14.0           kmem_cache_free
36147    696530         1.3219  25.4725    ip_tables.c:294             vmlinux-3.14.0           ipt_do_table
35494    732024         1.2980  26.7705    sm_sideeffect.c:1100        sctp.ko                  sctp_do_sm
35452    767476         1.2965  28.0670    core.c:135                  vmlinux-3.14.0           nf_iterate
34697    802173         1.2689  29.3359    slub.c:2281                 vmlinux-3.14.0           __slab_alloc
33890    836063         1.2394  30.5753    slub.c:415                  vmlinux-3.14.0           cmpxchg_double_slab
33566    869629         1.2275  31.8028    (no location information)   libc-2.14.90.so          _int_free
33228    902857         1.2152  33.0180    socket.c:1590               sctp.ko                  sctp_sendmsg
32774    935631         1.1986  34.2166    slub.c:3381                 vmlinux-3.14.0           kfree
30359    965990         1.1102  35.3268    (no location information)   libc-2.14.90.so          __memmove_ssse3_back
28905    994895         1.0571  36.3839    list_debug.c:25             vmlinux-3.14.0           __list_add
25888    1020783        0.9467  37.3306    skbuff.c:199                vmlinux-3.14.0           __alloc_skb
25490    1046273        0.9322  38.2628    fib_trie.c:1399             vmlinux-3.14.0           fib_table_lookup
25232    1071505        0.9227  39.1856    nf_conntrack_core.c:376     nf_conntrack.ko          __nf_conntrack_find_get
24114    1095619        0.8819  40.0674    chunk.c:168                 sctp.ko                  sctp_datamsg_from_user
24067    1119686        0.8801  40.9476    ixgbe_main.c:2020           ixgbe.ko                 ixgbe_clean_rx_irq
23972    1143658        0.8767  41.8242    (no location information)   libc-2.14.90.so          _int_malloc
22117    1165775        0.8088  42.6331    ip_output.c:215             vmlinux-3.14.0           ip_finish_output
22037    1187812        0.8059  43.4390    slub.c:3854                 vmlinux-3.14.0           __kmalloc_node_track_caller
21847    1209659        0.7990  44.2379    dev.c:2546                  vmlinux-3.14.0           dev_hard_start_xmit
21564    1231223        0.7886  45.0265    slub.c:2481                 vmlinux-3.14.0           kmem_cache_alloc
20659    1251882        0.7555  45.7820    socket.c:2049               sctp.ko                  sctp_recvmsg







-----Original Message-----
From: Vlad Yasevich [mailto:vyasevich@gmail.com]
Sent: April-11-14 11:28 AM
To: Butler, Peter; Daniel Borkmann
Cc: linux-sctp@vger.kernel.org
Subject: Re: Is SCTP throughput really this low compared to TCP?

On 04/11/2014 11:07 AM, Butler, Peter wrote:
> Yes indeed this is ixgbe and I do have SCTP checksum offloading 
> enabled.  (For what it's worth, the checksum offload gives about a 20% 
> throughput gain - but this is, of course, already included in the 
> numbers I posted to this thread as I've been using the CRC offload all
> along.)
> 
> I re-did all the tests with TSO/GSO/LRO/GRO disabled (on both sides of the association - i.e. on both endpoint nodes), and using 1452-byte messages instead of 1000-byte messages.  With this new setup, the TCP performance drops significantly, as expected, while the SCTP performance is boosted, and the playing field is somewhat more 'level'.   (Note that I could not use 1464-byte messages as suggested by Vlad, as anything above 1452 cut the SCTP performance in half - must have hit the segmentation limit at this slightly lower message size.  MTU is 1500.)
> 
> So comparing "apples to apples" now, TCP only out-performs SCTP by approximately 40-70% over the various range of network latencies I tested with (RTTs of 0.2 ms, 10 ms, 20 ms, and 50 ms).  40-70% is still significant, but nowhere near the 200% better (i.e. 3 times the throughput) I was getting before.
> 
> Does this value (i.e. 40-70%) sound reasonable? 

This still looks high.  Could you run 'perf record -a' and 'perf report'
to see where we are spending all of our time in sctp.

My guess is that a lot of it is going to be in memcpy(), but I am curious.

> Is this the more-or-less accepted performance difference with the current LKSCTP implementation?
> 
> Also, for what it's worth, I get better SCTP throughput numbers with the older kernel (3.4.2) than with the newer kernel (3.14)...
> 

That's interesting.  I'll have to look at see what might have changed here.

-vlad

> 
> 
> -----Original Message-----
> From: Daniel Borkmann [mailto:dborkman@redhat.com]
> Sent: April-11-14 3:43 AM
> To: Vlad Yasevich
> Cc: Butler, Peter; linux-sctp@vger.kernel.org
> Subject: Re: Is SCTP throughput really this low compared to TCP?
> 
> Hi Peter,
> 
> On 04/10/2014 10:21 PM, Vlad Yasevich wrote:
>> On 04/10/2014 03:12 PM, Butler, Peter wrote:
>>> I've been testing SCTP throughput between two nodes over a 10Gb-Ethernet backplane, and am finding that at best, its throughput is about a third of that of TCP.  Is this number generally accepted for current LKSCTP performance?
>>>
>>> All TCP/SCTP tests performed with 1000-byte (payload) messages, between 8-core Xeon nodes @ 2.13GHz, with no CPU throttling (always running at 100%) on otherwise idle systems.  Test applications include netperf, iperf and proprietary in-house stubs.
>>>
>>> The latency between nodes is generally 0.2 ms.  Tests were run using this low-latency scenario, as well as using traffic control (tc) to simulate networks with 10 ms, 20 ms and 50 ms latency (i.e. 20 ms, 40 ms and 100 ms RTT, respectively).
>>>
>>> In addition, each of these network scenarios were tested using various kernel socket buffer sizes, ranging from the default kernel size (100-200 kB), to several MB for send and receive buffers, and multiple send:receive ratios for these buffer sizes (generally using larger receive buffer sizes, up to a factor of about 6).
>>>
>>> Finally, tests were performed on kernels as old as 3.4.2 and as recent as 3.14.
>>>
>>> The TCP throughput is about 3x higher than that of SCTP as a best-case scenario (i.e. from an SCTP perspective), and much higher still in worst-case scenarios.
>>
>> To do a more of apples-to-apples comparison, you need to disable 
>> tso/gso on the sending node.
>>
>> The reason is that even if you limit buffer sizes, tcp will still try 
>> to do tso on the transmit size, thus coalescing you 1000-byte 
>> messages into something much larger, thus utilizing your MTU much more efficiently.
>>
>> SCTP, on the other hand, has to preserve message boundaries which 
>> results in sub-optimal mtu utilization when using 1000-byte payloads.
>>
>> My recommendation is to use 1464 byte message for SCTP on a 1500 byte 
>> MTU nic.
>>
>> I would be interested to see the results.  There could very well be issues.
> 
> Agreed.
> 
> Also, what NIC are you using? It seems only Intel provides SCTP checksum offloading so far, i.e. ixgbe/i40e NICs.
> 
>> -vlad

