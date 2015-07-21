From: David Miller <davem@davemloft.net>
Date: Tue, 21 Jul 2015 07:20:45 +0000
Subject: Re: [PATCH v2 0/2] sctp: fix src address selection if using secondary address
Message-Id: <20150721.002045.1819611920291195410.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1437145508.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1437145508.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 17 Jul 2015 12:34:16 -0300

> This series improves the way SCTP chooses its src address so that the
> choosen one will always belong to the interface being used for output.
> 
> v1->v2:
>  - split out the refactoring from the fix itself
>  - Doing a full reverse routing as in v1 is not necessary. Only looking
>    for the interface that has the address and comparing its number is
>    enough.

Series applied, thanks.
