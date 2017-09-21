From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 21 Sep 2017 15:24:55 +0000
Subject: Re: PMTU discovery behaviour
Message-Id: <20170921152455.GA3389@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
In-Reply-To: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Sep 21, 2017 at 03:41:51PM +0300, Peter Salin wrote:
> 2017-09-21 14:01 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
> > On Wed, Sep 20, 2017 at 02:02:45PM +0300, Peter Salin wrote:
> >> 2017-09-19 20:09 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
> >> > On Mon, Sep 11, 2017 at 03:44:57PM +0300, Peter Salin wrote:
> >> >> Hi,
> >> >>
> >> >> I encountered some strange PMTUD related behaviour that I need help in
> >> >> understanding.
> >> >>
> >> >> Setup:
> >> >>
> >> >> +-----------+        +---+        +--------+
> >> >> | 10.0.0.10 |--------| X |--------|10.0.0.3|
> >> >> +-----------+        +---+        +--------+
> >> >>
> >> >> A one to many socket is setup at 10.0.0.10. Two instances of the
> >> >> lksctp sctp_darn applications are ran at 10.0.0.3 listening to ports
> >> >> 8001 and 8002. 10.0.0.3 was also setup to generate ICMP frag needed
> >> >> messages for incoming messages over 600 bytes. This same issue also
> >> >> occurs also when a router on the path was setup to generate the ICMP
> >> >> message instead.
> >> >>
> >> >> Test 1:
> >> >> Two associations were connected from 10.0.0.10 to 10.0.0.3, one to
> >> >> port 8001 and another one to 8002. Then a too large message was sent
> >> >> on the association to 8001, triggering ICMP generation. When checking
> >> >> the MTU reported in spinfo_mtu field of SCTP_GET_PEER_ADDR_INFO, the
> >> >> association now reports 600. The association to 8002 reports 1500
> >> >> until traffic is sent on it, at which point it also adjusts to 600
> >> >> which I think makes sense since the destination IP is the same. When
> >> >> reopening the associations, the value of 600 would be remembered for
> >> >> about 10 min, which I also think makes sense since
> >> >> net.ipv4.route.mtu_expires is 600.
> >> >>
> >> >> Test 2:
> >> >> Again the same two associations were connected to 10.0.0.3, but in
> >> >> addition an attempt to connect a third association to a non-existing
> >> >> IP was done, this attempt fails with timeout after a while. After
> >> >> that, again an ICMP triggering large message was sent to 8001. Now the
> >> >> behaviour is different from before. The association to 8001 reports a
> >> >> spinfo_mtu of 600, but only for a brief moment, it does not stay at
> >> >> 600 for 10 minutes. In addition the spinfo_mtu of the association to
> >> >> 8002 never changes, it stays at the original 1500.
> >> >>
> >> >> The only difference between the two tests is the attempt to connect to
> >> >> a non-responding IP at the beginning of test 2. Any ideas why the
> >> >> behaviour changes, is this a bug or is there some other reason for
> >> >> this?
> >> >>
> >> >> I have attached the sample application used for reproducing this.
> >> >>
> >> >> BR,
> >> >> -Peter
> >> >>
> >> > Hey, apologies for the delay on this, I've had it in my reader for days and kept
> >> > meaning to respond, but kept getting sidetracked.
> >> >
> >> > First glance, this sounds incorrect.  Each association (or rather each
> >> > transport) maintains its own mtu, and the association reflects the mtu of the
> >> > active transport. Given that each transport holds its own dst cache entry, I
> >> > have a hard time seeing how one transports mtu changes might leak to another
> >> >
> >> > But thats not really whats happening here.  By your description, the active
> >> > transport on the established association isn't updating its pathmtu, which
> >> > should happen in response to receiving the ICMP_FRAG_NEEDED message.
> >> >
> >> > I know you've provided the reproducer bellow, and I appreciate that, but I don't
> >> > have the cycles to set this up at the moment.  Could you tell me if, during the
> >> > second test, after you attempt to connect to the fake ip address and then send
> >> > the large message that should trigger the frag needed message, does said large
> >> > message get retransmitted and eventually arrive at the peer host?  If so, that
> >> > suggests that the sctp stack:
> >> >
> >> > a) receives the frag needed message
> >> > and
> >> > b) resends the packet at the lower frag point
> >> >
> >> > That in turn suggests we just have some internal reporting error in which we
> >> > don't update the associations pmtu with the active transports
> >> >
> >> > Let me know the answer to that question and it will give me some places to start
> >> > looking
> >> > Neil
> >> >
> >> Thanks for responding. In response to your question, the first large
> >> message does get retransmitted without the Don't Fragment bit set. I
> >> modified the test a bit to also send further messages after the first
> >> one. Those messages are indeed fragmented according to the limit of
> >> the ICMP message. I have attached a PCAP trace and SCTP debug logs in
> >> case that helps here.
> >>
> >> I also tried sending a large message on the other association after
> >> the large message on the first association had been sent. For test 2
> >> that message was not fragmented even though the ICMP was already
> >> received for the first assoc. After the second assoc also received an
> >> ICMP it adjusted to use the lower MTU for subsequent messages. In the
> >> case of test 1, sending a large message on the second assoc would auto
> >> fragment already on the first message.
> >>
> >> Also, after stopping and rerunning test 2 the MTU would always be
> >> reset at 1500, whereas in test 1 the lower limit would still be in
> >> effect for a new run. So it seems like in test 2 the lower MTU is only
> >> known within each association, where as in test 1 the lower MTU also
> >> gets stored deeper down?
> >>
> >> BR,
> >> -Peter
> >>
> > So, from what I can see, your included tcpdump only shows the first part of what
> > you are describing.  That is to say that it sends a large data chunk on an
> > association that gets an ICMP frag needed response, after which the pmtu is
> > lowered and smaller message fragments are sent, which is good (i.e. working as
> > designed).
> >
> > I don't see anything in the tcpdump relating to the remainder of your test,
> > showing failed fragmentation.  Can you include that please?
> >
> > Neil
> Yes, please find attached traces that include sending on the other
> association after receiving the first ICMP.
> 


