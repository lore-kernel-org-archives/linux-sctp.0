From: David Miller <davem@davemloft.net>
Date: Tue, 08 Apr 2014 18:46:01 +0000
Subject: Re: [PATCH net v2] net: sctp: wake up all assocs if sndbuf policy is per socket
Message-Id: <20140408.144601.1499418906739470715.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140408.131819.1373401078750444800.davem@davemloft.net>
	<53442FD0.5020609@redhat.com>
	<20140408.141918.1353780924646899277.davem@redhat.com>
In-Reply-To: <20140408.141918.1353780924646899277.davem@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, tgraf@suug.ch, nhorman@tuxdriver.com, vyasevic@redhat.com


Daniel and Vlad, I'm about to send Linus a pull request.

I know that you still need to fixup this SCTP change and it'll be
in there, but I really need to get the changes in my tree staged
so that I can do a set of -stable submissions.

So please don't freak out, I know that this change still needs work
and shouldn't go to -stable just yet :-)
