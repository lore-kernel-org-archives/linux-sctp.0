From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 19 Dec 2017 04:07:06 +0000
Subject: Re: [PATCH net] sctp: add SCTP_CID_RECONF conversion in sctp_cname
Message-Id: <CADvbK_d309m-VAEhTTQDcaxJ=-KK35ktZsSr_5CQwqSo5L8YUw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <ae9172b7dc432d6092ab2bc061a0cf322a3939b5.1513577597.git.lucien.xin@gmail.com>
 <20171218130810.GA6123@localhost.localdomain>
In-Reply-To: <20171218130810.GA6123@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>

On Mon, Dec 18, 2017 at 9:08 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Mon, Dec 18, 2017 at 02:13:17PM +0800, Xin Long wrote:
>> Whenever a new type of chunk is added, the corresp conversion in
>> sctp_cname should be added. Otherwise, in some places, pr_debug
>> will print it as "unknown chunk".
>>
>> Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Acked-by: Marcelo R. Leitner <marcelo.leitner@gmail.com>
>
> ...
>>       case SCTP_CID_AUTH:
>>               return "AUTH";
>>
>> +     case SCTP_CID_RECONF:
>> +             return "RECONF";
>> +
>>       default:
>>               break;
>
> Now we also need idata and ifwdtsn in there too, btw.
Yes, waiting for the merge from net-next to net.

>
>   Marcelo
