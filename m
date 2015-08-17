From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Mon, 17 Aug 2015 14:37:56 +0000
Subject: Re: SCTP heartbeat transmission interval in not working as expected
Message-Id: <BBCC4900-7B6C-474C-A2B7-CA80163B22B6@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <f0156706abe9412c9d158cac2724d12a@BGHMBXV01.AD.ARICENT.COM>
In-Reply-To: <f0156706abe9412c9d158cac2724d12a@BGHMBXV01.AD.ARICENT.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org


> On 17 Aug 2015, at 15:45, Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com> wrote:
> 
> Hi Michael,
> 
> Thanks for your quick response. It will be helpful if you can explain why it should be 30.5 to 31.5.
> 
> As per our understanding initially it should start with 33-seconds (30[HBInterval]+3[RTO initial]) right ?. Please correct me if my understanding is in-correct.
It should be [HB.Interval + 0.5 RTO, HB.Interval + 1.5 RTO]. I don't know when LKSCTP does RTT measurement, but assuming that the RTT is small,
I expect the RTO to be roughly RTO.min after the first measurement. So I was using RTO = RTO.Min

Best regards
Michael
> 
> 
> Regards,
> 
> Ravi
> 
> 
> -----Original Message-----
> From: Michael Tuexen [mailto:Michael.Tuexen@lurchi.franken.de]
> Sent: Monday, August 17, 2015 6:43 PM
> To: Ravi Puttachannaiah
> Cc: linux-sctp@vger.kernel.org
> Subject: Re: SCTP heartbeat transmission interval in not working as expected
> 
>> On 17 Aug 2015, at 13:45, Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com> wrote:
>> 
>> Hi,
>> 
>>               We are using LKSCTP (ver 1.0.16) and we observe that the SCTP heartbeat transmission interval in not working as expected. Following is the SCTP configuration settings we are using (applied using setsockopt()).
>> 
>> 
>> hbinterval0-sec
>> RTO initial=3-sec
>> RTO min=1-sec
>> RTO max`-sec
>> 
>>               As per our understanding the SCTP heartbeat transmission interval value should be between 31.5 to 34.5 seconds as per the calculation "RTO+HBInterval+delta(脗膮0.5ofRTO)" but we are always seeing the value in-between 30.6 to 31.5 seconds.
> Assuming that the RTO is 1 second (after an RTT measurement this is true, I guess), you would get HBs every
> 30.5 and 31.5 seconds. Seems to be about what you measure.
> 
> Best regards
> Michael
>> 
>>               Could somebody confirm if this is an issue or not and in-case of an issue how we can resolve.
>> 
>>               We are using LKSCTP version 1.0.16 and 1.0.7 and in both the versions we are observing the same behavior.
>> 
>> 
>> Regards,
>> 
>> Ravi芒鈧��
>> 
>> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
>> N鈥孤撁δ梤募鈥簓煤膷職脴b膿X沤姆漠搂v脴^鈥�)脼拧{.n漠+鈥奥纺妠膮膮脣i聤{ay拧�臉鈥∶氣劉毛,j
> 颅膾f蘑膾路h職鈥鼓亃膽�弄w抹膾募
> 膾路亩j:+v鈥澳宦妛膷j脴m姆聼母奴
> 纽鈥樐櫮痾Z+聝懦職藝聤脻膾j"炉煤!
> 
> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
> �N嫥叉靣笡y氊b瞂千v豝�)藓{.n�+壏{北薸妠ay��蕠跈�,j�f＂穐殝鄗��畐ア�⒎:+v墾妛鑚豰稛���珣赙zZ+凒殠娸"濟!

