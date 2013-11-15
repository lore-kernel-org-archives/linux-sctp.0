From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 15 Nov 2013 12:45:10 +0000
Subject: Re: MTU Probing
Message-Id: <20131115124510.GB29877@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <8A8F98BF0CDFD5438985D4397358E6C73B14A9@idc.vanu.com>
In-Reply-To: <8A8F98BF0CDFD5438985D4397358E6C73B14A9@idc.vanu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Nov 15, 2013 at 10:42:27AM +0530, Prasad, Shashank wrote:
> Does the kernel SCTP implementation have the implementation of RFC 4821
> (Packetization Layer Path MTU Discovery) ? I am using 2.6.32-358.23.2
> kernel, and did NOT find the implementation of RFC 4821 yet.
> 
SCTP gets its mtu for outgoing paths from the ip layer (via dst_mtu).  IIRC that
is 4821 compliant 
Neil
 
> Thanx.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
