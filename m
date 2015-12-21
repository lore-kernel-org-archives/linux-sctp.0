From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 21 Dec 2015 09:56:15 +0000
Subject: Re: [PATCH net] sctp: sctp should release assoc when sctp_make_abort_user return NULL in sctp_close
Message-Id: <CADvbK_fWOErVv6EM5R5jstZSXscqK_-K+wvTLdb4DYv6+MTuSg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48cc5cc3af81404dffc6121f075c05e6b8c5171c.1450362652.git.lucien.xin@gmail.com>
	<5672FF06.2030803@gmail.com>
	<5673067B.6080001@gmail.com>
	<56730E1F.2090003@gmail.com>
	<5674136E.6050104@gmail.com>
	<20151218162357.GB5050@mrl.redhat.com>
In-Reply-To: <20151218162357.GB5050@mrl.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevic@redhat.com>, davem <davem@davemloft.net>

On Sat, Dec 19, 2015 at 12:23 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Fri, Dec 18, 2015 at 09:08:46AM -0500, Vlad Yasevich wrote:
>> On 12/17/2015 02:33 PM, Vlad Yasevich wrote:
>> > On 12/17/2015 02:01 PM, Marcelo Ricardo Leitner wrote:
> ...
>> >> There is a check on sctp_cmd_delete_tcb() that avoids calling that on temp assocs on
>> >> listening sockets, but that condition is false due to the check on sk_shutdown so it will
>> >> call those two functions anyway.
>> >
>> > The condition I am a bit concerned about is one thread waiting in sctp_wait_for_sndbuf
>> > while another does an abort.
>> >
>> > I think this is OK though.  I need to look a bit more...
>>
>> I think the only time this ends up biting us is if SO_SNDTIMEO was used and we ran out
>> of send buffer.  It looks to me like schedule_timeout() will wait until timer expired and
>> depending on the timer value, you could wait quite a while.
>>
>> With this path, since you don't transition state, the asoc->wait wait queue is never
>> notified and it could be hanging around for quite a while.

do you think it makes sense if we have this condition judgment there ?
        if (waitqueue_active(&asoc->wait))
            wake_up_interruptible(&asoc->wait);


>
> Yes, agreed. For blocking sockets, it could hang waiting until the
> application finally closes. Thanks Vlad.
>
>   Marcelo
>
