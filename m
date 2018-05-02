From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 02 May 2018 11:38:02 +0000
Subject: Re: [PATCH net] sctp: init active key for the new asoc in dupcook_a and dupcook_b
Message-Id: <20180502113802.GB13202@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <96c2191206cb67ccec250ca1ec66d83dc9f40c9a.1525239464.git.lucien.xin@gmail.com>
In-Reply-To: <96c2191206cb67ccec250ca1ec66d83dc9f40c9a.1525239464.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Wed, May 02, 2018 at 01:37:44PM +0800, Xin Long wrote:
> When processing a duplicate cookie-echo chunk, for case 'A' and 'B',
> after sctp_process_init for the new asoc, if auth is enabled for the
> cookie-ack chunk, the active key should also be initialized.
> 
> Otherwise, the cookie-ack chunk made later can not be set with auth
> shkey properly, and a crash can even be caused by this, as after
> Commit 1b1e0bc99474 ("sctp: add refcnt support for sh_key"), sctp
> needs to hold the shkey when making control chunks.
> 
> Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/sm_statefuns.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index dd0594a..98acfed 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -1794,6 +1794,9 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
>  			       GFP_ATOMIC))
>  		goto nomem;
>  
> +	if (sctp_auth_asoc_init_active_key(new_asoc, GFP_ATOMIC))
> +		goto nomem;
> +
>  	/* Make sure no new addresses are being added during the
>  	 * restart.  Though this is a pretty complicated attack
>  	 * since you'd have to get inside the cookie.
> @@ -1906,6 +1909,9 @@ static enum sctp_disposition sctp_sf_do_dupcook_b(
>  			       GFP_ATOMIC))
>  		goto nomem;
>  
> +	if (sctp_auth_asoc_init_active_key(new_asoc, GFP_ATOMIC))
> +		goto nomem;
> +
>  	/* Update the content of current association.  */
>  	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
>  	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

