From: yegorslists@googlemail.com
Date: Fri, 04 Mar 2016 08:41:04 +0000
Subject: [PATCH 1/2] Add .gitignore files
Message-Id: <1457080865-30845-1-git-send-email-yegorslists@googlemail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 .gitignore                | 20 ++++++++++++++++++++
 bin/.gitignore            |  5 +++++
 src/apps/.gitignore       | 10 ++++++++++
 src/func_tests/.gitignore | 41 +++++++++++++++++++++++++++++++++++++++++
 src/withsctp/.gitignore   |  2 ++
 5 files changed, 78 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 bin/.gitignore
 create mode 100644 src/apps/.gitignore
 create mode 100644 src/func_tests/.gitignore
 create mode 100644 src/withsctp/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..eac9cca
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,20 @@
+aclocal.m4
+config.guess
+config.log
+config.status
+config.sub
+configure
+Makefile.in
+Makefile
+config.h
+config.h.in
+libsctp.pc
+libtool
+lksctp-tools.spec
+stamp-h1
+*.deps/
+*.libs/
+autom4te.cache/
+*.la
+*.lo
+*.o
diff --git a/bin/.gitignore b/bin/.gitignore
new file mode 100644
index 0000000..813925f
--- /dev/null
+++ b/bin/.gitignore
@@ -0,0 +1,5 @@
+compile
+depcomp
+install-sh
+ltmain.sh
+missing
diff --git a/src/apps/.gitignore b/src/apps/.gitignore
new file mode 100644
index 0000000..a7ba019
--- /dev/null
+++ b/src/apps/.gitignore
@@ -0,0 +1,10 @@
+bindx_test
+myftp
+nagle_rcv
+nagle_snd
+peel_client
+peel_server
+sctp_darn
+sctp_status
+sctp_test
+sctp_xconnect
diff --git a/src/func_tests/.gitignore b/src/func_tests/.gitignore
new file mode 100644
index 0000000..720db65
--- /dev/null
+++ b/src/func_tests/.gitignore
@@ -0,0 +1,41 @@
+test_1_to_1_accept_close
+test_1_to_1_addrs
+test_1_to_1_connect
+test_1_to_1_connectx
+test_1_to_1_events
+test_1_to_1_initmsg_connect
+test_1_to_1_nonblock
+test_1_to_1_recvfrom
+test_1_to_1_recvmsg
+test_1_to_1_rtoinfo
+test_1_to_1_send
+test_1_to_1_sendmsg
+test_1_to_1_sendto
+test_1_to_1_shutdown
+test_1_to_1_socket_bind_listen
+test_1_to_1_sockopt
+test_1_to_1_threads
+test_assoc_abort
+test_assoc_shutdown
+test_autoclose
+test_basic
+test_basic_v6
+test_connect
+test_connectx
+test_fragments
+test_fragments_v6
+test_getname
+test_getname_v6
+test_inaddr_any
+test_inaddr_any_v6
+test_peeloff
+test_peeloff_v6
+test_recvmsg
+test_sctp_sendrecvmsg
+test_sctp_sendrecvmsg_v6
+test_sockopt
+test_sockopt_v6
+test_tcp_style
+test_tcp_style_v6
+test_timetolive
+test_timetolive_v6
diff --git a/src/withsctp/.gitignore b/src/withsctp/.gitignore
new file mode 100644
index 0000000..498e578
--- /dev/null
+++ b/src/withsctp/.gitignore
@@ -0,0 +1,2 @@
+checksctp
+withsctp
-- 
2.7.0

