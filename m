From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 12 Dec 2017 14:02:56 +0000
Subject: Re: [PATCH net-next 4/8] sctp: implement report_ftsn for sctp_stream_interleave
Message-Id: <CADvbK_dVaU-Q15x-W+owKx1VuUSiFAmG3H1ag0YLwJfKaUmikA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513070662.git.lucien.xin@gmail.com> <5bdf9baf00c367ec91c1e06986be77835be7e451.1513070662.git.lucien.xin@gmail.com>
 <20171212132514.GC3532@localhost.localdomain>
In-Reply-To: <20171212132514.GC3532@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>

On Tue, Dec 12, 2017 at 9:25 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Tue, Dec 12, 2017 at 05:25:55PM +0800, Xin Long wrote:
>> report_ftsn is added as a member of sctp_stream_interleave, used to
>> skip tsn from tsnmap, remove old events from reasm or lobby queue,
>> and abort pd for data or idata, called for SCTP_CMD_REPORT_FWDTSN
>> cmd and asoc reset.
>>
>> sctp_report_iftsn works for ifwdtsn, and sctp_report_fwdtsn works
>> for fwdtsn. Note that sctp_report_iftsn doesn't do asoc abort_pd,
>> as stream abort_pd will be done when handling ifwdtsn. But when
>> ftsn is equal with ftsn, which means asoc reset, asoc abot_pd has
>    nit...                                         aboRt ^^^^ :-)
ah sorry, 'set spell' could tell when it's together with _pd. :D
