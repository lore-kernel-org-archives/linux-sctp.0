From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 30 Sep 2020 06:26:31 +0000
Subject: Re: [PATCH net-next 13/15] sctp: support for sending packet over udp4 sock
Message-Id: <CADvbK_cKHg=TD7h=Ddaon_T0t7+G81Pg_EJ2CeOtvq7TcQKO=Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <82b358f40c81cfdecbfc394113be40fd1f682043.1601387231.git.lucien.xin@gmail.com>
 <202009300036.j5lTE8CI-lkp@intel.com>
In-Reply-To: <202009300036.j5lTE8CI-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kernel test robot <lkp@intel.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, kbuild-all@lists.01.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>

On Wed, Sep 30, 2020 at 12:26 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20200929-215159
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 280095713ce244e8dbdfb059cdca695baa72230a
> config: ia64-randconfig-r014-20200929 (attached as .config)
> compiler: ia64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/a1016fd4a55f176fcc2eae05052a61ad7d5a142b
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20200929-215159
>         git checkout a1016fd4a55f176fcc2eae05052a61ad7d5a142b
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=ia64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    net/sctp/protocol.c: In function 'sctp_udp_sock_start':
> >> net/sctp/protocol.c:894:11: error: 'struct udp_port_cfg' has no member named 'local_ip6'; did you mean 'local_ip'?
>      894 |  udp_conf.local_ip6 = in6addr_any;
>          |           ^~~~~~~~~
>          |           local_ip
>
> vim +894 net/sctp/protocol.c
>
> a330bee1c278f8 Xin Long 2020-09-29  870
> 140bb5309cf409 Xin Long 2020-09-29  871  int sctp_udp_sock_start(struct net *net)
> 140bb5309cf409 Xin Long 2020-09-29  872  {
> 140bb5309cf409 Xin Long 2020-09-29  873         struct udp_tunnel_sock_cfg tuncfg = {NULL};
> 140bb5309cf409 Xin Long 2020-09-29  874         struct udp_port_cfg udp_conf = {0};
> 140bb5309cf409 Xin Long 2020-09-29  875         struct socket *sock;
> 140bb5309cf409 Xin Long 2020-09-29  876         int err;
> 140bb5309cf409 Xin Long 2020-09-29  877
> 140bb5309cf409 Xin Long 2020-09-29  878         udp_conf.family = AF_INET;
> 140bb5309cf409 Xin Long 2020-09-29  879         udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
> 140bb5309cf409 Xin Long 2020-09-29  880         udp_conf.local_udp_port = htons(net->sctp.udp_port);
> 140bb5309cf409 Xin Long 2020-09-29  881         err = udp_sock_create(net, &udp_conf, &sock);
> 140bb5309cf409 Xin Long 2020-09-29  882         if (err)
> 140bb5309cf409 Xin Long 2020-09-29  883                 return err;
> 140bb5309cf409 Xin Long 2020-09-29  884
> 140bb5309cf409 Xin Long 2020-09-29  885         tuncfg.encap_type = 1;
> 140bb5309cf409 Xin Long 2020-09-29  886         tuncfg.encap_rcv = sctp_udp_rcv;
> a330bee1c278f8 Xin Long 2020-09-29  887         tuncfg.encap_err_lookup = sctp_udp_err_lookup;
> 140bb5309cf409 Xin Long 2020-09-29  888         setup_udp_tunnel_sock(net, sock, &tuncfg);
> 140bb5309cf409 Xin Long 2020-09-29  889         net->sctp.udp4_sock = sock->sk;
> 140bb5309cf409 Xin Long 2020-09-29  890
> cff8956126170d Xin Long 2020-09-29  891         memset(&udp_conf, 0, sizeof(udp_conf));
> cff8956126170d Xin Long 2020-09-29  892
> cff8956126170d Xin Long 2020-09-29  893         udp_conf.family = AF_INET6;
> cff8956126170d Xin Long 2020-09-29 @894         udp_conf.local_ip6 = in6addr_any;
> cff8956126170d Xin Long 2020-09-29  895         udp_conf.local_udp_port = htons(net->sctp.udp_port);
> cff8956126170d Xin Long 2020-09-29  896         udp_conf.use_udp6_rx_checksums = true;
> cff8956126170d Xin Long 2020-09-29  897         udp_conf.ipv6_v6only = true;
> cff8956126170d Xin Long 2020-09-29  898         err = udp_sock_create(net, &udp_conf, &sock);
> cff8956126170d Xin Long 2020-09-29  899         if (err) {
> cff8956126170d Xin Long 2020-09-29  900                 udp_tunnel_sock_release(net->sctp.udp4_sock->sk_socket);
> cff8956126170d Xin Long 2020-09-29  901                 net->sctp.udp4_sock = NULL;
> cff8956126170d Xin Long 2020-09-29  902                 return err;
> cff8956126170d Xin Long 2020-09-29  903         }
> cff8956126170d Xin Long 2020-09-29  904
> cff8956126170d Xin Long 2020-09-29  905         tuncfg.encap_type = 1;
> cff8956126170d Xin Long 2020-09-29  906         tuncfg.encap_rcv = sctp_udp_rcv;
> a330bee1c278f8 Xin Long 2020-09-29  907         tuncfg.encap_err_lookup = sctp_udp_err_lookup;
> cff8956126170d Xin Long 2020-09-29  908         setup_udp_tunnel_sock(net, sock, &tuncfg);
> cff8956126170d Xin Long 2020-09-29  909         net->sctp.udp6_sock = sock->sk;
#if IS_ENABLED(CONFIG_IPV6) is needed for this part.

Thanks.
> cff8956126170d Xin Long 2020-09-29  910
> 140bb5309cf409 Xin Long 2020-09-29  911         return 0;
> 140bb5309cf409 Xin Long 2020-09-29  912  }
> 140bb5309cf409 Xin Long 2020-09-29  913
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
