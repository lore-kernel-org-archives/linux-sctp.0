From: Paul Moore <paul@paul-moore.com>
Date: Fri, 18 Nov 2016 18:00:19 +0000
Subject: Re: github issue trackers
Message-Id: <CAHC9VhR4VhObCP9SGQxeE0n+WBw7fB+vWP1Xt7xc+=dkmLK6oQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <74821043-5051-f05b-9ef8-e34af08f7a54@tycho.nsa.gov>
 <1479487762.13487.6.camel@btinternet.com>
 <b54fe273-01bf-e128-0dcc-5fb764f865f8@tycho.nsa.gov>
In-Reply-To: <b54fe273-01bf-e128-0dcc-5fb764f865f8@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Richard Haines <richard_c_haines@btinternet.com>, SELinux-NSA <SELinux@tycho.nsa.gov>, linux-sctp@vger.kernel.org

On Fri, Nov 18, 2016 at 12:02 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> On 11/18/2016 11:49 AM, Richard Haines wrote:
>> On Fri, 2016-11-18 at 10:30 -0500, Stephen Smalley wrote:
>>> Hi,
>>>
>>> I've populated the github issue trackers for the selinux (userspace)
>>> and
>>> selinux-kernel github projects, see:
>>> https://github.com/SELinuxProject/selinux/issues
>>> and
>>> https://github.com/SELinuxProject/selinux-kernel/issues
>>>
>>> The old ToDo wiki pages are being migrated over, although I would
>>> like
>>> to drop items that are either a) already in progress, b)
>>> vague/ill-defined, or c) unlikely to be done.  Going forward, we'll
>>> just
>>> use the issue trackers for all new items.
>>>
>>> Feel free to identify additional issues that I may have missed, but
>>> please try to keep them well-defined and feasible.
>>
>> Just thought I would update you regarding the status of the RFC SCTP
>> kernel patches I sent a few years ago that are referenced at:
>> https://github.com/SELinuxProject/selinux-kernel/issues/5
>>
>> I have been keeping these updated and fixing problems as I find them,
>> however I have not resubmitted. If there is interest I'm happy to
>> submit again and see how far I can get. If anyone is interested
>> I keep a set of patches at:
>> http://arctic.selinuxproject.org/~rhaines/selinux-sctp
>>
>> For the gory details read:
>> http://arctic.selinuxproject.org/~rhaines/selinux-sctp/readme.txt
>
> Thanks, I'd certainly like to see them upstreamed.  Were there specific
> objections or just a lack of response?

I believe I was the weak link in this; I had (still have for that
matter) some gaps in my SCTP understanding and I wanted to be able to
properly review those patches before merging.

-- 
paul moore
www.paul-moore.com
