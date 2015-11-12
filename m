From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 12 Nov 2015 21:02:57 +0000
Subject: Re: [PATCH net] sctp: translate host order to network order when setting a hmacid
Message-Id: <5644FE81.9070900@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <8cede44279b2f01a58fa02d4bb46b40fb630563f.1447304827.git.lucien.xin@gmail.com>
In-Reply-To: <8cede44279b2f01a58fa02d4bb46b40fb630563f.1447304827.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: marcelo.leitner@gmail.com, vyasevic@redhat.com, davem@davemloft.net

On 11/12/2015 12:07 AM, Xin Long wrote:
> now sctp auth cannot work well when setting a hmacid manually, which
> is caused by that we didn't use the network order for hmacid, so fix
> it by adding the transformation in sctp_auth_ep_set_hmacs.
> 
> even we set hmacid with the network order in userspace, it still
> can't work, because of this condition in sctp_auth_ep_set_hmacs():
> 
> 		if (id > SCTP_AUTH_HMAC_ID_MAX)
> 			return -EOPNOTSUPP;
> 
> so this wasn't working before and thus it won't break compatibility.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/auth.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index 4f15b7d..1543e39 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -809,8 +809,8 @@ int sctp_auth_ep_set_hmacs(struct sctp_endpoint *ep,
>  	if (!has_sha1)
>  		return -EINVAL;
>  
> -	memcpy(ep->auth_hmacs_list->hmac_ids, &hmacs->shmac_idents[0],
> -		hmacs->shmac_num_idents * sizeof(__u16));
> +	for (i = 0; i < hmacs->shmac_num_idents; i++)
> +		ep->auth_hmacs_list->hmac_ids[i] = htons(hmacs->shmac_idents[i]);
>  	ep->auth_hmacs_list->param_hdr.length = htons(sizeof(sctp_paramhdr_t) +
>  				hmacs->shmac_num_idents * sizeof(__u16));
>  	return 0;
> 

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad
