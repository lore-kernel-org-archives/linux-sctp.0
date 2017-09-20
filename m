From: Peter Salin <peter.salin@gmail.com>
Date: Wed, 20 Sep 2017 11:02:45 +0000
Subject: Re: PMTU discovery behaviour
Message-Id: <CAH9vUQsxReaWkc-_NnKQ=0zObvd1fHxAaBsEyEjneggSMCu8Tg@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="001a1144993a67b52505599cea40"
List-Id: <linux-sctp.vger.kernel.org>
References: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
In-Reply-To: <CAH9vUQuf9u=isRf5r4e-Eh+qtP=G170=a-kmCLCLFYBFJGcJKQ@mail.gmail.com>
To: linux-sctp@vger.kernel.org

--001a1144993a67b52505599cea40
Content-Type: text/plain; charset="UTF-8"

2017-09-19 20:09 GMT+03:00 Neil Horman <nhorman@tuxdriver.com>:
> On Mon, Sep 11, 2017 at 03:44:57PM +0300, Peter Salin wrote:
>> Hi,
>>
>> I encountered some strange PMTUD related behaviour that I need help in
>> understanding.
>>
>> Setup:
>>
>> +-----------+        +---+        +--------+
>> | 10.0.0.10 |--------| X |--------|10.0.0.3|
>> +-----------+        +---+        +--------+
>>
>> A one to many socket is setup at 10.0.0.10. Two instances of the
>> lksctp sctp_darn applications are ran at 10.0.0.3 listening to ports
>> 8001 and 8002. 10.0.0.3 was also setup to generate ICMP frag needed
>> messages for incoming messages over 600 bytes. This same issue also
>> occurs also when a router on the path was setup to generate the ICMP
>> message instead.
>>
>> Test 1:
>> Two associations were connected from 10.0.0.10 to 10.0.0.3, one to
>> port 8001 and another one to 8002. Then a too large message was sent
>> on the association to 8001, triggering ICMP generation. When checking
>> the MTU reported in spinfo_mtu field of SCTP_GET_PEER_ADDR_INFO, the
>> association now reports 600. The association to 8002 reports 1500
>> until traffic is sent on it, at which point it also adjusts to 600
>> which I think makes sense since the destination IP is the same. When
>> reopening the associations, the value of 600 would be remembered for
>> about 10 min, which I also think makes sense since
>> net.ipv4.route.mtu_expires is 600.
>>
>> Test 2:
>> Again the same two associations were connected to 10.0.0.3, but in
>> addition an attempt to connect a third association to a non-existing
>> IP was done, this attempt fails with timeout after a while. After
>> that, again an ICMP triggering large message was sent to 8001. Now the
>> behaviour is different from before. The association to 8001 reports a
>> spinfo_mtu of 600, but only for a brief moment, it does not stay at
>> 600 for 10 minutes. In addition the spinfo_mtu of the association to
>> 8002 never changes, it stays at the original 1500.
>>
>> The only difference between the two tests is the attempt to connect to
>> a non-responding IP at the beginning of test 2. Any ideas why the
>> behaviour changes, is this a bug or is there some other reason for
>> this?
>>
>> I have attached the sample application used for reproducing this.
>>
>> BR,
>> -Peter
>>
> Hey, apologies for the delay on this, I've had it in my reader for days and kept
> meaning to respond, but kept getting sidetracked.
>
> First glance, this sounds incorrect.  Each association (or rather each
> transport) maintains its own mtu, and the association reflects the mtu of the
> active transport. Given that each transport holds its own dst cache entry, I
> have a hard time seeing how one transports mtu changes might leak to another
>
> But thats not really whats happening here.  By your description, the active
> transport on the established association isn't updating its pathmtu, which
> should happen in response to receiving the ICMP_FRAG_NEEDED message.
>
> I know you've provided the reproducer bellow, and I appreciate that, but I don't
> have the cycles to set this up at the moment.  Could you tell me if, during the
> second test, after you attempt to connect to the fake ip address and then send
> the large message that should trigger the frag needed message, does said large
> message get retransmitted and eventually arrive at the peer host?  If so, that
> suggests that the sctp stack:
>
> a) receives the frag needed message
> and
> b) resends the packet at the lower frag point
>
> That in turn suggests we just have some internal reporting error in which we
> don't update the associations pmtu with the active transports
>
> Let me know the answer to that question and it will give me some places to start
> looking
> Neil
>
Thanks for responding. In response to your question, the first large
message does get retransmitted without the Don't Fragment bit set. I
modified the test a bit to also send further messages after the first
one. Those messages are indeed fragmented according to the limit of
the ICMP message. I have attached a PCAP trace and SCTP debug logs in
case that helps here.

