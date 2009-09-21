From: colin wen <colinw21@gmail.com>
Date: Mon, 21 Sep 2009 16:40:07 +0000
Subject: Re: sctp send and recv
Message-Id: <a87dbce20909210940sc152c12j52008dbec8f219f7@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <a87dbce20909171629h274f02b5h28731245c0cb5ed7@mail.gmail.com>
In-Reply-To: <a87dbce20909171629h274f02b5h28731245c0cb5ed7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Sep 21, 2009 at 6:45 AM, Vlad Yasevich
<vladislav.yasevich@hp.com> wrote:
> colin wen wrote:
>> I wrote a simple sctp server and client to test sctp in linux.
>> after client call connect, server accept return a socket,
>> but after client call send(fd, "hello", 5, 0) server's recv call
>> does not return, server's recv return after client close and
>> re-connect to server.
>> I wonder if someone could tell me what's the problem.
>> Thanks,
>
>
> What kernel version are you using?
>
> Can you post the source to your client and server?
>
> -vlad
>
I am using 2.6.28-13-generic (debian-5.0) and also
tested the kernel 2.6.31 downloaded from kernel.org.
Please find the following test code.
Client:
------------------------------------------------------------
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <linux/in.h>

int main()
{
	int fd;
	struct sockaddr_in addr;
	int len;

	fd = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
	if (fd < 0) {
		printf("socket failed\n");
		return -1;
	}
	printf("socket ok\n");

	addr.sin_family = AF_INET;
	addr.sin_port = htons(5060);
	addr.sin_addr.s_addr = inet_addr("172.16.80.234");

	if (connect(fd, (struct sockaddr*)&addr, sizeof addr)) {
		printf("connect failed\n");
		return -1;
	}
	printf("connect \n");

	len = send(fd, "hello", 5, 0);
	printf("send %d\n", len);

	close(fd);
	return 0;
}

Server:
--------------------------------------------------------------------
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <linux/in.h>

int main()
{
	int fd, fd_client;
	struct sockaddr_in addr;
	char buf[128];
	int len;

	fd = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
	if (fd < 0) {
		printf("socket failed\n");
		return -1;
	}
	addr.sin_family = AF_INET;
	addr.sin_port = htons(5060);
	addr.sin_addr.s_addr = INADDR_ANY;

	if (bind(fd, (struct sockaddr*)&addr, sizeof addr)) {
		printf("bind failed\n");
		return -1;
	}
	if (listen(fd, 10)) {
		printf("listen failed\n");
		return -1;
	}
	while (1) {
		len = sizeof(addr);
		fd_client = accept(fd, (struct sockaddr*)&addr, &len);	
		if (fd_client < 0) {
			printf("accept failed\n");
			break;
		}
		printf("accept %d\n", fd_client);
		while(1) {
			len = recv(fd_client, buf, sizeof(buf), 0);					
			if (len <= 0)
				break;
			buf[len] = 0;
			printf("%s\n", buf);
			
		}
		close(fd_client);
		
	}
	return 0;
}
