From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 14 Jan 2011 01:25:47 +0000
Subject: Re: [PATCH][RFC] Allow to use adler32 for SCTP
Message-Id: <4D2FA61B.60204@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D2DC00A.8030208@freyther.de>
In-Reply-To: <4D2DC00A.8030208@freyther.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



> Hi,
>
> with OpenBSC I have to connect to some equipment that is configured to use
> adler32 as the checksum. I wonder if something a long the lines of this patch
> is acceptable? It adds a module parameter that globally allows to use adler32
> and then there is a sockopt to enable adler32 on a per process basis. For the
> receive path I have to decode both checksums.

decode both checksums by default will cause performance lost.
Why not change this to kernel config, and disable it by default since
most people do not need this?

Other question: why not just update your box which only support
adler32 to support new crc32 checksums? Linux and Freebsd etc.
do not using adler32, but using crc32.

> I could probably just use the code to disable checksums for rx but I will need
> to generate them on tx to make the other equipment accept these.
>
> regards
> 	holger
>
> PS: While adding my field to struct sctp_sock I saw that there are quite some
> holes (on both ia32,x86_64) in the struct and that one can save 16byte by
> re-ordering. I am not sure how to and if to benchmark such a change. Does it
> make sense to re-order those?
>
> PPS: This was sent to netdev first, so sorry if people see it twice
