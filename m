From: "Barry Nagelberg" <barryn@adax.com>
Date: Thu, 28 May 2009 12:31:50 +0000
Subject: No indication from kernel after'Max.Init.Retransmits' retries
Message-Id: <JBECLENKLBCKAAKFGAJOAEJPGGAA.barryn@adax.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

I am running M3UA over lksctp using the following versions:

Redhat EL 4 Update 5
Kernel version : 2.6.9-55.ELsmp #1 SMP
32Bits

This corresponds to http://tools.ietf.org/html/draft-ietf-tsvwg-sctpsocket-07.

When my M3UA ASP (client) tries to connect to a peer that isn't running, and after my client sends the SCTP INIT msg
'Max.Init.Retransmits' times, I expect to receive an error indication from the kernel, as per the following section from
RFC 4960:

<snip>
4. SCTP Association State Diagram

.....

   2) If the T1-init timer expires, the endpoint MUST retransmit INIT
      and re-start the T1-init timer without changing state.  This MUST
      be repeated up to 'Max.Init.Retransmits' times.  After that, the
      endpoint MUST abort the initialization process and report the
      error to SCTP user.
<snip>

Before I bind to the socket and issue the connect call, I am subscribing to all of the event notifications in the
sctp_event_subscribe structure listed in section 7.3 of the sctpsocket draft:

   struct sctp_event_subscribe{
       u_int8_t sctp_data_io_event;
       u_int8_t sctp_association_event;
       u_int8_t sctp_address_event;
       u_int8_t sctp_send_failure_event;
       u_int8_t sctp_peer_error_event;
       u_int8_t sctp_shutdown_event;
       u_int8_t sctp_partial_delivery_event;
       u_int8_t sctp_adaption_layer_event;
   };

However I don't receive any event from the kernel after 'Max.Init.Retransmits' retries. In a normal successful
association startup or takedown I _do_ receive an event.

This seems to be a defect in lksctp. Has this been pointed out before? Has this been fixed in a subsequent version?

Thanks for any assistance,
Barry Nagelberg

