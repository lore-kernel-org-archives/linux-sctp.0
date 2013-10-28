From: Julian Anastasov <ja@ssi.bg>
Date: Mon, 28 Oct 2013 09:00:37 +0000
Subject: Re: [PATCH ipvs 2/2] net: ipvs: sctp: do not recalc sctp checksum when not needed
Message-Id: <alpine.LFD.2.03.1310281058410.1490@ssi.bg>
List-Id: <linux-sctp.vger.kernel.org>
References: <8390127344501c35ed3c23f3690b8a671d353870.1382689350.git.dborkman@redhat.com>
In-Reply-To: <8390127344501c35ed3c23f3690b8a671d353870.1382689350.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


	Hello,

On Mon, 28 Oct 2013, Simon Horman wrote:

> Thanks, I have pushed it to ipvs-next.
> 
> I will hold off on sending a pull-request to Pablo until you send
> the 2nd patch.

	First patch is a bugfix, it should go to stable
kernels. The second patch looks like an optimization.

Regards

--
Julian Anastasov <ja@ssi.bg>
