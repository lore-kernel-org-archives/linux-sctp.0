From: Vasil Velichkov <vasil.velichkov@opencode.com>
Date: Tue, 15 Feb 2011 16:01:08 +0000
Subject: Re: Gap is only retransmitted once
Message-Id: <4D5AA344.9010107@opencode.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
In-Reply-To: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 15.02.2011 15:58, Mingyuan Zhu wrote:
> Hi,
>
>
>
> I have observed a problem while doing load testing on SCTP. The tested
> equipment is an open suse linux box with 2.6.34 kernel. The
> application of the equipment will send/receive messages through linux
> kernel sctp. The peer is an equipment using Aricent sctp stack.
>
> During the load testing, the peer equipment drops sctp chunks and
> reports gaps through SACK to the tested equipment.
>
> The tested equipment (Linux box) retransmitts the missing chunks. But
> it always retransmit the same #TSN only once even it receives more
> SACKs with the reporting gap.
>
>  From the ethereal captures:
>
> - TSN 2254147468 is not received by the peer equipment, so it reports
> the gap by SACK.
>
> - Linux box retransmit TSN 2254147468.
>
> - The peer still does not get it. It reports the gap by SACK again and again.
>
> - Linux box never retransmit the missing chunk again.
>
> - Finally, neither linux box nor the peer can send/receive any more chunks.
>
>
>
> Could someone help to look at the problem? Any help would be highly appreciated!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>    
Hi Mingyuan Zhu,

On the Linux box, check whether net.sctp.path_max_retrans(MAX_PATH_RTX) 
or net.sctp.association_max_retrans(MAXRT) parameters are set to 1.

# cat /proc/net/sctp/assocs
  ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE 
LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
f2876000 f35ee1c0 2   1   4  38050    1        0        0       0 
6429275 2975   2985  *127.0.0.1 <-> *127.0.0.1            5000    32    
32    5    0    0        0
f444c800 e8407c00 2   1   4  41620    2        0        0     500 
6429276 2985   2975  *127.0.0.1 <-> *127.0.0.1            5000    32    
32    5    0    0        0

# cat /proc/net/sctp/remaddr
ADDR ASSOC_ID HB_ACT RTO MAX_PATH_RTX REM_ADDR_RTX  START
127.0.0.1  1 1 1000 5 0 0
127.0.0.1  2 1 1000 5 0 0

# sysctl -a | grep max_retrans
net.sctp.association_max_retrans = 10
net.sctp.path_max_retrans = 5

BR
Vasil Velichkov
