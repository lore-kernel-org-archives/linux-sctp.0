From: David Miller <davem@davemloft.net>
Date: Tue, 18 Feb 2014 21:07:30 +0000
Subject: Re: [PATCH net] net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode
Message-Id: <20140218.160730.1363339001953107311.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1392635471-31528-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1392635471-31528-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 17 Feb 2014 12:11:11 +0100

> SCTP's sctp_connectx() abi breaks for 64bit kernels compiled with 32bit
> emulation (e.g. ia32 emulation or x86_x32). Due to internal usage of
> 'struct sctp_getaddrs_old' which includes a struct sockaddr pointer,
> sizeof(param) check will always fail in kernel as the structure in
> 64bit kernel space is 4bytes larger than for user binaries compiled
> in 32bit mode. Thus, applications making use of sctp_connectx() won't
> be able to run under such circumstances.
> 
> Introduce a compat interface in the kernel to deal with such
> situations by using a 'struct compat_sctp_getaddrs_old' structure
> where user data is copied into it, and then sucessively transformed
> into a 'struct sctp_getaddrs_old' structure with the help of
> compat_ptr(). That fixes sctp_connectx() abi without any changes
> needed in user space, and lets the SCTP test suite pass when compiled
> in 32bit and run on 64bit kernels.
> 
> Fixes: f9c67811ebc0 ("sctp: Fix regression introduced by new sctp_connectx api")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied and queued up for -stable, thanks.
