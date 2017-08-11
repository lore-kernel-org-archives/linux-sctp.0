From: David Miller <davem@davemloft.net>
Date: Fri, 11 Aug 2017 17:03:49 +0000
Subject: Re: [PATCH net-next 00/14] sctp: remove typedefs from structures part 6
Message-Id: <20170811.100349.419260692188420889.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1502417340.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1502417340.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 11 Aug 2017 10:23:44 +0800

> As we know, typedef is suggested not to use in kernel, even checkpatch.pl
> also gives warnings about it. Now sctp is using it for many structures.
> 
> All this kind of typedef's using should be removed. This patchset is the
> part 6 to remove all typedefs in include/net/sctp/structs.h, command.h
> and sm.h.
> 
> Just as the part 1-5, No any code's logic would be changed in these patches,
> only cleaning up.
> 
> Note that this is the last part for this typedef cleaning up. after this
> patchset, no more inappropriate typedefs in sctp. It's also to tidy some
> codes when removing them, like fixing many indents, reodering some local
> params, especially in the last 2 patches.

Series applied, thanks Xin.
