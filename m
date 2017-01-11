From: tsoi andrew <tsoiandrew@gmail.com>
Date: Wed, 11 Jan 2017 10:24:13 +0000
Subject: Re: multihoming client question
Message-Id: <CAJ0j_BZO5nq=z0vB2UEvzs85PjRqDnu=Ne=rbT6=-OQzCUHg=w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
In-Reply-To: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Dear Sir,

We have used iproute2 to set the route but lksctp client still choose
the path from IP A to IP Y.
It is still under our investigation.  Any hints for me?

Regards,
Andrew

On Wed, Dec 21, 2016 at 10:04 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Wed, Dec 21, 2016 at 05:10:22PM +0800, tsoi andrew wrote:
>> Dear Sir,
>>
>> Would you provide the link for download the new library? I only find
>> version 1.0.17 in http://lksctp.sourceforge.net/.
>
> 1.0.17 is the latest release we have.
> You can a devel copy (may not be stable) via git,
> https://github.com/sctp/lksctp-tools
> but that's not going to help with this problem. The change Xin mentioned
> is on kernel level only.
>
>   Marcelo
