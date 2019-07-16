From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 16 Jul 2019 23:20:21 +0000
Subject: Re: OOM triggered by SCTP
Message-Id: <20190716232021.GA12469@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJPywTL5aKYB40FsAFYFEuhErhgQpYZP5Q_ipMG9pDxqipcEDg@mail.gmail.com>
In-Reply-To: <CAJPywTL5aKYB40FsAFYFEuhErhgQpYZP5Q_ipMG9pDxqipcEDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marek Majkowski <marek@cloudflare.com>
Cc: vyasevich@gmail.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>

On Tue, Jul 16, 2019 at 11:47:40PM +0200, Marek Majkowski wrote:
> Morning,
> 
> My poor man's fuzzer found something interesting in SCTP. It seems
> like creating large number of SCTP sockets + some magic dance, upsets
> a memory subsystem related to SCTP. The sequence:
> 
>  - create SCTP socket
>  - call setsockopts (SCTP_EVENTS)
>  - call bind(::1, port)
>  - call sendmsg(long buffer, MSG_CONFIRM, ::1, port)
>  - close SCTP socket
>  - repeat couple thousand times
> 
> Full code:
> https://gist.github.com/majek/bd083dae769804d39134ce01f4f802bb#file-test_sctp-c
> 
> I'm running it on virtme the simplest way:
> $ virtme-run --show-boot-console --rw --pwd --kimg bzImage --memory
> 512M --script-sh ./test_sctp
> 
> Originally I was running it inside net namespace, and just having a
> localhost interface is sufficient to trigger the problem.
> 
> Kernel is 5.2.1 (with KASAN and such, but that shouldn't be a factor).
> In some tests I saw a message that might indicate something funny
> hitting neighbor table:
> 
> neighbour: ndisc_cache: neighbor table overflow!
> 
> I'm not addr-decoding the stack trace, since it seems unrelated to the
> root cause.
> 
Why would you have to decode anything, the decoded stack trace should be
available in your demsg log.  Cant you just attach that here?

Neil

> Cheers,
>     Marek
> 