I also tried sending a large message on the other association after
the large message on the first association had been sent. For test 2
that message was not fragmented even though the ICMP was already
received for the first assoc. After the second assoc also received an
ICMP it adjusted to use the lower MTU for subsequent messages. In the
case of test 1, sending a large message on the second assoc would auto
fragment already on the first message.

Also, after stopping and rerunning test 2 the MTU would always be
reset at 1500, whereas in test 1 the lower limit would still be in
effect for a new run. So it seems like in test 2 the lower MTU is only
known within each association, where as in test 1 the lower MTU also
gets stored deeper down?

BR,
-Peter

>> ------ ver_linux output ------
>> Linux esalipe-test 4.4.0-93-generic #116-Ubuntu SMP Fri Aug 11
>> 21:17:51 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>>
>> GNU C                   5.4.0
>> GNU Make                4.1
>> Binutils                2.26.1
>> Util-linux              2.27.1
>> Mount                   2.27.1
>> Module-init-tools       22
>> E2fsprogs               1.42.13
>> Xfsprogs                4.3.0
>> Linux C Library         2.23
>> Dynamic linker (ldd)    2.23
>> Linux C++ Library       6.0.21
>> Procps                  3.3.10
>> Net-tools               1.60
>> Kbd                     1.15.5
>> Console-tools           1.15.5
>> Sh-utils                8.25
>> Udev                    229
>> Modules Loaded          ablk_helper aes_x86_64 aesni_intel
>> async_memcpy async_pq async_raid6_recov async_tx async_xor autofs4
>> binfmt_misc btrfs  crc32_pclmul crct10dif_pclmul cryptd floppy
>> gf128mul ghash_clmul ni_intel glue_helper hid hid_generic ib_addr
>> ib_cm ib_core ib_iser ib_mad ib_sa input_leds irqbypass iscsi_tcp
>> iw_cm joydev kvm kvm_intel libcrc32c libiscsi libiscsi_tcp linear lrw
>> multipath parport parport_pc ppdev psmouse raid0 raid1 raid10 raid456
>> raid6_pq rdma_cm scsi_transport_iscsi sctp serio_raw usbhid xor
>
>>
>> #include <cstring>
>> #include <ctime>
>> #include <iomanip>
>> #include <iostream>
>>
>> #include <errno.h>
>> #include <unistd.h>
>> #include <arpa/inet.h>
>> #include <net/if.h>
>> #include <netinet/in.h>
>> #include <netinet/sctp.h>
>> #include <sys/ioctl.h>
>> #include <sys/socket.h>
>>
>> using namespace std;
>>
>> static const int ERROR_BUFLEN = 64;
>> static const char* SCTP_INTERFACE_NAME = "ens4";
>>
>> static string data100 = "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789";
>> static string data1000 = "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789"
>>   "01234567890123456789012345678901234567890123456789";
>>
>> void printError(const string& msg, const string& funcName) {
>>   char errorMessage[ERROR_BUFLEN] {};
>>   char* errMsg = ::strerror_r(errno, errorMessage,
>>                             sizeof(errorMessage));
>>
>>   cerr << "::" << funcName << ": " << msg << ": " << errMsg << endl;
>> }
>>
>> int createSocket() {
>>   int sockFd = socket (AF_INET,
>>                      SOCK_SEQPACKET,
>>                      IPPROTO_SCTP);
>>   if (sockFd == -1) {
>>     printError("Creation of socket failed", __FUNCTION__);
>>     return -1;
>>   }
>>
>>   // Enable address reuse
>>   int enable = 1;
>>   int err = setsockopt(sockFd,
>>                      SOL_SOCKET,
>>                      SO_REUSEADDR,
>>                      &enable,
>>                      sizeof(enable));
>>
>>   if (err) {
>>     printError("Error setting socket option SO_REUSEADDR", __FUNCTION__);
>>     close(sockFd);
>>     return -1;
>>   }
>>
>>   // Configure SCTP
>>   sctp_initmsg initmsg{};
>>   initmsg.sinit_num_ostreams = 3;
>>   initmsg.sinit_max_instreams = 3;
>>   initmsg.sinit_max_attempts = 2;
>>   initmsg.sinit_max_init_timeo = 0;
>>
>>   err = setsockopt(sockFd,
>>                  IPPROTO_SCTP,
>>                  SCTP_INITMSG,
>>                  &initmsg,
>>                  sizeof(initmsg));
>>
>>   if (err) {
>>     printError("Configuring SCTP socket failed", __FUNCTION__);
>>     close(sockFd);
>>     return -1;
>>   }
>>
>>   struct sctp_paddrparams paddr_params{};
>>   memset(&paddr_params, 0, sizeof(paddr_params));
>>   socklen_t size_of_sctp_paddr_params = sizeof(paddr_params);
>>   paddr_params.spp_flags = SPP_HB_ENABLE | SPP_PMTUD_ENABLE | SPP_SACKDELAY_ENABLE;
>>
>>   err = setsockopt(sockFd,
>>                  IPPROTO_SCTP,
>>                  SCTP_PEER_ADDR_PARAMS,
>>                  &paddr_params,
>>                  size_of_sctp_paddr_params);
>>
>>   if (err) {
>>     printError("Configuring SCTP params failed", __FUNCTION__);
>>     close(sockFd);
>>     return -1;
>>   }
>>
>>   return sockFd;
>> }
>>
>> bool bindSocket(const int sockFd, const int localPort) {
>>   // Get IP of ethernet interface
>>   string localAddress = "";
>>   ifreq ifr{};
>>   ifr.ifr_addr.sa_family = AF_INET;
>>   strncpy(ifr.ifr_name, SCTP_INTERFACE_NAME, IFNAMSIZ - 1);
>>   const int ioctlStatus = ioctl(sockFd,
>>                               SIOCGIFADDR,
>>                               &ifr);
>>
>>   if (ioctlStatus == -1) {
>>     printError("Failed to get local address", __FUNCTION__);
>>     return false;
>>   }
>>
>>   char ipAddrBuffer[INET_ADDRSTRLEN] {};
>>   inet_ntop(AF_INET,
>>           &reinterpret_cast<sockaddr_in*>(&(ifr.ifr_addr))->sin_addr,
>>           ipAddrBuffer,
>>           sizeof(ipAddrBuffer));
>>
>>   localAddress.assign(ipAddrBuffer);
>>
>>   // Bind to found ip address
>>   sockaddr_in serv_addr{};
>>   serv_addr.sin_family = AF_INET;
>>   inet_pton(AF_INET,
>>           localAddress.c_str(),
>>           &serv_addr.sin_addr);
>>   serv_addr.sin_port = htons(localPort);
>>
>>   if (bind(sockFd,
>>          reinterpret_cast<sockaddr*>(&serv_addr),
>>          sizeof(serv_addr))) {
>>     printError("Failed to bind socket to local address", __FUNCTION__);
>>     localAddress.clear();
>>     close(sockFd);
>>     return false;
>>   }
>>
>>   cout << "Local endpoint succussfully bound to local address: " << localAddress << endl;
>>
>>   return true;
>> }
>>
>> bool openAssociation(const int sockFd,
>>                    const string &remoteAddress,
>>                    std::uint16_t remotePort) {
>>
>>   sockaddr_in address{};
>>   address.sin_family = AF_INET;
>>   inet_pton(AF_INET, remoteAddress.c_str(), &address.sin_addr);
>>   address.sin_port = htons(remotePort);
>>
>>   int connectError = connect(sockFd,
>>                            reinterpret_cast<sockaddr *>(&address),
>>                            sizeof(address));
>>   if (connectError) {
>>     printError("Error connecting association", __FUNCTION__);
>>     return false;
>>   }
>>
>>   cout << "Association connected to address: " << remoteAddress << ":" << remotePort << endl;
>>   return true;
>> }
>>
>> void sendReq(const int sockFd,
>>            const string& remoteAddress,
>>            const uint16_t remotePort,
>>            const std::string& data)
>> {
>>
>>   struct sockaddr_in remoteAddr {};
>>   remoteAddr.sin_family = AF_INET;
>>   remoteAddr.sin_port = htons(remotePort);
>>
>>   uint32_t payloadProtId = 7;
>>   uint16_t streamId = 0;
>>   uint32_t dataLength = data.size();
>>   sockaddr* servaddr = reinterpret_cast<sockaddr*>(&remoteAddr);
>>   inet_pton(AF_INET, remoteAddress.c_str(), &remoteAddr.sin_addr);
>>
>>   const std::string ipaddr =
>>     inet_ntoa(reinterpret_cast<sockaddr_in*>(servaddr)->sin_addr);
>>
>>   cout << "Sending SCTP req to " << remoteAddress << ":" << remotePort;
>>   cout << ", len=" << dataLength << endl;
>>
>>   const int bytesSent = sctp_sendmsg(sockFd,
>>                                    data.c_str(),
>>                                    (size_t)dataLength,
>>                                    servaddr,
>>                                    sizeof(sockaddr_in),
>>                                    htonl(payloadProtId),
>>                                    SCTP_ADDR_OVER,
>>                                    streamId,
>>                                    200,
>>                                    0);
>>
>>   if (bytesSent == -1) {
>>     printError("SCTP send failed", __FUNCTION__);
>>   }
>>
>>   return;
>> }
>>
>> sctp_assoc_t getSocketAssociationId(const int sockFd,
>>                                   const string &remoteIpAddress,
>>                                   std::uint16_t remotePort)
>>
>> {
>>   sockaddr_in socket_address_in{};
>>
>>   socket_address_in.sin_family = AF_INET;
>>   socket_address_in.sin_port = htons(remotePort);
>>   inet_pton(AF_INET, remoteIpAddress.c_str(), &socket_address_in.sin_addr);
>>
>>   struct sockaddr *socket_address = reinterpret_cast<sockaddr*>(&socket_address_in);
>>   socklen_t salen = sizeof(&socket_address);
>>
>>   struct sctp_paddrinfo peer_address_info{};
>>   socklen_t size_of_sctp_paddrinfo = sizeof peer_address_info;
>>   std::memcpy(&peer_address_info.spinfo_address, socket_address, salen);
>>
>>   const int sctpOptInfoError = sctp_opt_info(sockFd,
>>                                            0,
>>                                            SCTP_GET_PEER_ADDR_INFO,
>>                                            &peer_address_info,
>>                                            &size_of_sctp_paddrinfo);
>>
>>   if (sctpOptInfoError) {
>>     printError("Failed to get association id", __FUNCTION__);
>>   }
>>
>>   return peer_address_info.spinfo_assoc_id;
>> }
>>
>> std::uint32_t getAssociationPathMtu(const int sockFd,
>>                                   const string &remoteIpAddress,
>>                                   const std::uint16_t remotePort) {
>>   sockaddr_in socket_address_in{};
>>
>>   socket_address_in.sin_family = AF_INET;
>>   socket_address_in.sin_port = htons(remotePort);
>>   inet_pton(AF_INET, remoteIpAddress.c_str(), &socket_address_in.sin_addr);
>>
>>   struct sockaddr *socket_address = reinterpret_cast<sockaddr*>(&socket_address_in);
>>   socklen_t salen = sizeof(&socket_address);
>>
>>   struct sctp_paddrinfo peer_address_info{};
>>   socklen_t size_of_sctp_paddrinfo = sizeof(peer_address_info);
>>   std::memcpy(&peer_address_info.spinfo_address, socket_address, salen);
>>
>>   sctp_assoc_t sctpAssociationId = getSocketAssociationId(sockFd, remoteIpAddress, remotePort);
>>
>>   const int sctpOptInfoError = sctp_opt_info(sockFd, sctpAssociationId,
>>                                            SCTP_GET_PEER_ADDR_INFO,
>>                                            &peer_address_info, &size_of_sctp_paddrinfo);
>>   if (sctpOptInfoError) {
>>     printError("Failed to get pmtu", __FUNCTION__);
>>   }
>>
>>   auto t = std::time(nullptr);
>>   auto tm = *std::localtime(&t);
>>   std::cout << std::put_time(&tm, "%H:%M:%S ") << remoteIpAddress << ":" << remotePort;
>>   cout << " currently has a PMTU of " << peer_address_info.spinfo_mtu << endl;
>>
>>   return peer_address_info.spinfo_mtu;
>> }
>>
>> void test1(const string& data) {
>>   int localPort = 2944;
>>   string remoteIp1 = "10.0.0.3";
>>   uint16_t remotePort1 = 8001;
>>   uint16_t remotePort2 = 8002;
>>
>>   int sockFd = createSocket();
>>   bindSocket(sockFd, localPort);
>>
>>   cout << "### Test 1: 2 assocs" << endl;
>>
>>   openAssociation(sockFd, remoteIp1, remotePort1);
>>   openAssociation(sockFd, remoteIp1, remotePort2);
>>
>>   getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>>   getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>>
>>   sendReq(sockFd, remoteIp1, remotePort1, data);
>>   for (int i = 0; i < 10; i++) {
>>     sleep(10);
>>     getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>>     getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>>   }
>> }
>>
>> void test2(const string& data) {
>>   int localPort = 2944;
>>   string remoteIp1 = "10.0.0.3";
>>   uint16_t remotePort1 = 8001;
>>   uint16_t remotePort2 = 8002;
>>   string remoteIpFake = "10.52.96.204";
>>   uint16_t remotePortFake = 3239;
>>
>>   int sockFd = createSocket();
>>   bindSocket(sockFd, localPort);
>>
>>   cout << "### Test 2: 2 assocs + 1 unreachable assoc" << endl;
>>
>>   openAssociation(sockFd, remoteIp1, remotePort1);
>>   openAssociation(sockFd, remoteIp1, remotePort2);
>>   openAssociation(sockFd, remoteIpFake, remotePortFake);
>>
>>   getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>>   getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>>
>>   sendReq(sockFd, remoteIp1, remotePort1, data);
>>   for (int i = 0; i < 10; i++) {
>>     sleep(10);
>>     getAssociationPathMtu(sockFd, remoteIp1, remotePort1);
>>     getAssociationPathMtu(sockFd, remoteIp1, remotePort2);
>>   }
>> }
>>
>>
>> int main(int argc, char** argv) {
>>   string testNr = "1";
>>   string& testData = data1000;
>>   if (argc >= 2) {
>>     testNr = argv[1];
>>   }
>>   if (argc >= 3) {
>>     testData = data100;
>>   }
>>
>>   if (testNr == "1") {
>>     test1(testData);
>>   } else {
>>     test2(testData);
>>   }
>>
>>   return 0;
>> }
>

