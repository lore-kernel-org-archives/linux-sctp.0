From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Sat, 12 Apr 2014 07:27:51 +0000
Subject: Re: Is SCTP throughput really this low compared to TCP?
Message-Id: <CAE8XmWoHMwW1RpG_UAnRkcUMevhV_=HeXMbdQCmxQOnmWSdOqA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi all,

I found a strange SCTP stream behavior, when the message size equal to
the recv buffer size, the performance is VERY LOW ( just 1% !!!). TCP
no such issue, just drop 20%.

*) SCTP message size = 128K, recvbuffer size = 128K
netperf -H 10.0.0.201 -p 1234 -l 10 -t SCTP_STREAM -- -m 128K -S 64K
SCTP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.0.201
() port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072 212992 131072    10.04       6.16

*) message size = 64K, recvbuffer size = 128K
Then I double the send buffer size:
netperf -H 10.0.0.201 -p 1234 -l 10 -t SCTP_STREAM -- -m 64K -S 64K
SCTP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.0.201
() port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072 212992  65536    10.00     596.26

But TCP no such issue,

*) TCP message size = 128K, recvbuffer size = 128K
netperf -H 10.0.0.201 -p 1234 -l 10 -t TCP_STREAM -- -m 128K -S 64K
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
10.0.0.201 () port 0 AF_INET
./netperf -H 10.0.0.201 -p 1234 -l 10 -t TCP_STREAM -- -m 128K -S 64K
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072  16384 131072    10.00    2368.84

*) TCP message size = 64K, recvbuffer size = 128K
netperf -H 10.0.0.201 -p 1234 -l 10 -t TCP_STREAM -- -m 128K -S 128K
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
10.0.0.201 () port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

262144  16384 131072    10.00    2993.15

I'm doing these test 2 VMware VMs with Intel Core i3-2120 @ 3.30GHz,
running Ubuntu 14.04 LTS, Linux kernel3.13.0-24-generic.
SCTP_RR is very good, but SCTP_STREAM have many improve room:

[9250.98] netperf -H 10.0.0.201 -p 1234 -l 10 -t UDP_RR  -- -r 960,512
[9070.85] netperf -H 10.0.0.201 -p 1234 -l 10 -t TCP_RR  -- -r 960,512
[2127.47] netperf -H 10.0.0.201 -p 1234 -l 10 -t TCP_CRR -- -r 960,512
[8126.60] netperf -H 10.0.0.201 -p 1234 -l 10 -t SCTP_RR -- -r 960,512

[3380.84] netperf -H 10.0.0.201 -p 1234 -l 10 -t TCP_STREAM   -- -m 16384
[ 952.17] netperf -H 10.0.0.201 -p 1234 -l 10 -t UDP_STREAM   -- -m 65504
[ 699.98] netperf -H 10.0.0.201 -p 1234 -l 10 -t SCTP_STREAM  -- -m
128K -s 512K -M 128K -S 256K

Regards,
Dongsheng
