From: Hangbin Liu <liuhangbin@gmail.com>
Date: Sun, 27 Oct 2013 03:11:37 +0000
Subject: [lksctp-developers] sctp_status: Got sendmsg: Invalid argument when set max_stream larger than 10
Message-Id: <CAPwn2JQRx3j3GieoZaFh4wO7MPGmZPNY9W2U7hsQJ0xUULX3MA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi Daniel,

When I run sctp_status test and set max_stream >=3D 10, the client will
fail with "sendmsg: Invalid argument". Would you like to help have a
look at this?

# ./sctp_status -H 127.0.0.1 -P 9998 -h 127.0.0.1 -p 9999 -s -d 2 -M 20
remote:addr=127.0.0.1, port=3Ddistinct, family=3D2
local:addr=127.0.0.1, port=3Ddistinct32, family=3D2

Starting tests...
        socket(SOCK_STREAM, IPPROTO_SCTP)  ->  sk=3D3
        bind(sk=3D3, [a:127.0.0.1,p:distinct32])  --  attempt 1/10
        connect(sk=3D3)
Client: Sending packets.(1/10)
        sendmsg(sk=3D3, assoc=3D0) 17768 bytes.
          SNDRCV(stream=3D1 flags=3D0x1 ppid=846930886)
        sendmsg(sk=3D3, assoc=3D0) 6250 bytes.
          SNDRCV(stream=3D2 flags=3D0x1 ppid=1714636915)
        sendmsg(sk=3D3, assoc=3D0) 23634 bytes.
          SNDRCV(stream=3D3 flags=3D0x1 ppidB4238335)
        sendmsg(sk=3D3, assoc=3D0) 5195 bytes.
          SNDRCV(stream=3D4 flags=3D0x1 ppid=1649760492)
        sendmsg(sk=3D3, assoc=3D0) 7978 bytes.
          SNDRCV(stream=3D5 flags=3D0x1 ppid=1189641421)
        sendmsg(sk=3D3, assoc=3D0) 22715 bytes.
          SNDRCV(stream=3D6 flags=3D0x1 ppid=1350490027)
        sendmsg(sk=3D3, assoc=3D0) 16883 bytes.
          SNDRCV(stream=3D7 flags=3D0x1 ppid=1102520059)
        sendmsg(sk=3D3, assoc=3D0) 10724 bytes.
          SNDRCV(stream=3D8 flags=3D0x1 ppid=1967513926)
        sendmsg(sk=3D3, assoc=3D0)  125 bytes.
          SNDRCV(stream=3D9 flags=3D0x1 ppid=1540383426)
        sendmsg(sk=3D3, assoc=3D0) 2133 bytes.
          SNDRCV(stream=10 flags=3D0x1 ppid=1303455736)

                *** sendmsg: Invalid argument ***

Thanks
Hangbin Liu
