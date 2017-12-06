From: Paul Moore <paul@paul-moore.com>
Date: Wed, 06 Dec 2017 14:15:06 +0000
Subject: Re: [PATCH V2] selinux: Add SCTP support
Message-Id: <CAHC9VhTXRzkVR2V809chUCSHtV6a3Po9ay6cVDeGVcohDz0DGw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171206101736.3217-1-richard_c_haines@btinternet.com>
	<20171206124638.GD3328@localhost.localdomain>
In-Reply-To: <20171206124638.GD3328@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Wed, Dec 6, 2017 at 7:46 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Wed, Dec 06, 2017 at 10:17:36AM +0000, Richard Haines wrote:
>> The SELinux SCTP implementation is explained in:
>> Documentation/security/SELinux-sctp.rst
>>
>> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
>> ---
>> V2 Changes
>> Remove lock from selinux_sctp_assoc_request()
>> Fix selinux_sctp_sk_clone() kbuild test robot catch [1]
>>
>> [1] https://marc.info/?l=selinux&m1198281817779&w=2
>>
>
> Is this patchset going in via netdev tree or selinux one?
> I see Dave is tracking the v1
> (http://patchwork.ozlabs.org/patch/841842/) so I'm thinking netdev but
> for netdev it would require a repost of the entire patchset, even if
> the first ones weren't changed.

This should go in via the SELinux tree, although I would like to see
ACKs from Dave and/or other netdev folks for the core stack bits.

-- 
paul moore
www.paul-moore.com
