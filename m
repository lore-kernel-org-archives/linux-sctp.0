From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 09 Jul 2014 16:10:40 +0000
Subject: Re: [PATCH net-next 0/5] SCTP updates
Message-Id: <53BD6980.1090605@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1404507908-6949-1-git-send-email-dborkman@redhat.com> <20140708111408.GA23026@hmsreliant.think-freely.org> <53BBFAA6.80408@redhat.com> <20140708144127.GB23026@hmsreliant.think-freely.org> <53BD1211.4080504@redhat.com> <20140709104958.GA3784@hmsreliant.think-freely.org> <53BD4363.70306@redhat.com> <20140709151354.GA5250@localhost.localdomain> <53BD6167.1030000@gmail.com>
In-Reply-To: <53BD6167.1030000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, geirola@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 07/09/2014 05:36 PM, Vlad Yasevich wrote:
...
> The problem here is deprecation of ancillary data and that's is a lot tougher
> then socket options.  In this particular case (SCTP_SNDRCVINFO vs SCTP_RCVINFO),
> I don't think there is any way to deprecate the SCTP_SNDRCVINFO since the event
> enabling it is the same as the one for SCTP_RCVINFO.  This was a mistake in the
> spec.  Ancillary data should not have been enabled using even notification api,
> as it is not an event, but we now have to live with it.

Then the set could stay as is from my side.
