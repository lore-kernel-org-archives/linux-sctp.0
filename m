From: David Miller <davem@davemloft.net>
Date: Thu, 14 Apr 2016 03:05:32 +0000
Subject: Re: [PATCH v3 0/2] sctp: delay calls to sk_data_ready() as much as possible
Message-Id: <20160413.230532.676746231426161126.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1460144373.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1460144373.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, David.Laight@ACULAB.COM, jkbs@redhat.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri,  8 Apr 2016 16:41:26 -0300

> 1st patch is a preparation for the 2nd. The idea is to not call
> ->sk_data_ready() for every data chunk processed while processing
> packets but only once before releasing the socket.
> 
> v2: patchset re-checked, small changelog fixes
> v3: on patch 2, make use of local vars to make it more readable

Applied to net-next, but isn't this reduced overhead coming at the
expense of latency?  What if that lower latency is important to the
application and/or consumer?
