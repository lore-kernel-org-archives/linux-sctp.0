From: Holger Hans Peter Freyther <holger@freyther.de>
Date: Fri, 14 Jan 2011 09:00:09 +0000
Subject: Re: [PATCH][RFC] Allow to use adler32 for SCTP
Message-Id: <4D301099.20707@freyther.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D2DC00A.8030208@freyther.de>
In-Reply-To: <4D2DC00A.8030208@freyther.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01/14/2011 02:25 AM, Wei Yongjun wrote:

> 
> decode both checksums by default will cause performance lost.
> Why not change this to kernel config, and disable it by default since
> most people do not need this?

Well, by default I am only checking the CRC32 checksum and have a test and a
branch for a global variable. So the question is what is the impact of the
extra load of the global variable?

Do you have a benchmark in mind? Something as simple as one connection and
sending messages between two machines? Or should I guard this whole config
with a kernel config right away?


> 
> Other question: why not just update your box which only support
> adler32 to support new crc32 checksums? Linux and Freebsd etc.
> do not using adler32, but using crc32.
> 

I wish I could, the machine is on the edge of the network and not in my control.
