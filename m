From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 30 Jul 2010 13:13:52 +0000
Subject: Re: [RFC PATCH]sctp: handle ASCONF-ACK which contains Request Refused
Message-Id: <4C52D010.4090303@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C528EDC.9000006@cn.fujitsu.com>
In-Reply-To: <4C528EDC.9000006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 07/30/2010 04:35 AM, Shan Wei wrote:
> 
> If Host-A sends an ASCONF request for adding IP-A address, Host-Z may sent ASCONF-ACK
> which contains Error Cause: Request Refused(error = 0x00A4), for the local security 
> policy or other problems. See below chart:
> 
> Host-A                                Host-Z
>    -------ASCONF(ADDIP[IP-A])---------->
> 
>    <------ASCONF-ACK(error=0x00A4)------
> 
> 
> Host-Z would thought the operation of adding IP-A at Host-A is fail, and the IP-A address
> is not part of this association. So, If Host-Z sends HEARBEAT to check the IP-A path, 
> Host-A should treat this chunk as OOTB.

Host Z will not send anything since he address was never added to the association on Host Z.
So the above is moot.

> 
> However, because there is no implementation of local security policy settings in sctp protocol,
> ASCONF-ACK chunk which contains Request Refused error never be sent, and  will be ignored 
> by the receiver.(when received ASCONF-ACK, no more further treatment.) 
> So, If Host-Z sends HEARBEAT to check the IP-A path, Host-A doesn't treat this chunk as OOTB,
> and sends HEARTBEAT-ACK from primary address.
> 
> Although Freebsd and Linux still does not send ASCONF-ACK (error = 0x00A4), but we can not
> guarantee that other systems will not too. Therefore, It's necessary to do something when
> receiving ASCONF-ACK(error = 0x00A4).
> 
> The current handle is to send ABORT terminates the association, but this will lead to termination
> of other paths in the association. 
> 
> Is there better way to fix it?
> 

I don't think this is really a problem.  The issue really is on the host that sent the asconf (host A)
in this case.  It has done part of the work, but is depending on the ACK to finish the work.  

Since the asconf is forbidden by host Z, and host A has two options on what to do:
	1.  Ignore the asconf-ack.  This is what we do now.  This leaves Host A in a half-finished state.
	    When adding or deleting addresses, it will leave them in the association, but
	    the state will remain unusable.

	2.  Unwind everything that this specific parameter of the asconf tried to do.  That means that
	    we would need to change the state back the address that we were trying to remove.  This would
	    require a little more code, but should be doable.

-vlad


> 
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
> ---
>  net/sctp/sm_make_chunk.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 246f929..147cca4 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3344,6 +3344,10 @@ int sctp_process_asconf_ack(struct sctp_association *asoc,
>  			break;
>  
>  		case SCTP_ERROR_REQ_REFUSED:
> +			if (asconf_param->param_hdr.type = SCTP_PARAM_ADD_IP)
> +				retval = 1;
> +			break;
> +
>  		case SCTP_ERROR_DEL_LAST_IP:
>  		case SCTP_ERROR_DEL_SRC_IP:
>  		default:

