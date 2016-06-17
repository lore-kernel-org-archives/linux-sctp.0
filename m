From: Wasim Baig <wasimbaig@gmail.com>
Date: Fri, 17 Jun 2016 05:13:06 +0000
Subject: Re: No COOKIE_ECHO after INIT_ACK
Message-Id: <CABHdwCrNzQc=GG-bYMcUYCKxED=xP99mTWwzf3-xKC9UxGQvkg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CABHdwCpNDcpQHUpR6ho+Eh2CUfCbGhEt1dKt2vE9wTfHJv1Gfw@mail.gmail.com>
In-Reply-To: <CABHdwCpNDcpQHUpR6ho+Eh2CUfCbGhEt1dKt2vE9wTfHJv1Gfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Indeed it was the iptables interfering, bypassing that shows a
complete handshake. Thanks, and I apologize for wasting precious
cycles.

root@smsc-01 ~ # tshark -r nflog-sctp.pcap

|
tshark: Lua: Error during loading:

|
 [string "/usr/share/wireshark/init.lua"]:46: dofile has been disabled
due to running Wireshark as superuser. See
http://wiki.wireshark.org/C|
aptureSetup/CapturePrivileges for help in running Wireshark as an
unprivileged user.
Running as user "root" and group "root". This could be dangerous.
  1 0.000000000 10.123.86.248 -> 10.157.120.36 SCTP 116 INIT
  2 0.000005000 10.157.120.36 -> 10.123.86.248 SCTP 892 INIT_ACK
  3 0.000006000 10.123.86.248 -> 10.157.120.36 SCTP 828 COOKIE_ECHO
DATA
  4 0.000006000 10.157.120.36 -> 10.123.86.248 SCTP 140 COOKIE_ACK
  5 0.000007000 10.157.120.36 -> 10.123.86.248 SCTP 152 SACK
  6 0.000007000 10.123.86.248 -> 10.157.120.36 SCTP 100 DATA
  7 0.998681000 10.123.86.248 -> 10.157.120.36 SCTP 1480 DATA DATA
DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA
DATA
 DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA
DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA
DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA
DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA
  8 0.998684000 10.157.120.36 -> 10.123.86.248 SCTP 152 SACK
  9 0.998685000 10.123.86.248 -> 10.157.120.36 SCTP 624 DATA DATA DATA
DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA
DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA
 10 0.998685000 10.157.120.36 -> 10.123.86.248 SCTP 152 SACK
 11 0.998686000 10.123.86.248 -> 10.157.120.36 SCTP 72 SHUTDOWN
 12 0.998686000 10.157.120.36 -> 10.123.86.248 SCTP 140 SHUTDOWN_ACK
 13 0.998687000 10.123.86.248 -> 10.157.120.36 SCTP 68 SHUTDOWN_COMPLETE


-wasim

On Fri, Jun 17, 2016 at 9:55 AM, Wasim Baig <wasimbaig@gmail.com> wrote:
> In trying to establish an association, linux-sctp Debian 8 (libsctp1
> 1.0.16+dfsg-2) is not responding with COOKIE_ECHO to the INIT_ACK.
>
> Linux smsc-01 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt25-1 (2016-03-06)
> x86_64 GNU/Linux
>
> Far end is probably a Huawei STP, but I have to confirm this
> information with the operator.
>
> Attached is a PCAP showing the INIT and INIT_ACK (this goes on...)
>
> sctp_test -H 10.123.86.248 -P 2527 -h 10.157.120.36 -p 2527 -s
> remote:addr.157.120.36, port%27, family=2
> local:addr.123.86.248, port%27, family=2
> seed = 1466138967
>
> Starting tests...
>         socket(SOCK_SEQPACKET, IPPROTO_SCTP)  ->  sk=3
>         bind(sk=3, [a:10.123.86.248,p:2527])  --  attempt 1/10
> Client: Sending packets.(1/10)
>         sendmsg(sk=3, assoc=0)    1 bytes.
>           SNDRCV(stream=0 flags=0x1 ppid9959982
>
> In between is an IPSEC tunnel, could it be the INIT_ACK is not
> reaching sctp_test? How can I get more debug?
>
> Would appreciate insight into the matter as we haven't seen this
> behaviour below.
>
> Many thanks.
>
> --
> wasim h. baig | +92 30 0850 8070 | peace be upon you



-- 
wasim h. baig | +92 30 0850 8070 | peace be upon you
