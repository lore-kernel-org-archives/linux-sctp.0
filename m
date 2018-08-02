From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 02 Aug 2018 11:39:56 +0000
Subject: Re: [PATCH lksctp-tools] travis: use git instead of downloading tarballs
Message-Id: <20180802113956.GC28190@hmswarspite.think-freely.org>
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
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  .travis.yml            |  7 +----
>  .travis/linux-build.sh | 61 +++++++++++++++++++++++++++++++++++-------
>  2 files changed, 53 insertions(+), 15 deletions(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index 8416b621a6f486469cef8fbb61e3d782674a4978..f1b2b49b97485f870047c7865d18605175b35c53 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -9,12 +9,7 @@ env:
>    global:
>      - KERNEL=4.17
>    matrix:
> -    - KERNEL=4.10
> -    - KERNEL=4.11
> -    - KERNEL=4.12
> -    - KERNEL=4.13
> -    - KERNEL=4.16
> -    - KERNEL=4.17
> +    - KERNEL=""
>  compiler:
>    - gcc
>    - clang
> diff --git a/.travis/linux-build.sh b/.travis/linux-build.sh
> index e1874f3e16fb86ab86d7796b6c807b791b584e95..746f17252992f8f80a49fd9004bc9600cc97081e 100755
> --- a/.travis/linux-build.sh
> +++ b/.travis/linux-build.sh
> @@ -1,17 +1,34 @@
> -#!/bin/bash
> +#!/bin/bash -ex
>  
> -set -ex
> +VERS="master v4.17 v4.16 v4.13 v4.12 v4.11 v4.10"
>  
>  nproc=$(/usr/bin/getconf _NPROCESSORS_ONLN)
> +basedir=$(pwd)
>  
> -function install_kernel()
> +function cleanup()
> +{
> +	cd "$basedir"
> +	[ ! -d linux ] || rm -rf linux
> +	[ ! -d "linux-$KERNEL" ] || rm -rf "linux-$KERNEL"
> +	make distclean || :
> +}
> +
> +function clone_kernel()
> +{
> +	git clone https://github.com/torvalds/linux
> +}
> +
> +function download_kernel()
>  {
>  	VER="$1"
>  	URL="https://www.kernel.org/pub/linux/kernel/v4.x/linux-$VER.tar.xz"
>  	wget "$URL"
>  	tar xf "linux-$VER.tar.xz"
> +}
>  
> -	pushd "linux-$VER"
> +function __prep_kernel()
> +{
> +	make mrproper
>  	make allmodconfig
>  	make -j $nproc modules_prepare
>  	make -j $nproc headers_install
> @@ -19,8 +36,26 @@ function install_kernel()
>  	popd
>  }
>  
> +function git_prep_kernel()
> +{
> +	VER="$1"
> +
> +	pushd "linux"
> +	git checkout "$VER"
> +	__prep_kernel
> +}
> +
> +function download_prep_kernel()
> +{
> +	VER="$1"
> +
> +	pushd "linux-$VER"
> +	__prep_kernel
> +}
> +
>  function build_lksctp()
>  {
> +	make distclean || :
>  	./bootstrap
>  
>  	#CFLAGS="-Werror"
> @@ -33,11 +68,19 @@ function build_lksctp()
>  	make -j $nproc
>  
>  	#make -j $nproc distcheck
> -}
>  
> -if [ -n "$KERNEL" ]; then
> -	install_kernel "$KERNEL"
> -fi
> +}
>  
> -build_lksctp
> +trap cleanup EXIT
> +if [ -z "$KERNEL" ]; then
> +	clone_kernel
>  
> +	for ver in $VERS; do
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
Acked-by: Neil Horman <nhorman@tuxdriver.com>> 
