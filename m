From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 31 Mar 2019 08:56:40 +0000
Subject: Re: [PATCH net-next 0/2] sctp: fully support memory accounting
Message-Id: <CADvbK_fuTOQYZxN+d4OkwEZmjVacP6OK5YAszuijNa=3RQenBA@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="000000000000be879005856015c7"
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1554022192.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1554022192.git.lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>, Matteo Croce <mcroce@redhat.com>, Vladis Dronov <vdronov@redhat.com>

--000000000000be879005856015c7
Content-Type: text/plain; charset="UTF-8"

Simple tests are as attached.

On Sun, Mar 31, 2019 at 4:53 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> sctp memory accounting is added in this patchset by using
> these kernel APIs on send side:
>
>   - sk_mem_charge()
>   - sk_mem_uncharge()
>   - sk_wmem_schedule()
>   - sk_under_memory_pressure()
>   - sk_mem_reclaim()
>
> and these on receive side:
>
>   - sk_mem_charge()
>   - sk_mem_uncharge()
>   - sk_rmem_schedule()
>   - sk_under_memory_pressure()
>   - sk_mem_reclaim()
>
> With sctp memory accounting, we can limit the memory allocation by
> either sysctl:
>
>   # sysctl -w net.sctp.sctp_mem="10 20 50"
>
> or cgroup:
>
>   # echo $((8<<14)) > \
>     /sys/fs/cgroup/memory/sctp_mem/memory.kmem.tcp.limit_in_bytes
>
> When the socket is under memory pressure, the send side will block
> and wait, while the receive side will renege or drop.
>
> Xin Long (2):
>   sctp: implement memory accounting on tx path
>   sctp: implement memory accounting on rx path
>
>  include/net/sctp/sctp.h |  2 +-
>  net/sctp/sm_statefuns.c |  6 ++++--
>  net/sctp/socket.c       | 10 ++++++++--
>  net/sctp/ulpevent.c     | 19 ++++++++-----------
>  net/sctp/ulpqueue.c     |  3 ++-
>  5 files changed, 23 insertions(+), 17 deletions(-)
>
> --
> 2.1.0
>

--000000000000be879005856015c7
Content-Type: text/x-sh; charset="US-ASCII"; name="sysctl_sockets_memctl.sh"
Content-Disposition: attachment; filename="sysctl_sockets_memctl.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_jtwowonb1>
X-Attachment-Id: f_jtwowonb1

