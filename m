From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 10 Apr 2008 19:55:53 +0000
Subject: Re: [PATCH 2/5] [SCTP]: "list_for_each()" -> "list_for_each_entry()"
Message-Id: <47FE70C9.3070009@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1207856394-19321-1-git-send-email-vladislav.yasevich@hp.com> <1207856394-19321-3-git-send-email-vladislav.yasevich@hp.com> <alpine.LFD.1.00.0804101545570.24254@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.00.0804101545570.24254@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, netdev@vger.kernel.org

Robert P. J. Day wrote:
>   actually, if i remember correctly, davem rejected that change as
> being too disruptive at the moment, no?
> 
> rday
> --
> 
> ====================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry:
>     Have classroom, will lecture.
> 
> http://crashcourse.ca                          Waterloo, Ontario, CANADA
> ====================================
> 

this is for 2.6.26, which should be fine.  it was too disruptive for net.26.

-vlad
