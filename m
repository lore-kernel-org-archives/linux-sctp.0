From: David Miller <davem@davemloft.net>
Date: Mon, 04 Mar 2013 19:14:49 +0000
Subject: Re: [Patch net] sctp: use KMALLOC_MAX_SIZE instead of its own MAX_KMALLOC_SIZE
Message-Id: <20130304.141449.1630318569008015881.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1362364107-26908-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1362364107-26908-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: amwang@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, sri@us.ibm.com, nhorman@tuxdriver.com

From: Cong Wang <amwang@redhat.com>
Date: Mon,  4 Mar 2013 10:28:27 +0800

> From: Cong Wang <amwang@redhat.com>
> 
> Don't definite its own MAX_KMALLOC_SIZE, use the one
> defined in mm.
> 
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Sridhar Samudrala <sri@us.ibm.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Cong Wang <amwang@redhat.com>

Applied.
