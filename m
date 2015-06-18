From: Daniel Borkmann <daniel@iogearbox.net>
Date: Thu, 18 Jun 2015 14:30:18 +0000
Subject: Re: NO TCB to Destory
Message-Id: <5582D5FA.2050000@iogearbox.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+hN7KOqGVWqa1xn0dKNJNarc65YYYFiLnSn7CMYarLHA@mail.gmail.com>
In-Reply-To: <CAFXGft+hN7KOqGVWqa1xn0dKNJNarc65YYYFiLnSn7CMYarLHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 06/18/2015 12:20 PM, Sun Paul wrote:
> Hi
>
> I suffered a case on a SCTP connection.
>
> HOST A sends INIT chunk to HOST B
> HOST B returns INIT_ACK chunk back to HOST A
> HOST A sends COOKIE_ECHO chunk to HOST B
> HOST B then send ABORT chunk with T-bit set to 1.
>
> Any idea on why ABORT chunk is sent out?

Do you have a reliable, minimal reproducer?
