From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 03 Jul 2017 20:29:08 +0000
Subject: Re: [PATCH v2] lksctp-tools: Add sctp_peeloff_flags function
Message-Id: <20170703202710.GS18138@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170703201330.29691-1-nhorman@hmswarspite.think-freely.org>
In-Reply-To: <20170703201330.29691-1-nhorman@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jul 03, 2017 at 04:13:30PM -0400, Neil Horman wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> 
> With the addition of the SCTP_SOCKOPT_PEELOFF_FLAGS socket option for
> linux, this patch adds a library function to support its use.  For non
> linux systems, when the call is used with a 0 flag set, the behavior
> will be identical to sctp_peeloff, and with a non-zero flag set for
> non-linux operating systems, a runtime error will be returned.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Vlad Yasevich <vyasevic@redhat.com>
> CC: Daniel Borkmann <dborkman@redhat.com>

Applied, thanks Neil.

  Marcelo
