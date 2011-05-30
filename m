From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 30 May 2011 03:25:38 +0000
Subject: Re: [Question] Demo apps myftp
Message-Id: <4DE30E32.6090706@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DE10A38.6000908@gmail.com>
In-Reply-To: <4DE10A38.6000908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

In code myftp.c, function command_recv. If filename to save =NULL, fd=1
>
> if ( filename = NULL ) fd = 1;
>     else if ( (fd = open(filename,O_WRONLY|O_CREAT|O_TRUNC,S_IREAD|S_IWRITE)) = -1 )
>
> When if receiver file ,Where is this endpoint will save file?
> I am trying send file 300MB, but it slow (than 2 hours).And I don't know where myftp save this file.


fd = 1 means that file is output to stdout.


> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
