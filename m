From: David Miller <davem@davemloft.net>
Date: Fri, 08 Feb 2013 04:45:20 +0000
Subject: Re: [PATCH net-next] net: sctp: sctp_auth_make_key_vector: remove duplicate ntohs calls
Message-Id: <20130207.234520.1493484945207262693.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360237025.git.dborkman@redhat.com>
	<c029f55f4d0bde790f77f62d623f4d1e387c4c0b.1360237025.git.dborkman@redhat.com>
In-Reply-To: <c029f55f4d0bde790f77f62d623f4d1e387c4c0b.1360237025.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: vyasevich@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu,  7 Feb 2013 12:41:39 +0100

> Instead of calling 3 times ntohs(random->param_hdr.length), 2 times
> ntohs(hmacs->param_hdr.length), and 3 times ntohs(chunks->param_hdr.length)
> within the same function, we only call each once and store it in a
> variable.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied.
