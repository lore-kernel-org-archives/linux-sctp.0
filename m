From: David Miller <davem@davemloft.net>
Date: Wed, 18 Jan 2017 19:55:28 +0000
Subject: Re: [PATCHv4 net-next 0/6] sctp: add sender-side procedures for stream reconf ssn reset request chun
Message-Id: <20170118.145528.656758298004770748.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1484670664.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1484670664.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 18 Jan 2017 00:44:41 +0800

> Patch 6/6 is to implement sender-side procedures for the Outgoing
> and Incoming SSN Reset Request Parameter described in rfc6525
> section 5.1.2 and 5.1.3
> 
> Patches 1-5/6 are ahead of it to define some apis and asoc members
> for it.
> 
> Note that with this patchset, asoc->reconf_enable has no chance yet to
> be set, until the patch "sctp: add get and set sockopt for reconf_enable"
> is applied in the future. As we can not just enable it when sctp is not
> capable of processing reconf chunk yet.
> 
> v1->v2:
>   - put these into a smaller group.
>   - rename some temporary variables in the codes.
>   - rename the titles of the commits and improve some changelogs.
> v2->v3:
>   - re-split the patchset and make sure it has no dead codes for review.
> v3->v4:
>   - move sctp_make_reconf() into patch 1/6 to avoid kbuild warning.
>   - drop unused struct sctp_strreset_req.

Series applied, thank you.
