From: David Neil <David.Neil@attocore.com>
Date: Sat, 24 Mar 2018 07:32:22 +0000
Subject: Re: SCTP abort with T-bit set after handshake
Message-Id: <23B49B8C-36AC-44F5-B671-C491A89EA171@attocore.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
In-Reply-To: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> 
>> 
>> I am assuming this decription I have given still fits in with the
>> theory that the failures were casued by the rhlists bug. Do you need
>> any more info to confirm this?
> 
> If doable, you could apply those fixes and run the original tests
> again. That would be very good to confirm it, but not really needed.
> 
> I'll try to write some test case for this. Will let you know once I
> have it.
> 
> Note sure if you know about it, but we have a growing collection of
> test cases @ https://github.com/sctp/sctp-tests
> 
> Pull requests are very welcomed. :-)
> 

The testing I have been doing has all been with the original test cases. These all work fine now.

I have been trying to put together a cut down standalone test that could recreate this problem, but I have not had any luck.
I guess if it was easy to reproduce then this linux bug would have been picked up ages ago!
Hopefully you have more luck.

Regards,
Dave.

