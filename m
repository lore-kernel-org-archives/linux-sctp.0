From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 17:23:30 +0000
Subject: Re: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <CADvbK_ct1cGSFZ68RaTh8=T6-Z8v0nFSruMti-L2fA393ti9pA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com> <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com> <20171208145630.GE3328@localhost.localdomain>
 <20171208153734.GB6955@hmswarspite.think-freely.org> <20171208160001.GF3328@localhost.localdomain>
 <CADvbK_ckOgH9vzXVzckEtWAkJaYn9wuhJtZ+qpzep2T6C8Wung@mail.gmail.com> <27aff622f1574b329e18ba21922f6e7e@AcuMS.aculab.com>
In-Reply-To: <27aff622f1574b329e18ba21922f6e7e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>

On Sat, Dec 9, 2017 at 12:22 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Xin Long
>> Sent: 08 December 2017 16:18
>>
> ...
>> >> Alternatively you could preform the dereference in two steps (i.e. declare an si
>> >> pointer on the stack and set it equal to asoc->stream.si, then deref
>> >> si->make_datafrag at call time.  That will at least give the compiler an
>> >> opportunity to preload the first pointer.
>
> You want to save the function pointer itself.
>
> ...
>> Another small difference:
>>   as you can see, comparing to (X), (Y) is using 0x28(%rsp) in the loop,
>>   instead of %r13.
>>
>> So that's what I can see from the related generated code.
>> If 0x848(%r13) is not worse than 0x28(%rsp) for cpu, I think
>> asoc->stream.si->make_datafrag() is even better. No ?
>
> That code must have far too many life local variables.
> Otherwise there's be a caller saved register available.
>
Hi, David, Sorry,  I'm not sure we're worrying about the cpu cost or
codes style now ?

For cpu cost,  I think 0x848(%r13) operation must be better than the
generated code of if-else.

For the codes style, comparing to the if-else, I think this one is
more readable. (ignore extendible stuff first, as probably no more
new type of data chunk).
