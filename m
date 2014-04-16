From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 16 Apr 2014 07:58:39 +0000
Subject: Re: [PATCH]: NULL pointer dereference in sctp_auth_asoc_set_default_hmac
Message-Id: <534E382F.4030507@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <534E0C7A.9070309@gentoo.org>
In-Reply-To: <534E0C7A.9070309@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Joshua,

On 04/16/2014 06:52 AM, Joshua Kinard wrote:
> Hi linux-sctp,
>
> I stumbled into a NULL pointer dereference on amd64 and mips when receiving
> an INIT chunk containing the HMAC Algorithm Parameter (0x8004) when
> net.sctp.auth_enable = 1.
>
>  From some quick debugging I did, even if net.sctp.auth_enable = 1, the if
> statement on line 448 in net/sctp/auth.c::sctp_auth_init_hmacs() checks
> net->sctp.auth_enable and gets '0' back, which causes ep->auth_hmacs to get
> set to NULL:
>
> 448         if (!net->sctp.auth_enable) {
> 449                 ep->auth_hmacs = NULL;
> 450                 return 0;
> 451         }
>
>
> Later, the if statement on line 621 in
> net/sctp/auth.c::sctp_auth_asoc_set_default_hmac() attempts to access
> ep->auth_hmacs without first checking for NULL, which triggers the oops:

I presume at this point, it's net->sctp.auth_enable = 1 as we test for
it here before calling sctp_auth_asoc_set_default_hmac():

	case SCTP_PARAM_HMAC_ALGO:
		if (!net->sctp.auth_enable)
			goto fall_through;

Could it be that upon sctp_endpoint_init() time in your case,
sctp.auth_enable was still reset to 0, but you've set it between
sctp_endpoint_init() time and before invocation of
sctp_auth_asoc_set_default_hmac() to 1, so that this code path
will suddenly be taken, causing the NULL ptr deref?

> 620                 /* If this TFM has been allocated, use this id */
> 621                 if (ep->auth_hmacs[id]) {
> 622                         asoc->default_hmac_id = id;
> 623                         break;
> 624                 }
>
>
> I am not sure why net->sctp.auth_enable is initially returning '0' when it's
> set in sysctl, and verified in /proc/sys/net/sctp/auth_enable.  Adding a
> check for NULL on ep->auth_hmacs in the if statement stops the oops from
> happening, though I am not sure if this is the correct fix.
...
> Another thing I noticed, is that I cannot trigger the Oops from the
> SCTP/DTLS samples on this page:
> http://sctp.fh-muenster.de/dtls-samples.html
>
> But if I patch OpenSSH with the SCTP patch below, that does trigger it on
> the sshd server machine as soon as I issue 'ssh -z user@host ...'.  I've
> looked at both INIT chunks sent out by the respective programs in Wireshark,
> but nothing stands out.

Same symptoms?

Do you have a test pcap though?

> OpenSSH SCTP:
> https://bugzilla.mindrot.org/show_bug.cgi?id 16
>
> If anyone's got other ideas to try out, let me know, thanks!
