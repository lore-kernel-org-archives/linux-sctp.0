From: David Neil <David.Neil@attocore.com>
Date: Fri, 16 Mar 2018 09:33:12 +0000
Subject: SCTP abort with T-bit set after handshake
Message-Id: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,
I have been having intermittent problems with SCTP connection failures; I have finally caught one on Wireshark.

From the application code, I see task-A opening an SCTP connection to task-B and messages being exchanged in both directions. At some subsequent point task-A attempts to send a message and receives an SCTP_COMM_LOST followed by an SCTP_SEND_FAILED. Nothing is seen at task-B during this attempt to send.

When viewing the same event in wirehark, we see a successful handshake and an exchange of one data chunk in each direction during connection setup. Afew milliseconds later, task-A sends an SCTP message and receives an ABORT chunk from the other end with the T-bit set. In the seconds that follow task-B continues to send heartbeats for the association until finally the association times out at task-B.

Task A                          Task B
--SCTP-INIT-------------------------->
<---------------------------INIT_ACK--
--COOKIE-ECHO + Diameter msg--------->
<------------------COOKIE-ACK + SACK--
<-----------------------Diameter msg--
--SACK------------------------------->
--Diameter msg----------------------->
<---------------ABORT with T-bit set--
<--------------------------Heartbeat--
<--------------------------Heartbeat--
<--------------------------Heartbeat--
<--------------------------Heartbeat--
<----ABORT assoc max retransmissions--

I have put more detailed textual output from Wireshark at the bottom of the post.

If I understand the SCTP specs correctly, an ABORT with the T-bit set indicates that the receiver of the message did not recognize the verification tag. Any ideas how this can happen on an apparently healthy association? 

I am running lksctp 1.0.17 on Debian 9, but I have also seen what I believe is the same problem on lksctp 1.0.16 on Debian 8.

The application code is made up of multiple tasks, each one running in its own thread and using SCTP to communicate with other tasks. The tasks all use one-to-many style SCTP sockets.
The failures occur while running an automated test suite. Each testcase instantiates an appropriate set of tasks (up to 50 or so), tests a sequence of events and then shuts down the tasks.
I am typically seeing one test failure every couple of hours which can be traced back to this problem.

Do you need any more information?
Regards,
Dave.



