From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 23 Jan 2015 11:50:25 +0000
Subject: Re: Fwd: Question on SCTP ABORT chunk is generated when the association_max_retrans is reached
Message-Id: <54C23581.9060809@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com> <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com>
In-Reply-To: <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sun Paul <paulrbk@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, vyasevich@gmail.com

Hi,

On 01/23/2015 11:25 AM, Sun Paul wrote:
...
> I would like to check the behave in LKSCTP.
>
> we are running DIAMETER message over SCTP, and we have set the
> parameter "net.sctp.association_max_retrans = 4" in the LinuxOS.
>
> We noticed that when remote peer have retry to send the same request
> for 4 times, the LKSCTP will initiate an ABORT chunk with reason
> "association exceeded its max_retrans count".
>
> We would like to know whether this is the correct behavior? is there
> any other option that we can alter in order to avoid the ABORT chunk
> being sent?

I don't recall the RFC saying to send an ABORT, but let me double
check in the mean time.

Hmm, untested, but could you try something like that?

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index fef2acd..5ce198d 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -584,7 +584,8 @@ static void sctp_cmd_assoc_failed(sctp_cmd_seq_t *commands,
  		sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP,
  				SCTP_ULPEVENT(event));

-	if (asoc->overall_error_count >= asoc->max_retrans) {
+	if (asoc->overall_error_count >= asoc->max_retrans &&
+	    error != SCTP_ERROR_NO_ERROR) {
  		abort = sctp_make_violation_max_retrans(asoc, chunk);
  		if (abort)
  			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
