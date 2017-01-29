From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sun, 29 Jan 2017 14:39:43 +0000
Subject: Re: A PMTU auto-discovery error for large SCTP packets
Message-Id: <20170129143943.GL3781@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <07B7943445653648AD9B4DBB916BB48F1C265220@cnshjmbx01>
In-Reply-To: <07B7943445653648AD9B4DBB916BB48F1C265220@cnshjmbx01>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: YUAN Jia <Jia.Yuan@alcatel-sbell.com.cn>
Cc: "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, 'network dev' <netdev@vger.kernel.org>

On Wed, Jan 25, 2017 at 06:40:10AM +0000, YUAN Jia wrote:
...
> I think that ‘sctp_manip_pkt’ should also behave like this. Isn’t it?

I believe so, yes.
Will you send a patch?

Btw, your host did have a MTU bigger than 1500, right? I'm just curious
on why such big packet was generated in the first place.

  Marcelo

