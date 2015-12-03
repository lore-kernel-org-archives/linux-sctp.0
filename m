From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 03 Dec 2015 12:18:58 +0000
Subject: Re: Not receiving SCTP_SHUTDOWN_COMP notifications
Message-Id: <20151203121858.GA4164@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJRTQvywGjd87nbug80Xw0LPv0HUGSRp5zP_vu9-omHsh+kROQ@mail.gmail.com>
In-Reply-To: <CAJRTQvywGjd87nbug80Xw0LPv0HUGSRp5zP_vu9-omHsh+kROQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

On Mon, Nov 30, 2015 at 03:41:13PM -0800, Julien Pourtet wrote:
> My "tweak" for the client app is using a one-to-one socket
> (SOCK_STREAM) instead of one-to-many. I also perform a
> shutdown(SHUT_RDWR) before close() is called, as well as a recvmsg()
> [get_reply() in that code base semantics] to receive the notifications
> before closing the file descriptor.
> 
> Commenting out the following lines in ulpqueue.c does get the
> notifications delivered to the client app:
>          /* If the socket is just going to throw this away, do not
>           * even try to deliver it.
>           */
>          if (sock_flag(sk, SOCK_DEAD) || (sk->sk_shutdown & RCV_SHUTDOWN))
>                  goto out_free;

That's pretty much the thing.. when you did shutdown(SHUT_RDWR), you set
that RCV_SHUTDOWN flag. You told the sockets layer that you don't want
to receive anything else from this fd.

Please change that SHUT_RDWR to just SHUT_WR and see how it goes.

For one-to-many, there is also this possibility:
https://tools.ietf.org/html/rfc6458#section-3.2
To shut down the association gracefully, the user must call sendmsg()
with no data and with the SCTP_EOF flag set as described in
Section 5.3.4.  The function returns immediately, and completion of
the graceful shutdown is indicated by an SCTP_ASSOC_CHANGE
notification of type SCTP_SHUTDOWN_COMP (see Section 6.1.1).  Note
that this can also be done using the sctp_sendv() call described in
Section 9.12."

in case you're intestered. (This cannot be used with
one-to-one/tcp-style)

> However, I guess that's not a viable solution as this may have
> undesirable side-effects (I am not familiar with this code base). It
> was more of a sanity check for me.

I think that with the above explanation you can see the effects it would
have.

> Question is, is this a bug? Should we fix it?

Nope :)

> [Note: it's my first time writing to this ML, sorry if I am breaking
> any implicit rules or explicit conventions].

It's all good, just sorry for the delay.

  Marcelo
