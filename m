From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 12 Mar 2018 15:50:38 +0000
Subject: Re: [PATCH net-next] sctp: fix error return code in sctp_sendmsg_new_asoc()
Message-Id: <20180312155038.GA5106@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1520856964-132516-1-git-send-email-weiyongjun1@huawei.com>
 <CADvbK_fFdFJ4uREOP2bAYShB_TkP5Xi3d0v1_YodazNYyMjAdw@mail.gmail.com>
In-Reply-To: <CADvbK_fFdFJ4uREOP2bAYShB_TkP5Xi3d0v1_YodazNYyMjAdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Mon, Mar 12, 2018 at 09:38:53PM +0800, Xin Long wrote:
> On Mon, Mar 12, 2018 at 8:16 PM, Wei Yongjun <weiyongjun1@huawei.com> wrote:
...
> Btw, the 'err' initialization can also be removed in your patch.
 
I second this.

