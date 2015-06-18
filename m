From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Date: Thu, 18 Jun 2015 12:57:15 +0000
Subject: Re: NO TCB to Destory
Message-Id: <20150618125715.GC4062@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+hN7KOqGVWqa1xn0dKNJNarc65YYYFiLnSn7CMYarLHA@mail.gmail.com>
In-Reply-To: <CAFXGft+hN7KOqGVWqa1xn0dKNJNarc65YYYFiLnSn7CMYarLHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jun 18, 2015 at 06:20:42PM +0800, Sun Paul wrote:
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

Hi,

I have reports of this too, specially on load times, but the cause is
still an unknown..

  Marcelo

