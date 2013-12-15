From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 15 Dec 2013 15:32:01 +0000
Subject: Re: undetected closed apps
Message-Id: <ADF5C8CA-87A0-44BC-ABEF-A9BD2A250A28@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Dec 15, 2013, at 4:21 PM, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> On 12/14/13 15:06, Michael Tuexen wrote:
>> On Dec 14, 2013, at 8:09 PM, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> 
>> In FreeBSD it can be controlled by a sysctl:
>> net.inet.sctp.shutdown_guard_time: 180
>> Don't know about Linux.
> 
> The kernel seems to have it - but i cant see any knob exposed to
> user space.
> 
> Can someone from the Linux world point me to some stats i can collect
> in user space that will narrow this down? There has to be something.
> I dont have the luxury of doing git bisect (rephrase: These kernels
> are deployed, upgrade is almost a no option).
> 
>>> Waiting for a few hours last time didnt seem to cure this.
>> OK.
>> 
>> But the suggested value is 3 Minutes...
>> 
> 
> Understood - but i thought if i waited longer than 3 minutes then
> that would cover it, no?
Sure, but you don't need to wait for hours...
> 
> I tried a few other things from the server side to detect if the client
> is gone:
> - peek read (claimed all was good)
> - getsockopt some random value (claimed all was good)
> All understandable given the socket state seems to be still intact.
I think you said that HEARTBEATs were still flowing in both directions.
So the association is alive. You might want to inspect on the client
side the state of the association. That seems to be the side which
has a problem. What is netstat reporting?
Best regards
Michael
> 
> So the only option that still seem left for me is to implement app level
> heartbeats to detect dead clients.
> 
> cheers,
> jamal
> 
> 
> 

