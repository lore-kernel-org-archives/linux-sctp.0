From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 19 Aug 2016 09:28:37 +0000
Subject: Re: [PATCH net v2] sctp: linearize early if it's not GSO
Message-Id: <20160819092837.GH3110@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <c333cd2ab2c828577251c6f75a3cc5e5f3683eb8.1471542789.git.marcelo.leitner@gmail.com>
In-Reply-To: <c333cd2ab2c828577251c6f75a3cc5e5f3683eb8.1471542789.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

On Thu, Aug 18, 2016 at 05:46:37PM -0300, Marcelo Ricardo Leitner wrote:
> Because otherwise when crc computation is still needed it's way more
> expensive than on a linear buffer to the point that it affects
> performance.

Please ignore the 2nd copy (same MessageId). I thought it got lost
somehow and sent it again.

