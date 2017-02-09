From: David Miller <davem@davemloft.net>
Date: Thu, 09 Feb 2017 21:58:10 +0000
Subject: Re: [PATCHv6 net-next 0/6] sctp: add sender-side procedures for stream reconf asoc reset and add str
Message-Id: <20170209.165810.1019732594616565226.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1486573727.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1486573727.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu,  9 Feb 2017 01:18:14 +0800

> Patch 4/6 is to implement sender-side procedures for the SSN/TSN Reset
> Request Parameter described in rfc6525 section 5.1.4, patch 3/6 is
> ahead of it to define a function to make the request chunk for it.
> 
> Patch 6/6 is to implement sender-side procedures for the Add Incoming
> and Outgoing Streams Request Parameter Request Parameter described in
> rfc6525 section 5.1.5 and 5.1.6, patch 5/6 is ahead of it to define a
> function to make the request chunk for it.
> 
> Patch 2/6 is a fix to recover streams states when it fails to send
> request and Patch 1/6 is to drop some unncessary __packed from some
> old structures.

Series applied with stray __packed reference removed from the commit
message of patch #3.
