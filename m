From: Franklin Marmon <marmon@hydeco.com>
Date: Mon, 20 Nov 2017 16:29:13 +0000
Subject: Re: address already in use on previously used (but currently unused) IP:PORT combinations in sctp_bi
Message-Id: <bb113a21-3ce7-d7a9-50e2-6fa4ec2a4972@hydeco.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0bbe01d30afe$80ce96f0$826bc4d0$@hydeco.com>
In-Reply-To: <0bbe01d30afe$80ce96f0$826bc4d0$@hydeco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I have now experienced this same issue on kernel 4.9.49. An SCTP_SOCKET 
is open, close() is called and a new socket is created. when 
sctp_bindx() is called on the new socket the kernel is reporting that 
the address is already in use. The address continues to show in 
/proc/net/sctp/assoc as in use, even when the program responsible for 
the original socket is killed and confirmed removed from the process list.

The remote end is continuing to send SCTP heartbeats as well as data 
packets, the kernel is acknowledging them. It seems as though when the 
socket's parent process is killed the socket should be removed from the 
kernel, regardless incoming data, socket options or really anything 
else. Is this an invalid assumption?

In the interim I'm going to attempt setting my SO_LINGER to {1, 0} to 
force close() to send ABORT. I'm not sure what else to try in order to 
force the remote end to close their side down and hopefully allow the 
kernel to cleanup the socket after close().

frm

Franklin Marmon
They Hyde Company
331 East Broaday, Missoula MT 59801
Office: 1.406.541.4777
Mobile: 1.406.493.2460
http://www.hydeco.com

On 8/2/2017 6:37 PM, Xin Long wrote:
> On Thu, Aug 3, 2017 at 2:09 AM, Franklin Marmon <marmon@hydeco.com> wrote:
>> I did have a connection prior to the binding. If I can reproduce I will test against the 4.8.x kernel when I am able. This is a live system and requires coordinate with others.
> Sorry, it should be 4.9.x
>
>> Thank you!
>>
>> frm
>>
>> Franklin Marmon
>> The Hyde Company
>> 331 East Broadway
>> Missoula, MT 59801
>>
>> Office: 406.541.4777
>> Cell: 406.493.2460
>> http://www.hydeco.com
>> marmon@hydeco.com
>>
>> -----Original Message-----
>> From: Xin Long [mailto:lucien.xin@gmail.com]
>> Sent: Wednesday, August 2, 2017 7:28 AM
>> To: marmon@hydeco.com
>> Cc: linux-sctp@vger.kernel.org; smcclain@hydeco.com; jerry@hydeco.com
>> Subject: Re: address already in use on previously used (but currently unused) IP:PORT combinations in sctp_bindx()
>>
>> On Wed, Aug 2, 2017 at 7:43 AM, Franklin Marmon <marmon@hydeco.com> wrote:
>>> Hello,
>>>
>>> I'm having trouble with sctp_bindx() reporting address already in use
>>> when attempting to bind sockets. The IP:PORT combinations are not
>>> open, do not show up in /proc/net/sctp/assocs, netstat, ss, or lsof.
>>> The IP:PORTs were bound in a previous instance of the client
>>> application however that application itself has been killed and
>>> restarted. It is as if the kernel believes the IP:PORT pair is in use
>>> when, as far as I can tell, it isn't. If I change the ports used in my
>>> addresses to ports I have not used previously the bind succeeds
>>> without issue. Any suggestions on how I can tell what is holding the ports open, or how to reset the sctp port table in the kernel?
>>>
>>> Lksctp-tools verison: 1.0.16
>>> Kernel version: 4.4.6
>> Did you have sctp connection and sctp traffic before this binding ?
>> It maybe an asoc leak in 4.4.y kernel.
>> If it's reproducable, can you try against this commit(or with 4.8.y kernel)
>>
>> commit b61c654f9b3f1a271217e46c893f80565b1f754d
>> Author: Xin Long <lucien.xin@gmail.com>
>> Date:   Wed Sep 14 02:04:20 2016 +0800
>>
>>      sctp: free msg->chunks when sctp_primitive_SEND return err
>>
>>
>>
>>
>>> IP-Family: IPv4
>>> Number of addresses passed to sctp_bindx(): normally 2, have tested
>>> with each address individually
>>>
>>> frm
>>>
>>>
>>> Franklin Marmon
>>> The Hyde Company
>>> 331 East Broadway
>>> Missoula, MT 59801
>>>
>>> Office: 406.541.4777
>>> Cell: 406.493.2460
>>> http://www.hydeco.com
>>> marmon@hydeco.com
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp"
>>> in the body of a message to majordomo@vger.kernel.org More majordomo
>>> info at  http://vger.kernel.org/majordomo-info.html
>>

