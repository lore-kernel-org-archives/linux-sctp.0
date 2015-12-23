From: Sun Paul <paulrbk@gmail.com>
Date: Wed, 23 Dec 2015 01:41:39 +0000
Subject: Re: Is SO_REUSEADDR option available for SCTP?
Message-Id: <CAFXGftKnyTnbhpZchgasNMNXXgQsW_=wpzh-BRoqvcCAEVs_CA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftL+F2F3vaYTCoLnWLAUC3ZQYEsJTRy93AS+xtOPSMWGkA@mail.gmail.com>
In-Reply-To: <CAFXGftL+F2F3vaYTCoLnWLAUC3ZQYEsJTRy93AS+xtOPSMWGkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

we are using 2.6.32-504.23.4.el6.x86_64

On Tue, Dec 22, 2015 at 10:43 PM, Vlad Yasevich <vyasevich@gmail.com> wrote:
> On 12/21/2015 07:59 PM, Sun Paul wrote:
>> Understood. we have set the setReuseAddress (java.net API) in our java
>> code, but it seems not work as expected. So, is this option applied
>> for SCTP layer?
>>
>
> Which kernel version are you using?  What is the behavior that you are observing?
>
> -vlad
>
>>
>> On Mon, Dec 21, 2015 at 10:49 AM, Vlad Yasevich <vyasevich@gmail.com> wrote:
>>> On 12/20/2015 09:18 PM, Sun Paul wrote:
>>>> is it possible to provide some reference on how to use it?
>>>
>>> It has the same limitation as usage with TCP sockets.  Only 1 listening socket
>>> is allowed, but you can bind multiple sockets with different addresses to the
>>> same port.
>>>
>>> -vlad
>>>>
>>>> thanks
>>>>
>>>>
>>>> On Mon, Dec 21, 2015 at 10:17 AM, Vlad Yasevich <vyasevich@gmail.com> wrote:
>>>>> On 12/20/2015 09:09 PM, Sun Paul wrote:
>>>>>> Hi
>>>>>>
>>>>>> we have running in trouble in bind the port when the SCTP application
>>>>>> is stopped and then started, we got the "Address already in use".
>>>>>>
>>>>>> we would like to know whether SO_REUSEADDR option available for SCTP?
>>>>>
>>>>> Yes it is available for SCTP protocol sockets.
>>>>>
>>>>>>
>>>>>> if yes, is it also available for the java socket API?
>>>>>
>>>>> Don't know.  It would have to be something supported in Java.
>>>>>
>>>>> -vlad
>>>>>
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>> RBK
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>
>>>
>
