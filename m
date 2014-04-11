From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Fri, 11 Apr 2014 19:16:37 +0000
Subject: RE: Is SCTP throughput really this low compared to TCP?
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E31B60D@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

What an excellent question.  I just tried that now and you are definitely on to something.  Whereas IPv4 is erratic on 3.14 (for SCTP), IPv6 is fairly smooth (see results below).

However, note that as previously mentioned I still get better throughput numbers with 3.4.2.  For the no-latency (0.2 ms) test, the 3.4.2 kernel yields about 2.1 Gbps, whereas the 3.14 kernel yields only about 1.6 Gbps.

These results show that the erratic behaviour seen with kernel 3.14 appears to be confined to IPv4 SCTP only:

IPv6:

[root@Lab200slot2 ~]#  iperf3 --sctp -6 -c 2001:db8:0:f101::1 -V -l 1400 -t 60
iperf version 3.0.1 (10 January 2014)
Linux Lab200slot2 3.14.0 #1 SMP Thu Apr 3 23:18:29 EDT 2014 x86_64
Time: Fri, 11 Apr 2014 19:08:41 GMT
Connecting to host 2001:db8:0:f101::1, port 5201
      Cookie: Lab200slot2.1397243321.714295.2b3f7c
[  4] local 2001:db8:0:f101::2 port 55804 connected to 2001:db8:0:f101::1 port 5201
Starting Test: protocol: SCTP, 1 streams, 1400 byte blocks, omitting 0 seconds, 60 second test
[ ID] Interval           Transfer     Bandwidth
[  4]   0.00-1.00   sec   169 MBytes  1.42 Gbits/sec
[  4]   1.00-2.00   sec   201 MBytes  1.69 Gbits/sec
[  4]   2.00-3.00   sec   188 MBytes  1.58 Gbits/sec
[  4]   3.00-4.00   sec   174 MBytes  1.46 Gbits/sec
[  4]   4.00-5.00   sec   165 MBytes  1.39 Gbits/sec
[  4]   5.00-6.00   sec   199 MBytes  1.67 Gbits/sec
[  4]   6.00-7.00   sec   163 MBytes  1.36 Gbits/sec
[  4]   7.00-8.00   sec   174 MBytes  1.46 Gbits/sec
[  4]   8.00-9.00   sec   193 MBytes  1.62 Gbits/sec
[  4]   9.00-10.00  sec   196 MBytes  1.65 Gbits/sec
[  4]  10.00-11.00  sec   157 MBytes  1.31 Gbits/sec
[  4]  11.00-12.00  sec   175 MBytes  1.47 Gbits/sec
[  4]  12.00-13.00  sec   192 MBytes  1.61 Gbits/sec
[  4]  13.00-14.00  sec   199 MBytes  1.67 Gbits/sec
(etc)



IPv4:

 [root@Lab200slot2 ~]#  iperf3 --sctp -4 -c 192.168.240.3 -V -l 1400 -t 60
iperf version 3.0.1 (10 January 2014)
Linux Lab200slot2 3.14.0 #1 SMP Thu Apr 3 23:18:29 EDT 2014 x86_64
Time: Fri, 11 Apr 2014 19:09:28 GMT
Connecting to host 192.168.240.3, port 5201
      Cookie: Lab200slot2.1397243368.815040.7ecb3d
[  4] local 192.168.240.2 port 36273 connected to 192.168.240.3 port 5201
Starting Test: protocol: SCTP, 1 streams, 1400 byte blocks, omitting 0 seconds, 60 second test
[ ID] Interval           Transfer     Bandwidth
[  4]   0.00-1.00   sec   221 MBytes  1.85 Gbits/sec
[  4]   1.00-2.42   sec  91.3 MBytes   541 Mbits/sec
[  4]   2.42-3.00   sec   127 MBytes  1.83 Gbits/sec
[  4]   3.00-4.00   sec   216 MBytes  1.81 Gbits/sec
[  4]   4.00-5.51   sec   111 MBytes   617 Mbits/sec
[  4]   5.51-6.75   sec  54.0 MBytes   365 Mbits/sec
[  4]   6.75-7.00   sec  57.4 MBytes  1.89 Gbits/sec
[  4]   7.00-9.55   sec   121 MBytes   399 Mbits/sec
[  4]   9.55-9.56   sec  0.00 Bytes  0.00 bits/sec
[  4]   9.56-10.00  sec  99.7 MBytes  1.88 Gbits/sec
[  4]  10.00-11.00  sec   220 MBytes  1.85 Gbits/sec
[  4]  11.00-12.34  sec  74.3 MBytes   466 Mbits/sec
(etc)




