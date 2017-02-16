From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 16 Feb 2017 15:40:33 +0000
Subject: Re: [PATCH net-next] sctp: change to use uint<size>_t in uapi sctp.h
Message-Id: <CADvbK_c82TA+NETwPsMuTCx=k7tc9d6Wwi4yK5Y5NKOOVb5eTg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <05fb9cd9aed85d33cc8d635a18b0dcd3e7c0ff29.1487060628.git.lucien.xin@gmail.com>
 <20170214.112604.827348279100654183.davem@davemloft.net>
In-Reply-To: <20170214.112604.827348279100654183.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

On Wed, Feb 15, 2017 at 12:26 AM, David Miller <davem@davemloft.net> wrote:
> From: Xin Long <lucien.xin@gmail.com>
> Date: Tue, 14 Feb 2017 16:23:48 +0800
>
>> All structures in uapi sctp.h are exported for userspace, their members'
>> types should use uint<size>_t instead of __u<size>.
>
> This is not true.
>
> __u<size> is in fact preferred for userspace exported datastructures.
Hi, David, can you tell more details about uint<size>_t and __u<size>,
especially for usage of kernel and userspace in linux ?
or some documents about them.

Thanks.
