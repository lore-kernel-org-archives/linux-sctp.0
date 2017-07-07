From: Marcelo <marcelo.leitner@gmail.com>
Date: Fri, 07 Jul 2017 23:03:19 +0000
Subject: Re: ABORT after COOKIE_ECHO
Message-Id: <20170707230319.GT18138@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+WBxm+7JK1imsP=M_go60WWHSsOurJPr=3=FZzWDShqg@mail.gmail.com>
In-Reply-To: <CAFXGft+WBxm+7JK1imsP=M_go60WWHSsOurJPr=3=FZzWDShqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jul 07, 2017 at 11:23:02PM +1200, Xin Long wrote:
> On Mon, Jul 3, 2017 at 7:12 PM, Sun Paul <paulrbk@gmail.com> wrote:
> > also, how to determine it is OOTB packet?
> can you use systemtap on the host sending abort chunk ?
> 
> # stap --all-modules -v -e 'probe
> module("sctp").function("sctp_make_abort").call{print_backtrace();println("");}'
> 
> So that we can see how the abort chunk is caused.

Or the perf version:
# perf probe -m sctp -a sctp_make_abort
# perf record -e probe:sctp_make_abort -agR -- <command>
  (note the extra -g if compared to what the 1st command outputted)
# perf script

<command> should be either your reproducer or an sleep X that covers the
event.

  Marcelo
