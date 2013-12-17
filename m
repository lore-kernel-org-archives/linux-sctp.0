From: David Miller <davem@davemloft.net>
Date: Tue, 17 Dec 2013 01:11:52 +0000
Subject: Re: [PATCH v2] sctp: loading sctp when load sctp_probe
Message-Id: <20131216.201152.1820334028788828960.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AA783A.7090502@huawei.com>
In-Reply-To: <52AA783A.7090502@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wangweidong1@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 13 Dec 2013 11:00:10 +0800

> when I modprobe sctp_probe, it failed with "FATAL: ". I found that
> sctp should load before sctp_probe register jprobe. So I add a
> sctp_setup_jprobe for loading 'sctp' when first failed to register
> jprobe, just do this similar to dccp_probe.
> 
> v2: add MODULE_SOFTDEP and check of request_module, as suggested by Neil
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Applied.
