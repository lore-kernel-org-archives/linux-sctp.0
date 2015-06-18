From: Daniel Borkmann <daniel@iogearbox.net>
Date: Thu, 18 Jun 2015 19:08:24 +0000
Subject: Re: NO TCB to Destory
Message-Id: <55831728.3010507@iogearbox.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+hN7KOqGVWqa1xn0dKNJNarc65YYYFiLnSn7CMYarLHA@mail.gmail.com>
In-Reply-To: <CAFXGft+hN7KOqGVWqa1xn0dKNJNarc65YYYFiLnSn7CMYarLHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 06/18/2015 08:02 PM, Sun Paul wrote:
> Is it an update of lksctp can help? or I should need to patch the kernel?

https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/net/=
sctp?id=D3217b15a19a4779c39b212358a5c71d725822ee

Afaik, that's part of RHEL7, so you might need to check if your kernel
already includes that. If so, then there's likely a different bug else
where. But as I asked already, do you have a reliable, stand-alone
reproducer for this issue?

Thanks,
Daniel

> On Fri, Jun 19, 2015 at 1:52 AM, Sun Paul <paulrbk@gmail.com> wrote:
>> Hello,
>>
>> The version I used is 1.0.10
>>
>> lksctp-tools-doc-1.0.10-7.el6.x86_64
>> lksctp-tools-1.0.10-7.el6.x86_64
>> lksctp-tools-devel-1.0.10-7.el6.x86_64
>>
>>
>> can you direct me on where I can get more information on the patch and
>> where to download it?
>>
>> Thanks
>>
>> - paul
>>
>> On Thu, Jun 18, 2015 at 11:17 PM, Gomonovych, Vasyl (Nokia -
>> PL/Wroclaw) <vasyl.gomonovych@nokia.com> wrote:
>>>
>>> Hello.
>>>
>>> I do not know which version you use.
>>> But I observe similar issue and in my case
>>> it was problem with sk_ack_backlog
>>> sctp-Fix-sk_ack_backlog-wrap-around-problem.patch
>>>
>>> With best regards Vasyl.
>>>
>>>
>>> ________________________________________
>>> From: linux-sctp-owner@vger.kernel.org [linux-sctp-owner@vger.kernel.or=
g] on behalf of ext Daniel Borkmann [daniel@iogearbox.net]
>>> Sent: Thursday, June 18, 2015 4:30 PM
>>> To: Sun Paul
>>> Cc: linux-sctp@vger.kernel.org
>>> Subject: Re: NO TCB to Destory
>>>
>>> On 06/18/2015 12:20 PM, Sun Paul wrote:
>>>> Hi
>>>>
>>>> I suffered a case on a SCTP connection.
>>>>
>>>> HOST A sends INIT chunk to HOST B
>>>> HOST B returns INIT_ACK chunk back to HOST A
>>>> HOST A sends COOKIE_ECHO chunk to HOST B
>>>> HOST B then send ABORT chunk with T-bit set to 1.
>>>>
>>>> Any idea on why ABORT chunk is sent out?
>>>
>>> Do you have a reliable, minimal reproducer?
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

