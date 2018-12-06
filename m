From: kbuild test robot <lkp@intel.com>
Date: Thu, 06 Dec 2018 02:49:02 +0000
Subject: Re: [PATCH net] sctp: frag_point sanity check
Message-Id: <201812061014.UpXttouc%fengguang.wu@intel.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
List-Id: <linux-sctp.vger.kernel.org>
References: <20181204192741.35357-1-jakub.audykowicz@gmail.com>
In-Reply-To: <20181204192741.35357-1-jakub.audykowicz@gmail.com>
To: linux-sctp@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jakub,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/0day-ci/linux/commits/Jakub-Audykowicz/sctp-frag_point-sanity-check/20181206-011917
config: x86_64-randconfig-x015-12051035 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   In file included from include/linux/kernel.h:14:0,
                    from net/sctp/chunk.c:36:
   net/sctp/chunk.c: In function 'sctp_datamsg_from_user':
   include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t {aka long unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:429:10: note: in definition of macro 'printk_ratelimited'
      printk(fmt, ##__VA_ARGS__);    \
             ^~~
   include/linux/kern_levels.h:12:22: note: in expansion of macro 'KERN_SOH'
    #define KERN_WARNING KERN_SOH "4" /* warning conditions */
                         ^~~~~~~~
   include/linux/printk.h:445:21: note: in expansion of macro 'KERN_WARNING'
     printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
                        ^~~~~~~~~~~~
>> net/sctp/chunk.c:197:3: note: in expansion of macro 'pr_warn_ratelimited'
      pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to default minimum (%d)",
      ^~~~~~~~~~~~~~~~~~~

vim +/pr_warn_ratelimited +197 net/sctp/chunk.c

   156	
   157	
   158	/* A data chunk can have a maximum payload of (2^16 - 20).  Break
   159	 * down any such message into smaller chunks.  Opportunistically, fragment
   160	 * the chunks down to the current MTU constraints.  We may get refragmented
   161	 * later if the PMTU changes, but it is _much better_ to fragment immediately
   162	 * with a reasonable guess than always doing our fragmentation on the
   163	 * soft-interrupt.
   164	 */
   165	struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
   166						    struct sctp_sndrcvinfo *sinfo,
   167						    struct iov_iter *from)
   168	{
   169		size_t len, first_len, max_data, remaining;
   170		size_t msg_len = iov_iter_count(from);
   171		struct sctp_shared_key *shkey = NULL;
   172		struct list_head *pos, *temp;
   173		struct sctp_chunk *chunk;
   174		struct sctp_datamsg *msg;
   175		int err;
   176	
   177		msg = sctp_datamsg_new(GFP_KERNEL);
   178		if (!msg)
   179			return ERR_PTR(-ENOMEM);
   180	
   181		/* Note: Calculate this outside of the loop, so that all fragments
   182		 * have the same expiration.
   183		 */
   184		if (asoc->peer.prsctp_capable && sinfo->sinfo_timetolive &&
   185		    (SCTP_PR_TTL_ENABLED(sinfo->sinfo_flags) ||
   186		     !SCTP_PR_POLICY(sinfo->sinfo_flags)))
   187			msg->expires_at = jiffies +
   188					  msecs_to_jiffies(sinfo->sinfo_timetolive);
   189	
   190		/* This is the biggest possible DATA chunk that can fit into
   191		 * the packet
   192		 */
   193		max_data = asoc->frag_point;
   194		if (unlikely(!max_data)) {
   195			max_data = sctp_min_frag_point(sctp_sk(asoc->base.sk),
   196						       sctp_datachk_len(&asoc->stream));
 > 197			pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to default minimum (%d)",
   198					    __func__, asoc, max_data);
   199		}
   200	
   201		/* If the the peer requested that we authenticate DATA chunks
   202		 * we need to account for bundling of the AUTH chunks along with
   203		 * DATA.
   204		 */
   205		if (sctp_auth_send_cid(SCTP_CID_DATA, asoc)) {
   206			struct sctp_hmac *hmac_desc = sctp_auth_asoc_get_hmac(asoc);
   207	
   208			if (hmac_desc)
   209				max_data -= SCTP_PAD4(sizeof(struct sctp_auth_chunk) +
   210						      hmac_desc->hmac_len);
   211	
   212			if (sinfo->sinfo_tsn &&
   213			    sinfo->sinfo_ssn != asoc->active_key_id) {
   214				shkey = sctp_auth_get_shkey(asoc, sinfo->sinfo_ssn);
   215				if (!shkey) {
   216					err = -EINVAL;
   217					goto errout;
   218				}
   219			} else {
   220				shkey = asoc->shkey;
   221			}
   222		}
   223	
   224		/* Set first_len and then account for possible bundles on first frag */
   225		first_len = max_data;
   226	
   227		/* Check to see if we have a pending SACK and try to let it be bundled
   228		 * with this message.  Do this if we don't have any data queued already.
   229		 * To check that, look at out_qlen and retransmit list.
   230		 * NOTE: we will not reduce to account for SACK, if the message would
   231		 * not have been fragmented.
   232		 */
   233		if (timer_pending(&asoc->timers[SCTP_EVENT_TIMEOUT_SACK]) &&
   234		    asoc->outqueue.out_qlen == 0 &&
   235		    list_empty(&asoc->outqueue.retransmit) &&
   236		    msg_len > max_data)
   237			first_len -= SCTP_PAD4(sizeof(struct sctp_sack_chunk));
   238	
   239		/* Encourage Cookie-ECHO bundling. */
   240		if (asoc->state < SCTP_STATE_COOKIE_ECHOED)
   241			first_len -= SCTP_ARBITRARY_COOKIE_ECHO_LEN;
   242	
   243		/* Account for a different sized first fragment */
   244		if (msg_len >= first_len) {
   245			msg->can_delay = 0;
   246			if (msg_len > first_len)
   247				SCTP_INC_STATS(sock_net(asoc->base.sk),
   248					       SCTP_MIB_FRAGUSRMSGS);
   249		} else {
   250			/* Which may be the only one... */
   251			first_len = msg_len;
   252		}
   253	
   254		/* Create chunks for all DATA chunks. */
   255		for (remaining = msg_len; remaining; remaining -= len) {
   256			u8 frag = SCTP_DATA_MIDDLE_FRAG;
   257	
   258			if (remaining == msg_len) {
   259				/* First frag, which may also be the last */
   260				frag |= SCTP_DATA_FIRST_FRAG;
   261				len = first_len;
   262			} else {
   263				/* Middle frags */
   264				len = max_data;
   265			}
   266	
   267			if (len >= remaining) {
   268				/* Last frag, which may also be the first */
   269				len = remaining;
   270				frag |= SCTP_DATA_LAST_FRAG;
   271	
   272				/* The application requests to set the I-bit of the
   273				 * last DATA chunk of a user message when providing
   274				 * the user message to the SCTP implementation.
   275				 */
   276				if ((sinfo->sinfo_flags & SCTP_EOF) ||
   277				    (sinfo->sinfo_flags & SCTP_SACK_IMMEDIATELY))
   278					frag |= SCTP_DATA_SACK_IMM;
   279			}
   280	
   281			chunk = asoc->stream.si->make_datafrag(asoc, sinfo, len, frag,
   282							       GFP_KERNEL);
   283			if (!chunk) {
   284				err = -ENOMEM;
   285				goto errout;
   286			}
   287	
   288			err = sctp_user_addto_chunk(chunk, len, from);
   289			if (err < 0)
   290				goto errout_chunk_free;
   291	
   292			chunk->shkey = shkey;
   293	
   294			/* Put the chunk->skb back into the form expected by send.  */
   295			__skb_pull(chunk->skb, (__u8 *)chunk->chunk_hdr -
   296					       chunk->skb->data);
   297	
   298			sctp_datamsg_assign(msg, chunk);
   299			list_add_tail(&chunk->frag_list, &msg->chunks);
   300		}
   301	
   302		return msg;
   303	
   304	errout_chunk_free:
   305		sctp_chunk_free(chunk);
   306	
   307	errout:
   308		list_for_each_safe(pos, temp, &msg->chunks) {
   309			list_del_init(pos);
   310			chunk = list_entry(pos, struct sctp_chunk, frag_list);
   311			sctp_chunk_free(chunk);
   312		}
   313		sctp_datamsg_put(msg);
   314	
   315		return ERR_PTR(err);
   316	}
   317	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--RnlQjJ0d97Da+TV1
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--RnlQjJ0d97Da+TV1--
