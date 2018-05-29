From: Neal Cardwell <ncardwell@google.com>
Date: Tue, 29 May 2018 16:03:46 +0000
Subject: Re: [PATCH net] sctp: not allow to set rto_min with a value below 200 msecs
Message-Id: <CADVnQymCNEtQFThsbQ0u7jirx24i45f5L7P-2dPf8omkshqwmg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <dc48b7c6a6dd1d8f19215cea6713d5723779d564.1527270062.git.lucien.xin@gmail.com>
 <20180525191319.GB392@hmswarspite.think-freely.org> <71FD541D-25FE-4100-980B-C3A0CEAF6CD4@lurchi.franken.de>
 <CACT4Y+YozRSfcoUoKHOWy5wujhVdks38vcfNGhwNj-REWcd-hw@mail.gmail.com>
 <20180527010059.GA15798@neilslaptop.think-freely.org> <20180528194315.GB3788@localhost.localdomain>
 <20180529114111.GA24144@hmswarspite.think-freely.org> <559FFFDD-E508-4936-9544-CACE606AF40F@lurchi.franken.de>
 <20180529154514.GC3788@localhost.localdomain>
In-Reply-To: <20180529154514.GC3788@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: Michael Tuexen <michael.tuexen@lurchi.franken.de>, nhorman@tuxdriver.com, Dmitry Vyukov <dvyukov@google.com>, lucien.xin@gmail.com, Netdev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>, dsa@cumulusnetworks.com, Eric Dumazet <edumazet@google.com>, syzkaller@googlegroups.com

On Tue, May 29, 2018 at 11:45 AM Marcelo Ricardo Leitner <
marcelo.leitner@gmail.com> wrote:
> - patch2 - fix rtx attack vector
>    - Add the floor value to rto_min to HZ/20 (which fits the values
>      that Michael shared on the other email)

I would encourage allowing minimum RTO values down to 5ms, if the ACK
policy in the receiver makes this feasible. Our experience is that in
datacenter environments it can be advantageous to allow timer-based loss
recoveries using timeout values as low as 5ms, e.g.:


https://www.ietf.org/proceedings/97/slides/slides-97-tcpm-tcp-options-for-low-latency-00.pdf
   https://tools.ietf.org/html/draft-wang-tcpm-low-latency-opt-00

cheers,
neal
