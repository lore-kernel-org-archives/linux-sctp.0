From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 07 May 2008 17:45:27 +0000
Subject: Re: [PATCH] add /proc/net/sctp/remaddr table to complete RFC
Message-Id: <20080507174527.GA1727@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080430144606.GB572@hmsendeavour.rdu.redhat.com>
In-Reply-To: <20080430144606.GB572@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, May 07, 2008 at 08:25:57AM -0400, Vlad Yasevich wrote:
> Neil Horman wrote:
>> Hey all-
>>
>> Add support for RFC3873 remote address table OID.  Currently the OID's required
>> by RFC 3873 cannot be implemented as part of the association table, where they
>
> The way read the spec, the sctpAssocRemAddrTable that you are implementing is not
> part of the association table.  It's a separate table and should be reported as
> such (the way you are doing here).
>
>> would otherwise naturally belong.  This patch places all the requsite data in a
>> separate proc file, /proc/net/sctp/remaddr
>>     Regards
>> Neil 
>> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>>
Thanks vlad, I'll repost with your suggestions incorporated shortly
Neil

>>
>> include/net/sctp/sctp.h |    2 net/sctp/proc.c         |  144 
>> ++++++++++++++++++++++++++++++++++++++++++++++++
>> net/sctp/protocol.c     |    3 +
>> 3 files changed, 149 insertions(+)
>>
>> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
>> index 34318a3..c1b087d 100644
>> --- a/include/net/sctp/sctp.h
>> +++ b/include/net/sctp/sctp.h
>> @@ -186,6 +186,8 @@ int sctp_eps_proc_init(void);
>>  void sctp_eps_proc_exit(void);
>>  int sctp_assocs_proc_init(void);
>>  void sctp_assocs_proc_exit(void);
>> +int sctp_remaddr_proc_init(void);
>> +void sctp_remaddr_proc_exit(void);
>>    /*
>> diff --git a/net/sctp/proc.c b/net/sctp/proc.c
>> index 2499732..dc80cd7 100644
>> --- a/net/sctp/proc.c
>> +++ b/net/sctp/proc.c
>> @@ -402,3 +402,147 @@ void sctp_assocs_proc_exit(void)
>>  {
>>  	remove_proc_entry("assocs", proc_net_sctp);
>>  }
>> +
>> +static void *sctp_remaddr_seq_start(struct seq_file *seq, loff_t *pos)
>> +{
>> +	if (*pos >= sctp_assoc_hashsize)
>> +		return NULL;
>> +
>> +	if (*pos < 0)
>> +		*pos = 0;
>> +
>> +	if (*pos = 0)
>> +		seq_printf(seq, "ADDR ASSOC_ID HB_ACT RTO MAX_PATH_RTX "
>> +				"REM_ADDR_RTX  START\n");
>> +
>> +	return (void *)pos;
>> +}
>> +
>> +static void *sctp_remaddr_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>> +{
>> +	if (++*pos >= sctp_assoc_hashsize)
>> +		return NULL;
>> +
>> +	return pos;
>> +}
>> +
>> +static void sctp_remaddr_seq_stop(struct seq_file *seq, void *v)
>> +{
>> +	return;
>> +}
>> +
>> +static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
>> +{
>> +	struct sctp_hashbucket *head;
>> +	struct sctp_ep_common *epb;
>> +	struct sctp_association *assoc;
>> +	struct hlist_node *node;
>> +	struct list_head *pos;
>> +	int    hash = *(loff_t *)v;
>> +
>> +	if (hash >= sctp_assoc_hashsize)
>> +		return -ENOMEM;
>> +
>> +	head = &sctp_assoc_hashtable[hash];
>> +	sctp_local_bh_disable();
>> +	read_lock(&head->lock);
>> +	sctp_for_each_hentry(epb, node, &head->chain) {
>> +		assoc = sctp_assoc(epb);
>> +		list_for_each(pos, &assoc->peer.transport_addr_list) {
>> +			struct sctp_transport *tsp;
>> +			tsp = list_entry(pos, struct sctp_transport,
>> +					 transports);
>
> I think this deserver list_for_each_entry() since we don't use pos for
> anything other then iteration of the list.
>
>
> Otherwise looks good.
>
> -vlad
>
>> +			/*
>> +			 * The remote address (ADDR)
>> +			 */
>> +			tsp->af_specific->seq_dump_addr(seq, &tsp->ipaddr);
>> +			seq_printf(seq, " ");
>> +
>> +			/*
>> +			 * The association ID (ASSOC_ID)
>> +			 */
>> +			seq_printf(seq, "%d ", tsp->asoc->assoc_id);
>> +
>> +			/*
>> +			 * If the Heartbeat is active (HB_ACT)
>> +			 * Note: 1 = Active, 0 = Inactive
>> +			 */
>> +			seq_printf(seq, "%d ", timer_pending(&tsp->hb_timer));
>> +
>> +			/*
>> +			 * Retransmit time out (RTO)
>> +			 */
>> +			seq_printf(seq, "%lu ", tsp->rto);
>> +
>> +			/*
>> +			 * Maximum path retransmit count (PATH_MAX_RTX)
>> +			 */
>> +			seq_printf(seq, "%d ", tsp->pathmaxrxt);
>> +
>> +			/*
>> +			 * remote address retransmit count (REM_ADDR_RTX)
>> +			 * Note: We don't have a way to tally this at the moment
>> +			 * so lets just leave it as zero for the moment
>> +			 */
>> +			seq_printf(seq, "0 ");
>> +
>> +			/*
>> +			 * remote address start time (START).  This is also not
>> +			 * currently implemented, but we can record it with a
>> +			 * jiffies marker in a subsequent patch
>> +			 */
>> +			seq_printf(seq, "0");
>> +
>> +			seq_printf(seq, "\n");
>> +		}
>> +	}
>> +
>> +	read_unlock(&head->lock);
>> +	sctp_local_bh_enable();
>> +
>> +	return 0;
>> +
>> +}
>> +
>> +static const struct seq_operations sctp_remaddr_ops = {
>> +	.start = sctp_remaddr_seq_start,
>> +	.next  = sctp_remaddr_seq_next,
>> +	.stop  = sctp_remaddr_seq_stop,
>> +	.show  = sctp_remaddr_seq_show,
>> +};
>> +
>> +/* Cleanup the proc fs entry for 'remaddr' object. */
>> +void sctp_remaddr_proc_exit(void)
>> +{
>> +	remove_proc_entry("remaddr", proc_net_sctp);
>> +}
>> +
>> +static int sctp_remaddr_seq_open(struct inode *inode, struct file *file)
>> +{
>> +	return seq_open(file, &sctp_remaddr_ops);
>> +}
>> +
>> +static const struct file_operations sctp_remaddr_seq_fops = {
>> +	.open = sctp_remaddr_seq_open,
>> +	.read = seq_read,
>> +	.llseek = seq_lseek,
>> +	.release = seq_release,
>> +};
>> +
>> +int __init sctp_remaddr_proc_init(void)
>> +{
>> +	struct proc_dir_entry *p;
>> +
>> +	p = create_proc_entry("remaddr", S_IRUGO, proc_net_sctp);
>> +	if (!p)
>> +		return -ENOMEM;
>> +	p->proc_fops = &sctp_remaddr_seq_fops;
>> +
>> +	return 0;
>> +}
>> +
>> +void sctp_assoc_proc_exit(void)
>> +{
>> +	remove_proc_entry("remaddr", proc_net_sctp);
>> +}
>> +
>> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
>> index d50f610..15be5cb 100644
>> --- a/net/sctp/protocol.c
>> +++ b/net/sctp/protocol.c
>> @@ -113,6 +113,8 @@ static __init int sctp_proc_init(void)
>>  		goto out_nomem;
>>  	if (sctp_assocs_proc_init())
>>  		goto out_nomem;
>> +	if (sctp_remaddr_proc_init())
>> +		goto out_nomem;
>>   	return 0;
>>  @@ -129,6 +131,7 @@ static void sctp_proc_exit(void)
>>  	sctp_snmp_proc_exit();
>>  	sctp_eps_proc_exit();
>>  	sctp_assocs_proc_exit();
>> +	sctp_remaddr_proc_exit();
>>   	if (proc_net_sctp) {
>>  		proc_net_sctp = NULL;

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
