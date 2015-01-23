From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 23 Jan 2015 19:05:38 +0000
Subject: Re: Question on SCTP ABORT chunk is generated when the association_max_retrans is reached
Message-Id: <54C29B82.7090502@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com> <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com> <54C23581.9060809@redhat.com> <54C27137.5010405@gmail.com> <54C2807E.8080607@redhat.com> <8BBFBEE6-FA34-4190-BFCB-AB6BEC093774@fh-muenster.de>
In-Reply-To: <8BBFBEE6-FA34-4190-BFCB-AB6BEC093774@fh-muenster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Tuexen <tuexen@fh-muenster.de>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Sun Paul <paulrbk@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On 01/23/2015 07:36 PM, Michael Tuexen wrote:
...
> Yepp. It might not reach the peer or it might. If it does it helps
> to keep the states in sync. If it doesn't it sometimes helps in
> analysing tracefiles. In BSD, we also send it. It is not required,
> doesn't harm and is useful in some cases...

Ok, as the TCB is destroyed in any case, should be fine then.

Thanks,
Daniel
