From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 11 Apr 2014 18:41:51 +0000
Subject: Re: Is SCTP throughput really this low compared to TCP?
Message-Id: <5348376F.4080709@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 04/11/2014 08:40 PM, Daniel Borkmann wrote:
> On 04/11/2014 08:22 PM, Butler, Peter wrote:
>> The difference between 3.14 and 3.4.2 is staggering.  An order of magnitude or so.  For example,
>  > using the precisely same setup as before, whereas I get about 2.1 Gbps throughput with 3.4 2, I
>  > can only manage between 70-150 Mbps with 3.14 - a staggering difference.
>>
>> Moreover, the SCTP throughput seems to 'choke' itself with 3.14, such that it is always trying to
>  > recover.  For example, with 3.4.2 the 2.1 Gbps throughput is quite consistent from one second to
>  > the next (as you would expect):
>>
>> [root@Lab200slot2 ~]# iperf3 --sctp -4 -c 192.168.241.3 -V -l 1452 -t 60
>> iperf version 3.0.1 (10 January 2014)
>> Linux Lab200slot2 3.4.2-1.fc16.x86_64 #1 SMP Thu Jun 14 20:17:26 UTC 2012 x86_64
>> Time: Fri, 11 Apr 2014 18:19:15 GMT
>> Connecting to host 192.168.241.3, port 5201
>>        Cookie: Lab200slot2.1397240355.069035.0d5b0f
>> [  4] local 192.168.241.2 port 56030 connected to 192.168.241.3 port 5201
>> Starting Test: protocol: SCTP, 1 streams, 1452 byte blocks, omitting 0 seconds, 60 second test
>> [ ID] Interval           Transfer     Bandwidth
>> [  4]   0.00-1.00   sec   255 MBytes  2.14 Gbits/sec
>> [  4]   1.00-2.00   sec   253 MBytes  2.12 Gbits/sec
>> [  4]   2.00-3.00   sec   255 MBytes  2.14 Gbits/sec
>> [  4]   3.00-4.00   sec   255 MBytes  2.14 Gbits/sec
>> [  4]   4.00-5.00   sec   255 MBytes  2.14 Gbits/sec
>> [  4]   5.00-6.00   sec   257 MBytes  2.15 Gbits/sec
>> [  4]   6.00-7.00   sec   253 MBytes  2.13 Gbits/sec
>> [  4]   7.00-8.00   sec   254 MBytes  2.13 Gbits/sec
>> [  4]   8.00-9.00   sec   255 MBytes  2.14 Gbits/sec
>> [  4]   9.00-10.00  sec   252 MBytes  2.12 Gbits/sec
>> (etc)
>>
>> but with 3.14 the numbers as all over the place:
>>
>> [root@Lab200slot2 ~]# iperf3 --sctp -4 -c 192.168.241.3 -V -l 1452 -t 60
>> iperf version 3.0.1 (10 January 2014)
>> Linux Lab200slot2 3.14.0 #1 SMP Thu Apr 3 23:18:29 EDT 2014 x86_64
>> Time: Fri, 11 Apr 2014 17:56:21 GMT
>> Connecting to host 192.168.241.3, port 5201
>>        Cookie: Lab200slot2.1397238981.812898.548918
>> [  4] local 192.168.241.2 port 38616 connected to 192.168.241.3 port 5201
>> Starting Test: protocol: SCTP, 1 streams, 1452 byte blocks, omitting 0 seconds, 60 second test
>> [ ID] Interval           Transfer     Bandwidth
>> [  4]   0.00-1.09   sec  20.8 MBytes   161 Mbits/sec
>> [  4]   1.09-2.13   sec  10.8 MBytes  86.8 Mbits/sec
>> [  4]   2.13-3.15   sec  3.57 MBytes  29.5 Mbits/sec
>> [  4]   3.15-4.16   sec  4.33 MBytes  35.7 Mbits/sec
>> [  4]   4.16-6.21   sec  10.4 MBytes  42.7 Mbits/sec
>> [  4]   6.21-6.21   sec  0.00 Bytes  0.00 bits/sec
>> [  4]   6.21-7.35   sec  34.6 MBytes   253 Mbits/sec
>> [  4]   7.35-11.45  sec  22.0 MBytes  45.0 Mbits/sec
>> [  4]  11.45-11.45  sec  0.00 Bytes  0.00 bits/sec
>> [  4]  11.45-11.45  sec  0.00 Bytes  0.00 bits/sec
>> [  4]  11.45-11.45  sec  0.00 Bytes  0.00 bits/sec
>> [  4]  11.45-12.51  sec  16.0 MBytes   126 Mbits/sec
>> [  4]  12.51-13.59  sec  20.3 MBytes   158 Mbits/sec
>> [  4]  13.59-14.65  sec  13.4 MBytes   107 Mbits/sec
>> [  4]  14.65-16.79  sec  33.3 MBytes   130 Mbits/sec
>> [  4]  16.79-16.79  sec  0.00 Bytes  0.00 bits/sec
>> [  4]  16.79-17.82  sec  5.94 MBytes  48.7 Mbits/sec
>> (etc)
>>
>> Note: the difference appears to be SCTP-specific, as I get exactly the same TCP
>  > throughput in both kernels.
>
> Hmm, okay. :/ Could you further bisect on your side to narrow down from which
> kernel onwards this behaviour can be seen?

Is that behaviour consistent between IPv4 and IPv6?
