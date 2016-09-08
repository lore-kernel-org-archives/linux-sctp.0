From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 08 Sep 2016 12:45:35 +0000
Subject: RE: [PATCH net] sctp: hold the transport before using it in sctp_hash_cmp
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DB00F7710@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <f71c2e03ae6e9b956f41c73fff5a282c86d79daf.1473328144.git.lucien.xin@gmail.com>
In-Reply-To: <f71c2e03ae6e9b956f41c73fff5a282c86d79daf.1473328144.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: "davem@davemloft.net" <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>

From: Xin Long
> Sent: 08 September 2016 10:49
> Now sctp uses the transport without holding it in sctp_hash_cmp,
> it can cause a use-after-free panic. As after it get transport from
> hashtable, another CPU may free it, then the members it accesses
> may be unavailable memory.

How old is this bug?
Is it in any release kernels?

	David

