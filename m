From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 23 Dec 2015 13:18:42 +0000
Subject: Re: [PATCH net] Revert "net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver'
Message-Id: <20151223131841.GA5440@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <567A499B.6020901@bahnhof.se>
In-Reply-To: <567A499B.6020901@bahnhof.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Hi,

On Wed, Dec 23, 2015 at 08:13:31AM +0100, Roger Nyberg wrote:
> Hi,
> 
> Is this fault corrected?
> “Fix a_rwnd/rwnd management to reflect real state of the receiver's buffer”
> http://www.spinics.net/lists/linux-sctp/msg03323.html

I don't think so.

> I can’t from the mail list find out if it is corrected in the “Revert "net:
> sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver's
> buffer"” correction, or if it remains unfixed.
> If unfixed, is there any plan or work ongoing for a correction?

Not that I'm aware of.

  Marcelo

> I have a customer case where my SCTP connection get stuck for ever with
> a_rwnd returning 0 size.
> 
> Best regards
> Roger Nyberg
> 
> 
> ---
> Detta e-postmeddelande har sökts igenom efter virus med antivirusprogram från Avast.
> https://www.avast.com/antivirus
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
