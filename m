From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Tue, 11 Apr 2017 19:14:52 +0000
Subject: Re: SCTP getting EAGAIN but poll or select return socket is writable
Message-Id: <45198365-50CE-456C-8F4A-8BDA672B97F7@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 11. Apr 2017, at 21:08, Deepak Khandelwal <dazz.87@gmail.com> wrote:
> 
> Hi,
> 
> I am using 4.4.x kernel.
> 
> in context of LKSCTP, what could be the possible reasons that poll or
> select on fd return false positive events, causing application do
> write on fd but failed with EAGAIN ?
I'm just guessing here... What if you can write something, but not
something big as you try...
So how big is the message you are trying so send?

Best regards
Michael
> 
> 
> Best Regards,
> Deepak
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

