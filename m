From: David Miller <davem@davemloft.net>
Date: Fri, 27 Apr 2018 18:42:13 +0000
Subject: Re: [PATCH net-next 00/13] sctp: refactor MTU handling
Message-Id: <20180427.144213.1823377521178882809.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, lucien.xin@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 16:58:49 -0300

> Currently MTU handling is spread over SCTP stack. There are multiple
> places doing same/similar calculations and updating them is error prone
> as one spot can easily be left out.
> 
> This patchset converges it into a more concise and consistent code. In
> general, it moves MTU handling from functions with bigger objectives,
> such as sctp_assoc_add_peer(), to specific functions.
> 
> It's also a preparation for the next patchset, which removes the
> duplication between sctp_make_op_error_space and
> sctp_make_op_error_fixed and relies on sctp_mtu_payload introduced here.
> 
> More details on each patch.

Series applied, thanks!