--001a1144993a67b52505599cea40
Content-Type: application/x-gzip; name="test2_traces.tar.gz"
Content-Disposition: attachment; filename="test2_traces.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j7sx4d630

H4sIAPoywlkAA+1dC5AlVXnumX2wsu6CYiFJadEhBGGZHft5uvuKFLO7Izthd2ZhZhGyklt95/ad
vezMvZd77+yDimFLjEZJ5eEjVogkmCIajBATY5SEWIKWVUgEK26qghYQJWhkNeVSkqWoUnJO33ff
093/f7rvLGifrdnp+5jzfefR5//Pd/5zuuk1mtpkbdGtSSNLCk3EMPzfNAV+a/QzIqm6ShRDM1WN
fk9VDUuRZGV0lHpptdF067Is1avVZtT34j5/laYTX/mHT4xL6/veWS+N0f+/ctnDN+5at0W6jl6z
n5fO//SNdz5O///Mn96wSZoel3ZJ0lXSVe+9ZPvZkrSR/oxvPn7hFPv7dW889Rqaw8XvPnHJY9LY
3fQNad2J8x6ck14rbZQ2SNJxCvFl+sMQ/pAiaPTL7KeVdwuHIYxd3EL4jb0sd4Zy4dTm4yzXjXec
/sa4NLZ+yjt1Rwfh5KN33SqdJf3PO1546oG/WXzua/Wvl372z+Tkubf9+N9PBst8xylv6rFLTry7
8/q+k79dm93w/TfQbKRb73r05Li0+TjD49XX1IVj/u/j49LFV176zC0f3fSWq9888eTt23c98uTh
277+ybe96bmXnrjos/eU6m+cgdQ/pKaCf9Nfg6X1W6TzaSbnjw230dimdg2W+9uI1dqP3nXDs/T1
L0VtsVr6CK0ljV6zn2A/k9r97JKhfvaurz70ps3tev7Mhsh7YczPYaKvnncw7P33/9FWxvn5E87p
Duf3/8G/vsy7Fx7ZgLoXdmw+znJ95C/l/2L3woYHnu4inC6eup3dC3/yoZ/9XW7x/u9vWbzx7t/5
4Is/+MDCrVawdk4//cCG086J5zuva19c6rbu7aeKp6Nad0df66r3fOpbx588sO3eb73179++VLr6
1279jy2z/7L1jz/3zEO/d+HDX/getHXjair4N/01+P6NkffCuF+DS/1txGrthXtv/i67F34ZaovV
0qc3ou6Fdj8779uVjexe+E+aw0Xf2SJdQvNmP8F6Xn+BtJHlcNF8cMz55gs//rK0bt2L/j3bSmcp
qqYbJrFsJ7vKrrKrX9QrNmr8o71V2kZvevbzsp/a485GiQ7OG6nb2XrNxozW8MBGEPaXe6/YKl1B
X18hBcabzl+Ot16z7wfz6E8sry/kt0o76Li1Y/3Q6CetN9igetVY4aHO6Ldu/bXUHxq/IRvXsqvs
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
--001a1144993a67b52505599cea40--
