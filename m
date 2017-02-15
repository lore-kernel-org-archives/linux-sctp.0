From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 15 Feb 2017 14:17:56 +0000
Subject: Re: [PATCH net-next] sctp: change to use uint<size>_t in uapi sctp.h
Message-Id: <20170215141756.GA24734@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <05fb9cd9aed85d33cc8d635a18b0dcd3e7c0ff29.1487060628.git.lucien.xin@gmail.com>
 <20170214.112604.827348279100654183.davem@davemloft.net>
In-Reply-To: <20170214.112604.827348279100654183.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com

On Tue, Feb 14, 2017 at 11:26:04AM -0500, David Miller wrote:
> From: Xin Long <lucien.xin@gmail.com>
> Date: Tue, 14 Feb 2017 16:23:48 +0800
> 
> > All structures in uapi sctp.h are exported for userspace, their members'
> > types should use uint<size>_t instead of __u<size>.
> 
> This is not true.
> 
> __u<size> is in fact preferred for userspace exported datastructures.
> 

I'll admit that I can never remember which is which, but the files in uapi seem
pretty evenly split between the two types, and I always thought the uint<size>_t
was the one meant for user space

Neil

