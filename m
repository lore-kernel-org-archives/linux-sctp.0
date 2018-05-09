From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 09 May 2018 19:01:52 +0000
Subject: Re: [PATCH lksctp-tools] func_tests: add a reference to Issue 24
Message-Id: <20180509190152.GU5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <ce318353a5288076342d5517262e9aa08d4b1c67.1525831854.git.marcelo.leitner@gmail.com>
In-Reply-To: <ce318353a5288076342d5517262e9aa08d4b1c67.1525831854.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, May 08, 2018 at 11:14:06PM -0300, Marcelo Ricardo Leitner wrote:
> We extended struct sctp_event_subscribe in the kernel UAPI. The change
> itself would have been backwards compatible if only the kernel was doing
> the right size check, as described at Issue 24.
>
> That said, place a pointer to the known issue in the code to ease it for
> who else trip over this.
>
> See-also: https://github.com/sctp/lksctp-tools/issues/24
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> Note: kernel is not yet fixed. Draft patch is available at the issue
> page.
>
>  src/func_tests/test_1_to_1_events.c | 3 +++

Self-nack.

There are other tests issuing this setsockopt() call, and updating all
of them doesn't seem worth.

func_tests]$ git grep -lw SCTP_EVENTS
test_1_to_1_events.c
test_sctp_sendrecvmsg.c
test_sockopt.c
test_timetolive.c
func_tests]$

  Marcelo
