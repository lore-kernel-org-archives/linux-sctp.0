From: James Morris <james.l.morris@oracle.com>
Date: Fri, 20 Oct 2017 04:53:03 +0000
Subject: Re: [RFC PATCH 1/5] security: Add support for SCTP security hooks
Message-Id: <alpine.LFD.2.20.1710201551200.4174@t440>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171017140247.4604-1-richard_c_haines@btinternet.com>
In-Reply-To: <20171017140247.4604-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Tue, 17 Oct 2017, Richard Haines wrote:

> The SCTP security hooks are explained in:
> Documentation/security/LSM-sctp.txt
> 
> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> ---
>  Documentation/security/LSM-sctp.txt | 212 ++++++++++++++++++++++++++++++++++++
>  include/linux/lsm_hooks.h           |  37 +++++++
>  include/linux/security.h            |  27 +++++
>  security/security.c                 |  23 ++++
>  4 files changed, 299 insertions(+)
>  create mode 100644 Documentation/security/LSM-sctp.txt

This looks ok from an LSM API pov, but note that I'm not an expert on 
SCTP.  It would be good to see more review from networking folk.


Reviewed-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<james.l.morris@oracle.com>

