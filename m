From: David Miller <davem@davemloft.net>
Date: Thu, 13 Dec 2018 00:06:09 +0000
Subject: Re: [PATCHv2 net 0/3] net: add support for flex_array_resize in flex_array
Message-Id: <20181212.160609.1564345085630799191.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1544163962.git.lucien.xin@gmail.com>
        <20181211.225000.726755542677275663.davem@davemloft.net>
        <20181212120015.GA7637@hmswarspite.think-freely.org>
In-Reply-To: <20181212120015.GA7637@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: lucien.xin@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, dave.hansen@linux.intel.com, rientjes@google.com, eparis@redhat.com, khorenko@virtuozzo.com

From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 12 Dec 2018 07:00:15 -0500

> I suggest xin respond to messageid
> 20180523011821.12165-6-kent.overstreet@gmail.com> and send a NAK,
> indicating that his patch seems like it will break the build, as,
> looking through it, it never removes flex_array calls from the sctp
> code.  If kent reposts with a conversion of the sctp code to radix
> trees, we're done.  If not, you can move forward with this commit.

Ok, Xin please do that so we can more forward.

Thanks Neil.
