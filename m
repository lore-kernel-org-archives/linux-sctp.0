From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 01 Feb 2013 14:33:48 +0000
Subject: Re: [PATCH net-next v2] sctp: sctp_close: fix release of bindings for deferred call_rcu's
Message-Id: <510BD24C.3050507@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1359726681.git.dborkman@redhat.com> <2e8cac1036ff146d5e4c609e9aecb3765f19b067.1359726681.git.dborkman@redhat.com> <510BCFB7.3050603@gmail.com>
In-Reply-To: <510BCFB7.3050603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 02/01/2013 03:22 PM, Vlad Yasevich wrote:
>> +
>> +    if (transport->asoc)
>> +        sctp_association_put(transport->asoc);
>> +
>> +    sctp_packet_free(&transport->packet);
>
> I think it might be better to do sctp_packet_free() before releasing transports ref on the association.  The reason is that if for some reason that ref is the last one, you'd trigger association_destroy()
> call and then come back to try to free the packet.  It just doesn't sound right.  It would be better to free the packet (which should be
> empty at this point anyway), and then drop the ref on the association.

Agreed, that's more sound.
