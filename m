From: Vasil Velichkov <vvvelichkov@gmail.com>
Date: Tue, 03 Dec 2019 18:54:45 +0000
Subject: Re: Fw: [Bug 205753] New: Incorrect SCTP DATA dispatching
Message-Id: <e9c3d8bd-f2f4-3bbc-50ed-ef578915525a@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191203082233.5c1525be@hermes.lan>
In-Reply-To: <20191203082233.5c1525be@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Evgeni,

On 03/12/2019 18.22, Stephen Hemminger wrote:
> All networking bugzilla bugs go to me. This one is new and  SCTP related
> 
> Begin forwarded message:
> 
> Date: Tue, 03 Dec 2019 13:32:39 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 205753] New: Incorrect SCTP DATA dispatching
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id 5753
> 
>             Bug ID: 205753
>            Summary: Incorrect SCTP DATA dispatching
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 4.19.67
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: evgenij.fokin@gmail.com
>         Regression: No
> 
> I think that root cause in skipped messages.
> 
> For example, frame 56 in your debian10_sctp_test_to_sctp_test.pcapng shows that
> the data message with sctp.data_tsn = 919935042 was received on server
> interface but it was acked in frame 78 only.
> 
> It happens periodically with high-load traffic. The server can capture DATA on
> network interface but SCTP level does not receive it.

In my opinion the reason that a SACK for frame 56 is not returned is that the receive buffer is full

$ tshark -r debian10_sctp_test_to_sctp_test.pcapng -Y "sctp.sack_a_rwnd" -T fields -e frame.number -e sctp.sack_a_rwnd
4       106495
7       106423
...
49      105662
53      105591
55      0
57      0
58      13500

> Reproduction scenario:
> system1: /usr/bin/sctp_test -H local-addr -P local-port -l
> system2: /usr/bin/sctp_test -H local-addr -P local-port -h remote-addr -p remote-port -s -x 1000

I'm not sure whether the sctp_test is the best tool for stress/load tests.

You may try increasing the buffer size (-m 212992) on the server side, see also https://github.com/sctp/lksctp-tools/blob/master/src/apps/sctp_test.c#L1117-L1123

Monitor the buffers sizes and sctp's snmp stats when testing

cat /proc/net/sctp/assocs
cat /proc/net/sctp/snmp

Regards,
Vasil
