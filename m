From: David Miller <davem@davemloft.net>
Date: Wed, 25 Oct 2017 03:02:41 +0000
Subject: Re: [PATCH] net: sctp: Convert timers to use timer_setup()
Message-Id: <20171025.120241.829185567247781597.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171024084531.GA23722@beast>
In-Reply-To: <20171024084531.GA23722@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: keescook@chromium.org
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Tue, 24 Oct 2017 01:45:31 -0700

> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-sctp@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied.
