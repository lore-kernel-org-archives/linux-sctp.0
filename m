From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 05 Feb 2018 15:47:39 +0000
Subject: Re: [PATCH net v2] sctp: fix dst refcnt leak in sctp_v4_get_dst
Message-Id: <20180205154739.GB27685@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180205133311.2620-1-tommi.t.rantala@nokia.com>
In-Reply-To: <20180205133311.2620-1-tommi.t.rantala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tommi.t.rantala@nokia.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Alexey Kodanev <alexey.kodanev@oracle.com>

On Mon, Feb 05, 2018 at 03:33:11PM +0200, Tommi Rantala wrote:
> Fix dst reference count leak in sctp_v4_get_dst() introduced in commit
> 410f03831 ("sctp: add routing output fallback"):
> 

Patch LGTM. Will wait the respin for Acking.
Thanks.
