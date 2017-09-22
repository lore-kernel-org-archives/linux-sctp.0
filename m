From: Peter Salin <peter.salin@gmail.com>
Date: Fri, 22 Sep 2017 09:05:30 +0000
Subject: Re: PMTU discovery behaviour
Message-Id: <CAH9vUQt455m4g775gn=MJQcU=y=ctwrX5t=MNWfd=X86E_rYAQ@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="001a113ece7ecb2b1e0559c38247"
List-Id: <linux-sctp.vger.kernel.org>
References: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
In-Reply-To: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
To: linux-sctp@vger.kernel.org

--001a113ece7ecb2b1e0559c38247
Content-Type: text/plain; charset="UTF-8"

2017-09-21 18:24 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
> On Thu, Sep 21, 2017 at 03:41:51PM +0300, Peter Salin wrote:
>> 2017-09-21 14:01 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
>> > On Wed, Sep 20, 2017 at 02:02:45PM +0300, Peter Salin wrote:
>> >> 2017-09-19 20:09 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
>> >> > On Mon, Sep 11, 2017 at 03:44:57PM +0300, Peter Salin wrote:
>> >> >> Hi,
>> >> >>
>> >> >> I encountered some strange PMTUD related behaviour that I need help in
>> >> >> understanding.
>> >> >>
>> >> >> Setup:
>> >> >>
>> >> >> +-----------+        +---+        +--------+
>> >> >> | 10.0.0.10 |--------| X |--------|10.0.0.3|
>> >> >> +-----------+        +---+        +--------+
>> >> >>
>> >> >> A one to many socket is setup at 10.0.0.10. Two instances of the
>> >> >> lksctp sctp_darn applications are ran at 10.0.0.3 listening to ports
>> >> >> 8001 and 8002. 10.0.0.3 was also setup to generate ICMP frag needed
>> >> >> messages for incoming messages over 600 bytes. This same issue also
>> >> >> occurs also when a router on the path was setup to generate the ICMP
>> >> >> message instead.
>> >> >>
>> >> >> Test 1:
>> >> >> Two associations were connected from 10.0.0.10 to 10.0.0.3, one to
>> >> >> port 8001 and another one to 8002. Then a too large message was sent
>> >> >> on the association to 8001, triggering ICMP generation. When checking
>> >> >> the MTU reported in spinfo_mtu field of SCTP_GET_PEER_ADDR_INFO, the
>> >> >> association now reports 600. The association to 8002 reports 1500
>> >> >> until traffic is sent on it, at which point it also adjusts to 600
>> >> >> which I think makes sense since the destination IP is the same. When
>> >> >> reopening the associations, the value of 600 would be remembered for
>> >> >> about 10 min, which I also think makes sense since
>> >> >> net.ipv4.route.mtu_expires is 600.
>> >> >>
>> >> >> Test 2:
>> >> >> Again the same two associations were connected to 10.0.0.3, but in
>> >> >> addition an attempt to connect a third association to a non-existing
>> >> >> IP was done, this attempt fails with timeout after a while. After
>> >> >> that, again an ICMP triggering large message was sent to 8001. Now the
>> >> >> behaviour is different from before. The association to 8001 reports a
>> >> >> spinfo_mtu of 600, but only for a brief moment, it does not stay at
>> >> >> 600 for 10 minutes. In addition the spinfo_mtu of the association to
>> >> >> 8002 never changes, it stays at the original 1500.
>> >> >>
>> >> >> The only difference between the two tests is the attempt to connect to
>> >> >> a non-responding IP at the beginning of test 2. Any ideas why the
>> >> >> behaviour changes, is this a bug or is there some other reason for
>> >> >> this?
>> >> >>
>> >> >> I have attached the sample application used for reproducing this.
>> >> >>
>> >> >> BR,
>> >> >> -Peter
>> >> >>
>> >> > Hey, apologies for the delay on this, I've had it in my reader for days and kept
>> >> > meaning to respond, but kept getting sidetracked.
>> >> >
>> >> > First glance, this sounds incorrect.  Each association (or rather each
>> >> > transport) maintains its own mtu, and the association reflects the mtu of the
>> >> > active transport. Given that each transport holds its own dst cache entry, I
>> >> > have a hard time seeing how one transports mtu changes might leak to another
>> >> >
>> >> > But thats not really whats happening here.  By your description, the active
>> >> > transport on the established association isn't updating its pathmtu, which
>> >> > should happen in response to receiving the ICMP_FRAG_NEEDED message.
>> >> >
>> >> > I know you've provided the reproducer bellow, and I appreciate that, but I don't
>> >> > have the cycles to set this up at the moment.  Could you tell me if, during the
>> >> > second test, after you attempt to connect to the fake ip address and then send
>> >> > the large message that should trigger the frag needed message, does said large
>> >> > message get retransmitted and eventually arrive at the peer host?  If so, that
>> >> > suggests that the sctp stack:
>> >> >
>> >> > a) receives the frag needed message
>> >> > and
>> >> > b) resends the packet at the lower frag point
>> >> >
>> >> > That in turn suggests we just have some internal reporting error in which we
>> >> > don't update the associations pmtu with the active transports
>> >> >
>> >> > Let me know the answer to that question and it will give me some places to start
>> >> > looking
>> >> > Neil
>> >> >
>> >> Thanks for responding. In response to your question, the first large
>> >> message does get retransmitted without the Don't Fragment bit set. I
>> >> modified the test a bit to also send further messages after the first
>> >> one. Those messages are indeed fragmented according to the limit of
>> >> the ICMP message. I have attached a PCAP trace and SCTP debug logs in
>> >> case that helps here.
>> >>
>> >> I also tried sending a large message on the other association after
>> >> the large message on the first association had been sent. For test 2
>> >> that message was not fragmented even though the ICMP was already
>> >> received for the first assoc. After the second assoc also received an
>> >> ICMP it adjusted to use the lower MTU for subsequent messages. In the
>> >> case of test 1, sending a large message on the second assoc would auto
>> >> fragment already on the first message.
>> >>
>> >> Also, after stopping and rerunning test 2 the MTU would always be
>> >> reset at 1500, whereas in test 1 the lower limit would still be in
>> >> effect for a new run. So it seems like in test 2 the lower MTU is only
>> >> known within each association, where as in test 1 the lower MTU also
>> >> gets stored deeper down?
>> >>
>> >> BR,
>> >> -Peter
>> >>
>> > So, from what I can see, your included tcpdump only shows the first part of what
>> > you are describing.  That is to say that it sends a large data chunk on an
>> > association that gets an ICMP frag needed response, after which the pmtu is
>> > lowered and smaller message fragments are sent, which is good (i.e. working as
>> > designed).
>> >
>> > I don't see anything in the tcpdump relating to the remainder of your test,
>> > showing failed fragmentation.  Can you include that please?
>> >
>> > Neil
>> Yes, please find attached traces that include sending on the other
>> association after receiving the first ICMP.
>>
>
>
> Thank you.  So tell me if I'm missing something here, but I think this trace
> contradicts what you describe above.  Some specifics:
>
> 1) I observe two assocations in this trace:
>         a) An association with index 0, who's init chunk is in frame 1
>         b) An association with index 1, whos init chunk is in frame 5
>         Note that I can toggle between these association flows with the display
> filter of:
>         sctp.assoc_index == 1
>         or
>         sctp.assoc_index == 0
>         in wireshark
>
>
> 2) In both flows, I can observe that a large chunk is sent:
>         a) in assoc index 0, the over-mtu chunk is in frame 9
>         b) in assoc index 1, the over-mtu chunk is in frame 16
>
> 3) Subsequent to each data chunk in (2), we get an icmp unreach (frag needed
> message)
>         a) in assoc index 0, the icmp is in frame 10
>         b) in assoc index 1, the icmp is in frame 17
>
> 4) Subsequent to (3), all DATA chunks appear to get limited to an appropriate
> size for the path mtu as specified in the respective icmp from (3), and
> oversized datagrams are appropriately fragmented.
>
>
> Please let me know if I'm missing something, but this trace shows everything to
> be working as normal.
>
> Neil

