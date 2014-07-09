From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 09 Jul 2014 14:57:55 +0000
Subject: RE: [PATCH net-next 2/5] net: sctp: implement rfc6458, 5.3.4. SCTP_SNDINFO cmsg support
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1726F288@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1404507908-6949-3-git-send-email-dborkman@redhat.com>
In-Reply-To: <1404507908-6949-3-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> > My 'other' test system in running 2.6.26 and probably sends multiple sacks
> > for packets containing a lot of data chunks.
> >
> > 	David
> 
> That shouldn't happen even in 2.6.26.  SACKs were always per packet, not per chunk

There seem to be a lot of SACKs at the bottom of the trace below.
Maybe they are being sent as the application reads the data off the
socket, rather than directly in response to the received data.

tcpdump output edited to shorten the lines.
All the [SACK] have [#gap acks] [#dup tsns 0]
All the [DATA] have [PPIDx3]
A lot of earlier trace deleted, it all looks much the same.

Trace taken on the sending system (dsl-a) running a 3.15(ish) kernel,
ss7-3 is runnin 2.6.18.

10:14:49.663034 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 622] [SID: 3] [SSEQ 2507] 
10:14:49.663038 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 623] [SID: 4] [SSEQ 2507] 
10:14:49.663040 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 624] [SID: 1] [SSEQ 2508] 
10:14:49.663041 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 625] [SID: 2] [SSEQ 2508] 
10:14:49.663043 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 626] [SID: 3] [SSEQ 2508] 
10:14:49.663044 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 627] [SID: 4] [SSEQ 2508] 
10:14:49.663045 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 628] [SID: 1] [SSEQ 2509] 
10:14:49.663118 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 629] [SID: 2] [SSEQ 2509] 
10:14:49.663123 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 630] [SID: 3] [SSEQ 2509] 
10:14:49.663125 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 631] [SID: 4] [SSEQ 2509] 
10:14:49.663126 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 632] [SID: 1] [SSEQ 2510] 
10:14:49.663173 ss7-3 > dsl-a: [SACK] [cum ack 568] [a_rwnd 62020]
10:14:49.663189 ss7-3 > dsl-a: [SACK] [cum ack 570] [a_rwnd 62020]
10:14:49.663197 ss7-3 > dsl-a: [SACK] [cum ack 572] [a_rwnd 61724]
10:14:49.663210 ss7-3 > dsl-a: [SACK] [cum ack 574] [a_rwnd 61428]
10:14:49.663217 ss7-3 > dsl-a: [SACK] [cum ack 576] [a_rwnd 61132]
10:14:49.663229 ss7-3 > dsl-a: [SACK] [cum ack 578] [a_rwnd 60836]
10:14:49.663246 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 633] [SID: 2] [SSEQ 2510] 
10:14:49.663250 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 634] [SID: 3] [SSEQ 2510] 
10:14:49.663251 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 635] [SID: 4] [SSEQ 2510] 
10:14:49.663252 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 636] [SID: 1] [SSEQ 2511] 
10:14:49.663254 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 637] [SID: 2] [SSEQ 2511] 
10:14:49.663255 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 638] [SID: 3] [SSEQ 2511] 
10:14:49.663257 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 639] [SID: 4] [SSEQ 2511] 
10:14:49.663305 ss7-3 > dsl-a: [SACK] [cum ack 579] [a_rwnd 62464]
10:14:49.663331 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 640] [SID: 1] [SSEQ 2512] 
10:14:49.663335 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 641] [SID: 2] [SSEQ 2512] 
10:14:49.663336 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 642] [SID: 3] [SSEQ 2512] 
10:14:49.663337 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 643] [SID: 4] [SSEQ 2512] 
10:14:49.663435 ss7-3 > dsl-a: [SACK] [cum ack 581] [a_rwnd 62168]
10:14:49.663447 ss7-3 > dsl-a: [SACK] [cum ack 583] [a_rwnd 61872]
10:14:49.663454 ss7-3 > dsl-a: [SACK] [cum ack 585] [a_rwnd 61872]
10:14:49.663465 ss7-3 > dsl-a: [SACK] [cum ack 587] [a_rwnd 61872]
10:14:49.663473 ss7-3 > dsl-a: [SACK] [cum ack 589] [a_rwnd 61576]
10:14:49.663485 ss7-3 > dsl-a: [SACK] [cum ack 591] [a_rwnd 61280]
10:14:49.663498 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 644] [SID: 1] [SSEQ 2513] 
10:14:49.663505 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 645] [SID: 2] [SSEQ 2513] 
10:14:49.663507 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 646] [SID: 3] [SSEQ 2513] 
10:14:49.663510 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 647] [SID: 4] [SSEQ 2513] 
10:14:49.663512 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 648] [SID: 1] [SSEQ 2514] 
10:14:49.663514 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 649] [SID: 2] [SSEQ 2514] ,
                            (2) [DATA] (B)(E) [TSN: 650] [SID: 3] [SSEQ 2514] ,
                            (3) [DATA] (B)(E) [TSN: 651] [SID: 4] [SSEQ 2514] ,
                            (4) [DATA] (B)(E) [TSN: 652] [SID: 1] [SSEQ 2515] 
