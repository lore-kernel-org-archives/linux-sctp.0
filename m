From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 16 Aug 2018 18:18:41 +0000
Subject: Re: [PATCH lksctp-tools] configure.ac: add CURRENT REVISION and AGE for libsctp and libwithsctp
Message-Id: <20180816181841.GI5311@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <d594347d6683fbbfaf468010d9e9bd9b86c4ca0b.1534399950.git.lucien.xin@gmail.com>
In-Reply-To: <d594347d6683fbbfaf468010d9e9bd9b86c4ca0b.1534399950.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Aug 16, 2018 at 02:12:30PM +0800, Xin Long wrote:
> Add CURRENT REVISION and AGE for libsctp and libwithsctp in
> configure.ac to update these 2 library version information.
> 
> Compatible with before, they will start from 1:18:0. But each
> will get updated according to their definitions in the future.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  configure.ac             | 7 +++++++
>  src/lib/Makefile.am      | 7 +++++--
>  src/withsctp/Makefile.am | 3 ++-
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 275ef4e..2ae36ec 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -14,6 +14,13 @@ dnl reduce clutter in the root; if we put it below AM_INIT_AUTOMAKE,
>  dnl configure will fail ...)
>  
>  AC_INIT([lksctp-tools], [1.0.18], [], [], [http://www.lksctp.org/])
> +AC_SUBST(LIBSCTP_CURRENT, 1)
> +AC_SUBST(LIBSCTP_REVISION, 18)
> +AC_SUBST(LIBSCTP_AGE, 0)
> +AC_SUBST(LIBWITHSCTP_CURRENT, 1)
> +AC_SUBST(LIBWITHSCTP_REVISION, 18)
> +AC_SUBST(LIBWITHSCTP_AGE, 0)

Applied.  Thanks, now it will be harder to miss these =)
