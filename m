From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 24 Aug 2018 12:42:13 +0000
Subject: Re: [PATCH lksctp-tools] build: fix netinet/sctp.h not to be installed
Message-Id: <20180824124213.GK5311@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <16d4fc6998450e9aba61259a1ee4869df841cc6c.1535044412.git.lucien.xin@gmail.com>
In-Reply-To: <16d4fc6998450e9aba61259a1ee4869df841cc6c.1535044412.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Aug 24, 2018 at 01:13:32AM +0800, Xin Long wrote:
> After libcnetinet_HEADERS was set to sctp.h.in, netinet/sctp.h can
> no longer be installed into ${includedir}.
> 
> Since "AC_CONFIG_HEADERS([src/include/netinet/sctp.h])" is already
> added into configure.ac, there's no need to generate sctp.h by
> automake.
> 
> So we simply set libcnetinet_HEADERS back to sctp.h.
> 
> Fixes: 9607dd85e70a ("netinet/sctp.h: dynamically build based on system setup")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks Xin.
