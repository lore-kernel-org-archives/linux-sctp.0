From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 12 Feb 2013 15:20:42 +0000
Subject: Re: [PATCH net-next v2] net: sctp: remove unused multiple cookie keys
Message-Id: <20130212152042.GB7849@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1360682133-17658-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1360682133-17658-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Vlad Yasevich <vyasevic@redhat.com>

On Tue, Feb 12, 2013 at 04:15:33PM +0100, Daniel Borkmann wrote:
> Vlad says: The whole multiple cookie keys code is completely unused
> and has been all this time. Noone uses anything other then the
> secret_key[0] since there is no changeover support anywhere.
> 
> Thus, for now clean up its left-over fragments.
> 
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Vlad Yasevich <vyasevic@redhat.com>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

