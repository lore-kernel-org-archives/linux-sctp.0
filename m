From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 18 Feb 2016 13:59:33 +0000
Subject: Re: [PATCH net 1/3] sctp: move rcu_read_lock from __sctp_lookup_association to sctp_lookup_associati
Message-Id: <CADvbK_dt7WEjw=o1zhObgdT5Q9HLtRAppr5iEQAOu6ggfwvv2Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1455517541.git.lucien.xin@gmail.com>
	<c805e4a1994f53947351e8d4dd79609fd206e807.1455517541.git.lucien.xin@gmail.com>
	<20160217161104.GA17476@hmsreliant.think-freely.org>
In-Reply-To: <20160217161104.GA17476@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, davem <davem@davemloft.net>

On Thu, Feb 18, 2016 at 12:11 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Feb 15, 2016 at 02:28:03PM +0800, Xin Long wrote:
>> __sctp_lookup_association() is only invoked by sctp_v4_err() and
>> sctp_rcv(), both which run on the rx BH, and it has been protected
>> by rcu_read_lock [see ip_local_deliver_finish() / ipv6_rcv()].
>>
>> So we can move it to sctp_lookup_association, only let
>> sctp_lookup_association use rcu_read_lock.
>>
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Not that it was right before if this is true, but if we're using rcu in a bottom
> half path, shouldn't rcu_read_lock_bh be used instead here?
>
the resource is also accessed in threads, not only in BH, so we cannot
use rcu_read_lock_bh here.

> Neil
>
