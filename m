From: malc <mlashley@gmail.com>
Date: Tue, 16 Jul 2019 23:59:10 +0000
Subject: Re: OOM triggered by SCTP
Message-Id: <CAPkQJpRJadEqxOcdb_U5Tz6NPE3h3FzootQt3r2GgPP0aYsVvA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJPywTL5aKYB40FsAFYFEuhErhgQpYZP5Q_ipMG9pDxqipcEDg@mail.gmail.com>
In-Reply-To: <CAJPywTL5aKYB40FsAFYFEuhErhgQpYZP5Q_ipMG9pDxqipcEDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Marek Majkowski <marek@cloudflare.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, Linux SCTP <linux-sctp@vger.kernel.org>, netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>

On Tue, Jul 16, 2019 at 10:49 PM Marek Majkowski <marek@cloudflare.com> wrote:
>
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
> Cheers,
>     Marek

I _think_ this is an 'expected' peculiarity of SCTP on loopback - you
test_sctp.c ends up creating actual associations to itself on the same
socket (you can test safely by reducing the port range (say
30000-32000) and setting the for-loop-clause to 'run < 1')
You'll see a bunch of associations established like the following
(note that I(kernel) was dropping packets for this capture - even with
/only/ 2000 sockets used...)

$ tshark -r sctp.pcap -Y 'sctp.assoc_index==4'
  21 0.000409127          ::1 → ::1           SCTP INIT
  22 0.000436281          ::1 → ::1           SCTP INIT_ACK
  23 0.000442106          ::1 → ::1           SCTP COOKIE_ECHO
  24 0.000463007          ::1 → ::1           SCTP COOKIE_ACK DATA
(Message Fragment)
                                              presumably your close()
happens here and we enter SHUTDOWN-PENDING, where we wait for pending
data to be acknowledged, I'm not convinced that we shouldn't be
SACK'ing the data from the 'peer' at this point - but for whatever
reason, we aren't.
                                              We then run thru
path-max-retrans, and finally ABORT (the abort indication also shows
the PMR-exceeded indication in the 'Cause Information')
  25 0.000476083          ::1 → ::1           SCTP SACK
13619 3.017788109          ::1 → ::1           SCTP DATA (retransmission)
14022 3.222690889          ::1 → ::1           SCTP SACK
18922 21.938217449          ::1 → ::1           SCTP SACK
33476 69.831029904          ::1 → ::1           SCTP HEARTBEAT
33561 69.831310796          ::1 → ::1           SCTP HEARTBEAT_ACK
40816 94.102667600          ::1 → ::1           SCTP SACK
40910 95.942741287          ::1 → ::1           SCTP DATA (retransmission)
41039 96.152023010          ::1 → ::1           SCTP SACK
41100 100.182685237          ::1 → ::1           SCTP SACK
41212 108.230746764          ::1 → ::1           SCTP DATA (retransmission)
41345 108.439061392          ::1 → ::1           SCTP SACK
41407 116.422688507          ::1 → ::1           SCTP HEARTBEAT
41413 116.423183124          ::1 → ::1           SCTP HEARTBEAT_ACK
41494 124.823749255          ::1 → ::1           SCTP SACK
41576 126.663648718          ::1 → ::1           SCTP ABORT

With your entire 512M - you'd only have about 16KB for each of these
31K associations tops, I suspect that having a 64KB pending data chunk
(fragmented ULP msg) for each association for >= 90s is what is
exhausting memory here - although I'm sure Neil or Michael will be
along to correct me ;-)

What's interesting - as you reduce the payload size - we end up
bundling DATA from the 'initiator' side (in COOKIE ECHO) - and
everything works as expected... (the SACK here is for the bundled DATA
chunks TSN.

mlashley@duality /tmp $ tshark -r /tmp/sctp_index4_10K.pcap
   1 0.000000000          ::1 → ::1          SCTP INIT
   2 0.000014491          ::1 → ::1          SCTP INIT_ACK
   3 0.000024190          ::1 → ::1          SCTP COOKIE_ECHO DATA
   4 0.000034833          ::1 → ::1          SCTP COOKIE_ACK
   5 0.000040646          ::1 → ::1          SCTP SACK
   6 0.000050287          ::1 → ::1          SCTP ABORT

In short - the SCTP associations /can/ persist after user-space calls
close() whilst there is outstanding data (for path.max.retrans *
rto-with-doubling[due to T3-rtx expiry])

(My tests on 5.2.0 as it is what I had to hand...)

Cheers,
malc.
