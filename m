From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 21 Dec 2015 02:17:38 +0000
Subject: Re: Is SO_REUSEADDR option available for SCTP?
Message-Id: <56776142.8020307@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftL+F2F3vaYTCoLnWLAUC3ZQYEsJTRy93AS+xtOPSMWGkA@mail.gmail.com>
In-Reply-To: <CAFXGftL+F2F3vaYTCoLnWLAUC3ZQYEsJTRy93AS+xtOPSMWGkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/20/2015 09:09 PM, Sun Paul wrote:
> Hi
> 
> we have running in trouble in bind the port when the SCTP application
> is stopped and then started, we got the "Address already in use".
> 
> we would like to know whether SO_REUSEADDR option available for SCTP?

Yes it is available for SCTP protocol sockets.

> 
> if yes, is it also available for the java socket API?

Don't know.  It would have to be something supported in Java.

-vlad

> 
> Thanks
> 
> RBK
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

