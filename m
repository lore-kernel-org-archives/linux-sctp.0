From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 30 Jun 2015 17:38:04 +0000
Subject: Re: Clean up messages for a particular stream
Message-Id: <20150630173804.GA1943@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAyB5c+_yBxrer7tA5a69E+-0nsZRCqLV4+MVHEAP_Ppg49whg@mail.gmail.com>
In-Reply-To: <CAAyB5c+_yBxrer7tA5a69E+-0nsZRCqLV4+MVHEAP_Ppg49whg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

In-Reply-To: <CAAyB5c+_yBxrer7tA5a69E+-0nsZRCqLV4+MVHEAP_Ppg49whg@mail.gmail.com>

On Tue, Jun 30, 2015 at 09:56:50AM -0700, Jerry Jerry wrote:
>  Hello everyone,
> 
> We currently encounter an issue where we re-use the streams in a SCTP
> connection. However, data from different message contexts may co-exist
> in the send/recv buffers for that reused stream. I'm wondering if
> there is any special API that allow us to flush the data for just one
> particular stream in a SCTP connection just before we reuse it, or we
> have to do this from application?
> 
> I've been searching but were unable to find a good answer yet. Your
> advices would be greatly appreciated!

In short, no.. you have to do it in your application.

If you're using unordered delivery, I'm afraid that clean cut is just
not possible at all as there will always be the chance of a late packet
getting delivered. That is, unless you add a layer abstracting that,
like a substream id or something like that...

And if you're using ordered delivery, it would mean to close/re-open a
stream or a signaling for such event, but those operations don't exist.

  Marcelo
