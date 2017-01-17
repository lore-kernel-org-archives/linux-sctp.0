From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 17 Jan 2017 17:44:51 +0000
Subject: Re: Resources not freed when calling sctp_sendmsg() after shutdown()
Message-Id: <CADvbK_c637Szve1zBfK-DDLzwshe6gDoAifLregqV2Oz9WtWZQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117131041.GD6494@aomx-netbook>
In-Reply-To: <20170117131041.GD6494@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Jan 18, 2017 at 1:38 AM, Julian Cordes <julian.cordes@gmail.com> wrote:
> 2017-01-17 18:30 GMT+01:00 Xin Long <lucien.xin@gmail.com>:
>> On Tue, Jan 17, 2017 at 9:10 PM, Julian Cordes <julian.cordes@gmail.com> wrote:
>>> Somehow after calling sctp_sendmsg after calling shutdown with SHUT_WR a
>>> resource is not freed anymore.
>>>
>>> I can reproduce the following behaviour:
>>> When running for example the following test case
>>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-tests/ttl-policy/shutdown-14.pkt
>>> on my machine, it succeeds the first time. This means that the test case
>>> worked as expected. But if I run the same test case
>>> on the same machine again then the bind-call in the test-case will fail.
>>> I waited longer than 30 minutes but only a reboot of the operating
>>> system seems to help in this case.
>>>
>>> See the following test-cases that all reproduce this issue. All call
>>> sctp_sendmsg after calling shutdown, therefore i suspect
>>> that this is the cause of the issue.
>> I think it's a old issue, the latest kernel has no this issue any more.
>> can you give it a try ?
>>
> Hi,
> i just ran the test-case
> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-tests/ttl-policy/shutdown-14.pkt
> on a recent archlinux kernel:
> $ uname -a
> Linux localhost 4.8.13-1-ARCH #1 SMP PREEMPT Fri Dec 9 07:24:34 CET
> 2016 x86_64 GNU/Linux
>
> The problem still exists. The second time i ran the test case, i got
> as a result:
> shutdown-14.pkt:78: runtime error in bind call: Expected result 0 but
> got -1 with errno 98 (Address already in use)
>
I meant upstream latest kernel:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git

it's already v4.10-rc3
you may need to rebuild. :)


>>>
>>> Testscripts available at:
>>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-tests/ttl-policy/shutdown-14.pkt
>>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-tests/ttl-policy/shutdown-1.pkt
>>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-tests/ttl-policy/shutdown-2.pkt
>>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-received-tests/ttl-policy/shutdown-1.pkt
>>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/sender-side-implementation/shutdown-received-tests/ttl-policy/shutdown-2.pkt
