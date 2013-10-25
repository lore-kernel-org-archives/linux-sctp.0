From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 25 Oct 2013 09:48:13 +0000
Subject: Re: [PATCH ipvs 2/2] net: ipvs: sctp: do not recalc sctp checksum when not needed
Message-Id: <20131025114813.6a227df3@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <8390127344501c35ed3c23f3690b8a671d353870.1382689350.git.dborkman@redhat.com>
In-Reply-To: <8390127344501c35ed3c23f3690b8a671d353870.1382689350.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, 25 Oct 2013 11:05:05 +0200
Daniel Borkmann <dborkman@redhat.com> wrote:

> Unlike UDP or TCP, we do not take the pseudo-header into account
> in SCTP checksums [1]. So in case port mapping is the very same, we
> do not need to recalculate the whole SCTP checksum in software, which
> is expensive.
> 
> Also, similarly as in IPVS/TCP, take into account when a private
> helper mangled the packet. In that case, we also need to recalculate
> the checksum even if ports might be same.
> 
>  [1] http://tools.ietf.org/html/rfc4960#section-6.8
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks Daniel, this will hopefully increase SCTP performance as we
avoid recalculating the checksum when not necessary :-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
