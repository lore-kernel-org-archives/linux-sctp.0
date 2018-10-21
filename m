From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 21 Oct 2018 06:58:12 +0000
Subject: Re: [PATCH net-next 0/3] sctp: add support for sk_reuseport
Message-Id: <CADvbK_fVP8jKS72=DfCpkT3C9VKHKhkY0zD0znCwiJzncpfLfA@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="000000000000abaf540578b7a96d"
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1540095102.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1540095102.git.lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>

--000000000000abaf540578b7a96d
Content-Type: text/plain; charset="UTF-8"

On Sun, Oct 21, 2018 at 1:43 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> sctp sk_reuseport allows multiple socks to listen on the same port and
> addresses, as long as these socks have the same uid. This works pretty
> much as TCP/UDP does, the only difference is that sctp is multi-homing
> and all the bind_addrs in these socks will have to completely matched,
> otherwise listen() will return err.
>
> The below is when 5 sockets are listening on 172.16.254.254:6400 on a
> server, 26 sockets on a client connect to 172.16.254.254:6400 and each
> may be processed by a different socket on the server which is selected
> by hash(lport, pport, paddr) in reuseport_select_sock():
>
>  # ss --sctp -nn
>    State      Recv-Q Send-Q        Local Address:Port     Peer Address:Port
>    LISTEN     0      10           172.16.254.254:6400                *:*
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.2.1:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.2.4:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.3.3:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.3.4:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.5.2:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.5.3:1234
>    LISTEN     0      10           172.16.254.254:6400                *:*
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.1.3:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.1.4:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.3.2:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.4.1:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.4.2:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.4.3:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.4.4:1234
>    LISTEN     0      10           172.16.254.254:6400                *:*
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.1.2:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.3.5:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.4.5:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400   172.16.253.253:1234
>    LISTEN     0      10           172.16.254.254:6400                *:*
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.2.2:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.2.3:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.5.4:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.5.5:1234
>    LISTEN     0      10           172.16.254.254:6400                *:*
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.1.1:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.1.5:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.2.5:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.3.1:1234
>    `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.5.1:1234
Attached is the testcase based on sctp-tests.git.

>
> Xin Long (3):
>   sctp: do reuseport_select_sock in __sctp_rcv_lookup_endpoint
>   sctp: add sock_reuseport for the sock in __sctp_hash_endpoint
>   sctp: process sk_reuseport in sctp_get_port_local
>
>  include/net/sctp/sctp.h    |   2 +-
>  include/net/sctp/structs.h |   6 ++-
>  net/core/sock_reuseport.c  |   1 +
>  net/sctp/bind_addr.c       |  28 ++++++++++
>  net/sctp/input.c           | 129 ++++++++++++++++++++++++++++++++-------------
>  net/sctp/socket.c          |  49 +++++++++++------
>  6 files changed, 162 insertions(+), 53 deletions(-)
>
> --
> 2.1.0
>

--000000000000abaf540578b7a96d
Content-Type: application/x-gzip; name="reuseport.tar.gz"
Content-Disposition: attachment; filename="reuseport.tar.gz"
Content-Transfer-Encoding: base64
Content-ID: <f_jniis5i00>
X-Attachment-Id: f_jniis5i00

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
--000000000000abaf540578b7a96d--
