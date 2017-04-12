From: Deepak Khandelwal <dazz.87@gmail.com>
Date: Wed, 12 Apr 2017 14:55:52 +0000
Subject: Re: SCTP performance on 4.4.x Kernel with two instances of iperf3
Message-Id: <CAOci8d+nhHC9q+sHOeEUmoUG5MPY5J_WyUipzDgsi5HsP4iurw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAOci8dL_ab3uQz7tukv21Ski5Ye8C4DX-wQ8v9hA8jW=5_dK6A@mail.gmail.com>
In-Reply-To: <CAOci8dL_ab3uQz7tukv21Ski5Ye8C4DX-wQ8v9hA8jW=5_dK6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Apr 6, 2017 at 5:19 AM, malc <mlashley@gmail.com> wrote:
> Resend in plaintext-mode (damn you gmail...)
>
> On Thu, Apr 6, 2017 at 12:06 AM, Deepak Khandelwal <dazz.87@gmail.com> wrote:
>>
>> Hi,
>>
>> I am testing SCTP performance on 4.4.x mips kernel (Octeon 2 hardware)
>> I have a specific requirement of testing 130K packets per second with
>> each packet size of 278 bytes. Server(s) and Client(s) are running on
>> separate machines each with 16 CPU Core.
>>
>> I am running two instances of iperf3 Server and client in those
>> dedicated machines respectively.
>> Is there any dependency between two instances from SCTP PoV ?
>>
>> Case -1: when Running with one instance of Server and Client
>>
>> ./iperf3 --sctp -4 -c 18.18.18.1 -B 18.18.18.2 -p 45000 -V -l 278 -t 60 -A 10
>>
>>
>> I am getting consistent bandwidth.
>> CPU usage of Client is 100 %
>>
>>
>> Case -2:  when Running with two instances of Server and Client
>>
>> ./iperf3 --sctp -4 -c 18.18.18.1 -B 18.18.18.2 -p 45000 -V -l 278 -t 60 -A 10
>>
>> ./iperf3 --sctp -4 -c 18.18.18.1 -B 18.18.18.2 -p 45020 -V -l 278 -t 60 -A 11
>
>
> Are you running iPerf on the Octeon, or some other x86 hardware?
> If x86 - your -A 10, -A 11 are likely pinning to 2 hyper-threads on
> the same CPU core - pinning to 10,12 may yield better performance.
>
> malc.


yes i am running iperf3 on Octeon-2 hardware.  (do you know if there
is any recommended tool to benchmark sctp performance ?)


based on your inputs i check it further and it seem earlier i had
interface level drops (tc -s qdisc show).
so this time i made sure i don;t have drops at NIC level

i tried to simplify the setup too.


Node A              ---------------------------------------------Loop
Back Cable-----------------------------------------------------------------
   Node B
SCTP Server(ether15 vlan Interface  )

                                     SCTP Client (ether19 vlan
Interface)
1Gbps

                                                             1Gbps


Each of these nodes have 16 CPU available.
Client send 278 Bytes messages to server.

Case-1: Disable Nagle Algorithm at Client end

i see the throughput is not constant at all intervals.
sometime server receives 108 Mbps and sometime half of it 54 Mbps.
what could be possible reason for it (?)

i do also notice at Server end that when SctpInPktDiscards increases
throughput decreases from max.
what could be the possible reason for SctpInPktDiscards counter
increments ? should these be there at all ?


Case -2: without disabling Nagle Algorithm at Client end.
i see the throughput is almost same at all intervals. and there are
very slight drops (SctpInPktDiscards) comparatively in snmp output.



