From: Peter Salin <peter.salin@gmail.com>
Date: Thu, 21 Sep 2017 12:41:51 +0000
Subject: Re: PMTU discovery behaviour
Message-Id: <CAH9vUQs88PryhvdwUdX0pEHFPp7BYJajSrbmrPZGd7GhufKTKA@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="001a114099aaa91fef0559b26acf"
List-Id: <linux-sctp.vger.kernel.org>
References: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
In-Reply-To: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
To: linux-sctp@vger.kernel.org

--001a114099aaa91fef0559b26acf
Content-Type: text/plain; charset="UTF-8"

2017-09-21 14:01 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
> On Wed, Sep 20, 2017 at 02:02:45PM +0300, Peter Salin wrote:
>> 2017-09-19 20:09 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
>> > On Mon, Sep 11, 2017 at 03:44:57PM +0300, Peter Salin wrote:
>> >> Hi,
>> >>
>> >> I encountered some strange PMTUD related behaviour that I need help in
>> >> understanding.
>> >>
>> >> Setup:
>> >>
>> >> +-----------+        +---+        +--------+
>> >> | 10.0.0.10 |--------| X |--------|10.0.0.3|
>> >> +-----------+        +---+        +--------+
>> >>
>> >> A one to many socket is setup at 10.0.0.10. Two instances of the
>> >> lksctp sctp_darn applications are ran at 10.0.0.3 listening to ports
>> >> 8001 and 8002. 10.0.0.3 was also setup to generate ICMP frag needed
>> >> messages for incoming messages over 600 bytes. This same issue also
>> >> occurs also when a router on the path was setup to generate the ICMP
>> >> message instead.
>> >>
>> >> Test 1:
>> >> Two associations were connected from 10.0.0.10 to 10.0.0.3, one to
>> >> port 8001 and another one to 8002. Then a too large message was sent
>> >> on the association to 8001, triggering ICMP generation. When checking
>> >> the MTU reported in spinfo_mtu field of SCTP_GET_PEER_ADDR_INFO, the
>> >> association now reports 600. The association to 8002 reports 1500
>> >> until traffic is sent on it, at which point it also adjusts to 600
>> >> which I think makes sense since the destination IP is the same. When
>> >> reopening the associations, the value of 600 would be remembered for
>> >> about 10 min, which I also think makes sense since
>> >> net.ipv4.route.mtu_expires is 600.
>> >>
>> >> Test 2:
>> >> Again the same two associations were connected to 10.0.0.3, but in
>> >> addition an attempt to connect a third association to a non-existing
>> >> IP was done, this attempt fails with timeout after a while. After
>> >> that, again an ICMP triggering large message was sent to 8001. Now the
>> >> behaviour is different from before. The association to 8001 reports a
>> >> spinfo_mtu of 600, but only for a brief moment, it does not stay at
>> >> 600 for 10 minutes. In addition the spinfo_mtu of the association to
>> >> 8002 never changes, it stays at the original 1500.
>> >>
>> >> The only difference between the two tests is the attempt to connect to
>> >> a non-responding IP at the beginning of test 2. Any ideas why the
>> >> behaviour changes, is this a bug or is there some other reason for
>> >> this?
>> >>
>> >> I have attached the sample application used for reproducing this.
>> >>
>> >> BR,
>> >> -Peter
>> >>
>> > Hey, apologies for the delay on this, I've had it in my reader for days and kept
>> > meaning to respond, but kept getting sidetracked.
>> >
>> > First glance, this sounds incorrect.  Each association (or rather each
>> > transport) maintains its own mtu, and the association reflects the mtu of the
>> > active transport. Given that each transport holds its own dst cache entry, I
>> > have a hard time seeing how one transports mtu changes might leak to another
>> >
>> > But thats not really whats happening here.  By your description, the active
>> > transport on the established association isn't updating its pathmtu, which
>> > should happen in response to receiving the ICMP_FRAG_NEEDED message.
>> >
>> > I know you've provided the reproducer bellow, and I appreciate that, but I don't
>> > have the cycles to set this up at the moment.  Could you tell me if, during the
>> > second test, after you attempt to connect to the fake ip address and then send
>> > the large message that should trigger the frag needed message, does said large
>> > message get retransmitted and eventually arrive at the peer host?  If so, that
>> > suggests that the sctp stack:
>> >
>> > a) receives the frag needed message
>> > and
>> > b) resends the packet at the lower frag point
>> >
>> > That in turn suggests we just have some internal reporting error in which we
>> > don't update the associations pmtu with the active transports
>> >
>> > Let me know the answer to that question and it will give me some places to start
>> > looking
>> > Neil
>> >
>> Thanks for responding. In response to your question, the first large
>> message does get retransmitted without the Don't Fragment bit set. I
>> modified the test a bit to also send further messages after the first
>> one. Those messages are indeed fragmented according to the limit of
>> the ICMP message. I have attached a PCAP trace and SCTP debug logs in
>> case that helps here.
>>
>> I also tried sending a large message on the other association after
>> the large message on the first association had been sent. For test 2
>> that message was not fragmented even though the ICMP was already
>> received for the first assoc. After the second assoc also received an
>> ICMP it adjusted to use the lower MTU for subsequent messages. In the
>> case of test 1, sending a large message on the second assoc would auto
>> fragment already on the first message.
>>
>> Also, after stopping and rerunning test 2 the MTU would always be
>> reset at 1500, whereas in test 1 the lower limit would still be in
>> effect for a new run. So it seems like in test 2 the lower MTU is only
>> known within each association, where as in test 1 the lower MTU also
>> gets stored deeper down?
>>
>> BR,
>> -Peter
>>
> So, from what I can see, your included tcpdump only shows the first part of what
> you are describing.  That is to say that it sends a large data chunk on an
> association that gets an ICMP frag needed response, after which the pmtu is
> lowered and smaller message fragments are sent, which is good (i.e. working as
> designed).
>
> I don't see anything in the tcpdump relating to the remainder of your test,
> showing failed fragmentation.  Can you include that please?
>
> Neil
Yes, please find attached traces that include sending on the other
association after receiving the first ICMP.

