From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 17 Jun 2014 18:42:24 +0000
Subject: Re: [PATCH net-next 0/6] A step closer to RFC 6458 compliancy
Message-Id: <53A08C10.70103@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403017296-28469-1-git-send-email-geirola@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D1725DEC9@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1725DEC9@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>, 'Geir Ola Vaagland' <geirola@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

On 06/17/2014 11:36 AM, David Laight wrote:
> From: Of Geir Ola Vaagland
>> These patches are part of my master thesis project. I have been searching for discrepancies between
>> the socket API specificiation in RFC 6458 and the current Linux SCTP implementation. The following
>> patches are my humble attempts at getting somewhat closer to compliancy.
> 
> I've just been reading RFC 6458 - HTF did it get past the editors and
> then published in its current form?
> Lots of the structures have implied padding.
> There is an embedded 'struct sockaddr_storage' in the middle of
> one structure. In some OS this should never actually be instantiated.

This particular horse has been beaten to death already.  It has been
around for so long that we couldn't really change it anymore.

I've argued the padding issue, but the editor stance is that it's implementation
dependent.

-vlad

> 
> Maybe the interface could have been changed in 2001, but not in 2011.
> 
> 	David
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