10:14:49.663515 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 653] [SID: 2] [SSEQ 2515] ,
                            (2) [DATA] (B)(E) [TSN: 654] [SID: 3] [SSEQ 2515] ,
                            (3) [DATA] (B)(E) [TSN: 655] [SID: 4] [SSEQ 2515] ,
                            (4) [DATA] (B)(E) [TSN: 656] [SID: 1] [SSEQ 2516] 
10:14:49.663517 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 657] [SID: 2] [SSEQ 2516] ,
                            (2) [DATA] (B)(E) [TSN: 658] [SID: 3] [SSEQ 2516] ,
                            (3) [DATA] (B)(E) [TSN: 659] [SID: 4] [SSEQ 2516] ,
                            (4) [DATA] (B)(E) [TSN: 660] [SID: 1] [SSEQ 2517] 
10:14:49.663519 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 661] [SID: 2] [SSEQ 2517] ,
                            (2) [DATA] (B)(E) [TSN: 662] [SID: 3] [SSEQ 2517] ,
                            (3) [DATA] (B)(E) [TSN: 663] [SID: 4] [SSEQ 2517] ,
                            (4) [DATA] (B)(E) [TSN: 664] [SID: 1] [SSEQ 2518] 
10:14:49.663523 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 665] [SID: 2] [SSEQ 2518] ,
                            (2) [DATA] (B)(E) [TSN: 666] [SID: 3] [SSEQ 2518] ,
                            (3) [DATA] (B)(E) [TSN: 667] [SID: 4] [SSEQ 2518] ,
                            (4) [DATA] (B)(E) [TSN: 668] [SID: 1] [SSEQ 2519] 
10:14:49.663524 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 669] [SID: 2] [SSEQ 2519] ,
                            (2) [DATA] (B)(E) [TSN: 670] [SID: 3] [SSEQ 2519] ,
                            (3) [DATA] (B)(E) [TSN: 671] [SID: 4] [SSEQ 2519] ,
                            (4) [DATA] (B)(E) [TSN: 672] [SID: 1] [SSEQ 2520] 
10:14:49.663627 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 673] [SID: 2] [SSEQ 2520] ,
                            (2) [DATA] (B)(E) [TSN: 674] [SID: 3] [SSEQ 2520] ,
                            (3) [DATA] (B)(E) [TSN: 675] [SID: 4] [SSEQ 2520] ,
                            (4) [DATA] (B)(E) [TSN: 676] [SID: 1] [SSEQ 2521] 
10:14:49.663631 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 677] [SID: 2] [SSEQ 2521] ,
                            (2) [DATA] (B)(E) [TSN: 678] [SID: 3] [SSEQ 2521] 
10:14:49.663632 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 679] [SID: 4] [SSEQ 2521] ,
                            (2) [DATA] (B)(E) [TSN: 680] [SID: 1] [SSEQ 2522] ,
                            (3) [DATA] (B)(E) [TSN: 681] [SID: 2] [SSEQ 2522] ,
                            (4) [DATA] (B)(E) [TSN: 682] [SID: 3] [SSEQ 2522] 
10:14:49.663633 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 683] [SID: 4] [SSEQ 2522] ,
                            (2) [DATA] (B)(E) [TSN: 684] [SID: 1] [SSEQ 2523] ,
                            (3) [DATA] (B)(E) [TSN: 685] [SID: 2] [SSEQ 2523] ,
                            (4) [DATA] (B)(E) [TSN: 686] [SID: 3] [SSEQ 2523] 
10:14:49.663634 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 687] [SID: 4] [SSEQ 2523] ,
                            (2) [DATA] (B)(E) [TSN: 688] [SID: 1] [SSEQ 2524] ,
                            (3) [DATA] (B)(E) [TSN: 689] [SID: 2] [SSEQ 2524] ,
                            (4) [DATA] (B)(E) [TSN: 690] [SID: 3] [SSEQ 2524] 
