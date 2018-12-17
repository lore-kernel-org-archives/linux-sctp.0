From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 17 Dec 2018 20:50:01 +0000
Subject: Re: [PATCH 6/7] sctp: Convert to genradix
Message-Id: <20181217125001.8e89ac2565417d55ef7a624e@linux-foundation.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181217131929.11727-1-kent.overstreet@gmail.com>
        <20181217131929.11727-7-kent.overstreet@gmail.com>
In-Reply-To: <20181217131929.11727-7-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org

On Mon, 17 Dec 2018 08:19:28 -0500 Kent Overstreet <kent.overstreet@gmail.com> wrote:

> @@ -535,9 +470,6 @@ int sctp_send_add_streams(struct sctp_association *asoc,
>  		goto out;
>  	}
>  
> -	stream->incnt = incnt;
> -	stream->outcnt = outcnt;
> -
>  	asoc->strreset_outstanding = !!out + !!in;
>  

I'm seeing a reject here for some reason.  Using todays's linux-next,
but there are no changes against net/sctp/stream.c in -next.  The
assignment to stream->incnt has disappeared.  I did this:

@@ -535,8 +470,6 @@ int sctp_send_add_streams(struct sctp_as
 		goto out;
 	}
 
-	stream->outcnt = outcnt;
-
 	asoc->strreset_outstanding = !!out + !!in;
 
 out:


We're at 4.20-rc7 and this series is rather large.  I'll merge them all
to see what happens, but I don't think it's 4.21-rc1 material?
