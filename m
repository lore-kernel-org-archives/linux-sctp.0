From: muskala magda <magdafrog@yahoo.de>
Date: Mon, 28 Apr 2008 20:22:19 +0000
Subject: sctp and select
Message-Id: <782746.49086.qm@web27101.mail.ukl.yahoo.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

hi,

i am trying to rn this server. the (low level)
communication seems to be done. but after accepting
the connection, the select doesn't notice an incoming
data. it notices only the 4 way handshake & closing
packets, but not the data. the program waits in this
line:

if (select(fdmax+1, &read_fds, NULL, NULL, NULL)) {

there is also an error after cookie echo received by
the server, but as already mentioned, the
communication seems not to be broken. are the data
buffered? how can i check it/read it? how can i (if it
is possible at all) "force" the select to notice the
incoming data packets?

thank you
greetings
magda


#include <stdio.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/sctp.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/poll.h>
#include <sys/time.h>
#include <signal.h>
#include <getopt.h>
#include <stdlib.h>
#include <string.h>
#include <sys/uio.h>
#include <sys/sysinfo.h>
#include <fcntl.h>=20
int nodelay =3D1;

#define HOST_BUF_LEN 4096
char buf[HOST_BUF_LEN];
int init_server(int port){
	struct sockaddr_in addr;
    int sd;                                       =20
=09
	addr.sin_family =3D PF_INET;
	addr.sin_addr.s_addr =3D INADDR_ANY;
	addr.sin_port =3D htons(port);
	if( (sd=3Dsocket(PF_INET, SOCK_STREAM, IPPROTO_SCTP)) <
0 ) {
	perror("socket failed\n");
	return(-1);
	=09
	}
	if (fcntl(sd, F_SETFL, O_NONBLOCK) < 0) {
		perror("fcntl");
	}
=09
	if( bind( sd, (struct sockaddr *)&addr,sizeof(addr) )
=3D -1 ) {
		perror("bind");
		goto errout;
     	exit(1);
	}
	else printf("binded\n");
	if (listen(sd, 1)=3D-1) {
		printf("not listening...\n");
       	goto errout;
	}
    else printf("listening...\n");
	return sd;
	errout:
		close(sd);
		return(-1);
}
void serve(int listener){
	fd_set master;  // master file descriptor list
    fd_set read_fds; //temp file descriptor list for
select()
	struct sockaddr_in remoteaddr; //client address
	remoteaddr.sin_family =3D PF_INET;
	int fdmax;      //  maximum file descriptor number
	int newfd;     //   newly accept()ed socket
descriptor
	char buf[HOST_BUF_LEN];   // buffer for client data
	int nbytes;
	int addrlen;
	int i ;
	FD_ZERO(&master); //   clear the master and temp sets
	FD_ZERO(&read_fds);
	FD_SET(listener, &master);
	int total=3D0;
	int filesize=3D0;
	int file=3D0;
	int first=3D1;
	//keep track of the biggest file descriptor
	fdmax =3D listener; //so far, it's this one
	//main loop
	for(;;) {

		read_fds =3D master; //copy it
		if (select(fdmax+1, &read_fds, NULL, NULL, NULL)) {
			perror("select");
		=09
			for(i =3D 0; i <=3D fdmax; i++) {
				if (FD_ISSET(i, &read_fds)) { //we got one!!
					if (i =3D listener) {
						//handle new connections
						addrlen =3D sizeof remoteaddr;
						if ((newfd =3D accept(listener, (struct sockaddr
*)&remoteaddr, &addrlen)) =3D -1) {=20
							perror("accept");
						} else {
							if (fcntl(i, F_SETFL, O_NONBLOCK) < 0) {
								perror("fcntl");
							}
							if (setsockopt(i, SOL_SCTP, SCTP_NODELAY,
&nodelay, sizeof(nodelay)) < 0) {
								perror("setsockopt");
							}
							FD_SET(newfd, &master); //add to master set
							if (newfd > fdmax) {    //keep track of the
maximum
								fdmax =3D newfd;
							}
							first =3D 1;
						}
					} else {
						if ((nbytes =3D recv(i, buf, sizeof buf,
MSG_DONTWAIT )) <=3D 0) {
							//got error or connection closed by client
							if (nbytes =3D 0) {
								//connection closed
								printf("selectserver: socket %d hung up\n",
i);
							} else {
								perror("recv");
							}
							close(i); //bye!
							FD_CLR(i, &master); //remove from master set
							//close(fd);
						} else {
							if (first=3D1 )
					   		{
								first =3D 0;
								char delims[] =3D "###";
		                 		char *result =3D NULL;
		                 		result =3D strtok( buf, delims );
			          	    	filesize =3D  atoi(strtok( NULL,
delims ));
			                 	printf( "result is \"%s\", size
is %d\n", result, filesize );
					=09
					=09
								file =3D open(result,O_WRONLY|O_CREAT,0700);
								perror("open");
								printf("o p e  n: %d\n", file);
	=09
						   }
						   else
						   {
					   			printf("o p e n i n g  %d\n", file);
								printf ("T O T A L, NB %d %d\n",total,
nbytes);
					   			total +=3D nbytes;
								printf ("T O T A L, NB2%d %d\n",total,
nbytes);
		                        fwrite(buf,nbytes,1,stdout);
		                        write(file, &buf, nbytes);
					   			if (total =3D filesize){
									first =3D 1;
					   				total=3D0;
					   				filesize =3D0;
					   				printf ("F i n i o t i o\n");
					   				close(file);
									file=3D0;
					   			}
					  		}
					 =20
						}
					}=20
				}
			}
		}

	}
}



int main(int argc, char *argv[]){
	short port =10000;
	int option_index =3D 0;
	static struct option long_options[] =3D {
                            {"host",
required_argument, NULL, 'h'},
                            {"port",
required_argument, NULL, 'p'},
                            {"dir", required_argument,
NULL, 'd'},
                            {"file",
required_argument, NULL, 'f'},
        };
   =20
 	int c =3D getopt_long(argc, argv, "p:h", long_options,
&option_index);
	perror("1");
        while (c !=3D -1) {
            switch (c) {
			case 'p': printf(optarg);
			port =3D atoi(optarg);
			perror("5");
			break;
			case 'h':
			break;

			default:
			perror("6");
			break;
		}=09
		perror("7");
		c =3D getopt_long(argc, argv, "h:d:p:f:",
long_options, &option_index);
		perror("8");
	}=09
	serve(init_server(port));
	return 1;
}


this is the traffic:

No.     Time        Source                Destination=20
         Protocol Info
 484976 192373.864470 192.168.1.109       =20
192.168.1.233         SCTP     INIT_ACK=20

Frame 484976 (308 bytes on wire, 308 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.109 (192.168.1.109),
Dst: 192.168.1.233 (192.168.1.233)
Stream Control Transmission Protocol, Src Port: 10000
(10000), Dst Port: 3072 (3072)
    Source port: 10000
    Destination port: 3072
    Verification tag: 0xee4cc7c0
    Checksum: 0xfc8dfdd9 [correct CRC32C]
    INIT_ACK chunk (Outbound streams: 10, inbound
streams: 1)
        Chunk type: INIT_ACK (2)
        Chunk flags: 0x00
        Chunk length: 260
        Initiate tag: 0x4d855e4f
        Advertised receiver window credit (a_rwnd):
55296
        Number of outbound streams: 10
        Number of inbound streams: 1
        Initial TSN: 1795865472
        State cookie parameter (Cookie length: 228
bytes)
            Parameter type: State cookie (0x0007)
            Parameter length: 232
            State cookie:
584D24ACEC72121F37BC435CD07F05850000000000000000...
        Adaptation Layer Indication parameter
(Indication: 0)
            Parameter type: Adaptation Layer
Indication (0xc006)
            Parameter length: 8
            Indication: 0x00000000

No.     Time        Source                Destination=20
         Protocol Info
 484978 192374.103552 192.168.1.233       =20
192.168.1.109         SCTP     COOKIE_ECHO ERROR=20

Frame 484978 (296 bytes on wire, 296 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
Dst: 192.168.1.109 (192.168.1.109)
Stream Control Transmission Protocol, Src Port: 3072
(3072), Dst Port: 10000 (10000)
    Source port: 3072
    Destination port: 10000
    Verification tag: 0x4d855e4f
    Checksum: 0xf3e29f58 [correct CRC32C]
    COOKIE_ECHO chunk (Cookie length: 228 bytes)
        Chunk type: COOKIE_ECHO (10)
        Chunk flags: 0x00
        Chunk length: 232
        Cookie:
584D24ACEC72121F37BC435CD07F05850000000000000000...
    ERROR chunk
        Chunk type: ERROR (9)
        Chunk flags: 0x00
        Chunk length: 16
        Unrecognized parameters cause
            Cause code: Unrecognized parameters
(0x0008)
            Cause length: 12
            Adaptation Layer Indication parameter
(Indication: 0)
                Parameter type: Adaptation Layer
Indication (0xc006)
                Parameter length: 8
                Indication: 0x00000000

No.     Time        Source                Destination=20
         Protocol Info
 484979 192374.103825 192.168.1.109       =20
192.168.1.233         SCTP     COOKIE_ACK=20

Frame 484979 (52 bytes on wire, 52 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.109 (192.168.1.109),
Dst: 192.168.1.233 (192.168.1.233)
Stream Control Transmission Protocol, Src Port: 10000
(10000), Dst Port: 3072 (3072)
    Source port: 10000
    Destination port: 3072
    Verification tag: 0xee4cc7c0
    Checksum: 0x547e1b06 [correct CRC32C]
    COOKIE_ACK chunk
        Chunk type: COOKIE_ACK (11)
        Chunk flags: 0x00
        Chunk length: 4

No.     Time        Source                Destination=20
         Protocol Info
 484981 192374.502964 192.168.1.233       =20
192.168.1.109         SCTP     DATA=20

Frame 484981 (72 bytes on wire, 72 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
Dst: 192.168.1.109 (192.168.1.109)
Stream Control Transmission Protocol, Src Port: 3072
(3072), Dst Port: 10000 (10000)
    Source port: 3072
    Destination port: 10000
    Verification tag: 0x4d855e4f
    Checksum: 0x5edddafd [correct CRC32C]
    DATA chunk(ordered, complete segment, TSN:
3998009280, SID: 0, SSN: 1, PPID: 0, payload length: 8
bytes)
        Chunk type: DATA (0)
        Chunk flags: 0x03
        Chunk length: 24
        TSN: 3998009280
        Stream Identifier: 0x0000
        Stream sequence number: 1
        Payload protocol identifier: not specified (0)
Data (8 bytes)

0000  72 63 23 23 23 32 36 39                        =20
 rc###269
    Data: 7263232323323639

No.     Time        Source                Destination=20
         Protocol Info
 484982 192374.503080 192.168.1.109       =20
192.168.1.233         SCTP     SACK=20

Frame 484982 (64 bytes on wire, 64 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.109 (192.168.1.109),
Dst: 192.168.1.233 (192.168.1.233)
Stream Control Transmission Protocol, Src Port: 10000
(10000), Dst Port: 3072 (3072)
    Source port: 10000
    Destination port: 3072
    Verification tag: 0xee4cc7c0
    Checksum: 0x871d6016 [correct CRC32C]
    SACK chunk (Cumulative TSN: 3998009280, a_rwnd:
55288, gaps: 0, duplicate TSNs: 0)
        Chunk type: SACK (3)
        Chunk flags: 0x00
        Chunk length: 16
        Cumulative TSN ACK: 3998009280
        Advertised receiver window credit (a_rwnd):
55288
        Number of gap acknowledgement blocks: 0
        Number of duplicated TSNs: 0

No.     Time        Source                Destination=20
         Protocol Info
 484999 192380.098573 192.168.1.233       =20
192.168.1.109         SCTP     DATA=20

Frame 484999 (320 bytes on wire, 320 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
Dst: 192.168.1.109 (192.168.1.109)
Stream Control Transmission Protocol, Src Port: 3072
(3072), Dst Port: 10000 (10000)
    Source port: 3072
    Destination port: 10000
    Verification tag: 0x4d855e4f
    Checksum: 0x9b833a01 [correct CRC32C]
    DATA chunk(ordered, complete segment, TSN:
3998009281, SID: 0, SSN: 1, PPID: 0, payload length:
256 bytes)
        Chunk type: DATA (0)
        Chunk flags: 0x03
        Chunk length: 272
        TSN: 3998009281
        Stream Identifier: 0x0000
        Stream sequence number: 1
        Payload protocol identifier: not specified (0)
Data (256 bytes)

0000  68 6f 73 74 6e 61 6d 65 20 45 44 4f 53 4b 32 36=20
 hostname EDOSK26
0010  37 34 0a 2f 62 69 6e 2f 65 78 70 61 6e 64 20 2f=20
 74./bin/expand /
0020  65 74 63 2f 72 61 6d 66 73 2e 69 6d 67 20 2f 64=20
 etc/ramfs.img /d
0030  65 76 2f 72 61 6d 30 0a 2f 62 69 6e 2f 65 78 70=20
 ev/ram0./bin/exp
0040  61 6e 64 20 2f 65 74 63 2f 72 61 6d 66 73 2e 69=20
 and /etc/ramfs.i
0050  6d 67 20 2f 64 65 76 2f 72 61 6d 31 0a 6d 6f 75=20
 mg /dev/ram1.mou
0060  6e 74 20 2d 74 20 70 72 6f 63 20 70 72 6f 63 20=20
 nt -t proc proc=20
0070  2f 70 72 6f 63 0a 6d 6f 75 6e 74 20 2d 74 20 65=20
 /proc.mount -t e
0080  78 74 32 20 2f 64 65 76 2f 72 61 6d 30 20 2f 76=20
 xt2 /dev/ram0 /v
0090  61 72 0a 6d 6f 75 6e 74 20 2d 74 20 65 78 74 32=20
 ar.mount -t ext2
00a0  20 2f 64 65 76 2f 72 61 6d 31 20 2f 65 74 63 2f=20
  /dev/ram1 /etc/
00b0  63 6f 6e 66 69 67 0a 6d 6b 64 69 72 20 2f 76 61=20
 config.mkdir /va
00c0  72 2f 74 6d 70 0a 6d 6b 64 69 72 20 2f 76 61 72=20
 r/tmp.mkdir /var
00d0  2f 6c 6f 67 0a 6d 6b 64 69 72 20 2f 76 61 72 2f=20
 /log.mkdir /var/
00e0  72 75 6e 0a 6d 6b 64 69 72 20 2f 76 61 72 2f 6c=20
 run.mkdir /var/l
00f0  6f 63 6b 0a 66 6c 61 74 66 73 64 20 2d 72 0a 63=20
 ock.flatfsd -r.c
    Data:
686F73746E616D652045444F534B323637340A2F62696E2F...

No.     Time        Source                Destination=20
         Protocol Info
 485000 192380.295289 192.168.1.109       =20
192.168.1.233         SCTP     SACK=20

Frame 485000 (64 bytes on wire, 64 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.109 (192.168.1.109),
Dst: 192.168.1.233 (192.168.1.233)
Stream Control Transmission Protocol, Src Port: 10000
(10000), Dst Port: 3072 (3072)
    Source port: 10000
    Destination port: 3072
    Verification tag: 0xee4cc7c0
    Checksum: 0xd6a06e0d [correct CRC32C]
    SACK chunk (Cumulative TSN: 3998009281, a_rwnd:
55032, gaps: 0, duplicate TSNs: 0)
        Chunk type: SACK (3)
        Chunk flags: 0x00
        Chunk length: 16
        Cumulative TSN ACK: 3998009281
        Advertised receiver window credit (a_rwnd):
55032
        Number of gap acknowledgement blocks: 0
        Number of duplicated TSNs: 0

No.     Time        Source                Destination=20
         Protocol Info
 485007 192385.449421 192.168.1.233       =20
192.168.1.109         SCTP     DATA=20

Frame 485007 (80 bytes on wire, 80 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
Dst: 192.168.1.109 (192.168.1.109)
Stream Control Transmission Protocol, Src Port: 3072
(3072), Dst Port: 10000 (10000)
    Source port: 3072
    Destination port: 10000
    Verification tag: 0x4d855e4f
    Checksum: 0xa6294f39 [correct CRC32C]
    DATA chunk(ordered, complete segment, TSN:
3998009282, SID: 0, SSN: 1, PPID: 0, payload length:
13 bytes)
        Chunk type: DATA (0)
        Chunk flags: 0x03
        Chunk length: 29
        TSN: 3998009282
        Stream Identifier: 0x0000
        Stream sequence number: 1
        Payload protocol identifier: not specified (0)
        Chunk padding: 303030
Data (13 bytes)

0000  61 74 20 2f 65 74 63 2f 6d 6f 74 64 0a         =20
 at /etc/motd.
    Data: 6174202F6574632F6D6F74640A

No.     Time        Source                Destination=20
         Protocol Info
 485008 192385.647279 192.168.1.109       =20
192.168.1.233         SCTP     SACK=20

Frame 485008 (64 bytes on wire, 64 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.109 (192.168.1.109),
Dst: 192.168.1.233 (192.168.1.233)
Stream Control Transmission Protocol, Src Port: 10000
(10000), Dst Port: 3072 (3072)
    Source port: 10000
    Destination port: 3072
    Verification tag: 0xee4cc7c0
    Checksum: 0xd87dd0d3 [correct CRC32C]
    SACK chunk (Cumulative TSN: 3998009282, a_rwnd:
55019, gaps: 0, duplicate TSNs: 0)
        Chunk type: SACK (3)
        Chunk flags: 0x00
        Chunk length: 16
        Cumulative TSN ACK: 3998009282
        Advertised receiver window credit (a_rwnd):
55019
        Number of gap acknowledgement blocks: 0
        Number of duplicated TSNs: 0

No.     Time        Source                Destination=20
         Protocol Info
 485203 192463.052409 192.168.1.233       =20
192.168.1.109         SCTP     SHUTDOWN=20

Frame 485203 (62 bytes on wire, 62 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
Dst: 192.168.1.109 (192.168.1.109)
Stream Control Transmission Protocol, Src Port: 3072
(3072), Dst Port: 10000 (10000)
    Source port: 3072
    Destination port: 10000
    Verification tag: 0x4d855e4f
    Checksum: 0xfa0aa00c [correct CRC32C]
    SHUTDOWN chunk (Cumulative TSN ack: 1795865471)
        Chunk type: SHUTDOWN (7)
        Chunk flags: 0x00
        Chunk length: 8
        Cumulative TSN Ack: 1795865471

No.     Time        Source                Destination=20
         Protocol Info
 485204 192463.052528 192.168.1.109       =20
192.168.1.233         SCTP     SHUTDOWN_ACK=20

Frame 485204 (52 bytes on wire, 52 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.109 (192.168.1.109),
Dst: 192.168.1.233 (192.168.1.233)
Stream Control Transmission Protocol, Src Port: 10000
(10000), Dst Port: 3072 (3072)
    Source port: 10000
    Destination port: 3072
    Verification tag: 0xee4cc7c0
    Checksum: 0x6df73964 [correct CRC32C]
    SHUTDOWN_ACK chunk
        Chunk type: SHUTDOWN_ACK (8)
        Chunk flags: 0x00
        Chunk length: 4

No.     Time        Source                Destination=20
         Protocol Info
 485205 192463.145419 192.168.1.233       =20
192.168.1.109         SCTP     SHUTDOWN_COMPLETE=20

Frame 485205 (62 bytes on wire, 62 bytes captured)
Linux cooked capture
Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
Dst: 192.168.1.109 (192.168.1.109)
Stream Control Transmission Protocol, Src Port: 3072
(3072), Dst Port: 10000 (10000)
    Source port: 3072
    Destination port: 10000
    Verification tag: 0x4d855e4f
    Checksum: 0x9b456826 [correct CRC32C]
    SHUTDOWN_COMPLETE chunk
        Chunk type: SHUTDOWN_COMPLETE (14)
        Chunk flags: 0x00
        Chunk length: 4


--

With your feet on the air and your head on the ground=20
Try this trick and spin it, yeah=20
Your head will collapse if there's nothing in it=20
And you'll ask yourself=20

Where is my mind?
Where is my mind?
Where is my mind?


      __________________________________________________________
Gesendet von Yahoo! Mail.
Mehr M=F6glichkeiten, in Kontakt zu bleiben. http://de.overview.mail.yahoo.=
com
