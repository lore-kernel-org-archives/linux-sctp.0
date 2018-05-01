From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 01 May 2018 15:02:45 +0000
Subject: Re: [PATCH lksctp-tools 1/3] lib: add the core functions for sctp_sendv and sctp_recvv
Message-Id: <CADvbK_dZWr2+Aa=kxwPggHAJFjRJh8SdLUYfrnd=CRD=2eaE6w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <715ad5dd0aae4dda8b96a396ea8d57b07f9a3e82.1525170039.git.lucien.xin@gmail.com>
In-Reply-To: <715ad5dd0aae4dda8b96a396ea8d57b07f9a3e82.1525170039.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, May 1, 2018 at 9:59 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, May 01, 2018 at 06:24:07PM +0800, Xin Long wrote:
>> This patch is to implement sctp_sendv and sctp_recvv defined in
>> rfc6458#section-9.12 and 9.13. They provide an extensible way
>> for users to send or receive messages from a SCTP socket.
>>
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> ---
>>  src/include/netinet/sctp.h |  43 ++++++++++++
>>  src/lib/Versions.map       |   2 +
>>  src/lib/recvmsg.c          |  88 +++++++++++++++++++++++++
>>  src/lib/sendmsg.c          | 161 +++++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 294 insertions(+)
>>
>> diff --git a/src/include/netinet/sctp.h b/src/include/netinet/sctp.h
>> index a0cd14c..701f091 100644
>> --- a/src/include/netinet/sctp.h
>> +++ b/src/include/netinet/sctp.h
>> @@ -122,6 +122,49 @@ int sctp_recvmsg(int s, void *msg, size_t len, struct sockaddr *from,
>>  /* Return the address length for an address family. */
>>  int sctp_getaddrlen(sa_family_t family);
>>
>> +
>> +/* sendv infotype */
>> +enum {
>> +     SCTP_SENDV_NOINFO,
>> +     SCTP_SENDV_SNDINFO,
>> +     SCTP_SENDV_PRINFO,
>> +     SCTP_SENDV_AUTHINFO,
>> +     SCTP_SENDV_SPA
>> +};
>> +
>> +/* sendv_flags */
>> +#define SCTP_SEND_SNDINFO_VALID              0x1
>> +#define SCTP_SEND_PRINFO_VALID               0x2
>> +#define SCTP_SEND_AUTHINFO_VALID     0x4
>> +
>> +struct sctp_sendv_spa {
>> +     uint32_t sendv_flags;
>> +     struct sctp_sndinfo sendv_sndinfo;
>> +     struct sctp_prinfo sendv_prinfo;
>> +     struct sctp_authinfo sendv_authinfo;
>> +};
>> +
>> +int sctp_sendv(int s, const struct iovec *iov, int iovcnt,
>> +            struct sockaddr *addrs, int addrcnt, void *info,
>> +            socklen_t infolen, unsigned int infotype, int flags);
>> +
>> +/* recvv infotype */
>> +enum {
>> +     SCTP_RECVV_NOINFO,
>> +     SCTP_RECVV_RCVINFO,
>> +     SCTP_RECVV_NXTINFO,
>> +     SCTP_RECVV_RN
>> +};
>> +
>> +struct sctp_recvv_rn {
>> +     struct sctp_rcvinfo recvv_rcvinfo;
>> +     struct sctp_nxtinfo recvv_nxtinfo;
>> +};
>> +
>> +int sctp_recvv(int s, const struct iovec *iov, int iovlen,
>> +            struct sockaddr *from, socklen_t *fromlen, void *info,
>> +            socklen_t *infolen, unsigned int *infotype, int *flags);
>> +
>>  #ifdef __cplusplus
>>  }
>>  #endif
>> diff --git a/src/lib/Versions.map b/src/lib/Versions.map
>> index a3c5561..7faad5d 100644
>> --- a/src/lib/Versions.map
>> +++ b/src/lib/Versions.map
>> @@ -10,7 +10,9 @@ VERS_1 {
>>               sctp_opt_info;
>>               sctp_peeloff;
>>               sctp_recvmsg;
>> +             sctp_recvv;
>>               sctp_sendmsg;
>> +             sctp_sendv;
>>               sctp_send;
>>
>>       local:
>> diff --git a/src/lib/recvmsg.c b/src/lib/recvmsg.c
>> index 4575788..7c1dcad 100644
>> --- a/src/lib/recvmsg.c
>> +++ b/src/lib/recvmsg.c
>> @@ -99,3 +99,91 @@ int sctp_recvmsg(int s, void *msg, size_t len, struct sockaddr *from,
>>
>>       return (error);
>>  }
>> +
>> +int sctp_recvv(int s, const struct iovec *iov, int iovlen,
>> +            struct sockaddr *from, socklen_t *fromlen, void *info,
>> +            socklen_t *infolen, unsigned int *infotype, int *flags)
>> +{
>> +     char incmsg[CMSG_SPACE(sizeof(struct sctp_rcvinfo) +
>> +                            sizeof(struct sctp_nxtinfo))];
>> +     int error, len, _infolen;
>> +     struct cmsghdr *cmsg;
>> +     struct msghdr inmsg;
>> +
>> +     memset(&inmsg, 0, sizeof(inmsg));
>> +
>> +     /* set from and iov */
>> +     inmsg.msg_name = from;
>> +     inmsg.msg_namelen = fromlen ? *fromlen : 0;
>> +     inmsg.msg_iov = (struct iovec *)iov;
>> +     inmsg.msg_iovlen = iovlen;
>> +     inmsg.msg_control = incmsg;
>> +     inmsg.msg_controllen = sizeof(incmsg);
>> +
>> +     error = recvmsg(s, &inmsg, flags ? *flags : 0);
>> +     if (error < 0)
>> +             return error;
>> +
>> +     /* set fromlen, frags */
>> +     if (fromlen)
>> +             *fromlen = inmsg.msg_namelen;
>> +
>> +     if (flags)
>> +             *flags = inmsg.msg_flags;
>> +
>> +     if (!info || !infotype || !infolen)
>> +             return error;
>> +
>> +     *infotype = SCTP_RECVV_NOINFO;
>> +     _infolen = *infolen;
>> +
>> +     /* set info and infotype */
>> +     for (cmsg = CMSG_FIRSTHDR(&inmsg); cmsg != NULL;
>> +                             cmsg = CMSG_NXTHDR(&inmsg, cmsg)) {
>> +             if (cmsg->cmsg_level != IPPROTO_SCTP)
>> +                     continue;
>> +
>> +             if (cmsg->cmsg_type = SCTP_RCVINFO) {
>> +                     len = sizeof(struct sctp_rcvinfo);
>> +                     if (*infotype = SCTP_RECVV_NOINFO) {
>> +                             if (_infolen < len)
>> +                                     break;
>> +                             memcpy(info, CMSG_DATA(cmsg), len);
>> +                             *infotype = SCTP_RECVV_RCVINFO;
>> +                             *infolen = len;
>> +                     } else if (*infotype = SCTP_RECVV_NXTINFO) {
>> +                             if (_infolen < len +
>> +                                            sizeof(struct sctp_nxtinfo))
>> +                                     break;
>> +                             memcpy(info + len, info,
>> +                                    sizeof(struct sctp_nxtinfo));
>> +                             memcpy(info, CMSG_DATA(cmsg), len);
>> +                             *infotype = SCTP_RECVV_RN;
>> +                             *infolen = len + sizeof(struct sctp_nxtinfo);
>> +                     } else {
>> +                             break;
>> +                     }
>> +             } else if (cmsg->cmsg_type = SCTP_NXTINFO) {
>> +                     len = sizeof(struct sctp_nxtinfo);
>> +                     if (*infotype = SCTP_RECVV_NOINFO) {
>> +                             if (_infolen < len)
>> +                                     break;
>> +                             memcpy(info, CMSG_DATA(cmsg), len);
>> +                             *infotype = SCTP_RECVV_NXTINFO;
>> +                             *infolen = len;
>> +                     } else if (*infotype = SCTP_RECVV_RCVINFO) {
>> +                             if (_infolen < len +
>> +                                            sizeof(struct sctp_rcvinfo))
>> +                                     break;
>> +                             memcpy(info + sizeof(struct sctp_rcvinfo),
>> +                                    CMSG_DATA(cmsg), len);
>> +                             *infotype = SCTP_RECVV_RN;
>> +                             *infolen = len + sizeof(struct sctp_rcvinfo);
>> +                     } else {
>> +                             break;
>> +                     }
>> +             }
>> +     }
>> +
>> +     return error;
>> +}
>> diff --git a/src/lib/sendmsg.c b/src/lib/sendmsg.c
>> index 9046174..cb75378 100644
>> --- a/src/lib/sendmsg.c
>> +++ b/src/lib/sendmsg.c
>> @@ -19,7 +19,10 @@
>>   *  Ardelle Fan     <ardelle.fan@intel.com>
>>   */
>>
>> +#include <errno.h>
>>  #include <string.h>
>> +#include <stdlib.h>
>> +#include <netinet/in.h>
>>  #include <sys/socket.h>   /* struct sockaddr_storage, setsockopt() */
>>  #include <netinet/sctp.h>
>>
>> @@ -104,3 +107,161 @@ sctp_send(int s, const void *msg, size_t len,
>>
>>       return sendmsg(s, &outmsg, flags);
>>  }
>> +
>> +static struct cmsghdr *sctp_sendv_store_cmsg(struct cmsghdr *cmsg, int *cmsglen,
>> +                                          int type, int len, void *data)
>> +{
>> +     cmsg->cmsg_level = IPPROTO_SCTP;
>> +     cmsg->cmsg_type = type;
>> +     cmsg->cmsg_len = CMSG_LEN(len);
>> +     memcpy(CMSG_DATA(cmsg), data, len);
>> +
>> +     *cmsglen -= CMSG_SPACE(len);
>> +     if (!*cmsglen)
>> +             return NULL;
>> +
>> +     return (struct cmsghdr *)((char *)cmsg + CMSG_SPACE(len));
>> +}
>> +
>> +int sctp_sendv(int s, const struct iovec *iov, int iovcnt,
>> +            struct sockaddr *addrs, int addrcnt, void *info,
>> +            socklen_t infolen, unsigned int infotype, int flags)
>> +{
>> +     struct sockaddr *addr;
>> +     struct msghdr outmsg;
>> +     struct cmsghdr *cmsg;
>> +     int type, len, i;
>> +     int cmsglen = 0;
>> +     char *addrbuf;
>> +
>> +     /* set msg_iov, msg_iovlen, msg_flags */
>> +     memset(&outmsg, 0x00, sizeof(outmsg));
>> +     outmsg.msg_iov = (struct iovec *)iov;
>> +     outmsg.msg_iovlen = iovcnt;
>> +     outmsg.msg_flags = flags;
>> +
>> +     /* set msg_name and msg_namelen */
>> +     if (addrs && addrcnt) {
>> +             outmsg.msg_name = addrs;
>> +             if (addrs->sa_family = AF_INET)
>> +                     outmsg.msg_namelen = sizeof(struct sockaddr_in);
>> +             else if (addrs->sa_family = AF_INET6)
>> +                     outmsg.msg_namelen = sizeof(struct sockaddr_in6);
>> +             else
>> +                     return -EINVAL;
>> +             addrcnt -= 1;
>> +             addrbuf = (char *)addrs;
>> +             addrs = (struct sockaddr *)(addrbuf + outmsg.msg_namelen);
>> +     }
>> +
>> +     /* get the cmsg length it will need for addr info */
>> +     for (i = 0, addrbuf = (char *)addrs; i < addrcnt; i++) {
>> +             addr = (struct sockaddr *)addrbuf;
>> +             if (addr->sa_family = AF_INET) {
>> +                     len = sizeof(struct in_addr);
>> +                     cmsglen += CMSG_SPACE(len);
>> +                     addrbuf += sizeof(struct sockaddr_in);
>> +             } else if (addr->sa_family = AF_INET6) {
>> +                     len = sizeof(struct in6_addr);
>> +                     cmsglen += CMSG_SPACE(len);
>> +                     addrbuf += sizeof(struct sockaddr_in6);
>> +             } else {
>> +                     return -EINVAL;
>> +             }
>> +     }
>> +     /* get the cmsg length it will need for snd/pr/auth info */
>> +     if (infotype = SCTP_SENDV_SPA) {
>> +             struct sctp_sendv_spa *spa = info;
>> +
>> +             if (spa->sendv_flags & SCTP_SEND_SNDINFO_VALID)
>> +                     cmsglen += CMSG_SPACE(sizeof(struct sctp_sndinfo));
>> +             if (spa->sendv_flags & SCTP_SEND_PRINFO_VALID)
>> +                     cmsglen += CMSG_SPACE(sizeof(struct sctp_prinfo));
>> +             if (spa->sendv_flags & SCTP_SEND_AUTHINFO_VALID)
>> +                     cmsglen +=  CMSG_SPACE(sizeof(struct sctp_authinfo));
>> +     } else if (infotype = SCTP_SENDV_SNDINFO) {
>> +             cmsglen += CMSG_SPACE(sizeof(struct sctp_sndinfo));
>> +     } else if (infotype = SCTP_SENDV_PRINFO) {
>> +             cmsglen += CMSG_SPACE(sizeof(struct sctp_prinfo));
>> +     } else if (infotype = SCTP_SENDV_AUTHINFO) {
>> +             cmsglen += CMSG_SPACE(sizeof(struct sctp_authinfo));
>> +     }
>> +
> We're talkinag about less than 128 bytes of storage here.  Instead of checking
> all the infotypes and allocating the appropriate cmsglen, why not just declare a
> cmsg buffer on the stack that is of the maximum possible size.  It would
> eliminate a good deal of code here.
With the appropriate cmsglen, we can void the unncessary alloc by checking
(!cmsglen).
Otherwise we will have to check "!cmsglen && infotype != any of them",
and also to count cmsglen in the 2nd "if-else if" to set the correct value
for outmsg.msg_controllen.