Frame 620: 84 bytes on wire (672 bits), 84 bytes captured (672 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.12, Dst: 127.0.0.1
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0x00000000
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    INIT chunk (Outbound streams: 2, inbound streams: 32)
        Chunk type: INIT (1)
        Chunk flags: 0x00
        Chunk length: 36
        Initiate tag: 0xd2059903
        Advertised receiver window credit (a_rwnd): 106496
        Number of outbound streams: 2
        Number of inbound streams: 32
        Initial TSN: 4239369224
        Supported address types parameter (Supported types: IPv4)
        ECN parameter
        Forward TSN supported parameter

Frame 621: 308 bytes on wire (2464 bits), 308 bytes captured (2464 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.1, Dst: 127.0.0.12
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0xd2059903
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    INIT_ACK chunk (Outbound streams: 2, inbound streams: 2)
        Chunk type: INIT_ACK (2)
        Chunk flags: 0x00
        Chunk length: 260
        Initiate tag: 0x574885aa
        Advertised receiver window credit (a_rwnd): 106496
        Number of outbound streams: 2
        Number of inbound streams: 2
        Initial TSN: 3027575157
        State cookie parameter (Cookie length: 228 bytes)
        ECN parameter
        Forward TSN supported parameter

Frame 622: 440 bytes on wire (3520 bits), 440 bytes captured (3520 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.12, Dst: 127.0.0.1
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0x574885aa
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    COOKIE_ECHO chunk (Cookie length: 228 bytes)
        Chunk type: COOKIE_ECHO (10)
        Chunk flags: 0x00
        Chunk length: 232
        Cookie: 9a8b766df4a9cb098575172259c06bc90000000000000000...
    DATA chunk(ordered, complete segment, TSN: 4239369224, SID: 0, SSN: 0, PPID: 46, payload length: 144 bytes)
        Chunk type: DATA (0)
        Chunk flags: 0x03
        Chunk length: 160
        Transmission sequence number: 4239369224
        Stream identifier: 0x0000
        Stream sequence number: 0
        Payload protocol identifier: DIAMETER (46)
Diameter Protocol

Frame 623: 68 bytes on wire (544 bits), 68 bytes captured (544 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.1, Dst: 127.0.0.12
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0xd2059903
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    COOKIE_ACK chunk
        Chunk type: COOKIE_ACK (11)
        Chunk flags: 0x00
        Chunk length: 4
    SACK chunk (Cumulative TSN: 4239369224, a_rwnd: 106352, gaps: 0, duplicate TSNs: 0)
        Chunk type: SACK (3)
        Chunk flags: 0x00
        Chunk length: 16
        Cumulative TSN ACK: 4239369224
        Advertised receiver window credit (a_rwnd): 106352
        Number of gap acknowledgement blocks: 0
        Number of duplicated TSNs: 0

Frame 624: 216 bytes on wire (1728 bits), 216 bytes captured (1728 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.1, Dst: 127.0.0.12
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0xd2059903
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    DATA chunk(ordered, complete segment, TSN: 3027575157, SID: 0, SSN: 0, PPID: 46, payload length: 152 bytes)
        Chunk type: DATA (0)
        Chunk flags: 0x03
        Chunk length: 168
        Transmission sequence number: 3027575157
        Stream identifier: 0x0000
        Stream sequence number: 0
        Payload protocol identifier: DIAMETER (46)
Diameter Protocol

Frame 625: 64 bytes on wire (512 bits), 64 bytes captured (512 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.12, Dst: 127.0.0.1
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0x574885aa
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    SACK chunk (Cumulative TSN: 3027575157, a_rwnd: 106344, gaps: 0, duplicate TSNs: 0)
        Chunk type: SACK (3)
        Chunk flags: 0x00
        Chunk length: 16
        Cumulative TSN ACK: 3027575157
        Advertised receiver window credit (a_rwnd): 106344
        Number of gap acknowledgement blocks: 0
        Number of duplicated TSNs: 0

Frame 796: 288 bytes on wire (2304 bits), 288 bytes captured (2304 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.12, Dst: 127.0.0.1
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0x574885aa
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    DATA chunk(ordered, complete segment, TSN: 4239369225, SID: 0, SSN: 1, PPID: 46, payload length: 224 bytes)
        Chunk type: DATA (0)
        Chunk flags: 0x03
        Chunk length: 240
        Transmission sequence number: 4239369225
        Stream identifier: 0x0000
        Stream sequence number: 1
        Payload protocol identifier: DIAMETER (46)
Diameter Protocol

Frame 797: 52 bytes on wire (416 bits), 52 bytes captured (416 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.1, Dst: 127.0.0.12
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0x574885aa
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    ABORT chunk
        Chunk type: ABORT (6)
        Chunk flags: 0x01
            .... ...1 = T-Bit: Tag reflected
        Chunk length: 4

Frame 1178: 100 bytes on wire (800 bits), 100 bytes captured (800 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.1, Dst: 127.0.0.12
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0xd2059903
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    HEARTBEAT chunk (Information: 48 bytes)
        Chunk type: HEARTBEAT (4)
        Chunk flags: 0x00
        Chunk length: 52
        Heartbeat info parameter (Information: 44 bytes)

Frame 1492: 100 bytes on wire (800 bits), 100 bytes captured (800 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.1, Dst: 127.0.0.12
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0xd2059903
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    HEARTBEAT chunk (Information: 48 bytes)
        Chunk type: HEARTBEAT (4)
        Chunk flags: 0x00
        Chunk length: 52
        Heartbeat info parameter (Information: 44 bytes)

Frame 1565: 100 bytes on wire (800 bits), 100 bytes captured (800 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.1, Dst: 127.0.0.12
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0xd2059903
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    HEARTBEAT chunk (Information: 48 bytes)
        Chunk type: HEARTBEAT (4)
        Chunk flags: 0x00
        Chunk length: 52
        Heartbeat info parameter (Information: 44 bytes)

Frame 1960: 100 bytes on wire (800 bits), 100 bytes captured (800 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.1, Dst: 127.0.0.12
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0xd2059903
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    HEARTBEAT chunk (Information: 48 bytes)
        Chunk type: HEARTBEAT (4)
        Chunk flags: 0x00
        Chunk length: 52
        Heartbeat info parameter (Information: 44 bytes)

Frame 2816: 100 bytes on wire (800 bits), 100 bytes captured (800 bits)
Linux cooked capture
Internet Protocol Version 4, Src: 127.0.0.1, Dst: 127.0.0.12
Stream Control Transmission Protocol, Src Port: 3868 (3868), Dst Port: 3868 (3868)
    Source port: 3868
    Destination port: 3868
    Verification tag: 0xd2059903
    [Association index: 45]
    Checksum: 0x00000000 [unverified]
    [Checksum Status: Unverified]
    ABORT chunk
        Chunk type: ABORT (6)
        Chunk flags: 0x00
            .... ...0 = T-Bit: Tag not reflected
        Chunk length: 50
        Protocol violation cause
            Cause code: Protocol violation (0x000d)



