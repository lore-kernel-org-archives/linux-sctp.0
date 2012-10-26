From: David Miller <davem@davemloft.net>
Date: Fri, 26 Oct 2012 06:22:58 +0000
Subject: Re: [PATCH v2] sctp: Make hmac algorithm selection for cookie generation dynamic
Message-Id: <20121026.022258.608629405171960370.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1350661926-8312-1-git-send-email-nhorman@tuxdriver.com>
	<1351106403-23375-1-git-send-email-nhorman@tuxdriver.com>
	<50893A08.60202@gmail.com>
In-Reply-To: <50893A08.60202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 25 Oct 2012 09:09:28 -0400

> On 10/24/2012 03:20 PM, Neil Horman wrote:
>> Currently sctp allows for the optional use of md5 of sha1 hmac
>> algorithms to
>> generate cookie values when establishing new connections via two build
>> time
>> config options.  Theres no real reason to make this a static
>> selection.  We can
>> add a sysctl that allows for the dynamic selection of these algorithms
>> at run
>> time, with the default value determined by the corresponding crypto
>> library
>> availability.
>> This comes in handy when, for example running a system in FIPS mode,
>> where use
>> of md5 is disallowed, but SHA1 is permitted.
>>
>> Note: This new sysctl has no corresponding socket option to select the
>> cookie
>> hmac algorithm.  I chose not to implement that intentionally, as RFC
>> 6458
>> contains no option for this value, and I opted not to pollute the
>> socket option
>> namespace.
>>
>> Change notes:
>> v2)
>> 	* Updated subject to have the proper sctp prefix as per Dave M.
>> 	* Replaced deafult selection options with new options that allow
>> 	  developers to explicitly select available hmac algs at build time
>> 	  as per suggestion by Vlad Y.
>>
> 
> Thanks Neil.  That's much better.
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied.
