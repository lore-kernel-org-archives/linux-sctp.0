From: tsoi andrew <tsoiandrew@gmail.com>
Date: Tue, 21 Feb 2017 08:51:46 +0000
Subject: Re: multihoming client question
Message-Id: <CAJ0j_BabcifrZq3QFy3wk9jzA9VivJqmM+2yFiyJAF5VpeS75g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
In-Reply-To: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Dear Sir,

My partner TIm will help to provide information.

Hi Tim,

Please help to provide information.

Regards,
Andrew


---------- Forwarded message ----------
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, Jan 11, 2017 at 9:19 PM
Subject: Re: multihoming client question
To: tsoi andrew <tsoiandrew@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>


On Wed, Jan 11, 2017 at 6:24 PM, tsoi andrew <tsoiandrew@gmail.com> wrote:
> Dear Sir,
>
> We have used iproute2 to set the route but lksctp client still choose
> the path from IP A to IP Y.
> It is still under our investigation.  Any hints for me?
can you send your route entries, the NICs' names and their addresses,
peer's addresses?

>
> Regards,
> Andrew
>
> On Wed, Dec 21, 2016 at 10:04 PM, Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
>> On Wed, Dec 21, 2016 at 05:10:22PM +0800, tsoi andrew wrote:
>>> Dear Sir,
>>>
>>> Would you provide the link for download the new library? I only find
>>> version 1.0.17 in http://lksctp.sourceforge.net/.
>>
>> 1.0.17 is the latest release we have.
>> You can a devel copy (may not be stable) via git,
>> https://github.com/sctp/lksctp-tools
>> but that's not going to help with this problem. The change Xin mentioned
>> is on kernel level only.
>>
>>   Marcelo
