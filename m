From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 09 Aug 2013 18:50:40 +0000
Subject: Re: [PATCH net-next 1/2] net: sctp: convert sctp_checksum_disable module param into sctp sysctl
Message-Id: <52053A00.80808@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1375816693-7697-1-git-send-email-dborkman@redhat.com> <20130809.113320.681399334989952629.davem@davemloft.net>
In-Reply-To: <20130809.113320.681399334989952629.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 08/09/2013 02:33 PM, David Miller wrote:
> From: Daniel Borkmann <dborkman@redhat.com>
> Date: Tue,  6 Aug 2013 21:18:12 +0200
>
>> Get rid of the last module parameter for SCTP and make this
>> configurable via sysctl for SCTP like all the rest of SCTP's
>> configuration knobs.
>>
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>
> Applied.

David

Please revert this.  This isn't a knob that that should be
so freely exposed.  I thought my response to Daniel made
that clear.

Thanks
-vlad

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

