From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 19 Aug 2019 17:58:51 +0000
Subject: Re: [PATCH net-next 0/8] sctp: support per endpoint auth and asconf flags
Message-Id: <20190819175851.GF2870@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Mon, Aug 19, 2019 at 10:02:42PM +0800, Xin Long wrote:
> This patchset mostly does 3 things:
> 
>   1. add per endpint asconf flag and use asconf flag properly
>      and add SCTP_ASCONF_SUPPORTED sockopt.
>   2. use auth flag properly and add SCTP_AUTH_SUPPORTED sockopt.
>   3. remove the 'global feature switch' to discard chunks.

What about net->sctp.addip_noauth, why wasn't it included as well?
I'm thinking that's because it's more of a compatibility knob and
that there isn't much value on having it more fine-grained than
per-netns. Just feels a bit odd to have the other two but not this
one, which is directly related, but yeah.

Otherwise, changes LGTM.
