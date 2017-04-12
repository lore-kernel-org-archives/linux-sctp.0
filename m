From: Deepak Khandelwal <dazz.87@gmail.com>
Date: Wed, 12 Apr 2017 02:50:20 +0000
Subject: Re: SCTP getting EAGAIN but poll or select return socket is writable
Message-Id: <CAOci8d+VCCj+9dpVuGG1yyNPToPKbwZfG8d2F3mKiRARUO7j2A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <45198365-50CE-456C-8F4A-8BDA672B97F7@lurchi.franken.de>
In-Reply-To: <45198365-50CE-456C-8F4A-8BDA672B97F7@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Apr 12, 2017 at 3:21 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Wed, Apr 12, 2017 at 01:54:41AM +0530, Deepak Khandelwal wrote:
>> Hi,
>>
>
> Please don't top post..
>
>>
>> App act as client (1-1 Style SOCK_STREAM)
>> App try to send 278 bytes of message.
>
> Okay.
>
>>
>> So you mean that, if socket has space for few bytes (say 1 or 2
>> bytes), lksctp will set POLLOUT event for fd,
>> but since user application doesn;t know the underlying socket space
>> available, it can write more than that but will fail with EAGAIN ?
>
> Was reading the code again on this, I actually don't think this can
> happen. The sleep on waiting for sndbuf doesn't check for msgsize, just
> if there is any amount of buffer available or not.
>
> sctp_sendmsg()
> {
> ...
>         timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
>         if (!sctp_wspace(asoc)) {
>                 err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
>                 if (err)
>                         goto out_free;
>         }
> ...
> }
>
> For returning -EAGAIN due to sndbuf, it has to match !sctp_wspace, which
> is only about the soc/asoc and not the message. The EAGAIN in this case
> comes from inside sctp_wait_for_sndbuf().
>

So then it means that message written to fd is over committed and not
honoring socket send buffer space limits ?
and now next time when APP does POLL, it will not return POLLOUT event
for the fd,
because now there will be negative buffer space, due to over commit last time.

so in all APP shouldn't have got this EAGAIN error anytime (due to
over commit allowed atmost once)



> That leads us to my other question, are you binding/connecting this
> socket before sending the message?
>


yes i am doing bind/connect and then checking pullout events returned
by poll on that fd, before sending the message or writing to that fd.


>>
>>
>> Best Regards,
>> Deepak
>>
>> On Wed, Apr 12, 2017 at 12:44 AM, Michael Tuexen
>> <Michael.Tuexen@lurchi.franken.de> wrote:
>> >> On 11. Apr 2017, at 21:08, Deepak Khandelwal <dazz.87@gmail.com> wrote:
>> >>
>> >> Hi,
>> >>
>> >> I am using 4.4.x kernel.
>> >>
>> >> in context of LKSCTP, what could be the possible reasons that poll or
>> >> select on fd return false positive events, causing application do
>> >> write on fd but failed with EAGAIN ?
>> > I'm just guessing here... What if you can write something, but not
>> > something big as you try...
>> > So how big is the message you are trying so send?
>> >
>> > Best regards
>> > Michael
>> >>
>> >>
>> >> Best Regards,
>> >> Deepak
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
