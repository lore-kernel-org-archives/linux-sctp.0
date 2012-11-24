From: =?GBK?B?0KG62A==?= <elliehct@163.com>
Date: Sat, 24 Nov 2012 04:55:10 +0000
Subject: how to use sctp_sendmsg to send ABORT chunk
Message-Id: <20844e51.131ec.13b30c4ebec.Coremail.elliehct@163.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

dear  lksctp Project,     
  i met a problem about sending abort chunk. if you have time, please help me.       i'm using the lksctp to develop my function, which is for sending Abort chunk.        platform of my development : Redhat centos 5.5 and verion  of linux kernel is 2.18.        according to "man sctp_sendmsg", just set flags to SCTP_ABORT.        my partial code.--------------------------------------------------------------------------------------------------------------------------struct msghdr msg;struct cmsghdr cmsg; struct iovec iov;        static char error_code= 12;	iov.iov_base = &error_code;	iov.iov_len = 1;cmsg.cmsg_level = IPPROTO_SCTP;cmsg.cmsg_type = SCTP_SNDRV;cmsg.cmsg_len = sizeof(struct cmsghdr);msg.msg_name = (SOCKADDR*)&serAddr;	msg.msg_namelen = sizeof(serAddr);	msg.msg_iov = &iov;	msg.msg_iovlen = 1;	msg.msg_control = &cmsg;	msg.msg_controllen = sizeof(cmsg);        ret = sctp_sendmsg(sock_fd, (void*)&msg, sizeof(msg), (SOCKADDR*)&serAddr,                                   sizeof(serAddr),sri.sinfo_ppid, (SCTP_ABORT),                           sri.sinfo_stream, sri.sinfo_timetolive,sri.sinfo_context);--------------------------------------------------------------------------------------------------------------------but the ret < 0 and the errno is 22 that is invalid agument.please tell which argument is error and how to set cause of abort chunk into "struct msghdr" best regardsthank you fangmin.cao
