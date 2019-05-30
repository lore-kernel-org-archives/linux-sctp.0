From: David Miller <davem@davemloft.net>
Date: Thu, 30 May 2019 21:36:04 +0000
Subject: Re: [PATCH net-next] sctp: deduplicate identical skb_checksum_ops
Message-Id: <20190530.143604.925231544360388287.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190529153941.12166-1-mcroce@redhat.com>
In-Reply-To: <20190529153941.12166-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mcroce@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-kernel@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Wed, 29 May 2019 17:39:41 +0200

> The same skb_checksum_ops struct is defined twice in two different places,
> leading to code duplication. Declare it as a global variable into a common
> header instead of allocating it on the stack on each function call.
> bloat-o-meter reports a slight code shrink.
> 
> add/remove: 1/1 grow/shrink: 0/10 up/down: 128/-1282 (-1154)
> Function                                     old     new   delta
> sctp_csum_ops                                  -     128    +128
> crc32c_csum_ops                               16       -     -16
> sctp_rcv                                    6616    6583     -33
> sctp_packet_pack                            4542    4504     -38
> nf_conntrack_sctp_packet                    4980    4926     -54
> execute_masked_set_action                   6453    6389     -64
> tcf_csum_sctp                                575     428    -147
> sctp_gso_segment                            1292    1126    -166
> sctp_csum_check                              579     412    -167
> sctp_snat_handler                            957     772    -185
> sctp_dnat_handler                           1321    1132    -189
> l4proto_manip_pkt                           2536    2313    -223
> Total: Before59297613, After59296459, chg -0.00%
> 
> Reviewed-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied.
