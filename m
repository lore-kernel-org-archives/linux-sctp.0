From: Sun Paul <paulrbk@gmail.com>
Date: Thu, 18 Jun 2015 17:52:06 +0000
Subject: Re: NO TCB to Destory
Message-Id: <CAFXGftKHXWfB9YBLJj6usLfKeTS3pCXd5XYuMYcejYj9kOe19A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+hN7KOqGVWqa1xn0dKNJNarc65YYYFiLnSn7CMYarLHA@mail.gmail.com>
In-Reply-To: <CAFXGft+hN7KOqGVWqa1xn0dKNJNarc65YYYFiLnSn7CMYarLHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

The version I used is 1.0.10

lksctp-tools-doc-1.0.10-7.el6.x86_64
lksctp-tools-1.0.10-7.el6.x86_64
lksctp-tools-devel-1.0.10-7.el6.x86_64


can you direct me on where I can get more information on the patch and
where to download it?

Thanks

- paul

On Thu, Jun 18, 2015 at 11:17 PM, Gomonovych, Vasyl (Nokia -
PL/Wroclaw) <vasyl.gomonovych@nokia.com> wrote:
>
> Hello.
>
> I do not know which version you use.
> But I observe similar issue and in my case
> it was problem with sk_ack_backlog
> sctp-Fix-sk_ack_backlog-wrap-around-problem.patch
>
> With best regards Vasyl.
>
>
> ________________________________________
> From: linux-sctp-owner@vger.kernel.org [linux-sctp-owner@vger.kernel.org] on behalf of ext Daniel Borkmann [daniel@iogearbox.net]
> Sent: Thursday, June 18, 2015 4:30 PM
> To: Sun Paul
> Cc: linux-sctp@vger.kernel.org
> Subject: Re: NO TCB to Destory
>
> On 06/18/2015 12:20 PM, Sun Paul wrote:
>> Hi
>>
>> I suffered a case on a SCTP connection.
>>
>> HOST A sends INIT chunk to HOST B
>> HOST B returns INIT_ACK chunk back to HOST A
>> HOST A sends COOKIE_ECHO chunk to HOST B
>> HOST B then send ABORT chunk with T-bit set to 1.
>>
>> Any idea on why ABORT chunk is sent out?
>
> Do you have a reliable, minimal reproducer?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
