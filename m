From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Dec 2012 21:56:15 +0000
Subject: Re: [PATCH] sctp: Change defaults on cookie hmac selection
Message-Id: <CA+55aFyT5b9GmGX0kzMPQG795uojiiWjWxUBBG_-m9bfrThU=Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1355511060-27320-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1355511060-27320-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

On Fri, Dec 14, 2012 at 10:51 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
>
> Tested by myself (allbeit fairly quickly).  All configuration combinations seems
> to work soundly.

Ok, looks good, but I suspect we should also re-introduce the "none"
choice we used to have.

No?

          Linus
