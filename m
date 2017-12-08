From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 17:37:14 +0000
Subject: Re: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <CADvbK_dvEmGr9N_-qGW1gqBXZO7snxv0f8vZM2vZKYcCptqbEQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com> <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com> <20171208145630.GE3328@localhost.localdomain>
 <20171208153734.GB6955@hmswarspite.think-freely.org> <20171208160001.GF3328@localhost.localdomain>
 <CADvbK_ckOgH9vzXVzckEtWAkJaYn9wuhJtZ+qpzep2T6C8Wung@mail.gmail.com>
 <27aff622f1574b329e18ba21922f6e7e@AcuMS.aculab.com> <CADvbK_ct1cGSFZ68RaTh8=T6-Z8v0nFSruMti-L2fA393ti9pA@mail.gmail.com>
 <b727ce7a5f8746219987775dab5d1e1a@AcuMS.aculab.com>
In-Reply-To: <b727ce7a5f8746219987775dab5d1e1a@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>

On Sat, Dec 9, 2017 at 1:29 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Xin Long ...
>> Hi, David, Sorry,  I'm not sure we're worrying about the cpu cost or
>> codes style now ?
>>
>> For cpu cost,  I think 0x848(%r13) operation must be better than the
>> generated code of if-else.
>
> Nope - the call xxx(%ryyy) is likely to be a data cache miss and a complete
> cpu pipeline stall.
>
> The conditional will be a data cache hit and the code (for one branch)
> will be prefetched and speculatively executed.
>
> Some very modern cpu might manage to predict indirect jumps, but for
> most it is a full pipeline stall.
Thanks for the CPU information.

The thing is with if-else can't avoid xxx(%ryyy) in this case, as Marcelo
said above. It seems if-else will just be a extra cost compare to this one.
