From: Sun Paul <paulrbk@gmail.com>
Date: Mon, 09 Jan 2017 02:06:14 +0000
Subject: Re: Problem on SCTP
Message-Id: <CAFXGftK6n52Lu69uDu4TwPrrkP=ZTppTiGxYRxfWVx-SVhQR8A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+weUFodkkiY=kgHMX+t4fECQhB+PKg2dBKxCBeU7w7MA@mail.gmail.com>
 <20170106114354.GB3771@localhost.localdomain>
In-Reply-To: <20170106114354.GB3771@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

Hi

I actually have set the rp_filter to 2 already but still the same.



On Fri, Jan 6, 2017 at 7:43 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> Hi,
>
> On Fri, Jan 06, 2017 at 05:34:47PM +0800, Sun Paul wrote:
>> Hi
>>
>> I am setting up a lab where the SCTP traffics from  client is passing
>> through a linux router before reaching to the SCTP server running
>> LKSCTP.
>>
>> The linux router did not change the source address of the client, so
>> when it arrived to the SCTP server, the source address is the oriingal
>> one.
>>
>> however, I found that there is no response from the SCTP server, any
>> idea on this?
>>
>> if I connect the client directly to the SCTP server, it do not have any issue.
>
> This seems to be a routing issue then, specially if you're using
> rp_filter. Make sure the server can reach that foreign address the
> client uses.
>
>   Marcelo
>
>>
>> help pls
>>
>> rbk
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
