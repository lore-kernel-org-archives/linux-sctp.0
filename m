From: Marcel Holtmann <marcel@holtmann.org>
Date: Sat, 02 May 2020 06:44:37 +0000
Subject: Re: [PATCH 00/20] crypto: introduce crypto_shash_tfm_digest()
Message-Id: <5E6F9382-3D91-4587-980A-377E7CB086E4@holtmann.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200502053122.995648-1-ebiggers@kernel.org>
In-Reply-To: <20200502053122.995648-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Cheng-Yi Chiang <cychiang@chromium.org>, ecryptfs@vger.kernel.org, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Gilad Ben-Yossef <gilad@benyossef.com>, Guenter Roeck <groeck@chromium.org>, Jesper Nilsson <jesper.nilsson@axis.com>, Kamil Konieczny <k.konieczny@samsung.com>, keyrings@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>, Krzysztof Opasiak <k.opasiak@samsung.com>, Lars Persson <lars.persson@axis.com>, linux-bluetooth <linux-bluetooth@vger.kernel.org>, linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org, linux-sctp@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>, Tom Lendacky <thomas.lendacky@amd.com>, Vladimir Zapolskiy <vz@mleia.com>, Zaibo Xu <xuzaibo@huawei.com>

Hi Eric,

> This series introduces a helper function crypto_shash_tfm_digest() which
> replaces the following common pattern:
> 
> 	{
> 		SHASH_DESC_ON_STACK(desc, tfm);
> 		int err;
> 
> 		desc->tfm = tfm;
> 
> 		err = crypto_shash_digest(desc, data, len, out);
> 
> 		shash_desc_zero(desc);
> 	}
> 
> with:
> 
> 	err = crypto_shash_tfm_digest(tfm, data, len, out);
> 
> Patch 1 introduces this helper function, and patches 2-20 convert all
> relevant users to use it.
> 
> IMO, it would be easiest to take all these patches through the crypto
> tree.  But taking just the "crypto:" ones and then me trying to get the
> rest merged later via subsystem trees is also an option.

I am fine if you take the net/bluetooth/smp.c change through the crypto tree.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel
