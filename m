From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 10 Aug 2018 18:29:51 +0000
Subject: Re: [PATCH lksctp-tools] travis: use git instead of downloading tarballs
Message-Id: <20180810182951.GC5311@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <61414c1f14e60615bd2c2235dca6797baa1c0783.1533141162.git.marcelo.leitner@gmail.com>
In-Reply-To: <61414c1f14e60615bd2c2235dca6797baa1c0783.1533141162.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Aug 01, 2018 at 01:33:05PM -0300, Marcelo Ricardo Leitner wrote:
> With this, we 1) avoid downloading several tarballs and 2) make it
> easier to test against Linus master.
> 
> We want to test against Linus master so can catch build errors before
> GA, like the one fixed by Xin's patches in the sequence.
> 
> Sample build: https://travis-ci.org/sctp/lksctp-tools/builds/410860154

Applied
