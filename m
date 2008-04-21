From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 21 Apr 2008 13:15:59 +0000
Subject: Re: [Lksctp-developers] A lot of socket api work needs to be done.
Message-Id: <480C938F.8060609@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48098D83.50402@cn.fujitsu.com>
In-Reply-To: <48098D83.50402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Hi All:
> 
> Vlad Yasevich wrote:
>> Hi  All
>>
>> We are severely lacking in our implementation of the socket API and 
>> I'd like to revitalize
>> the effort to get this updated.
>>
>> Note:  I am ignoring the AUTH pieces since I've had this implemented, 
>> but have been
>> waiting for the API to stabilize.
>>
>> As such, the following is a set of sections that need to be implemented:
>>
>>     5.2.2. SCTP Header Information Structure (SCTP_SNDRCV)   
>>         - SCTP_SENDALL will require reworking how we copy data from
>>
>>     5.2.3.  Extended SCTP Header Information Structure
>>
>>     7.1.26. Set or Get the use of extended receive info 
>> SCTP_USE_EXT_RCVINFO)
>>
>>     7.1.23. Get or set delayed ack timer (SCTP_DELAYED_SACK)
>>   
> Is anyone doing about this one? If nobody do this, I'd link to take it.

Go for it

-vlad
