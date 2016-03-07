From: kbuild test robot <lkp@intel.com>
Date: Mon, 07 Mar 2016 23:17:55 +0000
Subject: Re: [PATCH net] sctp: fix copying more bytes than expected in sctp_add_bind_addr
Message-Id: <201603080758.oSIf1B2b%fengguang.wu@intel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <508c18fbd4bd0b447e2f9b110190be2fd2dbb3cf.1453744111.git.marcelo.leitner@gmail.com>
In-Reply-To: <508c18fbd4bd0b447e2f9b110190be2fd2dbb3cf.1453744111.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Marcelo,

[auto build test WARNING on net/master]

url:    https://github.com/0day-ci/linux/commits/Marcelo-Ricardo-Leitner/sctp-fix-copying-more-bytes-than-expected-in-sctp_add_bind_addr/20160308-052009


coccinelle warnings: (new ones prefixed by >>)

>> net/sctp/bind_addr.c:458:42-48: ERROR: application of sizeof to pointer

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
