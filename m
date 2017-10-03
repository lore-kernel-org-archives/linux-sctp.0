From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 03 Oct 2017 16:46:04 +0000
Subject: Re: [PATCH V2] Fix a sleep-in-atomic bug in shash_setkey_unaligned
Message-Id: <CALCETrVw1=XDOEf_mEN77Lpr1DZnx769RCs1w73JJ2w_9C6-Kg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1506997522-26684-1-git-send-email-baijiaju1990@163.com>
 <CALCETrWdXjTTTywbb3duCEsLYNxkeGx7bf3SM4PYKeErCyiUNQ@mail.gmail.com> <20171003052643.GB22750@gondor.apana.org.au>
In-Reply-To: <20171003052643.GB22750@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andy Lutomirski <luto@kernel.org>, Jia-Ju Bai <baijiaju1990@163.com>, "David S. Miller" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, vyasevich@gmail.com, Kalle Valo <kvalo@codeaurora.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Linux Wireless List <linux-wireless@vger.kernel.org>

On Mon, Oct 2, 2017 at 10:26 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Oct 02, 2017 at 09:18:24PM -0700, Andy Lutomirski wrote:
>> > On Oct 2, 2017, at 7:25 PM, Jia-Ju Bai <baijiaju1990@163.com> wrote:
>> >
>> > The SCTP program may sleep under a spinlock, and the function call path is:
>> > sctp_generate_t3_rtx_event (acquire the spinlock)
>> >  sctp_do_sm
>> >    sctp_side_effects
>> >      sctp_cmd_interpreter
>> >        sctp_make_init_ack
>> >          sctp_pack_cookie
>> >            crypto_shash_setkey
>> >              shash_setkey_unaligned
>> >                kmalloc(GFP_KERNEL)
>>
>> I'm going to go out on a limb here: why on Earth is out crypto API so
>> full of indirection that we allocate memory at all here?
>
> The crypto API operates on a one key per-tfm basis.  So normally
> tfm allocation and key setting is done once only and not done on
> the data path.
>
> I have looked at the SCTP code and it appears to fit this paradigm.
> That is, we should be able to allocate the tfm and set the key when
> the key is actually generated via get_random_bytes, rather than every
> time the key is used which is not only a waste but as you see runs
> into API issues.

It's a waste because it loses a pre-computation advantage.

The fact that it has memory allocation issues is crypto API's fault,
full stop.  There is no legit reason to need to allocate anything.
