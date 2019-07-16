From: Marek Majkowski <marek@cloudflare.com>
Date: Tue, 16 Jul 2019 21:47:40 +0000
Subject: OOM triggered by SCTP
Message-Id: <CAJPywTL5aKYB40FsAFYFEuhErhgQpYZP5Q_ipMG9pDxqipcEDg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>

Morning,

My poor man's fuzzer found something interesting in SCTP. It seems
like creating large number of SCTP sockets + some magic dance, upsets
a memory subsystem related to SCTP. The sequence:

 - create SCTP socket
 - call setsockopts (SCTP_EVENTS)
 - call bind(::1, port)
 - call sendmsg(long buffer, MSG_CONFIRM, ::1, port)
 - close SCTP socket
 - repeat couple thousand times

Full code:
https://gist.github.com/majek/bd083dae769804d39134ce01f4f802bb#file-test_sctp-c

I'm running it on virtme the simplest way:
$ virtme-run --show-boot-console --rw --pwd --kimg bzImage --memory
512M --script-sh ./test_sctp

Originally I was running it inside net namespace, and just having a
localhost interface is sufficient to trigger the problem.

Kernel is 5.2.1 (with KASAN and such, but that shouldn't be a factor).
In some tests I saw a message that might indicate something funny
hitting neighbor table:

neighbour: ndisc_cache: neighbor table overflow!

I'm not addr-decoding the stack trace, since it seems unrelated to the
root cause.

Cheers,
    Marek
