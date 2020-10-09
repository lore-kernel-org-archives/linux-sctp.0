From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 09 Oct 2020 01:59:18 +0000
Subject: Re: [PATCHv2 net-next 05/17] sctp: create udp4 sock and add its encap_rcv
Message-Id: <CADvbK_f2neAmkuHytPJ=Gc7TEf4nHjDZ1k2C_p6MUSBJtK6w5A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <202010090235.YqoHRhHI-lkp@intel.com>
In-Reply-To: <202010090235.YqoHRhHI-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kernel test robot <lkp@intel.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, kbuild-all@lists.01.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem <davem@davemloft.net>

On Fri, Oct 9, 2020 at 2:30 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20201008-175211
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9faebeb2d80065926dfbc09cb73b1bb7779a89cd
> config: arm-keystone_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/55d6ef371ddfab66c7767da14b490f7576262f1a
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20201008-175211
>         git checkout 55d6ef371ddfab66c7767da14b490f7576262f1a
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arm
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    arm-linux-gnueabi-ld: net/sctp/protocol.o: in function `sctp_udp_sock_start':
> >> protocol.c:(.text+0x1084): undefined reference to `udp_sock_create4'
> >> arm-linux-gnueabi-ld: protocol.c:(.text+0x10b0): undefined reference to `setup_udp_tunnel_sock'
>    arm-linux-gnueabi-ld: net/sctp/protocol.o: in function `sctp_udp_sock_stop':
> >> protocol.c:(.text+0x1108): undefined reference to `udp_tunnel_sock_release'
diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 39d7fa9569f8..5da599ff84a9 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -11,6 +11,7 @@ menuconfig IP_SCTP
        select CRYPTO_HMAC
        select CRYPTO_SHA1
        select LIBCRC32C
+       select NET_UDP_TUNNEL
        help
          Stream Control Transmission Protocol

>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
