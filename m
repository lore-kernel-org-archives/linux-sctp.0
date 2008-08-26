From: Eugene Teo <eteo@redhat.com>
Date: Tue, 26 Aug 2008 03:01:05 +0000
Subject: Re: [PATCH] sctp: add verification checks to SCTP_AUTH_KEY option
Message-Id: <48B371F1.5080605@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080825164440.GA504@kernel.sg> <12196959323990-git-send-email-vladislav.yasevich@hp.com> <48B35561.2010001@redhat.com> <48B35B59.2020208@hp.com>
In-Reply-To: <48B35B59.2020208@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, security@kernel.org

Vlad Yasevich wrote:
> Eugene Teo wrote:
>> Vlad Yasevich wrote:
[...]
>>> +	if (authkey->sca_keylength > optlen) {
>>> +		ret = -EINVAL;
>>> +		goto out;
>> Is there a better upper bound check?
> 
> Hm...  optlen - sizeof(struct sctp_authkey)  is more accurate.
> 
> There is really no other bound.

Linus suggested that it is better to declare an upper bound for key_len.
I think it makes a lot of sense as a key shouldn't be as long as the
boundary limit of its declared data type.

Thanks,
Eugene
