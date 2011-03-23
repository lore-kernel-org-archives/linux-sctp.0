From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 23 Mar 2011 01:12:26 +0000
Subject: Re: Error when build apps SCTP
Message-Id: <4D8948FA.6000800@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1300785083.2391.10.camel@thanh.pc>
In-Reply-To: <1300785083.2391.10.camel@thanh.pc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org


> Hi,my name Thanh Nguyen.Student of University of Science Ho Chi Minh
> City Viet Nam.I have one problem with SCTP API.
> I have source code one example client server SCTP. (Attach).But when
> build with gcc (using command gcc client.c -o client) was error as:
> "'union sctp_notification’ has no member named ‘sn_types’
> And I check struct sctp_notification but sn_types is member of this
> struct.Why error?
> If you have example same it, and paper abount SCTP API.Please send to
> me.Thanks a lot.
> Source example,I take it from Oracle example.Code server build ok.
> I have install LKSCTP, Fedora 13,GCC.  

It should be 'snp->sn_header.sn_type', not 'snp->sn_types'.

See the socket API: http://tools.ietf.org/html/draft-ietf-tsvwg-sctpsocket-27

Section 6.1.  SCTP Notification Structure

   union sctp_notification {
     struct sctp_tlv {
       uint16_t sn_type; /* Notification type. */
       uint16_t sn_flags;
       uint32_t sn_length;
     } sn_header;
     struct sctp_assoc_change sn_assoc_change;
     struct sctp_paddr_change sn_paddr_change;
     struct sctp_remote_error sn_remote_error;
     struct sctp_send_failed sn_send_failed;
     struct sctp_shutdown_event sn_shutdown_event;
     struct sctp_adaptation_event sn_adaptation_event;
     struct sctp_pdapi_event sn_pdapi_event;
     struct sctp_authkey_event sn_auth_event;
     struct sctp_sender_dry_event sn_sender_dry_event;
     struct sctp_send_failed_event sn_send_failed_event;
   };