10:14:49.663674 ss7-3 > dsl-a: [SACK] [cum ack 593] [a_rwnd 61280]
10:14:49.663687 ss7-3 > dsl-a: [SACK] [cum ack 595] [a_rwnd 61280]
10:14:49.663695 ss7-3 > dsl-a: [SACK] [cum ack 597] [a_rwnd 61280]
10:14:49.663706 ss7-3 > dsl-a: [SACK] [cum ack 599] [a_rwnd 61280]
10:14:49.663715 ss7-3 > dsl-a: [SACK] [cum ack 601] [a_rwnd 61132]
10:14:49.663726 ss7-3 > dsl-a: [SACK] [cum ack 603] [a_rwnd 60836]
10:14:49.663729 ss7-3 > dsl-a: [SACK] [cum ack 605] [a_rwnd 60540]
10:14:49.663744 dsl-a > ss7-3: [DATA] (B)(E) [TSN: 691] [SID: 4] [SSEQ 2524] 
10:14:49.663834 ss7-3 > dsl-a: [SACK] [cum ack 606] [a_rwnd 62168]
10:14:49.663928 ss7-3 > dsl-a: [SACK] [cum ack 608] [a_rwnd 62168]
10:14:49.663939 ss7-3 > dsl-a: [SACK] [cum ack 610] [a_rwnd 62020]
10:14:49.663946 ss7-3 > dsl-a: [SACK] [cum ack 612] [a_rwnd 61724]
10:14:49.663957 ss7-3 > dsl-a: [SACK] [cum ack 614] [a_rwnd 61428]
10:14:49.663964 ss7-3 > dsl-a: [SACK] [cum ack 616] [a_rwnd 61132]
10:14:49.663976 ss7-3 > dsl-a: [SACK] [cum ack 618] [a_rwnd 61132]
10:14:49.664183 ss7-3 > dsl-a: [SACK] [cum ack 620] [a_rwnd 61132]
10:14:49.664194 ss7-3 > dsl-a: [SACK] [cum ack 622] [a_rwnd 61132]
10:14:49.664200 ss7-3 > dsl-a: [SACK] [cum ack 624] [a_rwnd 61132]
10:14:49.664209 ss7-3 > dsl-a: [SACK] [cum ack 626] [a_rwnd 61132]
10:14:49.664215 ss7-3 > dsl-a: [SACK] [cum ack 628] [a_rwnd 60984]
10:14:49.664224 ss7-3 > dsl-a: [SACK] [cum ack 630] [a_rwnd 60688]
10:14:49.664232 ss7-3 > dsl-a: [SACK] [cum ack 632] [a_rwnd 60392]
10:14:49.664320 ss7-3 > dsl-a: [SACK] [cum ack 632] [a_rwnd 62020]
10:14:49.664429 ss7-3 > dsl-a: [SACK] [cum ack 634] [a_rwnd 62020]
10:14:49.664439 ss7-3 > dsl-a: [SACK] [cum ack 636] [a_rwnd 62020]
10:14:49.664446 ss7-3 > dsl-a: [SACK] [cum ack 638] [a_rwnd 61724]
10:14:49.664457 ss7-3 > dsl-a: [SACK] [cum ack 640] [a_rwnd 61428]
10:14:49.664463 ss7-3 > dsl-a: [SACK] [cum ack 642] [a_rwnd 61132]
10:14:49.664473 ss7-3 > dsl-a: [SACK] [cum ack 644] [a_rwnd 60836]
10:14:49.664479 ss7-3 > dsl-a: [SACK] [cum ack 644] [a_rwnd 62464]
10:14:49.664676 ss7-3 > dsl-a: [SACK] [cum ack 646] [a_rwnd 62168]
10:14:49.664687 ss7-3 > dsl-a: [SACK] [cum ack 648] [a_rwnd 61872]
10:14:49.664693 ss7-3 > dsl-a: [SACK] [cum ack 656] [a_rwnd 60688]
10:14:49.664825 ss7-3 > dsl-a: [SACK] [cum ack 660] [a_rwnd 62316]
10:14:49.664945 ss7-3 > dsl-a: [SACK] [cum ack 668] [a_rwnd 61280]
10:14:49.664962 ss7-3 > dsl-a: [SACK] [cum ack 676] [a_rwnd 60096]
10:14:49.664979 ss7-3 > dsl-a: [SACK] [cum ack 676] [a_rwnd 61724]
10:14:49.665179 ss7-3 > dsl-a: [SACK] [cum ack 682] [a_rwnd 61724]
10:14:49.665193 ss7-3 > dsl-a: [SACK] [cum ack 690] [a_rwnd 61724]
10:14:49.864258 ss7-3 > dsl-a: [SACK] [cum ack 691] [a_rwnd 61724]