IyEvYmluL3NoCgojIFRPUE86IGxvY2FsICgxMC43My4xMzEuMTU4KSA8LS0+IHBlZXIgKDEwLjcz
LjEzMS4yMDIpIFtob3N0cyBub3QgbmV0bnNdCgpwZWVyX3J1bigpCnsKCXNzaCByb290QDEwLjcz
LjEzMS4yMDIgIiRAIgoJIyBlY2hvICIgLSBwZWVyIHJ1bjogJEAiCgkjIGVjaG8gIiAtIHByaW50
IGFueSBrZXkgdG8gY29udGludWUgYWZ0ZXIgaXQncyBkb25lIgoJIyByZWFkCn0KCm1vZHByb2Jl
IHNjdHAKCmVjaG8gInNjdHAgc3lzY3RsIG1lbW9yeSBjb250cm9sIHJtZW06IgplY2hvICItLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSIKCmVjaG8gIjEwIDIwIDUwIHJtZW0gbGltaXQg
LT4iCnBraWxsIHNjdHBfdGVzdCAyPiAvZGV2L251bGwKc3lzY3RsIC13ICBuZXQuc2N0cC5zY3Rw
X21lbT0iMTAgMjAgNTAiCnNjdHBfdGVzdCAtSCAxMC43My4xMzEuMTU4IC1QIDEyMzQgLWwgPiAv
ZGV2L251bGwgMj4mMSAmCnNsZWVwIDMKcGVlcl9ydW4gInRpbWUgc2N0cF90ZXN0IC1IIDEwLjcz
LjEzMS4yMDIgLVAgODAwMCAtaCAxMC43My4xMzEuMTU4IC1wIDEyMzQgLXMgLWMgNSAgPiAvZGV2
L251bGwgMj4mMSIKZWNobyAiIgoKZWNobyAiMjAgNTAgMTAwIHJtZW0gbGltaXQgLT4iCnBraWxs
IHNjdHBfdGVzdCAyPiAvZGV2L251bGwKc3lzY3RsIC13ICBuZXQuc2N0cC5zY3RwX21lbT0iMjAg
NTAgMTAwIgpzY3RwX3Rlc3QgLUggMTAuNzMuMTMxLjE1OCAtUCAxMjM0IC1sID4gL2Rldi9udWxs
IDI+JjEgJgpzbGVlcCAzCnBlZXJfcnVuICJ0aW1lIHNjdHBfdGVzdCAtSCAxMC43My4xMzEuMjAy
IC1QIDgwMDAgLWggMTAuNzMuMTMxLjE1OCAtcCAxMjM0IC1zIC1jIDUgID4gL2Rldi9udWxsIDI+
JjEiCmVjaG8gIiIKCmVjaG8gInNjdHAgc3lzY3RsIG1lbW9yeSBjb250cm9sIHdtZW06IgplY2hv
ICItLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSIKCnBlZXJfcnVuICJzY3RwX3Rlc3Qg
LUggMTAuNzMuMTMxLjIwMiAtUCA4MDAwIC1sID4gL2Rldi9udWxsIDI+JjEgJiIKdGMgcWRpc2Mg
YWRkIGRldiBldGgwIHJvb3QgbmV0ZW0gZGVsYXkgNTBtcwplY2hvICIxMCAyMCA1MCB3bWVtIGxp
bWl0IC0+IgpzeXNjdGwgLXcgIG5ldC5zY3RwLnNjdHBfbWVtPSI1IDEwIDIwIgp0aW1lIHNjdHBf
dGVzdCAtaCAxMC43My4xMzEuMjAyIC1wIDgwMDAgLUggMTAuNzMuMTMxLjE1OCAtUCAxMjM0IC1z
IC1jIDUgID4gL2Rldi9udWxsIDI+JjEKZWNobyAiIgoKZWNobyAiMTAgNTAgMTAwIHdtZW0gbGlt
aXQgLT4iCnN5c2N0bCAtdyAgbmV0LnNjdHAuc2N0cF9tZW09IjEwIDUwIDEwMCAtPiIKdGltZSBz
Y3RwX3Rlc3QgLWggMTAuNzMuMTMxLjIwMiAtcCA4MDAwIC1IIDEwLjczLjEzMS4xNTggLVAgMTIz
NCAtcyAtYyA1ICA+IC9kZXYvbnVsbCAyPiYxCmVjaG8gIiIKdGMgcWRpc2MgZGVsZXRlIGRldiBl
dGgwIHJvb3QKcGVlcl9ydW4gInBraWxsIHNjdHBfdGVzdCAyPi9kZXYvbnVsbCIK
--000000000000be879005856015c7
Content-Type: text/x-sh; charset="US-ASCII"; name="cgroup_sockets_memctl.sh"
Content-Disposition: attachment; filename="cgroup_sockets_memctl.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_jtwowomz0>
X-Attachment-Id: f_jtwowomz0

