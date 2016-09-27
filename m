From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 27 Sep 2016 09:54:07 +0000
Subject: Re: [PATCH net 2/5] sctp: reuse sent_count to avoid retransmitted chunks for RTT measurements
Message-Id: <CADvbK_fFkn1PcRnRg2PJnCEnhLfojSHp+LCKCWWwxM_xi-fJfQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1474883200.git.lucien.xin@gmail.com> <e8146a7075544ccb2631117f507cfd51e20b4cde.1474883200.git.lucien.xin@gmail.com>
 <20160926131300.GA6812@hmsreliant.think-freely.org>
In-Reply-To: <20160926131300.GA6812@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

>
> Maybe wrap this in a macro?  i.e.:
> #define chunk_retransmitted(chunk) (chunk->sent_count > 1)
>
> For readability?
>
That's a nice suggestion.
chunk->sent_count = 1 is confusing there for reading.
will improve it in v2.

Thanks.
