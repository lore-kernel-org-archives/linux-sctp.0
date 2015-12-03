From: Julien Pourtet <j.pourtet@gmail.com>
Date: Thu, 03 Dec 2015 19:03:52 +0000
Subject: Re: Not receiving SCTP_SHUTDOWN_COMP notifications
Message-Id: <CAJRTQvxEP5cp-T5SnwbLnoFD2zuJ_HotOWS1NBS1oPCy+aPYAQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJRTQvywGjd87nbug80Xw0LPv0HUGSRp5zP_vu9-omHsh+kROQ@mail.gmail.com>
In-Reply-To: <CAJRTQvywGjd87nbug80Xw0LPv0HUGSRp5zP_vu9-omHsh+kROQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

On Thu, Dec 3, 2015 at 4:18 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> That's pretty much the thing.. when you did shutdown(SHUT_RDWR), you set
> that RCV_SHUTDOWN flag. You told the sockets layer that you don't want
> to receive anything else from this fd.
>
> Please change that SHUT_RDWR to just SHUT_WR and see how it goes.

Duh! Alright, it works fine with SHUT_WR. I was so focused on the
transport layer that it didn't occur to me that SHUT_RDWR was what was
setting the RCV_SHUTDOWN flag on the socket. Sorry about that.

> For one-to-many, there is also this possibility:
> https://tools.ietf.org/html/rfc6458#section-3.2
> To shut down the association gracefully, the user must call sendmsg()
> with no data and with the SCTP_EOF flag set as described in
> Section 5.3.4.  The function returns immediately, and completion of
> the graceful shutdown is indicated by an SCTP_ASSOC_CHANGE
> notification of type SCTP_SHUTDOWN_COMP (see Section 6.1.1).  Note
> that this can also be done using the sctp_sendv() call described in
> Section 9.12."
>
> in case you're intestered. (This cannot be used with
> one-to-one/tcp-style)

Thanks for the clarification about one-to-many. Definitely helpful.

>> Question is, is this a bug? Should we fix it?
>
> Nope :)

Indeed ;) Thank you very much for your time.

Julien
