From: Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 06 May 2020 06:47:03 +0000
Subject: Re: [PATCH 0/2] Backport to 4.19 - sctp: fully support memory accounting
Message-Id: <20200506064703.GA2273049@kroah.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1588242081.git.ashwinh@vmware.com>
In-Reply-To: <cover.1588242081.git.ashwinh@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ashwin-h <ashwinh@vmware.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, srivatsab@vmware.com, srivatsa@csail.mit.edu, rostedt@goodmis.org, srostedt@vmware.com, ashwin.hiranniah@gmail.com

On Wed, May 06, 2020 at 07:50:52PM +0530, ashwin-h wrote:
> Backport below upstream commits to 4.19 to address CVE-2019-3874.
> 1033990ac5b2ab6cee93734cb6d301aa3a35bcaa
> sctp: implement memory accounting on tx path
> 
> 9dde27de3e5efa0d032f3c891a0ca833a0d31911
> sctp: implement memory accounting on rx path
> 
> Xin Long (2):
>   sctp: implement memory accounting on tx path
>   sctp: implement memory accounting on rx path
> 
>  include/net/sctp/sctp.h |  2 +-
>  net/sctp/sm_statefuns.c |  6 ++++--
>  net/sctp/socket.c       | 10 ++++++++--
>  net/sctp/ulpevent.c     | 19 ++++++++-----------
>  net/sctp/ulpqueue.c     |  3 ++-
>  5 files changed, 23 insertions(+), 17 deletions(-)
> 
> -- 
> 2.7.4
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
