From: Qiujun Huang <hqjagain@gmail.com>
Date: Mon, 16 Mar 2020 06:59:43 +0000
Subject: [PATCH] drm/lease: fix potential race in fill_object_idr
Message-Id: <1584341983-11245-1-git-send-email-hqjagain@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>

We should hold idr_mutex for idr_alloc.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 drivers/gpu/drm/drm_lease.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index b481caf..427ee21 100644
--- a/drivers/gpu/drm/drm_lease.c
+++ b/drivers/gpu/drm/drm_lease.c
@@ -418,6 +418,7 @@ static int fill_object_idr(struct drm_device *dev,
 		goto out_free_objects;
 	}
 
+	mutex_lock(&dev->mode_config.idr_mutex);
 	/* add their IDs to the lease request - taking into account
 	   universal planes */
 	for (o = 0; o < object_count; o++) {
@@ -437,7 +438,7 @@ static int fill_object_idr(struct drm_device *dev,
 		if (ret < 0) {
 			DRM_DEBUG_LEASE("Object %d cannot be inserted into leases (%d)\n",
 					object_id, ret);
-			goto out_free_objects;
+			goto out_unlock;
 		}
 		if (obj->type = DRM_MODE_OBJECT_CRTC && !universal_planes) {
 			struct drm_crtc *crtc = obj_to_crtc(obj);
@@ -445,20 +446,22 @@ static int fill_object_idr(struct drm_device *dev,
 			if (ret < 0) {
 				DRM_DEBUG_LEASE("Object primary plane %d cannot be inserted into leases (%d)\n",
 						object_id, ret);
-				goto out_free_objects;
+				goto out_unlock;
 			}
 			if (crtc->cursor) {
 				ret = idr_alloc(leases, &drm_lease_idr_object, crtc->cursor->base.id, crtc->cursor->base.id + 1, GFP_KERNEL);
 				if (ret < 0) {
 					DRM_DEBUG_LEASE("Object cursor plane %d cannot be inserted into leases (%d)\n",
 							object_id, ret);
-					goto out_free_objects;
+					goto out_unlock;
 				}
 			}
 		}
 	}
 
 	ret = 0;
+out_unlock:
+	mutex_unlock(&dev->mode_config.idr_mutex);
 out_free_objects:
 	for (o = 0; o < object_count; o++) {
 		if (objects[o])
-- 
1.8.3.1
