From: Dong Liu <dliu.cn@gmail.com>
Date: Thu, 13 Mar 2014 02:30:50 +0000
Subject: 1.0.16 sctp_connectx() in 32 bit
Message-Id: <5321185A.8050700@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

I think I found a problem in the new sctp_connectx() code.

in sctp_connectx3() there are,

     struct sctp_getaddrs_old param;
     socklen_t opt_len = sizeof(param);
     status getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_CONNECTX3, &param, 
&opt_len);

And in kernel net/sctp/socket.c sctp_getsockopt_connectx3(), there is a 
check,

             if (len < sizeof(param)) |
                 return 
-EINVAL;                                                         |

But struct sctp_getaddrs_old contains a pointer . When compiled in 32 
bit or 64 bit, the size of sctp_getaddrs_old is different. So if the 
kernel is in 64 bit mode but the libsctp is in 32 bit mode. 
sctp_connectx() will fail with EINVAL.

Thanks,

Dong
