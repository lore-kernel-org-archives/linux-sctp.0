From: upma gandhi <upma.gandhi@gmail.com>
Date: Fri, 22 Mar 2013 08:24:02 +0000
Subject: Re: [Lksctp-developers] ARP request being sent every 20 seconds or so
Message-Id: <CAMW_Aa_tSYyVbMzEnOOoOFthnJdjh73xbQukXOhBVdXdkXDNSQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5149AE3F.50000@gmail.com>
In-Reply-To: <5149AE3F.50000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Thanks Vlad, Will try and let you know.
  There seems to be one issue in 2.6.32 where netstat shows sctp
socket in CLOSE state and it never cleans up. Rebooting m/c does solve
the problem.

Thanks
Upma

On Thu, Mar 21, 2013 at 6:54 PM, Vlad Yasevich <vyasevich@gmail.com> wrote:
> On 03/21/2013 03:38 AM, upma gandhi wrote:
>>
>> Hi Vlad,
>>    I understand that  SCTP_MIB_OUTSCTPPACKS  is just for SCTP level stats.
>> But in route module, when a packet( SCTP) is send out for some
>> neighbor, we must be updating "used" variable with 'jiffies'  and
>> which should not let ARP expiry timer kick in ? or is it that dst at
>> SCTP layer doesn't match exactly to neighbor maintained at ARP layer ?
>> I am asking all this for my understanding, pls. let me know if there
>> is any document which talks about SCTP linux implementation.
>
>
> The MIB attribute is just that.  It is used in the SNMP MIB.
>
> The solution is for SCTP to call the proper dst/route code when the time is
> right.  Essentially, when SCTP determines that is has made forward progress
> in the connection, it can call dst_confirm().
>
> I am attaching a patch that does this, but I have not tested it yet.
> Give it a try and let me know if it works for you.
>
> -vlad
>
>>
>> Thanks
>> Upma
>>
>>
>> On Wed, Mar 20, 2013 at 6:10 PM, Vlad Yasevich <vyasevich@gmail.com>
>> wrote:
>>>
>>> On 03/20/2013 06:40 AM, upma gandhi wrote:
>>>>
>>>>
>>>> Hi Vlad,
>>>>       I am using linux kernel  2.6.32 and wondering if the fix you are
>>>> referring is after that ?
>>>> I would like to know if MIB variable SCTP_MIB_OUTSCTPPACKS  is picked
>>>> up by ICMP to figure out if  neighbour is stale/unreachable/delay etc.
>>>> ? Can you pls. point me to variable which is being set by SCTp on
>>>> successful packet out and pickup by ARP to figure out if resolution is
>>>> required or not ? I am sorry for writing personal mail but I am in
>>>> need of solution faster.
>>>
>>>
>>>
>>> I just checked, and we don't appear to have this fix.  Let me see if I
>>> can
>>> cook something up for you to test.
>>>
>>> -vlad
>>>
>>>>
>>>> Thanks
>>>> Upma
>>>>
>>>> On Tue, Mar 19, 2013 at 5:37 PM, Vlad Yasevich <vyasevich@gmail.com>
>>>> wrote:
>>>>>
>>>>>
>>>>> On 03/19/2013 05:03 AM, upma gandhi wrote:
>>>>>>
>>>>>>
>>>>>> Hello All,
>>>>>>      I have one basic SCTP client and server ( having single network
>>>>>> connection) and client is continuously sending data to server every 1
>>>>>> second. I am seeing that server is sending ARP request every 20
>>>>>> seconds or so ( see below logs) for client IP address. If I use TCP
>>>>>> client/ server  instead of SCTP, I see that ARP request is being sent
>>>>>> every 4 minute. Can somebody clarify why its happening or if my
>>>>>> observation is wrong ?
>>>>>
>>>>>
>>>>>
>>>>> There was an old bug that SCTP didn't update the route forward progress
>>>>> thus causing NUD to kick in even though reachability was configured
>>>>> through SCTP.  I thought it was fixed a long time ago.  Which kernel
>>>>> version are you using?
>>>>>
>>>>> -vlad
>>>>>
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>>
>>>>>>
>>>>>> ------------------------------------------------------------------------------
>>>>>> Everyone hates slow websites. So do we.
>>>>>> Make your web apps faster with AppDynamics
>>>>>> Download AppDynamics Lite for free today:
>>>>>> http://p.sf.net/sfu/appdyn_d2d_mar
>>>>>> _______________________________________________
>>>>>> Lksctp-developers mailing list
>>>>>> Lksctp-developers@lists.sourceforge.net
>>>>>> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> ------------------------------------------------------------------------------
>>>>> Everyone hates slow websites. So do we.
>>>>> Make your web apps faster with AppDynamics
>>>>> Download AppDynamics Lite for free today:
>>>>> http://p.sf.net/sfu/appdyn_d2d_mar
>>>>> _______________________________________________
>>>>> Lksctp-developers mailing list
>>>>> Lksctp-developers@lists.sourceforge.net
>>>>> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>>>
>>>
>>>
>
