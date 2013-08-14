From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
Date: Wed, 14 Aug 2013 08:50:10 +0000
Subject: SCTP rwnd issues [2/2]
Message-Id: <520B44C2.4070505@nsn.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello!

A sample program that demonstrates a situation when rwnd drops to 0 because
of memory pressure and never grows to its original value. At the same time
other association on the same socket has its rwnd affected: it drops to 0,
but restores only to 1.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <sys/socket.h>
#include <unistd.h>
#include <error.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <netinet/sctp.h>
#include <arpa/inet.h>
#include <sys/select.h>
#include <errno.h>

int open_sockets(int *rcsock, int *trsock1, int *trsock2, int *rcbufsize,
                 struct sockaddr_in *saddr)
{
	int optlen, optval;
	struct sctp_event_subscribe events;
	int ret;

	*rcsock = socket(PF_INET, SOCK_SEQPACKET, IPPROTO_SCTP);
	if (*rcsock = -1)
		return errno;

	*trsock1 = socket(PF_INET, SOCK_SEQPACKET, IPPROTO_SCTP);
	if (*trsock1 = -1)
		return errno;

	*trsock2 = socket(PF_INET, SOCK_SEQPACKET, IPPROTO_SCTP);
	if (*trsock1 = -1)
		return errno;

	optlen = sizeof(optval);
	ret = getsockopt(*rcsock, SOL_SOCKET, SO_RCVBUF, &optval, &optlen);
	if (ret = -1)
		return errno;

	printf("Receive socket buffer size: %d\n", optval);
	*rcbufsize = optval;

	memset(&events, 0, sizeof(events));
	events.sctp_data_io_event = 1;
	ret = setsockopt(*rcsock, IPPROTO_SCTP, SCTP_EVENTS, &events,
	                 sizeof(events));
	if (ret = -1)
		return errno;

	optval = 1;
	ret = setsockopt(*trsock1, IPPROTO_SCTP, SCTP_NODELAY, &optval,
	                 sizeof(optval));
	if (ret = -1)
		return errno;
	ret = setsockopt(*trsock2, IPPROTO_SCTP, SCTP_NODELAY, &optval,
	                 sizeof(optval));
	if (ret = -1)
		return errno;

	saddr->sin_family = AF_INET;
	ret = inet_pton(AF_INET, "127.0.0.1", &saddr->sin_addr);
	if (ret != 1)
		return EFAULT;
	saddr->sin_port = htons(54321);

	ret = bind(*rcsock, (struct sockaddr *)saddr, sizeof(*saddr));
	if (ret = -1)
		return errno;

	ret = listen(*rcsock, 2);
	if (ret = -1)
		return errno;

	printf("Server is listening on 127.0.0.1:%d...\n",
	       ntohs(saddr->sin_port));

	return 0;
}

/* Fill receive buffer until memory pressure closes rwnd */
int fill_rxbuffer(int rcsock, int trsock1, void *buf, int bufsize,
                  struct sockaddr_in *saddr, sctp_assoc_t *rcassoc1)
{
	int ret;
	int optlen;
	int rflags;
	struct sctp_sndrcvinfo sinfo;
	struct sctp_assocparams args;
	int total = 0;
	int reported = 0;

	while (1) {
		ret = sctp_sendmsg(trsock1, buf, bufsize,
		                   (struct sockaddr *)saddr,
		                   sizeof(struct sockaddr_in), 0, 0, 0, 0, 0);
		if (ret = -1)
			return errno;

		if (*rcassoc1 = 0) {
			rflags = 0;
			ret = sctp_recvmsg(rcsock, buf, bufsize, NULL, NULL,
			                   &sinfo, &rflags);
			if (ret = -1)
				return errno;

			if (!(rflags & MSG_NOTIFICATION)) {
				*rcassoc1 = sinfo.sinfo_assoc_id;
				printf("Receiver association1=%d\n", *rcassoc1);
				continue;
			}
		}

		optlen = sizeof(args);
		ret = sctp_opt_info(rcsock, *rcassoc1, SCTP_ASSOCINFO, &args,
		                    &optlen);
		if (ret = -1)
			return errno;

		total += bufsize;
		if ((total >= reported * 2) || !args.sasoc_local_rwnd) {
			reported = total;
			printf("Sent %d bytes ... rwnd=%d\n", total,
			       args.sasoc_local_rwnd);
		}

		if (!args.sasoc_local_rwnd)
			break;
	}

	return 0;
}

