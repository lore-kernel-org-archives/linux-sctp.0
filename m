From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 13 Dec 2013 10:57:10 +0000
Subject: Re: [PATCH] lksctp: Avoid using file descriptor 0 to get ENOTSOCK
Message-Id: <52AAE806.5060408@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1386663562-791-1-git-send-email-xu.simon@oracle.com>
In-Reply-To: <1386663562-791-1-git-send-email-xu.simon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/10/2013 09:19 AM, Simon Xu wrote:
> On some systems, errno will not be ENOTSOCK when operating on file descriptor
> 0 in an ssh session:
>
> test_1_to_1_accept_close.c    2  TBROK  :  accept with invalid socketerror:-1, errno:22
> test_1_to_1_addrs.c    2  TBROK  :  sctp_getladdrs with invalid socket error:-1, errno:95
> test_1_to_1_connect.c    2  TBROK  :  connect with invalid socket error:-1, errno:22
> test_1_to_1_recvfrom.c    2  TBROK  :  recvfrom with invalid socket count:0, errno:9
> test_1_to_1_recvmsg.c    2  TBROK  :  recvmsg with invalid socket count:0, errno:9
> test_1_to_1_send.c    2  TBROK  :  send with invalid socket count:15, errno:9
> test_1_to_1_sendmsg.c    2  TBROK  :  sendmsg with invalid socket count:-1, errno:106
> test_1_to_1_shutdown.c    2  TBROK  :  shutdown with an invalid socket error:0, errno:9
> test_1_to_1_socket_bind_listen.c    6  TBROK  :  bind() with invalid socket descriptor error:-1, errno:22
> test_1_to_1_sockopt.c    2  TBROK  :  setsockopt with an invalid socket error:-1, errno:95
> test_getname.c    9  TBROK  :  getsockname on an invalid socket error:0 errno:9
>
> This patch gets a non-socket file descriptor by creating a temporary file
> to replace file descriptor 0.
>
> Signed-off-by: Simon Xu <xu.simon@oracle.com>

Ok, applied, thank you.
