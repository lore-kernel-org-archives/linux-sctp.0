From: Sun Paul <paulrbk@gmail.com>
Date: Mon, 26 Jan 2015 01:27:10 +0000
Subject: Re: Question on SCTP ABORT chunk is generated when the association_max_retrans is reached
Message-Id: <CAFXGft+XZCmhuwj2QTCiU0MD10Uo+WZ3WCC+rfbsd_Lxbhk3iw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com>
	<CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com>
	<54C23581.9060809@redhat.com>
	<54C27137.5010405@gmail.com>
	<54C2807E.8080607@redhat.com>
	<8BBFBEE6-FA34-4190-BFCB-AB6BEC093774@fh-muenster.de>
	<54C29B82.7090502@redhat.com>
In-Reply-To: <54C29B82.7090502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Michael Tuexen <tuexen@fh-muenster.de>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hi

sorry for the late reply. I am a bit confused. when side-A sends a
request to side-B, and side-B return the response, but side-A keep
re-transmit the same request to side-B, why side-B needed to send a
ABORT to side-A?

If it is used in order to reestablish the connection, shoudn't it
should be side-A to send ABORT instead?

- PS

On Sat, Jan 24, 2015 at 3:05 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 01/23/2015 07:36 PM, Michael Tuexen wrote:
> ...
>>
>> Yepp. It might not reach the peer or it might. If it does it helps
>> to keep the states in sync. If it doesn't it sometimes helps in
>> analysing tracefiles. In BSD, we also send it. It is not required,
>> doesn't harm and is useful in some cases...
>
>
> Ok, as the TCB is destroyed in any case, should be fine then.
>
> Thanks,
> Daniel
