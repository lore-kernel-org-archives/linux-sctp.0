From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 May 2018 12:16:05 +0000
Subject: Re: [kbuild-all] [PATCH net-next 2/2] sctp: add sctp_make_op_error_limited and reuse inner functions
Message-Id: <20180514121605.GB5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <53909b1bd523d45a453431968fd1e03fd4be6196.1525017179.git.marcelo.leitner@gmail.com>
 <201804300849.DRgYHLmw%fengguang.wu@intel.com>
 <20180430023421.GA4977@localhost.localdomain>
 <20180514074053.GA21079@yexl-desktop>
 <20180514110123.GA5105@localhost.localdomain>
 <20180514114720.GA25280@yexl-desktop>
In-Reply-To: <20180514114720.GA25280@yexl-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ye Xiaolong <xiaolong.ye@intel.com>
Cc: kbuild test robot <lkp@intel.com>, Xin Long <lucien.xin@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, kbuild-all@01.org

On Mon, May 14, 2018 at 07:47:20PM +0800, Ye Xiaolong wrote:
> On 05/14, Marcelo Ricardo Leitner wrote:
> >On Mon, May 14, 2018 at 03:40:53PM +0800, Ye Xiaolong wrote:
> >> >> config: x86_64-randconfig-x006-201817 (attached as .config)
> >> >> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
> >> >> reproduce:
> >> >>         # save the attached .config to linux build tree
> >> >>         make ARCH=x86_64
> >> >>
> >> >> All errors (new ones prefixed by >>):
> >> >>
> >> >>    net//sctp/sm_make_chunk.c: In function 'sctp_make_op_error_limited':
> >> >> >> net//sctp/sm_make_chunk.c:1260:9: error: implicit declaration of function 'sctp_mtu_payload'; did you mean 'sctp_do_peeloff'? [-Werror=implicit-function-declaration]
> >> >>      size = sctp_mtu_payload(sp, size, sizeof(struct sctp_errhdr));
> >> >>             ^~~~~~~~~~~~~~~~
> >> >>             sctp_do_peeloff
> >> >>    cc1: some warnings being treated as errors
> >> >
> >> >Seems the test didn't pick up the MTU refactor patchset yet.
> >>
> >> Do you mean your patchset require MTU refactor patchset as prerequisites?
> >
> >Yes.
>
> Then it is recommended to use '--base' option of git format-patch, it would record
> the base tree info in the first patch or cover letter, 0day bot would apply your
> patchset to right base according to it.

Nice. I wasn't aware of it. Thanks.

Considering that the MTU refactor patchset was already applied on
net-next when the bot did the test, why should I have to specify the
base?

  Marcelo
