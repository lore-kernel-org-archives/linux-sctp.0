From: Jerry Jerry <jerry.jerry2008@gmail.com>
Date: Fri, 06 Mar 2015 16:51:40 +0000
Subject: Re: Does IPv6 have to be enabled to run lksctp-tools?
Message-Id: <CAAyB5cKYyDJ=i2uO=FQYjsYZH0+GCMYxOc_fr-UgKbTwet+J5Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAyB5cKp6+dwfcbJT763nTvF0U1JXixv6uRYy=6XPD2h0_RGUQ@mail.gmail.com>
In-Reply-To: <CAAyB5cKp6+dwfcbJT763nTvF0U1JXixv6uRYy=6XPD2h0_RGUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Neil,

My apology that I didn't make it clear. There are actually two related
issues, (1) ipv6 requirement, and (2) checksctp hangs. For 2nd issue,
we are trying to recreate the problem and will get back to you once we
have the trace. For the 1st issue, here is how we verified:

using "vi /etc/modprobe.d/50-ipv6.conf" to comment out #install ipv6
/bin/true, and later using modprobe ipv6 to enable it. The following
are our steps:

linux165:~/sctp_test/lksctp-tools-1.0.16/src/withsctp
# ./checksctp
 checksctp: Protocol not supported

linux165:~/sctp_test/lksctp-tools-1.0.16/src/withsctp
# vi /etc/modprobe.d/50-ipv6.conf  (undo comment out ipv6)

linux165:~/sctp_test/lksctp-tools-1.0.16/src/withsctp
# modprobe ipv6

linux165:~/sctp_test/lksctp-tools-1.0.16/src/withsctp
# ./checksctp
SCTP supported


Regards,
Jerry

On Thu, Mar 5, 2015 at 6:04 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Wed, Mar 04, 2015 at 12:59:21PM -0800, Jerry Jerry wrote:
>> Hello,
>>
>> We had a strange problem using lksctp-tool where checksctp would hang
>> there on some of our machines and process cannot be killed anyway
>> (with status d/d+). After some investigation, we found out that
>> whether ipv6 is enabled could impact the behavior of the library. So,
>> my question is that, is this a requirement by design or it just
>> happens to occur that ipv6 is required? Any suggestion to bypass this
>> (not to rely on ipv6) would be appreciated very much.
>>
>> Regards,
>> Jerry
> IIRC there should be no ipv6 requierment.
>
> Where does the checksctp tool hang?  Is it in user space or the kernel?  Can you
> provide a backtrace, either ia gdb if its in userspace or sysrq in the kernel?
>
> Best
> Neil
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
