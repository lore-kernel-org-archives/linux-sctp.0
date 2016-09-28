From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 28 Sep 2016 12:35:40 +0000
Subject: Re: [PATCHv2 net 0/5] sctp: some fixes of prsctp polices
Message-Id: <CADvbK_eKrZaGf0uDsCBdkWCw9e51W-HVL=_WLsR4RaSKjNmqqA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1475059350.git.lucien.xin@gmail.com> <20160928.081303.661512609700070565.davem@davemloft.net>
In-Reply-To: <20160928.081303.661512609700070565.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

>
>> This patchset is to improve some codes about prsctp polices, and also
>> to fix some issues.
>>
>> v1->v2:
>>   - wrap the check of chunk->sent_count in a macro:
>>     sctp_chunk_retransmitted in patch 2/5.
>
> This series is a mix of bug fixes (patch #1) which should be targetting
> 'net' and simplifications/cleanups (patch #2-5) which should be targetting
> 'net-next'.
>
> Please do not mix things up like this, and submit patches targetting
> the appropriate tree.
>
understand, I wanted to divide them.
but this patchset is special, the following patches
depend on patch 1/5.
