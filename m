From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 15 Jan 2013 13:14:44 +0000
Subject: Re: v2 [PATCH] sctp_xconnect: memory leak when malloc big buffer
Message-Id: <50F55644.2010404@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1358214723-26879-1-git-send-email-fan.du@windriver.com>
In-Reply-To: <1358214723-26879-1-git-send-email-fan.du@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01/15/2013 01:43 PM, Neil Horman wrote:
> On Tue, Jan 15, 2013 at 09:52:03AM +0800, Fan Du wrote:
>> sctp_xconnect: memory leak when malloc big buffer
>>
>> CLIENT repeatly call process_ready_sockets, which malloc without free,
>> so sctp_xconnect exit unexpectly.
>>
>> Signed-off-by: Fan Du <fan.du@windriver.com>
>> v1->v2:
>> Declare this buffer statically suggested by Neil Horman.

[...]

> Looks good, thank you!
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Applied, thanks Fan.
