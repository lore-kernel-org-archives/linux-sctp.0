From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 21 Feb 2017 19:54:31 +0000
Subject: Re: [PATCH 4.4 14/20] sctp: avoid BUG_ON on sctp_wait_for_sndbuf
Message-Id: <CAFSqH7zB7CkVXqZZO8_WWhhtmhN5wtBxkrwcPrSgDXJ4CUeWSQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170216175259.514980415@linuxfoundation.org> <20170216175300.120096888@linuxfoundation.org>
 <1487693324.2885.17.camel@decadent.org.uk> <210C5D26-C634-41E0-B744-1A7FA2AC157D@gmail.com>
In-Reply-To: <210C5D26-C634-41E0-B744-1A7FA2AC157D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ben Hutchings <ben@decadent.org.uk>, Alexander Popov <alex.popov@linux.com>, Xin Long <lucien.xin@gmail.com>
Cc: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org

On Tue, Feb 21, 2017 at 1:56 PM, Marcelo <marcelo.leitner@gmail.com> wrote:
>
>
> Em 21 de fevereiro de 2017 13:08:44 BRT, Ben Hutchings <ben@decadent.org.uk> escreveu:
>>On Thu, 2017-02-16 at 09:53 -0800, Greg Kroah-Hartman wrote:
>>> 4.4-stable review patch.  If anyone has any objections, please let me
>>know.
>>>
>>> ------------------
>>>
>>> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>>>
>>>
>>> [ Upstream commit 2dcab598484185dea7ec22219c76dcdd59e3cb90 ]
>>[...]
>>> --- a/net/sctp/socket.c
>>> +++ b/net/sctp/socket.c
>>> @@ -6960,7 +6960,8 @@ static int sctp_wait_for_sndbuf(struct s
>>>               */
>>>              release_sock(sk);
>>>              current_timeo = schedule_timeout(current_timeo);
>>> -            BUG_ON(sk != asoc->base.sk);
>>> +            if (sk != asoc->base.sk)
>>> +                    goto do_error;
>>
>>This function normally returns with sk still locked, but in this case
>>it returns with sk unlocked.  Perhaps this check should be moved after
>>the lock_sock(sk)?
>>
>
> Looks like so. Will check more in a few. Thanks Ben

Yes, we need to move the check to after the lock_sock(sk) call.

There is also another problem: consider a thread A sending a packet to
a new asoc (which creates a new asoc during sctp_sendsmg), and while
waiting for more sndbuf space, it gets peeled off by another thread.
This would cause a double-free of the asoc as sctp_sendmsg() will free
this asoc thinking it errored out but it actually now belongs to
another thread.

Testing both patches now, should be ready by tomorrow.

  Marcelo

>
>>Ben.
>>
>>>              lock_sock(sk);
>>>
>>>              *timeo_p = current_timeo;
>>>
>>>
>
> --
> Enviado de meu dispositivo Android com K-9 mail. Desculpe-me pela brevidade.
