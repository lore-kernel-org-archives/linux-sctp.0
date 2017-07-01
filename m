From: Sun Paul <paulrbk@gmail.com>
Date: Sat, 01 Jul 2017 17:29:56 +0000
Subject: Re: ABORT after COOKIE_ECHO
Message-Id: <CAFXGft+EXA4qzUyre7sBTVPgSzEGEAX_e1Tvy9DZmLaDgJDFwg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+WBxm+7JK1imsP=M_go60WWHSsOurJPr=3=FZzWDShqg@mail.gmail.com>
In-Reply-To: <CAFXGft+WBxm+7JK1imsP=M_go60WWHSsOurJPr=3=FZzWDShqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

OOTB means?

and below figure is the /proc/net/sctp/snmp, any idea

$ cat  /proc/net/sctp/snmp
SctpCurrEstab                   0
SctpActiveEstabs                 26061
SctpPassiveEstabs               204235
SctpAborteds                     811874
SctpShutdowns                   196524
SctpOutOfBlues                   19104636
SctpChecksumErrors               3070
SctpOutCtrlChunks               3515894374
SctpOutOrderChunks               43687436
SctpOutUnorderChunks             5244253158
SctpInCtrlChunks                 3820268182
SctpInOrderChunks               2553760409
SctpInUnorderChunks             2741444705
SctpFragUsrMsgs                 197031085
SctpReasmUsrMsgs                 207379860
SctpOutSCTPPacks                 6407590023
SctpInSCTPPacks                 6719200223
SctpT1InitExpireds               18041179
SctpT1CookieExpireds             365
SctpT2ShutdownExpireds           486
SctpT3RtxExpireds               4543012
SctpT4RtoExpireds               0
SctpT5ShutdownGuardExpireds     2
SctpDelaySackExpireds           2595840671
SctpAutocloseExpireds           0
SctpT3Retransmits               4527700
SctpPmtudRetransmits             3341
SctpFastRetransmits             4155577
SctpInPktSoftirq                 6711421746
SctpInPktBacklog                 7744553
SctpInPktDiscards               19253619
SctpInDataChunkDiscards         4248038

On Sun, Jul 2, 2017 at 1:11 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> Hi,
>
> On Sun, Jul 02, 2017 at 01:02:36AM +0800, Sun Paul wrote:
>> Hi
>>
>> we have a setup that running normal, however, we found that some of
>> the conenctions are not able to establish and we (server) send ABORT
>> right after receiving COOKIE_ECHO.
>>
>> any idea?
>
> Several reasons.. if it's not triggering a duplicate cookie processing,
> it's being processed on sctp_sf_do_5_1D_ce(). Have a look at it to have
> a better idea. Two reasons that stands out are somehow the cookie was
> interpreted as an OOTB packet or the tcp-style listening socket got its
> backlog full.
>
> It can also be due to an out of memory situation, which is not often the
> case.
>
> OOTB packets are accounted for in netstat -s or /proc/net/sctp/snmp.
>
>   Marcelo
>
