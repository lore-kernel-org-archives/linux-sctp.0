From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Aug 2008 01:28:32 +0000
Subject: Re: [Security] [PATCH] sctp: add verification checks to SCTP_AUTH_KEY
Message-Id: <alpine.LFD.1.10.0808251827240.3363@nehalem.linux-foundation.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080825164440.GA504@kernel.sg> <12196959323990-git-send-email-vladislav.yasevich@hp.com> <48B35561.2010001@redhat.com> <alpine.LFD.1.10.0808251816110.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808251816110.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eugene Teo <eteo@redhat.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, security@kernel.org, davem@davemloft.net



On Mon, 25 Aug 2008, Linus Torvalds wrote:
> 
> But if it can overflow, I actually think it makes more sense to test for 
> something smaller than the "exact" overflow. A key can't reasonably be all 
> that long _anyway_, so it's probably better to test for something _much_ 
> smaller.

IOW, I think it would make _more_ sense to just declare some "key size 
max", and do something like

	#define SCTP_AUTH_KEY_SIZE (65536)

	.. 
	if (key_len > SCTP_AUTH_KEY_SIZE)
		return -EINVAL;

kind of thing.

		Linus
