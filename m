From: David Miller <davem@davemloft.net>
Date: Mon, 30 Mar 2020 05:02:42 +0000
Subject: Re: [PATCH net] sctp: fix possibly using a bad saddr with a given dst
Message-Id: <20200329.220242.1383520985415551854.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <d6baf212bdd7c54df847e0b5117406419c993a4f.1585182887.git.mleitner@redhat.com>
In-Reply-To: <d6baf212bdd7c54df847e0b5117406419c993a4f.1585182887.git.mleitner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, lucien.xin@gmail.com, meng.a.jin@nokia-sbell.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Mar 2020 20:47:46 -0300

> Under certain circumstances, depending on the order of addresses on the
> interfaces, it could be that sctp_v[46]_get_dst() would return a dst
> with a mismatched struct flowi.
> 
> For example, if when walking through the bind addresses and the first
> one is not a match, it saves the dst as a fallback (added in
> 410f03831c07), but not the flowi. Then if the next one is also not a
> match, the previous dst will be returned but with the flowi information
> for the 2nd address, which is wrong.
> 
> The fix is to use a locally stored flowi that can be used for such
> attempts, and copy it to the parameter only in case it is a possible
> match, together with the corresponding dst entry.
> 
> The patch updates IPv6 code mostly just to be in sync. Even though the issue
> is also present there, it fallback is not expected to work with IPv6.
> 
> Fixes: 410f03831c07 ("sctp: add routing output fallback")
> Reported-by: Jin Meng <meng.a.jin@nokia-sbell.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable.