Thank you.  So tell me if I'm missing something here, but I think this trace
contradicts what you describe above.  Some specifics:

1) I observe two assocations in this trace:
	a) An association with index 0, who's init chunk is in frame 1
	b) An association with index 1, whos init chunk is in frame 5
	Note that I can toggle between these association flows with the display
filter of:
	sctp.assoc_index = 1
	or
	sctp.assoc_index = 0
	in wireshark


2) In both flows, I can observe that a large chunk is sent:
	a) in assoc index 0, the over-mtu chunk is in frame 9
	b) in assoc index 1, the over-mtu chunk is in frame 16

3) Subsequent to each data chunk in (2), we get an icmp unreach (frag needed
message)
	a) in assoc index 0, the icmp is in frame 10
	b) in assoc index 1, the icmp is in frame 17

4) Subsequent to (3), all DATA chunks appear to get limited to an appropriate
size for the path mtu as specified in the respective icmp from (3), and
oversized datagrams are appropriately fragmented.


Please let me know if I'm missing something, but this trace shows everything to
be working as normal.

Neil

> BR,
> -Peter
> >
> >> >> ------ ver_linux output ------
> >> >> Linux esalipe-test 4.4.0-93-generic #116-Ubuntu SMP Fri Aug 11
> >> >> 21:17:51 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> >> >>
> >> >> GNU C                   5.4.0
> >> >> GNU Make                4.1
> >> >> Binutils                2.26.1
> >> >> Util-linux              2.27.1
> >> >> Mount                   2.27.1
> >> >> Module-init-tools       22
> >> >> E2fsprogs               1.42.13
> >> >> Xfsprogs                4.3.0
> >> >> Linux C Library         2.23
> >> >> Dynamic linker (ldd)    2.23
> >> >> Linux C++ Library       6.0.21
> >> >> Procps                  3.3.10
> >> >> Net-tools               1.60
> >> >> Kbd                     1.15.5
> >> >> Console-tools           1.15.5
> >> >> Sh-utils                8.25
> >> >> Udev                    229
> >> >> Modules Loaded          ablk_helper aes_x86_64 aesni_intel
> >> >> async_memcpy async_pq async_raid6_recov async_tx async_xor autofs4
> >> >> binfmt_misc btrfs  crc32_pclmul crct10dif_pclmul cryptd floppy
> >> >> gf128mul ghash_clmul ni_intel glue_helper hid hid_generic ib_addr
> >> >> ib_cm ib_core ib_iser ib_mad ib_sa input_leds irqbypass iscsi_tcp
> >> >> iw_cm joydev kvm kvm_intel libcrc32c libiscsi libiscsi_tcp linear lrw
> >> >> multipath parport parport_pc ppdev psmouse raid0 raid1 raid10 raid456
> >> >> raid6_pq rdma_cm scsi_transport_iscsi sctp serio_raw usbhid xor
> >> >
> >> >>
> >> >> #include <cstring>
> >> >> #include <ctime>
> >> >> #include <iomanip>
> >> >> #include <iostream>
> >> >>
> >> >> #include <errno.h>
> >> >> #include <unistd.h>
> >> >> #include <arpa/inet.h>
> >> >> #include <net/if.h>
> >> >> #include <netinet/in.h>
> >> >> #include <netinet/sctp.h>
> >> >> #include <sys/ioctl.h>
> >> >> #include <sys/socket.h>
> >> >>
> >> >> using namespace std;
> >> >>
> >> >> static const int ERROR_BUFLEN = 64;
> >> >> static const char* SCTP_INTERFACE_NAME = "ens4";
> >> >>
> >> >> static string data100 = "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789";
> >> >> static string data1000 = "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789"
> >> >>   "01234567890123456789012345678901234567890123456789";
> >> >>
> >> >> void printError(const string& msg, const string& funcName) {
> >> >>   char errorMessage[ERROR_BUFLEN] {};
> >> >>   char* errMsg = ::strerror_r(errno, errorMessage,
> >> >>                             sizeof(errorMessage));
> >> >>
> >> >>   cerr << "::" << funcName << ": " << msg << ": " << errMsg << endl;
> >> >> }
> >> >>
> >> >> int createSocket() {
> >> >>   int sockFd = socket (AF_INET,
> >> >>                      SOCK_SEQPACKET,
> >> >>                      IPPROTO_SCTP);
> >> >>   if (sockFd = -1) {
> >> >>     printError("Creation of socket failed", __FUNCTION__);
> >> >>     return -1;
> >> >>   }
> >> >>
> >> >>   // Enable address reuse
> >> >>   int enable = 1;
> >> >>   int err = setsockopt(sockFd,
> >> >>                      SOL_SOCKET,
> >> >>                      SO_REUSEADDR,
> >> >>                      &enable,
> >> >>                      sizeof(enable));
> >> >>
> >> >>   if (err) {
> >> >>     printError("Error setting socket option SO_REUSEADDR", __FUNCTION__);
> >> >>     close(sockFd);
> >> >>     return -1;
> >> >>   }
> >> >>
> >> >>   // Configure SCTP
> >> >>   sctp_initmsg initmsg{};
> >> >>   initmsg.sinit_num_ostreams = 3;
> >> >>   initmsg.sinit_max_instreams = 3;
> >> >>   initmsg.sinit_max_attempts = 2;
> >> >>   initmsg.sinit_max_init_timeo = 0;
> >> >>
> >> >>   err = setsockopt(sockFd,
> >> >>                  IPPROTO_SCTP,
> >> >>                  SCTP_INITMSG,
> >> >>                  &initmsg,
> >> >>                  sizeof(initmsg));
> >> >>
> >> >>   if (err) {
> >> >>     printError("Configuring SCTP socket failed", __FUNCTION__);
> >> >>     close(sockFd);
> >> >>     return -1;
> >> >>   }
> >> >>
> >> >>   struct sctp_paddrparams paddr_params{};
> >> >>   memset(&paddr_params, 0, sizeof(paddr_params));
> >> >>   socklen_t size_of_sctp_paddr_params = sizeof(paddr_params);
> >> >>   paddr_params.spp_flags = SPP_HB_ENABLE | SPP_PMTUD_ENABLE | SPP_SACKDELAY_ENABLE;
> >> >>
> >> >>   err = setsockopt(sockFd,
> >> >>                  IPPROTO_SCTP,
> >> >>                  SCTP_PEER_ADDR_PARAMS,
> >> >>                  &paddr_params,
> >> >>                  size_of_sctp_paddr_params);
> >> >>
> >> >>   if (err) {
> >> >>     printError("Configuring SCTP params failed", __FUNCTION__);
> >> >>     close(sockFd);
> >> >>     return -1;
> >> >>   }
> >> >>
> >> >>   return sockFd;
> >> >> }
> >> >>
> >> >> bool bindSocket(const int sockFd, const int localPort) {
> >> >>   // Get IP of ethernet interface
> >> >>   string localAddress = "";
> >> >>   ifreq ifr{};
> >> >>   ifr.ifr_addr.sa_family = AF_INET;
> >> >>   strncpy(ifr.ifr_name, SCTP_INTERFACE_NAME, IFNAMSIZ - 1);
> >> >>   const int ioctlStatus = ioctl(sockFd,
> >> >>                               SIOCGIFADDR,
> >> >>                               &ifr);
> >> >>
> >> >>   if (ioctlStatus = -1) {
> >> >>     printError("Failed to get local address", __FUNCTION__);
> >> >>     return false;
> >> >>   }
> >> >>
> >> >>   char ipAddrBuffer[INET_ADDRSTRLEN] {};
> >> >>   inet_ntop(AF_INET,
> >> >>           &reinterpret_cast<sockaddr_in*>(&(ifr.ifr_addr))->sin_addr,
> >> >>           ipAddrBuffer,
> >> >>           sizeof(ipAddrBuffer));
> >> >>
> >> >>   localAddress.assign(ipAddrBuffer);
> >> >>
> >> >>   // Bind to found ip address
> >> >>   sockaddr_in serv_addr{};
> >> >>   serv_addr.sin_family = AF_INET;
> >> >>   inet_pton(AF_INET,
> >> >>           localAddress.c_str(),
> >> >>           &serv_addr.sin_addr);
> >> >>   serv_addr.sin_port = htons(localPort);
> >> >>
> >> >>   if (bind(sockFd,
> >> >>          reinterpret_cast<sockaddr*>(&serv_addr),
> >> >>          sizeof(serv_addr))) {
> >> >>     printError("Failed to bind socket to local address", __FUNCTION__);
> >> >>     localAddress.clear();
> >> >>     close(sockFd);
> >> >>     return false;
> >> >>   }
> >> >>
> >> >>   cout << "Local endpoint succussfully bound to local address: " << localAddress << endl;
> >> >>
> >> >>   return true;
> >> >> }
> >> >>
> >> >> bool openAssociation(const int sockFd,
> >> >>                    const string &remoteAddress,
> >> >>                    std::uint16_t remotePort) {
> >> >>
> >> >>   sockaddr_in address{};
> >> >>   address.sin_family = AF_INET;
> >> >>   inet_pton(AF_INET, remoteAddress.c_str(), &address.sin_addr);
> >> >>   address.sin_port = htons(remotePort);
> >> >>
> >> >>   int connectError = connect(sockFd,
> >> >>                            reinterpret_cast<sockaddr *>(&address),
> >> >>                            sizeof(address));
> >> >>   if (connectError) {
> >> >>     printError("Error connecting association", __FUNCTION__);
> >> >>     return false;
> >> >>   }
> >> >>
> >> >>   cout << "Association connected to address: " << remoteAddress << ":" << remotePort << endl;
> >> >>   return true;
> >> >> }
> >> >>
> >> >> void sendReq(const int sockFd,
> >> >>            const string& remoteAddress,
> >> >>            const uint16_t remotePort,
> >> >>            const std::string& data)
> >> >> {
> >> >>
> >> >>   struct sockaddr_in remoteAddr {};
> >> >>   remoteAddr.sin_family = AF_INET;
> >> >>   remoteAddr.sin_port = htons(remotePort);
> >> >>
> >> >>   uint32_t payloadProtId = 7;
> >> >>   uint16_t streamId = 0;
> >> >>   uint32_t dataLength = data.size();
> >> >>   sockaddr* servaddr = reinterpret_cast<sockaddr*>(&remoteAddr);
> >> >>   inet_pton(AF_INET, remoteAddress.c_str(), &remoteAddr.sin_addr);
> >> >>
> >> >>   const std::string ipaddr > >> >>     inet_ntoa(reinterpret_cast<sockaddr_in*>(servaddr)->sin_addr);
> >> >>
> >> >>   cout << "Sending SCTP req to " << remoteAddress << ":" << remotePort;
> >> >>   cout << ", len=" << dataLength << endl;
> >> >>
> >> >>   const int bytesSent = sctp_sendmsg(sockFd,
> >> >>                                    data.c_str(),
> >> >>                                    (size_t)dataLength,
> >> >>                                    servaddr,
> >> >>                                    sizeof(sockaddr_in),
> >> >>                                    htonl(payloadProtId),
> >> >>                                    SCTP_ADDR_OVER,
> >> >>                                    streamId,
> >> >>                                    200,
> >> >>                                    0);
> >> >>
> >> >>   if (bytesSent = -1) {
> >> >>     printError("SCTP send failed", __FUNCTION__);
> >> >>   }
> >> >>
> >> >>   return;
> >> >> }
> >> >>
> >> >> sctp_assoc_t getSocketAssociationId(const int sockFd,
> >> >>                                   const string &remoteIpAddress,
> >> >>                                   std::uint16_t remotePort)
> >> >>
> >> >> {
> >> >>   sockaddr_in socket_address_in{};
> >> >>
> >> >>   socket_address_in.sin_family = AF_INET;
> >> >>   socket_address_in.sin_port = htons(remotePort);
> >> >>   inet_pton(AF_INET, remoteIpAddress.c_str(), &socket_address_in.sin_addr);
> >> >>
> >> >>   struct sockaddr *socket_address = reinterpret_cast<sockaddr*>(&socket_address_in);
> >> >>   socklen_t salen = sizeof(&socket_address);
> >> >>
> >> >>   struct sctp_paddrinfo peer_address_info{};
> >> >>   socklen_t size_of_sctp_paddrinfo = sizeof peer_address_info;
> >> >>   std::memcpy(&peer_address_info.spinfo_address, socket_address, salen);
> >> >>
> >> >>   const int sctpOptInfoError = sctp_opt_info(sockFd,
> >> >>                                            0,
> >> >>                                            SCTP_GET_PEER_ADDR_INFO,
> >> >>                                            &peer_address_info,
> >> >>                                            &size_of_sctp_paddrinfo);
> >> >>
> >> >>   if (sctpOptInfoError) {
> >> >>     printError("Failed to get association id", __FUNCTION__);
> >> >>   }
> >> >>
> >> >>   return peer_address_info.spinfo_assoc_id;
> >> >> }
> >> >>
> >> >> std::uint32_t getAssociationPathMtu(const int sockFd,
> >> >>                                   const string &remoteIpAddress,
> >> >>                                   const std::uint16_t remotePort) {
> >> >>   sockaddr_in socket_address_in{};
> >> >>
> >> >>   socket_address_in.sin_family = AF_INET;
> >> >>   socket_address_in.sin_port = htons(remotePort);
> >> >>   inet_pton(AF_INET, remoteIpAddress.c_str(), &socket_address_in.sin_addr);
> >> >>
> >> >>   struct sockaddr *socket_address = reinterpret_cast<sockaddr*>(&socket_address_in);
> >> >>   socklen_t salen = sizeof(&socket_address);
> >> >>
> >> >>   struct sctp_paddrinfo peer_address_info{};
> >> >>   socklen_t size_of_sctp_paddrinfo = sizeof(peer_address_info);
> >> >>   std::memcpy(&peer_address_info.spinfo_address, socket_address, salen);
> >> >>
> >> >>   sctp_assoc_t sctpAssociationId = getSocketAssociationId(sockFd, remoteIpAddress, remotePort);
> >> >>
> >> >>   const int sctpOptInfoError = sctp_opt_info(sockFd, sctpAssociationId,
> >> >>                                            SCTP_GET_PEER_ADDR_INFO,
> >> >>                                            &peer_address_info, &size_of_sctp_paddrinfo);
> >> >>   if (sctpOptInfoError) {
> >> >>     printError("Failed to get pmtu", __FUNCTION__);
> >> >>   }
> >> >>
> >> >>   auto t = std::time(nullptr);
> >> >>   auto tm = *std::localtime(&t);
> >> >>   std::cout << std::put_time(&tm, "%H:%M:%S ") << remoteIpAddress << ":" << remotePort;
> >> >>   cout << " currently has a PMTU of " << peer_address_info.spinfo_mtu << endl;
> >> >>
> >> >>   return peer_address_info.spinfo_mtu;
> >> >> }
> >> >>
> >> >> void test1(const string& data) {
> >> >>   int localPort = 2944;
> >> >>   string remoteIp1 = "10.0.0.3";
> >> >>   uint16_t remotePort1 = 8001;
> >> >>   uint16_t remotePort2 = 8002;
> >> >>
> >> >>   int sockFd = createSocket();
> >> >>   bindSocket(sockFd, localPort);
> >> >>
> >> >>   cout << "### Test 1: 2 assocs" << endl;
> >> >>
> >> >>   openAssociation(sockFd, remoteIp1, remotePort1);
> >> >>   openAssociation(sockFd, remoteIp1, remotePort2);
> >> >>
> >> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
> >> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
> >> >>
> >> >>   sendReq(sockFd, remoteIp1, remotePort1, data);
> >> >>   for (int i = 0; i < 10; i++) {
> >> >>     sleep(10);
> >> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
> >> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
> >> >>   }
> >> >> }
> >> >>
> >> >> void test2(const string& data) {
> >> >>   int localPort = 2944;
> >> >>   string remoteIp1 = "10.0.0.3";
> >> >>   uint16_t remotePort1 = 8001;
> >> >>   uint16_t remotePort2 = 8002;
> >> >>   string remoteIpFake = "10.52.96.204";
> >> >>   uint16_t remotePortFake = 3239;
> >> >>
> >> >>   int sockFd = createSocket();
> >> >>   bindSocket(sockFd, localPort);
> >> >>
> >> >>   cout << "### Test 2: 2 assocs + 1 unreachable assoc" << endl;
> >> >>
> >> >>   openAssociation(sockFd, remoteIp1, remotePort1);
> >> >>   openAssociation(sockFd, remoteIp1, remotePort2);
> >> >>   openAssociation(sockFd, remoteIpFake, remotePortFake);
> >> >>
> >> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
> >> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
> >> >>
> >> >>   sendReq(sockFd, remoteIp1, remotePort1, data);
> >> >>   for (int i = 0; i < 10; i++) {
> >> >>     sleep(10);
> >> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
> >> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
> >> >>   }
> >> >> }
> >> >>
> >> >>
> >> >> int main(int argc, char** argv) {
> >> >>   string testNr = "1";
> >> >>   string& testData = data1000;
> >> >>   if (argc >= 2) {
> >> >>     testNr = argv[1];
> >> >>   }
> >> >>   if (argc >= 3) {
> >> >>     testData = data100;
> >> >>   }
> >> >>
> >> >>   if (testNr = "1") {
> >> >>     test1(testData);
> >> >>   } else {
> >> >>     test2(testData);
> >> >>   }
> >> >>
> >> >>   return 0;
> >> >> }
> >> >
> >
> >


