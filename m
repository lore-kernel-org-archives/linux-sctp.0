From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu, 10 Oct 2019 00:13:21 +0000
Subject: Re: [PATCH net-next 0/4] sctp: add some missing events from rfc5061
Message-Id: <20191009171321.4583316f@cakuba.netronome.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1570534014.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570534014.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Tue,  8 Oct 2019 19:27:32 +0800, Xin Long wrote:
> There are 4 events defined in rfc5061 missed in linux sctp:
> SCTP_ADDR_ADDED, SCTP_ADDR_REMOVED, SCTP_ADDR_MADE_PRIM and
> SCTP_SEND_FAILED_EVENT.
> 
> This patchset is to add them up.

Applied, thanks.
