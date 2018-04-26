From: Oleg Babin <obabin@virtuozzo.com>
Date: Thu, 26 Apr 2018 22:14:56 +0000
Subject: Re: [PATCH net-next 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <27adcf09-830d-48cb-34ab-aaabffa2b202@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1524508866-317485-1-git-send-email-obabin@virtuozzo.com>
 <20180423213314.GG3711@localhost.localdomain>
In-Reply-To: <20180423213314.GG3711@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

Hi Marcelo,

On 04/24/2018 12:33 AM, Marcelo Ricardo Leitner wrote:
> Hi,
> 
> On Mon, Apr 23, 2018 at 09:41:04PM +0300, Oleg Babin wrote:
>> Each SCTP association can have up to 65535 input and output streams.
>> For each stream type an array of sctp_stream_in or sctp_stream_out
>> structures is allocated using kmalloc_array() function. This function
>> allocates physically contiguous memory regions, so this can lead
>> to allocation of memory regions of very high order, i.e.:
>>
>>   sizeof(struct sctp_stream_out) = 24,
>>   ((65535 * 24) / 4096) = 383 memory pages (4096 byte per page),
>>   which means 9th memory order.
>>
>> This can lead to a memory allocation failures on the systems
>> under a memory stress.
> 
> Did you do performance tests while actually using these 65k streams
> and with 256 (so it gets 2 pages)?
> 
> This will introduce another deref on each access to an element, but
> I'm not expecting any impact due to it.
> 

No, I didn't do such tests. Could you please tell me what methodology
do you usually use to measure performance properly?

I'm trying to do measurements with iperf3 on unmodified kernel and get
very strange results like this:

ovbabin@ovbabin-laptop:~$ ~/programs/iperf/bin/iperf3 -c 169.254.11.150 --sctp
Connecting to host 169.254.11.150, port 5201
[  5] local 169.254.11.150 port 46330 connected to 169.254.11.150 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  9.88 MBytes  82.8 Mbits/sec                  
[  5]   1.00-2.00   sec   226 MBytes  1.90 Gbits/sec                  
[  5]   2.00-3.00   sec   832 KBytes  6.82 Mbits/sec                  
[  5]   3.00-4.00   sec   640 KBytes  5.24 Mbits/sec                  
[  5]   4.00-5.00   sec   756 MBytes  6.34 Gbits/sec                  
[  5]   5.00-6.00   sec   522 MBytes  4.38 Gbits/sec                  
[  5]   6.00-7.00   sec   896 KBytes  7.34 Mbits/sec                  
[  5]   7.00-8.00   sec   519 MBytes  4.35 Gbits/sec                  
[  5]   8.00-9.00   sec   504 MBytes  4.23 Gbits/sec                  
[  5]   9.00-10.00  sec   475 MBytes  3.98 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  2.94 GBytes  2.53 Gbits/sec                  sender
[  5]   0.00-10.04  sec  2.94 GBytes  2.52 Gbits/sec                  receiver

iperf Done.

The values are spread enormously from hundreds of kilobits to gigabits.
I get similar results with netperf. This particular result was obtained
with client and server running on the same machine. Also I tried this
on different machines with different kernel versions - situation was similar.
I compiled latest versions of iperf and netperf from sources.

Could it possibly be that I am missing something very obvious? 

Thanks!

-- 
Best regards,
Oleg
  
>   Marcelo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>
