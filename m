From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 17 Jun 2014 12:36:42 +0000
Subject: RE: [PATCH net-next 2/6] Support for SCTP_RCVINFO ancillary data
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1725DC64@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403006273-27859-1-git-send-email-geirola@gmail.com>
 <1403006273-27859-3-git-send-email-geirola@gmail.com>
In-Reply-To: <1403006273-27859-3-git-send-email-geirola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Geir Ola Vaagland' <geirola@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>

From: Geir Ola Vaagland
...
> +struct sctp_rcvinfo {
> +	__u16 rcv_sid;
> +	__u16 rcv_ssn;
> +	__u16 rcv_flags;
> +	__u32 rcv_ppid;
> +	__u32 rcv_tsn;
> +	__u32 rcv_cumtsn;
> +	__u32 rcv_context;
> +	sctp_assoc_t rcv_assoc_id;
> +};

There are two pad bytes in the middle of the above.
You leak kernel data to userspace.

...
	David



