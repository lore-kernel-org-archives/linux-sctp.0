From: Emanuel Freitas <ejsfreitas@gmail.com>
Date: Mon, 25 Nov 2019 13:57:00 +0000
Subject: SCTP unable to bind after restart application
Message-Id: <CALyDMGoWYqSBYJwfARROuP_6g_PXLU1oPcS8jomgm+4oNSkckA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Hello,

I had an application running on SCTP port 3890 for a few days and I
stopped it (kill <pid>) for maintenance purposes. After that I’m not
able to bind on port.
The same situation happened in the past and the only way that I found
to fix it was to restart the server. I was hoping that you can help me
fixing this issue without restart.

The application is not running and the port is not used by anything else:
[root@server1 /]# netstat -lanp | grep 3890
[root@server1 /]#

I tried to use the sctp_test in order to exclude any issue on the
application and it also cannot bind on that port (my IP address is
replaced with <IPv4>):

[root@server1 /]# /usr/bin/sctp_test -H <IPv4> -P 3890 -l
local:addr=<IPv4>, port=ndsconnect, family=2
seed = 1574684002
Starting tests...
        socket(SOCK_SEQPACKET, IPPROTO_SCTP)  ->  sk=3
        bind(sk=3, [a:<IPv4>,p:ndsconnect])  --  attempt 1/10
        bind(sk=3, [a:<IPv4>,p:ndsconnect])  --  attempt 2/10
        bind(sk=3, [a:<IPv4>,p:ndsconnect])  --  attempt 3/10
        bind(sk=3, [a:<IPv4>,p:ndsconnect])  --  attempt 4/10
        bind(sk=3, [a:<IPv4>,p:ndsconnect])  --  attempt 5/10
        bind(sk=3, [a:<IPv4>,p:ndsconnect])  --  attempt 6/10
        bind(sk=3, [a:<IPv4>,p:ndsconnect])  --  attempt 7/10
        bind(sk=3, [a:<IPv4>,p:ndsconnect])  --  attempt 8/10
        bind(sk=3, [a:<IPv4>,p:ndsconnect])  --  attempt 9/10
        bind(sk=3, [a:<IPv4>,p:ndsconnect])  --  attempt 10/10
Maximum bind() attempts. Die now...

I have no issues while binding on other ports:
[root@server1 /]# /usr/bin/sctp_test -H <IPv4> -P 3891 -l
local:addr=<IPv4>, port=rtc-pm-port, family=2
seed = 1574684925
Starting tests...
        socket(SOCK_SEQPACKET, IPPROTO_SCTP)  ->  sk=3
        bind(sk=3, [a:<IPv4>,p:rtc-pm-port])  --  attempt 1/10
        listen(sk=3,backlog=100)
Server: Receiving packets.
        recvmsg(sk=3) ^C

There are no active SCTP associations:
[root@server1 log]# tail /proc/net/sctp/* -n 10000
==> /proc/net/sctp/assocs <==
ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
==> /proc/net/sctp/eps <==
ENDPT     SOCK   STY SST HBKT LPORT   UID INODE LADDRS
==> /proc/net/sctp/remaddr <==
ADDR ASSOC_ID HB_ACT RTO MAX_PATH_RTX REM_ADDR_RTX  START
==> /proc/net/sctp/snmp <==
SctpCurrEstab                           0
SctpActiveEstabs                        0
SctpPassiveEstabs                       602
SctpAborteds                            13
SctpShutdowns                           589
SctpOutOfBlues                          29128
SctpChecksumErrors                      0
SctpOutCtrlChunks                       891800
SctpOutOrderChunks                      135693
SctpOutUnorderChunks                    0
SctpInCtrlChunks                        941831
SctpInOrderChunks                       122325
SctpInUnorderChunks                     13931
SctpFragUsrMsgs                         0
SctpReasmUsrMsgs                        0
SctpOutSCTPPacks                        1027573
SctpInSCTPPacks                         1035656
SctpT1InitExpireds                      0
SctpT1CookieExpireds                    0
SctpT2ShutdownExpireds                  0
SctpT3RtxExpireds                       81
SctpT4RtoExpireds                       0
SctpT5ShutdownGuardExpireds             0
SctpDelaySackExpireds                   57489
SctpAutocloseExpireds                   0
SctpT3Retransmits                       80
SctpPmtudRetransmits                    0
SctpFastRetransmits                     0
SctpInPktSoftirq                        1035623
SctpInPktBacklog                        19
SctpInPktDiscards                       29139
SctpInDataChunkDiscards                 27869


Other useful information:
[root@server1 log]# uname -a
Linux server1 2.6.32-754.11.1.el6.x86_64 #1 SMP Tue Feb 26 15:38:56
UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

[root@server1 log]# cat /etc/redhat-release
CentOS release 6.10 (Final)

[root@server1 log]# rpm -qa | grep sctp
lksctp-tools-1.0.10-7.el6.x86_64

I don’t find any relevant information on /var/log
I also disabled IPv6 (although I’m not using it) in an attempt to
isolate the issue but there was no difference.

Thanks in advance!

Kind regards,

Emanuel
