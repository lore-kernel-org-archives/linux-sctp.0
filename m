From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 01 Aug 2018 17:43:02 +0000
Subject: Re: [PATCH lksctp-tools] travis: use git instead of downloading tarballs
Message-Id: <20180801174302.GF5482@localhost.localdomain>
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
> 

...

> +if [ -z "$KERNEL" ]; then
> +	clone_kernel
>  
> +	for ver in $VERS; do

Even with this loop, the log file is now 5k~6k lines long, while the
limit is 10k.

> +		git_prep_kernel "$ver"
> +		build_lksctp
> +	done
> +else
> +	download_kernel "$KERNEL"
> +	download_prep_kernel "$KERNEL"
> +	build_lksctp
> +fi
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
