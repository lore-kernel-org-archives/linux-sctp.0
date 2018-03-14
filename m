From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 14 Mar 2018 13:53:02 +0000
Subject: Re: [PATCH net-next 1/5] sctp: add refcnt support for sh_key
Message-Id: <20180314135302.GV27351@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1521025473.git.lucien.xin@gmail.com>
 <6b9a82f18f69682fea668026d33b937c1702a09a.1521025473.git.lucien.xin@gmail.com>
In-Reply-To: <6b9a82f18f69682fea668026d33b937c1702a09a.1521025473.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Wed, Mar 14, 2018 at 07:05:30PM +0800, Xin Long wrote:
> With refcnt support for sh_key, chunks auth sh_keys can be decided
> before enqueuing it. Changing the active key later will not affect
> the chunks already enqueued.
> 
> Furthermore, this is necessary when adding the support for authinfo
> for sendmsg in next patch.
> 
> Note that struct sctp_chunk can't be grown due to that performance
> drop issue on slow cpu, so it just reuses head_skb memory for shkey
> in sctp_chunk.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  include/net/sctp/auth.h    |  9 +++--
>  include/net/sctp/sm.h      |  3 +-
>  include/net/sctp/structs.h |  9 +++--
>  net/sctp/auth.c            | 86 +++++++++++++++++++++++-----------------------
>  net/sctp/chunk.c           |  5 +++
>  net/sctp/output.c          | 18 ++++++++--
>  net/sctp/sm_make_chunk.c   | 15 ++++++--
>  net/sctp/sm_statefuns.c    | 11 +++---
>  net/sctp/socket.c          |  6 ++++
>  9 files changed, 104 insertions(+), 58 deletions(-)
> 
> diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
> index e5c57d0..017c1aa 100644
> --- a/include/net/sctp/auth.h
> +++ b/include/net/sctp/auth.h
> @@ -62,8 +62,9 @@ struct sctp_auth_bytes {
>  /* Definition for a shared key, weather endpoint or association */
>  struct sctp_shared_key {
>  	struct list_head key_list;
> -	__u16 key_id;
>  	struct sctp_auth_bytes *key;
> +	refcount_t refcnt;
> +	__u16 key_id;
>  };
>  
>  #define key_for_each(__key, __list_head) \
> @@ -103,8 +104,10 @@ int sctp_auth_send_cid(enum sctp_cid chunk,
>  int sctp_auth_recv_cid(enum sctp_cid chunk,
>  		       const struct sctp_association *asoc);
>  void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
> -			    struct sk_buff *skb,
> -			    struct sctp_auth_chunk *auth, gfp_t gfp);
> +			      struct sk_buff *skb, struct sctp_auth_chunk *auth,
> +			      struct sctp_shared_key *ep_key, gfp_t gfp);
> +void sctp_auth_shkey_release(struct sctp_shared_key *sh_key);
> +void sctp_auth_shkey_hold(struct sctp_shared_key *sh_key);
>  
>  /* API Helpers */
>  int sctp_auth_ep_add_chunkid(struct sctp_endpoint *ep, __u8 chunk_id);
> diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
> index 2883c43..2d0e782 100644
> --- a/include/net/sctp/sm.h
> +++ b/include/net/sctp/sm.h
> @@ -263,7 +263,8 @@ int sctp_process_asconf_ack(struct sctp_association *asoc,
>  struct sctp_chunk *sctp_make_fwdtsn(const struct sctp_association *asoc,
>  				    __u32 new_cum_tsn, size_t nstreams,
>  				    struct sctp_fwdtsn_skip *skiplist);
> -struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc);
> +struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc,
> +				  __u16 key_id);
>  struct sctp_chunk *sctp_make_strreset_req(const struct sctp_association *asoc,
>  					  __u16 stream_num, __be16 *stream_list,
>  					  bool out, bool in);
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index ec6e46b..49ad67b 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -577,8 +577,12 @@ struct sctp_chunk {
>  	/* This points to the sk_buff containing the actual data.  */
>  	struct sk_buff *skb;
>  
> -	/* In case of GSO packets, this will store the head one */
> -	struct sk_buff *head_skb;
> +	union {
> +		/* In case of GSO packets, this will store the head one */
> +		struct sk_buff *head_skb;
> +		/* In case of auth enabled, this will point to the shkey */
> +		struct sctp_shared_key *shkey;
> +	};
>  
>  	/* These are the SCTP headers by reverse order in a packet.
>  	 * Note that some of these may happen more than once.  In that
> @@ -1995,6 +1999,7 @@ struct sctp_association {
>  	 * The current generated assocaition shared key (secret)
>  	 */
>  	struct sctp_auth_bytes *asoc_shared_key;
> +	struct sctp_shared_key *shkey;
>  
>  	/* SCTP AUTH: hmac id of the first peer requested algorithm
>  	 * that we support.
> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index 00667c5..e5214fd 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -101,13 +101,14 @@ struct sctp_shared_key *sctp_auth_shkey_create(__u16 key_id, gfp_t gfp)
>  		return NULL;
>  
>  	INIT_LIST_HEAD(&new->key_list);
> +	refcount_set(&new->refcnt, 1);
>  	new->key_id = key_id;
>  
>  	return new;
>  }
>  
>  /* Free the shared key structure */
> -static void sctp_auth_shkey_free(struct sctp_shared_key *sh_key)
> +static void sctp_auth_shkey_destroy(struct sctp_shared_key *sh_key)
>  {
>  	BUG_ON(!list_empty(&sh_key->key_list));
>  	sctp_auth_key_put(sh_key->key);
> @@ -115,6 +116,17 @@ static void sctp_auth_shkey_free(struct sctp_shared_key *sh_key)
>  	kfree(sh_key);
>  }
>  
> +void sctp_auth_shkey_release(struct sctp_shared_key *sh_key)
> +{
> +	if (refcount_dec_and_test(&sh_key->refcnt))
> +		sctp_auth_shkey_destroy(sh_key);
> +}
> +
> +void sctp_auth_shkey_hold(struct sctp_shared_key *sh_key)
> +{
> +	refcount_inc(&sh_key->refcnt);
> +}
> +
>  /* Destroy the entire key list.  This is done during the
>   * associon and endpoint free process.
>   */
> @@ -128,7 +140,7 @@ void sctp_auth_destroy_keys(struct list_head *keys)
>  
>  	key_for_each_safe(ep_key, tmp, keys) {
>  		list_del_init(&ep_key->key_list);
> -		sctp_auth_shkey_free(ep_key);
> +		sctp_auth_shkey_release(ep_key);
>  	}
>  }
>  
> @@ -409,13 +421,19 @@ int sctp_auth_asoc_init_active_key(struct sctp_association *asoc, gfp_t gfp)
>  
>  	sctp_auth_key_put(asoc->asoc_shared_key);
>  	asoc->asoc_shared_key = secret;
> +	asoc->shkey = ep_key;
>  
>  	/* Update send queue in case any chunk already in there now
>  	 * needs authenticating
>  	 */
>  	list_for_each_entry(chunk, &asoc->outqueue.out_chunk_list, list) {
> -		if (sctp_auth_send_cid(chunk->chunk_hdr->type, asoc))
> +		if (sctp_auth_send_cid(chunk->chunk_hdr->type, asoc)) {
>  			chunk->auth = 1;
> +			if (!chunk->shkey) {
> +				chunk->shkey = asoc->shkey;
> +				sctp_auth_shkey_hold(chunk->shkey);
> +			}
> +		}
>  	}
>  
>  	return 0;
> @@ -703,16 +721,15 @@ int sctp_auth_recv_cid(enum sctp_cid chunk, const struct sctp_association *asoc)
>   *    after the AUTH chunk in the SCTP packet.
>   */
>  void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
> -			      struct sk_buff *skb,
> -			      struct sctp_auth_chunk *auth,
> -			      gfp_t gfp)
> +			      struct sk_buff *skb, struct sctp_auth_chunk *auth,
> +			      struct sctp_shared_key *ep_key, gfp_t gfp)
>  {
> -	struct crypto_shash *tfm;
>  	struct sctp_auth_bytes *asoc_key;
> +	struct crypto_shash *tfm;
>  	__u16 key_id, hmac_id;
> -	__u8 *digest;
>  	unsigned char *end;
>  	int free_key = 0;
> +	__u8 *digest;
>  
>  	/* Extract the info we need:
>  	 * - hmac id
> @@ -724,12 +741,7 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
>  	if (key_id = asoc->active_key_id)
>  		asoc_key = asoc->asoc_shared_key;
>  	else {
> -		struct sctp_shared_key *ep_key;
> -
> -		ep_key = sctp_auth_get_shkey(asoc, key_id);
> -		if (!ep_key)
> -			return;
> -
> +		/* ep_key can't be NULL here */
>  		asoc_key = sctp_auth_asoc_create_secret(asoc, ep_key, gfp);
>  		if (!asoc_key)
>  			return;
> @@ -829,7 +841,7 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
>  		      struct sctp_association *asoc,
>  		      struct sctp_authkey *auth_key)
>  {
> -	struct sctp_shared_key *cur_key = NULL;
> +	struct sctp_shared_key *cur_key, *shkey;
>  	struct sctp_auth_bytes *key;
>  	struct list_head *sh_keys;
>  	int replace = 0;
> @@ -842,46 +854,34 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
>  	else
>  		sh_keys = &ep->endpoint_shared_keys;
>  
> -	key_for_each(cur_key, sh_keys) {
> -		if (cur_key->key_id = auth_key->sca_keynumber) {
> +	key_for_each(shkey, sh_keys) {
> +		if (shkey->key_id = auth_key->sca_keynumber) {
>  			replace = 1;
>  			break;
>  		}
>  	}
>  
> -	/* If we are not replacing a key id, we need to allocate
> -	 * a shared key.
> -	 */
> -	if (!replace) {
> -		cur_key = sctp_auth_shkey_create(auth_key->sca_keynumber,
> -						 GFP_KERNEL);
> -		if (!cur_key)
> -			return -ENOMEM;
> -	}
> +	cur_key = sctp_auth_shkey_create(auth_key->sca_keynumber, GFP_KERNEL);
> +	if (!cur_key)
> +		return -ENOMEM;
>  
>  	/* Create a new key data based on the info passed in */
>  	key = sctp_auth_create_key(auth_key->sca_keylength, GFP_KERNEL);
> -	if (!key)
> -		goto nomem;
> +	if (!key) {
> +		kfree(cur_key);
> +		return -ENOMEM;
> +	}
>  
>  	memcpy(key->data, &auth_key->sca_key[0], auth_key->sca_keylength);
> +	cur_key->key = key;
>  
> -	/* If we are replacing, remove the old keys data from the
> -	 * key id.  If we are adding new key id, add it to the
> -	 * list.
> -	 */
> -	if (replace)
> -		sctp_auth_key_put(cur_key->key);
> -	else
> -		list_add(&cur_key->key_list, sh_keys);
> +	if (replace) {
> +		list_del_init(&shkey->key_list);
> +		sctp_auth_shkey_release(shkey);
> +	}
> +	list_add(&cur_key->key_list, sh_keys);
>  
> -	cur_key->key = key;
>  	return 0;
> -nomem:
> -	if (!replace)
> -		sctp_auth_shkey_free(cur_key);
> -
> -	return -ENOMEM;
>  }
>  
>  int sctp_auth_set_active_key(struct sctp_endpoint *ep,
> @@ -952,7 +952,7 @@ int sctp_auth_del_key_id(struct sctp_endpoint *ep,
>  
>  	/* Delete the shared key */
>  	list_del_init(&key->key_list);
> -	sctp_auth_shkey_free(key);
> +	sctp_auth_shkey_release(key);
>  
>  	return 0;
>  }
> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> index 991a530..9f28a9a 100644
> --- a/net/sctp/chunk.c
> +++ b/net/sctp/chunk.c
> @@ -168,6 +168,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  {
>  	size_t len, first_len, max_data, remaining;
>  	size_t msg_len = iov_iter_count(from);
> +	struct sctp_shared_key *shkey = NULL;
>  	struct list_head *pos, *temp;
>  	struct sctp_chunk *chunk;
>  	struct sctp_datamsg *msg;
> @@ -204,6 +205,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  		if (hmac_desc)
>  			max_data -= SCTP_PAD4(sizeof(struct sctp_auth_chunk) +
>  					      hmac_desc->hmac_len);
> +
> +		shkey = asoc->shkey;
>  	}
>  
>  	/* Check what's our max considering the above */
> @@ -275,6 +278,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  		if (err < 0)
>  			goto errout_chunk_free;
>  
> +		chunk->shkey = shkey;
> +
>  		/* Put the chunk->skb back into the form expected by send.  */
>  		__skb_pull(chunk->skb, (__u8 *)chunk->chunk_hdr -
>  				       chunk->skb->data);
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 01a26ee0..d6e1c90 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -241,10 +241,13 @@ static enum sctp_xmit sctp_packet_bundle_auth(struct sctp_packet *pkt,
>  	if (!chunk->auth)
>  		return retval;
>  
> -	auth = sctp_make_auth(asoc);
> +	auth = sctp_make_auth(asoc, chunk->shkey->key_id);
>  	if (!auth)
>  		return retval;
>  
> +	auth->shkey = chunk->shkey;
> +	sctp_auth_shkey_hold(auth->shkey);
> +
>  	retval = __sctp_packet_append_chunk(pkt, auth);
>  
>  	if (retval != SCTP_XMIT_OK)
> @@ -490,7 +493,8 @@ static int sctp_packet_pack(struct sctp_packet *packet,
>  		}
>  
>  		if (auth) {
> -			sctp_auth_calculate_hmac(tp->asoc, nskb, auth, gfp);
> +			sctp_auth_calculate_hmac(tp->asoc, nskb, auth,
> +						 packet->auth->shkey, gfp);
>  			/* free auth if no more chunks, or add it back */
>  			if (list_empty(&packet->chunk_list))
>  				sctp_chunk_free(packet->auth);
> @@ -770,6 +774,16 @@ static enum sctp_xmit sctp_packet_will_fit(struct sctp_packet *packet,
>  	enum sctp_xmit retval = SCTP_XMIT_OK;
>  	size_t psize, pmtu, maxsize;
>  
> +	/* Don't bundle in this packet if this chunk's auth key doesn't
> +	 * match other chunks already enqueued on this packet. Also,
> +	 * don't bundle the chunk with auth key if other chunks in this
> +	 * packet don't have auth key.
> +	 */
> +	if ((packet->auth && chunk->shkey != packet->auth->shkey) ||
> +	    (!packet->auth && chunk->shkey &&
> +	     chunk->chunk_hdr->type != SCTP_CID_AUTH))
> +		return SCTP_XMIT_PMTU_FULL;
> +
>  	psize = packet->size;
>  	if (packet->transport->asoc)
>  		pmtu = packet->transport->asoc->pathmtu;
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index d01475f..10f071c 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -87,7 +87,10 @@ static void  *sctp_addto_chunk_fixed(struct sctp_chunk *, int len,
>  /* Control chunk destructor */
>  static void sctp_control_release_owner(struct sk_buff *skb)
>  {
> -	/*TODO: do memory release */
> +	struct sctp_chunk *chunk = skb_shinfo(skb)->destructor_arg;
> +
> +	if (chunk->shkey)
> +		sctp_auth_shkey_release(chunk->shkey);
>  }
>  
>  static void sctp_control_set_owner_w(struct sctp_chunk *chunk)
> @@ -102,7 +105,12 @@ static void sctp_control_set_owner_w(struct sctp_chunk *chunk)
>  	 *
>  	 *  For now don't do anything for now.
>  	 */
> +	if (chunk->auth) {
> +		chunk->shkey = asoc->shkey;
> +		sctp_auth_shkey_hold(chunk->shkey);
> +	}
>  	skb->sk = asoc ? asoc->base.sk : NULL;
> +	skb_shinfo(skb)->destructor_arg = chunk;
>  	skb->destructor = sctp_control_release_owner;
>  }
>  
> @@ -1271,7 +1279,8 @@ struct sctp_chunk *sctp_make_op_error(const struct sctp_association *asoc,
>  	return retval;
>  }
>  
> -struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc)
> +struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc,
> +				  __u16 key_id)
>  {
>  	struct sctp_authhdr auth_hdr;
>  	struct sctp_hmac *hmac_desc;
> @@ -1289,7 +1298,7 @@ struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc)
>  		return NULL;
>  
>  	auth_hdr.hmac_id = htons(hmac_desc->hmac_id);
> -	auth_hdr.shkey_id = htons(asoc->active_key_id);
> +	auth_hdr.shkey_id = htons(key_id);
>  
>  	retval->subh.auth_hdr = sctp_addto_chunk(retval, sizeof(auth_hdr),
>  						 &auth_hdr);
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index eb7905f..792e0e2 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -4114,6 +4114,7 @@ static enum sctp_ierror sctp_sf_authenticate(
>  					const union sctp_subtype type,
>  					struct sctp_chunk *chunk)
>  {
> +	struct sctp_shared_key *sh_key = NULL;
>  	struct sctp_authhdr *auth_hdr;
>  	__u8 *save_digest, *digest;
>  	struct sctp_hmac *hmac;
> @@ -4135,9 +4136,11 @@ static enum sctp_ierror sctp_sf_authenticate(
>  	 * configured
>  	 */
>  	key_id = ntohs(auth_hdr->shkey_id);
> -	if (key_id != asoc->active_key_id && !sctp_auth_get_shkey(asoc, key_id))
> -		return SCTP_IERROR_AUTH_BAD_KEYID;
> -
> +	if (key_id != asoc->active_key_id) {
> +		sh_key = sctp_auth_get_shkey(asoc, key_id);
> +		if (!sh_key)
> +			return SCTP_IERROR_AUTH_BAD_KEYID;
> +	}
>  
>  	/* Make sure that the length of the signature matches what
>  	 * we expect.
> @@ -4166,7 +4169,7 @@ static enum sctp_ierror sctp_sf_authenticate(
>  
>  	sctp_auth_calculate_hmac(asoc, chunk->skb,
>  				 (struct sctp_auth_chunk *)chunk->chunk_hdr,
> -				 GFP_ATOMIC);
> +				 sh_key, GFP_ATOMIC);
>  
>  	/* Discard the packet if the digests do not match */
>  	if (memcmp(save_digest, digest, sig_len)) {
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index af5cf29..003a4ad 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -156,6 +156,9 @@ static inline void sctp_set_owner_w(struct sctp_chunk *chunk)
>  	/* The sndbuf space is tracked per association.  */
>  	sctp_association_hold(asoc);
>  
> +	if (chunk->shkey)
> +		sctp_auth_shkey_hold(chunk->shkey);
> +
>  	skb_set_owner_w(chunk->skb, sk);
>  
>  	chunk->skb->destructor = sctp_wfree;
> @@ -8109,6 +8112,9 @@ static void sctp_wfree(struct sk_buff *skb)
>  	sk->sk_wmem_queued   -= skb->truesize;
>  	sk_mem_uncharge(sk, skb->truesize);
>  
> +	if (chunk->shkey)
> +		sctp_auth_shkey_release(chunk->shkey);
> +
>  	sock_wfree(skb);
>  	sctp_wake_up_waiters(sk, asoc);
>  
> -- 
> 2.1.0
> 
