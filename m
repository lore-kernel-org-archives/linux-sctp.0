From: David Neil <David.Neil@attocore.com>
Date: Mon, 19 Mar 2018 17:06:05 +0000
Subject: Re: SCTP abort with T-bit set after handshake
Message-Id: <8A8F6E25-CF27-4324-9D85-59AD3928B43A@attocore.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
In-Reply-To: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Marcelo,
Sorry for the slow reply, have been away and then have been struggling to reproduce the problem.


> 
> A few lines below it will check if an asoc couldn't be found and will
> increment SCTP_MIB_OUTOFBLUES. There are more places that inc it, but
> it's a start.
> 
> It should show up in netstat -s or /proc/net/sctp/snmp.
> 

Have finally caught another instance of the problem while monitoring the SCTP statistics. 
This is not helped by the fact that the out-of-blue counter goes up in total by about 600 while running a complete set of tests (I assume this is mainly at the end of each test when conections are abruptly terminated).
I have therefore been capturing the stats every 100msec and looking at the counters at the moment when the problem occurred.

This shows the out-of-blue counter being incremented at the same time as the SCTP connection failure.

16:07:12.708
SctpCurrEstab                           22
SctpActiveEstabs                        64619
SctpPassiveEstabs                       64618
SctpAborteds                            108462
SctpShutdowns                           24922
SctpOutOfBlues                          3471
SctpChecksumErrors                      0
SctpOutCtrlChunks                       915680
SctpOutOrderChunks                      708312
SctpOutUnorderChunks                    0
SctpInCtrlChunks                        1314834
SctpInOrderChunks                       704751
SctpInUnorderChunks                     0
SctpFragUsrMsgs                         0
SctpReasmUsrMsgs                        0
SctpOutSCTPPacks                        1489904
SctpInSCTPPacks                         1488886
SctpT1InitExpireds                      108
SctpT1CookieExpireds                    2
SctpT2ShutdownExpireds                  80
SctpT3RtxExpireds                       162
SctpT4RtoExpireds                       0
SctpT5ShutdownGuardExpireds             0
SctpDelaySackExpireds                   54915
SctpAutocloseExpireds                   0
SctpT3Retransmits                       157
SctpPmtudRetransmits                    0
SctpFastRetransmits                     0
SctpInPktSoftirq                        1217809
SctpInPktBacklog                        270941
SctpInPktDiscards                       3483
SctpInDataChunkDiscards                 0

16:07:12.810
SctpCurrEstab                           38
SctpActiveEstabs                        64627
SctpPassiveEstabs                       64627
SctpAborteds                            108463
SctpShutdowns                           24922
SctpOutOfBlues                          3472
SctpChecksumErrors                      0
SctpOutCtrlChunks                       915742
SctpOutOrderChunks                      708342
SctpOutUnorderChunks                    0
SctpInCtrlChunks                        1314899
SctpInOrderChunks                       704781
SctpInUnorderChunks                     0
SctpFragUsrMsgs                         0
SctpReasmUsrMsgs                        0
SctpOutSCTPPacks                        1489978
SctpInSCTPPacks                         1488960
SctpT1InitExpireds                      108
SctpT1CookieExpireds                    2
SctpT2ShutdownExpireds                  80
SctpT3RtxExpireds                       162
SctpT4RtoExpireds                       0
SctpT5ShutdownGuardExpireds             0
SctpDelaySackExpireds                   54920
SctpAutocloseExpireds                   0
SctpT3Retransmits                       157
SctpPmtudRetransmits                    0
SctpFastRetransmits                     0
SctpInPktSoftirq                        1217854
SctpInPktBacklog                        270970
SctpInPktDiscards                       3484
SctpInDataChunkDiscards                 0

> 
> Btw, is this test public? Can I run it too?  

Unfortunately, it is private.


> Or if you can create a
> small reproducer, that would be great.

This would be great if I could figure out what the important elements are in what I am doing.
The tests are opening and closing and aborting large numbers of connections. 
Some of the connections are used to exchange a lot of data, others hardly carry anything.
The connection that fails appears to be fairly random. The timing of when it fails appears to be fairly random.
The failure only occurs after an average of over an hour of running.
Any hints at the kind of behaviour that could trigger a failure like this?

Thanks,
Dave.








