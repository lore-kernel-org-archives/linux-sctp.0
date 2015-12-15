From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 15 Dec 2015 03:49:16 +0000
Subject: Re: Question on SCTP parameters tunning
Message-Id: <566F8DBC.7080502@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftJ3kdbHc54QwH6m-KEemsDXLkKSRk5E+D+F2jKtBVr4wg@mail.gmail.com>
In-Reply-To: <CAFXGftJ3kdbHc54QwH6m-KEemsDXLkKSRk5E+D+F2jKtBVr4wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/14/2015 08:19 PM, Sun Paul wrote:
> Hi All
> 
> the current memory settings on sctp is as below.
> 
> net.sctp.sctp_mem = 1531104 2041472 3062208
> net.sctp.sctp_rmem = 4096 349500 4194304
> net.sctp.sctp_wmem = 4096 16384 4194304
> 
> However, we observed that consumption of one particular SCTP
> connection is as below.
> 
> ffff8803d0609000 ffff8804358a6500 2   1   4  21855 968785  3882668
> 13184   28674 1132095678 3868  18710  171.109.115.116 171.109.115.122
> <-> *164.114.213.15 164.114.213.136   10000    10  2048    6    0    0
>      175
> 
> The Transmit Q reaches around 3.6MB, we would like to check what is
> the value we should enlarge. is there any limitation on setting the
> read/write memory for LKSCTP?

Why do you want to enlarge memory?  That just allows you to buffer
more data in the kernel, but doesn't really improve anything.
The fact that you have 3.6 MB of data buffered in the transmit q
means that you either your receive or your path is very slow and
buffering more data in the kernel would actually be a bad thing,

As for programatically limiting of buffer sizes, they are limited by net.core.wmem_max
and net.core.rmem_max. Bump those value and you can set larger buffer values
in your application.

-vlad

> 
> Thanks
> 
> - RBK
> 
> On Tue, Dec 15, 2015 at 9:14 AM, Sun Paul <paulrbk@gmail.com> wrote:
>> Hi All
>>
>> the current memory settings on sctp is as below.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

