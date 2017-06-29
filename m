From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 29 Jun 2017 17:33:14 +0000
Subject: Re: SCTP_SOCKOPT_PEELOFF is missing SOCK_CLOEXEC (and SOCK_NONBLOCK)
Message-Id: <20170629173314.GA14751@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1497965053.10887.2.camel@domdv.de>
In-Reply-To: <1497965053.10887.2.camel@domdv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jun 26, 2017 at 11:57:10AM +0200, Andreas Steinmetz wrote:
> A quick test with retrieving the flags with fcntl(F_GETFD/F_GETFL)
> after peeloff shows that your patch works. Good job!
> 
nm, I realized that I needed to update lksctp-tools for this too, and tested it
myself with that.  It seems to work for me, I'll post this officially shortly.

Neil

