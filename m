From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 29 Apr 2008 02:03:13 +0000
Subject: Re: [Lksctp-developers] sctp and select
Message-Id: <481681E1.2060904@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

muskala magda wrote:
> hi,
>=20
> i am trying to rn this server. the (low level)
> communication seems to be done. but after accepting
> the connection, the select doesn't notice an incoming
> data. it notices only the 4 way handshake & closing
> packets, but not the data. the program waits in this
> line:
>=20
> if (select(fdmax+1, &read_fds, NULL, NULL, NULL)) {
>=20
> there is also an error after cookie echo received by
> the server, but as already mentioned, the
> communication seems not to be broken. are the data
> buffered? how can i check it/read it? how can i (if it
> is possible at all) "force" the select to notice the
> incoming data packets?

It looks like the system you are talking to is utterly
broken.

> No.     Time        Source                Destination=20
>          Protocol Info
>  484981 192374.502964 192.168.1.233       =20
> 192.168.1.109         SCTP     DATA=20
>=20
> Frame 484981 (72 bytes on wire, 72 bytes captured)
> Linux cooked capture
> Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
> Dst: 192.168.1.109 (192.168.1.109)
> Stream Control Transmission Protocol, Src Port: 3072
> (3072), Dst Port: 10000 (10000)
>     Source port: 3072
>     Destination port: 10000
>     Verification tag: 0x4d855e4f
>     Checksum: 0x5edddafd [correct CRC32C]
>     DATA chunk(ordered, complete segment, TSN:
> 3998009280, SID: 0, SSN: 1, PPID: 0, payload length: 8
> bytes)
>         Chunk type: DATA (0)
>         Chunk flags: 0x03
>         Chunk length: 24
>         TSN: 3998009280
>         Stream Identifier: 0x0000
>         Stream sequence number: 1

First of all, the very first data chunk of an association has
to start with a SSN of 0.

>         Payload protocol identifier: not specified (0)
> Data (8 bytes)
>=20
> 0000  72 63 23 23 23 32 36 39                        =20
>  rc###269
>     Data: 7263232323323639
>=20
>=20
> No.     Time        Source                Destination=20
>          Protocol Info
>  484999 192380.098573 192.168.1.233       =20
> 192.168.1.109         SCTP     DATA=20
>=20
> Frame 484999 (320 bytes on wire, 320 bytes captured)
> Linux cooked capture
> Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
> Dst: 192.168.1.109 (192.168.1.109)
> Stream Control Transmission Protocol, Src Port: 3072
> (3072), Dst Port: 10000 (10000)
>     Source port: 3072
>     Destination port: 10000
>     Verification tag: 0x4d855e4f
>     Checksum: 0x9b833a01 [correct CRC32C]
>     DATA chunk(ordered, complete segment, TSN:
> 3998009281, SID: 0, SSN: 1, PPID: 0, payload length:
> 256 bytes)
>         Chunk type: DATA (0)
>         Chunk flags: 0x03
>         Chunk length: 272
>         TSN: 3998009281
>         Stream Identifier: 0x0000
>         Stream sequence number: 1
>         Payload protocol identifier: not specified (0)
> Data (256 bytes)
>=20
> 0000  68 6f 73 74 6e 61 6d 65 20 45 44 4f 53 4b 32 36=20
>  hostname EDOSK26
> 0010  37 34 0a 2f 62 69 6e 2f 65 78 70 61 6e 64 20 2f=20
>  74./bin/expand /
> 0020  65 74 63 2f 72 61 6d 66 73 2e 69 6d 67 20 2f 64=20
>  etc/ramfs.img /d
> 0030  65 76 2f 72 61 6d 30 0a 2f 62 69 6e 2f 65 78 70=20
>  ev/ram0./bin/exp
> 0040  61 6e 64 20 2f 65 74 63 2f 72 61 6d 66 73 2e 69=20
>  and /etc/ramfs.i
> 0050  6d 67 20 2f 64 65 76 2f 72 61 6d 31 0a 6d 6f 75=20
>  mg /dev/ram1.mou
> 0060  6e 74 20 2d 74 20 70 72 6f 63 20 70 72 6f 63 20=20
>  nt -t proc proc=20
> 0070  2f 70 72 6f 63 0a 6d 6f 75 6e 74 20 2d 74 20 65=20
>  /proc.mount -t e
> 0080  78 74 32 20 2f 64 65 76 2f 72 61 6d 30 20 2f 76=20
>  xt2 /dev/ram0 /v
> 0090  61 72 0a 6d 6f 75 6e 74 20 2d 74 20 65 78 74 32=20
>  ar.mount -t ext2
> 00a0  20 2f 64 65 76 2f 72 61 6d 31 20 2f 65 74 63 2f=20
>   /dev/ram1 /etc/
> 00b0  63 6f 6e 66 69 67 0a 6d 6b 64 69 72 20 2f 76 61=20
>  config.mkdir /va
> 00c0  72 2f 74 6d 70 0a 6d 6b 64 69 72 20 2f 76 61 72=20
>  r/tmp.mkdir /var
> 00d0  2f 6c 6f 67 0a 6d 6b 64 69 72 20 2f 76 61 72 2f=20
>  /log.mkdir /var/
> 00e0  72 75 6e 0a 6d 6b 64 69 72 20 2f 76 61 72 2f 6c=20
>  run.mkdir /var/l
> 00f0  6f 63 6b 0a 66 6c 61 74 66 73 64 20 2d 72 0a 63=20
>  ock.flatfsd -r.c
>     Data:
> 686F73746E616D652045444F534B323637340A2F62696E2F...
>=20
>=20
> No.     Time        Source                Destination=20
>          Protocol Info
>  485007 192385.449421 192.168.1.233       =20
> 192.168.1.109         SCTP     DATA=20
>=20
> Frame 485007 (80 bytes on wire, 80 bytes captured)
> Linux cooked capture
> Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
> Dst: 192.168.1.109 (192.168.1.109)
> Stream Control Transmission Protocol, Src Port: 3072
> (3072), Dst Port: 10000 (10000)
>     Source port: 3072
>     Destination port: 10000
>     Verification tag: 0x4d855e4f
>     Checksum: 0xa6294f39 [correct CRC32C]
>     DATA chunk(ordered, complete segment, TSN:
> 3998009282, SID: 0, SSN: 1, PPID: 0, payload length:
> 13 bytes)
>         Chunk type: DATA (0)
>         Chunk flags: 0x03
>         Chunk length: 29
>         TSN: 3998009282
>         Stream Identifier: 0x0000
>         Stream sequence number: 1

Secondly, each subsequent complete DATA chunk must increment the Stream
sequence number.  SSN 1 has already been received above.

The only time that SSN remains the same is when fragment DATA chunks
are sent.

Looks like the sender SCTP stack has a bug with ordered DATA chunks.

-vlad

>         Payload protocol identifier: not specified (0)
>         Chunk padding: 303030
> Data (13 bytes)
>=20
> 0000  61 74 20 2f 65 74 63 2f 6d 6f 74 64 0a         =20
>  at /etc/motd.
>     Data: 6174202F6574632F6D6F74640A
>=20
> No.     Time        Source                Destination=20
>          Protocol Info
>  485008 192385.647279 192.168.1.109       =20
> 192.168.1.233         SCTP     SACK=20
>=20
> Frame 485008 (64 bytes on wire, 64 bytes captured)
> Linux cooked capture
> Internet Protocol, Src: 192.168.1.109 (192.168.1.109),
> Dst: 192.168.1.233 (192.168.1.233)
> Stream Control Transmission Protocol, Src Port: 10000
> (10000), Dst Port: 3072 (3072)
>     Source port: 10000
>     Destination port: 3072
>     Verification tag: 0xee4cc7c0
>     Checksum: 0xd87dd0d3 [correct CRC32C]
>     SACK chunk (Cumulative TSN: 3998009282, a_rwnd:
> 55019, gaps: 0, duplicate TSNs: 0)
>         Chunk type: SACK (3)
>         Chunk flags: 0x00
>         Chunk length: 16
>         Cumulative TSN ACK: 3998009282
>         Advertised receiver window credit (a_rwnd):
> 55019
>         Number of gap acknowledgement blocks: 0
>         Number of duplicated TSNs: 0
>=20
> No.     Time        Source                Destination=20
>          Protocol Info
>  485203 192463.052409 192.168.1.233       =20
> 192.168.1.109         SCTP     SHUTDOWN=20
>=20
> Frame 485203 (62 bytes on wire, 62 bytes captured)
> Linux cooked capture
> Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
> Dst: 192.168.1.109 (192.168.1.109)
> Stream Control Transmission Protocol, Src Port: 3072
> (3072), Dst Port: 10000 (10000)
>     Source port: 3072
>     Destination port: 10000
>     Verification tag: 0x4d855e4f
>     Checksum: 0xfa0aa00c [correct CRC32C]
>     SHUTDOWN chunk (Cumulative TSN ack: 1795865471)
>         Chunk type: SHUTDOWN (7)
>         Chunk flags: 0x00
>         Chunk length: 8
>         Cumulative TSN Ack: 1795865471
>=20
> No.     Time        Source                Destination=20
>          Protocol Info
>  485204 192463.052528 192.168.1.109       =20
> 192.168.1.233         SCTP     SHUTDOWN_ACK=20
>=20
> Frame 485204 (52 bytes on wire, 52 bytes captured)
> Linux cooked capture
> Internet Protocol, Src: 192.168.1.109 (192.168.1.109),
> Dst: 192.168.1.233 (192.168.1.233)
> Stream Control Transmission Protocol, Src Port: 10000
> (10000), Dst Port: 3072 (3072)
>     Source port: 10000
>     Destination port: 3072
>     Verification tag: 0xee4cc7c0
>     Checksum: 0x6df73964 [correct CRC32C]
>     SHUTDOWN_ACK chunk
>         Chunk type: SHUTDOWN_ACK (8)
>         Chunk flags: 0x00
>         Chunk length: 4
>=20
> No.     Time        Source                Destination=20
>          Protocol Info
>  485205 192463.145419 192.168.1.233       =20
> 192.168.1.109         SCTP     SHUTDOWN_COMPLETE=20
>=20
> Frame 485205 (62 bytes on wire, 62 bytes captured)
> Linux cooked capture
> Internet Protocol, Src: 192.168.1.233 (192.168.1.233),
> Dst: 192.168.1.109 (192.168.1.109)
> Stream Control Transmission Protocol, Src Port: 3072
> (3072), Dst Port: 10000 (10000)
>     Source port: 3072
>     Destination port: 10000
>     Verification tag: 0x4d855e4f
>     Checksum: 0x9b456826 [correct CRC32C]
>     SHUTDOWN_COMPLETE chunk
>         Chunk type: SHUTDOWN_COMPLETE (14)
>         Chunk flags: 0x00
>         Chunk length: 4
>=20
>=20
> --
>=20
> With your feet on the air and your head on the ground=20
> Try this trick and spin it, yeah=20
> Your head will collapse if there's nothing in it=20
> And you'll ask yourself=20
>=20
> Where is my mind?
> Where is my mind?
> Where is my mind?
>=20
>=20
>       __________________________________________________________
> Gesendet von Yahoo! Mail.
> Mehr M=F6glichkeiten, in Kontakt zu bleiben. http://de.overview.mail.yaho=
o.com
>=20
> -------------------------------------------------------------------------
> This SF.net email is sponsored by the 2008 JavaOne(SM) Conference=20
> Don't miss this year's exciting event. There's still time to save $100.=20
> Use priority code J8TL2D2.=20
> http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/ja=
vaone
> _______________________________________________
> Lksctp-developers mailing list
> Lksctp-developers@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>=20

