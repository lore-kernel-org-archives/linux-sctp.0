From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 02 Aug 2018 11:37:52 +0000
Subject: Re: [PATCH lksctp-tools] nagle_snd: silence false-positive compiler warning
Message-Id: <20180802113752.GB28190@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <6530f05626614250e2c5257356c52d180326147c.1533140085.git.marcelo.leitner@gmail.com>
In-Reply-To: <6530f05626614250e2c5257356c52d180326147c.1533140085.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On Wed, Aug 01, 2018 at 01:33:04PM -0300, Marcelo Ricardo Leitner wrote:
> I'm getting:
> nagle_snd.c: In function ‘main’:
> nagle_snd.c:275:3: warning: ‘strncpy’ output truncated before terminating nul copying 10 bytes from a string of the same length [-Wstringop-truncation]
>    strncpy(message+i, "1234567890", 10);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Turns out the code is doing that on purpose. To silence it, lets use
> memcpy() instead.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  src/apps/nagle_snd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/apps/nagle_snd.c b/src/apps/nagle_snd.c
> index 1fc788d56c6e4dd99e89f73c8eafc829efc76dc5..bc960cca04bbc3d8e22a1757daf5fce7b76a95ce 100644
> --- a/src/apps/nagle_snd.c
> +++ b/src/apps/nagle_snd.c
> @@ -272,7 +272,7 @@ main(int argc, char *argv[])
>  	message = test_malloc((size + 1) * sizeof(u_int8_t));
>  
>  	for(i=0; i + 10 < size; i+= 10)
> -		strncpy(message+i, "1234567890", 10);
> +		memcpy(message+i, "1234567890", 10);
Are you sure you want to do that?  strncpy limits the copy operation to
min(sizeof(message+i), 10), and the size of message can be specified on the
command line.  memcpy just copies 10 bytes blindly, possibly overruning the end
of the array.

I think it may be more useful here to do this:
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wstringop-truncation"
...
strncpy(message+i, "1234567890", 10);
#pragma GCC diagnostic pop

You can wrap up those pragmas in a macro using _Pragma if you need to. Its a bit
ugly, but it clearly flags the truncation as an intended side effect.

Neil

>  	strncpy(message+i, "1234567890", size-i);
>  	*(message+size) = 0;
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