I would have expected the second ICMP to not be needed as I thought
both assocs are on the same transport.

I have now attached traces for both tests so that you can compare them
side-by-side and see what I am after here. I have run each test twice
in the traces to be able to show the two key differences here:

1) In test 1, the first large message sent on the second assoc (frame
22) is already limited correctly in size and no second ICMP is needed
like in test 2.

(Here test 1 behaviour looked ok to me since I thought both assocs are
on the same transport and therefore the MTU would be synced to both
assocs. There seems to be some locally sent ICMP message in frame 16,
perhaps this has to do with the syncing?)

2) When rerunning test 1, the previously found out MTU value is
remembered and no new ICMPs are needed (frame 52). This is not the
case for test 2.

(Again here test 1 made sense to me since I thougth the MTU would be
cached and only forgotten after 10 minutes
(net.ipv4.route.mtu_expires).

Please note that in the test application the only difference between
test 1 and test 2 is the attempt to connect a third assoc to a
non-responding IP in test 2. Yet the behaviour of the stack is very
different between the two tests.

I am new to SCTP, but to me the behaviour shown in test 1 looked more
like what I would have expected. In any case I don't understand why
the behaviour is so different between these two cases, so I hope we
can find some explanation for that.

BR,
-Peter
>
>> BR,
>> -Peter
>> >
>> >> >> ------ ver_linux output ------
>> >> >> Linux esalipe-test 4.4.0-93-generic #116-Ubuntu SMP Fri Aug 11
>> >> >> 21:17:51 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>> >> >>
>> >> >> GNU C                   5.4.0
>> >> >> GNU Make                4.1
>> >> >> Binutils                2.26.1
>> >> >> Util-linux              2.27.1
>> >> >> Mount                   2.27.1
>> >> >> Module-init-tools       22
>> >> >> E2fsprogs               1.42.13
>> >> >> Xfsprogs                4.3.0
>> >> >> Linux C Library         2.23
>> >> >> Dynamic linker (ldd)    2.23
>> >> >> Linux C++ Library       6.0.21
>> >> >> Procps                  3.3.10
>> >> >> Net-tools               1.60
>> >> >> Kbd                     1.15.5
>> >> >> Console-tools           1.15.5
>> >> >> Sh-utils                8.25
>> >> >> Udev                    229
>> >> >> Modules Loaded          ablk_helper aes_x86_64 aesni_intel
>> >> >> async_memcpy async_pq async_raid6_recov async_tx async_xor autofs4
>> >> >> binfmt_misc btrfs  crc32_pclmul crct10dif_pclmul cryptd floppy
>> >> >> gf128mul ghash_clmul ni_intel glue_helper hid hid_generic ib_addr
>> >> >> ib_cm ib_core ib_iser ib_mad ib_sa input_leds irqbypass iscsi_tcp
>> >> >> iw_cm joydev kvm kvm_intel libcrc32c libiscsi libiscsi_tcp linear lrw
>> >> >> multipath parport parport_pc ppdev psmouse raid0 raid1 raid10 raid456
>> >> >> raid6_pq rdma_cm scsi_transport_iscsi sctp serio_raw usbhid xor
>> >> >
>> >> >>
>> >> >> #include <cstring>
>> >> >> #include <ctime>
>> >> >> #include <iomanip>
>> >> >> #include <iostream>
>> >> >>
>> >> >> #include <errno.h>
>> >> >> #include <unistd.h>
>> >> >> #include <arpa/inet.h>
>> >> >> #include <net/if.h>
>> >> >> #include <netinet/in.h>
>> >> >> #include <netinet/sctp.h>
>> >> >> #include <sys/ioctl.h>
>> >> >> #include <sys/socket.h>
>> >> >>
>> >> >> using namespace std;
>> >> >>
>> >> >> static const int ERROR_BUFLEN = 64;
>> >> >> static const char* SCTP_INTERFACE_NAME = "ens4";
>> >> >>
>> >> >> static string data100 = "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789";
>> >> >> static string data1000 = "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789"
>> >> >>   "01234567890123456789012345678901234567890123456789";
>> >> >>
>> >> >> void printError(const string& msg, const string& funcName) {
>> >> >>   char errorMessage[ERROR_BUFLEN] {};
>> >> >>   char* errMsg = ::strerror_r(errno, errorMessage,
>> >> >>                             sizeof(errorMessage));
>> >> >>
>> >> >>   cerr << "::" << funcName << ": " << msg << ": " << errMsg << endl;
>> >> >> }
>> >> >>
>> >> >> int createSocket() {
>> >> >>   int sockFd = socket (AF_INET,
>> >> >>                      SOCK_SEQPACKET,
>> >> >>                      IPPROTO_SCTP);
>> >> >>   if (sockFd == -1) {
>> >> >>     printError("Creation of socket failed", __FUNCTION__);
>> >> >>     return -1;
>> >> >>   }
>> >> >>
>> >> >>   // Enable address reuse
>> >> >>   int enable = 1;
>> >> >>   int err = setsockopt(sockFd,
>> >> >>                      SOL_SOCKET,
>> >> >>                      SO_REUSEADDR,
>> >> >>                      &enable,
>> >> >>                      sizeof(enable));
>> >> >>
>> >> >>   if (err) {
>> >> >>     printError("Error setting socket option SO_REUSEADDR", __FUNCTION__);
>> >> >>     close(sockFd);
>> >> >>     return -1;
>> >> >>   }
>> >> >>
>> >> >>   // Configure SCTP
>> >> >>   sctp_initmsg initmsg{};
>> >> >>   initmsg.sinit_num_ostreams = 3;
>> >> >>   initmsg.sinit_max_instreams = 3;
>> >> >>   initmsg.sinit_max_attempts = 2;
>> >> >>   initmsg.sinit_max_init_timeo = 0;
>> >> >>
>> >> >>   err = setsockopt(sockFd,
>> >> >>                  IPPROTO_SCTP,
>> >> >>                  SCTP_INITMSG,
>> >> >>                  &initmsg,
>> >> >>                  sizeof(initmsg));
>> >> >>
>> >> >>   if (err) {
>> >> >>     printError("Configuring SCTP socket failed", __FUNCTION__);
>> >> >>     close(sockFd);
>> >> >>     return -1;
>> >> >>   }
>> >> >>
>> >> >>   struct sctp_paddrparams paddr_params{};
>> >> >>   memset(&paddr_params, 0, sizeof(paddr_params));
>> >> >>   socklen_t size_of_sctp_paddr_params = sizeof(paddr_params);
>> >> >>   paddr_params.spp_flags = SPP_HB_ENABLE | SPP_PMTUD_ENABLE | SPP_SACKDELAY_ENABLE;
>> >> >>
>> >> >>   err = setsockopt(sockFd,
>> >> >>                  IPPROTO_SCTP,
>> >> >>                  SCTP_PEER_ADDR_PARAMS,
>> >> >>                  &paddr_params,
>> >> >>                  size_of_sctp_paddr_params);
>> >> >>
>> >> >>   if (err) {
>> >> >>     printError("Configuring SCTP params failed", __FUNCTION__);
>> >> >>     close(sockFd);
>> >> >>     return -1;
>> >> >>   }
>> >> >>
>> >> >>   return sockFd;
>> >> >> }
>> >> >>
>> >> >> bool bindSocket(const int sockFd, const int localPort) {
>> >> >>   // Get IP of ethernet interface
>> >> >>   string localAddress = "";
>> >> >>   ifreq ifr{};
>> >> >>   ifr.ifr_addr.sa_family = AF_INET;
>> >> >>   strncpy(ifr.ifr_name, SCTP_INTERFACE_NAME, IFNAMSIZ - 1);
>> >> >>   const int ioctlStatus = ioctl(sockFd,
>> >> >>                               SIOCGIFADDR,
>> >> >>                               &ifr);
>> >> >>
>> >> >>   if (ioctlStatus == -1) {
>> >> >>     printError("Failed to get local address", __FUNCTION__);
>> >> >>     return false;
>> >> >>   }
>> >> >>
>> >> >>   char ipAddrBuffer[INET_ADDRSTRLEN] {};
>> >> >>   inet_ntop(AF_INET,
>> >> >>           &reinterpret_cast<sockaddr_in*>(&(ifr.ifr_addr))->sin_addr,
>> >> >>           ipAddrBuffer,
>> >> >>           sizeof(ipAddrBuffer));
>> >> >>
>> >> >>   localAddress.assign(ipAddrBuffer);
>> >> >>
>> >> >>   // Bind to found ip address
>> >> >>   sockaddr_in serv_addr{};
>> >> >>   serv_addr.sin_family = AF_INET;
>> >> >>   inet_pton(AF_INET,
>> >> >>           localAddress.c_str(),
>> >> >>           &serv_addr.sin_addr);
>> >> >>   serv_addr.sin_port = htons(localPort);
>> >> >>
>> >> >>   if (bind(sockFd,
>> >> >>          reinterpret_cast<sockaddr*>(&serv_addr),
>> >> >>          sizeof(serv_addr))) {
>> >> >>     printError("Failed to bind socket to local address", __FUNCTION__);
>> >> >>     localAddress.clear();
>> >> >>     close(sockFd);
>> >> >>     return false;
>> >> >>   }
>> >> >>
>> >> >>   cout << "Local endpoint succussfully bound to local address: " << localAddress << endl;
>> >> >>
>> >> >>   return true;
>> >> >> }
>> >> >>
>> >> >> bool openAssociation(const int sockFd,
>> >> >>                    const string &remoteAddress,
>> >> >>                    std::uint16_t remotePort) {
>> >> >>
>> >> >>   sockaddr_in address{};
>> >> >>   address.sin_family = AF_INET;
>> >> >>   inet_pton(AF_INET, remoteAddress.c_str(), &address.sin_addr);
>> >> >>   address.sin_port = htons(remotePort);
>> >> >>
>> >> >>   int connectError = connect(sockFd,
>> >> >>                            reinterpret_cast<sockaddr *>(&address),
>> >> >>                            sizeof(address));
>> >> >>   if (connectError) {
>> >> >>     printError("Error connecting association", __FUNCTION__);
>> >> >>     return false;
>> >> >>   }
>> >> >>
>> >> >>   cout << "Association connected to address: " << remoteAddress << ":" << remotePort << endl;
>> >> >>   return true;
>> >> >> }
>> >> >>
>> >> >> void sendReq(const int sockFd,
>> >> >>            const string& remoteAddress,
>> >> >>            const uint16_t remotePort,
>> >> >>            const std::string& data)
>> >> >> {
>> >> >>
>> >> >>   struct sockaddr_in remoteAddr {};
>> >> >>   remoteAddr.sin_family = AF_INET;
>> >> >>   remoteAddr.sin_port = htons(remotePort);
>> >> >>
>> >> >>   uint32_t payloadProtId = 7;
>> >> >>   uint16_t streamId = 0;
>> >> >>   uint32_t dataLength = data.size();
>> >> >>   sockaddr* servaddr = reinterpret_cast<sockaddr*>(&remoteAddr);
>> >> >>   inet_pton(AF_INET, remoteAddress.c_str(), &remoteAddr.sin_addr);
>> >> >>
>> >> >>   const std::string ipaddr =
>> >> >>     inet_ntoa(reinterpret_cast<sockaddr_in*>(servaddr)->sin_addr);
>> >> >>
>> >> >>   cout << "Sending SCTP req to " << remoteAddress << ":" << remotePort;
>> >> >>   cout << ", len=" << dataLength << endl;
>> >> >>
>> >> >>   const int bytesSent = sctp_sendmsg(sockFd,
>> >> >>                                    data.c_str(),
>> >> >>                                    (size_t)dataLength,
>> >> >>                                    servaddr,
>> >> >>                                    sizeof(sockaddr_in),
>> >> >>                                    htonl(payloadProtId),
>> >> >>                                    SCTP_ADDR_OVER,
>> >> >>                                    streamId,
>> >> >>                                    200,
>> >> >>                                    0);
>> >> >>
>> >> >>   if (bytesSent == -1) {
>> >> >>     printError("SCTP send failed", __FUNCTION__);
>> >> >>   }
>> >> >>
>> >> >>   return;
>> >> >> }
>> >> >>
>> >> >> sctp_assoc_t getSocketAssociationId(const int sockFd,
>> >> >>                                   const string &remoteIpAddress,
>> >> >>                                   std::uint16_t remotePort)
>> >> >>
>> >> >> {
>> >> >>   sockaddr_in socket_address_in{};
>> >> >>
>> >> >>   socket_address_in.sin_family = AF_INET;
>> >> >>   socket_address_in.sin_port = htons(remotePort);
>> >> >>   inet_pton(AF_INET, remoteIpAddress.c_str(), &socket_address_in.sin_addr);
>> >> >>
>> >> >>   struct sockaddr *socket_address = reinterpret_cast<sockaddr*>(&socket_address_in);
>> >> >>   socklen_t salen = sizeof(&socket_address);
>> >> >>
>> >> >>   struct sctp_paddrinfo peer_address_info{};
>> >> >>   socklen_t size_of_sctp_paddrinfo = sizeof peer_address_info;
>> >> >>   std::memcpy(&peer_address_info.spinfo_address, socket_address, salen);
>> >> >>
>> >> >>   const int sctpOptInfoError = sctp_opt_info(sockFd,
>> >> >>                                            0,
>> >> >>                                            SCTP_GET_PEER_ADDR_INFO,
>> >> >>                                            &peer_address_info,
>> >> >>                                            &size_of_sctp_paddrinfo);
>> >> >>
>> >> >>   if (sctpOptInfoError) {
>> >> >>     printError("Failed to get association id", __FUNCTION__);
>> >> >>   }
>> >> >>
>> >> >>   return peer_address_info.spinfo_assoc_id;
>> >> >> }
>> >> >>
>> >> >> std::uint32_t getAssociationPathMtu(const int sockFd,
>> >> >>                                   const string &remoteIpAddress,
>> >> >>                                   const std::uint16_t remotePort) {
>> >> >>   sockaddr_in socket_address_in{};
>> >> >>
>> >> >>   socket_address_in.sin_family = AF_INET;
>> >> >>   socket_address_in.sin_port = htons(remotePort);
>> >> >>   inet_pton(AF_INET, remoteIpAddress.c_str(), &socket_address_in.sin_addr);
>> >> >>
>> >> >>   struct sockaddr *socket_address = reinterpret_cast<sockaddr*>(&socket_address_in);
>> >> >>   socklen_t salen = sizeof(&socket_address);
>> >> >>
>> >> >>   struct sctp_paddrinfo peer_address_info{};
>> >> >>   socklen_t size_of_sctp_paddrinfo = sizeof(peer_address_info);
>> >> >>   std::memcpy(&peer_address_info.spinfo_address, socket_address, salen);
>> >> >>
>> >> >>   sctp_assoc_t sctpAssociationId = getSocketAssociationId(sockFd, remoteIpAddress, remotePort);
>> >> >>
>> >> >>   const int sctpOptInfoError = sctp_opt_info(sockFd, sctpAssociationId,
>> >> >>                                            SCTP_GET_PEER_ADDR_INFO,
>> >> >>                                            &peer_address_info, &size_of_sctp_paddrinfo);
>> >> >>   if (sctpOptInfoError) {
>> >> >>     printError("Failed to get pmtu", __FUNCTION__);
>> >> >>   }
>> >> >>
>> >> >>   auto t = std::time(nullptr);
>> >> >>   auto tm = *std::localtime(&t);
>> >> >>   std::cout << std::put_time(&tm, "%H:%M:%S ") << remoteIpAddress << ":" << remotePort;
>> >> >>   cout << " currently has a PMTU of " << peer_address_info.spinfo_mtu << endl;
>> >> >>
>> >> >>   return peer_address_info.spinfo_mtu;
>> >> >> }
>> >> >>
>> >> >> void test1(const string& data) {
>> >> >>   int localPort = 2944;
>> >> >>   string remoteIp1 = "10.0.0.3";
>> >> >>   uint16_t remotePort1 = 8001;
>> >> >>   uint16_t remotePort2 = 8002;
>> >> >>
>> >> >>   int sockFd = createSocket();
>> >> >>   bindSocket(sockFd, localPort);
>> >> >>
>> >> >>   cout << "### Test 1: 2 assocs" << endl;
>> >> >>
>> >> >>   openAssociation(sockFd, remoteIp1, remotePort1);
>> >> >>   openAssociation(sockFd, remoteIp1, remotePort2);
>> >> >>
>> >> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>> >> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>> >> >>
>> >> >>   sendReq(sockFd, remoteIp1, remotePort1, data);
>> >> >>   for (int i = 0; i < 10; i++) {
>> >> >>     sleep(10);
>> >> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>> >> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>> >> >>   }
>> >> >> }
>> >> >>
>> >> >> void test2(const string& data) {
>> >> >>   int localPort = 2944;
>> >> >>   string remoteIp1 = "10.0.0.3";
>> >> >>   uint16_t remotePort1 = 8001;
>> >> >>   uint16_t remotePort2 = 8002;
>> >> >>   string remoteIpFake = "10.52.96.204";
>> >> >>   uint16_t remotePortFake = 3239;
>> >> >>
>> >> >>   int sockFd = createSocket();
>> >> >>   bindSocket(sockFd, localPort);
>> >> >>
>> >> >>   cout << "### Test 2: 2 assocs + 1 unreachable assoc" << endl;
>> >> >>
>> >> >>   openAssociation(sockFd, remoteIp1, remotePort1);
>> >> >>   openAssociation(sockFd, remoteIp1, remotePort2);
>> >> >>   openAssociation(sockFd, remoteIpFake, remotePortFake);
>> >> >>
>> >> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>> >> >>   getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>> >> >>
>> >> >>   sendReq(sockFd, remoteIp1, remotePort1, data);
>> >> >>   for (int i = 0; i < 10; i++) {
>> >> >>     sleep(10);
>> >> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>> >> >>     getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>> >> >>   }
>> >> >> }
>> >> >>
>> >> >>
>> >> >> int main(int argc, char** argv) {
>> >> >>   string testNr = "1";
>> >> >>   string& testData = data1000;
>> >> >>   if (argc >= 2) {
>> >> >>     testNr = argv[1];
>> >> >>   }
>> >> >>   if (argc >= 3) {
>> >> >>     testData = data100;
>> >> >>   }
>> >> >>
>> >> >>   if (testNr == "1") {
>> >> >>     test1(testData);
>> >> >>   } else {
>> >> >>     test2(testData);
>> >> >>   }
>> >> >>
>> >> >>   return 0;
>> >> >> }
>> >> >
>> >
>> >
>
>

--001a113ece7ecb2b1e0559c38247
Content-Type: application/x-gzip; name="test_traces.tar.gz"
Content-Disposition: attachment; filename="test_traces.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j7vnq21w0

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
BQA=
--001a113ece7ecb2b1e0559c38247--