Results:
===
Client :
from iperf3 help
(-N, --no-delay            set TCP/SCTP no delay, disabling Nagle's Algorithm)



Case-1:

# ./iperf3 --sctp -4 -c 30.30.30.3 -p 31000 -V -l 278  -t 30 -N

iperf 3.1.3
Time: Wed, 12 Apr 2017 14:20:12 GMT
Connecting to host 30.30.30.3, port 31000
      Cookie: EIPU.1492006812.431678.6a4ca8c53c1
[  4] local 30.30.30.4 port 61759 connected to 30.30.30.3 port 31000
Starting Test: protocol: SCTP, 1 streams, 278 byte blocks, omitting 0
seconds, 30 second test
[ ID] Interval           Transfer     Bandwidth
[  4]   0.00-1.00   sec  12.7 MBytes   106 Mbits/sec
[  4]   1.00-2.00   sec  11.2 MBytes  94.2 Mbits/sec
[  4]   2.00-3.00   sec  5.62 MBytes  47.1 Mbits/sec
[  4]   3.00-4.00   sec  5.61 MBytes  47.1 Mbits/sec
[  4]   4.00-5.00   sec  6.15 MBytes  51.6 Mbits/sec
[  4]   5.00-6.00   sec  6.52 MBytes  54.7 Mbits/sec
[  4]   6.00-7.00   sec  6.08 MBytes  51.0 Mbits/sec
[  4]   7.00-8.00   sec  6.10 MBytes  51.2 Mbits/sec
[  4]   8.00-9.00   sec  6.30 MBytes  52.9 Mbits/sec
[  4]   9.00-10.00  sec  6.57 MBytes  55.1 Mbits/sec
[  4]  10.00-11.00  sec  5.95 MBytes  49.9 Mbits/sec
[  4]  11.00-12.00  sec  5.99 MBytes  50.2 Mbits/sec
[  4]  12.00-13.00  sec  5.94 MBytes  49.8 Mbits/sec
[  4]  13.00-14.00  sec  5.89 MBytes  49.4 Mbits/sec
[  4]  14.00-15.00  sec  5.93 MBytes  49.8 Mbits/sec
[  4]  15.00-16.00  sec  5.94 MBytes  49.8 Mbits/sec
[  4]  16.00-17.00  sec  5.96 MBytes  50.0 Mbits/sec
[  4]  17.00-18.00  sec  5.67 MBytes  47.6 Mbits/sec
[  4]  18.00-19.00  sec  5.31 MBytes  44.5 Mbits/sec
[  4]  19.00-20.00  sec  5.31 MBytes  44.5 Mbits/sec
[  4]  20.00-21.00  sec  5.31 MBytes  44.6 Mbits/sec
[  4]  21.00-22.00  sec  8.93 MBytes  74.9 Mbits/sec
[  4]  22.00-23.00  sec  6.02 MBytes  50.5 Mbits/sec
[  4]  23.00-24.00  sec  6.70 MBytes  56.2 Mbits/sec
[  4]  24.00-25.00  sec  6.52 MBytes  54.7 Mbits/sec
[  4]  25.00-26.00  sec  12.9 MBytes   108 Mbits/sec
[  4]  26.00-27.00  sec  12.9 MBytes   108 Mbits/sec
[  4]  27.00-28.00  sec  12.9 MBytes   108 Mbits/sec
[  4]  28.00-29.00  sec  12.9 MBytes   108 Mbits/sec
[  4]  29.00-30.00  sec  12.9 MBytes   108 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
Test Complete. Summary Results:
[ ID] Interval           Transfer     Bandwidth
[  4]   0.00-30.00  sec   229 MBytes  64.0 Mbits/sec                  sender
[  4]   0.00-30.00  sec   229 MBytes  63.9 Mbits/sec                  receiver
CPU Utilization: local/sender 90.5% (2.1%u/88.4%s), remote/receiver
6.2% (0.4%u/5.9%s)

iperf Done.



sysctl at both ends.
======
net.core.rmem_default = 229376
net.core.rmem_max = 8388608

net.core.wmem_default = 229376
net.core.wmem_max = 229376

net.sctp.sctp_mem = 740757      987679  1481514
net.sctp.sctp_rmem = 4096       961500  4194304
net.sctp.sctp_wmem = 4096       16384   4194304
net.sctp.addip_enable = 0
net.sctp.addip_noauth_enable = 0
net.sctp.addr_scope_policy = 1
net.sctp.association_max_retrans = 10
net.sctp.auth_enable = 0
net.sctp.cookie_hmac_alg = md5
net.sctp.cookie_preserve_enable = 1
net.sctp.default_auto_asconf = 0
net.sctp.hb_interval = 30000
net.sctp.max_autoclose = 8589934
net.sctp.max_burst = 4
net.sctp.max_init_retransmits = 8
net.sctp.path_max_retrans = 5
net.sctp.pf_enable = 0
net.sctp.pf_retrans = 0
net.sctp.prsctp_enable = 0
net.sctp.rcvbuf_policy = 0
net.sctp.rto_alpha_exp_divisor = 3
net.sctp.rto_beta_exp_divisor = 2
net.sctp.rto_initial = 3000
net.sctp.rto_max = 60000
net.sctp.rto_min = 1000
net.sctp.rwnd_update_shift = 4
net.sctp.sack_timeout = 200
net.sctp.sndbuf_policy = 0
net.sctp.valid_cookie_life = 60000





Case :2
===


# ./iperf3 --sctp -4 -c 30.30.30.3 -p 31000 -V -l 278  -t 30


iperf 3.1.3
Time: Wed, 12 Apr 2017 14:14:26 GMT
Connecting to host 30.30.30.3, port 31000
      Cookie: EIPU-1.1492006466.621613.754134a26e2
[  4] local 30.30.30.4 port 64948 connected to 30.30.30.3 port 31000
Starting Test: protocol: SCTP, 1 streams, 278 byte blocks, omitting 0
seconds, 30 second test
[ ID] Interval           Transfer     Bandwidth
[  4]   0.00-1.00   sec  13.1 MBytes   110 Mbits/sec
[  4]   1.00-2.00   sec  15.1 MBytes   127 Mbits/sec
[  4]   2.00-3.00   sec  15.1 MBytes   126 Mbits/sec
[  4]   3.00-4.00   sec  12.5 MBytes   104 Mbits/sec
[  4]   4.00-5.00   sec  12.5 MBytes   105 Mbits/sec
[  4]   5.00-6.00   sec  12.6 MBytes   106 Mbits/sec
[  4]   6.00-7.00   sec  14.1 MBytes   118 Mbits/sec
[  4]   7.00-8.00   sec  13.6 MBytes   114 Mbits/sec
[  4]   8.00-9.00   sec  13.6 MBytes   114 Mbits/sec
[  4]   9.00-10.00  sec  13.2 MBytes   111 Mbits/sec
[  4]  10.00-11.00  sec  13.1 MBytes   110 Mbits/sec
[  4]  11.00-12.00  sec  12.9 MBytes   108 Mbits/sec
[  4]  12.00-13.00  sec  14.3 MBytes   120 Mbits/sec
[  4]  13.00-14.00  sec  12.8 MBytes   108 Mbits/sec
[  4]  14.00-15.00  sec  12.9 MBytes   108 Mbits/sec
[  4]  15.00-16.00  sec  14.6 MBytes   122 Mbits/sec
[  4]  16.00-17.00  sec  16.7 MBytes   140 Mbits/sec
[  4]  17.00-18.00  sec  16.6 MBytes   140 Mbits/sec
[  4]  18.00-19.00  sec  14.3 MBytes   120 Mbits/sec
[  4]  19.00-20.00  sec  13.4 MBytes   112 Mbits/sec
[  4]  20.00-21.00  sec  14.4 MBytes   121 Mbits/sec
[  4]  21.00-22.00  sec  13.0 MBytes   109 Mbits/sec
[  4]  22.00-23.00  sec  12.9 MBytes   109 Mbits/sec
[  4]  23.00-24.00  sec  12.9 MBytes   109 Mbits/sec
[  4]  24.00-25.00  sec  12.9 MBytes   108 Mbits/sec
[  4]  25.00-26.00  sec  13.0 MBytes   109 Mbits/sec
[  4]  26.00-27.00  sec  13.1 MBytes   110 Mbits/sec
[  4]  27.00-28.00  sec  13.0 MBytes   109 Mbits/sec
[  4]  28.00-29.00  sec  13.0 MBytes   109 Mbits/sec
[  4]  29.00-30.00  sec  13.0 MBytes   109 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
Test Complete. Summary Results:
[ ID] Interval           Transfer     Bandwidth
[  4]   0.00-30.00  sec   408 MBytes   114 Mbits/sec                  sender
[  4]   0.00-30.00  sec   408 MBytes   114 Mbits/sec                  receiver
CPU Utilization: local/sender 76.3% (3.1%u/73.1%s), remote/receiver
86.4% (3.8%u/82.7%s)

iperf Done.




===========
# ethtool -i ether19
driver: 802.1Q VLAN Support
version: 1.8
firmware-version: N/A
expansion-rom-version:
bus-info:
supports-statistics: no
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no


# ethtool -i real_ether_dev
driver: octeon-ethernet
version: 2.0
firmware-version:
expansion-rom-version:
bus-info: Builtin
supports-statistics: no
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no


same output for ether15



=============

# cat /proc/octeon_info
processor_id:        0xd910a
boot_flags:          0x5
dram_size:           32768
phy_mem_desc_addr:   0x48108
eclock_hz:           1200000000
io_clock_hz:         800000000
dclock_hz:           533000000
board_type:          21901
board_rev_major:     2
board_rev_minor:     0



processor               : 15
cpu model               : Cavium Octeon II V0.10
BogoMIPS                : 2400.00
wait instruction        : yes
microsecond timers      : yes
tlb_entries             : 128
extra interrupt vector  : yes
hardware watchpoint     : yes, count: 2, address/irw mask: [0x0ffc, 0x0ffb]
isa                     : mips2 mips3 mips4 mips5 mips64r2
ASEs implemented        :
shadow register sets    : 1
kscratch registers      : 3
package                 : 0
core                    : 15
VCED exceptions         : not available
VCEI exceptions         : not available


same for other processor 0-15


Best Regards,
Deepak


>
>> the bandwidth is not consistent and sometimes even 0 .
>> CPU of both these process together reaches to 100% not individually.
>> so if one client CPU usage is 80% other one CPU usage is 20%
>>
>> I have pinned the servers and clients to dedicated CPU cores. and
>> softirq interrupts also are masked to these cores.(smp_affinity)
>>
>> I tried changing scheduling priority of these process to SCHED_RR
>> (earlier SCHED_OTHER)
>> but the situation is still the same.
>>
>>
>> Best Regards,
>> Deepak
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
