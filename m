From: David Miller <davem@davemloft.net>
Date: Wed, 06 Dec 2017 20:13:03 +0000
Subject: Re: [PATCH V2] selinux: Add SCTP support
Message-Id: <20171206.151303.1526119083235256934.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171206101736.3217-1-richard_c_haines@btinternet.com>
In-Reply-To: <20171206101736.3217-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

From: Richard Haines <richard_c_haines@btinternet.com>
Date: Wed,  6 Dec 2017 10:17:36 +0000

> The SELinux SCTP implementation is explained in:
> Documentation/security/SELinux-sctp.rst
> 
> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>

No general objections from the networking side, so:

Acked-by: David S. Miller <davem@davemloft.net>

from me.  But if I were you I'd wait for some review from the
SCTP maintainers and experts. :-)
