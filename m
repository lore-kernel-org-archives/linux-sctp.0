Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579533A9630
	for <linux-sctp@vger.kernel.org>; Thu, 24 Sep 2026 10:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244855; cv=none; b=tlK6xAwvkP+N6UrYbIJ3zCQBzkB6EZVFiAF/Gu3XuRKg9Fob8PEe6Dohmzj0qgHVQGTp+NJslpS4jt+EDPZVr5GdZQzJKGw1BoIC8z2a5TtW3crraliDQciWCYed0TZI0cQu659bmbujUHQ1HeWaGr1PovNFfLVTeNGqayHdbe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244855; c=relaxed/simple;
	bh=NN0e0g23jeBHX6DFaufsvruZGi8WnjPIpSL3GTO21Mw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E5S7dlfYQKcovJZDwXd8DQVvRk4QPiymwIeJ0RHWih0UYbkWBPY4lNLuP6S5PgwcJ1fbGeU9j4qbxvJyqrybBbeHaqY+puHPOL53EzO5FnSCBlznUtKSBm3ATEWC2nX6ifKEGI48WLRuDBSaMvNi2PDbqYFMz+ELxDb/ldGzXcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J84dTtYk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J84dTtYk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790244842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YxjUDCrVF3cPBepPW95UZ0ZG6+HKjGTnptEQIR9dc6M=;
	b=J84dTtYkU18ysRbnjBoKfLb5+57Kv594Vb9cm52iB8iHNTYlDXGr0NQpcrXXgUuBNo5Jbv
	ofAJ6FgtIfHosBouEaOhM1KREIFNbDl6/VbN4jpafz+CzeIQAF6RhJqLXIc13Z8nifYIcY
	HXCvlMoXmlBZILFp2QIXbsGmJqRdZ48=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-zLPEJahaNYmWNqJ9syNNBQ-1; Thu, 24 Sep 2026 06:14:00 -0400
X-MC-Unique: zLPEJahaNYmWNqJ9syNNBQ-1
X-Mimecast-MFC-AGG-ID: zLPEJahaNYmWNqJ9syNNBQ_1790244840
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49fe40db0e0so9903705e9.0
        for <linux-sctp@vger.kernel.org>; Thu, 24 Sep 2026 03:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790244839; x=1790849639;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YxjUDCrVF3cPBepPW95UZ0ZG6+HKjGTnptEQIR9dc6M=;
        b=Fr8T+Z5X/iiaYgf6go40NDizUUgk63pt3ua8pwn9w72vPwBDxDGPQxdkGBDsoU0lVj
         OEglX7DjFjnh3PPjZgoEqsDojnSnBJJMpZpnM8Twdw213ZHuYiwSvtNBW8bTZuWWkTBy
         0NbDaiVZOrpezhkUOX/obSnjR7Nc5EBHGMDQ+xLK1ZvJzIJrjcbux13qVu2WzmhhssxX
         RNT3UF0nCqENte2XHdXSNZWGDWBiNfuBWbRkaINo+YoGs5154J6nLSX76CvdNA9WIGXq
         hLvrOkp6Ij/S+7RZXEK2LYVwkpM477Azz1UesLp6DDGbgqeYVWCtrH9x1vmpwsbeI2nm
         S7nw==
X-Gm-Message-State: AFuF++loDUYKh1Blfamwas79XmzvlhqFdthAzgEgzqa0/25QSspdcHKD
	bCOxaHuxe46nBh3bWBbPe8tdgFEdUQ3Hw+T01RTSByH3aYLEwMqc6IxjbjHovfLdKht/2g6w8SN
	Pl+CY5ZNPVsIJfFoVCOwPasg7VG5opU9JPV0PuZgJHfx6CJ/iqgWdjvG8HHqrJtM=
X-Gm-Gg: AYBFou0+dWX6dszLZ44NQdSfas+9kreChhWZz0EY0RA++oXO0ZS1zmLA7Rj53j/kO9w
	IFUH/n3sE60g1CVkCnqoYgfgrZ4IsLpFsohmJoitU+/Dvi0z2ELEhTOpU1oB0UZA5sZJI5V4UOD
	5KuwLw1WQqtpAvOWX0jILbi8pljVdeP82FeoKYQRfkCY60+JnHKzYAvEHP1KoU2MOzjBI2QJNHp
	9o+LCwWNzo+3pbROW2ZniGG7Tux6cUvd9EOlvvT0aduI7Nx352F/nUb3i8VmzMguNQvXCke6+Oy
	dysyURQOPVxJuybA6QmemJ1/kPvUNqeqg4Gjh9SO3oQaWPlFJkUkuZYAuAumHAb7xMmZL4tHLk7
	EEGGgBIxiCs+EH7bxzXtYHjTqQv47juksKpNO3uZWopUPMWU8+hcOwDfc9GwXRpOVtuJ5FrTwrg
	==
X-Received: by 2002:a05:600c:870c:b0:49e:6050:9fbe with SMTP id 5b1f17b1804b1-49fe66d76camr33596605e9.15.1790244839525;
        Thu, 24 Sep 2026 03:13:59 -0700 (PDT)
X-Received: by 2002:a05:600c:870c:b0:49e:6050:9fbe with SMTP id 5b1f17b1804b1-49fe66d76camr33596255e9.15.1790244839132;
        Thu, 24 Sep 2026 03:13:59 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c5b646sm53445335e9.4.2026.09.24.03.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 03:13:57 -0700 (PDT)
Message-ID: <4745a390-6859-4a5e-8ee1-ab9634b3bc10@redhat.com>
Date: Thu, 24 Sep 2026 12:13:56 +0200
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sctp: copy zeroed stats to user in
 sctp_getsockopt_pr_streamstatus() when !streamoute
To: Hui Peng <benquike@gmail.com>, marcelo.leitner@gmail.com,
 lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260919213634.3314055-1-benquike@gmail.com>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260919213634.3314055-1-benquike@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qU-hGbLWP2AvWuFyhEB4k6ydfI4m18yS_01RoD3zxXk_1790244840
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/26 23:36, Hui Peng wrote:
> @@ -7589,6 +7585,8 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
>   			streamoute->abandoned_sent[__SCTP_PR_INDEX(policy)];
>   	}
>   
> +	retval = 0;
> +

AFAICS the above is not needed; retval will be zeroed later, if in case of
no errors.

Also this is IMHO net-next material with no fixes tag.

/P

