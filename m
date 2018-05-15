From: David Miller <davem@davemloft.net>
Date: Tue, 15 May 2018 02:57:32 +0000
Subject: Re: [PATCH net-next v3 0/8] sctp: refactor sctp_outq_flush
Message-Id: <20180514.225732.1585931004339408037.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526318522.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526318522.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, lucien.xin@gmail.com, vyasevich@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 May 2018 14:34:35 -0300

> Currently sctp_outq_flush does many different things and arguably
> unrelated, such as doing transport selection and outq dequeueing.
> 
> This patchset refactors it into smaller and more dedicated functions.
> The end behavior should be the same.
> 
> The next patchset will rework the function parameters.
> 
> Changes since v1:
> - fix build issues on patches 3 and 4, and updated 5 and 8 because of
>   it.
> 
> Changes since v2:
> - fixed panic if building with just up to patch 3 applied

Series applied, thanks.
