From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 31 Jul 2018 18:00:53 +0000
Subject: Re: [PATCH v2] travis: add support for building against Linus master
Message-Id: <20180731180053.GE5482@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <2220f27a907e8761cf274b92a5d7568e178f1fca.1533059016.git.marcelo.leitner@gmail.com>
In-Reply-To: <2220f27a907e8761cf274b92a5d7568e178f1fca.1533059016.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jul 31, 2018 at 02:44:11PM -0300, Marcelo Ricardo Leitner wrote:
> So we can catch build errors before GA.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> 
> v2: use unzip -q, otherwise it lists all unpacked files.

Hmpf, please disregard this. Seems unzip can't handle it and I'll have
to switch to git already.
https://travis-ci.org/sctp/lksctp-tools/jobs/410444855

