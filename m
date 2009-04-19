From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sun, 19 Apr 2009 00:02:20 +0000
Subject: Re: unused SCTP config var SCTP_HMAC_NONE?
Message-Id: <49EA6A0C.1010503@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <alpine.LFD.2.00.0904180908170.499@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904180908170.499@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Robert P. J. Day wrote:
> === SCTP_HMAC_NONE
> net/sctp/Kconfig:68:config SCTP_HMAC_NONE
> 
>   nothing seems to refer to that.
> 

This has been there since the beginning.  My guess is that it's for
testing only.  This allows SCTP to not compute an hmac over the cookie
and thus skip cookie verification.  It's not really useful for production
systems, but it might be useful during test.

-vlad

> rday
> --
> 
> ====================================
> Robert P. J. Day                               Waterloo, Ontario, CANADA
> 
>         Linux Consulting, Training and Annoying Kernel Pedantry.
> 
> Web page:                                          http://crashcourse.ca
> Linked In:                             http://www.linkedin.com/in/rpjday
> Twitter:                                       http://twitter.com/rpjday
> ====================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

