From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Mon, 17 Aug 2015 13:12:34 +0000
Subject: Re: SCTP heartbeat transmission interval in not working as expected
Message-Id: <43C2F12F-CA84-4742-9909-FDC0893CB085@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <f0156706abe9412c9d158cac2724d12a@BGHMBXV01.AD.ARICENT.COM>
In-Reply-To: <f0156706abe9412c9d158cac2724d12a@BGHMBXV01.AD.ARICENT.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

> On 17 Aug 2015, at 13:45, Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com> wrote:
> 
> Hi,
> 
>                We are using LKSCTP (ver 1.0.16) and we observe that the SCTP heartbeat transmission interval in not working as expected. Following is the SCTP configuration settings we are using (applied using setsockopt()).
> 
> 
> hbinterval0-sec
> RTO initial=3-sec
> RTO min=1-sec
> RTO max`-sec
> 
>                As per our understanding the SCTP heartbeat transmission interval value should be between 31.5 to 34.5 seconds as per the calculation "RTO+HBInterval+delta(Âą0.5ofRTO)" but we are always seeing the value in-between 30.6 to 31.5 seconds.
Assuming that the RTO is 1 second (after an RTT measurement this is true, I guess), you would get HBs every
30.5 and 31.5 seconds. Seems to be about what you measure.

Best regards
Michael
> 
>                Could somebody confirm if this is an issue or not and in-case of an issue how we can resolve.
> 
>                We are using LKSCTP version 1.0.16 and 1.0.7 and in both the versions we are observing the same behavior.
> 
> 
> Regards,
> 
> Raviâ
> 
> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
> N§ēæėrļyúčØbēXŽķĮ§vØ^)Þš{.nĮ+·Ĩ{ąąËi{ayšĘÚë,j­ĒfĢĒ·hāzđŪwĨĒļĒ·Ķj:+vĻwčjØmķĸūŦęįzZ+ųÝĒj"ú!

