From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 05 Feb 2013 15:22:18 +0000
Subject: Re: [PATCH v2 60/62] sctp: convert to idr_alloc()
Message-Id: <20130205152218.GC4511@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-61-git-send-email-tj@kernel.org>
 <20130204164238.GC27963@mtj.dyndns.org>
In-Reply-To: <20130204164238.GC27963@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk, Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org

On Mon, Feb 04, 2013 at 08:42:38AM -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> v2: Don't preload if @gfp doesn't contain __GFP_WAIT as the function
>     may be being called from non-process ocntext.  Also, add a comment
>     explaining @idr_low never becomes zero.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Sridhar Samudrala <sri@us.ibm.com>
> Cc: linux-sctp@vger.kernel.org
> ---
>  net/sctp/associola.c |   31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
I dont' think the documentation was really needed, but the interrupt context fix
was a good catch

Acked-by: Neil Horman <nhorman@tuxdriver.com>
