From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 30 Jul 2018 11:50:17 +0000
Subject: Re: [PATCH 1/4] travis: build against multiple kernel versions
Message-Id: <20180730115017.GA14421@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <69c9bde6c476f33b6d2cf5b9d06b4dccc96fe083.1532816583.git.marcelo.leitner@gmail.com>
In-Reply-To: <69c9bde6c476f33b6d2cf5b9d06b4dccc96fe083.1532816583.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sat, Jul 28, 2018 at 07:31:20PM -0300, Marcelo Ricardo Leitner wrote:
> With recent changes, configure is probing for kernel features before
> enabling them in the library.
> 
> Now with this change, travis-ci will build the library against several
> different kernels, allowing a better CI.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> 
> The comments in linux-build.sh are intentional. Place holders for next
> steps.
> 
>  .travis.yml            | 17 ++++++++++++-----
>  .travis/linux-build.sh | 43 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+), 5 deletions(-)
>  create mode 100755 .travis/linux-build.sh
> 
> diff --git a/.travis.yml b/.travis.yml
> index 75d07aa0640d73d12321231ecce18aa407ce15f4..c0fb7c68c4977c7185cd05df1b88b6d552cfa59f 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -1,10 +1,17 @@
>  language: c
> +addons:
> +  apt:
> +    packages:
> +      - libelf-dev
>  script:
> -  - ./bootstrap
> -    && ./configure
> -    && make -j `/usr/bin/getconf _NPROCESSORS_ONLN`
> -  # ipv6 is not supported by Travis
> -  - make -C src/func_tests/ v4test
> +  - ./.travis/linux-build.sh
> +env:
> +  - KERNEL=4.10
> +  - KERNEL=4.11
> +  - KERNEL=4.12
> +  - KERNEL=4.13
> +  - KERNEL=4.16
> +  - KERNEL=4.17
>  compiler:
>    - gcc
>    - clang
> diff --git a/.travis/linux-build.sh b/.travis/linux-build.sh
> new file mode 100755
> index 0000000000000000000000000000000000000000..e1874f3e16fb86ab86d7796b6c807b791b584e95
> --- /dev/null
> +++ b/.travis/linux-build.sh
> @@ -0,0 +1,43 @@
> +#!/bin/bash
> +
> +set -ex
Did you mean to keep this in here?  I can understand the -e since this is for
travis ci testing, but -x seems like its just going to generate alot of noise.

Neil

> +
> +nproc=$(/usr/bin/getconf _NPROCESSORS_ONLN)
> +
> +function install_kernel()
> +{
> +	VER="$1"
> +	URL="https://www.kernel.org/pub/linux/kernel/v4.x/linux-$VER.tar.xz"
> +	wget "$URL"
> +	tar xf "linux-$VER.tar.xz"
> +
> +	pushd "linux-$VER"
> +	make allmodconfig
> +	make -j $nproc modules_prepare
> +	make -j $nproc headers_install
> +	KERNEL_HEADERS=$(pwd)/usr/include
> +	popd
> +}
> +
> +function build_lksctp()
> +{
> +	./bootstrap
> +
> +	#CFLAGS="-Werror"
> +	if [ -n "$KERNEL_HEADERS" ]; then
> +		CFLAGS="$CFLAGS -I$KERNEL_HEADERS"
> +	fi
> +	export CFLAGS
> +	./configure
> +
> +	make -j $nproc
> +
> +	#make -j $nproc distcheck
> +}
> +
> +if [ -n "$KERNEL" ]; then
> +	install_kernel "$KERNEL"
> +fi
> +
> +build_lksctp
> +
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
