From: David Miller <davem@davemloft.net>
Date: Tue, 10 Mar 2020 01:09:49 +0000
Subject: Re: [PATCH net] sctp: return a one-to-one type socket when doing peeloff
Message-Id: <20200309.180949.633904935953558472.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
In-Reply-To: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, jere.leppanen@nokia.com, michael.tuexen@lurchi.franken.de

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  2 Mar 2020 14:57:15 +0800

> As it says in rfc6458#section-9.2:
> 
>   The application uses the sctp_peeloff() call to branch off an
>   association into a separate socket.  (Note that the semantics are
>   somewhat changed from the traditional one-to-one style accept()
>   call.)  Note also that the new socket is a one-to-one style socket.
>   Thus, it will be confined to operations allowed for a one-to-one
>   style socket.
> 
> Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
> on which some operations are not allowed, like shutdown, as Jere
> reported.
> 
> This patch is to change it to return a one-to-one type socket instead.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Leppanen, Jere (Nokia - FI/Espoo) <jere.leppanen@nokia.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

I don't know what to do with this patch.

There seems to be some discussion about a potential alternative approach
to the fix, but there were problems with that suggestion.

Please advise, thank you.
