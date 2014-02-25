From: David Miller <davem@davemloft.net>
Date: Tue, 25 Feb 2014 00:00:36 +0000
Subject: Re: [PATCH net-next] loopback: sctp: add NETIF_F_SCTP_CSUM to device features
Message-Id: <20140224.190036.1932145515925400435.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1393074113-9922-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1393074113-9922-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Sat, 22 Feb 2014 14:01:53 +0100

> Drivers are allowed to set NETIF_F_SCTP_CSUM if they have
> hardware crc32c checksumming support for the SCTP protocol.
> Currently, NETIF_F_SCTP_CSUM flag is available in igb,
> ixgbe, i40e/i40evf drivers and for vlan devices.
> 
> If we don't have NETIF_F_SCTP_CSUM then crc32c is done
> through CPU instructions, invoked from crypto layer, or
> if not available as slow-path fallback in software.
> 
> Currently, loopback device propagates checksum offloading
> feature flags in dev->features, but is missing SCTP checksum
> offloading. Therefore, account for NETIF_F_SCTP_CSUM as
> well.
 ...
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied, thanks a lot Daniel.
