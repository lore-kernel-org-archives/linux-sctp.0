From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 09 Jan 2018 17:44:40 +0000
Subject: sctp: memory leak in sctp_endpoint_init
Message-Id: <CACT4Y+avNW05tiE7Qr4mx+X6dSVaTHL4MLuByF8viNyouMYiww@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="94eb2c1f40046173ab05625b7926"
List-Id: <linux-sctp.vger.kernel.org>
To: Vladislav Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>

--94eb2c1f40046173ab05625b7926
Content-Type: text/plain; charset="UTF-8"

Hello,

syzkaller has hit the following memory leak on 4.15-rc7.
Reproducer is attached.

unferenced object 0xffff88007bbaa720 (size 32):
  comm "syz-executor4", pid 12479, jiffies 4295951917 (age 9.779s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000ce041e0c>] kmemleak_alloc_recursive
include/linux/kmemleak.h:55 [inline]
    [<00000000ce041e0c>] slab_post_alloc_hook mm/slab.h:440 [inline]
    [<00000000ce041e0c>] slab_alloc_node mm/slub.c:2725 [inline]
    [<00000000ce041e0c>] slab_alloc mm/slub.c:2733 [inline]
    [<00000000ce041e0c>] kmem_cache_alloc_trace+0x126/0x290 mm/slub.c:2750
    [<0000000052b69e97>] kmalloc include/linux/slab.h:499 [inline]
    [<0000000052b69e97>] kzalloc include/linux/slab.h:688 [inline]
    [<0000000052b69e97>] sctp_endpoint_init net/sctp/endpointola.c:66 [inline]
    [<0000000052b69e97>] sctp_endpoint_new+0x16d/0xef0
net/sctp/endpointola.c:195
    [<00000000b78002d9>] sctp_init_sock+0xc18/0x13e0 net/sctp/socket.c:4490
    [<00000000fe5de849>] inet6_create+0xba7/0x1290 net/ipv6/af_inet6.c:255
    [<00000000bb006173>] __sock_create+0x521/0x920 net/socket.c:1265
    [<00000000a8d6fbc0>] sock_create net/socket.c:1305 [inline]
    [<00000000a8d6fbc0>] SYSC_socket net/socket.c:1335 [inline]
    [<00000000a8d6fbc0>] SyS_socket+0x102/0x1f0 net/socket.c:1315
    [<000000004dc391b5>] entry_SYSCALL_64_fastpath+0x23/0x9a
    [<00000000c66d20cc>] 0xffffffffffffffff

2018/01/09 15:50:01 BUG: memory leak
unreferenced object 0xffff88007bbaac30 (size 32):
  comm "syz-executor4", pid 12479, jiffies 4295951917 (age 9.791s)
  hex dump (first 32 bytes):
    f0 45 4b 2a 00 88 ff ff f0 45 4b 2a 00 88 ff ff  .EK*.....EK*....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000ce041e0c>] kmemleak_alloc_recursive
include/linux/kmemleak.h:55 [inline]
    [<00000000ce041e0c>] slab_post_alloc_hook mm/slab.h:440 [inline]
    [<00000000ce041e0c>] slab_alloc_node mm/slub.c:2725 [inline]
    [<00000000ce041e0c>] slab_alloc mm/slub.c:2733 [inline]
    [<00000000ce041e0c>] kmem_cache_alloc_trace+0x126/0x290 mm/slub.c:2750
    [<0000000069bdc070>] kmalloc include/linux/slab.h:499 [inline]
    [<0000000069bdc070>] kzalloc include/linux/slab.h:688 [inline]
    [<0000000069bdc070>] sctp_auth_shkey_create+0xbb/0x1f0 net/sctp/auth.c:99
    [<00000000604efa40>] sctp_endpoint_init net/sctp/endpointola.c:151 [inline]
    [<00000000604efa40>] sctp_endpoint_new+0x65b/0xef0
