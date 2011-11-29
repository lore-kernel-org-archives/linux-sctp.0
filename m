From: Xi Wang <xi.wang@gmail.com>
Date: Tue, 29 Nov 2011 19:31:30 +0000
Subject: Re: [PATCH] sctp: integer overflow in sctp_auth_create_key()
Message-Id: <BC344CCF-A50F-4E5E-A9A5-F506D8BD9DB9@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <028246D6-9024-4E43-93A1-25A87878CBBC@gmail.com> <20111129.011932.1501413448765180498.davem@davemloft.net>
In-Reply-To: <20111129.011932.1501413448765180498.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, security@kernel.org

Sorry my bad.

BTW it seems that the patch was not applied correctly either in
the commit a5e5c374 --- it says "No differences found".

Can you please apply the new patch v2?  Thanks.

- xi

On Nov 29, 2011, at 1:19 AM, David Miller wrote:
> 
> Applied, but I had to apply your patch by hand because it was
> corrupted by your email client.
> 
> Please fix this problem because I am not applying any other patch
> you've submitted which has this issue.

