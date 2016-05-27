From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 27 May 2016 16:02:55 +0000
Subject: Re: [PATCH net] sctp: sctp_diag should dump sctp socket type
Message-Id: <CADvbK_d0H7DG6YQTow6zq37H0cD0Aj0_y4_LoAa1OzkqXodMJQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <53ebf63eb6de080418949f52d0d3556af2a371e1.1464203668.git.lucien.xin@gmail.com>
	<20160525.122421.1141954704190813920.davem@davemloft.net>
In-Reply-To: <20160525.122421.1141954704190813920.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, Phil Sutter <phil@nwl.cc>

On Thu, May 26, 2016 at 3:24 AM, David Miller <davem@davemloft.net> wrote:
> From: Xin Long <lucien.xin@gmail.com>
> Date: Thu, 26 May 2016 03:14:28 +0800
>
>> For sctp_diag, ss support is not officially available, thus there
>> are no official users of this yet, so we can add this field in the
>> middle of sctp_info without breaking user API.
>
> This is not what matters.
>
> What matters is if a released kernel went out with the existing API.
got you, I will move this field to the end of struct sctp_info.
