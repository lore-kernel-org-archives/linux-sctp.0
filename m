From: Ian Coolidge <icoolidge@google.com>
Date: Thu, 05 Nov 2015 23:54:39 +0000
Subject: Re: Max.Init.Retransmits and ABORT response to INIT
Message-Id: <CAB3A_j9G1qyiwZeaT2gsFs1Ycx_N=6pNAFpk_XNkc9ecvFxeYA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAB3A_j95dYXpM9bd1vuSo-1mOjtpwauoxQCcBZLmpFywBmmPMA@mail.gmail.com>
In-Reply-To: <CAB3A_j95dYXpM9bd1vuSo-1mOjtpwauoxQCcBZLmpFywBmmPMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad,

Thanks for the reply,

On Mon, Nov 2, 2015 at 5:07 AM, Vlad Yasevich <vyasevich@gmail.com> wrote:
> On 10/30/2015 08:03 PM, Ian Coolidge wrote:
>> Hello,
>>
>> With the Linux SCTP implementation, Max.Init.Retransmits is respected
>> when INIT messages do not receive a response (ie, if SCTP host is
>> unavailable). However, if a Linux SCTP host is accessible, but has no
>> SCTP servers listening for incoming connections, it will quickly reply
>> ABORT. This doesn't trigger the Max.Init.Retransmits logic, so,
>> retries occur indefinitely.
> An ABORT should terminate the association thus stopping any further
> INIT transmissions.  Is that not happening?

Thanks for the clarification on the intended behavior.
Do you think that the general abort specification fully defines that behavior?

In my case, it seems like after the abort is received, 65s later,
another INIT attempt is made,
and it repeats indefinitely. I have ruled out application layer
triggering of this by strace -p on the process which owns the client
socketfd,
it is doing no sockopt or connect calls, so I think it is related to
the Linux implementation.
