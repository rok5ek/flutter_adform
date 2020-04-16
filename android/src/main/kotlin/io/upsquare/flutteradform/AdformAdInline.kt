package io.upsquare.flutteradform

import android.content.Context
import android.view.View
import com.adform.sdk.pub.views.AdInline
import com.adform.sdk.utils.SmartAdSize
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.util.*

private const val RESUMED = "resumed"
private const val PAUSED = "paused"
private const val DETACHED = "detached"
private const val DISPOSE = "dispose"
private const val ARG_MASTER_TAG_ID = "masterTagId"
private const val ARG_WIDTH = "width"
private const val ARG_HEIGHT = "height"

class AdformAdInline(context: Context, messenger: BinaryMessenger, id: Int, args: HashMap<*, *>?) : PlatformView, MethodChannel.MethodCallHandler {
    private val channel: MethodChannel = MethodChannel(messenger, "${FlutterAdformPlugin.ADFORM_ADINLINE_VIEW_TYPE}_$id")
    private val adView: AdInline = AdInline(FlutterAdformPlugin.activity)

    init {
        channel.setMethodCallHandler(this)

        val width = args?.get(ARG_WIDTH) as Int?
        val height = args?.get(ARG_HEIGHT) as Int?
        adView.masterTagId = args?.get(ARG_MASTER_TAG_ID) as Int
        if (width != null && height != null) {
            adView.adSize = SmartAdSize(width, height)
        } else {
            adView.adSize = SmartAdSize()
        }
        adView.loadAd()
        adView.onResume()
    }

    override fun getView(): View {
        return adView
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            RESUMED -> adView.onResume()
            PAUSED -> adView.onPause()
            DETACHED -> adView.destroy()
            DISPOSE -> dispose()
            else -> result.notImplemented()
        }
    }

    override fun dispose() {
        adView.visibility = View.GONE
        adView.destroy()
        channel.setMethodCallHandler(null)
    }
}