IyEvYmluL3NoCgojIFRPUE86IDEyNy4wLjAuMSBsbwoKbW9kcHJvYmUgc2N0cApwa2lsbCBzY3Rw
X3Rlc3QgMj4gL2Rldi9udWxsCnNjdHBfdGVzdCAtSCAxMjcuMC4wLjEgLVAgMTIzNCAtbCA+IC9k
ZXYvbnVsbCAyPiYxICYKc2xlZXAgMwpta2RpciAvc3lzL2ZzL2Nncm91cC9tZW1vcnkvc2N0cF9t
ZW0gPiAvZGV2L251bGwgMj4mMTsKCmVjaG8gInNjdHBfd21lbSB0ZXN0aW5nOiIKZWNobyAiLS0t
LS0tLS0tLS0tLS0tLS0tIgoKZWNobyAiJCgoODw8MTQpKSBieXRlcyBmb3Igd21lbSBsaW1pdCAt
PiIKZWNobyAkKCg4PDwxNCkpID4vc3lzL2ZzL2Nncm91cC9tZW1vcnkvc2N0cF9tZW0vbWVtb3J5
LmttZW0udGNwLmxpbWl0X2luX2J5dGVzCnsKCWVjaG8gJEJBU0hQSUQgPiAvc3lzL2ZzL2Nncm91
cC9tZW1vcnkvc2N0cF9tZW0vY2dyb3VwLnByb2NzCgl0aW1lIHNjdHBfdGVzdCAtSCAxMjcuMC4w
LjEgLVAgODAwMCAtaCAxMjcuMC4wLjEgLXAgMTIzNCAtcyAtYyA1ICA+IC9kZXYvbnVsbCAyPiYx
CgllY2hvICIiCn0gJgp3YWl0ICQhCgplY2hvICIkKCg4PDwxNikpIGJ5dGVzIGZvciB3bWVtIGxp
bWl0IC0+IgplY2hvICQoKDg8PDE2KSkgPi9zeXMvZnMvY2dyb3VwL21lbW9yeS9zY3RwX21lbS9t
ZW1vcnkua21lbS50Y3AubGltaXRfaW5fYnl0ZXMKewoJZWNobyAkQkFTSFBJRCA+IC9zeXMvZnMv
Y2dyb3VwL21lbW9yeS9zY3RwX21lbS9jZ3JvdXAucHJvY3MKCXRpbWUgc2N0cF90ZXN0IC1IIDEy
Ny4wLjAuMSAtUCA4MDAwIC1oIDEyNy4wLjAuMSAtcCAxMjM0IC1zIC1jIDUgID4gL2Rldi9udWxs
IDI+JjEKCWVjaG8gIiIKfSAmCndhaXQgJCEKCgplY2hvICJzY3RwX3JtZW0gdGVzdGluZzoiCmVj
aG8gIi0tLS0tLS0tLS0tLS0tLS0tLSIKCmVjaG8gIiQoKDg8PDEzKSkgYnl0ZXMgZm9yIHJtZW0g
bGltaXQgLT4iCnBraWxsIHNjdHBfdGVzdCAyPiAvZGV2L251bGwKZWNobyAkKCg4PDwxMykpID4v
c3lzL2ZzL2Nncm91cC9tZW1vcnkvc2N0cF9tZW0vbWVtb3J5LmttZW0udGNwLmxpbWl0X2luX2J5
dGVzCnsKCWVjaG8gJEJBU0hQSUQgPiAvc3lzL2ZzL2Nncm91cC9tZW1vcnkvc2N0cF9tZW0vY2dy
b3VwLnByb2NzCglzY3RwX3Rlc3QgLUggMTI3LjAuMC4xIC1QIDEyMzQgLWwgPiAvZGV2L251bGwg
Mj4mMQp9ICYKc2xlZXAgMwp0aW1lIHNjdHBfdGVzdCAtSCAxMjcuMC4wLjEgLVAgODAwMCAtaCAx
MjcuMC4wLjEgLXAgMTIzNCAtcyAtYyA1ICA+IC9kZXYvbnVsbCAyPiYxCmVjaG8gIiIKCmVjaG8g
IiQoKDg8PDE0KSkgYnl0ZXMgZm9yIHJtZW0gbGltaXQgLT4iCnBraWxsIHNjdHBfdGVzdCAyPiAv
ZGV2L251bGwKZWNobyAkKCg4PDwxNCkpID4vc3lzL2ZzL2Nncm91cC9tZW1vcnkvc2N0cF9tZW0v
bWVtb3J5LmttZW0udGNwLmxpbWl0X2luX2J5dGVzCnsKCWVjaG8gJEJBU0hQSUQgPiAvc3lzL2Zz
L2Nncm91cC9tZW1vcnkvc2N0cF9tZW0vY2dyb3VwLnByb2NzCglzY3RwX3Rlc3QgLUggMTI3LjAu
MC4xIC1QIDEyMzQgLWwgPiAvZGV2L251bGwgMj4mMQp9ICYKc2xlZXAgMwp0aW1lIHNjdHBfdGVz
dCAtSCAxMjcuMC4wLjEgLVAgODAwMCAtaCAxMjcuMC4wLjEgLXAgMTIzNCAtcyAtYyA1ICA+IC9k
ZXYvbnVsbCAyPiYxCmVjaG8gIiIKCmVjaG8gInNjdHBfd21lbV9hbmRfcm1lbSB0ZXN0aW5nOiIK
ZWNobyAiLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIgoKZWNobyAiJCgoODw8MTQpKSBieXRl
cyBmb3Igd21lbSBBTkQgcm1lbSBsaW1pdCAtPiIKcGtpbGwgc2N0cF90ZXN0IDI+IC9kZXYvbnVs
bAplY2hvICQoKDg8PDE0KSkgPi9zeXMvZnMvY2dyb3VwL21lbW9yeS9zY3RwX21lbS9tZW1vcnku
a21lbS50Y3AubGltaXRfaW5fYnl0ZXMKewoJZWNobyAkQkFTSFBJRCA+IC9zeXMvZnMvY2dyb3Vw
L21lbW9yeS9zY3RwX21lbS9jZ3JvdXAucHJvY3MKCXNjdHBfdGVzdCAtSCAxMjcuMC4wLjEgLVAg
MTIzNCAtbCA+IC9kZXYvbnVsbCAyPiYxICYKCXNsZWVwIDMKCXRpbWUgc2N0cF90ZXN0IC1IIDEy
Ny4wLjAuMSAtUCA4MDAwIC1oIDEyNy4wLjAuMSAtcCAxMjM0IC1zIC1jIDUgID4gL2Rldi9udWxs
IDI+JjEKCWVjaG8gIiIKfSAmCndhaXQK
--000000000000be879005856015c7--
