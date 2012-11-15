From: David Miller <davem@davemloft.net>
Date: Thu, 15 Nov 2012 18:56:23 +0000
Subject: Re: [PATCHv2] sctp: fix /proc/net/sctp/ memory leak
Message-Id: <20121115.135623.45874794041542310.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1352987345-11263-1-git-send-email-tt.rantala@gmail.com>
In-Reply-To: <1352987345-11263-1-git-send-email-tt.rantala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tt.rantala@gmail.com
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, davej@redhat.com, ebiederm@xmission.com

From: Tommi Rantala <tt.rantala@gmail.com>
Date: Thu, 15 Nov 2012 15:49:05 +0200

> Commit 13d782f ("sctp: Make the proc files per network namespace.")
> changed the /proc/net/sctp/ struct file_operations opener functions to
> use single_open_net() and seq_open_net().
> 
> Avoid leaking memory by using single_release_net() and seq_release_net()
> as the release functions.
> 
> Discovered with Trinity (the syscall fuzzer).
> 
> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Applied.
