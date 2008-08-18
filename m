From: Daniel Lezcano <dlezcano@fr.ibm.com>
Date: Mon, 18 Aug 2008 07:21:08 +0000
Subject: Re: [PATCH 2/2] netns: Add network namespace argument in rt6_fill_node()
Message-Id: <48A922E4.1050304@fr.ibm.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48A48722.3050509@hp.com> <48A758F0.60009@fr.ibm.com>
	<20080817.153526.109132408.davem@davemloft.net>
In-Reply-To: <20080817.153526.109132408.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, brian.haley-VXdhtT5mjnY@public.gmane.org
Cc: containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

David Miller wrote:
> From: Daniel Lezcano <dlezcano@fr.ibm.com>
> Date: Sun, 17 Aug 2008 00:47:12 +0200
> 
>> The approach looks correct except with the network namespace passed as 
>> parameter, it must never be NULL.
> 
> You're reviewing the patches that Brian retracted, we added a different
> version of these fixes in the end.

Yes thanks, I received the emails delayed, so I saw the first version 
and no reply to them, neither the V2.
The second version is much better.
Thanks Brian for fixing this :)

   -- Daniel
