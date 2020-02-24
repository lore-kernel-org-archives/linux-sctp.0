From: David Miller <davem@davemloft.net>
Date: Mon, 24 Feb 2020 21:28:47 +0000
Subject: Re: [PATCH 05/30] sctp: Add missing annotation for sctp_transport_walk_start()
Message-Id: <20200224.132847.414576903338334553.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <0/30>
        <20200223231711.157699-1-jbi.octave@gmail.com>
        <20200223231711.157699-6-jbi.octave@gmail.com>
In-Reply-To: <20200223231711.157699-6-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jbi.octave@gmail.com
Cc: boqun.feng@gmail.com, linux-kernel@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>
Date: Sun, 23 Feb 2020 23:16:46 +0000

> Sparse reports a warning at sctp_transport_walk_start()
> 
> warning: context imbalance in sctp_transport_walk_start
> 	- wrong count at exit
> 
> The root cause is the missing annotation at sctp_transport_walk_start()
> Add the missing __acquires(RCU) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Applied.