BR,
-Peter
>
>> >> ------ ver_linux output ------
>> >> Linux esalipe-test 4.4.0-93-generic #116-Ubuntu SMP Fri Aug 11
>> >> 21:17:51 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>> >>
>> >> GNU C                   5.4.0
>> >> GNU Make                4.1
>> >> Binutils                2.26.1
>> >> Util-linux              2.27.1
>> >> Mount                   2.27.1
>> >> Module-init-tools       22
>> >> E2fsprogs               1.42.13
>> >> Xfsprogs                4.3.0
>> >> Linux C Library         2.23
>> >> Dynamic linker (ldd)    2.23
>> >> Linux C++ Library       6.0.21
>> >> Procps                  3.3.10
>> >> Net-tools               1.60
>> >> Kbd                     1.15.5
>> >> Console-tools           1.15.5
>> >> Sh-utils                8.25
>> >> Udev                    229
>> >> Modules Loaded          ablk_helper aes_x86_64 aesni_intel
>> >> async_memcpy async_pq async_raid6_recov async_tx async_xor autofs4
>> >> binfmt_misc btrfs  crc32_pclmul crct10dif_pclmul cryptd floppy
>> >> gf128mul ghash_clmul ni_intel glue_helper hid hid_generic ib_addr
>> >> ib_cm ib_core ib_iser ib_mad ib_sa input_leds irqbypass iscsi_tcp
>> >> iw_cm joydev kvm kvm_intel libcrc32c libiscsi libiscsi_tcp linear lrw
>> >> multipath parport parport_pc ppdev psmouse raid0 raid1 raid10 raid456
>> >> raid6_pq rdma_cm scsi_transport_iscsi sctp serio_raw usbhid xor
>> >
>> >>
>> >> #include <cstring>
>> >> #include <ctime>
>> >> #include <iomanip>
>> >> #include <iostream>
>> >>
>> >> #include <errno.h>
>> >> #include <unistd.h>
>> >> #include <arpa/inet.h>
>> >> #include <net/if.h>
>> >> #include <netinet/in.h>
>> >> #include <netinet/sctp.h>
>> >> #include <sys/ioctl.h>
>> >> #include <sys/socket.h>
>> >>
>> >> using namespace std;
>> >>
>> >> static const int ERROR_BUFLEN = 64;
>> >> static const char* SCTP_INTERFACE_NAME = "ens4";
>> >>
>> >> static string data100 = "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789";
>> >> static string data1000 = "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789"
>> >>   "01234567890123456789012345678901234567890123456789";
>> >>
>> >> void printError(const string& msg, const string& funcName) {
>> >>   char errorMessage[ERROR_BUFLEN] {};
>> >>   char* errMsg = ::strerror_r(errno, errorMessage,
>> >>                             sizeof(errorMessage));
>> >>
>> >>   cerr << "::" << funcName << ": " << msg << ": " << errMsg << endl;
>> >> }
>> >>
>> >> int createSocket() {
>> >>   int sockFd = socket (AF_INET,
>> >>                      SOCK_SEQPACKET,
>> >>                      IPPROTO_SCTP);
>> >>   if (sockFd == -1) {
>> >>     printError("Creation of socket failed", __FUNCTION__);
>> >>     return -1;
>> >>   }
>> >>
>> >>   // Enable address reuse
>> >>   int enable = 1;
>> >>   int err = setsockopt(sockFd,
>> >>                      SOL_SOCKET,
>> >>                      SO_REUSEADDR,
>> >>                      &enable,
>> >>                      sizeof(enable));
>> >>
>> >>   if (err) {
>> >>     printError("Error setting socket option SO_REUSEADDR", __FUNCTION__);
>> >>     close(sockFd);
>> >>     return -1;
>> >>   }
>> >>
>> >>   // Configure SCTP
>> >>   sctp_initmsg initmsg{};
>> >>   initmsg.sinit_num_ostreams = 3;
>> >>   initmsg.sinit_max_instreams = 3;
>> >>   initmsg.sinit_max_attempts = 2;
>> >>   initmsg.sinit_max_init_timeo = 0;
>> >>
>> >>   err = setsockopt(sockFd,
>> >>                  IPPROTO_SCTP,
>> >>                  SCTP_INITMSG,
>> >>                  &initmsg,
>> >>                  sizeof(initmsg));
>> >>
>> >>   if (err) {
>> >>     printError("Configuring SCTP socket failed", __FUNCTION__);
>> >>     close(sockFd);
>> >>     return -1;
>> >>   }
>> >>
>> >>   struct sctp_paddrparams paddr_params{};
>> >>   memset(&paddr_params, 0, sizeof(paddr_params));
>> >>   socklen_t size_of_sctp_paddr_params = sizeof(paddr_params);
>> >>   paddr_params.spp_flags = SPP_HB_ENABLE | SPP_PMTUD_ENABLE | SPP_SACKDELAY_ENABLE;
>> >>
>> >>   err = setsockopt(sockFd,
>> >>                  IPPROTO_SCTP,
>> >>                  SCTP_PEER_ADDR_PARAMS,
>> >>                  &paddr_params,
>> >>                  size_of_sctp_paddr_params);
>> >>
>> >>   if (err) {
>> >>     printError("Configuring SCTP params failed", __FUNCTION__);
>> >>     close(sockFd);
>> >>     return -1;
>> >>   }
>> >>
>> >>   return sockFd;
>> >> }
>> >>
>> >> bool bindSocket(const int sockFd, const int localPort) {
>> >>   // Get IP of ethernet interface
>> >>   string localAddress = "";
>> >>   ifreq ifr{};
>> >>   ifr.ifr_addr.sa_family = AF_INET;
>> >>   strncpy(ifr.ifr_name, SCTP_INTERFACE_NAME, IFNAMSIZ - 1);
>> >>   const int ioctlStatus = ioctl(sockFd,
>> >>                               SIOCGIFADDR,
>> >>                               &ifr);
>> >>
>> >>   if (ioctlStatus == -1) {
>> >>     printError("Failed to get local address", __FUNCTION__);
>> >>     return false;
>> >>   }
>> >>
>> >>   char ipAddrBuffer[INET_ADDRSTRLEN] {};
>> >>   inet_ntop(AF_INET,
>> >>           &reinterpret_cast<sockaddr_in*>(&(ifr.ifr_addr))->sin_addr,
>> >>           ipAddrBuffer,
>> >>           sizeof(ipAddrBuffer));
>> >>
>> >>   localAddress.assign(ipAddrBuffer);
>> >>
>> >>   // Bind to found ip address
>> >>   sockaddr_in serv_addr{};
>> >>   serv_addr.sin_family = AF_INET;
>> >>   inet_pton(AF_INET,
>> >>           localAddress.c_str(),
>> >>           &serv_addr.sin_addr);
>> >>   serv_addr.sin_port = htons(localPort);
>> >>
>> >>   if (bind(sockFd,
>> >>          reinterpret_cast<sockaddr*>(&serv_addr),
>> >>          sizeof(serv_addr))) {
>> >>     printError("Failed to bind socket to local address", __FUNCTION__);
>> >>     localAddress.clear();
>> >>     close(sockFd);
>> >>     return false;
>> >>   }
>> >>
>> >>   cout << "Local endpoint succussfully bound to local address: " << localAddress << endl;
>> >>
>> >>   return true;
>> >> }
>> >>
>> >> bool openAssociation(const int sockFd,
>> >>                    const string &remoteAddress,
>> >>                    std::uint16_t remotePort) {
>> >>
>> >>   sockaddr_in address{};
>> >>   address.sin_family = AF_INET;
>> >>   inet_pton(AF_INET, remoteAddress.c_str(), &address.sin_addr);
>> >>   address.sin_port = htons(remotePort);
>> >>
>> >>   int connectError = connect(sockFd,
>> >>                            reinterpret_cast<sockaddr *>(&address),
>> >>                            sizeof(address));
>> >>   if (connectError) {
>> >>     printError("Error connecting association", __FUNCTION__);
>> >>     return false;
>> >>   }
>> >>
>> >>   cout << "Association connected to address: " << remoteAddress << ":" << remotePort << endl;
>> >>   return true;
>> >> }
>> >>
>> >> void sendReq(const int sockFd,
>> >>            const string& remoteAddress,
>> >>            const uint16_t remotePort,
>> >>            const std::string& data)
>> >> {
>> >>
>> >>   struct sockaddr_in remoteAddr {};
>> >>   remoteAddr.sin_family = AF_INET;
>> >>   remoteAddr.sin_port = htons(remotePort);
>> >>
>> >>   uint32_t payloadProtId = 7;
>> >>   uint16_t streamId = 0;
>> >>   uint32_t dataLength = data.size();
>> >>   sockaddr* servaddr = reinterpret_cast<sockaddr*>(&remoteAddr);
>> >>   inet_pton(AF_INET, remoteAddress.c_str(), &remoteAddr.sin_addr);
>> >>
>> >>   const std::string ipaddr =
>> >>     inet_ntoa(reinterpret_cast<sockaddr_in*>(servaddr)->sin_addr);
>> >>
>> >>   cout << "Sending SCTP req to " << remoteAddress << ":" << remotePort;
>> >>   cout << ", len=" << dataLength << endl;
>> >>
>> >>   const int bytesSent = sctp_sendmsg(sockFd,
>> >>                                    data.c_str(),
>> >>                                    (size_t)dataLength,
>> >>                                    servaddr,
>> >>                                    sizeof(sockaddr_in),
>> >>                                    htonl(payloadProtId),
>> >>                                    SCTP_ADDR_OVER,
>> >>                                    streamId,
>> >>                                    200,
>> >>                                    0);
>> >>
>> >>   if (bytesSent == -1) {
>> >>     printError("SCTP send failed", __FUNCTION__);
>> >>   }
>> >>
>> >>   return;
>> >> }
>> >>
>> >> sctp_assoc_t getSocketAssociationId(const int sockFd,
>> >>                                   const string &remoteIpAddress,
>> >>                                   std::uint16_t remotePort)
>> >>
>> >> {
>> >>   sockaddr_in socket_address_in{};
>> >>
>> >>   socket_address_in.sin_family = AF_INET;
>> >>   socket_address_in.sin_port = htons(remotePort);
>> >>   inet_pton(AF_INET, remoteIpAddress.c_str(), &socket_address_in.sin_addr);
>> >>
>> >>   struct sockaddr *socket_address = reinterpret_cast<sockaddr*>(&socket_address_in);
>> >>   socklen_t salen = sizeof(&socket_address);
>> >>
>> >>   struct sctp_paddrinfo peer_address_info{};
>> >>   socklen_t size_of_sctp_paddrinfo = sizeof peer_address_info;
>> >>   std::memcpy(&peer_address_info.spinfo_address, socket_address, salen);
>> >>
>> >>   const int sctpOptInfoError = sctp_opt_info(sockFd,
>> >>                                            0,
>> >>                                            SCTP_GET_PEER_ADDR_INFO,
>> >>                                            &peer_address_info,
>> >>                                            &size_of_sctp_paddrinfo);
>> >>
>> >>   if (sctpOptInfoError) {
>> >>     printError("Failed to get association id", __FUNCTION__);
>> >>   }
>> >>
>> >>   return peer_address_info.spinfo_assoc_id;
>> >> }
>> >>
>> >> std::uint32_t getAssociationPathMtu(const int sockFd,
>> >>                                   const string &remoteIpAddress,
>> >>                                   const std::uint16_t remotePort) {
>> >>   sockaddr_in socket_address_in{};
>> >>
>> >>   socket_address_in.sin_family = AF_INET;
>> >>   socket_address_in.sin_port = htons(remotePort);
>> >>   inet_pton(AF_INET, remoteIpAddress.c_str(), &socket_address_in.sin_addr);
>> >>
>> >>   struct sockaddr *socket_address = reinterpret_cast<sockaddr*>(&socket_address_in);
>> >>   socklen_t salen = sizeof(&socket_address);
>> >>
>> >>   struct sctp_paddrinfo peer_address_info{};
>> >>   socklen_t size_of_sctp_paddrinfo = sizeof(peer_address_info);
>> >>   std::memcpy(&peer_address_info.spinfo_address, socket_address, salen);
>> >>
>> >>   sctp_assoc_t sctpAssociationId = getSocketAssociationId(sockFd, remoteIpAddress, remotePort);
>> >>
>> >>   const int sctpOptInfoError = sctp_opt_info(sockFd, sctpAssociationId,
>> >>                                            SCTP_GET_PEER_ADDR_INFO,
>> >>                                            &peer_address_info, &size_of_sctp_paddrinfo);
>> >>   if (sctpOptInfoError) {
>> >>     printError("Failed to get pmtu", __FUNCTION__);
>> >>   }
>> >>
>> >>   auto t = std::time(nullptr);
>> >>   auto tm = *std::localtime(&t);
>> >>   std::cout << std::put_time(&tm, "%H:%M:%S ") << remoteIpAddress << ":" << remotePort;
>> >>   cout << " currently has a PMTU of " << peer_address_info.spinfo_mtu << endl;
>> >>
>> >>   return peer_address_info.spinfo_mtu;
>> >> }
>> >>
>> >> void test1(const string& data) {
>> >>   int localPort = 2944;
>> >>   string remoteIp1 = "10.0.0.3";
>> >>   uint16_t remotePort1 = 8001;
>> >>   uint16_t remotePort2 = 8002;
>> >>
>> >>   int sockFd = createSocket();
>> >>   bindSocket(sockFd, localPort);
>> >>
>> >>   cout << "### Test 1: 2 assocs" << endl;
>> >>
>> >>   openAssociation(sockFd, remoteIp1, remotePort1);
>> >>   openAssociation(sockFd, remoteIp1, remotePort2);
>> >>
>> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>> >>
>> >>   sendReq(sockFd, remoteIp1, remotePort1, data);
>> >>   for (int i = 0; i < 10; i++) {
>> >>     sleep(10);
>> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>> >>   }
>> >> }
>> >>
>> >> void test2(const string& data) {
>> >>   int localPort = 2944;
>> >>   string remoteIp1 = "10.0.0.3";
>> >>   uint16_t remotePort1 = 8001;
>> >>   uint16_t remotePort2 = 8002;
>> >>   string remoteIpFake = "10.52.96.204";
>> >>   uint16_t remotePortFake = 3239;
>> >>
>> >>   int sockFd = createSocket();
>> >>   bindSocket(sockFd, localPort);
>> >>
>> >>   cout << "### Test 2: 2 assocs + 1 unreachable assoc" << endl;
>> >>
>> >>   openAssociation(sockFd, remoteIp1, remotePort1);
>> >>   openAssociation(sockFd, remoteIp1, remotePort2);
>> >>   openAssociation(sockFd, remoteIpFake, remotePortFake);
>> >>
>> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>> >>
>> >>   sendReq(sockFd, remoteIp1, remotePort1, data);
>> >>   for (int i = 0; i < 10; i++) {
>> >>     sleep(10);
>> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>> >>   }
>> >> }
>> >>
>> >>
>> >> int main(int argc, char** argv) {
>> >>   string testNr = "1";
>> >>   string& testData = data1000;
>> >>   if (argc >= 2) {
>> >>     testNr = argv[1];
>> >>   }
>> >>   if (argc >= 3) {
>> >>     testData = data100;
>> >>   }
>> >>
>> >>   if (testNr == "1") {
>> >>     test1(testData);
>> >>   } else {
>> >>     test2(testData);
>> >>   }
>> >>
>> >>   return 0;
>> >> }
>> >
>
>

--001a114099aaa91fef0559b26acf
Content-Type: application/x-gzip; 
	name="test2_traces_send_on_both_assocs.tar.gz"
Content-Disposition: attachment; 
	filename="test2_traces_send_on_both_assocs.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j7ug4pv00

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
Xtfrel2v63W9rtf1ul7X6891/R8UwsRYANACAA==
--001a114099aaa91fef0559b26acf--