net/sctp/endpointola.c:195
    [<00000000b78002d9>] sctp_init_sock+0xc18/0x13e0 net/sctp/socket.c:4490
    [<00000000fe5de849>] inet6_create+0xba7/0x1290 net/ipv6/af_inet6.c:255
    [<00000000bb006173>] __sock_create+0x521/0x920 net/socket.c:1265
    [<00000000a8d6fbc0>] sock_create net/socket.c:1305 [inline]
    [<00000000a8d6fbc0>] SYSC_socket net/socket.c:1335 [inline]
    [<00000000a8d6fbc0>] SyS_socket+0x102/0x1f0 net/socket.c:1315
    [<000000004dc391b5>] entry_SYSCALL_64_fastpath+0x23/0x9a
    [<00000000c66d20cc>] 0xffffffffffffffff

--94eb2c1f40046173ab05625b7926
Content-Type: text/x-csrc; charset="US-ASCII"; name="sctp.c"
Content-Disposition: attachment; filename="sctp.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jc7xdmjv0

Ly8gYXV0b2dlbmVyYXRlZCBieSBzeXprYWxsZXIgKGh0dHA6Ly9naXRodWIuY29tL2dvb2dsZS9z
eXprYWxsZXIpCgojZGVmaW5lIF9HTlVfU09VUkNFCiNpbmNsdWRlIDxlbmRpYW4uaD4KI2luY2x1
ZGUgPGxpbnV4L2Z1dGV4Lmg+CiNpbmNsdWRlIDxwdGhyZWFkLmg+CiNpbmNsdWRlIDxzdGRpbnQu
aD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMv
c3lzY2FsbC5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgpzdHJ1Y3QgdGhyZWFkX3QgewogIGludCBj
cmVhdGVkLCBydW5uaW5nLCBjYWxsOwogIHB0aHJlYWRfdCB0aDsKfTsKCnN0YXRpYyBzdHJ1Y3Qg
dGhyZWFkX3QgdGhyZWFkc1sxNl07CnN0YXRpYyB2b2lkIGV4ZWN1dGVfY2FsbChpbnQgY2FsbCk7
CnN0YXRpYyBpbnQgcnVubmluZzsKc3RhdGljIGludCBjb2xsaWRlOwoKc3RhdGljIHZvaWQqIHRo
cih2b2lkKiBhcmcpCnsKICBzdHJ1Y3QgdGhyZWFkX3QqIHRoID0gKHN0cnVjdCB0aHJlYWRfdCop
YXJnOwogIGZvciAoOzspIHsKICAgIHdoaWxlICghX19hdG9taWNfbG9hZF9uKCZ0aC0+cnVubmlu
ZywgX19BVE9NSUNfQUNRVUlSRSkpCiAgICAgIHN5c2NhbGwoU1lTX2Z1dGV4LCAmdGgtPnJ1bm5p
bmcsIEZVVEVYX1dBSVQsIDAsIDApOwogICAgZXhlY3V0ZV9jYWxsKHRoLT5jYWxsKTsKICAgIF9f
YXRvbWljX2ZldGNoX3N1YigmcnVubmluZywgMSwgX19BVE9NSUNfUkVMQVhFRCk7CiAgICBfX2F0
b21pY19zdG9yZV9uKCZ0aC0+cnVubmluZywgMCwgX19BVE9NSUNfUkVMRUFTRSk7CiAgICBzeXNj
YWxsKFNZU19mdXRleCwgJnRoLT5ydW5uaW5nLCBGVVRFWF9XQUtFKTsKICB9CiAgcmV0dXJuIDA7
Cn0KCnN0YXRpYyB2b2lkIGV4ZWN1dGUoaW50IG51bV9jYWxscykKewogIGludCBjYWxsLCB0aHJl
YWQ7CiAgcnVubmluZyA9IDA7CiAgZm9yIChjYWxsID0gMDsgY2FsbCA8IG51bV9jYWxsczsgY2Fs
bCsrKSB7CiAgICBmb3IgKHRocmVhZCA9IDA7IHRocmVhZCA8IHNpemVvZih0aHJlYWRzKSAvIHNp
emVvZih0aHJlYWRzWzBdKTsgdGhyZWFkKyspIHsKICAgICAgc3RydWN0IHRocmVhZF90KiB0aCA9
ICZ0aHJlYWRzW3RocmVhZF07CiAgICAgIGlmICghdGgtPmNyZWF0ZWQpIHsKICAgICAgICB0aC0+
Y3JlYXRlZCA9IDE7CiAgICAgICAgcHRocmVhZF9hdHRyX3QgYXR0cjsKICAgICAgICBwdGhyZWFk
X2F0dHJfaW5pdCgmYXR0cik7CiAgICAgICAgcHRocmVhZF9hdHRyX3NldHN0YWNrc2l6ZSgmYXR0
ciwgMTI4IDw8IDEwKTsKICAgICAgICBwdGhyZWFkX2NyZWF0ZSgmdGgtPnRoLCAmYXR0ciwgdGhy
LCB0aCk7CiAgICAgIH0KICAgICAgaWYgKCFfX2F0b21pY19sb2FkX24oJnRoLT5ydW5uaW5nLCBf
X0FUT01JQ19BQ1FVSVJFKSkgewogICAgICAgIHRoLT5jYWxsID0gY2FsbDsKICAgICAgICBfX2F0
b21pY19mZXRjaF9hZGQoJnJ1bm5pbmcsIDEsIF9fQVRPTUlDX1JFTEFYRUQpOwogICAgICAgIF9f
YXRvbWljX3N0b3JlX24oJnRoLT5ydW5uaW5nLCAxLCBfX0FUT01JQ19SRUxFQVNFKTsKICAgICAg
ICBzeXNjYWxsKFNZU19mdXRleCwgJnRoLT5ydW5uaW5nLCBGVVRFWF9XQUtFKTsKICAgICAgICBp
ZiAoY29sbGlkZSAmJiBjYWxsICUgMikKICAgICAgICAgIGJyZWFrOwogICAgICAgIHN0cnVjdCB0
aW1lc3BlYyB0czsKICAgICAgICB0cy50dl9zZWMgPSAwOwogICAgICAgIHRzLnR2X25zZWMgPSAy
MCAqIDEwMDAgKiAxMDAwOwogICAgICAgIHN5c2NhbGwoU1lTX2Z1dGV4LCAmdGgtPnJ1bm5pbmcs
IEZVVEVYX1dBSVQsIDEsICZ0cyk7CiAgICAgICAgaWYgKHJ1bm5pbmcpCiAgICAgICAgICB1c2xl
ZXAoKGNhbGwgPT0gbnVtX2NhbGxzIC0gMSkgPyAxMDAwMCA6IDEwMDApOwogICAgICAgIGJyZWFr
OwogICAgICB9CiAgICB9CiAgfQp9Cgpsb25nIHJbMV07CnZvaWQgZXhlY3V0ZV9jYWxsKGludCBj
YWxsKQp7CiAgc3dpdGNoIChjYWxsKSB7CiAgY2FzZSAwOgogICAgc3lzY2FsbChfX05SX21tYXAs
IDB4MjAwMDAwMDAsIDB4ZmZmMDAwLCAzLCAweDMyLCAtMSwgMCk7CiAgICBicmVhazsKICBjYXNl
IDE6CiAgICBzeXNjYWxsKF9fTlJfZ2V0cGlkKTsKICAgIGJyZWFrOwogIGNhc2UgMjoKICAgIHJb
MF0gPSBzeXNjYWxsKF9fTlJfc29ja2V0LCAweGEsIDUsIDB4ODQpOwogICAgYnJlYWs7CiAgY2Fz
ZSAzOgogICAgKih1aW50NjRfdCopMHgyMDQ2ZWZmMCA9IDA7CiAgICAqKHVpbnQ2NF90KikweDIw
NDZlZmY4ID0gMDsKICAgIHN5c2NhbGwoX19OUl9zZXRybGltaXQsIDcsIDB4MjA0NmVmZjApOwog
ICAgYnJlYWs7CiAgY2FzZSA0OgogICAgKih1aW50MzJfdCopMHgyMDJiZjAwMCA9IDA7CiAgICBz
eXNjYWxsKF9fTlJfaW9jdGwsIHJbMF0sIDB4ODk0YywgMHgyMDJiZjAwMCk7CiAgICBicmVhazsK
ICB9Cn0KCnZvaWQgbG9vcCgpCnsKICBtZW1zZXQociwgLTEsIHNpemVvZihyKSk7CiAgZXhlY3V0
ZSg1KTsKICBjb2xsaWRlID0gMTsKICBleGVjdXRlKDUpOwp9CgppbnQgbWFpbigpCnsKICBsb29w
KCk7CiAgcmV0dXJuIDA7Cn0K
--94eb2c1f40046173ab05625b7926--
