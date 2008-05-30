From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 30 May 2008 17:10:55 +0000
Subject: Re: receiver window questions
Message-Id: <4840351F.1000908@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <483EC663.1070805@hp.com>
In-Reply-To: <483EC663.1070805@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Michael Tuexen wrote:
> Hi Vlad,
> 
> is there any description available how the auto-tuning works?

There is no formal writeup.  In short it works the same as TCP.

Essentially, we start out with a set buffer space and calculated
rwnd.  Then as buffer space and window is consumed, we see if
buffer space is consumed faster then rwnd.  If we reach a point
where default buffer space is consumed, but rwnd is not, we
grow the buffer space slowly up to the next threshold, thus allowing
all of rwnd to be consumed.

There is also a system-wide threshold that we look at when growing
the buffer.   So that if the system is experiencing memory pressure
conditions, the growth and allocations will fail.

> But even with auto-tuning you still have the a_rwnd you report
> to the outside world (in SACKs) and an internal value which
> you use for tracking you buffer, right?

Buffer space tracking is separate from rwnd and a_rwnd that we
advertise.

-vlad

> 
> Best regards
> Michael
> 

