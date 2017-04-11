From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 11 Apr 2017 19:36:16 +0000
Subject: Re: SCTP getting EAGAIN but poll or select return socket is writable
Message-Id: <20170411193616.GG911@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <45198365-50CE-456C-8F4A-8BDA672B97F7@lurchi.franken.de>
In-Reply-To: <45198365-50CE-456C-8F4A-8BDA672B97F7@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Apr 11, 2017 at 09:14:52PM +0200, Michael Tuexen wrote:
> > On 11. Apr 2017, at 21:08, Deepak Khandelwal <dazz.87@gmail.com> wrote:
> > 
> > Hi,
> > 
> > I am using 4.4.x kernel.
> > 
> > in context of LKSCTP, what could be the possible reasons that poll or
> > select on fd return false positive events, causing application do
> > write on fd but failed with EAGAIN ?
> I'm just guessing here... What if you can write something, but not
> something big as you try...
> So how big is the message you are trying so send?

That's possible, yes.

Another possibility (and I guess the only other one) is that you're
polling on a socket that has sndbuf available but you're sending a msg
to a peer that requires starting another assoc. If it fails to bind
while creating this new asoc during sendmsg, it will return EAGAIN too.
Like, you created a UDP-style socket, but didn't bind() nor connect(),
and called sendmsg() directly on it. Sendmsg() will do an indirect
bind() but somehow, you're out of ephemeral ports, or something else is
blocking it.

Best regards,
Marcelo

> 
> Best regards
> Michael
> > 
> > 
> > Best Regards,
> > Deepak
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
