From: malc <mlashley@gmail.com>
Date: Wed, 05 Apr 2017 23:49:52 +0000
Subject: Re: SCTP performance on 4.4.x Kernel with two instances of iperf3
Message-Id: <CAPkQJpT4tGOaeTS20DkOW6fmjh0wRyH=AfCeO8UZQ7tUeT90ZA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAOci8dL_ab3uQz7tukv21Ski5Ye8C4DX-wQ8v9hA8jW=5_dK6A@mail.gmail.com>
In-Reply-To: <CAOci8dL_ab3uQz7tukv21Ski5Ye8C4DX-wQ8v9hA8jW=5_dK6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Resend in plaintext-mode (damn you gmail...)

On Thu, Apr 6, 2017 at 12:06 AM, Deepak Khandelwal <dazz.87@gmail.com> wrote:
>
> Hi,
>
> I am testing SCTP performance on 4.4.x mips kernel (Octeon 2 hardware)
> I have a specific requirement of testing 130K packets per second with
> each packet size of 278 bytes. Server(s) and Client(s) are running on
> separate machines each with 16 CPU Core.
>
> I am running two instances of iperf3 Server and client in those
> dedicated machines respectively.
> Is there any dependency between two instances from SCTP PoV ?
>
> Case -1: when Running with one instance of Server and Client
>
> ./iperf3 --sctp -4 -c 18.18.18.1 -B 18.18.18.2 -p 45000 -V -l 278 -t 60 -A 10
>
>
> I am getting consistent bandwidth.
> CPU usage of Client is 100 %
>
>
> Case -2:  when Running with two instances of Server and Client
>
> ./iperf3 --sctp -4 -c 18.18.18.1 -B 18.18.18.2 -p 45000 -V -l 278 -t 60 -A 10
>
> ./iperf3 --sctp -4 -c 18.18.18.1 -B 18.18.18.2 -p 45020 -V -l 278 -t 60 -A 11


Are you running iPerf on the Octeon, or some other x86 hardware?
If x86 - your -A 10, -A 11 are likely pinning to 2 hyper-threads on
the same CPU core - pinning to 10,12 may yield better performance.

malc.

> the bandwidth is not consistent and sometimes even 0 .
> CPU of both these process together reaches to 100% not individually.
> so if one client CPU usage is 80% other one CPU usage is 20%
>
> I have pinned the servers and clients to dedicated CPU cores. and
> softirq interrupts also are masked to these cores.(smp_affinity)
>
> I tried changing scheduling priority of these process to SCHED_RR
> (earlier SCHED_OTHER)
> but the situation is still the same.
>
>
> Best Regards,
> Deepak
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
