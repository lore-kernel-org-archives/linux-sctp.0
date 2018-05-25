From: David Ahern <dsa@cumulusnetworks.com>
Date: Fri, 25 May 2018 20:06:03 +0000
Subject: Re: [PATCH net-next] vrf: add CRC32c offload to device features
Message-Id: <829661ca-fe17-8a96-3cf2-146f24943ac0@cumulusnetworks.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <bb3aa69eaef613f033f8f52674740286ba67dc31.1527175921.git.dcaratti@redhat.com>
In-Reply-To: <bb3aa69eaef613f033f8f52674740286ba67dc31.1527175921.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Davide Caratti <dcaratti@redhat.com>, Vlad Yasevich <vyasevich@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 5/24/18 9:49 AM, Davide Caratti wrote:
> SCTP sockets originated in a VRF can improve their performance if CRC32c
> computation is delegated to underlying devices: update device features,
> setting NETIF_F_SCTP_CRC. Iterating the following command in the topology
> proposed with [1],
> 
>  # ip vrf exec vrf-h2 netperf -H 192.0.2.1 -t SCTP_STREAM -- -m 10K
> 
> the measured throughput in Mbit/s improved from 2395 ± 1% to 2720 ± 1%.
> 
> [1] https://www.spinics.net/lists/netdev/msg486007.html
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  drivers/net/vrf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: David Ahern <dsa@cumulusnetworks.com>