/* Clean the receive buffer */
int free_rxbuffer(int rcsock, void *buf, int bufsize, sctp_assoc_t rcassoc1,
                  sctp_assoc_t *rcassoc2)
{
	int total = 0;
	int reported = 0;
	int rflags;
	struct sctp_sndrcvinfo sinfo;
	int ret;
	struct sctp_assocparams args;
	int optlen;
	int err;

	while (1) {
		rflags = MSG_DONTWAIT;
		ret = sctp_recvmsg(rcsock, buf, bufsize, NULL, NULL, &sinfo,
		                   &rflags);
		if (ret = -1) {
			if ((errno = EWOULDBLOCK) || (errno = EAGAIN))
				ret = 0;
			else
				return errno;
		}

		if (rflags & MSG_NOTIFICATION)
			continue;

		if ((*rcassoc2 = 0) && (sinfo.sinfo_assoc_id != rcassoc1)) {
			*rcassoc2 = sinfo.sinfo_assoc_id;
			printf("Receiver association2=%d\n", *rcassoc2);
		}

		optlen = sizeof(args);
		err = sctp_opt_info(rcsock, rcassoc1, SCTP_ASSOCINFO, &args,
		                    &optlen);
		if (err = -1)
			return errno;

		total += ret;
		if ((total >= reported * 2) || !ret) {
			reported = total;
			printf("Received %d bytes ... rwnd1=%d\n", total,
			       args.sasoc_local_rwnd);
		}

		if (!ret)
			break;
	}

	return 0;
}

/* Transmit some packets, give rwnd a chance to restore */
int give_chance(int rcsock, int trsock1, int trsock2, void *buf, int bufsize,
                struct sockaddr_in *saddr)
{
	/*
	 * For some reason transmission from here on is really slow.
	 * Let's send only 2x16 packets, no reason to wait longer,
	 * there is not improvement any way...
	 */
	int total = 16;
	struct sctp_sndrcvinfo sinfo;
	int ret;
	int rflags;

	printf("Transferring 2x%d packets...\n", total);

	while (total--) {
		ret = sctp_sendmsg(trsock1, buf, bufsize,
		                   (struct sockaddr *)saddr,
		                   sizeof(struct sockaddr_in), 0, 0, 0, 0, 0);

		rflags = 0;
		if (ret != -1)
			ret = sctp_recvmsg(rcsock, buf, bufsize, NULL, NULL,
			                   &sinfo, &rflags);

		if (ret != -1)
			ret = sctp_sendmsg(trsock2, buf, bufsize,
			                   (struct sockaddr *)saddr,
			                   sizeof(struct sockaddr_in),
			                   0, 0, 0, 0, 0);

		rflags = 0;
		if (ret != -1)
			ret = sctp_recvmsg(rcsock, buf, bufsize, NULL, NULL,
			                   &sinfo, &rflags);

		if (ret = -1) {
			if ((errno = EAGAIN) || (errno = EWOULDBLOCK))
				printf("We are LOCKED\n");
			else
				printf("Some unexpected error...\n");
			return errno;
		}
	}

	return 0;
}

int main(int argc, char **argv)
{
	int rcsock, trsock1, trsock2;
	int ret;
	int optlen;
	struct sockaddr_in saddr;
	struct sctp_assocparams args;
	sctp_assoc_t rcassoc1 = 0;
	sctp_assoc_t rcassoc2 = 0;
	char buf[1];
	int rcbufsize;

	ret = open_sockets(&rcsock, &trsock1, &trsock2, &rcbufsize, &saddr);
	if (ret)
		exit(ret);

	ret = fill_rxbuffer(rcsock, trsock1, &buf, sizeof(buf), &saddr,
	                    &rcassoc1);
	if (ret)
		exit(ret);

	/* Trigger the problem */
	ret = sctp_sendmsg(trsock2, &buf, sizeof(buf), (struct sockaddr *)&saddr,
	                   sizeof(struct sockaddr_in), 0, 0, 0, 0, 0);
	if (ret = -1)
		exit(errno);

	ret = free_rxbuffer(rcsock, &buf, sizeof(buf), rcassoc1, &rcassoc2);
	if (ret)
		exit(ret);

	optlen = sizeof(args);
	ret = sctp_opt_info(rcsock, rcassoc2, SCTP_ASSOCINFO, &args, &optlen);
	if (ret = -1)
		exit(errno);

	printf("rwnd2=%d\n", args.sasoc_local_rwnd);

	ret = give_chance(rcsock, trsock1, trsock2, &buf, sizeof(buf), &saddr);
	if (ret)
		exit(ret);

	optlen = sizeof(args);
	ret = sctp_opt_info(rcsock, rcassoc1, SCTP_ASSOCINFO, &args, &optlen);
	if (ret = -1)
		exit(errno);
	printf("rwnd1=%d\n", args.sasoc_local_rwnd);

	optlen = sizeof(args);
	ret = sctp_opt_info(rcsock, rcassoc2, SCTP_ASSOCINFO, &args, &optlen);
	if (ret = -1)
		exit(errno);
	printf("rwnd2=%d\n", args.sasoc_local_rwnd);

	printf("Finished.\n");

	close(trsock2);
	close(trsock1);
	close(rcsock);
}

-- 
Best regards,
Alexander Sverdlin.
