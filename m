From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Feb 2018 07:24:06 +0000
Subject: Re: [PATCH net] sctp: rename sctp_diag.c as diag.c
Message-Id: <CADvbK_eacYGnzek+RJj_b5v+JB1oOnyW4v5gtfJo_3gqOXaFWQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0b9abe0b402eaa4c5c71a3d165669814f1789cee.1518431550.git.lucien.xin@gmail.com>
 <20180212123704.GL7402@localhost.localdomain> <20180212.101224.44294606381993057.davem@davemloft.net>
In-Reply-To: <20180212.101224.44294606381993057.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>

On Mon, Feb 12, 2018 at 11:12 PM, David Miller <davem@davemloft.net> wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date: Mon, 12 Feb 2018 10:37:04 -0200
>
>> On Mon, Feb 12, 2018 at 06:32:30PM +0800, Xin Long wrote:
>>> Remove sctp_ prefix for diag file, to keep consistent with other
>>> files' names, while at it, also to add file comments for diag.c.
>>
>> Okay but this should be a two-patches series then. The changes made
>> with the rename are hard to find/follow later.
>
> Agreed, the file move should be a separate change from and
> modifications to the file itself.
I will post a two-patch series for this soon.