-----Original Message-----
From: Daniel Borkmann [mailto:dborkman@redhat.com] 
Sent: April-11-14 2:42 PM
To: Butler, Peter
Cc: Vlad Yasevich; linux-sctp@vger.kernel.org
Subject: Re: Is SCTP throughput really this low compared to TCP?

On 04/11/2014 08:40 PM, Daniel Borkmann wrote:
> On 04/11/2014 08:22 PM, Butler, Peter wrote:
>> The difference between 3.14 and 3.4.2 is staggering.  An order of 
>> magnitude or so.  For example,
>  > using the precisely same setup as before, whereas I get about 2.1 
> Gbps throughput with 3.4 2, I  > can only manage between 70-150 Mbps with 3.14 - a staggering difference.
>>
>> Moreover, the SCTP throughput seems to 'choke' itself with 3.14, such 
>> that it is always trying to
>  > recover.  For example, with 3.4.2 the 2.1 Gbps throughput is quite 
> consistent from one second to  > the next (as you would expect):
>>
>> [root@Lab200slot2 ~]# iperf3 --sctp -4 -c 192.168.241.3 -V -l 1452 -t 
>> 60 iperf version 3.0.1 (10 January 2014) Linux Lab200slot2 
>> 3.4.2-1.fc16.x86_64 #1 SMP Thu Jun 14 20:17:26 UTC 2012 x86_64
>> Time: Fri, 11 Apr 2014 18:19:15 GMT
>> Connecting to host 192.168.241.3, port 5201
>>        Cookie: Lab200slot2.1397240355.069035.0d5b0f
>> [  4] local 192.168.241.2 port 56030 connected to 192.168.241.3 port 
>> 5201 Starting Test: protocol: SCTP, 1 streams, 1452 byte blocks, omitting 0 seconds, 60 second test
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
>> [root@Lab200slot2 ~]# iperf3 --sctp -4 -c 192.168.241.3 -V -l 1452 -t 
>> 60 iperf version 3.0.1 (10 January 2014) Linux Lab200slot2 3.14.0 #1 
>> SMP Thu Apr 3 23:18:29 EDT 2014 x86_64
>> Time: Fri, 11 Apr 2014 17:56:21 GMT
>> Connecting to host 192.168.241.3, port 5201
>>        Cookie: Lab200slot2.1397238981.812898.548918
>> [  4] local 192.168.241.2 port 38616 connected to 192.168.241.3 port 
>> 5201 Starting Test: protocol: SCTP, 1 streams, 1452 byte blocks, omitting 0 seconds, 60 second test
>> [ ID] Interval           Transfer     Bandwidth
>> [  4]   0.00-1.09   sec  20.8 MBytes   161 Mbits/sec
>> [  4]   1.09-2.13   sec  10.8 MBytes  86.8 Mbits/sec
>> [  4]   2.13-3.15   sec  3.57 MBytes  29.5 Mbits/sec
>> [  4]   3.15-4.16   sec  4.33 MBytes  35.7 Mbits/sec
>> [  4]   4.16-6.21   sec  10.4 MBytes  42.7 Mbits/sec
>> [  4]   6.21-6.21   sec  0.00 Bytes  0.00 bits/sec
>> [  4]   6.21-7.35   sec  34.6 MBytes   253 Mbits/sec
>> [  4]   7.35-11.45  sec  22.0 MBytes  45.0 Mbits/sec
>> [  4]  11.45-11.45  sec  0.00 Bytes  0.00 bits/sec [  4]  11.45-11.45  
>> sec  0.00 Bytes  0.00 bits/sec [  4]  11.45-11.45  sec  0.00 Bytes  
>> 0.00 bits/sec
>> [  4]  11.45-12.51  sec  16.0 MBytes   126 Mbits/sec
>> [  4]  12.51-13.59  sec  20.3 MBytes   158 Mbits/sec
>> [  4]  13.59-14.65  sec  13.4 MBytes   107 Mbits/sec
>> [  4]  14.65-16.79  sec  33.3 MBytes   130 Mbits/sec
>> [  4]  16.79-16.79  sec  0.00 Bytes  0.00 bits/sec [  4]  16.79-17.82  
>> sec  5.94 MBytes  48.7 Mbits/sec
>> (etc)
>>
>> Note: the difference appears to be SCTP-specific, as I get exactly 
>> the same TCP
>  > throughput in both kernels.
>
> Hmm, okay. :/ Could you further bisect on your side to narrow down 
> from which kernel onwards this behaviour can be seen?

Is that behaviour consistent between IPv4 and IPv6?
